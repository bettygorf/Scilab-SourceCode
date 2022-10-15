#include <stdio.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Label.h>

#include "metawin.h"
#include "graphics.h"

#define STRLEN 1000

static int okFlag;
static int yesOrNo;

void AlertOk(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  XtPopdown((Widget)shell);
  okFlag = 1;
}

void MetanetAlert(format,a1,a2,a3,a4,a5,a6,a7)
char *format;
{
  XEvent event;
  Widget Alert;
  Arg args[10];
  int iargs = 0;
  Widget shell;
  XtCallbackRec callbacks[2];
  XWindowAttributes war;
  int h,w;
  char description[STRLEN];

  sprintf(description,format,a1,a2,a3,a4,a5,a6,a7);

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;
  
  XGetWindowAttributes(theG.dpy,XtWindow(toplevel),&war);
  h = war.height; w = war.width;

  XtSetArg(args[iargs], XtNx, w/2); iargs++;
  XtSetArg(args[iargs], XtNy, h/2); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  shell = XtCreatePopupShell("Metanet Alert",transientShellWidgetClass,
			     toplevel,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  Alert = XtCreateManagedWidget("Alert",boxWidgetClass,shell,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, description); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 0); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("labelAlert",labelWidgetClass,Alert,args,iargs);

  callbacks[0].callback = AlertOk;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "ok" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("Alertcommand",commandWidgetClass,
			Alert,args,iargs);

  XtPopup(shell,XtGrabExclusive);
  
  okFlag = 0;
  while (!okFlag) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
  }
  XtDestroyWidget(shell);
}

void AlertYes(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  XtPopdown((Widget)shell);
  yesOrNo = 1;
  okFlag = 1;
}

void AlertNo(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  XtPopdown((Widget)shell);
  yesOrNo = 0;
  okFlag = 1;
}

int MetanetYesOrNo(format,a1,a2,a3,a4,a5,a6,a7)
char *format;
{
  XEvent event;
  Widget Alert;
  Arg args[10];
  int iargs = 0;
  Widget shell;
  XtCallbackRec callbacks[2];
  char description[STRLEN];
  int h,w;
  XWindowAttributes war;
  sprintf(description,format,a1,a2,a3,a4,a5,a6,a7);

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;
  
  XGetWindowAttributes(theG.dpy,XtWindow(toplevel),&war);
  h = war.height; w = war.width;

  XtSetArg(args[iargs], XtNx, w/2); iargs++;
  XtSetArg(args[iargs], XtNy, h/2); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  shell = XtCreatePopupShell("Metanet Alert",transientShellWidgetClass,
			     toplevel,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  Alert = XtCreateManagedWidget("Alert",boxWidgetClass,shell,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, description); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 0); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("labelAlert",labelWidgetClass,Alert,args,iargs);

  callbacks[0].callback = AlertYes;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "yes" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("yescommand",commandWidgetClass,Alert,args,iargs);

  callbacks[0].callback = AlertNo;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "no" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("nocommand",commandWidgetClass,Alert,args,iargs);

  XtPopup(shell,XtGrabExclusive);

  okFlag = 0;
  while (!okFlag) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
  }
  XtDestroyWidget(shell);

  return yesOrNo;
}
