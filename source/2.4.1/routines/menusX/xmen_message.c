/* Copyright INRIA */
#include "men_scilab.h"

/*******************************************************
 * XWindow part for message 
 *******************************************************/

extern SciMess ScilabMessage;

#define OK 1
#define CANCEL 2
static int ok_Flag_sci;
extern void ShellFormCreate();
static void MessageOk();
static void MessageCancel();
int ExposeMessageWindow();


/*************************************************     
 * OK Callback 
 **********************************************************/

static 
void MessageOk(w,shell,callData)
     Widget w;
     caddr_t shell;
     caddr_t callData;
{
  ok_Flag_sci = OK;
}

/*************************************************     
 * cancel Callback 
 **********************************************************/

static 
void MessageCancel(w,shell,callData)
     Widget w;
     caddr_t shell;
     caddr_t callData;
{
  ok_Flag_sci = CANCEL;
}

/*************************************************     
 * Widget Creation 
 **********************************************************/

int ExposeMessageWindow()
{
  Arg args[10];
  Cardinal iargs = 0;
  Widget shell,dialog,mpanned,mviewport,okbutton,cancelbutton,cform;
  static Display *dpy = (Display *) NULL;

  ShellFormCreate("messageShell",&shell,&mpanned,&dpy);

  /* Create a Viewport+Label and resize it */
  ViewpLabelCreate(mpanned,&dialog,&mviewport,ScilabMessage.string);
  /* The buttons */

  iargs=0;
  cform = XtCreateManagedWidget("cform",formWidgetClass,mpanned,args,iargs);

  ButtonCreate(cform,&okbutton,(XtCallbackProc)MessageOk,(XtPointer) NULL,
	       ScilabMessage.pButName[0],"ok");
  if ( ScilabMessage.nb == 2) 
    {
      ButtonCreate(cform,&cancelbutton,(XtCallbackProc)MessageCancel,(XtPointer) NULL,ScilabMessage.pButName[1],"cancel");
    }
  XtMyLoop(shell,dpy,0,&ok_Flag_sci);
  return(ok_Flag_sci);
}









 
