#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Dialog.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/Viewport.h>

#include <malloc.h>
#include <stdio.h>

#include "metaconst.h"
#include "metawin.h"
#include "graphics.h"

#define MAXDIALOG 20
#define DIALOGSHEIGHT 800

extern void GetMetanetGeometry();

extern int dpyHeight;

static int dialogsFlag;
static char *strs[MAXDIALOG];
static Widget dialogs[MAXDIALOG];
static int nDialog;

#define STRLEN 1024

#define max(a,b) ((a) > (b) ? (a) : (b))

static int dialogFlag;
static char str[STRLEN];
static Widget dialog;

static Widget theShell;

#define OK 1
#define CANCEL 2

static int dialogType;
#define DIALOG 1
#define DIALOGS 2

/* Return action */

void ActionWhenReturn(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  int i;
  switch (dialogType) {
  case DIALOG:
    strcpy(str,XawDialogGetValueString(dialog));
    XtPopdown((Widget)theShell);
    dialogFlag = OK;  
    break;
  case DIALOGS:
    for (i = 0; i < nDialog; i++)
      strcpy(strs[i],XawDialogGetValueString(dialogs[i]));
    XtPopdown((Widget)theShell);
    dialogsFlag = OK;
    break;
  }
}

/* METANET DIALOG */

void DialogOk(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  strcpy(str,XawDialogGetValueString(dialog));
  XtPopdown((Widget)shell);
  dialogFlag = OK;
}

void DialogCancel(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  XtPopdown((Widget)shell);
  dialogFlag = CANCEL;
}

int MetanetDialog(valueinit,result,description)
char *valueinit, *result, *description;
{
  XEvent event;
  Arg args[10];
  int iargs = 0;
  Widget form, ok;
  XtCallbackRec callbacks[2];
  int x,y,w,h;
  
  static char translations[] =
    "<Key>Return: ActionWhenReturn()";
  XtTranslations compiled_translation_table;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  dialogType = DIALOG;

  GetMetanetGeometry(&x,&y,&w,&h);
  
  XtSetArg(args[iargs], XtNx, x + incX); iargs++;
  XtSetArg(args[iargs], XtNy, y + incY); iargs++;
  XtSetArg(args[iargs], XtNwidth,500); iargs++; /* 500: quick and dirty */
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  theShell = XtCreatePopupShell("Metanet Dialog",transientShellWidgetClass,
			     toplevel,args,iargs);

  iargs = 0;
  form =  XtCreateManagedWidget("form",formWidgetClass,theShell,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, description); iargs++;
  XtSetArg(args[iargs], XtNvalue, valueinit); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  dialog = XtCreateManagedWidget("dialog",dialogWidgetClass,form,args,iargs);
  compiled_translation_table = XtParseTranslationTable(translations);
  XtOverrideTranslations(XtNameToWidget(dialog,"value"),
			 compiled_translation_table);

  callbacks[0].callback = (XtCallbackProc)DialogOk;
  callbacks[0].closure = (caddr_t)theShell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "ok" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromVert, dialog); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNleft, XawChainLeft); iargs++;
  XtSetArg(args[iargs], XtNright, XawChainLeft); iargs++;
  ok = XtCreateManagedWidget("okdialog",
			     commandWidgetClass,form,args,iargs);

  callbacks[0].callback = (XtCallbackProc)DialogCancel;
  callbacks[0].closure = (caddr_t)theShell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "cancel" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromVert, dialog); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, ok); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNleft, XawChainLeft); iargs++;
  XtSetArg(args[iargs], XtNright, XawChainLeft); iargs++;
  XtCreateManagedWidget("canceldialog",commandWidgetClass,form,args,iargs);

  XtPopup(theShell,XtGrabExclusive);

  dialogFlag = 0;
  while (!dialogFlag) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
  }
  XtDestroyWidget(theShell);

  switch (dialogFlag) {
  case OK:
    strcpy(result,str);
    return strlen(result);
  case CANCEL:
    return 0;
  }
  return 0;
}

/* METANET DIALOGS */

void DialogsOk(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  int i;
  for (i = 0; i < nDialog; i++)
    strcpy(strs[i],XawDialogGetValueString(dialogs[i]));
  XtPopdown((Widget)shell);
  dialogsFlag = OK;
}

void DialogsCancel(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  XtPopdown((Widget)shell);
  dialogsFlag = CANCEL;
}

/* MetanetDialogs returns 1 if something has been modified, 0 otherwise */

int MetanetDialogs(n,valueinit,result,description,label)
int n;
char *valueinit[], *result[], *description[], *label;
{
  XEvent event;
  Arg args[10];
  int iargs = 0;
  Widget form, labeldia, ok, form0, dialogsport;
  XtCallbackRec callbacks[2];
  int i;
  int x,y,w,h;
  int width;
  int height = DIALOGSHEIGHT;

  static char translations[] =
    "<Key>Return: ActionWhenReturn()";
  XtTranslations compiled_translation_table;

  dialogType = DIALOGS;

  GetMetanetGeometry(&x,&y,&w,&h);

  nDialog = n;

  width = 0;
  for (i = 0; i < nDialog; i++) {
    if ((strs[i] = (char*)malloc((unsigned)STRLEN*sizeof(char))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return 0;
    }
    width = max(width,XTextWidth(theG.metafont,description[i],
			   strlen(description[i])));
  }
  width = width + 75;
  
  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;
  
  XtSetArg(args[iargs], XtNx, x + incX); iargs++;
  XtSetArg(args[iargs], XtNy, y + incY); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  theShell = XtCreatePopupShell("Metanet Dialog",transientShellWidgetClass,
			     toplevel,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  form0 = XtCreateManagedWidget("dialogsform0",formWidgetClass,theShell,
			       args,iargs);

  /* Label */

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, label); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 0); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  labeldia = XtCreateManagedWidget("dialogslabel",labelWidgetClass,
				   form0,args,iargs);

  /* Ok and Cancel */

  callbacks[0].callback = (XtCallbackProc)DialogsOk;
  callbacks[0].closure = (caddr_t)theShell;

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "ok" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromVert, labeldia); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNleft, XawChainLeft); iargs++;
  XtSetArg(args[iargs], XtNright, XawChainLeft); iargs++;
  ok = XtCreateManagedWidget("okdialogs",
			     commandWidgetClass,form0,args,iargs);

  callbacks[0].callback = (XtCallbackProc)DialogsCancel;
  callbacks[0].closure = (caddr_t)theShell;

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "cancel" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromVert, labeldia); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, ok); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNleft, XawChainLeft); iargs++;
  XtSetArg(args[iargs], XtNright, XawChainLeft); iargs++;
  XtCreateManagedWidget("canceldialogs",commandWidgetClass,form0,args,iargs);

  /* viewport with the dialogs */

  if (dpyHeight * .7 < height) height = dpyHeight * .7;
  
  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNallowVert, TRUE); iargs++;
  XtSetArg(args[iargs], XtNwidth, width); iargs++;
  XtSetArg(args[iargs], XtNheight, height); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  XtSetArg(args[iargs], XtNfromVert, ok); iargs++;
  XtSetArg(args[iargs], XtNtop, XtChainTop); iargs++;
  dialogsport = XtCreateManagedWidget("dialogsport",viewportWidgetClass,
				      form0,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  form = XtCreateManagedWidget("dialogsform",formWidgetClass,dialogsport,
			       args,iargs);

  /* First dialog */

  XtSetArg(args[iargs], XtNlabel, description[0]); iargs++;
  XtSetArg(args[iargs], XtNvalue, valueinit[0]); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNfromVert, NULL); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  dialogs[0] = XtCreateManagedWidget("dialog",dialogWidgetClass,
				     form,args,iargs);
  compiled_translation_table = XtParseTranslationTable(translations);
  XtOverrideTranslations(XtNameToWidget(dialogs[0],"value"),
			 compiled_translation_table);
  
  /* Others dialogs */
  
  for (i = 1; i < nDialog; i++) {
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, description[i]); iargs++;
    XtSetArg(args[iargs], XtNvalue, valueinit[i]); iargs++;
    XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
    XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
    XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
    XtSetArg(args[iargs], XtNfromVert, dialogs[i-1]); iargs++;
    dialogs[i] = XtCreateManagedWidget("dialog",dialogWidgetClass,
				      form,args,iargs);
    compiled_translation_table = XtParseTranslationTable(translations);
    XtOverrideTranslations(XtNameToWidget(dialogs[i],"value"),
			   compiled_translation_table);
  }

  XtPopup(theShell,XtGrabExclusive);

  dialogsFlag = 0;
  while (!dialogsFlag) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
  }
  XtDestroyWidget(theShell);

  switch (dialogsFlag) {
  case OK: 
    for (i = 0; i < n; i++)
      strcpy(result[i],strs[i]);
    for (i = 0; i < n; i++)
      if (strcmp(strs[i],valueinit[i]) != 0)
	return 1;
    break;
  case CANCEL:
    return 0;
  }
  return 0;
}
