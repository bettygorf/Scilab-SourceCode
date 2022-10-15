#include "scilab_d.h"
#include "../machine.h"

#define NOCHOOSE 0
#define CHOOSE 1
#define CANCEL 2
#define X 147
#define Y 33

static  Widget toplevel;
extern XtAppContext app_con;
extern int ok_Flag_sci;
static int numChoix ;

static void CancelChoose(w,shell,callData)
     Widget w;
     caddr_t shell,callData;
{
  ok_Flag_sci = CANCEL;
}

static void DoChoose(widget,shell,callData)
     Widget widget;
     caddr_t shell,callData;
{
  XawListReturnStruct* item;
  item = (XawListReturnStruct*)callData;
  numChoix = item->list_index ;
  ok_Flag_sci = CHOOSE;
}



void  ExposeChooseWindow(strings,description,buttonname)
     char **strings;
     char *description;
     char **buttonname;
{
    Widget chooseform,wid,list,shell,chooseviewport,chooselabel;
    Arg args[10];
    int iargs = 0;
    int width,i,temp_height;
    XFontStruct *temp_font;
    static Display *dpy = (Display *) NULL;

    DisplayInit("",&dpy,&toplevel);
    shell = XtCreatePopupShell("chooseShell",transientShellWidgetClass,toplevel, args,iargs);
    chooseform = XtCreateManagedWidget("chooseForm",formWidgetClass,shell,(Arg *) NULL,(int)ZERO);
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, description); iargs++;
    chooselabel = XtCreateManagedWidget("chooseLabel",labelWidgetClass,chooseform,args,iargs);
    iargs = 0;
    chooseviewport = XtCreateManagedWidget("chooseViewport",viewportWidgetClass,chooseform,args,iargs);
    iargs = 0;
    XtSetArg(args[iargs], XtNlist, strings); iargs++;
    list=XtCreateManagedWidget("chooseList",listWidgetClass,chooseviewport,args,iargs);
    XtAddCallback(list, XtNcallback,(XtCallbackProc)DoChoose , NULL);  
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, buttonname[0]); iargs++;
    wid=XtCreateManagedWidget("cancelCommand",commandWidgetClass,chooseform,args,iargs);
    XtAddCallback(wid, XtNcallback,(XtCallbackProc)CancelChoose , NULL);  
    XtMyLoop(shell,dpy);
}

void C2F(xchoose)(desc,ptrdesc,nd,basstrings,nstring,ptrstrings,btn,ptrbtn,nb,nrep,ierr)
     int *desc,*ptrdesc,*nd,*basstrings,*nstring,*ptrstrings,*btn,*nb,*ptrbtn,*nrep,*ierr;
{ 
  void C2F(cvstr)(), ExposeChooseWindow();
  int i;
  char **strings, *description,**buttonname;
  *ierr=0;
  ScilabMStr2C(desc,nd,ptrdesc,&description,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(btn,nb,ptrbtn,&buttonname,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(basstrings,nstring,ptrstrings,&strings,ierr);
  ExposeChooseWindow(strings,description,buttonname);
  for (i=0 ; i < *nstring ; i++ ) free((char*)strings[i]);
  free((char*)strings); 
  free(description);
  for (i=0 ; i < *nb ; i++ )free((char*)buttonname[i]);
  free(buttonname);
  if ( ok_Flag_sci == CHOOSE) 
    *nrep=(1+numChoix);
  else *nrep=0;
}

