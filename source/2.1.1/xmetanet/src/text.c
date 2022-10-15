#include <stdio.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/AsciiText.h>

#include "metaconst.h"
#include "metawin.h"
#include "graphics.h"

#define STRINGLEN 100000
#define MAXNAM 80

#define INCX 40
#define INCY 40

static int iText = 0;
static int iStr = 0;
static char Str[STRINGLEN];

void TextClose(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  XtPopdown((Widget)shell);
  XtDestroyWidget((Widget)shell);
}

void StartAddText()
{
  iStr = 0;
  Str[0] = '\0';
}  

void AddText(description)
char *description;
{
  sprintf(&Str[iStr],description);
  iStr = strlen(Str);
}

void EndAddText()
{
  Widget text;
  Arg args[10];
  int iargs = 0;
  Widget shell;
  XtCallbackRec callbacks[2];
  char name[MAXNAM];

  iText++;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;
  
  XtSetArg(args[iargs], XtNx, iText * INCX); iargs++;
  XtSetArg(args[iargs], XtNy, iText * INCY); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  sprintf(name,"Metanet Text %d",iText);
  shell = XtCreatePopupShell(name,transientShellWidgetClass,toplevel,
			     args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  text = XtCreateManagedWidget("text",boxWidgetClass,shell,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNstring, Str); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 1); iargs++;
  XtSetArg(args[iargs], XtNeditType, XawtextRead); iargs++;
  XtSetArg(args[iargs], XtNwrap, XawtextWrapWord); iargs++;
  XtSetArg(args[iargs], XtNscrollVertical, XawtextScrollWhenNeeded); iargs++;
  XtSetArg(args[iargs], XtNwidth, metaWidth/2); iargs++;
  XtSetArg(args[iargs], XtNheight, metaHeight/2); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("asciitext",asciiTextWidgetClass,
				text,args,iargs);

  callbacks[0].callback = (XtCallbackProc)TextClose;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Close" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtCreateManagedWidget("textcommand",commandWidgetClass,
			text,args,iargs);

  XtPopup(shell,XtGrabNone);
}
