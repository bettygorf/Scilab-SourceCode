/*------------------------------BEGIN--------------------------------------
%    Missile 
%    XWindow and Postscript library for 2D and 3D plotting 
%    Copyright (C) 1990 Chancelier Jean-Philippe
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 1, or (at your option)
%    any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
%
%    jpc@arletty.enpc.fr 
%    Phone : 43.04.40.98 poste : 3327 
%
--------------------------------------------------------------------------*/

/*----------------------------------------------------------------------
 \def\encadre#1{\paragraph{}\fbox{\begin{minipage}[t]{15cm}#1 \end{minipage}}}
 \section{X11 Driver}
----------------------------------------------------------------------------*/


#include <stdio.h>
#include <string.h>
#include <math.h>

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>

#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif
#include "Math.h"
#include "periX11.h"
#include "version.h"


#define MESSAGE4 "Can't allocate point vector"
#define MESSAGE5 "Can't re-allocate point vector" 
#define Char2Int(x)   ( x & 0x000000ff )

/** Global variables to deal with X11 **/

static GC gc;
static int screencolor = 0 ; /* default screen color or not : see initgraphic_ */
static Cursor arrowcursor,normalcursor,crosscursor;

static Drawable Cdrawable = (Drawable) NULL;
static Widget CinfoW = (Widget ) NULL ;
static Window CWindow =(Window) NULL ,root=(Window) NULL;
static Window CBGWindow=(Window) NULL ;
static int CurWindow = 0;
static Display *dpy = (Display *) NULL;
static unsigned long foreground, background;
static int ResetScilabXgc ();

#define NUMCOLORS 17

typedef struct res {
    Pixel color[NUMCOLORS];
} RES, *RESPTR;

extern RES the_res;

/** Structure to keep the graphic state  **/
struct BCG 
{ 
   int FontSize ;
   int FontId ;
   XID FontXID;
   int CurHardSymb;
   int CurHardSymbSize;
   int CurLineWidth;
   int CurPattern;
   int CurColor;
   int CurPixmapStatus;
   int IDWhitePattern;
   int CurVectorStyle;
   int CurDrawFunction;
   int ClipRegionSet;
   int CurClipRegion[4];
   int CurDashStyle;
   char CurNumberDispFormat[20];
   int CurColorStatus;
}  MissileXgc ;

struct BCG *ScilabXgc = (struct BCG *) 0;

Window Find_X_Scilab();
Window Find_BG_Window();
Window Find_ScilabGraphic_Window();

Drawable GetPixmapNumber_();
Window GetWindowNumber_();
Window GetBGWindowNumber_();
Widget GetInfoNumber_();


static  int LoadFonts();
static  int LoadSymbFonts();

/** Pixmap routines **/

static int depth;

pixmapclear_(v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{
  XWindowAttributes war;
  XSetForeground(dpy,gc,background);
  XGetWindowAttributes(dpy,CWindow,&war); 
  XFillRectangle(dpy, Cdrawable, gc, 0, 0, (unsigned)war.width,(unsigned)war.height);
  XSetForeground(dpy,gc,foreground);
}

show_(v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{
   XClearWindow(dpy,CWindow);
   XFlush(dpy);
}


/** ResiZe the pixmap associated to CWindow and store it back in the window List **/

CPixmapResize(x,y)
     int x,y;
{
  XFreePixmap(dpy,(Pixmap) Cdrawable);
  Cdrawable = (Drawable) XCreatePixmap(dpy, root,Max(x,400),Max(y,300),depth);
  SetPixmapNumber_(Cdrawable,(integer)CurWindow);
  XSetForeground(dpy,gc,background);
  XFillRectangle(dpy, Cdrawable, gc, 0, 0,(unsigned)Max(x,400),(unsigned)Max(y,300));
  XSetForeground(dpy,gc,foreground);
  XSetWindowBackgroundPixmap(dpy, CWindow, (Pixmap) Cdrawable);
}

/* Resize the Pixmap according to window size change 
   But only if there's a pixmap 
   */

CPixmapResize1()
{
  XWindowAttributes war;
  if (Cdrawable != (Drawable) CWindow ) 
    {
      XGetWindowAttributes(dpy,CWindow,&war); 
      CPixmapResize(war.width,war.height);
    }
}


/*-----------------------------------------------------
\encadre{General routines}
-----------------------------------------------------*/

/** To select (raise on the screen )the current graphic Window  **/
/** If there's no graphic window then select creates one **/

xselgraphic_(v1,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4) 
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;

{ 
  if (CBGWindow == (Window ) NULL) 
    initgraphic_("",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  XMapWindow(dpy,CBGWindow);
  XRaiseWindow(dpy,CBGWindow);
  XFlush(dpy);
}

/** End of graphic (do nothing)  **/

xendgraphic_()
{
} 

xend_(v1,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *v1;
     integer  *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  /** Must destroy everything  **/
}

/** Clear the current graphic window     **/

clearwindow_(v1,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4) 
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  if (Cdrawable != (Drawable) CWindow ) pixmapclear_(PI0,PI0,PI0,PI0);
  XClearWindow(dpy, CWindow);
  XFlush(dpy);
}

/*-----------------------------------------------------------
 \encadre{To generate a pause, in seconds}
------------------------------------------------------------*/

#if defined (sparc) && defined(__STDC__)
#define usleep(x) x
#endif 

xpause_(str,sec_time,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *sec_time,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ 
#ifdef hpux
#include <unistd.h>
#endif
  unsigned useconds;
  useconds=(unsigned) *sec_time;
  if (useconds != 0)  
#ifdef sun
      usleep(useconds);
#else
#ifdef hpux
  sleep(useconds/1000000);
#else
    return;
#endif
#endif

}

/****************************************************************
 Wait for mouse click in graphic window 
   send back mouse location  (x1,y1)  and button number  
   0,1,2}
   There's just a pb if the window is iconified when we try to click 
   in this case we return i= -1
****************************************************************/


xclick_(str,ibutton,x1,yy1,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *ibutton,*x1,*yy1,*v5,*v6,*v7 ;
     double *dv1,*dv2,*dv3,*dv4;
{
  XEvent event;
  Bool flag1=True;
  integer buttons = 0;
  /* Recenter_GW_(); */
  /*  remove the previous click events on the queue */
  /*  This is not so useful any more since the specified events are treated
      by EventProc outside xclick_
      */

  while (flag1) 
    flag1= XCheckWindowEvent(dpy,CWindow,KeyPressMask| ButtonPressMask,&event);
  XDefineCursor(dpy, CWindow ,crosscursor);
  while (buttons == 0) {
    XNextEvent (dpy, &event);
    if ( event.xany.window == CWindow && event.type ==  ButtonPress ) 
      {
	*x1=event.xbutton.x;
	*yy1=event.xbutton.y;
	*ibutton=event.xbutton.button-1;
	buttons++;
	break;
      }
    else 
      {
	XtDispatchEvent(&event);
      }
  }
  XDefineCursor(dpy, CWindow ,arrowcursor);
  XSync (dpy, 0);
}


xclick_any_(str,ibutton,x1,yy1,iwin,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *iwin,*ibutton,*x1,*yy1,*v6,*v7 ;
     double *dv1,*dv2,*dv3,*dv4;
{
  Window CW;
  XEvent event;
  Bool flag1;
  int buttons = 0;
  integer i;
  integer wincount = 0;
  
  flag1=True;
  while (flag1) {
      CW=GetWindowNumber_(wincount);
      if (CW!=(Window ) NULL) {
	  wincount++;
	  XDefineCursor(dpy, CW ,crosscursor);
      }
      else
	  flag1=False;
  }
  while (buttons == 0) {
      XNextEvent (dpy, &event);
      if ( event.type ==  ButtonPress ) {
	  for (i=0;i < wincount;i++) {
	      CW=GetWindowNumber_(i);
	      if ( event.xany.window == CW) {
		  *x1=event.xbutton.x;
		  *yy1=event.xbutton.y;
		  *ibutton=event.xbutton.button-1;
		  buttons++;
		  *iwin=i;
		  break;
	      }
	      else 
		  XtDispatchEvent(&event);
	  }
      }
      else 
	  XtDispatchEvent(&event);

  }
  for (i=0;i < wincount;i++) {
      CW=GetWindowNumber_(i);
      XDefineCursor(dpy, CW ,arrowcursor);
  }
  XSync (dpy, 0);
}

/* version test qui gere les press et release */

xgetmouse_test(str,ibutton,x1,yy1,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *ibutton,*x1,*yy1 ,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  XEvent event;
  integer buttons = 0;
  /** The EventProc Handler un SGraph.c keep the queue empty 
  Bool flag1=True;
  while (flag1) 
    flag1= XCheckWindowEvent(dpy,CWindow,
			     ButtonReleaseMask| ButtonPressMask | PointerMotionMask,&event);
  **/
  XDefineCursor(dpy, CWindow ,crosscursor);
  while (buttons == 0) {
    XNextEvent (dpy, &event); 
    if ( event.xany.window == CWindow && event.type ==  ButtonPress ) 
      {
	*x1=event.xbutton.x;
	*yy1=event.xbutton.y;
	*ibutton= (event.xbutton.button-1);
	buttons++;
      }
    else if ( event.xany.window == CWindow && event.type ==  MotionNotify ) 
      {
	*x1=event.xbutton.x;
	*yy1=event.xbutton.y;
	*ibutton = -1;
	buttons++;
      }
    else if ( event.xany.window == CWindow && event.type ==  ButtonRelease ) 
      {
	*x1=event.xbutton.x;
	*yy1=event.xbutton.y;
	*ibutton = (event.xbutton.button-1)+3;
	buttons++;
      }
    else      XtDispatchEvent(&event);
  }
  XDefineCursor(dpy, CWindow ,arrowcursor);
  XSync (dpy, 0);
}

xgetmouse_(str,ibutton,x1,yy1,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *ibutton,*x1,*yy1 ,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  XEvent event;
  Bool flag1=True;
  integer buttons = 0;
  XDefineCursor(dpy, CWindow ,crosscursor);
  /** KeyPressMask| ButtonPressMask | ButtonRelease | not so useful **/
  while (flag1) 
    flag1= XCheckWindowEvent(dpy,CWindow, PointerMotionMask,&event);
  while (buttons == 0) {
    XNextEvent (dpy, &event); 
    if ( event.xany.window == CWindow && event.type ==  ButtonPress ) 
	  {
	      *x1=event.xbutton.x;
	      *yy1=event.xbutton.y;
	      *ibutton=event.xbutton.button-1;
	      buttons++;
	  }
    else if ( event.xany.window == CWindow && event.type ==  MotionNotify ) 
      {
	*x1=event.xbutton.x;
	*yy1=event.xbutton.y;
	*ibutton = -1;
	buttons++;
      }
    else      XtDispatchEvent(&event);
  }
  XDefineCursor(dpy, CWindow ,arrowcursor);
  XSync (dpy, 0);
}


/*------------------------------------------------
  \encadre{Clear a rectangle }
-------------------------------------------------*/

cleararea_(str,x,y,w,h,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *x,*y,*w,*h,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  XClearArea(dpy,Cdrawable,(int)*x,(int) *y,(unsigned) *w,(unsigned) *h,False);
  XFlush(dpy);
}

/*---------------------------------------------------------------------
\section{moves graphic window for it to be inside the root window}
------------------------------------------------------------------------*/

Recenter_GW_()
{
  int ul[2],x,y;
  Window CHR;
  XWindowAttributes war,war1;
  XGetWindowAttributes(dpy,CBGWindow,&war); 
  XTranslateCoordinates(dpy,CBGWindow,root,war.x,war.y,&(ul[0]),&(ul[1]),&CHR);
  XGetWindowAttributes(dpy,root,&war1);
  x=Max(ul[0],0);y=Max(ul[1],0);
  if ( ul[0]+war.width > war1.width )
      x=Max(0, war1.width-war.width);
  if ( ul[1]+war.height > war1.height)
      y=Max(0, war1.height -war.height);
  if ( x != ul[0] || y != ul[1])
    XMoveWindow(dpy,CBGWindow,x,y);
}

/*---------------------------------------------------------------------
\section{Function for graphic context modification}
------------------------------------------------------------------------*/

/** to get the window upper-left point coordinates on the screen  **/

getwindowpos_(verbose,x,narg)
     integer *verbose,*x,*narg;
{
  int xx[2];
  XWindowAttributes war;
  Window CHR;
  *narg = 2;
  XGetWindowAttributes(dpy,CBGWindow,&war); 
  XTranslateCoordinates(dpy,CBGWindow,root,war.x,war.y,&(xx[0]),&(xx[1]),&CHR);
  x[0]=xx[0];x[1]=xx[1];
  if (*verbose == 1) 
    sciprint("\n CWindow position :%d,%d\r\n",xx[0],xx[1]);
}

/** to set the window upper-left point position on the screen **/

setwindowpos_(x,y,v3,v4)
     integer *x,*y,*v3,*v4;
{
  if (CBGWindow == (Window) NULL) 
    initgraphic_("",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  XMoveWindow(dpy,CBGWindow,(int) *x,(int) *y);
}

/** To get the window size **/
static int CWindowWidth=600;
static int CWindowHeight=400;

getwindowdim_(verbose,x,narg)
     integer *verbose,*x,*narg;
{     
  /* we directly trteun the current values which are fixed by setcurwin 
  XWindowAttributes war;
  *narg = 2;
  XGetWindowAttributes(dpy,CWindow,&war); 
  x[0]= war.width;
  x[1]= war.height;
  */
  *narg = 2;
  x[0]= CWindowWidth;
  x[1]= CWindowHeight;
  if (*verbose == 1) 
    sciprint("\n CWindow dim :%d,%d\r\n",(int) x[0],(int) x[1]);
} 

/** To change the window size  **/

setwindowdim_(x,y,v3,v4)
     integer *x,*y,*v3,*v4;
{
  if (CBGWindow != (Window) NULL) 
    {
      CWindowWidth = Max((int) *x,400);
      CWindowHeight =Max((int) *y,300);
      XResizeWindow(dpy,CBGWindow,CWindowWidth, CWindowHeight);
      if (Cdrawable != (Drawable) CWindow ) CPixmapResize(CWindowWidth, CWindowHeight);
    }
  XFlush(dpy);
}

/** To select a graphic Window  **/
/* Attention :  on ne fait rien si c'est deja la fenetre courante */

setcurwin_(intnum,v2,v3,v4)
     integer *intnum;
     integer *v2,*v3,*v4;
{ 
  if ( CurWindow != *intnum || CWindow == (Window) NULL )
    {
      MenuFixCurrentWin(*intnum);
      CWindow = GetWindowNumber_(*intnum);
      if ( CWindow != (Window) NULL) 
	{
	  CBGWindow = GetBGWindowNumber_(*intnum);
	  Cdrawable = GetPixmapNumber_(*intnum); 
	  CinfoW =  GetInfoNumber_(*intnum);
	  /* getting back the window graphic context */
	  GetWindowXgcNumber_(*intnum);
	  /* update the Xwindow gc  */
	  ResetScilabXgc ();
	  CurWindow = *intnum;
	  if (Cdrawable != (Drawable) CWindow ) ScilabXgc->CurPixmapStatus = 1;
	}
    }
  if (CWindow == (Window ) NULL)
    {
      integer i;
      initgraphic_("",intnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
    }
  if (CWindow != (Window) NULL)
    {
      XWindowAttributes war;
      XGetWindowAttributes(dpy,CWindow,&war); 
      CWindowWidth = war.width;
      CWindowHeight = war.height;
    }
  GetScaleWindowNumber_( *intnum);
}

/** Get the id number of the Current Graphic Window **/

getcurwin_(verbose,intnum,narg)
     integer *verbose,*intnum,*narg;
{
  *narg =1 ;
  *intnum = CurWindow ;
  if (*verbose == 1) 
    sciprint("\nCurrent Graphic Window :%d\r\n",(int) *intnum);
}

/** Set a clip zone (rectangle ) **/

setclip_(x,y,w,h)
     integer *x,*y,*w,*h;
{
  integer verbose=0,wd[2],narg;
  XRectangle rects[1];
  ScilabXgc->ClipRegionSet = 1;
  getwindowdim_(&verbose,wd,&narg);
  rects[0].x= *x;
  rects[0].y= *y;
  rects[0].width= *w;
  rects[0].height= *h;
  ScilabXgc->CurClipRegion[0]= rects[0].x;
  ScilabXgc->CurClipRegion[1]= rects[0].y;
  ScilabXgc->CurClipRegion[2]= rects[0].width;
  ScilabXgc->CurClipRegion[3]= rects[0].height;
  XSetClipRectangles(dpy,gc,0,0,rects,1,Unsorted);
}

/** unset clip zone **/

unsetclip_(v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{
  ScilabXgc->ClipRegionSet = 0;
  XSetClipMask(dpy,gc,None);
}

/** Get the boundaries of the current clip zone **/

getclip_(verbose,x,narg)
     integer *verbose,*x,*narg;
{
  x[0] = ScilabXgc->ClipRegionSet;
  if ( x[0] == 1)
    {
      *narg = 5;
      x[1] =ScilabXgc->CurClipRegion[0];
      x[2] =ScilabXgc->CurClipRegion[1];
      x[3] =ScilabXgc->CurClipRegion[2];
      x[4] =ScilabXgc->CurClipRegion[3];
    }
  else *narg = 1;
  if (*verbose == 1)
    if (ScilabXgc->ClipRegionSet == 1)
      sciprint("\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d\r\n",
	      ScilabXgc->CurClipRegion[0],
	      ScilabXgc->CurClipRegion[1],
	      ScilabXgc->CurClipRegion[2],
	      ScilabXgc->CurClipRegion[3]);
    else 
      Scistring("\nNo Clip Region");
}

/*----------------------------------------------------------
  \encadre{For the drawing functions dealing with vectors of 
  points, the following routine is used to select the mode 
  absolute or relative }
  Absolute mode if *num==0, relative mode if *num != 0
------------------------------------------------------------*/
/** to set absolute or relative mode **/

setabsourel_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{
  if (*num == 0 )
    ScilabXgc->CurVectorStyle =  CoordModeOrigin;
  else 
    ScilabXgc->CurVectorStyle =  CoordModePrevious ;
}

/** to get information on absolute or relative mode **/

getabsourel_(verbose,num,narg)
     integer *verbose,*num,*narg;
{
  *narg = 1;
  *num = ScilabXgc->CurVectorStyle  ;
  if (*verbose == 1) 
    if (ScilabXgc->CurVectorStyle == CoordModeOrigin)
      Scistring("\nTrace Absolu");
    else 
      Scistring("\nTrace Relatif");
}

/** The alu function for drawing : Works only with X11 **/
/** Not in Postscript **/
/** All the possibilities : Read The X11 manual to get more informations **/

static struct alinfo { 
  char *name;
  char id;
  char *info;} AluStruc_[] =
{ 
  "GXclear" ,GXclear," 0 ",
  "GXand" ,GXand," src AND dst ",
  "GXandReverse" ,GXandReverse," src AND NOT dst ",
  "GXcopy" ,GXcopy," src ",
  "GXandInverted" ,GXandInverted," NOT src AND dst ",
  "GXnoop" ,GXnoop," dst ",
  "GXxor" ,GXxor," src XOR dst ",
  "GXor" ,GXor," src OR dst ",
  "GXnor" ,GXnor," NOT src AND NOT dst ",
  "GXequiv" ,GXequiv," NOT src XOR dst ",
  "GXinvert" ,GXinvert," NOT dst ",
  "GXorReverse" ,GXorReverse," src OR NOT dst ",
  "GXcopyInverted" ,GXcopyInverted," NOT src ",
  "GXorInverted" ,GXorInverted," NOT src OR dst ",
  "GXnand" ,GXnand," NOT src OR NOT dst ",
  "GXset" ,GXset," 1 "};


static idfromname(name1,num)
     char name1[];
     integer *num;
{int i;
 *num = -1;
 for ( i =0 ; i < 16;i++)
   if (strcmp(AluStruc_[i].name,name1)== 0) 
     *num=AluStruc_[i].id;
 if (*num == -1 ) 
   {
     Scistring("\n Use the following keys (integer in scilab");
     for ( i=0 ; i < 16 ; i++)
       sciprint("\nkey %s   -> %s\r\n",AluStruc_[i].name,
	       AluStruc_[i].info);
   }
}

setalufunction_(string)
     char string[];
{     
  integer value;
  XGCValues gcvalues;
  idfromname(string,&value);
  if ( value != -1)
    {ScilabXgc->CurDrawFunction = value;
     gcvalues.function = value;
     XChangeGC(dpy, gc, GCFunction, &gcvalues);
   }
}


setalufunction1_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{     
  integer value;
  XGCValues gcvalues;
  value=AluStruc_[Min(16,Max(0,*num))].id;
  if ( value != -1)
    {
      ScilabXgc->CurDrawFunction = value;
      /* XChangeGC(dpy, gc, GCFunction, &gcvalues); */
      /** Using diff gc **/
      switch (value) 
	{
	case GXclear : 
	  gcvalues.foreground = background;
	  gcvalues.background = background;
	  gcvalues.function = GXcopy;
	  break;
	case GXxor   : 
	  gcvalues.foreground = foreground ^ background;
	  gcvalues.background = background;
	  gcvalues.function = GXxor;break;
	default :
	  gcvalues.foreground = foreground;
	  gcvalues.background = background;
	  gcvalues.function = value;
	  break;
	}
      XChangeGC(dpy,gc,(GCFunction|GCForeground|GCBackground), &gcvalues);
    }
}


getalufunction_(verbose,value,narg)
     integer *verbose , *value ,*narg;
{ 
  *narg =1 ;
  *value = ScilabXgc->CurDrawFunction ;
  if (*verbose ==1 ) 
    { 
      sciprint("\nThe Alufunction is %s -> <%s>\r\n",
	      AluStruc_[*value].name,
	      AluStruc_[*value].info);}
}


/** to set the thickness of lines : 0 is a possible value **/
/** give the thinest line (0 and 1 the same for X11 but   **/
/** with diferent algorithms ) **/
/** defaut value is 1 **/

setthickness_(value,v2,v3,v4)
     integer *value ,*v2,*v3,*v4;
{ 
  XGCValues gcvalues;
  ScilabXgc->CurLineWidth =Max(0, *value);
  gcvalues.line_width = Max(0, *value);
  XChangeGC(dpy, gc, GCLineWidth, &gcvalues); }

/** to get the thickness value **/

getthickness_(verbose,value,narg)
     integer *verbose,*value,*narg;
{
  *narg =1 ;
  *value = ScilabXgc->CurLineWidth ;
  if (*verbose ==1 ) 
    sciprint("\nLine Width:%d\r\n", ScilabXgc->CurLineWidth ) ;
}

/** To set grey level for filing areas **/
/** from black (*num =0 ) to white     **/

#define GREYNUMBER 17
Pixmap  Tabpix_[GREYNUMBER];

static char grey0[GREYNUMBER][8]={
  {(char)0x00, (char)0x00, (char)0x00, (char)0x00, (char)0x00, (char)0x00, (char)0x00, (char)0x00},
  {(char)0x00, (char)0x00, (char)0x44, (char)0x00, (char)0x00, (char)0x00, (char)0x44, (char)0x00},
  {(char)0x00, (char)0x44, (char)0x00, (char)0x22, (char)0x08, (char)0x40, (char)0x01, (char)0x20},
  {(char)0x00, (char)0x92, (char)0x00, (char)0x25, (char)0x00, (char)0x92, (char)0x00, (char)0xa4},
  {(char)0x55, (char)0x00, (char)0xaa, (char)0x00, (char)0x55, (char)0x00, (char)0xaa, (char)0x00},
  {(char)0xad, (char)0x00, (char)0x5b, (char)0x00, (char)0xda, (char)0x00, (char)0x6d, (char)0x00},
  {(char)0x6d, (char)0x02, (char)0xda, (char)0x08, (char)0x6b, (char)0x10, (char)0xb6, (char)0x20},
  {(char)0x6d, (char)0x22, (char)0xda, (char)0x0c, (char)0x6b, (char)0x18, (char)0xb6, (char)0x24},
  {(char)0x55, (char)0xaa, (char)0x55, (char)0xaa, (char)0x55, (char)0xaa, (char)0x55, (char)0xaa},
  {(char)0x92, (char)0xdd, (char)0x25, (char)0xf3, (char)0x94, (char)0xe7, (char)0x49, (char)0xdb},
  {(char)0x92, (char)0xfd, (char)0x25, (char)0xf7, (char)0x94, (char)0xef, (char)0x49, (char)0xdf},
  {(char)0x52, (char)0xff, (char)0xa4, (char)0xff, (char)0x25, (char)0xff, (char)0x92, (char)0xff},
  {(char)0xaa, (char)0xff, (char)0x55, (char)0xff, (char)0xaa, (char)0xff, (char)0x55, (char)0xff},
  {(char)0xff, (char)0x6d, (char)0xff, (char)0xda, (char)0xff, (char)0x6d, (char)0xff, (char)0x5b},
  {(char)0xff, (char)0xbb, (char)0xff, (char)0xdd, (char)0xf7, (char)0xbf, (char)0xfe, (char)0xdf},
  {(char)0xff, (char)0xff, (char)0xbb, (char)0xff, (char)0xff, (char)0xff, (char)0xbb, (char)0xff},
  {(char)0xff, (char)0xff, (char)0xff, (char)0xff, (char)0xff, (char)0xff, (char)0xff, (char)0xff},
};

CreatePatterns_(whitepixel,blackpixel)
     unsigned long whitepixel,blackpixel;
{ integer i ;
  for ( i=0 ; i < GREYNUMBER ; i++)
    Tabpix_[i] =XCreatePixmapFromBitmapData(dpy, root,grey0[i] ,8,8,whitepixel
		     ,blackpixel,XDefaultDepth (dpy,DefaultScreen(dpy)));
}


setpattern_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{ integer i ; 

  if ( ScilabXgc->CurColorStatus == 1 ) 
    {
      i= Max(0,Min(*num,NUMCOLORS-1));
      ScilabXgc->CurColor = i ;
      set_c(i);
    }
  else 
    {
      i= Max(0,Min(*num,GREYNUMBER-1));
      ScilabXgc->CurPattern = i;
      XSetTile (dpy, gc, Tabpix_[i]); 
      if (i ==0)
	XSetFillStyle(dpy,gc,FillSolid);
      else 
	XSetFillStyle(dpy,gc,FillTiled);
    }
}

/** To get the id of the current pattern  **/

getpattern_(verbose,num,narg)
     integer *num,*verbose,*narg;
{ 
  *narg=1;
  if ( ScilabXgc->CurColorStatus == 1 ) 
    *num = ScilabXgc->CurColor ;
  else 
    *num = ScilabXgc->CurPattern ;
  if (*verbose == 1) 
    sciprint("\n Pattern : %d\r\n",ScilabXgc->CurPattern);
}

/** To get the id of the white pattern **/

getwhite_(verbose,num,narg)
     integer *num,*verbose,*narg;
{
  if ( ScilabXgc->CurColorStatus == 1 ) 
    {
      *num = ScilabXgc->IDWhitePattern ;
      if (*verbose == 1) 
	sciprint("\n Id of Last Color %d\r\n",(int)*num);
    }
      
  else 
    {
      *num = ScilabXgc->IDWhitePattern ;
      if (*verbose == 1) 
	sciprint("\n Id of White Pattern %d\r\n",(int)*num);
    }
  *narg=1;
}


/*--------------------------------------
\encadre{Line style }
---------------------------------------*/

/**  use a table of dashes and set default X11-dash style to **/
/**  one of the possible value. value points **/
/**  to a strictly positive integer **/
/**  if *value == 0 -> Solid line   **/
/**  else Dashed Line **/

static integer DashTab[6][4] = {
  {2,5,2,5}, {5,2,5,2},  {5,3,2,3}, {8,3,2,3},
  {11,3,2,3}, {11,3,5,3}};

setdash_(value,v2,v3,v4)
     integer *value,*v2,*v3,*v4;
{
  static integer maxdash = 6, l2=4,l3 ;

  if ( ScilabXgc->CurColorStatus ==1) 
    {
      int i;
      i= Max(0,Min(*value,NUMCOLORS-1));
      ScilabXgc->CurColor = i;
      set_c(i);
    }
  else
    {
      l3 = Min(maxdash-1,*value-1);
      setdashstyle_(value,DashTab[Max(0,l3)],&l2);
      ScilabXgc->CurDashStyle= l3 + 1 ;
    }

}

/** To change The X11-default dash style **/
/** if *value == 0, use a solid line, if *value != 0 **/
/** the dash style is specified by the xx vector of n values **/
/** xx[3]={5,3,7} and *n == 3 means :  5white 3 void 7 white \ldots **/

setdashstyle_(value,xx,n)
     integer *value,xx[],*n;
{
  int dashok= LineOnOffDash ;
  if ( *value == 0) dashok = LineSolid;
  else 
    {
      integer i; char buffdash[18];
      for ( i =0 ; i < *n ; i++) buffdash[i]=xx[i];
      XSetDashes(dpy,gc,0,buffdash,(int)*n);
    }
  XSetLineAttributes(dpy,gc,(unsigned) ScilabXgc->CurLineWidth,dashok,CapButt,JoinMiter);
}

/** to get the current dash-style **/

getdash_(verbose,value,narg)
     integer *verbose,*value,*narg;
{int i ;
 *narg =1 ;
 if ( ScilabXgc->CurColorStatus ==1) 
   {
     *value =ScilabXgc->CurColor;
     if (*verbose == 1) sciprint("Color %d",(int)*value);
     return;
   }
 *value =ScilabXgc->CurDashStyle;
 if ( *value == 0) 
   { if (*verbose == 1) Scistring("\nLine style = Line Solid");}
 else 
   {
     value[1]=4;
     *narg = value[1]+2;
     for ( i =0 ; i < value[1]; i++) value[i+2]=DashTab[*value-1][i];
     if (*verbose ==1 ) 
       {
	 sciprint("\nDash Style %d:<",(int)*value);
	 for ( i =0 ; i < value[1]; i++)
	   sciprint("%d ",(int)value[i+2]);
	 Scistring(">\n");
       }
   }
}

/* basculement eventuel de couleur a n&b */

usecolor_(num,v1,v2,v3)
     integer *num,*v1,*v2,*v3;
{
  int i;
  i=  Min(Max(*num,0),1);
  if ( ScilabXgc->CurColorStatus != i) 
    {
      if (ScilabXgc->CurColorStatus == 1) 
	{
	  /* je passe de Couleur a n&b */
	  /* remise des couleurs a vide */
	  ScilabXgc->CurColorStatus = 1;
	  setpattern_((i=0,&i),PI0,PI0,PI0);
	  /* passage en n&b */
	  ScilabXgc->CurColorStatus = 0;
	  i= ScilabXgc->CurPattern;
	  setpattern_(&i,PI0,PI0,PI0);
	  i= ScilabXgc->CurDashStyle;
	  setdash_(&i,PI0,PI0,PI0);
	}
      else 
	{
	  /* je passe en couleur */
	  /* remise a zero des patterns et dash */
	  /* remise des couleurs a vide */
	  ScilabXgc->CurColorStatus = 0;
	  setpattern_((i=0,&i),PI0,PI0,PI0);
	  setdash_((i=0,&i),PI0,PI0,PI0);
	  /* passage en couleur  */
	  ScilabXgc->CurColorStatus = 1;
	  i= ScilabXgc->CurColor;
	  setpattern_(&i,PI0,PI0,PI0);
	}
    }
}

getusecolor_(verbose,num,narg)
     integer *num,*verbose,*narg;
{
  *num = ScilabXgc->CurColorStatus;
  if (*verbose == 1) 
    sciprint("\n Use color %d\r\n",(int)*num);
  *narg=1;
}

/** Change the status of a Graphic Window **/
/** adding or removing a Background Pixmap to it **/

setpixmapOn_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{
  integer num1= Min(Max(*num,0),1);
  if ( ScilabXgc->CurPixmapStatus == num1 ) return;
  if ( num1 == 1 )
    {
      /** I had a Background Pixmap to the window **/
      XWindowAttributes war;
      xinfo_("Animation mode is on,( xset('pixmap',0) to leave)",
	     PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);

      XGetWindowAttributes(dpy,CWindow,&war); 	
      Cdrawable = (Drawable) XCreatePixmap(dpy, root, war.width,war.height, depth);
      if ( Cdrawable == (Drawable) 0) 
	{
	  Cdrawable = (Drawable) CWindow;
	  sciprint("No more space to create Pixmaps\r\n");
	}
      else 
	{
	  ScilabXgc->CurPixmapStatus = 1;
	  XSetForeground(dpy,gc,background);
	  XFillRectangle(dpy, Cdrawable, gc, 0, 0,(unsigned) war.width,(unsigned)war.height);
	  XSetForeground(dpy,gc,foreground);
	  XSetWindowBackgroundPixmap(dpy, CWindow, (Pixmap) Cdrawable);
	}
    }
  if ( num1 == 0 )
    {
      xinfo_(" ",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      /** I remove the Background Pixmap to the window **/
      XFreePixmap(dpy, (Pixmap) Cdrawable);
      XSetWindowBackground(dpy, CWindow,background);
      Cdrawable = (Drawable) CWindow;
      ScilabXgc->CurPixmapStatus = 0;
    }
  ScilabXgc->CurPixmapStatus = num1 ;
  SetPixmapNumber_(Cdrawable,(integer)CurWindow);
}

getpixmapOn_(verbose,value,narg)
     integer *verbose,*value,*narg;
{
  *value=ScilabXgc->CurPixmapStatus;
  *narg =1 ;
  if (*verbose == 1) sciprint("Color %d",(int)*value);
}

/*-----------------------------------------------------------
  \encadre{general routines accessing the  set<> or get<>
  routines } 
-------------------------------------------------------------*/

static int InitMissileXgc();


sempty_(verbose,v2,v3,v4)
     integer *verbose,*v2,*v3,*v4;
{
  if ( *verbose ==1 ) Scistring("\n No operation ");
}

gempty_(verbose,v2,v3)
     integer *verbose,*v2,*v3;
{
  if ( *verbose ==1 ) Scistring("\n No operation ");
}

#define NUMSETFONC 18

/** Table in lexicographic order **/
int xsetfont_(),xgetfont_(),xsetmark_(),xgetmark_();

static struct bgc { char *name ;
	     int (*setfonc )() ;
	     int (*getfonc )() ;}

MissileGCTab_[] = {
  "alufunction",setalufunction1_,getalufunction_,
  "clipoff",unsetclip_,getclip_,
  "clipping",setclip_,getclip_,
  "dashes",setdash_,getdash_,
  "default",InitMissileXgc, gempty_,
  "font",xsetfont_,xgetfont_,
  "line mode",setabsourel_,getabsourel_,
  "mark",xsetmark_,xgetmark_,
  "pattern",setpattern_,getpattern_,
  "pixmap",setpixmapOn_,getpixmapOn_,
  "thickness",setthickness_,getthickness_,
  "use color",usecolor_,getusecolor_,
  "wdim",setwindowdim_,getwindowdim_,
  "white",sempty_,getwhite_,
  "window",setcurwin_,getcurwin_,
  "wpos",setwindowpos_,getwindowpos_,
  "wshow",show_,gempty_,
  "wwpc",pixmapclear_,gempty_
  };

#ifdef lint 

/* pour forcer lint a verifier ca */

static 
test(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     integer flag ;
     integer  *verbose,*x1,*x2,*x3,*x4,*x5;
{ 
setalufunction1_(x1,x2,x3,x4);getalufunction_(verbose,x1,x2);
setclip_(x1,x2,x3,x4);getclip_(verbose,x1,x2);
unsetclip_(x1,x2,x3,x4);getclip_(verbose,x1,x2);
setdash_(x1,x2,x3,x4);getdash_(verbose,x1,x2);
InitMissileXgc(x1,x2,x3,x4); gempty_(verbose,x1,x2);
xsetfont_(x1,x2,x3,x4);xgetfont_(verbose,x1,x2);
setabsourel_(x1,x2,x3,x4);getabsourel_(verbose,x1,x2);
xsetmark_(x1,x2,x3,x4);xgetmark_(verbose,x1,x2);
setpattern_(x1,x2,x3,x4);getpattern_(verbose,x1,x2);
setpixmapOn_(x1,x2,x3,x4);getpixmapOn_(verbose,x1,x2);
setthickness_(x1,x2,x3,x4);getthickness_(verbose,x1,x2);
usecolor_(x1,x2,x3,x4);gempty_(verbose,x1,x2);
setwindowdim_(x1,x2,x3,x4);getwindowdim_(verbose,x1,x2);
sempty_(x1,x2,x3,x4);getwhite_(verbose,x1,x2);
setcurwin_(x1,x2,x3,x4);getcurwin_(verbose,x1,x2);
setwindowpos_(x1,x2,x3,x4);getwindowpos_(verbose,x1,x2);
show_(x1,x2,x3,x4);gempty_(verbose,x1,x2);
pixmapclear_(x1,x2,x3,x4);gempty(verbose,x1,x2);

}

#endif 

MissileGCget_(str,verbose,x1,x2,x3,x4,x5,dv1,dv2,dv3,dv4)
     char str[];
     integer *verbose,*x1,*x2,*x3,*x4,*x5;
     double *dv1,*dv2,*dv3,*dv4;
{ MissileGCGetorSet_(str,1L,verbose,x1,x2,x3,x4,x5);}

MissileGCset_(str,x1,x2,x3,x4,x5,x6,dv1,dv2,dv3,dv4)
     char str[];
     integer *x1,*x2,*x3,*x4,*x5,*x6;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose=0 ;
  MissileGCGetorSet_(str,0L,&verbose,x1,x2,x3,x4,x5);
}

MissileGCGetorSet_(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     integer flag ;
     integer  *verbose,*x1,*x2,*x3,*x4,*x5;
{ integer i ;
  for (i=0; i < NUMSETFONC ; i++)
    {
      integer j;
      j = strcmp(str,MissileGCTab_[i].name);
      if ( j == 0 ) 
	{ if (*verbose == 1)
	    sciprint("\nGettting Info on %s\r\n",str);
	  if (flag == 1)
	    (MissileGCTab_[i].getfonc)(verbose,x1,x2);
	  else 
	    (MissileGCTab_[i].setfonc)(x1,x2,x3,x4);
	  return;}
      else 
	{ if ( j <= 0)
	    {
	      sciprint("\nUnknow X operator <%s>\r\n",str);
	      return;
	    }
	}
    }
  sciprint("\n Unknow X operator <%s>\r\n",str);
}

/*-------------------------------------------------------
\section{Functions for drawing}
---------------------------------------------------------*/

/*----------------------------------------------------
\subsection{String display}

\encadre{display of a string
  at (x,y) position whith slope angle alpha in degree . 
  Angle are given clockwise. 
  If *flag ==1 and angle is z\'ero a framed box is added 
  around the string}.
-----------------------------------------------------*/

displaystring_(string,x,y,v1,flag,v6,v7,angle,dv2,dv3,dv4)
     integer *x,*y ,*flag;
     double *angle;
     char string[] ;
     integer *v1,*v6,*v7;
     double *dv2,*dv3,*dv4;
{ 
  if ( Abs(*angle) <= 0.1) 
    {
      XDrawString(dpy, Cdrawable, gc,(int) *x,(int) *y,string,strlen(string));
      if ( *flag == 1) 
	{
	  integer rect[4];
	  boundingbox_(string,x,y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
	  rect[0]=rect[0]-4;rect[2]=rect[2]+6;
	  drawrectangle_(string,rect,rect+1,rect+2,rect+3,PI0,PI0,PD0,PD0,PD0,PD0);
       }
    }
  else 
    DispStringAngle_(x,y,string,angle);
  XFlush(dpy);
  
}

DispStringAngle_(x0,yy0,string,angle)
     integer *x0,*yy0;
     double *angle;
     char string[];
{
  int i;
  integer x,y, rect[4];
  double sina ,cosa,l;
  char str1[2];
  str1[1]='\0';
  x= *x0;
  y= *yy0;
  sina= sin(*angle * M_PI/180.0);
  cosa= cos(*angle * M_PI/180.0);
  for ( i = 0 ; i < (int)strlen(string); i++)
    { 
      str1[0]=string[i];
      XDrawString(dpy,Cdrawable,gc,(int) x,(int) y ,str1,1);
      boundingbox_(str1,&x,&y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      /** drawrectangle_(string,rect,rect+1,rect+2,rect+3); **/
      if ( cosa <= 0.0 && i < (int)strlen(string)-1)
	{ char str2[2];
	  /** si le cosinus est negatif le deplacement est a calculer **/
	  /** sur la boite du caractere suivant **/
	  str2[1]='\0';str2[0]=string[i+1];
	  boundingbox_(str2,&x,&y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
	}
      if ( Abs(cosa) >= 1.e-8 )
	{
	  if ( Abs(sina/cosa) <= Abs(((double)rect[3])/((double)rect[2])))
	    l = Abs(rect[2]/cosa);
	  else 
	    l = Abs(rect[3]/sina);
	}
      else 
	l = Abs(rect[3]/sina);
      x +=  cosa*l*1.1;
      y +=  sina*l*1.1;
    }
}

/** To get the bounding rectangle of a string **/

boundingbox_(string,x,y,rect,v5,v6,v7,dv1,dv2,dv3,dv4)
     integer *x,*y,*rect,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
     char string[];
{ 
  int dir,asc,dsc;
  XCharStruct charret;
  XQueryTextExtents(dpy,ScilabXgc->FontXID,
		    string,strlen(string),&dir,&asc,&dsc,&charret);
  rect[0]= *x ;
  rect[1]= *y-asc;
  rect[2]= charret.width;
  rect[3]= asc+dsc;
}

/*------------------------------------------------
subsection{ Segments and Arrows }
-------------------------------------------------*/

drawline_(x1,yy1,x2,y2)
     integer *x1, *x2, *yy1, *y2 ;
{
  XDrawLine(dpy, Cdrawable, gc,(int) *x1,(int) *yy1,(int) *x2,(int) *y2); 
  XFlush(dpy);
}

/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/

drawsegments_(str,vx,vy,n,style,iflag,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n,vx[],vy[],*style,*iflag,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose=0,Dnarg,Dvalue[10],NDvalue;
  integer i ;
  getdash_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i < *n/2 ; i++)
    {
      if ( (int) *iflag == 1) 
	NDvalue = style[i];
      else 
	NDvalue=(*style < 0) ? (integer) ScilabXgc->CurDashStyle : *style;
      setdash_(&NDvalue,PI0,PI0,PI0);
      XDrawLine(dpy,Cdrawable,gc, (int) vx[2*i],(int) vy[2*i],(int) vx[2*i+1],(int) vy[2*i+1]) ;
      XFlush(dpy);
    }
  XFlush(dpy);
  setdash_( Dvalue,PI0,PI0,PI0);
}

/** Draw a set of arrows **/
/** arrows are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/
/** as is 10*arsize (arsize) the size of the arrow head in pixels **/

drawarrows_(str,vx,vy,n,as,style,iflag,dv1,dv2,dv3,dv4)
     char str[];
     integer *as;
     integer *n,vx[],vy[],*style,*iflag;
     double *dv1,*dv2,*dv3,*dv4;
{ 
  integer verbose=0,Dnarg,Dvalue[10],NDvalue,i,cpat;
  double cos20=cos(20.0*M_PI/180.0);
  double sin20=sin(20.0*M_PI/180.0);
  integer polyx[4],polyy[4],fillvect[1];
  getdash_(&verbose,Dvalue,&Dnarg);
  getpattern_(&verbose,&cpat,&Dnarg);
  for (i=0 ; i < *n/2 ; i++)
    { 
      double dx,dy,norm;
      if ( (int) *iflag == 1) 
	NDvalue = style[i];
      else 
	NDvalue=(*style < 0) ? (integer) ScilabXgc->CurDashStyle : *style;
      setdash_(&NDvalue,PI0,PI0,PI0);
      setpattern_(&NDvalue,PI0,PI0,PI0);
      XDrawLine(dpy,Cdrawable,gc,(int) vx[2*i],(int)vy[2*i],
		(int)vx[2*i+1],(int)vy[2*i+1]);
      dx=( vx[2*i+1]-vx[2*i]);
      dy=( vy[2*i+1]-vy[2*i]);
      norm = sqrt(dx*dx+dy*dy);
      if ( Abs(norm) >  SMDOUBLE ) 
	{ integer nn=1,p=3;
	  dx=(*as/10.0)*dx/norm;dy=(*as/10.0)*dy/norm;
	  polyx[0]= polyx[3]=vx[2*i+1]+dx*cos20;
	  polyx[1]= inint(polyx[0]  - cos20*dx -sin20*dy );
	  polyx[2]= inint(polyx[0]  - cos20*dx + sin20*dy);
	  polyy[0]= polyy[3]=vy[2*i+1]+dy*cos20;
	  polyy[1]= inint(polyy[0] + sin20*dx -cos20*dy) ;
	  polyy[2]= inint(polyy[0] - sin20*dx - cos20*dy) ;
	  fillpolylines_("v",polyx,polyy,(fillvect[0]=(integer) ScilabXgc->CurPattern ,fillvect),
			 &nn,&p,PI0,PD0,PD0,PD0,PD0);
	  }
    }
  setdash_( Dvalue,PI0,PI0,PI0);
  setpattern_(&(cpat),PI0,PI0,PI0);
  XFlush(dpy);
}

/*----------------------
\subsection{Rectangles}
------------------------*/
/** Draw or fill a set of rectangle **/
/** rectangle i is specified by (vect[i],vect[i+1],vect[i+2],vect[i+3]) **/
/** for x,y,width,height **/
/** for i=0 step 4 **/
/** (*n) : number of rectangles **/
/** fillvect[*n] : specify the action  **/
/** if fillvect[i] is in [0,whitepattern] then  fill the rectangle i **/
/** with pattern fillvect[i]
/** if fillvect[i] is > whitepattern  then only draw the rectangle i **/
/** The drawing style is the current drawing style **/

drawrectangles_(str,vects,fillvect,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*fillvect,*n,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer i,cpat,verbose=0,num;
  getpattern_(&verbose,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] > ScilabXgc->IDWhitePattern )
	{
	  drawrectangle_(str,vects+4*i,vects+4*i+1,vects+4*i+2,vects+4*i+3
			 ,PI0,PI0,PD0,PD0,PD0,PD0);
	}
      else
	{
	  setpattern_(&(fillvect[i]),PI0,PI0,PI0);
	  fillrectangle_(str,vects+4*i,vects+4*i+1,vects+4*i+2,vects+4*i+3,PI0,PI0,PD0,PD0,PD0,PD0);
	}
    }
  setpattern_(&(cpat),PI0,PI0,PI0);
}

/** Draw one rectangle with current line style **/

drawrectangle_(str,x,y,width,height,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer  *x, *y, *width, *height,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{ 
  XDrawRectangle(dpy, Cdrawable, gc, *x, *y, (unsigned)*width,(unsigned)*height);
  XFlush(dpy); }

/** fill one rectangle, with current pattern **/

fillrectangle_(str,x,y,width,height,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer  *x, *y, *width, *height,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{ 
  XFillRectangle(dpy, Cdrawable, gc,(int) *x,(int) *y,(unsigned) *width,(unsigned) *height); 
  XFlush(dpy);
}

/*----------------------
\subsection{Circles and Ellipsis }
------------------------*/
/** Draw or fill a set of ellipsis or part of ellipsis **/
/** Each is defined by 6-parameters, **/
/** ellipsis i is specified by $vect[6*i+k]_{k=0,5}= x,y,width,height,angle1,angle2$ **/
/** <x,y,width,height> is the bounding box **/
/** angle1,angle2 specifies the portion of the ellipsis **/
/** caution : angle=degreangle*64          **/
/** if fillvect[i] is in [0,whitepattern] then  fill the ellipsis i **/
/** with pattern fillvect[i]
/** if fillvect[i] is > whitepattern  then only draw the ellipsis i **/
/** The drawing style is the current drawing style **/

fillarcs_(str,vects,fillvect,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*fillvect,*n,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer i,cpat,verb,num;
  verb=0;
  getpattern_(&verb,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] > ScilabXgc->IDWhitePattern )
	{
	  setpattern_(&(cpat),PI0,PI0,PI0);
	  drawarc_(str,vects+6*i,vects+6*i+1,
		   vects+6*i+2,vects+6*i+3,
		   vects+6*i+4,vects+6*i+5,PD0,PD0,PD0,PD0);
	}
      else
	{
	  setpattern_(&(fillvect[i]),PI0,PI0,PI0);
	  fillarc_(str,vects+6*i,vects+6*i+1,
		   vects+6*i+2,vects+6*i+3,
		   vects+6*i+4,vects+6*i+5,PD0,PD0,PD0,PD0);
	}
    }
  setpattern_(&(cpat),PI0,PI0,PI0);
}


/** Draw a set of ellipsis or part of ellipsis **/
/** Each is defined by 6-parameters, **/
/** ellipsis i is specified by $vect[6*i+k]_{k=0,5}= x,y,width,height,angle1,angle2$ **/
/** <x,y,width,height> is the bounding box **/
/** angle1,angle2 specifies the portion of the ellipsis **/
/** caution : angle=degreangle*64          **/

drawarcs_(str,vects,style,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*style,*n,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose=0,Dnarg,Dvalue[10],NDvalue,i;
  /* store the current values */
  getdash_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i< *n ; i++)
    {
      NDvalue = style[i];
      setdash_(&NDvalue,PI0,PI0,PI0);
      drawarc_(str,vects+6*i,vects+6*i+1,
	       vects+6*i+2,vects+6*i+3,
	       vects+6*i+4,vects+6*i+5,PD0,PD0,PD0,PD0);
    }
  setdash_( Dvalue,PI0,PI0,PI0);
}

/** Draw a single ellipsis or part of it **/

drawarc_(str,x,y,width,height,angle1,angle2,dv1,dv2,dv3,dv4)
     double *dv1,*dv2,*dv3,*dv4;
     char str[];
     integer *angle1,*angle2, *x, *y, *width, *height;
{ 
  XDrawArc(dpy, Cdrawable, gc, *x, *y,(unsigned)*width,
	   (unsigned)*height,*angle1, *angle2);
  XFlush(dpy); }

/** Fill a single elipsis or part of it with current pattern **/

fillarc_(str,x,y,width,height,angle1,angle2,dv1,dv2,dv3,dv4)
     char str[];
     double *dv1,*dv2,*dv3,*dv4;
     integer *angle1,*angle2, *x, *y, *width, *height;
{ 
  XFillArc(dpy, Cdrawable, gc, *x, *y, *width, *height, *angle1, *angle2);    
  XFlush(dpy);}

/*--------------------------------------------------------------
\encadre{Filling or Drawing Polylines and Polygons}
---------------------------------------------------------------*/

/** Draw a set of (*n) polylines (each of which have (*p) points) **/
/** with lines or marks **/
/** drawvect[i] >= 0 use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

drawpolylines_(str,vectsx,vectsy,drawvect,n,p,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vectsx,*vectsy,*drawvect,*n,*p,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ integer verbose=0 ,symb[2],Mnarg,Dnarg,Dvalue[10],NDvalue,i,close;
  /* store the current values */
  xgetmark_(&verbose,symb,&Mnarg);
  getdash_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i< *n ; i++)
    {
      if (drawvect[i] >= 0)
	{ /** we use the markid : drawvect[i] **/
	  xsetmark_(drawvect+i,symb+1,PI0,PI0);
	  drawpolymark_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
	}
      else
	{/** we use the line-style number abs(drawvect[i])  **/
	  NDvalue = - drawvect[i] -1 ;
	  setdash_(&NDvalue,PI0,PI0,PI0);
	  close = 0;
	  drawpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,&close,
			PI0,PI0,PD0,PD0,PD0,PD0);
	}
    }
  /** back to default values **/
  setdash_( Dvalue,PI0,PI0,PI0);
  xsetmark_(symb,symb+1,PI0,PI0);
}

/** fill a set of polygons each of which is defined by 
 (*p) points (*n) is the number of polygons 
 the polygon is closed by the routine 
 fillvect[*n] :         
 if fillvect[i] <= whiteid-pattern the coresponding pattern is used for filling
 if fillvect[i] == whiteid-pattern +1 -> draw the boundaries 
 if fillvect[i] >= whiteid-pattern +2 -> fill with 
     a pattern then  draw boundaries ( the pattern is the white pattern 
     for fillvect[i]== whiteid-pattern +2
**/

fillpolylines_(str,vectsx,vectsy,fillvect,n,p,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vectsx,*vectsy,*fillvect,*n,*p,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer i,cpat,verbose=0,num,close=1,pattern;
  getpattern_(&verbose,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] >= ScilabXgc->IDWhitePattern +2)
	{ /** on peint puis on fait un contour ferme **/
	  pattern= -fillvect[i]+2*ScilabXgc->IDWhitePattern +2;
	  setpattern_(&pattern,PI0,PI0,PI0);
	  fillpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=1,&close),
			PI0,PI0,PD0,PD0,PD0,PD0);
	  setpattern_(&(cpat),PI0,PI0,PI0);
	  drawpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=1,&close)
			,PI0,PI0,PD0,PD0,PD0,PD0);
	}
      else
	{
	  if (fillvect[i] == ScilabXgc->IDWhitePattern + 1)
	      drawpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=0,&close)
			    ,PI0,PI0,PD0,PD0,PD0,PD0);
	  else 
	    {
	      setpattern_(&(fillvect[i]),PI0,PI0,PI0);
	      fillpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=0,&close)
			    ,PI0,PI0,PD0,PD0,PD0,PD0);
	    }
	}
    }
  setpattern_(&(cpat),PI0,PI0,PI0);
}

/** Only draw one polygon  with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/
/** n is the number of points of the polyline */

drawpolyline_(str,n, vx, vy,closeflag,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n,*closeflag;
     integer vx[], vy[], *v6, *v7;
     double *dv1,*dv2,*dv3,*dv4;
{ 
  integer n1;
  XPoint *ReturnPoints_();
  if (*closeflag == 1) n1 = *n+1;else n1= *n;
  if (n1 >= 2) 
    {
      analyze_points_(*n, vx, vy,*closeflag); 
      /* Old code replaced by a routine with clipping 
	 if (store_points_(*n, vx, vy,*closeflag))
	{
	  XDrawLines (dpy, Cdrawable, gc, ReturnPoints_(), (int) n1,
		      ScilabXgc->CurVectorStyle);
	  XFlush(dpy);
	} */
      XFlush(dpy);
    }
}

/** Fill the polygon or polyline **/
/** according to *closeflag : the given vector is a polyline or a polygon **/

fillpolyline_(str,n, vx, vy,closeflag,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n,*closeflag;
     integer vx[], vy[],*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer n1;
  XPoint *ReturnPoints_();
  if (*closeflag == 1) n1 = *n+1;else n1= *n;
  if (store_points_(*n, vx, vy,*closeflag)){
    XFillPolygon (dpy, Cdrawable, gc, ReturnPoints_(), n1,
		  Complex, ScilabXgc->CurVectorStyle);
  }
  XFlush(dpy);
}

/** Draw the current mark centred at points defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_(str,n, vx, vy,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n ; 
     integer vx[], vy[],*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  XPoint *ReturnPoints_();
  if ( ScilabXgc->CurHardSymb == 0 )
    {if (store_points_(*n, vx, vy,0L))		
       XDrawPoints (dpy, Cdrawable, gc, ReturnPoints_(), *n,CoordModeOrigin);
     XFlush(dpy);
   }
  else 
    { 
      integer i,keepid,keepsize,hds;
      i=1;
      keepid =  ScilabXgc->FontId;
      keepsize= ScilabXgc->FontSize;
      hds= ScilabXgc->CurHardSymbSize;
      xsetfont_(&i,&hds,PI0,PI0);
      for ( i=0; i< *n ;i++) DrawMark_(vx+i,vy+i);
      xsetfont_(&keepid,&keepsize,PI0,PI0);
    }
}

/*-----------------------------------------
 \encadre{List of Window id}
-----------------------------------------*/

typedef  struct  {Window  win,bgwin ;
		  Drawable  pixm;
		  integer    winId;
		  Widget info;
		  struct WindowList *next;
		  struct BCG winxgc;
		} WindowList  ;

static WindowList *The_List_  = (WindowList *) NULL;

/* add a window + the cuurent graphic context the cuurent bgwindow pixm etc...
   in the list of graphic windows 
*/


AddNewWindowToList_(wind,bgwind,pixm,info,num)
     Window wind,bgwind;
     Drawable pixm;
     Widget info;
     integer num;
{
  AddNewWindow_(&The_List_,wind,bgwind,pixm,info,num);
}

AddNewWindow_(listptr,wind,bgwind,pixm,info,num)
     WindowList **listptr;
     Window     wind,bgwind;
     Widget info;
     Drawable pixm;
     integer num ;
{ 
  if ( *listptr == (WindowList *) NULL)
    {*listptr = (WindowList *) MALLOC (sizeof(WindowList ));
     if ( listptr == 0) 
       Scistring("AddNewWindow_ No More Place ");
     else 
       { int i;
	 (*listptr)->win=wind;
	 (*listptr)->bgwin=bgwind;
	 (*listptr)->pixm=pixm;
	 (*listptr)->info=info;
	 (*listptr)->winId = num;
	 ScilabXgc= &((*listptr)->winxgc);
	 /* contexte graphique */
         (*listptr)->next = (struct WindowList *) NULL ;
       }
   }
  else
    AddNewWindow_((WindowList **) &((*listptr)->next),wind,bgwind,pixm,info,num);
}



/** destruction d'une fenetre **/

DeleteSGWin(intnum)
     integer intnum;
{ 
  if ( CurWindow == intnum )
    {
      CWindow = (Window) NULL;
      CBGWindow = (Window) NULL;
      Cdrawable =  (Drawable) NULL;
      CinfoW =  (Widget ) NULL ;
      ScilabXgc = &(MissileXgc);
      CurWindow = 0;
    }
  DeleteWindowToList_(intnum);
  /** 
    WARNING : A Finir  
    [1] Detruire physiquement la fenetre 
        C'est fait dans la fonction suiante 
	reste le Pixmap a detruire si besoin 
    [2] DeleteScaleWindowNumber_(intnum); 
    **/
}

/** detruit la fenetre num dans la liste des fenetres */

DeleteWindowToList_(num)
     integer num;
{
  WindowList *L1,*L2;
  L1 = The_List_;
  L2 = The_List_;
  while ( L1 != (WindowList *) NULL)
    {
      if ( L1->winId == num )
	{
	  Widget popup =  XtWindowToWidget(dpy,L1->bgwin);
	  XtDestroyWidget(popup);
	  /** fenetre a detruire trouvee **/
	  if ( L1 != L2 )
	    {
	      /** Ce n'est pas la premiere fenetre de la liste **/
	      L2->next= L1->next ;
	      FREE(L1);
	      return ;
	    }
	  else 
	    {
	      /** C'est la premiere fenetre de la liste **/
	      The_List_ = (WindowList *) L1->next ;
	      FREE(L1);
	      return;
	    }
	}
      else 
	{
	  L2 = L1;
	  L1 = (WindowList *) L1->next;
	}
    }
}

Window GetWindowNumber_(i)
     integer i ;
{ Window GetWin_();
  return( GetWin_(The_List_,Max(0,i)));
}

GetWindowXgcNumber_(i)
     integer i ;
{ 
  return( GetWinXgc_(The_List_,Max(0,i)));
}


Window GetBGWindowNumber_(i)
     integer i ;
{ Window GetBGWin_();
  return( GetBGWin_(The_List_,Max(0,i)));
}

Widget GetInfoNumber_(i)
     integer i ;
{ Widget GetInfo_();
  return( GetInfo_(The_List_,Max(0,i)));
}

Window GetWin_(listptr,i)
     WindowList *listptr;
     integer i; 
{
  if (listptr == (WindowList  *) NULL)
    return((Window ) NULL);
  else 
    { if ((listptr->winId) == i)
	return( listptr->win);
    else 
      return((Window )GetWin_((WindowList *) listptr->next,i));
    }
}

GetWinXgc_(listptr,i)
     WindowList *listptr;
     integer i; 
{
  if (listptr == (WindowList  *) NULL)
    return(0);
  else 
    { 
      if ((listptr->winId) == i)
	{
	  ScilabXgc = &(listptr->winxgc);
	 }
      else 
	return(GetWinXgc_((WindowList *) listptr->next,i));
    }
}

Window GetBGWin_(listptr,i)
     WindowList *listptr;
     integer i; 
{
  if (listptr == (WindowList  *) NULL)
    return((Window ) NULL);
  else 
    { if ((listptr->winId) == i)
	return( listptr->bgwin);
    else 
      return((Window )GetBGWin_((WindowList *) listptr->next,i));
    }
}


Widget GetInfo_(listptr,i)
     WindowList *listptr;
     integer i; 
{
  if (listptr == (WindowList  *) NULL)
    return((Widget ) NULL);
  else 
    { if ((listptr->winId) == i)
	return( listptr->info);
    else 
      return((Widget )GetInfo_((WindowList *) listptr->next,i));
    }
}


Drawable GetPixmapNumber_(i)
     integer i ;
{ Drawable GetPix_();
  return( GetPix_(The_List_,Max(0,i)));
}

Drawable GetPix_(listptr,i)
     WindowList *listptr;
     integer i; 
{
  if (listptr == (WindowList  *) NULL)
    return((Drawable ) NULL);
  else 
    { if ((listptr->winId) == i)
	return( listptr->pixm);
    else 
      return((Drawable )GetPix_((WindowList *) listptr->next,i));
    }
}

SetPixmapNumber_(pixm,i)
     Drawable pixm;
     integer i ;
{ 
   SetPix_(The_List_,pixm,Max(0L,i));
}

SetPix_(listptr,pixm,i)
     WindowList *listptr;
     integer i; 
     Drawable pixm;
{
  if (listptr == (WindowList  *) NULL)
    {
      Scistring("Can't store created pixmap in window list \n");
    }
  else 
    { 
      if ((listptr->winId) == i)
	listptr->pixm = pixm;
      else 
	SetPix_((WindowList *) listptr->next,pixm,i);
    }
}

/*--------------------------------------------------------------
  \encadre{Routine for initialisation : string is a display name }
--------------------------------------------------------------*/
#define MAXERRMSGLEN 512

static int X_error_handler(d, err_ev)
    Display        *d;
    XErrorEvent    *err_ev;
{
    char            err_msg[MAXERRMSGLEN];

    XGetErrorText(dpy, (int) (err_ev->error_code), err_msg, MAXERRMSGLEN - 1);
    (void) sciprint(
           "Scilab : X error trapped - error message follows:\r\n%s\r\n", err_msg);
}



set_c(i)
     integer i;
{
  if ( ScilabXgc->CurDrawFunction != GXclear ) 
    {
        if ( ScilabXgc->CurDrawFunction != GXxor ) 
	  XSetForeground(dpy, gc,(unsigned long) the_res.color[Max(Min(i,NUMCOLORS-1),0)] );
	else 
	  XSetForeground(dpy, gc,(unsigned long) the_res.color[Max(Min(i,NUMCOLORS-1),0)]
			 ^ background);
      }
}


/** Initialyze the dpy connection and creates graphic windows **/
/** If v2 is not a nul pointer *v2 is the window number to create **/
/** EntryCounter is used to check for first Entry + to now an available number **/

initgraphic_(string,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char string[];
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ 
  Visual *visual;
  static integer EntryCounter = 0;
  integer WinNum;
  GC XCreateGC();
  static int  screen;
  Screen *Xscreen;
  static XGCValues gcvalues;
  static Widget toplevel = (Widget) NULL;
  static Widget infowidget = (Widget) NULL;
  if ( v2 != (integer *) NULL && *v2 != -1 )
    WinNum= *v2;
  else
    WinNum= EntryCounter;
  if (EntryCounter == 0)
    {
      /** This is done only at the first entry */
      DisplayInit(string,&dpy,&toplevel);
      if (AllocVectorStorage_()==0) return(0);
      screen =DefaultScreen(dpy);
      root = XRootWindow (dpy, screen); 
      depth = XDefaultDepth (dpy, screen);
      LoadFonts();
      crosscursor = XCreateFontCursor(dpy, XC_crosshair);
      arrowcursor  = XCreateFontCursor (dpy, (char)0x2e);
      normalcursor = XCreateFontCursor (dpy, XC_X_cursor);
      /* Try to figure out color status */
      if ((visual=XDefaultVisual(dpy,screen)) != NULL) 
	{
	  if (visual->map_entries > 2) 
	    {
	      switch (visual->class) 
		{
		case StaticColor:
		case PseudoColor:
		case TrueColor:
		case DirectColor:
		  screencolor = 1;
		  break;
		case StaticGray:
		case GrayScale:
		  screencolor = 0;
		  break;
		default:
		  screencolor = 1;
		}
	    }
	}
    }
  CreatePopupWindow(WinNum,toplevel,&CWindow,&CBGWindow,&foreground,&background,&infowidget);
  if (EntryCounter == 0)
    {
      CreatePatterns_(background,foreground);
    }
  /** Default value is without Pixmap **/
  Cdrawable = (Drawable) CWindow;
  CinfoW = infowidget;
  CurWindow =WinNum;
  /* Rajoute la fenetre dans la liste et le contexte graphique de la fenetre devient le contexte
     graphique courant */
  AddNewWindowToList_(CWindow,CBGWindow,Cdrawable,CinfoW,WinNum);
  if (EntryCounter == 0)
    {
      /* GC Set: for drawing */
      gcvalues.foreground = foreground;
      gcvalues.background = background;
      gcvalues.function   =  GXcopy ;
      gcvalues.line_width = 1;
      gc = XCreateGC(dpy, CWindow, GCFunction | GCForeground 
		     | GCBackground | GCLineWidth, &gcvalues);
      XSetErrorHandler(X_error_handler);
      XSetIOErrorHandler((XIOErrorHandler) X_error_handler);
   } 
  InitMissileXgc(PI0,PI0,PI0,PI0);
  EntryCounter=Max(EntryCounter,WinNum);
  EntryCounter++;
  XSync(dpy,0);
  return(0);
}

/* ecrit un message dans le label du widget CinfoW */

xinfo_(message,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *message;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  Arg args[1];
  if ( CinfoW != (Widget) NULL)
    {
      Cardinal n = 0;
      XtSetArg(args[n], XtNlabel, message);n++;
      XtSetValues(CinfoW, args, n);
    }
}

/* meme chose mais appel r'eduit pou appel a partir de C */

wininfo(message)
     char *message;
{
  Arg args[1];
  if ( CinfoW != (Widget) NULL)
    {
      Cardinal n = 0;
      XtSetArg(args[n], XtNlabel, message);n++;
      XtSetValues(CinfoW, args, n);
    }
}


/*
 * Envoit un message de type ClientMessage a XScilab
 * Demande a scilab de creer une fenetre graphique
 */

Atom		NewGraphWindowMessageAtom;

SendScilab(local,winnum)
     Window local;
     integer winnum;
{
    XClientMessageEvent ev;
    ev.type = ClientMessage;
    ev.window = local ;
    ev.message_type =NewGraphWindowMessageAtom;
    ev.format = 32;
    ev.data.l[0] = winnum;
    XSendEvent (dpy, local, False, 0L, (XEvent *) &ev);
    XFlush(dpy);
}

/****************************************************************
 * Searches window named name among the sons of top  
 ****************************************************************/

#define DbugInfo0(x) /* fprintf(stderr,x) */
#define DbugInfo1(x,y)  /* fprintf(stderr,x,y) */
#define DbugInfo3(x,y,z,t)  /* fprintf(stderr,x,y,z,t) */
static int CheckWin();

Window Window_With_Name( top, name,j,ResList0,ResList1,ResList2)
     Window top;
     char *name, *ResList0,*ResList1,*ResList2;
     int j;
{
  Status status;
  Window *children,root1,parent1,w=0;
  unsigned int nchildren=0;
  integer i; 
  char *window_name;
  if ( CheckWin(top)==0) return((Window) 0);
  status=XQueryTree(dpy, top, &root1, &parent1, &children, &nchildren);
  DbugInfo1(" Status %d\n",status);
  if ( status == 0)
    {
      DbugInfo0("XQuery Tree failed \n");
      return((Window) 0);
    }
  if ( nchildren == 0 )  return((Window) 0);
  DbugInfo1("Number of children %d \n",nchildren);
  for (i= (int) nchildren-1; i >= 0 ; i--) 
    {
      if ( CheckWin(children[i])!=0)
	{
	  XFetchName(dpy, children[i], &window_name);
	  DbugInfo3("Child [%d] %s %d\n",children[i],window_name,j);
	  if ( window_name != 0 && strcmp(window_name, name)==0 )
	    {
	      w=children[i];
	      DbugInfo1("Found %s \n",window_name);
	      DbugInfo1("Level %d\n",j);
	      XFree((char *) children);
	      if (window_name) XFree(window_name);
	      break;
	    }
	  else 
	    {  
	      w=Window_With_Name(children[i],name,j+1,
				 ResList0,ResList1,ResList2);
	      if ( w != 0 )
		{
		  XFree((char *) children);
		  DbugInfo1("father was %s\n",window_name);
		  if (window_name) XFree(window_name);
		  break;
		}
	    }
	  if (window_name) XFree(window_name);
	}
    }
  return((Window) w);
}


static char *ResList[]={ VERSION,"BG","ScilabGraphic"};


Window Find_X_Scilab()
{
  Window w;
  DbugInfo1("Searching %s\n",VERSION);
  w=Window_With_Name(RootWindow(dpy,DefaultScreen(dpy)),
			  VERSION,0,ResList[0],ResList[0],ResList[0]);
  return(w);
}

#define STR0 "ScilabGraphic%d"

Window Find_ScilabGraphic_Window(i)
     integer i;
{
  Window w;
  char wname[sizeof(STR0)+4];
  sprintf(wname,STR0,i);
  DbugInfo1("Searching %s\n",wname);
  w=Window_With_Name(RootWindow(dpy,DefaultScreen(dpy)),wname,0,
			  ResList[2],ResList[2],ResList[2]);
  return(w);
}

#define STR1 "BG%d"

Window Find_BG_Window(i)
     integer i;
{
  char wname[sizeof(STR1)+4];
  Window w;
  sprintf(wname,STR1,i);
  DbugInfo1("Searching %s\n",wname);
  w=Window_With_Name(RootWindow(dpy,DefaultScreen(dpy)),wname,0,
			  ResList[1],ResList[2],ResList[2]);
  return(w);
}

  /*
   * make sure that the window is valid
   * There's no function to really check this in X11
   */
#include <setjmp.h>

static integer val;
static jmp_buf my_env;

Ignore_Err(d, err_ev)
    Display        *d;
    XErrorEvent    *err_ev;
{DbugInfo0("Ignoring Error");
 longjmp(my_env,1);}

static int 
CheckWin(w)
     Window w;
{
  Window root_ret;
  int x, y;
  unsigned width= -1, height= -1, bw, idepth;
  int (*curh)();
  curh=XSetErrorHandler((XErrorHandler) Ignore_Err);
  if ( setjmp(my_env)) 
    {
      /** return from longjmp **/
      XSetErrorHandler((XErrorHandler) curh);
      return(0);
    }
  else
    {
      XGetGeometry (dpy, w, &root_ret, &x, &y, &width, &height, &bw, &idepth);
      XSync (dpy, 0);
      XSetErrorHandler((XErrorHandler) curh);
      return(1);}
}


/*--------------------------------------------------------
  \encadre{Initialisation of the graphic context. Used also 
  to come back to the default graphic state}
---------------------------------------------------------*/
static int
InitMissileXgc (v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{ 
  integer i,j;
  ScilabXgc->IDWhitePattern = GREYNUMBER-1;
  ScilabXgc->CurLineWidth=0 ;
  i=1;
  setthickness_(&i,PI0,PI0,PI0);
  setalufunction1_((i=3,&i),PI0,PI0,PI0);
  /** retirer le clipping **/
  i=j= -1;
  unsetclip_(PI0,PI0,PI0,PI0);
  ScilabXgc->ClipRegionSet= 0;
  xsetfont_((i=2,&i),(j=1,&j),PI0,PI0);
  xsetmark_((i=0,&i),(j=0,&j),PI0,PI0);
  ScilabXgc->CurPixmapStatus =0 ;
  setpixmapOn_((i=0,&i),PI0,PI0,PI0);
  /** trac\'e absolu **/
  i= CoordModeOrigin ;
  setabsourel_(&i,PI0,PI0,PI0);
  /* initialisation des pattern dash par defaut en n&b */
  ScilabXgc->CurColorStatus =0;
  setpattern_((i=0,&i),PI0,PI0,PI0);
  setdash_((i=0,&i),PI0,PI0,PI0);
  /* initialisation de la couleur par defaut */ 
  ScilabXgc->CurColorStatus = 1 ;
  setpattern_((i=0,&i),PI0,PI0,PI0);
  /* Choix du mode par defaut (decide dans initgraphic_ */
  usecolor_((i=screencolor,&i) ,PI0,PI0,PI0);
  strcpy(ScilabXgc->CurNumberDispFormat,"%-5.2g");
}

/* renvoit le screencolor courant */

getcolordef(screenc)
     integer * screenc;
{
  *screenc= screencolor;
}


/* Utilise le ScilabXgc courant pour reinitialiser le gc XWindow */
/* cela est utilis'e quand on change de fenetre graphique        */

static int
ResetScilabXgc ()
{ 
  integer i,j;
  i= ScilabXgc->FontId;
  j= ScilabXgc->FontSize;
  xsetfont_(&i,&j,PI0,PI0);
  
  i= ScilabXgc->CurHardSymb;
  j= ScilabXgc->CurHardSymbSize;
  xsetmark_(&i,&j,PI0,PI0);
  
  i= ScilabXgc->CurLineWidth;
  setthickness_(&i,PI0,PI0,PI0);
  
  i= ScilabXgc->CurVectorStyle;
  setabsourel_(&i,PI0,PI0,PI0);
  
  i= ScilabXgc->CurDrawFunction;
  setalufunction1_(&i,PI0,PI0,PI0);
  
  if (ScilabXgc->ClipRegionSet == 1) 
    setclip_( &(ScilabXgc->CurClipRegion[0]),
	     &(ScilabXgc->CurClipRegion[1]),
	     &(ScilabXgc->CurClipRegion[2]),
	     &(ScilabXgc->CurClipRegion[3]));
  else
    unsetclip_(PI0,PI0,PI0,PI0);

  if (ScilabXgc->CurColorStatus == 0) 
    {
      /* remise des couleurs a vide */
      ScilabXgc->CurColorStatus = 1;
      setpattern_((i=0,&i),PI0,PI0,PI0);
      /* passage en n&b */
      ScilabXgc->CurColorStatus = 0;
      i= ScilabXgc->CurPattern;
      setpattern_(&i,PI0,PI0,PI0);
      i= ScilabXgc->CurDashStyle;
      setdash_(&i,PI0,PI0,PI0);
    }
  else 
    {
      /* remise a zero des patterns et dash */
      /* remise des couleurs a vide */
      ScilabXgc->CurColorStatus = 0;
      setpattern_((i=0,&i),PI0,PI0,PI0);
      setdash_((i=0,&i),PI0,PI0,PI0);
      /* passage en couleur  */
      ScilabXgc->CurColorStatus = 1;
      i= ScilabXgc->CurColor;
      setpattern_(&i,PI0,PI0,PI0);
    }
}

/*------------------------------------------------------
  Draw an axis whith a slope of alpha degree (clockwise)
  . Along the axis marks are set in the direction ( alpha + pi/2), in the 
  following way :
  \begin{itemize}
  \item   $n=<n1,n2>$,
  \begin{verbatim}
  |            |           |
  |----|---|---|---|---|---|
  <-----n1---->                 
  <-------------n2-------->
  \end{verbatim}
  $n1$and $n2$ are integer numbers for interval numbers.
  \item $size=<dl,r,coeff>$. $dl$ distance in points between 
  two marks, $r$ size in points of small mark, $r*coeff$ 
  size in points of big marks. (they are doubleing points numbers)
  \item $init$. Initial point $<x,y>$. 
  \end{itemize}
  
-------------------------------------------------------------*/

drawaxis_(str,alpha,nsteps,v2,initpoint,v6,v7,size,dx2,dx3,dx4)
     double *dx2,*dx3,*dx4;
     char str[];
     integer *alpha,*nsteps,*initpoint,*v2,*v6,*v7;
     double *size;
{ integer i;
  double xi,yi,xf,yf;
  double cosal,sinal;
  cosal= cos( (double)M_PI * (*alpha)/180.0);
  sinal= sin( (double)M_PI * (*alpha)/180.0);
  for (i=0; i <= nsteps[0]*nsteps[1]; i++)
    { xi = initpoint[0]+i*size[0]*cosal;
      yi = initpoint[1]+i*size[0]*sinal;
      xf = xi - ( size[1]*sinal);
      yf = yi + ( size[1]*cosal);
      XDrawLine(dpy,Cdrawable,gc,inint(xi),inint(yi),inint(xf),inint(yf));
    }
  for (i=0; i <= nsteps[1]; i++)
    { xi = initpoint[0]+i*nsteps[0]*size[0]*cosal;
      yi = initpoint[1]+i*nsteps[0]*size[0]*sinal;
      xf = xi - ( size[1]*size[2]*sinal);
      yf = yi + ( size[1]*size[2]*cosal);
      XDrawLine(dpy,Cdrawable,gc,inint(xi),inint(yi),inint(xf),inint(yf));
    }
  xi = initpoint[0]; yi= initpoint[1];
  xf = initpoint[0]+ nsteps[0]*nsteps[1]*size[0]*cosal;
  yf = initpoint[1]+ nsteps[0]*nsteps[1]*size[0]*sinal;
  XDrawLine(dpy,Cdrawable,gc,inint(xi),inint(yi),inint(xf),inint(yf));
  XFlush(dpy);
}

/*-----------------------------------------------------
  \encadre{Display numbers z[i] at location (x[i],y[i])
  with a slope alpha[i] (see displaystring), if flag==1
  add a box around the string, only if slope =0}
-----------------------------------------------------*/

displaynumbers_(str,x,y,v1,v2,n,flag,z,alpha,dx3,dx4)
     double *dx3,*dx4;
     char str[];
     integer x[],y[],*n,*flag,*v1,*v2;
     double z[],alpha[];
{ integer i ;
  char buf[20];
  for (i=0 ; i< *n ; i++)
    { sprintf(buf,ScilabXgc->CurNumberDispFormat,z[i]);
      displaystring_(buf,&(x[i]),&(y[i]),PI0,flag,PI0,PI0,&(alpha[i]),PD0,PD0,PD0) ;
    }
  XFlush(dpy);
}

bitmap_(string,w,h)
     char string[];
     integer w,h;
{
  static XImage *setimage;
  setimage = XCreateImage (dpy, XDefaultVisual (dpy, DefaultScreen(dpy)),
			       1, XYBitmap, 0, string,w,h, 8, 0);	
  setimage->data = string;
  XPutImage (dpy, Cdrawable, gc, setimage, 0, 0, 10,10,w,h);
  XDestroyImage(setimage);
}
/*---------------------------------------------------------------------
\subsection{Using X11 Fonts}
functions : xsetfont\_, xgetfont\_,xsetmark\_,xgetmark\_,xloadfamily\_
---------------------------------------------------------------------*/

#define FONTNUMBER 7 
#define FONTMAXSIZE 6
#define SYMBOLNUMBER 10
/* FontsList : stockage des structures des fonts 
   la font i a la taille fsiz se trouve ds 
   FontsList_[i][fsiz]->fid
*/

static XFontStruct *FontsList_[FONTNUMBER][FONTMAXSIZE];

/* Dans FontInfoTab : on se garde des information sur les 
   fonts la fonts i a pour nom fname et ok vaut 1 si 
   elle a ete chargee ds le serveur 
   c'est loadfamily qui se charge de charger une font a diverses 
   taille ds le serveur.
*/


struct FontInfo { integer ok;
		  char fname[100];
		} FontInfoTab_[FONTNUMBER];

static char *size_[] = { "08" ,"10","12","14","18","24"};

/** To set the current font id  and size **/
/** load the fonts into X11 if necessary **/

typedef  struct  {
  char *alias;
  char *name;
  }  FontAlias;

/** ce qui suit marche sur 75dpi ou 100dpi **/

FontAlias fonttab[] ={
  "CourR", "-adobe-courier-medium-r-normal--*-%s0-*-*-m-*-iso8859-1",
  "Symb", "-adobe-symbol-medium-r-normal--*-%s0-*-*-p-*-adobe-fontspecific",
  "TimR", "-adobe-times-medium-r-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimI", "-adobe-times-medium-i-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimB", "-adobe-times-bold-r-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimBI", "-adobe-times-bold-i-normal--*-%s0-*-*-p-*-iso8859-1",
  (char *) NULL,( char *) NULL};


int xsetfont_(fontid,fontsize,v3,v4)
     integer *fontid , *fontsize ,*v3,*v4;
{ 
  integer i,fsiz;
  i = Min(FONTNUMBER-1,Max(*fontid,0));
  fsiz = Min(FONTMAXSIZE-1,Max(*fontsize,0));
  if ( FontInfoTab_[i].ok !=1 )
    { 
      if (i != 6 )
	{
	  loadfamily_(fonttab[i].alias,&i,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
	}
      else 
	{
	  sciprint(" The Font Id %d is not affected \r\n",(int)i);
	  Scistring(" use xlfont to set it \n");
	  return;
	}
    }
  ScilabXgc->FontId = i;
  ScilabXgc->FontSize = fsiz;
  ScilabXgc->FontXID=FontsList_[i][fsiz]->fid;
  XSetFont(dpy,gc,FontsList_[i][fsiz]->fid);
  XFlush(dpy);
}

/** To get the  id and size of the current font **/

int xgetfont_(verbose,font,nargs)
     integer *verbose,*font,*nargs;
{
  *nargs=2;
  font[0]= ScilabXgc->FontId ;
  font[1] =ScilabXgc->FontSize ;
  if (*verbose == 1) 
    {
      sciprint("\nFontId : %d ", ScilabXgc->FontId );
      sciprint("--> %s at size %s pts\r\n",
	     FontInfoTab_[ScilabXgc->FontId].fname,
	     size_[ScilabXgc->FontSize]);
    }
}

/** To set the current mark **/
xsetmark_(number,size,v3,v4)
     integer *number,*size ,*v3,*v4;
{ 
  ScilabXgc->CurHardSymb = Max(Min(SYMBOLNUMBER-1,*number),0);
  ScilabXgc->CurHardSymbSize = Max(Min(FONTMAXSIZE-1,*size),0);
  ;}

/** To get the current mark id **/

xgetmark_(verbose,symb,narg)
     integer *verbose,*symb,*narg;
{
  *narg =2 ;
  symb[0] = ScilabXgc->CurHardSymb ;
  symb[1] = ScilabXgc->CurHardSymbSize ;
  if (*verbose == 1) 
    {
      sciprint("\nMark : %d ",ScilabXgc->CurHardSymb);
      sciprint("at size %s pts\r\n", size_[ScilabXgc->CurHardSymbSize]);
    }
}

/** Load in X11 a font at size  08 10 12 14 18 24 **/
/**  TimR08 TimR10 TimR12 TimR14 TimR18 TimR24 **/ 
/** name is a string if it's a string containing the char % 
  it's suposed to be a format for a generic font in X11 string style 
  ex :  "-adobe-times-bold-i-normal--%s-*-75-75-p-*-iso8859-1"
  and the font is loaded at size 8,10,12,14,18,24
  else it's supposed to be an alias for a font name
  Ex : TimR and we shall try to load TimR08 TimR10 TimR12 TimR14 TimR18 TimR24 
  we first look in an internal table and transmits the string 
  to X11 
**/

loadfamily_(name,j,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *name;
     integer *j,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ integer i,flag=1 ;
  /** generic name with % **/
  if ( strchr(name,'%') != (char *) NULL)
    {
      loadfamily_n_(name,j);
      return;
    }
  else 
    {
      /** our table of alias **/
      i=0;
      while ( fonttab[i].alias != (char *) NULL)
	{
	  if (strcmp(fonttab[i].alias,name)==0)
	    {
	      loadfamily_n_(fonttab[i].name,j);
	      return;
	    }
	  i++;
	}
      /** Using X11 Table of aliases **/
      for ( i = 0; i < FONTMAXSIZE ; i++)
	{
	  char name1[200];
	  sprintf(name1,"%s%s",name,size_[i]);
	  FontsList_[*j][i]=XLoadQueryFont(dpy,name1);
	  if  (FontsList_[*j][i]== NULL)
	    { 
	      flag=0;
	      sciprint("\n Unknown font : %s",name1);
	      Scistring("\n I'll use font: fixed ");
	      FontsList_[*j][i]=XLoadQueryFont(dpy,"fixed");
	      if  (FontsList_[*j][i]== NULL)
		{
		  sciprint("\n Unknown font : %s\r\n","fixed");
		  Scistring("Please call an X Wizard !");
		}
	    }
	}
      FontInfoTab_[*j].ok = 1;
      if (flag != 0) 
	strcpy(FontInfoTab_[*j].fname,name);
      else
	strcpy(FontInfoTab_[*j].fname,"fixed");
    }
}

static char *size_n_[] = { "8" ,"10","12","14","18","24"};

loadfamily_n_(name,j)
     char *name;
     integer *j;
{ 
  char name1[200];
  integer i,flag=1 ;
  for ( i = 0; i < FONTMAXSIZE ; i++)
    {
      sprintf(name1,name,size_n_[i]);
      FontsList_[*j][i]=XLoadQueryFont(dpy,name1);
      if  (FontsList_[*j][i]== NULL)
	{ 
	  flag=0;
	  sciprint("\n Unknown font : %s",name1);
	  Scistring("\n I'll use font: fixed ");
	  FontsList_[*j][i]=XLoadQueryFont(dpy,"fixed");
	  if  (FontsList_[*j][i]== NULL)
	    {
	      sciprint("\n Unknown font : %s\r\n","fixed");
	      Scistring("  Please call an X Wizard !");
	    }
	}
    }
  FontInfoTab_[*j].ok = 1;
  if (flag != 0) 
    strcpy(FontInfoTab_[*j].fname,name);
  else
    strcpy(FontInfoTab_[*j].fname,"fixed");
}


static int
LoadFonts()
{
  integer fnum;
  loadfamily_("CourR",(fnum=0,&fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 
  LoadSymbFonts();
  loadfamily_("TimR",(fnum=2,&fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
/*  On charge ces fonts a la demande et non pas a l'initialisation 
    sinon le temps de calcul est trop long
  loadfamily_("TimI",(fnum=3,&fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  loadfamily_("TimB",(fnum=4,&fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  loadfamily_("TimBI",(fnum=5,&fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 
  See xsetfont
*/
}

/** We use the Symbol font  for mark plotting **/
/** so we want to be able to center a Symbol character at a specified point **/

typedef  struct { integer xoffset[SYMBOLNUMBER];
		  integer yoffset[SYMBOLNUMBER];} Offset ;

static Offset ListOffset_[FONTMAXSIZE];
static char Marks[] = {
  /*., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle*/
  (char)0x2e,(char)0x2b,(char)0xb4,(char)0xc5,(char)0xa8,
  (char)0xe0,(char)0x44,(char)0xd1,(char)0xa7,(char)0x4f};

static int 
LoadSymbFonts()
{ 
  XCharStruct xcs;
  integer j,k ;
  integer i;
  /** Symbol Font is loaded under Id : 1 **/
  loadfamily_("Symb",(i=1,&i),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);

  /* We compute the char offset for several chars of the symbol font
     in order to be able to center them on a specific point 
     we need one offset per symbol
     for the font i 
     n1=FontsList_[i]->min_char_or_byte2
     info on char coded as  oxyy are stored in 
     FontsList_[i]->per_char[(char)0xyy-n1]
     
     */
  /** if symbol font was not found me must stop **/
  if (strcmp(FontInfoTab_[1].fname,fonttab[1].name) != 0) return;
  for (i =0 ; i < FONTMAXSIZE ; i++)
    {    if (FontsList_[1][i] != NULL)
	   {
	     k =FontsList_[1][i]->min_char_or_byte2;
	     for (j=0 ; j < SYMBOLNUMBER ; j++)
	       { 
		 xcs= FontsList_[1][i]->per_char[Char2Int(Marks[j])-k];
		 (ListOffset_[i].xoffset)[j] = (xcs.rbearing+xcs.lbearing)/2;
		 (ListOffset_[i].yoffset)[j] = (xcs.ascent+xcs.descent)/2;
	       }
	   }
       }
}

/** The two next functions send the x and y offsets to center the current **/
/** symbol at point (x,y) **/

int CurSymbXOffset_()
{
  return(-(ListOffset_[ScilabXgc->CurHardSymbSize].xoffset)
	 [ScilabXgc->CurHardSymb]);
}
int CurSymbYOffset_()
{
  return((ListOffset_[ScilabXgc->CurHardSymbSize].yoffset)
	 [ScilabXgc->CurHardSymb]);
}

DrawMark_(x,y)
     integer *x,*y ;
{ 
  char str[1];
  str[0]=Marks[ScilabXgc->CurHardSymb];
  XDrawString(dpy,Cdrawable,gc,(int) *x+CurSymbXOffset_(),(int)*y+CurSymbYOffset_(),str,1);
  XFlush(dpy);
}

/*-------------------------------------------------------------------
\subsection{Allocation and storing function for vectors of X11-points}
------------------------------------------------------------------------*/

static XPoint *points;
static unsigned nbpoints;
#define NBPOINTS 256 

int store_points_(n, vx, vy,onemore)
     integer n,onemore;
     integer vx[], vy[];
{ 
  integer i,n1;
  if ( onemore == 1) n1=n+1;
  else n1=n;
  if (ReallocVector_(n1) == 1)
    {
      for (i = 0; i < n; i++){
#ifdef DEBUG
	if ( Abs(vx[i]) > int16max )
	  {
	    fprintf(stderr,"Warning store_point oustide of 16bits x=%d\n",
		    (int) vx[i]);
	  }
	if ( Abs(vy[i]) > int16max )
	  {
	    fprintf(stderr,"Warning store_point oustide of 16bits x=%d\n",
		    (int) vy[i]);
	  }
#endif
	points[i].x =(short) vx[i];
	points[i].y =(short) vy[i];
      }
      if (onemore == 1) {
	points[n].x=(short) points[0].x;
	points[n].y=(short) points[0].y;
      }
      return(1);
    }
  else return(0);
}

int ReallocVector_(n)
     integer n  ;
{
  while (n > nbpoints){
    nbpoints = 2 * nbpoints ;
    points = (XPoint *) REALLOC(points,(unsigned)
				 nbpoints * sizeof (XPoint));
    if (points == 0) 
      { perror(MESSAGE5);
	return (0);
      }
  }
  return(1);
}

int AllocVectorStorage_()
{
  nbpoints = NBPOINTS;
  points = (XPoint *) MALLOC( nbpoints * sizeof (XPoint)); 
  if ( points == 0) { perror(MESSAGE4);return(0);}
  else return(1);
}

XPoint *ReturnPoints_() { return(points); }

/**  Clipping functions **/

/* My own clipping routines  
  XDrawlines with clipping on the current graphic window 
  to ovoid trouble on some X servers **/

static integer xleft,xright,ybot,ytop;

/* Test a single point to be within the xleft,xright,ybot,ytop bbox.
 * Sets the returned integers 4 l.s.b. as follows:
 * bit 0 if to the left of xleft.
 * bit 1 if to the right of xright.
 * bit 2 if below of ybot.
 * bit 3 if above of ytop.
 * 0 is returned if inside.
 */

static int clip_point(x, y)
integer x, y;
{
    integer ret_val = 0;

    if (x < xleft) ret_val |= (char)0x01;
    else if (x > xright) ret_val |= (char)0x02;
    if (y < ybot) ret_val |= (char)0x04;
    else if (y > ytop) ret_val |= (char)0x08;
    return ret_val;
}

/* Clip the given line to drawing coords defined as xleft,xright,ybot,ytop.
 *   This routine uses the cohen & sutherland bit mapping for fast clipping -
 * see "Principles of Interactive Computer Graphics" Newman & Sproull page 65.
 return 0  : segment out 
        1  : (x1,y1) changed 
	2  : (x2,y2) changed 
	3  : (x1,y1) and (x2,y2) changed 
	4  : segment in 
 */


int set_clip_box(xxleft,xxright,yybot,yytop)
     integer xxleft,xxright,yybot,yytop;
{
  xleft=xxleft;
  xright=xxright;
  ybot=yybot;
  ytop=yytop;
}

int
clip_line(x1, yy1, x2, y2, x1n, yy1n, x2n, y2n, flag)
     integer x1, yy1, x2, y2, *flag, *x1n, *yy1n, *x2n, *y2n;
{
    integer x, y, dx, dy, x_intr[2], y_intr[2], count, pos1, pos2;
    *x1n=x1;*yy1n=yy1;*x2n=x2;*y2n=y2;*flag=4;
    pos1 = clip_point(x1, yy1);
    pos2 = clip_point(x2, y2);
    if (pos1 || pos2) {
	if (pos1 & pos2) { *flag=0;return;}	  
	/* segment is totally out. */

	/* Here part of the segment MAy be inside. test the intersection
	 * of this segment with the 4 boundaries for hopefully 2 intersections
	 * in. If non found segment is totaly out.
	 */
	count = 0;
	dx = x2 - x1;
	dy = y2 - yy1;

	/* Find intersections with the x parallel bbox lines: */
	if (dy != 0) {
	    x = (int) (ybot - y2)  * ((double) dx / (double) dy) + x2;
	    /* Test for ybot boundary. */
	    if (x >= xleft && x <= xright) {
		x_intr[count] = x;
		y_intr[count++] = ybot;
	    }
	    x = (ytop - y2) * ((double) dx / (double) dy) + x2; 
	    /* Test for ytop boundary. */
	    if (x >= xleft && x <= xright) {
		x_intr[count] = x;
		y_intr[count++] = ytop;
	    }
	}

	/* Find intersections with the y parallel bbox lines: */
	if (dx != 0) {
	    y = (xleft - x2) * ((double) dy / (double) dx) + y2;   
	    /* Test for xleft boundary. */
	    if (y >= ybot && y <= ytop) {
		x_intr[count] = xleft;
		y_intr[count++] = y;
	    }
	    y = (xright - x2) * ((double) dy / (double) dx) + y2;  
	    /* Test for xright boundary. */
	    if (y >= ybot && y <= ytop) {
		x_intr[count] = xright;
		y_intr[count++] = y;
	    }
	}

	if (count == 2) {
	    if (pos1 && pos2) {	   /* Both were out - update both */
		*x1n = x_intr[0];
		*yy1n = y_intr[0];
		*x2n = x_intr[1];
		*y2n = y_intr[1];
		*flag=3;return;
	      }
	    else if (pos1) {       /* Only x1/yy1 was out - update only it */
		if (dx * (x2 - x_intr[0]) + dy * (y2 - y_intr[0]) >= 0) {
		    *x1n = x_intr[0];
		    *yy1n = y_intr[0];
		    *flag=1;return;
		}
		else {
		    *x1n = x_intr[1];
		    *yy1n = y_intr[1];
		    *flag=1;return;
		}
	    }
	    else {	         /* Only x2/y2 was out - update only it */
		if (dx * (x_intr[0] - x1) + dy * (y_intr[0] - yy1) >= 0) {
		    *x2n = x_intr[0];
		    *y2n = y_intr[0];
		    *flag=2;return;
		}
		else {
		    *x2n = x_intr[1];
		    *y2n = y_intr[1];
		    *flag=2;return;
		}
	      }
	  }
	else 
	  {
	    /* count != 0 */
	    *flag=0;return;
	  }
      }
  }

static void change_points(i,x,y)
     integer i,x,y;
{
  points[i].x=(short)x;   points[i].y=(short)y;
}


static integer MyDraw(iib,iif,vx,vy)
     integer iib,iif,vx[],vy[];
{
  integer x1n,y1n,x11n,y11n,x2n,y2n,flag2=0,flag1=0;
  integer npts;
  npts= ( iib > 0) ? iif-iib+2  : iif-iib+1;
  if ( iib > 0) 
    {
      clip_line(vx[iib-1],vy[iib-1],vx[iib],vy[iib],&x1n,&y1n,&x2n,&y2n,&flag1);
    }
  clip_line(vx[iif-1],vy[iif-1],vx[iif],vy[iif],&x11n,&y11n,&x2n,&y2n,&flag2);
  if (store_points_(npts, &vx[Max(0,iib-1)], &vy[Max(0,iib-1)],0L));
  {
    if (iib > 0 && (flag1==1||flag1==3)) change_points(0L,x1n,y1n);
    if (flag2==2 || flag2==3) change_points(npts-1,x2n,y2n);
    XDrawLines (dpy, Cdrawable, gc, ReturnPoints_(),(int) npts,
		ScilabXgc->CurVectorStyle);
  }
}


static integer My2draw(j,vx,vy)
     integer j,vx[],vy[];
{
  /** The segment is out but can cross the box **/
  integer vxn[2],vyn[2],flag;
  long npts=2;
  clip_line(vx[j-1],vy[j-1],vx[j],vy[j],&vxn[0],&vyn[0],&vxn[1],&vyn[1],&flag);
  if (flag == 3 && store_points_(npts,vxn,vyn,0L))
  {
#ifdef DEBUG
	  sciprint("segment out mais intersecte en (%d,%d),(%d,%d)\r\n",
		   vxn[0],vyn[0],vxn[1],vyn[1]);
#endif 
    XDrawLines (dpy, Cdrawable, gc, ReturnPoints_(),(int)npts,
		ScilabXgc->CurVectorStyle);
  }
}


/* 
 *  returns the first (vx[.],vy[.]) point inside 
 *  xleft,xright,ybot,ytop bbox. begining at index ideb
 *  or zero if the whole polyline is out 
 */

static integer first_in(n,ideb,vx,vy)
     integer n,ideb;
     integer vx[], vy[];
{
  integer i;
  for (i=ideb  ; i < n ; i++)
    {
      if (vx[i]>= xleft && vx[i] <= xright  && vy[i] >= ybot && vy[i] <= ytop)
	{
#ifdef DEBUG
	  sciprint("first in %d->%d=(%d,%d)\r\n",ideb,i,vx[i],vy[i]);
#endif
	  return(i);
	}
    }
  return(-1);
}

/* 
 *  returns the first (vx[.],vy[.]) point outside
 *  xleft,xright,ybot,ytop bbox.
 *  or zero if the whole polyline is out 
 */

static integer first_out(n,ideb,vx,vy)
     integer n,ideb;
     integer vx[], vy[];
{
  integer i;
  for (i=ideb  ; i < n ; i++)
    {
      if ( vx[i]< xleft || vx[i]> xright  || vy[i] < ybot || vy[i] > ytop) 
	{
#ifdef DEBUG
	  sciprint("first out %d->%d=(%d,%d)\r\n",ideb,i,vx[i],vy[i]);
#endif
	  return(i);
	}
    }
  return(-1);
}


int analyze_points_(n, vx, vy,onemore)
     integer n,onemore;
     integer vx[], vy[];
{ 
  integer iib,iif,ideb=0,vxl[2],vyl[2];
  integer verbose=0,wd[2],narg;
  getwindowdim_(&verbose,wd,&narg);
  xleft=0;xright=wd[0]; ybot=0;ytop=wd[1];
#ifdef DEBUG1
    xleft=100;xright=300;
    ybot=100;ytop=300;
    XDrawRectangle(dpy, Cdrawable, gc,xleft,ybot,(unsigned)xright-xleft,
    (unsigned)ytop-ybot);
#endif
#ifdef DEBUG 
  sciprint("inside analyze\r\n");
#endif
  while (1) 
    { integer j;
      iib=first_in(n,ideb,vx,vy);
      if (iib == -1) 
	{ 
#ifdef DEBUG
	  sciprint("[%d,end=%d] polyline out\r\n",(int)ideb,(int)n);
	  /* all points are out but segments can cross the box */
#endif 
	  for (j=ideb+1; j < n; j++) My2draw(j,vx,vy);
	  break;
	}
      else 
      if ( iib - ideb > 1) 
	{
	  /* un partie du polygine est totalement out de ideb a iib -1 */
	  /* mais peu couper la zone */
	  for (j=ideb+1; j < iib; j++) My2draw(j,vx,vy);
	};
      iif=first_out(n,iib,vx,vy);
      if (iif == -1) {
	/* special case the polyligne is totaly inside */
	if (iib == 0) 
	  {
	    if (store_points_(n,vx,vy,onemore));
	    {
	      XDrawLines (dpy, Cdrawable, gc, ReturnPoints_(),(int) n,
			  ScilabXgc->CurVectorStyle);
	      return;
	    }	    
	  }
	else 
	  MyDraw(iib,n-1,vx,vy);
	break;
      }
#ifdef DEBUG
      sciprint("Analysed : [%d,%d]\r\n",(int)iib,(int)iif);
#endif 
      MyDraw(iib,iif,vx,vy);
      ideb=iif;
    }
  if (onemore == 1) {
    /* The polyligne is closed we consider the closing segment */
    integer x1n,y1n,x2n,y2n,flag1=0;
    vxl[0]=vx[n-1];vxl[1]=vx[0];vyl[0]=vy[n-1];vyl[1]=vy[0];
    clip_line(vxl[0],vyl[0],vxl[1],vyl[1],&x1n,&y1n,&x2n,&y2n,&flag1);
    if ( flag1==0) return ;
    if ( store_points_(2L,vxl,vyl,0L))
      {
	if (flag1==1||flag1==3) change_points(0L,x1n,y1n);
	if (flag1==2||flag1==3) change_points(1L,x2n,y2n);
	XDrawLines (dpy, Cdrawable, gc, ReturnPoints_(),2,
		    ScilabXgc->CurVectorStyle);	
      }
  }
}




