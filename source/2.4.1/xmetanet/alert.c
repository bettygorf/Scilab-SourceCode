/* Copyright INRIA */
#include <stdio.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Label.h>

#include "metaconst.h"
#include "metawin.h"
#include "graphics.h"

extern void GetMetanetGeometry();

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

void MetanetAlert(description)
char *description;
{
  XEvent event;
  Widget Alert;
  Arg args[10];
  int iargs = 0;
  Widget shell;
  XtCallbackRec callbacks[2];
  int x,y,w,h;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;
  
  GetMetanetGeometry(&x,&y,&w,&h);

  XtSetArg(args[iargs], XtNx, x + incX); iargs++;
  XtSetArg(args[iargs], XtNy, y + incY); iargs++;
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

  callbacks[0].callback = (XtCallbackProc)AlertOk;
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

int MetanetYesOrNo(description)
char *description;
{
  XEvent event;
  Widget Alert;
  Arg args[10];
  int iargs = 0;
  Widget shell;
  XtCallbackRec callbacks[2];
  int x,y,w,h;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;
  
  GetMetanetGeometry(&x,&y,&w,&h);

  XtSetArg(args[iargs], XtNx, x + incX); iargs++;
  XtSetArg(args[iargs], XtNy, y + incY); iargs++;
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

  callbacks[0].callback = (XtCallbackProc)AlertYes;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "yes" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("yescommand",commandWidgetClass,Alert,args,iargs);

  callbacks[0].callback = (XtCallbackProc)AlertNo;
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
