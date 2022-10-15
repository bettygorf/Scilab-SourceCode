
/***********************************************************
Copyright 1987, 1988 by Digital Equipment Corporation, Maynard,
Massachusetts, and the Massachusetts Institute of Technology,
Cambridge, Massachusetts.

                        All Rights Reserved

Permission to use, copy, modify, and distribute this software and its 
documentation for any purpose and without fee is hereby granted, 
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in 
supporting documentation, and that the names of Digital or MIT not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.  

DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

******************************************************************/


/* main.c */
#include "version.h"
#include "../machine.h"
#include "x_ptyx.h"
#include "x_data.h"
#include "x_error.h"
#include "x_menu.h"
#include <X11/StringDefs.h>
#include <X11/Shell.h>

#include <X11/Xos.h>
#include <X11/cursorfont.h>
#include <X11/Xaw/SimpleMenu.h>
#include <pwd.h>
#include <ctype.h>
#include <sys/ioctl.h>
#include <sys/stat.h>

#ifdef USE_TERMIOS
#include <termios.h>
/* this hacked termios support only works on SYSV */
#define USE_SYSV_TERMIO
#define termio termios
#undef TCGETA
#define TCGETA TCGETS
#undef TCSETA
#define TCSETA TCSETS
#else /* USE_TERMIOS */
#ifdef SYSV
#include <sys/termio.h>
#endif /* SYSV */
#endif /* USE_TERMIOS else */


#ifndef SYSV				/* BSD systems */
/* #include <sgtty.h> */
#include <sys/resource.h>
#endif	/* !SYSV */


#include <stdio.h>
#include <errno.h>

#include <sys/param.h>	/* for NOFILE */

#ifdef  PUCC_PTYD
#include <local/openpty.h>
int	Ptyfd;
#endif /* PUCC_PTYD */


#ifndef X_NOT_POSIX
#include <unistd.h>
#else
extern long lseek();
#ifdef USG
extern unsigned sleep();
#else
extern void sleep();
#endif
#endif

#ifndef X_NOT_STDC_ENV
#include <stdlib.h>
#else
extern char *malloc();
extern char *calloc();
extern char *realloc();
extern char *getenv();
extern void exit();
#endif

#if defined(macII) && !defined(__STDC__)  /* stdlib.h fails to define these */
char *malloc(), *realloc(), *calloc();
#endif /* macII */


extern char *strindex ();
extern void HandlePopupMenu();

char *ProgramName;

Boolean   sunFunctionKeys = False;

static struct _resource {
    char *xterm_name;
    char *icon_geometry;
    char *title;
    char *icon_name;
    char *term_name;
    char *tty_modes;
    Boolean noWindow;
    Boolean noStartup;
    Boolean useInsertMode;
} resource;

/* used by VT (charproc.c) */

#define offset(field)	XtOffsetOf(struct _resource, field)

 XtResource application_resources[] = {
    {"noWindow", "NoWindow", XtRBoolean, sizeof(Boolean),
	offset(noWindow), XtRString, "false"},
    {"noStartup", "NoStartup",XtRBoolean, sizeof(Boolean),
	offset(noStartup), XtRString, "false"},
    {"termName", "TermName", XtRString, sizeof(char *),
	offset(term_name), XtRString, (caddr_t) NULL},
    {"name", "Name", XtRString, sizeof(char *),
	offset(xterm_name), XtRString, "xterm"},
    {"iconGeometry", "IconGeometry", XtRString, sizeof(char *),
	offset(icon_geometry), XtRString, (caddr_t) NULL},
    {XtNtitle, XtCTitle, XtRString, sizeof(char *),
	offset(title), XtRString, VERSION},
    {XtNiconName, XtCIconName, XtRString, sizeof(char *),
	offset(icon_name), XtRString, VERSION},
    {"ttyModes", "TtyModes", XtRString, sizeof(char *),
	offset(tty_modes), XtRString, (caddr_t) NULL},
    {"useInsertMode", "UseInsertMode", XtRBoolean, sizeof (Boolean),
        offset(useInsertMode), XtRString, "false"},
};

static char *fallback_resources[] = {
  "Xscilab*SimpleMenu*menuLabel.vertSpace: 100",
  "Xscilab*SimpleMenu*HorizontalMargins: 16",
  "Xscilab*SimpleMenu*Sme.height: 16",
  "Xscilab*SimpleMenu*Cursor: left_ptr",
  "Xscilab*mainMenu.Label:  Main Options (no app-defaults)",
  "Xscilab*vtMenu.Label:  VT Options (no app-defaults)",
  "Xscilab*fontMenu.Label:  VT Fonts (no app-defaults)",
  "Xscilab*VT100.font:		9x15",
  "Xscilab*VT100.font1:		9x13",
  "Xscilab*VT100.saveLines:	1024",
  "Xscilab*VT100.scrollBar:	on",
#include "h_help.ad.h"
    NULL
};

/* Command line options table.  Only resources are entered here...there is a
   pass over the remaining options after XrmParseCommand is let loose. */

static XrmOptionDescRec optionDescList[] = {
{"-geometry",	"*vt100.geometry",XrmoptionSepArg,	(caddr_t) NULL},
{"-tm",		"*ttyModes",	XrmoptionSepArg,	(caddr_t) NULL},
{"-tn",		"*termName",	XrmoptionSepArg,	(caddr_t) NULL},
{"-nw",		"*noWindow", XrmoptionNoArg,	(caddr_t) "on"},
{"-ns",		"*noStartup", XrmoptionNoArg,	(caddr_t) "on"},
};

static struct _options {
  char *opt;
  char *desc;
} options[] = {
{ "-help",                 "print out this message" },
{ "-ns",                   "no startup mode " },
{ "-nw",                   "no window mode " },
{ "-display displayname",  "X server to contact" },
{ "-name string",          "client instance, icon, and title strings" },
{ "-xrm resourcestring",   "additional resource specifications" },
{ "-tm string",            "terminal mode keywords and characters" },
{ NULL, NULL }};

static char *message[] = {
"Options that start with a plus sign (+) restore the default.",
NULL};

static void Syntax (badOption)
    char *badOption;
{
    struct _options *opt;
    int col;

    fprintf (stderr, "%s:  bad command line option \"%s\"\r\n\n",
	     ProgramName, badOption);

    fprintf (stderr, "usage:  %s", ProgramName);
    col = 8 + strlen(ProgramName);
    for (opt = options; opt->opt; opt++) {
	int len = 3 + strlen(opt->opt);	 /* space [ string ] */
	if (col + len > 79) {
	    fprintf (stderr, "\r\n   ");  /* 3 spaces */
	    col = 3;
	}
	fprintf (stderr, " [%s]", opt->opt);
	col += len;
    }

    fprintf (stderr, "\r\n\nType %s -help for a full description.\r\n\n",
	     ProgramName);
    exit (1);
}

static void Help ()
{
    struct _options *opt;
    char **cpp;

    fprintf (stderr, "usage:\n        %s [-options ...] \n\n",
	     ProgramName);
    fprintf (stderr, "where options include:\n");
    for (opt = options; opt->opt; opt++) {
	fprintf (stderr, "    %-28s %s\n", opt->opt, opt->desc);
    }
    putc ('\n', stderr);
    for (cpp = message; *cpp; cpp++) {
	fputs (*cpp, stderr);
	putc ('\n', stderr);
    }
    putc ('\n', stderr);
    exit (0);
}

extern WidgetClass xtermWidgetClass;

Arg ourTopLevelShellArgs[] = {
	{ XtNallowShellResize, (XtArgVal) TRUE },	
	{ XtNinput, (XtArgVal) TRUE },
};
int number_ourTopLevelShellArgs = 2;
	
XtAppContext app_con;
Widget toplevel = (Widget) NULL;

extern void do_hangup();
extern void do_kill();

/*
 * DeleteWindow(): Action proc to implement ICCCM delete_window.
 */
/* ARGSUSED */
void
DeleteWindow(w, event, params, num_params)
    Widget w;
    XEvent *event;
    String *params;
    Cardinal *num_params;
{
  do_kill(w);
}

/* ARGSUSED */
void
KeyboardMapping(w, event, params, num_params)
    Widget w;
    XEvent *event;
    String *params;
    Cardinal *num_params;
{
    switch (event->type) {
       case MappingNotify:
	  XRefreshKeyboardMapping(&event->xmapping);
	  break;
    }
}

XtActionsRec actionProcs[] = {
    "DeleteWindow", DeleteWindow,
    "KeyboardMapping", KeyboardMapping,
};


/* used by scilab to know the dpy and toplevel */

int Xscilab(dpy,topwid)
     Display **dpy;
     Widget *topwid;
{
  *topwid=toplevel;
  if ( toplevel != (Widget) NULL) *dpy=XtDisplay(toplevel);
  return(1);
};


Atom wm_delete_window;

/* For Fortran call */

/**********************************************************************/
static void
strip_blank(source)
     char *source;
{
   char *p;
   p = source;
   /* look for end of string */
   while(*p != '\0') p++;
   while(p != source) {
      p--;
      if(*p != ' ') break;
      *p = '\0';
   }
};

C2F(mainsci) (pname,nos,now,idisp,display,dummy1,dummy2)
     int *nos,*now,*idisp;
     long int dummy1,dummy2;
     char display[];
     char pname[];
{
  char *argv[10];
  int argc=1;
  strip_blank(pname);
  argv[0]=pname;
  if ( *idisp == 1) 
    {
      argv[argc++]="-display";
      strip_blank(display);argv[argc++]=display;
    };
  if ( *nos == 1) 
      argv[argc++]="-ns";
  if ( *now == 1) 
      argv[argc++]="-nw";
  if ( *now == 1) 
    {
      C2F(scilab)(nos);
      exit(0);
    }
  main_sci(argc,argv);
};

main_sci(argc, argv)
     int argc;
     char **argv;
{
  int nostartup=0;
  XtermWidget CreateSubWindows();
  register TScreen *screen;
  register int i, pty;
  int Xsocket, mode;
  int xerror(), xioerror();
  ProgramName = argv[0];
  /* Init the Toolkit. */
  toplevel = XtAppInitialize (&app_con, "Xscilab", 
			      optionDescList, XtNumber(optionDescList), 
			      &argc, argv, fallback_resources, NULL, 0);
  XtGetApplicationResources(toplevel, (XtPointer) &resource,
			    application_resources,
			    XtNumber(application_resources), NULL, 0);

  XtAppAddActions(app_con, actionProcs, XtNumber(actionProcs));
  SetXsciOn();
  xterm_name = resource.xterm_name;
  if (strcmp(xterm_name, "-") == 0) xterm_name = "xterm";
  XtSetValues (toplevel, ourTopLevelShellArgs,  number_ourTopLevelShellArgs);
  /* Parse the rest of the command line */
  for (argc--, argv++ ; argc > 0 ; argc--, argv++) 
    {
      if(**argv != '-') Syntax (*argv);
      switch(argv[0][1]) {
      case 'h':
	Help ();
	/* NOTREACHED */
      default:
	Syntax (*argv);
      }
      break;
    };
  XawSimpleMenuAddGlobalActions (app_con);
  XtRegisterGrabAction (HandlePopupMenu, True,
			(ButtonPressMask|ButtonReleaseMask),
			GrabModeAsync, GrabModeAsync);
  term = CreateSubWindows(toplevel);
  screen = &term->screen;
  if (screen->savelines < 0) screen->savelines = 0;
  term->flags = 0;
  if (!screen->jumpscroll) {
    term->flags |= SMOOTHSCROLL;
    update_jumpscroll();
  }
  if (term->misc.reverseWrap) {
    term->flags |= REVERSEWRAP;
    update_reversewrap();
  }
  if (term->misc.autoWrap) {
    term->flags |= WRAPAROUND;
    update_autowrap();
  }
  if (term->misc.re_verse) {
    term->flags |= REVERSE_VIDEO;
    update_reversevideo();
  }
  
  term->initflags = term->flags;
  
  if (term->misc.appcursorDefault) {
    term->keyboard.flags |= CURSOR_APL;
    update_appcursor();
  }
  
  if (term->misc.appkeypadDefault) {
    term->keyboard.flags |= KYPD_APL;
    update_appkeypad();
  }
  
  /* open a terminal for client */
  screen->arrow = make_colored_cursor (XC_left_ptr, 
				       screen->mousecolor,
				       screen->mousecolorback);

  /* avoid double MapWindow requests */
  XtSetMappedWhenManaged( XtParent(term), False );
  wm_delete_window = XInternAtom(XtDisplay(toplevel),"WM_DELETE_WINDOW",False);
  VTInit1(toplevel);
  Xsocket = ConnectionNumber(screen->display);
  pty = screen->respond;
  mode = 1;
  pty_mask = 1 << pty;
  X_mask = 1 << Xsocket;
  Select_mask = pty_mask | X_mask;
  max_plus1 = (pty < Xsocket) ? (1 + Xsocket) : (1 + pty); 
  XSetErrorHandler(xerror);
  XSetIOErrorHandler(xioerror);
  signal(SIGINT,do_kill);
  signal(SIGKILL,do_kill);
  {
    VTRun(nostartup);
  }
}

Exit(n)
	int n;
{
  exit(n);
}

int GetBytesAvailable (fd)
    int fd;
{
#ifdef FIONREAD
    static long arg;
    ioctl (fd, FIONREAD, (char *) &arg);
    return (int) arg;
#else
    struct pollfd pollfds[1];

    pollfds[0].fd = fd;
    pollfds[0].events = POLLIN;
    return poll (pollfds, 1, 0);
#endif
}

/* Utility function to try to hide system differences from
   everybody who used to call killpg() */

int
kill_process_group(pid, sig)
    int pid;
    int sig;
{
    return kill (-pid, sig);
}

