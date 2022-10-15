
/*****************************************************************************
 *
 *  xdbx - X Window System interface to dbx
 *
 *  Copyright 1989, 1990 The University of Texas at Austin
 *
 *  Permission to use, copy, modify, and distribute this software and its
 *  documentation for any purpose and without fee is hereby granted,
 *  provided that the above copyright notice appear in all copies and that
 *  both that copyright notice and this permission notice appear in
 *  supporting documentation, and that the name of The University of Texas
 *  not be used in advertising or publicity pertaining to distribution of
 *  the software without specific, written prior permission.  The
 *  University of Texas makes no representations about the suitability of
 *  this software for any purpose.  It is provided "as is" without express
 *  or implied warranty.
 *
 *  THE UNIVERSITY OF TEXAS DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
 *  SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
 *  FITNESS, IN NO EVENT SHALL THE UNIVERSITY OF TEXAS BE LIABLE FOR ANY
 *  SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
 *  RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
 *  CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 *  CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *  Author:  	Po Cheung, The University of Texas at Austin
 *  Created:   	March 10, 1989
 *
 *****************************************************************************/

/*  windows.c:
 *
 *    CreateTitleBar() :	Create title bar.
 *    CreateFileLabel() :	Create file label in file window.
 *    CreateLineLabel() :	Create line label in file window.
 *    CreateFileWindow() :	Create file window.
 *    CreateMessageWindow() :	Create message window.
 *    CreateSubWindows() :	Create the subwindows.
 *    UpdateFileLabel() :	Update file label.
 *    UpdateLineLabel() :	Update line label.
 *    UpdateMessageWindow() :	Update message window.
 */
#include "x_ptyx.h"
#include "x_data.h"
#include "jpc_global.h"

Widget	fileWindow,			/* parent of fileLabel and lineLabel */
	messageWindow,			/* window for displaying messages */
	separator;			/* separator in vpane */

static Widget 	fileLabel,		/* filename of displayed text */
		lineLabel;		/* line number of caret position */

/*
 *  Private routines for creating various subwindows for xdbx.
 */

static void CreateFileLabel(parent)
Widget parent;
{
    Arg 	args[MAXARGS];
    Cardinal 	n;

    n = 0;
    XtSetArg(args[n], XtNlabel, (XtArgVal) "No Source File");           n++;
    XtSetArg(args[n], XtNborderWidth, (XtArgVal) 0);           		n++;
    fileLabel = XtCreateManagedWidget("fileLabel", labelWidgetClass, 
				      parent, args, n);
}

static void CreateLineLabel(parent)
Widget parent;
{
    Arg 	args[MAXARGS];
    Cardinal 	n;

    n = 0;
    XtSetArg(args[n], XtNlabel, (XtArgVal) "");           		n++;
    XtSetArg(args[n], XtNborderWidth, (XtArgVal) 0);           		n++;
    XtSetArg(args[n], XtNfromHoriz, (XtArgVal) fileLabel);          	n++;
    XtSetArg(args[n], XtNhorizDistance, (XtArgVal) 0);          	n++;
    lineLabel = XtCreateManagedWidget("lineLabel", labelWidgetClass, 
				      parent, args, n);
}


static void CreateFileWindow(parent)
Widget parent;
{
    Arg 	args[MAXARGS];
    Cardinal 	n;

    n = 0;
    XtSetArg(args[n], XtNshowGrip, (XtArgVal) False);			n++;
    fileWindow = XtCreateManagedWidget("fileWindow", formWidgetClass, 
				       parent, args, n);
    CreateFileLabel(fileWindow);
    CreateLineLabel(fileWindow);
}


#include "version.h"


static void CreateMessageWindow(parent)
Widget parent;
{
    Arg 	args[MAXARGS];
    Cardinal 	n;

    n = 0;
    XtSetArg(args[n], XtNlabel, (XtArgVal) DEFAULT_MES);	n++;
    XtSetArg(args[n], XtNjustify, (XtArgVal) XtJustifyLeft);          	n++;
    /*  XtSetArg(args[n], XtNshowGrip, (XtArgVal) False);			n++;**/
    XtSetArg(args[n], XtNmin, (XtArgVal) 20);        		n++;
    messageWindow = XtCreateManagedWidget("messageWindow", labelWidgetClass,
					  parent, args, n);
}

void DefaultMessageWindow()
{
    Arg 	args[MAXARGS];
    Cardinal 	n=0;
    XtSetArg(args[n], XtNlabel,(XtArgVal) DEFAULT_MES);	n++;
    XtSetValues(messageWindow, args, n);
}



/*  PUBLIC ROUTINES */
/*
 *  Top level function for creating all the xdbx subwindows.
 */

extern WidgetClass xtermWidgetClass;

#include "x_xbas.icon.X"
Pixmap  xbas_icon;

XtermWidget CreateSubWindows(parent)
Widget parent;
{
  XtermWidget CreateTermWindow();
  Widget	vpane;	 /* outer widget containing various subwindows */
  Arg 	args[MAXARGS];
  Cardinal 	n;
  n = 0;
  xbas_icon = XCreateBitmapFromData(XtDisplay(parent), 
				    RootWindow(XtDisplay(parent),
					       DefaultScreen(XtDisplay(parent))),
				   xbas_bits, xbas_width, xbas_height);
  XtSetArg(args[n], XtNiconPixmap, xbas_icon); n++;
  XtSetValues(parent, args, n);
  n=0;
  XtSetArg(args[n], XtNwidth, (XtArgVal) 650);        		n++;  
  XtSetArg(args[n], XtNheight, (XtArgVal) 500);        		n++;

  vpane = XtCreateManagedWidget("vpane", panedWidgetClass, parent, args, n);
  AddAcceptMessage(parent);
  CreateMessageWindow(vpane);
  CreateCommandPanel(vpane);
  return(CreateTermWindow(vpane));
} 

/** we want Xscilab to accept messages : NewGraphWindowMessageAtom **/

Atom		NewGraphWindowMessageAtom;

XtEventHandler UseMessage(w, child, e)
Widget w;
Widget child;

XClientMessageEvent *e;
{
    if (e->type == ClientMessage 
      && e->message_type == NewGraphWindowMessageAtom)
      {
	/*
	  fprintf(stderr,"It was a Client Message Of the Good Type \n");
	  fprintf(stderr,"I Need to Create Window %d",e->data.l[0]);
	*/
      };

};

static Widget WidgetUseMessage ;

AddAcceptMessage(parent)
     Widget parent;
{
  WidgetUseMessage=parent ;
  XtAddEventHandler(parent,ClientMessage, True, (XtEventHandler) UseMessage,NULL);  
};

ReAcceptMessage()
{
  XtAddEventHandler(WidgetUseMessage,ClientMessage, True, (XtEventHandler) UseMessage,NULL);  
};

XtermWidget CreateTermWindow(parent)
Widget parent;
{
  XtermWidget term;
  Arg 	args[MAXARGS];
  Cardinal 	n;
  n = 0;
  XtSetArg(args[n], XtNmin, (XtArgVal) 200);        		n++;
  term = (XtermWidget) XtCreateManagedWidget(
		     "vt100", xtermWidgetClass, parent, args,n);
  /* this causes the initialize method to be called */
  return(term);
}

/*
 *  Routines for updating fields for the filename and line number
 *  in the file window, and the execution status in the message window.
 */

void UpdateFileLabel(string)
char *string;
{
    Arg 	args[MAXARGS];
    Cardinal 	n;

    n = 0;
    XtSetArg(args[n], XtNlabel, (XtArgVal) string);        		n++;
    XtSetValues(fileLabel, args, n);
}

void UpdateLineLabel(line)
Cardinal line;
{
    Arg 	args[MAXARGS];
    Cardinal 	n;
    char 	string[10];

    n = 0;
    if (line > 0)
    	sprintf(string, "%d", line);
    else
	strcpy(string, "");
    XtSetArg(args[n], XtNlabel, (XtArgVal) string);        	n++;
    XtSetValues(lineLabel, args, n);
}

void UpdateMessageWindow(format, arg)
char *format, *arg;
{
    char 	message[LINESIZ], string[LINESIZ];
    Arg 	args[MAXARGS];
    Cardinal 	n;

    strcpy(message, "  ");
    sprintf(string, format, arg);
    strcat(message, string);
    n = 0;
    XtSetArg(args[n], XtNlabel, (XtArgVal) message);		n++;
    XtSetValues(messageWindow, args, n);
}
