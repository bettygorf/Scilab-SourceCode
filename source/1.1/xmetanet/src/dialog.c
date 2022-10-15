#include <stdio.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Dialog.h>

#include "metawin.h"
#include "graphics.h"

#define STRLEN 1000

static int okFlag;
static char str[256];
static Widget dialog;

void DialogOk(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  strcpy(str,XawDialogGetValueString(dialog));
  XtPopdown((Widget)shell);
  okFlag = 1;
}

int MetanetDialog(valueinit,result,format,a1,a2,a3,a4,a5,a6,a7)
char *valueinit, *result, *format;
{
  XEvent event;
  Arg args[10];
  int iargs = 0;
  Widget shell, box;
  XtCallbackRec callbacks[2];
  char description[STRLEN];
  XWindowAttributes war;
  int h,w;
  
  sprintf(description,format,a1,a2,a3,a4,a5,a6,a7);

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  XGetWindowAttributes(theG.dpy,XtWindow(toplevel),&war);
  h = war.height; w = war.width;
  
  XtSetArg(args[iargs], XtNx, w/2); iargs++;
  XtSetArg(args[iargs], XtNy, h/2); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  shell = XtCreatePopupShell("Metanet Dialog",transientShellWidgetClass,
			     toplevel,args,iargs);

  iargs = 0;
  box =  XtCreateManagedWidget("box",boxWidgetClass,shell,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, description); iargs++;
  XtSetArg(args[iargs], XtNvalue, valueinit); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  dialog = XtCreateManagedWidget("dialog",dialogWidgetClass,box,args,iargs);

  callbacks[0].callback = DialogOk;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "ok" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("dialogcommand",commandWidgetClass,box,args,iargs);

  XtPopup(shell,XtGrabExclusive);

  okFlag = 0;
  while (!okFlag) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
  }
  XtDestroyWidget(shell);

  strcpy(result,str);
  return strlen(result);
}
