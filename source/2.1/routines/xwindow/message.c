#include "scilab_d.h"
#include "../machine.h"

void C2F(xmsg)(basstrings,nstring,ptrstrings,ierr)
int *basstrings,*nstring,*ptrstrings,*ierr;
{
  void C2F(cvstr)(), ExposeMessageWindow();
  char *strings;
  *ierr=0;
  ScilabMStr2C(basstrings,nstring,ptrstrings,&strings,ierr);
  if ( *ierr == 1) return;
  ExposeMessageWindow(strings,nstring);
  free(strings);
}

static Widget toplevel;
extern XtAppContext app_con;
extern int ok_Flag_sci;

void MessageOk(w,shell,callData)
     Widget w;
     caddr_t shell;
     caddr_t callData;
{
  ok_Flag_sci = 1;
}


void ExposeMessageWindow(string,nstring)
     char *string;
     int *nstring;
{
  Widget shell,dialog;
  Arg args[1];
  int iargs = 0;
  static Display *dpy = (Display *) NULL;
  DisplayInit("",&dpy,&toplevel);

  shell = XtCreatePopupShell("messageShell",transientShellWidgetClass,toplevel,
			     args,iargs);
  XtSetArg(args[0],XtNlabel,string);  iargs++;
  dialog = XtCreateManagedWidget("messageDialog",dialogWidgetClass,shell,
				 args,iargs);
  XawDialogAddButton(dialog,"messageButton",
		     (XtCallbackProc)MessageOk,NULL);
  XtMyLoop(shell,dpy);
}




