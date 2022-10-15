/*
 * FIG : Facility for Interactive Generation of figures
 * Copyright (c) 1985 by Supoj Sutanthavibul
 *
 * "Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both the copyright
 * notice and this permission notice appear in supporting documentation. 
 * No representations are made about the suitability of this software for 
 * any purpose.  It is provided "as is" without express or implied warranty."
 */

#include "wf_fig.h"
#include "wf_figx.h"
#include "wf_resources.h"
static  TOOLSW	msg_form, msg_panel, name_panel;
#include "wf_mode.h"
#include "wf_w_util.h"
#include "wf_w_setup.h"
#include <varargs.h>

/********************* EXPORTS *******************/

int		put_msg();
int		init_msgreceiving();

/************************  LOCAL ******************/

#define		BUF_SIZE		128
static char	prompt[BUF_SIZE];

DeclareStaticArgs(12);

int
init_msg(tool,vert_w, ch,filename)
     TOOL	    tool,vert_w;
     int ch;
    char	   *filename;
{
    /* first make a form to put the two widgets in */
    FirstArg(XtNwidth, 350)
    NextArg(XtNheight, ch);
    NextArg(XtNfromVert,vert_w);
    NextArg(XtNvertDistance, 15);
    NextArg(XtNhorizDistance, 25);
    NextArg(XtNdefaultDistance, 0);
    NextArg(XtNborderWidth, 0);
    msg_form = XtCreateManagedWidget("msg_form", formWidgetClass, tool,
				      Args, ArgCount);
    /* setup the file name widget first */
    FirstArg(XtNresizable, True);
    NextArg(XtNlabel, (filename!=NULL? filename: DEF_NAME));
    NextArg(XtNtop, XtChainTop);
    NextArg(XtNwidth, 100);
    NextArg(XtNbottom, XtChainTop);
    NextArg(XtNborderWidth, INTERNAL_BW);
    name_panel = XtCreateManagedWidget("file_name", labelWidgetClass, msg_form,
				      Args, ArgCount);
    /* now the message panel */
    FirstArg(XtNstring, "\0");
    NextArg(XtNwidth,  400);
    NextArg(XtNfromHoriz, name_panel);
    NextArg(XtNhorizDistance, INTERNAL_BW);
    NextArg(XtNtop, XtChainTop);
    NextArg(XtNbottom, XtChainTop);
    NextArg(XtNborderWidth, INTERNAL_BW);
    NextArg(XtNdisplayCaret, False);
    msg_panel = XtCreateManagedWidget("message", asciiTextWidgetClass, msg_form,
				      Args, ArgCount);
}

/*
 * Update the current filename in the name_panel widget (it will resize
 * automatically) and resize the msg_panel widget to fit in the remaining 
 * space, by getting the width of the command panel and subtract the new 
 * width of the name_panel to get the new width of the message panel
 */

update_cur_filename(newname)
	char	*newname;
{
	Dimension namwid;

	XtUnmanageChild(msg_form);
	XtUnmanageChild(msg_panel);
	XtUnmanageChild(name_panel);
	strcpy(cur_filename,newname);

	FirstArg(XtNlabel, newname);
	SetValues(name_panel);
	/* get the new size of the name_panel */
	FirstArg(XtNwidth, &namwid);
	GetValues(name_panel);
	MSGPANEL_WD = 350-namwid;
	/* resize the message panel to fit with the new width of the name panel */
	FirstArg(XtNwidth, MSGPANEL_WD);
	SetValues(msg_panel);
	XtManageChild(msg_panel);
	XtManageChild(name_panel);

	/* now resize the whole form */
	FirstArg(XtNwidth,350);
	SetValues(msg_form);
	XtManageChild(msg_form);
}

/*VARARGS0*/
int put_msg(va_alist) va_dcl
{
    va_list ap;
    char *format;

    va_start(ap);
    format = va_arg(ap, char *);
    vsprintf(prompt, format, ap );
    va_end(ap);
    FirstArg(XtNstring, prompt);
    SetValues(msg_panel);
}

clear_message()
{
    FirstArg(XtNstring, "\0");
    SetValues(msg_panel);
}

/* pour que des boutons du file menu operations 
   aient un help automatique */

static void
file_info_handler(w, client_data, event)
     Widget	w;				/* unused */
     caddr_t	client_data;
     XEvent	*event;
{
  if  (event->type == LeaveNotify ) clear_message();
  else if (event->type == EnterNotify) 
    put_msg("%s", (char *) client_data);
} 

void
FOpAddInfoHandler(widget, message)
Widget widget;
char *message;
{
  XtAddEventHandler(widget,
		    (EventMask) (EnterWindowMask|LeaveWindowMask),
		    False,
		    (XtEventHandler)file_info_handler,
		    (caddr_t) message);
}

