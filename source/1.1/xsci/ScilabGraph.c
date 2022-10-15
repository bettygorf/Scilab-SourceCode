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


static XtCallbackProc  Efface(),Print();
static XtEventHandler EventProc();
void ResizeWindow();

SetHints(toplevel)
     Widget toplevel;
{
 Display		*dpy = XtDisplay(toplevel);
 Window			win = XtWindow(toplevel);
 XSizeHints		size_hints;
 Atom		wmDeleteWindow;
 size_hints.width	= 400;
 size_hints.height	= 300;
 size_hints.min_width = size_hints.max_width = size_hints.width ;
 size_hints.min_height = size_hints.max_height = size_hints.height ;
 size_hints.flags = USPosition | USSize | PMinSize;
 XSetNormalHints(dpy, win, &size_hints);
 /*
  *  Add a protocol flag indicating we wish to handle
  *  WM_DELETE_WINDOW requests (in fact we ignore it)
  */
 wmDeleteWindow = XInternAtom(dpy, "WM_DELETE_WINDOW", False);
 XSetWMProtocols(dpy, win, &wmDeleteWindow, 1);
}

/*	Function Name: CreatePopupWindow
 *	Description: Creates and pops up the New Graphic Window
 *	Arguments: button - the command button that activated this function.
 *                 client_data, call_data - *** UNUSED ***
 *	Returns: none.
 */

static int popupcount=0; /* number of the last created graphic window */
static char popupname[sizeof("ScilabGraphic")+4];
#define MAXWIN 50
Widget  popuplist[MAXWIN];
Window  window[MAXWIN];

void 
CreatePopupWindow(button, client_data, call_data)
Widget	button;		
XtPointer client_data, call_data;
{
    Arg		args[5];
    Widget	popup;
    Position	x, y;
    Dimension	width, height;
    Cardinal	n;

    /*
     * This will position the upper left hand corner of the popup at the
     * center of the widget which invoked this callback, which will also
     * become the parent of the popup.  I don't deal with the possibility
     * that the popup will be all or partially off the edge of the screen.
     */

    n = 0;
    XtSetArg(args[n], XtNwidth, &width); n++;
    XtSetArg(args[n], XtNheight, &height); n++;
    XtGetValues(button, args, n);
    XtTranslateCoords(button, (Position) (width / 2), (Position) (height / 2),
		      &x, &y);
    n = 0;
    XtSetArg(args[n], XtNx, x+20*popupcount);	n++;
    XtSetArg(args[n], XtNy, y+20*popupcount);	n++;
    sprintf(popupname,"ScilabGraphic%d",popupcount);
    /* if XtNTitle existe*/
    XtSetArg(args[n],XtNtitle,popupname);n++;
    popup = XtCreatePopupShell(popupname,
			       wmShellWidgetClass, button, args, n);
    AddNewWin(popup,popupcount);
    XtPopup(popup, XtGrabNone);
    SetHints(popup);
    /* XLowerWindow(XtDisplay(popup),XtWindow(popup)); */
    SetGlobalVar(popupcount);
    if (popupcount < MAXWIN) popuplist[popupcount]= popup;
    popupcount++;
    XSync(XtDisplay(popup),0);
}

Widget outer,command, command1, box,drawbox,command2,command3  ;
Display *dpy;


GraphicPopDown(count)
     int count;
{
  /** XtPopdown(popuplist[count]); **/
}

GraphicPopUp(count)
     int count;
{  
  XtPopup(popuplist[count],XtGrabNonexclusive);
}


SetGlobalVar(popupcount)
     int popupcount;
{
  static XSetWindowAttributes attributes;
  char winname[6];
  dpy    = XtDisplay(drawbox);
  if (popupcount < MAXWIN) window[popupcount]= XtWindow(drawbox);
  sprintf(winname,"BG%d",popupcount);
  XChangeProperty(dpy, window[popupcount], XA_WM_NAME, XA_STRING, 8, 
		       PropModeReplace, winname, 5);
  attributes.backing_store = Always;
  attributes.bit_gravity = NorthWestGravity;
  XChangeWindowAttributes(dpy, window[popupcount],
			  CWBackingStore | CWBitGravity,&attributes);
 }; 

AddNewWin(popup,popupcount)
     Widget popup;
     int popupcount;
{
  static Arg boxArgs[4],args[1] ;
  Cardinal n=0;
  outer = XtCreateManagedWidget( "paned", formWidgetClass, popup,
				  args,n);
  XtAddEventHandler(outer, StructureNotifyMask , False, ResizeWindow, 
		    (XtPointer) popupcount);
  n=0;
  XtSetArg(boxArgs[n], XtNresize, (XtArgVal) False); n++; 
  XtSetArg(boxArgs[n], XtNwidth , strlen("Clear")*13);n++;
  XtSetArg(boxArgs[n], XtNheight , 15);n++;
  command2 = XtCreateManagedWidget("Clear",
				   commandWidgetClass,outer,boxArgs,n);
  XtAddCallback(command2, XtNcallback,(XtCallbackProc) Efface, 
		(XtPointer) popupcount); 
  n=0;
  XtSetArg(boxArgs[n], XtNfromHoriz, command2);n++;
  XtSetArg(boxArgs[n], XtNresize, (XtArgVal) False); n++; 
  XtSetArg(boxArgs[n], XtNwidth , strlen("Print")*13);n++;
  XtSetArg(boxArgs[n], XtNheight , 15);n++;
  command3 = XtCreateManagedWidget("Print",
				   commandWidgetClass,outer,boxArgs,n);
  XtAddCallback(command3, XtNcallback,(XtCallbackProc)  Print,
		(XtPointer) popupcount); 
  XtSetArg(args[0], XtNfromHoriz, command3);
  n=0;
  XtSetArg(boxArgs[n], XtNheight , 400);n++;
  XtSetArg(boxArgs[n], XtNwidth , 600);n++;
  XtSetArg(boxArgs[n], XtNfromVert , command2);n++;
  drawbox= XtCreateManagedWidget("scigraphic",boxWidgetClass, outer,
				 boxArgs,n);
  /* XtAddEventHandler(drawbox,  ButtonPressMask|PointerMotionMask|
		    KeyPressMask,False,
		    (XtEventHandler) EventProc, (XtPointer) popupcount); 
		    */
  /* EventProc Must select the client Message Events */
  XtAddEventHandler(outer,NoEventMask,True,(XtEventHandler) EventProc,
		    (XtPointer) popupcount); 
};

/* 
 * Checking events in the Graphic Window 
 * Just Client Message can get there 
 * 
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
    case ButtonPress:
      fprintf(stderr," BPress In box %d \n",num); 
      break;
    case KeyPress:
      fprintf(stderr," KeyPress\n");
      break;
    case ClientMessage:
      fprintf(stderr," ClientMessage\n");
      break;
    default:
      fprintf(stderr," Unprocessed Event \n"); 
        return;
    }
}

/*
 * The ResizeWindow handler for the drawbox
 * This function is called when the window need redisplay
 * 
 */

#define STR0 ";xbasr(%d);\n"
static char strsend0[sizeof(STR0)+2];

void ResizeWindow(w, number, e)
     Widget w; 
     XtPointer number;
     XConfigureEvent *e;
{
  int num= (int) number;
  if (e->type != ConfigureNotify) return;
  sprintf(strsend0,STR0,num,num,num);
  write_scilab(strsend0);
 }

/*
 *
 * To clear the graphic window and clear the recorded graphics 
 * 
 */

#define STR1 ";xbasc(%d);\n"
static char strsend1[sizeof(STR1)+2];

static XtCallbackProc
Efface(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  int num = (int) number ;
  sprintf(strsend1,STR1,num);
  write_scilab(strsend1);
}


/*
 * Replot in Postscript style 
 * 
 */

#define PRINT0 ";xbasimp(%d);\n"
static char strpr0[sizeof(PRINT0)+3];

static XtCallbackProc
Print(w, number, client_data)
Widget w;
XtPointer number;
XtPointer client_data;
{
  int num = (int) number ;
  sprintf(strpr0,PRINT0,num);
  write_scilab(strpr0);
}






