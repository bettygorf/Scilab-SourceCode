#include <stdio.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/AsciiText.h>

#include "metaconst.h"
#include "metadir.h"
#include "metawin.h"
#include "graphics.h"

extern void GetMetanetGeometry();
extern char beginHelp[];
extern char studyHelp[];
extern char modifyHelp[];

static file[20];

void HelpClose(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  XtPopdown((Widget)shell);
  XtDestroyWidget((Widget)shell);
}

void DisplayHelp(file)
char *file;
{
  Arg args[15];
  int iargs = 0;
  Widget shell, helpclose, help;
  XtCallbackRec callbacks[2];
  int helpwidth;
  int x,y,w,h;
  char str[80];

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  GetMetanetGeometry(&x,&y,&w,&h);
  strcpy(str,"12345678901234567890123456789012345678901234567890123456789012345678901234567890"); /* 80 characters string */
  helpwidth = XTextWidth(theG.helpfont,str,strlen(str));
  if (helpwidth > metaWidth) helpwidth = metaWidth;
  
  XtSetArg(args[iargs], XtNx, x + incX); iargs++;
  XtSetArg(args[iargs], XtNy, y + incY); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.helpfont); iargs++;
  shell = XtCreatePopupShell("Metanet Help",transientShellWidgetClass,toplevel,
			     args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfont, theG.helpfont); iargs++;
  help =  XtCreateManagedWidget("helpform",formWidgetClass,shell,args,iargs);

  callbacks[0].callback = (XtCallbackProc)HelpClose;
  callbacks[0].closure = (caddr_t)shell;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Close" ); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.helpfont); iargs++;
  XtSetArg(args[iargs], XtNbottom, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNtop, XawChainTop); iargs++;
  XtSetArg(args[iargs], XtNleft, XawChainLeft); iargs++;
  XtSetArg(args[iargs], XtNright, XawChainLeft); iargs++;
  helpclose = XtCreateManagedWidget("helpcommand",commandWidgetClass,
			help,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNtype, XawAsciiFile); iargs++;
  XtSetArg(args[iargs], XtNstring, file); iargs++;
  XtSetArg(args[iargs], XtNborderWidth, 1); iargs++;
  XtSetArg(args[iargs], XtNeditType, XawtextRead); iargs++;
  XtSetArg(args[iargs], XtNscrollVertical, XawtextScrollWhenNeeded); iargs++;
  XtSetArg(args[iargs], XtNscrollHorizontal, XawtextScrollWhenNeeded); iargs++;
  XtSetArg(args[iargs], XtNwidth, helpwidth); iargs++;
  XtSetArg(args[iargs], XtNheight, metaHeight/2); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.helpfont); iargs++;
  XtSetArg(args[iargs], XtNfromVert, helpclose); iargs++;
  XtCreateManagedWidget("asciitext",asciiTextWidgetClass,
				help,args,iargs);

  XtPopup(shell,XtGrabNone);
}

void DisplayBeginHelp()
{
  DisplayHelp(beginHelp);
}

void DisplayStudyHelp()
{
  DisplayHelp(studyHelp);
}

void DisplayModifyHelp()
{
  DisplayHelp(modifyHelp);
}
