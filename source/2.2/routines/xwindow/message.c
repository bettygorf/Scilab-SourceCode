#include "scilab_d.h"

#define OK 1
#define CANCEL 2

extern int ok_Flag_sci;

extern void ShellFormCreate();
static void MessageOk();
static void MessageCancel();
void ExposeMessageWindow();

/* main function called from scilab */

void C2F(xmsg)(basstrings,nstring,ptrstrings,btn,ptrbtn,nb,nrep,ierr)
int *basstrings,*nstring,*ptrstrings,*btn,*nb,*ptrbtn,*nrep,*ierr;
{
  int i;
  char *strings, **buttonname;
  *ierr=0;
  ScilabMStr2C(basstrings,nstring,ptrstrings,&strings,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(btn,nb,ptrbtn,&buttonname,ierr);
  if ( *ierr == 1) return;
  ExposeMessageWindow(strings,nstring,buttonname,nb);
  FREE(strings);
  for (i=0 ; i < *nb ; i++ )FREE(buttonname[i]);
  FREE( buttonname);
  *nrep=ok_Flag_sci;
}

/*test function */

TestMessage()
{
  static String description = "Message \ntest";
  static String buttonname[] = {
        "Label1",
	"Label2",
	NULL
    };
  static nstrings=1; /* unused */
  static nbut=2;
  ExposeMessageWindow(description,&nstrings,buttonname,&nbut);
}



static 
void MessageOk(w,shell,callData)
     Widget w;
     caddr_t shell;
     caddr_t callData;
{
  ok_Flag_sci = OK;
}

static 
void MessageCancel(w,shell,callData)
     Widget w;
     caddr_t shell;
     caddr_t callData;
{
  ok_Flag_sci = CANCEL;
}

void ExposeMessageWindow(string,nstring,buttonname,nbutton)
     char *string;
     int *nstring;
     int *nbutton;
     char **buttonname;
{
  Arg args[10];
  Cardinal iargs = 0;
  Widget shell,dialog,mpanned,mviewport,okbutton,cancelbutton,cform;
  static Display *dpy = (Display *) NULL;

  ShellFormCreate("messageShell",&shell,&mpanned,&dpy);

  /* Create a Viewport+Label and resize it */
  ViewpLabelCreate(mpanned,&dialog,&mviewport,string);
  /* The buttons */

  iargs=0;
  cform = XtCreateManagedWidget("cform",formWidgetClass,mpanned,args,iargs);

  ButtonCreate(cform,&okbutton,(XtCallbackProc)MessageOk,(XtPointer) NULL,buttonname[0],"ok");
  if ( *nbutton == 2) 
    {
      ButtonCreate(cform,&cancelbutton,(XtCallbackProc)MessageCancel,(XtPointer) NULL,buttonname[1],"cancel");
    }
  XtMyLoop(shell,dpy);
}










