#include "scilab_d.h"

#define NOCHOOSE 0
#define CHOOSE 1
#define CANCEL 2

extern void ShellFormCreate();
extern int ok_Flag_sci;
extern  void C2F(cvstr)();

void    ExposeChooseWindow();
static  int numChoix ;
static  void CancelChoose();
static  void DoChoose();

/* Interface with a Scilab ``structure'' */

void C2F(xchoose)(desc,ptrdesc,nd,basstrings,nstring,ptrstrings,btn,ptrbtn,nb,nrep,ierr)
     int *desc,*ptrdesc,*nd,*basstrings,*nstring,*ptrstrings,*btn,*nb,*ptrbtn,*nrep,*ierr;
{ 

  int i;
  char **strings, *description,**buttonname;
  *ierr=0;
  ScilabMStr2C(desc,nd,ptrdesc,&description,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(btn,nb,ptrbtn,&buttonname,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(basstrings,nstring,ptrstrings,&strings,ierr);
  ExposeChooseWindow(strings,nstring,description,buttonname);
  for (i=0 ; i < *nstring ; i++ ) FREE(strings[i]);
  FREE(strings); 
  FREE(description);
  for (i=0 ; i < *nb ; i++ )FREE(buttonname[i]);
  FREE(buttonname);
  if ( ok_Flag_sci == CHOOSE) 
    *nrep=(1+numChoix);
  else *nrep=0;
}

/* test function */

TestChoose()
{
  static String description1 = "Choose \ntest";
  static String strings[] = {
	"first list entry",
	"second list entry",
	"third list entry",
	"fourth list entry",
	NULL
    };
  static String buttonname[] = {
        "Label1",
	"Label2",
	NULL
    };
  static nstrings=4;
  ExposeChooseWindow(strings,&nstrings,description1,buttonname);
}

/* The cancel command callback */

static void CancelChoose(w,shell,callData)
     Widget w;
     caddr_t shell,callData;
{
  ok_Flag_sci = CANCEL;
}

/* The choose command callback */

static void DoChoose(widget,shell,callData)
     Widget widget;
     caddr_t shell,callData;
{
  XawListReturnStruct* item;
  item = (XawListReturnStruct*)callData;
  numChoix = item->list_index ;
  ok_Flag_sci = CHOOSE;
}


void  ExposeChooseWindow(strings,ns,description,buttonname)
     char **strings;
     char *description;
     char **buttonname;
     int *ns;
{
  Widget choosepanned,wid,list,shell,chooseviewport,chooselabel,labelviewport,cform;
  Arg args[10];
  Cardinal iargs = 0;
  static Display *dpy = (Display *) NULL;

  ShellFormCreate("chooseShell",&shell,&choosepanned,&dpy);
  
  /* Create a Viewport+Label and resize it */

  ViewpLabelCreate(choosepanned,&chooselabel,&labelviewport,description);

  /* Create a Viewport+List and resize it */
  
  ViewpListCreate(choosepanned,&list,&chooseviewport,strings,*ns);

  XtAddCallback(list, XtNcallback,(XtCallbackProc)DoChoose ,(XtPointer) NULL); 

  /* Create a button */

  iargs=0;
  cform = XtCreateManagedWidget("cform",formWidgetClass,choosepanned,args,iargs);

  ButtonCreate(cform,&wid,(XtCallbackProc) CancelChoose,(XtPointer) NULL,
	       buttonname[0],"cancel");

  /* X11 Loop */

  XtMyLoop(shell,dpy);
}

