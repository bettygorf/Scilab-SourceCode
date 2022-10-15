#include <stdio.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/AsciiText.h>

#include "metaconst.h"
#include "metawin.h"
#include "graphics.h"

extern void GetMetanetGeometry();

#define STRINGLEN 100000
#define MAXNAM 80

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
  Widget text, textclose;
  Arg args[10];
  int iargs = 0;
  Widget shell;
  XtCallbackRec callbacks[2];
  char name[MAXNAM];
  int x,y,w,h;

  if(iText++ > 4) iText = 1;
  GetMetanetGeometry(&x,&y,&w,&h);

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;
  
  XtSetArg(args[iargs], XtNx, x + iText * incX); iargs++;
  XtSetArg(args[iargs], XtNy, y + iText * incY); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  sprintf(name,"Metanet Text %d",iText);
  shell = XtCreatePopupShell(name,transientShellWidgetClass,toplevel,
			     args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  text = XtCreateManagedWidget("text",formWidgetClass,shell,args,iargs);

  callbacks[0].callback = (XtCallbackProc)TextClose;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Close" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNleft, XawChainLeft); iargs++;
  XtSetArg(args[iargs], XtNright, XawChainLeft); iargs++;
  textclose = XtCreateManagedWidget("textcommand",commandWidgetClass,
			text,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNstring, Str); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 1); iargs++;
  XtSetArg(args[iargs], XtNeditType, XawtextRead); iargs++;
  XtSetArg(args[iargs], XtNwrap, XawtextWrapWord); iargs++;
  XtSetArg(args[iargs], XtNscrollVertical, XawtextScrollWhenNeeded); iargs++;
  XtSetArg(args[iargs], XtNwidth, metaWidth/2); iargs++;
  XtSetArg(args[iargs], XtNheight, metaHeight/2); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromVert, textclose); iargs++;
  XtCreateManagedWidget("asciitext",asciiTextWidgetClass,
				text,args,iargs);

  XtPopup(shell,XtGrabNone);
}
