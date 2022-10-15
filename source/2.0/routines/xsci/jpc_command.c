/*****************************************************************************
 *  
 *  xdbx - X Window System interface to the dbx debugger
 *  Author:  	Po Cheung
 *  Created:   	March 10, 1989
 *  xxgdb - X Window System interface to the gdb debugger
 * 	Copyright 1990 Thomson Consumer Electronics, Inc.
 *  Adaptation to GDB:  Pierre Willard
 *  XXGDB Created:   	December, 1990
 *
 *****************************************************************************
 *  xscilab - X Window System interface to scilab
 *  
 * 	Copyright 1990  ENPC-Cergrene
 *  Adaptation from  GDB:  Chancelier J.Ph
 *  xscilab Created:   	1992
 *****************************************************************************/

/*  command.c
 *
 *    Create the command window, the command buttons and their callbacks.
 *
 *    CreateCommandPanel() : 	Create a window with command buttons
 *    CreateButtons() :		Create command buttons in panel
 *    CreateFormWithButtons(parent) : Special set of buttons button 
 *    AddButton() :		Add a command button into the command window
 *    Command callbacks for the command buttons:
 *
 *    Command queue manipulation routines:
 *	send_command():		send a command to dbx and record in the queue
 *	get_command():		read command off head of queue
 *	insert_command():	insert command at the head of queue
 *	delete_command():	delete command from head of queue
 */

#include "../machine.h" 
#include <signal.h>
#include <ctype.h>
#include <sys/wait.h>
#include "jpc_global.h"
#include <X11/cursorfont.h>
#define	 REVERSE	0
#define	 FORWARD	1

Widget		commandWindow;			/* command panel with buttons */
Boolean		PopupMode = False;
static Widget	AddButton();
static Widget	button[30];
static CommandRec *commandQueue = NULL;
extern int get_is_reading();
#ifdef BSD
static char	savedCommand[LINESIZ] = ""; 
#endif


/* ARGSUSED */
/*  Execute the command specifed in client_data
 */

static void DoIt (w, command, call_data)
    Widget w;
    XtPointer command;
    XtPointer call_data;
{
    /* run, cont, next, step, where, up, down, status */
    write_scilab(command);
}


extern void do_kill();

/* ARGSUSED */
static void Do_Kill (w, command, call_data)
    Widget w;
    XtPointer command;
    XtPointer call_data;
{
  C2F(sciquit)();
  exit(1);
}

/* ARGSUSED */
static void Do_Stop (w, command, call_data)
    Widget w;
    XtPointer command;
    XtPointer call_data;
{
/*    if (!get_is_reading())
	    {
		int j = SIGINT;
		C2F(sigbas)(&j);
	    }
    else*/
    int j = SIGINT;
    C2F(sigbas)(&j);
    if (get_is_reading())
	write_scilab("\n");
    
}

extern void   popupHelpPanel();
/* ARGSUSED */
static void Do_Help (w, command, call_data)
    Widget w;
    XtPointer command;
    XtPointer call_data;
{
  static int status=0;
  if ( status == 0) {
    initHelpActions(app_con); status=1;
  };
  popupHelpPanel();
  /* status=system("$SCI/bin/scilab -xhelp"); */
}


/* for all file operations */
void FileG1(w, closure, call_data)
    Widget w;
    XtPointer closure;
    caddr_t call_data;
{
  popup_file_panel(w);
 }

static Widget AddButton(parent, name, function, client_data)
Widget parent;
char *name;
void (*function) ();
XtPointer client_data;		/* callback registered data */
{
    Widget 	button;
    Arg 	args[MAXARGS];
    Cardinal 	n;

    n = 0;
    /* XtSetArg(args[n], XtNresize, (XtArgVal) True); n++; */
    /* must be improved : Id'like the command button to check himself its size */
    XtSetArg(args[n], XtNwidth, strlen(name)*11); n++;
#ifdef XtNcursorname
    XtSetArg(args[n], XtNcursorName, "left_ptr"); n++;
#else
    /* for X11R4 */
    XtSetArg(args[n], XtNcursor, XCreateFontCursor(XtDisplay(parent),XC_left_ptr)); n++;
#endif
    button = XtCreateManagedWidget(name, commandWidgetClass, parent, args, n);
    XtAddCallback(button, XtNcallback, function, client_data);
    return (button);
}



/**************************************************************************
 * help message associated to buttons
 **************************************************************************/

static void
info_handler(w, client_data, event)
     Widget	w;				/* unused */
     caddr_t	client_data;
     XEvent	*event;
{
  if      (event->type == LeaveNotify ) DefaultMessageWindow();
  else if (event->type == EnterNotify) UpdateMessageWindow(client_data);
} 


static void
AddInfoHandler(widget, message)
Widget widget;
char *message;
{
  XtAddEventHandler(widget,
		    (EventMask) (EnterWindowMask|LeaveWindowMask),
		    False,
		    (XtEventHandler)info_handler,
		    (caddr_t) message);
}


static void CreateButtons (parent)
Widget parent;
{
  int i=0;
  button[i++] = AddButton (parent, "Resume", DoIt, "resume\n");
  AddInfoHandler(button[i-1],"Continue Scilab execution after pause or stop");
  button[i++] = AddButton (parent, "Abort", DoIt, "abort\n");
  AddInfoHandler(button[i-1],"Abort Scilab execution after pause or stop");
  button[i++] = AddButton (parent, "Restart", DoIt, 
			   "clear;exec('SCI/scilab.star');\n");
  AddInfoHandler(button[i-1],"Clear everything");
  button[i++] = AddButton (parent, "Stop", Do_Stop, " ");
  AddInfoHandler(button[i-1],"Stop execution");
  button[i++] = AddButton (parent, "File Operations", FileG1, (char *) 0);
  AddInfoHandler(button[i-1],"Getf, Exec, Load and Save operations");
  button[i++] = AddButton (parent, "Demo", DoIt,
			   ";exec(\"SCI/demos/alldems.dem\");\n");
  AddInfoHandler(button[i-1],"Exec demos");
  button[i++] = AddButton (parent, "Quit", DoIt, "quit\n");
  AddInfoHandler(button[i-1],"Quit Scilab");
  button[i++] = AddButton (parent, "Kill", Do_Kill, " ");
  AddInfoHandler(button[i-1],"Kill Scilab");
  button[i++] = AddButton (parent, "Help", Do_Help," ");
  AddInfoHandler(button[i-1],"Open Help Window");
  button[i++] = AddButton (parent, "Metanet", DoIt, "metanet();\n");
  AddInfoHandler(button[i-1],"Exec Metanet");

  button[i++] = AddButton (parent, "Your Menu", DoIt, "usermenu();\n");
  AddInfoHandler(button[i-1],"User defined Menu");
  button[i++] = NULL;

};


/*	Function Name: Count
 *	Description: This callback routin will increment that counter
 *                   and display the number as the label of the widget passed 
 *                   in the closure.
 *	Arguments: widget - *** UNUSED ***
 *                 closure - a pointer to the label widge to display the 
 *                           string in.
 *                 callData - *** UNUSED ***
 *	Returns: none
 */

/* ARGSUSED */
static int lab_count = 0;

static void 
Countp(widget, closure, callData)
Widget widget;
XtPointer closure, callData;
{
   Arg arg[1];
   char text[10];
   sprintf( text, " %d ", ++lab_count );
   XtSetArg( arg[0], XtNlabel, text );
   XtSetValues( (Widget)closure, arg, ONE );
}

/* ARGSUSED */
static void 
Countm(widget, closure, callData)
Widget widget;
XtPointer closure, callData;
{
   Arg arg[1];
   char text[10];
   lab_count = (lab_count == 0) ? 0 : lab_count-1;
   sprintf( text, " %d ", lab_count);
   XtSetArg( arg[0], XtNlabel, text );
   XtSetValues( (Widget)closure, arg, ONE );
}


#define IP0 (int *) 0

static void 
SendCountSet(widget, closure, callData)
Widget widget;
XtPointer closure, callData;
{
  char c ;
  if ((c=GetDriver_())=='R' || c == 'X' || c == 'W')
    {
      /* C2F(dr)("xsetdr","Rec",IP0,IP0,IP0,IP0,IP0,IP0,0,0); */
      C2F(dr)("xset","window",&lab_count,IP0,IP0,IP0,IP0,IP0,0,0);
    };
}


static void 
SendCountRaise(widget, closure, callData)
Widget widget;
XtPointer closure, callData;
{
  char c ;
  if ((c=GetDriver_())=='R' || c == 'X' || c == 'W')
    {
      /* C2F(dr)("xsetdr","Rec",IP0,IP0,IP0,IP0,IP0,IP0,0,0);*/
      C2F(dr)("xset","window",&lab_count,IP0,IP0,IP0,IP0,IP0,0,0);
      C2F(dr)("xselect","v",IP0,IP0,IP0,IP0,IP0,IP0,0,0);
    };
}

static void 
SendCountHide(widget, closure, callData)
Widget widget;
XtPointer closure, callData;
{

}

/*--------buttons with increment or decrement a value stored in a label
  Creates a Form widget for the Graphic Window Management 
 */

#ifdef XtNcursorname
#define XtSetCursor()     XtSetArg(args[n], XtNcursorName, "left_ptr"); n++;
#else
    /* for X11R4 */
#define XtSetCursor()     XtSetArg(args[n], XtNcursor, XCreateFontCursor(XtDisplay(parent),XC_left_ptr)); n++;
#endif

static void
  CreateFormWithButtons(parent)
Widget parent;
{
  Widget form, label, button,button1,button2,button3;
  int n;
  Arg args[2];
  form = XtCreateManagedWidget( "form", formWidgetClass, parent,
			       NULL, ZERO );
  n=0;
  XtSetCursor()
  button1 = XtCreateManagedWidget("Set (Create) Window ",commandWidgetClass, form,args,n);
  AddInfoHandler(button1,"Set the selected graphic window as the current window and create it if necessary");
  n=0;
  XtSetArg(args[n], XtNfromHoriz, button1);n++;
  XtSetCursor()
  button2 = XtCreateManagedWidget("Raise (Create) Window",commandWidgetClass, form,args,n);
  AddInfoHandler(button2,"Raise the selected graphic window and create it if necessary");
  n=0;
  /** Temporary commented out it doesn't work properly
  XtSetArg(args[n], XtNfromHoriz, button2);n++;
  XtSetCursor()
  button3 = XtCreateManagedWidget("Hide Window",commandWidgetClass, 
				  form,args,n);
  AddInfoHandler(button3,"Hides the  Graphic Window");
  **/
  n=0;
  XtSetArg(args[n], XtNfromHoriz, button2);n++;
  label = XtCreateManagedWidget(" 0 ",labelWidgetClass,form,args,n); 
  XtAddCallback( button1, XtNcallback, SendCountSet, (XtPointer) label );
  XtAddCallback( button2, XtNcallback, SendCountRaise, (XtPointer) label );
  /** Temporary commented out it doesn't work properly
  XtAddCallback( button3, XtNcallback, SendCountHide, (XtPointer) label ); **/
  n=0;
  XtSetArg(args[n], XtNfromHoriz, label); n++;
  XtSetCursor()
  button = XtCreateManagedWidget("+",commandWidgetClass,form,args,n);
  XtAddCallback( button, XtNcallback, Countp, (XtPointer) label );
  n=0;
  XtSetArg(args[n], XtNfromHoriz, button); n++;
  XtSetCursor()
  button = XtCreateManagedWidget("-", commandWidgetClass, form,args,n);
  XtAddCallback( button, XtNcallback, Countm, (XtPointer) label );
  /* fin du form Widget */

}

/**************************************************************************
 * The command panel
 **************************************************************************/

void CreateCommandPanel(parent)
Widget parent;
{
    Arg args[10];
    Cardinal n;
    n = 0;
    /* fixing a minimum value for the command widget inside the paned */
    XtSetArg(args[n], XtNmin, (XtArgVal) 100);        		n++;
    XtSetArg(args[n], XtNshowGrip, (XtArgVal) False);			n++;
    commandWindow = XtCreateManagedWidget("commandWindow", boxWidgetClass, 
					  parent, args, n);
    CreateButtons(commandWindow);
    CreateFormWithButtons(commandWindow);
    /** Creating a first graphic Popup Window **/
}






