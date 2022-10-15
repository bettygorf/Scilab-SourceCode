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
  ExposeMessageWindow(strings);
  free(strings);
}


extern Widget toplevel;
extern XtAppContext app_con;
extern int ok_Flag_sci;



#define X 147
#define Y 33

void MessageOk(w,shell,callData)
     Widget w;
     caddr_t shell;
     caddr_t callData;
{
  ok_Flag_sci = 1;
}

void ExposeMessageWindow(string)
     char *string;
{
  Widget message,okbutton,shell;
  Arg args[10];
  int iargs = 0;
  XtSetArg(args[iargs], XtNx, X + 10); iargs++;
  XtSetArg(args[iargs], XtNy, Y + DIALOGHEIGHT + 10); iargs++;
  XtSetArg(args[iargs], XtNallowShellResize, True); iargs++;
  shell = XtCreatePopupShell("messageshell",transientShellWidgetClass,toplevel,
			     args,iargs);
  iargs = 0;
  message = XtCreateManagedWidget("message",boxWidgetClass,shell,args,iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "OK" ); iargs++;
  okbutton=XtCreateManagedWidget("messagecommand",commandWidgetClass,

			message,args,iargs);
  XtAddCallback(okbutton, XtNcallback,MessageOk , NULL);  
  iargs=0;
  XtSetArg(args[iargs], XtNlabel,  string); iargs++; 
  XtCreateManagedWidget("labelmessage",labelWidgetClass,message,args,
			iargs);
  XtMyLoop(shell);
}


