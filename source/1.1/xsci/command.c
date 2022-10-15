/*****************************************************************************
 *  
 *  xdbx - X Window System interface to the dbx debugger
 *  Author:  	Po Cheung
 *  Created:   	March 10, 1989
 * 
 *****************************************************************************
 * 
 *  xxgdb - X Window System interface to the gdb debugger
 *  
 * 	Copyright 1990 Thomson Consumer Electronics, Inc.
 *  Adaptation to GDB:  Pierre Willard
 *  XXGDB Created:   	December, 1990
 *
 *****************************************************************************
 *  xscilab - X Window System interface to scilab
 *  
 * 	Copyright 1990  ENPC-Cergrene
 *  Adaptation to GDB:  Chancelier J.Ph
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
 
#include <signal.h>
#include <ctype.h>
#include <sys/wait.h>
#include "global.h"
#include <X11/cursorfont.h>
#define	 REVERSE	0
#define	 FORWARD	1

Widget		commandWindow;			/* command panel with buttons */
Boolean		PopupMode = False;
static Widget	AddButton();
static Widget	button[30];
static CommandRec *commandQueue = NULL;
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
    send_command(command);
}


extern void do_kill();

/* ARGSUSED */
static void Do_Kill (w, command, call_data)
    Widget w;
    XtPointer command;
    XtPointer call_data;
{
  do_kill(w);
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


static void CreateButtons (parent)
Widget parent;
{
  int i=0;
  void AddInfoHandler();
  button[i++] = AddButton (parent, "Resume", DoIt, "resume\n");
  AddInfoHandler(button[i-1],"Continue Scilab execution after pause or stop;");
  button[i++] = AddButton (parent, "Abort", DoIt, "abort\n");
  AddInfoHandler(button[i-1],"Abort Scilab execution after pause or stop;");
  button[i++] = AddButton (parent, "Restart", DoIt, 
			   "abort\nclear;exec('SCI/scilab.star');\n");
  AddInfoHandler(button[i-1],"Clears everything ");
  button[i++] = AddButton (parent, "Stop", DoIt, "\n");
  AddInfoHandler(button[i-1],"Stops execution ");
  button[i++] = AddButton (parent, "File Operations", FileG1, (char *) 0);
  AddInfoHandler(button[i-1],"Getf, Exec, Load and Save operations");
  button[i++] = AddButton (parent, "Demo", DoIt,
			   ";exec(\"SCI/demos/alldems.dem\");\n");
  button[i++] = AddButton (parent, "Quit", DoIt, "quit\n");
  button[i++] = AddButton (parent, "Kill", Do_Kill, " ");
  AddInfoHandler(button[i-1],"Kill Scilab");
  button[i++] = AddButton (parent, "Help", DoIt, "unix(SCI+'/bin/xscihelp');\n");
  AddInfoHandler(button[i-1],"Open Help Window");
  button[i++] = AddButton (parent, "Metanet", DoIt, "metawin=Metanet();\n");
  AddInfoHandler(button[i-1],"Exec Metanet");

  button[i++] = AddButton (parent, "Your Menu", DoIt, "usermenu();\n");
  AddInfoHandler(button[i-1],"User defined Menu");
  button[i++] = NULL;

};

CreateGraphicWindowIfNeeded(parent,count)
     Widget parent;
     int count;
{
  int i;
  static int local_count=0;
  for (i=local_count; i <= count ;i++) 
    {
      CreatePopupWindow(parent," \n",NULL);
      local_count++;
    }
};

/*--------buttons with increment or decrement a value stored in a label
  Creates a Form widget for the Graphic Window Management 
 */

static void
  CreateFormWithButtons(parent)
Widget parent;
{
  void Countp(), Countm(),SendCountSet(),SendCountRaise();
  void AddInfoHandler(),SendCountHide();
  Widget form, label, button,button1,button2,button3;
  int n;
  Arg args[2];
  form = XtCreateManagedWidget( "form", formWidgetClass, parent,
			       NULL, ZERO );
  n=0;
#ifdef XtNcursorname
    XtSetArg(args[n], XtNcursorName, "left_ptr"); n++;
#else
    /* for X11R4 */
    XtSetArg(args[n], XtNcursor, XCreateFontCursor(XtDisplay(parent),XC_left_ptr)); n++;
#endif
  button1 = XtCreateManagedWidget("Set (Create) Window ",commandWidgetClass, form,args,n);
  AddInfoHandler(button1,"Set the selected graphic window as the current window and creates it if necessary");
  n=0;
  XtSetArg(args[n], XtNfromHoriz, button1);n++;
#ifdef XtNcursorname
    XtSetArg(args[n], XtNcursorName, "left_ptr"); n++;
#else
    /* for X11R4 */
    XtSetArg(args[n], XtNcursor, XCreateFontCursor(XtDisplay(parent),XC_left_ptr)); n++;
#endif
  button2 = XtCreateManagedWidget("Raise (Create) Window",commandWidgetClass, form,args,n);
  AddInfoHandler(button2,"Raise the selected graphic window and creates it if necessary");
  n=0;
/** Temporary commented out it doesn't work properly
  XtSetArg(args[n], XtNfromHoriz, button2);n++;
#ifdef XtNcursorname
    XtSetArg(args[n], XtNcursorName, "left_ptr"); n++;
#else
    XtSetArg(args[n], XtNcursor, XCreateFontCursor(XtDisplay(parent),XC_left_ptr)); n++;
#endif
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
#ifdef XtNcursorname
    XtSetArg(args[n], XtNcursorName, "left_ptr"); n++;
#else
    /* for X11R4 */
    XtSetArg(args[n], XtNcursor, XCreateFontCursor(XtDisplay(parent),XC_left_ptr)); n++;
#endif
  button = XtCreateManagedWidget("+",commandWidgetClass,form,args,n);
  XtAddCallback( button, XtNcallback, Countp, (XtPointer) label );
  n=0;
  XtSetArg(args[n], XtNfromHoriz, button); n++;
#ifdef XtNcursorname
    XtSetArg(args[n], XtNcursorName, "left_ptr"); n++;
#else
    /* for X11R4 */
    XtSetArg(args[n], XtNcursor, XCreateFontCursor(XtDisplay(parent),XC_left_ptr)); n++;
#endif
  button = XtCreateManagedWidget("-", commandWidgetClass, form,args,n);
  XtAddCallback( button, XtNcallback, Countm, (XtPointer) label );
  /* fin du form Widget */

}


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

#define STRW ";driver(\"Rec\");xset(\"window\",%d);\n"

static void 
SendCountSet(widget, closure, callData)
Widget widget;
XtPointer closure, callData;
{
  char strsend1[sizeof(STRW)+2];
  sprintf(strsend1,STRW,lab_count);
  CreateGraphicWindowIfNeeded(widget,lab_count);
  write_scilab(strsend1); 
}

#define STRW1 ";driver(\"Rec\");xset(\"window\",%d);xselect();\n"

static void 
SendCountRaise(widget, closure, callData)
Widget widget;
XtPointer closure, callData;
{
  char strsend1[sizeof(STRW1)+2];
  sprintf(strsend1,STRW1,lab_count);
  CreateGraphicWindowIfNeeded(widget,lab_count);
  GraphicPopUp(lab_count);
  write_scilab(strsend1);
}

static void 
SendCountHide(widget, closure, callData)
Widget widget;
XtPointer closure, callData;
{
  CreateGraphicWindowIfNeeded(widget,lab_count);
  GraphicPopDown(lab_count);
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

/**************************************************************************
 * help message associated to buttons
 **************************************************************************/

void
info_handler(w, client_data, event)
     Widget	w;				/* unused */
     caddr_t	client_data;
     XEvent	*event;
{
  if      (event->type == LeaveNotify ) DefaultMessageWindow();
  else if (event->type == EnterNotify) UpdateMessageWindow(client_data);
} 


void
AddInfoHandler(widget, message)
Widget widget;
char *message;
{
  XtAddEventHandler(widget,
		    (EventMask) (EnterWindowMask|LeaveWindowMask),
		    False,
		    info_handler,
		    (caddr_t) message);
}


/**************************************************************************
 *
 *  Command queue functions
 *  It's used by read_dbx who want to know which command was activated 
 *  But We do not use this facility up to now 
 **************************************************************************/

/*  Append command to end of the command queue and send the command to dbx */

void send_command(command)
char *command;
{
    CommandRec *p, *q, *r;

#ifdef BSD 
    /* Save the command if it is not a blank command; else use the 
       last saved command instead */
    if (strcspn(command, " \n"))
	strcpy(savedCommand, command);
    else
	strcpy(command, savedCommand);
#endif

    p = (CommandRec *)XtNew(CommandRec);
    p->command = XtNewString(command);
    p->next = NULL;
    if (!commandQueue)
	commandQueue = p;
    else {
	q = commandQueue;
	while (r = q->next)
	    q = r;
	q->next = p;
    }
    write_scilab(command);
}

/*  Read command at the head of the command queue */

char *get_command()
{
    if (commandQueue) {
	return (commandQueue->command);
    }
    else
	return NULL;
}

/*  Delete command from the head of the command queue */

void delete_command()
{
    CommandRec *p;

    if (p = commandQueue) {
	commandQueue = p->next;
	XtFree(p->command);
	XtFree(p);
    }
}

/*  Insert command into head of queue */

void insert_command(command)
char *command;
{
    CommandRec *p;

    p = (CommandRec *)XtNew(CommandRec);
    p->command = XtNewString(command);
    p->next = NULL;
    if (!commandQueue)
	commandQueue = p;
    else {
	p->next = commandQueue;
	commandQueue = p;
    }
}





