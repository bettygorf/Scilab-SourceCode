#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/List.h>

#include "metawin.h"
#include "graphics.h"

static int okFlag;
static char str[256];

#define NOCHOOSE 0
#define CHOOSE 1
#define CANCEL 2
#define CHOOSEHEIGHT 40

void CancelChoose(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  XtPopdown((Widget)shell);
  okFlag = CANCEL;
}

void DoChoose(widget,shell,callData)
Widget widget;
caddr_t shell;
caddr_t callData;
{
  XawListReturnStruct *item;
  item = (XawListReturnStruct*)callData;
  strcpy(str,item->string);
  XtPopdown((Widget)shell);
  okFlag = CHOOSE;
}

int MetanetChoose(description,strings,result)
char *description;
char *strings[];
char *result;
{
  XEvent event;
  Widget choosebox;
  Arg args[10];
  int iargs = 0;
  XtCallbackRec callbacks[2];
  Widget shell;
  XWindowAttributes war;
  int w;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;
  
  XGetWindowAttributes(theG.dpy,XtWindow(toplevel),&war);
  w = war.width;

  XtSetArg(args[iargs], XtNx, w/2); iargs++;
  XtSetArg(args[iargs], XtNy, CHOOSEHEIGHT); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  shell = XtCreatePopupShell("Metanet Choose",
			     transientShellWidgetClass,toplevel,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  choosebox = XtCreateManagedWidget("choosebox",boxWidgetClass,
				    shell,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, description); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 0); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("labelchoose",labelWidgetClass,choosebox,args,iargs);

  callbacks[0].callback = DoChoose;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlist, strings); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNcolumnSpacing, 0); iargs++;
  XtSetArg(args[iargs], XtNdefaultColumns, 1); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("choose",listWidgetClass,choosebox,args,iargs);

  callbacks[0].callback = CancelChoose;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "cancel" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("cancelcommand",commandWidgetClass,
			choosebox,args,iargs);

  XtPopup(shell,XtGrabExclusive);
  
  theG.shell = shell;

  okFlag = NOCHOOSE;
  while (okFlag == NOCHOOSE) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
  }
  XtDestroyWidget(shell);

  switch (okFlag) {
  case CHOOSE:
    theG.shell = NULL;
    strcpy(result,str);
    return 1;
    break;
  case CANCEL:
    theG.shell = NULL;   
    return 0;
    break;
  }
}
