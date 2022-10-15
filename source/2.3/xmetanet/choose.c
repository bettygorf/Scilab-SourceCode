#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/List.h>
#include <X11/Xaw/Viewport.h>
#include <X11/Xaw/Form.h>

#include "metaconst.h"
#include "metawin.h"
#include "graphics.h"

extern void GetMetanetGeometry();

static int okFlag;
static char str[256];

#define max(a,b) ((a) > (b) ? (a) : (b))

#define NOCHOOSE 0
#define CHOOSE 1
#define CANCEL 2

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
  Widget chooseform,chooseport,chooselabel;
  Arg args[10];
  int iargs = 0;
  XtCallbackRec callbacks[2];
  Widget shell;
  int i,width;
  int x,y,w,h;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  GetMetanetGeometry(&x,&y,&w,&h);
  
  XtSetArg(args[iargs], XtNx, x + incX); iargs++;
  XtSetArg(args[iargs], XtNy, y + incY); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  shell = XtCreatePopupShell("Metanet Choose",
			     transientShellWidgetClass,toplevel,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  chooseform = XtCreateManagedWidget("chooseform",formWidgetClass,
				    shell,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, description); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 0); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  XtSetArg(args[iargs], XtNfromVert, NULL); iargs++;
  XtSetArg(args[iargs], XtNbottom, XtChainTop); iargs++;
  chooselabel = XtCreateManagedWidget("labelchoose",labelWidgetClass,
				      chooseform,args,iargs);

  callbacks[0].callback = (XtCallbackProc)CancelChoose;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "cancel" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, chooselabel); iargs++;
  XtSetArg(args[iargs], XtNfromVert, NULL); iargs++;
  XtSetArg(args[iargs], XtNbottom, XtChainTop); iargs++;
  XtCreateManagedWidget("cancelcommand",commandWidgetClass,
			chooseform,args,iargs);

  width = 0; i = 0;
  while(strings[i] != NULL) {
    width = max(width,
		XTextWidth(theG.metafont,strings[i],strlen(strings[i])));
    i++;
  }
  width = width + 25;
  
  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNallowVert, TRUE); iargs++;
  XtSetArg(args[iargs], XtNwidth, width); iargs++;
  XtSetArg(args[iargs], XtNheight, metaHeight/2); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  XtSetArg(args[iargs], XtNfromVert, chooselabel); iargs++;
  XtSetArg(args[iargs], XtNtop, XtChainTop); iargs++;
  chooseport = XtCreateManagedWidget("chooseport",viewportWidgetClass,
				    chooseform,args,iargs);

  callbacks[0].callback = (XtCallbackProc)DoChoose;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
    XtSetArg(args[iargs], XtNlist, strings); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNdefaultColumns, 1); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;

  XtCreateManagedWidget("choose",listWidgetClass,chooseport,args,iargs);

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
