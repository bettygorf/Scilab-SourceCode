
#include <stdio.h>			/* For the Syntax message */

#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/Cardinals.h>

#include "../machine.h"
#include "Math.h"

static XtCallbackProc Efface(),PrintPix();
static XtEventHandler EventProc();
static XtEventHandler ResizeWindow();

static int popupcount=0; /* number of the last created graphic window */
static char popupname[sizeof("ScilabGraphic")+4];

/*
 * Fixes hints for the graphic windows (min sizes and wm delete window flag)
 */

static SetHints(toplevel)
     Widget toplevel;
{
 XSizeHints		size_hints;
 Atom		wmDeleteWindow;
 size_hints.width	= 400;
 size_hints.height	= 300;
 size_hints.min_width = size_hints.max_width = size_hints.width ;
 size_hints.min_height = size_hints.max_height = size_hints.height ;
 size_hints.flags = USPosition | USSize | PMinSize;
 XSetNormalHints(XtDisplay(toplevel),XtWindow(toplevel), &size_hints);
 /*
  *  Add a protocol flag indicating we wish to handle
  *  WM_DELETE_WINDOW requests (in fact we ignore it)
  */
 wmDeleteWindow = XInternAtom(XtDisplay(toplevel), "WM_DELETE_WINDOW", False);
 XSetWMProtocols(XtDisplay(toplevel),XtWindow(toplevel),&wmDeleteWindow, 1);
}

/*
 * Creates a new graphic window 
 */

static int
AddNewWin(popup,popupcount,drawbox)
     Widget popup,*drawbox;
     int popupcount;
{
  Widget outer,command2,command3;
  static Arg args[1];
  Cardinal n=0;
  outer = XtCreateManagedWidget( "scigForm", formWidgetClass,popup,
				  args,n);
  XtAddEventHandler(outer,StructureNotifyMask,False,
		    (XtEventHandler)ResizeWindow, 
		    (XtPointer) popupcount);
  command2 = XtCreateManagedWidget("Clear",
				   commandWidgetClass,outer,args,n);
  XtAddCallback(command2, XtNcallback,(XtCallbackProc) Efface, 
		(XtPointer) popupcount); 
  /** No print for the Pixmap Window **/
  /* 
  command3 = XtCreateManagedWidget("Print",
				   commandWidgetClass,outer,args,n);
  XtAddCallback(command3, XtNcallback,(XtCallbackProc)  PrintPix,
		(XtPointer) popupcount); 
  */
  /* I use a label in order to have foreground and background */
  n=0;
  XtSetArg(args[n], XtNlabel," ");n++;
  *drawbox= XtCreateManagedWidget("scigraphic",labelWidgetClass, outer,
				 args,n);
  /* EventProc Must select the client Message Events */
  XtAddEventHandler(outer,NoEventMask,True,(XtEventHandler) EventProc,
		    (XtPointer) popupcount);  
  XtAddEventHandler(*drawbox,  ButtonPressMask|PointerMotionMask|
		    KeyPressMask,True,
		    (XtEventHandler) EventProc, (XtPointer) popupcount);
  /* AddNewMenu(outer,*drawbox); */
}

/* 
 * Checking events in the Graphic Window 
 * in fact just the XtAddEventHandler is used 
 * used in xclick 
 */

static XtEventHandler
EventProc(widget, number , event)
    Widget widget;
    XtPointer number;
    XEvent *event;
{
  int num= (int) number;
  switch (event->type) 
    {
     default:
      return;
    }
}
/*
 * The ResizeWindow handler for the drawbox
 * This function is called when the window need redisplay
 * 
 */
static XtEventHandler ResizeWindow(w, number, e)
     Widget w; 
     XtPointer number;
     XConfigureEvent *e;
{
  int win_num= (int) number;
  int verb=0,cur,na;
  if (e->type != ConfigureNotify) return;
  {
    char c,name[4];
    GetDriver1_(name);
    if ( (c=GetDriver_()) !='W') SetDriver_("Wdp");
    C2F(dr)("xget","window",&verb,&cur,&na,IP0,IP0,IP0,0,0);  
    C2F(dr)("xset","window",&win_num,IP0,IP0,IP0,IP0,IP0,0,0);
    CPixmapResize1();
    C2F(dr)("xclear","v",IP0,IP0,IP0,IP0,IP0,IP0,0,0);
    C2F(dr)("xset","window",&cur,IP0,IP0,IP0,IP0,IP0,0,0);
    C2F(dr)("xsetdr",name, IP0, IP0,IP0,IP0,IP0,IP0,0,0);
  }
}


/*
 *
 * To clear the graphic window and clear the recorded graphics 
 * 
 */

static XtCallbackProc
Efface(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  int win_num = (int) number ;
  int verb=0,cur,na;
  char c,name[4];
  GetDriver1_(name);
  if ( (c=GetDriver_()) !='W') SetDriver_("Wdp");
  C2F(dr)("xget","window",&verb,&cur,&na,IP0,IP0,IP0,0,0);  
  C2F(dr)("xset","window",&win_num,IP0,IP0,IP0,IP0,IP0,0,0);
  C2F(dr)("xclear","v",IP0,IP0,IP0,IP0,IP0,IP0,0,0);
  C2F(dr)("xset","window",&cur,IP0,IP0,IP0,IP0,IP0,0,0);
  C2F(dr)("xsetdr",name, IP0, IP0,IP0,IP0,IP0,IP0,0,0);
}

/*
 * Replot in Postscript style 
 * 
 */

static XtCallbackProc
PrintPix(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  int win_num = (int) number ;
  int verb=0,cur,na;
  /** xclear(win_num) **/
  Scistring("To be done \n");
}

/*	Function Name: CreatePopupWindow
 *	Description: Creates and pops up the New Graphic Window
 *      Returns the graphic window id (CWindow) and the window of the top level widget (SciGWindow)
 */

CreatePopupWindowPix(button, CWindow,SciGWindow,fg,bg)
     Widget	button;		
     Window *CWindow,*SciGWindow;
     unsigned long *fg,*bg;
{
    Arg		args[5];
    Widget	popup,drawbox;
    Position	x, y;
    Cardinal	n;
    XColor x_fg_color,x_bg_color;
    static XSetWindowAttributes attributes;
    unsigned char winname[6];

    n = 0;
    XtSetArg(args[n], XtNx, 100+20*popupcount);	n++;
    XtSetArg(args[n], XtNy, 100+20*popupcount);	n++;
    sprintf(popupname,"ScilabWdp%d",popupcount);
    XtSetArg(args[n],XtNtitle,popupname);n++;
    popup = XtCreatePopupShell(popupname,
			       wmShellWidgetClass, button, args, n);
    AddNewWin(popup,popupcount,&drawbox);
    XtPopup(popup, XtGrabNone);
    SetHints(popup);

    sprintf((char *)winname,"BG%d",popupcount);
    XChangeProperty(XtDisplay(drawbox), XtWindow(drawbox), XA_WM_NAME, XA_STRING, 8, 
		    PropModeReplace, winname, 5);
    attributes.backing_store = Always;
    attributes.bit_gravity = NorthWestGravity;
    XChangeWindowAttributes(XtDisplay(drawbox), XtWindow(drawbox),
			    CWBackingStore | CWBitGravity,&attributes);
    popupcount++;
    XSync(XtDisplay(popup),0);
    *CWindow=XtWindow(drawbox);
    *SciGWindow=XtWindow(popup);

    /*  Getting the values of foreground and background */
    XtSetArg(args[0],XtNforeground, &x_fg_color.pixel);
    XtSetArg(args[1],XtNbackground, &x_bg_color.pixel);
    XtGetValues(drawbox,args,2);
    *fg = x_fg_color.pixel;
    *bg = x_bg_color.pixel;
}



