#include "../machine.h"

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>
#include <X11/Xos.h>
#include <ctype.h>
#include <errno.h>
#include <stdio.h>

#ifdef aix
#include <sys/select.h>
#endif

#define NUMCOLORS 17

typedef struct res {
    Pixel color[NUMCOLORS];
} RES, *RESPTR;

RES the_res;

static XtResource app_resources[] = {
    {"color0", "Color0", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[0]), XtRString, (caddr_t) "black"},
    {"color1","color1", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[1]), XtRString, (caddr_t) "navyblue"},
    {"color2","color2", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[2]), XtRString, (caddr_t) "blue"},
    {"color3","color3", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[3]), XtRString, (caddr_t) "skyblue"},
    {"color4","color4", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[4]), XtRString, (caddr_t) "aquamarine"},
    {"color5","color5", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[5]), XtRString, (caddr_t) "forestgreen"},
    {"color6","color6", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[6]), XtRString, (caddr_t) "green"},
    {"color7","color7", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[7]), XtRString, (caddr_t) "lightcyan"},
    {"color8","color8", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[8]), XtRString, (caddr_t) "cyan"},
    {"color9","color9", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[9]), XtRString, (caddr_t) "orange"},
    {"color10","color10", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[10]), XtRString, (caddr_t) "red"},
    {"color11","color11", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[11]), XtRString, (caddr_t) "magenta"},
    {"color12","color12", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[12]), XtRString, (caddr_t) "violet"},
    {"color13","color13", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[13]), XtRString, (caddr_t) "yellow"},
    {"color14","color14", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[14]), XtRString, (caddr_t) "gold"},
    {"color15","color15", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[15]), XtRString, (caddr_t) "beige"},
    {"color16","color16", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[16]), XtRString, (caddr_t) "white"},
};


XtAppContext app_con;

static String bgfallback_resources[] = {
#include "../xsci/Xscilab.ad.h"
    NULL,
  };

/** do i want a scilab or an xscilab */

static int INXscilab=0;

int SetXsciOn()
{
  INXscilab=1;
}

C2F(xscion)(i)
     int *i;
{
  *i=INXscilab;
}

#define   ERROR_SELECT    50 

static int pty_mask = 1 ;
static int X_mask =16 ;
static int Select_mask ;
static int select_mask = 0;
static int write_mask = 2;
static int Write_mask = 2;
static int max_plus1 =5;
static Display *the_dpy = (Display *) NULL;
static int BasicScilab = 1 ;


/**  Display Init : initialyze only Once  **/

DisplayInit(string,dpy,toplevel)
     Display **dpy;
     Widget *toplevel;
     char *string;
{
  static XrmOptionDescRec *optionDescList = NULL;
  static Display *dpy1;
  static Widget toplevel1;
  static int count=0;
  int argc=0;
  char *argv = 0;
  if ( count > 0) 
    {
      *dpy=dpy1;
      *toplevel=toplevel1;
      return;
    }
  count++;
  Xscilab(dpy,toplevel);
  if ( *toplevel != (Widget) NULL)
    {
      toplevel1 = *toplevel;
      dpy1 = *dpy;
      XtGetApplicationResources(toplevel1, &the_res, app_resources,
			    XtNumber(app_resources), NULL, 0);
    }
  else
    {
      int Xsocket,pty=0,fd ;
      *toplevel=toplevel1=XtAppInitialize (&app_con,"Xscilab",optionDescList,
				       0,&argc, (String *)argv,
				       bgfallback_resources, NULL, 0);
      XtGetApplicationResources(toplevel1, &the_res, app_resources,
			    XtNumber(app_resources), NULL, 0);
      the_dpy = *dpy=dpy1=XtDisplay(toplevel1);
      BasicScilab = 0;
      Xsocket = ConnectionNumber(dpy1);
      X_mask = 1 << Xsocket;
      fd = fileno(stdin) ;
      pty_mask = 1   << fd;
      Select_mask = pty_mask | X_mask;  
      Write_mask = 1 << fileno(stdout);
      max_plus1 = (fd < Xsocket) ? (1 + Xsocket) : (1 + fd);
    }
  XSync(dpy1,0);
  /** xutl_(*dpy); **/
}

/*****************
Remarque : cette fonction est appelles par la fonction au dessus 
je m'en sert sur sun pour generer le tableau postscript qui decrit 
les couleurs X11 utilisees puis ce tableau a ete mis de facon permanente 
dans NperiPos.pos et la fonction ColorInit de periPos.c commentee 
ainsi on peut genere de la couleur sur une machine noir et blanc 
et l'appel a xutl et recomente car il fait parfois planter 

********************/

typedef  struct {
  float  r,g,b;} TabC;

TabC tabc[NUMCOLORS];

xutl_(dpy)
     Display *dpy;
{
  Screen   *scr;      
  int  status,i;
  XColor xcolor;
  scr = DefaultScreenOfDisplay(dpy);
  for (i=0 ; i < NUMCOLORS ; i++)
    {
      xcolor.pixel = the_res.color[i];
      XQueryColor(dpy, DefaultColormapOfScreen(scr), &xcolor);
      tabc[i].r = (int)xcolor.red / 65535.0   ;
      tabc[i].g = (int)xcolor.green / 65535.0 ;
      tabc[i].b = (int)xcolor.blue /  65535.0 ;
  }
}

/* 
 * zzledt is used while in the scilab -nw mode 
 * Xorgetchar is called by zzledt 
 * xevents is called by Xorgetchar and also by DispatchEvents in 
 * routines/system 
 * xevents must work for scilab and scilab -nw 
 * Xorgetchar : This routine reads one char on stdin 
 * but checks while waiting for that char for X11events 
 * stdin is supposed to be changed 
 * so as not to wait for <cr> this is done inside zzledt 
 * (in the following code  the key function is select )
 */

int Xorgetchar()
{
  int bcnt,ii;
  register int i;
  static struct timeval select_timeout;
  if ( BasicScilab) return(getchar());
  for( ; ; ) {
	XFlush(the_dpy); /* always flush writes before waiting */
	/* Update the masks and, unless X events are already in the queue,
	   wait for I/O to be possible. */
	select_mask = Select_mask;
	write_mask  = Write_mask;
	select_timeout.tv_sec = 1;
	select_timeout.tv_usec = 0;
	i = select(max_plus1, (fd_set *)&select_mask, (fd_set *) &write_mask, (fd_set *)NULL,
		   QLength(the_dpy) ? &select_timeout
		   : (struct timeval *) NULL);
	if (i < 0) {
	    if (errno != EINTR)
	      		  { 
			    Scistring("Error\n");
			    exit(0);/* SysError(ERROR_SELECT); */
			    continue;
			  }
	} 
	if (write_mask & Write_mask) {	  fflush(stdout);}

	/* if there's something to read */

	if (select_mask & pty_mask ) {
	    return(getchar());
	    break;
	  }

	/* if there are X events already in our queue, it
	   counts as being readable */
	if (QLength(the_dpy) || (select_mask & X_mask)) 
	  { C2F(xevents)();	}
    }
}

/** Dealing with X11 Events on the queue **/

C2F(xevents)()
{
  if (INXscilab==1) 
    {
      xevents1();
    }
  else 
    {
      XEvent event;
      if (BasicScilab) return;
      if ( the_dpy == (Display *) NULL)  return;
      if (!XPending (the_dpy))
	/* protect against events/errors being swallowed by us or Xlib */
	return;
      do {
	XNextEvent (the_dpy, &event);
	XtDispatchEvent(&event);
      } while (QLength(the_dpy) > 0);
    }
}

/** Dealing with X11 Events on the queue when computing in Scilab **/
C2F(sxevents)()
{
  if (INXscilab==1) 
    {
      xevents1();
    }
  else 
    {
      XEvent event;
      if (BasicScilab) return;
      if ( the_dpy == (Display *) NULL)  return;
      if (!XPending (the_dpy))
	/* protect against events/errors being swallowed by us or Xlib */
	return;
      do {
	XNextEvent (the_dpy, &event);
	XtDispatchEvent(&event);
      } while (QLength(the_dpy) > 0);
    }
}
