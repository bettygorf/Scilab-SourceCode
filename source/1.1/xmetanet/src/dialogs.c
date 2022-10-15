#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Dialog.h>
#include <X11/Xaw/Label.h>

#include "metawin.h"
#include "graphics.h"

#define MAXDIALOG 20

static int okFlag;
static char *str[MAXDIALOG];
static Widget dialog[MAXDIALOG];
static int nDialog;

void DialogsOk(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  int i;
  for (i = 0; i < nDialog; i++)
    strcpy(str[i],XawDialogGetValueString(dialog[i]));
  XtPopdown((Widget)shell);
  okFlag = 1;
}


/* MetanetDialogs returns 1 if something has been modified, 0 otherwise */

int MetanetDialogs(n,valueinit,result,description,label)
int n;
char *valueinit[], *result[], *description[], *label;
{
  XEvent event;
  Arg args[10];
  int iargs = 0;
  Widget shell, box;
  XtCallbackRec callbacks[2];
  int i;
  XWindowAttributes war;
  int h,w;
  char *calloc();

  nDialog = n;

  for (i = 0; i < n; i++) {
    str[i] = calloc(256,sizeof(char));
  }

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
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  box = XtCreateManagedWidget("dialogbox",boxWidgetClass,shell,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, label); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 0); iargs++;
  XtCreateManagedWidget("dialoglabel",labelWidgetClass,box,args,iargs);

  for (i = 0; i < n; i++) {
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, description[i]); iargs++;
    XtSetArg(args[iargs], XtNvalue, valueinit[i]); iargs++;
    XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
    dialog[i] = XtCreateManagedWidget("dialog",dialogWidgetClass,
				      box,args,iargs);
  }

  callbacks[0].callback = DialogsOk;
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

  for (i = 0; i < n; i++)
    strcpy(result[i],str[i]);

  for (i = 0; i < n; i++)
    if (strcmp(str[i],valueinit[i]) != 0)
      return 1;

  return 0;
}
