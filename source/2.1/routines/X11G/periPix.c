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
#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>


#include "Math.h"
#include "periPix.h"
#include "version.h"

#define MESSAGE4 "Can't allocate point vector"
#define MESSAGE5 "Can't re-allocate point vector" 
#define Char2Int(x)   ( x & 0x000000ff )

/** Global variables to deal with X11 **/

static GC gc;
static Cursor arrowcursor,normalcursor,crosscursor;
static Window CWindow=(Window) NULL ,root=(Window) NULL;
static Window CBGWindow=(Window) NULL ;
static Display *dpy = (Display *) NULL;
static int use_color=0;
static unsigned long foreground, background;

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
  int IDWhitePattern;
  int CurWindow;
  int CurVectorStyle;
  int CurDrawFunction;
  int ClipRegionSet;
  int CurClipRegion[4];
  int CurDashStyle;
  char CurNumberDispFormat[20];
}  MissileXgc ;


static  int LoadFonts();
static  int LoadSymbFonts();

/** Pixmap routines **/

static Pixmap Cpixmap;
static int depth;

pixmapclear_pix_()
{
  XWindowAttributes war;
  XSetForeground(dpy,gc,background);
  XGetWindowAttributes(dpy,CWindow,&war); 
  XFillRectangle(dpy, Cpixmap, gc, 0, 0, war.width,war.height);
  XSetForeground(dpy,gc,foreground);
}

show_pix_()
{
   XClearWindow(dpy,CWindow);
   XFlush(dpy);
}


/** ResiZe the pixmap associated to CWindow and store it back in the window List **/

CPixmapResize(x,y)
     int x,y;
{
  XFreePixmap(dpy,Cpixmap);
  Cpixmap = XCreatePixmap(dpy, root,Max(x,400),Max(y,300),depth);
  SetPixmapNumber_pix_(Cpixmap,MissileXgc.CurWindow);
  XSetForeground(dpy,gc,background);
  XFillRectangle(dpy, Cpixmap, gc, 0, 0,Max(x,400),Max(y,300));
  XSetForeground(dpy,gc,foreground);
  XSetWindowBackgroundPixmap(dpy, CWindow, Cpixmap);
}


CPixmapResize1()
{
  XWindowAttributes war;
  XGetWindowAttributes(dpy,CWindow,&war); 
  CPixmapResize(war.width,war.height);
}


/*-----------------------------------------------------
\encadre{General routines}
-----------------------------------------------------*/

/** To select (raise on the screen )the current graphic Window  **/
/** If there's no graphic window then select creates one **/

xselgraphic_pix_() 
{ 
  if (CBGWindow == (Window ) NULL) initgraphic_pix_("");
  XRaiseWindow(dpy,CBGWindow);
  XFlush(dpy);
}

/** End of graphic (do nothing)  **/

xendgraphic_pix_()
{
} 

xend_pix_()
{
  /** Must destroy everything  **/
}

/** Clear the current graphic window     **/

clearwindow_pix_() 
{
  pixmapclear_pix_();
  XClearWindow(dpy, CWindow);
  XFlush(dpy);
}

/*-----------------------------------------------------------
 \encadre{To generate a pause, in seconds}
------------------------------------------------------------*/

#if defined (sparc) && defined(__STDC__)
#define usleep(x) x
#endif 

xpause_pix_(str,sec_time)
     char str[];
     int *sec_time;
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
\encadre{ Wait for mouse click in graphic window 
   send back mouse location  (x1,y1)  and button number  
   0,1,2}
   There's just a pb if the window is iconified when we try to click 
   in this case we return i= -1
****************************************************************/


xclick_pix_(str,ibutton,x1,yy1)
     char str[];
     int *ibutton,*x1,*yy1 ;
{
  XEvent event;
  Bool flag1=True;
  int buttons = 0;
  /* Recenter_GW_pix_(); */
  /*  remove the previous click events on the queue */
  while (flag1) flag1= XCheckWindowEvent(dpy,CWindow,KeyPressMask| ButtonPressMask,&event);
  XDefineCursor(dpy, CWindow ,crosscursor);
  while (buttons == 0) {
    /* allow one more event */
    /* XWindowEvent(dpy, CWindow,ButtonPressMask|ButtonReleaseMask, &event); */
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

xgetmouse_pix_(str,ibutton,x1,y1)
     char str[];
     int *ibutton,*x1,*y1 ;
{
  XEvent event;
  Bool flag1=True;
  int buttons = 0;
  /* Recenter_GW_(); */
  XDefineCursor(dpy, CWindow ,crosscursor);
/*    XWindowEvent(dpy, CWindow,PointerMotionMask|ButtonReleaseMask, &event);*/
  XNextEvent (dpy, &event);
  while ( event.xany.window != CWindow )
	  {
	      XtDispatchEvent(&event);
	      XNextEvent (dpy, &event);
	  }
  /*  printf("%d\n",event.type);*/
  if (event.type ==  MotionNotify  ) 
	  {
	      *x1=event.xbutton.x;
	      *y1=event.xbutton.y;
	      *ibutton = -1;
	      XtDispatchEvent(&event);
	  }
  else if (event.type ==  ButtonPress ) 
	  {
	      *x1=event.xbutton.x;
	      *y1=event.xbutton.y;
	      *ibutton=event.xbutton.button-1;
	  }
  else 
	  {
	      XtDispatchEvent(&event);
	  }

  XDefineCursor(dpy, CWindow ,arrowcursor);
  XSync (dpy, 0);
}


/*------------------------------------------------
  \encadre{Clear a rectangle }
-------------------------------------------------*/

cleararea_pix_(str,x,y,w,h)
     char str[];
     int *x,*y,*w,*h;
{
  XClearArea(dpy,CWindow,*x,*y,*w,*h,True);
  XFlush(dpy);
}


/*---------------------------------------------------------------------
\section{moves graphic window for it to be inside the root window}
------------------------------------------------------------------------*/

Recenter_GW_pix_()
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

getwindowpos_pix_(verbose,x,narg)
     int *verbose,*x,*narg;
{
  XWindowAttributes war;
  Window CHR;
  *narg = 2;
  XGetWindowAttributes(dpy,CBGWindow,&war); 
  XTranslateCoordinates(dpy,CBGWindow,root,war.x,war.y,&(x[0]),&(x[1]),&CHR);
  if (*verbose == 1) 
    SciF2d("\n CWindow position :%d,%d\r\n",x[0],x[1]);
}

/** to set the window upper-left point position on the screen **/

setwindowpos_pix_(x,y)
     int *x,*y;
{
  if (CBGWindow == (Window) NULL) initgraphic_pix_("");
  XMoveWindow(dpy,CBGWindow,*x,*y);
}

/** To get the window size **/

getwindowdim_pix_(verbose,x,narg)
     int *verbose,*x,*narg;
{     
  XWindowAttributes war;
  *narg = 2;
  XGetWindowAttributes(dpy,CWindow,&war); 
  x[0]= war.width;
  x[1]= war.height;
  if (*verbose == 1) 
    SciF2d("\n CWindow dim :%d,%d\r\n",x[0],x[1]);
} 

/** To change the window size  **/

setwindowdim_pix_(x,y)
     int *x,*y;
{
  if (CBGWindow != (Window) NULL) 
	{	
	XResizeWindow(dpy,CBGWindow,Max(*x,400),Max(*y,300));
 	CPixmapResize(*x,*y);
	}
  XFlush(dpy);
}

/** To select a graphic Window  **/

setcurwin_pix_(intnum)
     int *intnum;
{ 
  Pixmap GetPixmapNumber_pix_();
  Window GetWindowNumber_pix_();
  Window GetBGWindowNumber_pix_();
  CWindow = GetWindowNumber_pix_(*intnum);
  CBGWindow = GetBGWindowNumber_pix_(*intnum);
  Cpixmap = GetPixmapNumber_pix_(*intnum); 
  MissileXgc.CurWindow = *intnum;
  if (CWindow == (Window ) NULL)
    {
      int i;
      for (i=0;i <= *intnum;i++)
	    if ( GetWindowNumber_pix_(*intnum)== (Window) NULL) initgraphic_pix_("");
    }
}

/** Get the id number of the Current Graphic Window **/

getcurwin_pix_(verbose,intnum,narg)
     int *verbose,*intnum,*narg;
{
  *narg =1 ;
  *intnum = MissileXgc.CurWindow ;
  if (*verbose == 1) 
    SciF1d("\nCurrent Graphic Window :%d\r\n",*intnum);
}

/** Set a clip zone (rectangle ) **/

setclip_pix_(x,y,w,h)
     int *x,*y,*w,*h;
{
  int verbose=0,wd[2],narg;
  XRectangle rects[1];
  MissileXgc.ClipRegionSet = 1;
  getwindowdim_pix_(&verbose,wd,&narg);
  rects[0].x= *x;
  rects[0].y= *y;
  rects[0].width= *w;
  rects[0].height= *h;
  MissileXgc.CurClipRegion[0]= rects[0].x;
  MissileXgc.CurClipRegion[1]= rects[0].y;
  MissileXgc.CurClipRegion[2]= rects[0].width;
  MissileXgc.CurClipRegion[3]= rects[0].height;
  XSetClipRectangles(dpy,gc,0,0,rects,1,Unsorted);
}

/** Get the boundaries of the current clip zone **/

getclip_pix_(verbose,x,narg)
     int *verbose,*x,*narg;
{
  x[0] = MissileXgc.ClipRegionSet;
  if ( x[0] == 1)
    {
      *narg = 5;
      x[1] =MissileXgc.CurClipRegion[0];
      x[2] =MissileXgc.CurClipRegion[1];
      x[3] =MissileXgc.CurClipRegion[2];
      x[4] =MissileXgc.CurClipRegion[3];
    }
  else *narg = 1;
  if (*verbose == 1)
    if (MissileXgc.ClipRegionSet == 1)
      SciF4d("\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d\r\n",
	      MissileXgc.CurClipRegion[0],
	      MissileXgc.CurClipRegion[1],
	      MissileXgc.CurClipRegion[2],
	      MissileXgc.CurClipRegion[3]);
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

setabsourel_pix_(num)
     int *num;
{
  if (*num == 0 )
    MissileXgc.CurVectorStyle =  CoordModeOrigin;
  else 
    MissileXgc.CurVectorStyle =  CoordModePrevious ;
}

/** to get information on absolute or relative mode **/

getabsourel_pix_(verbose,num,narg)
     int *verbose,*num,*narg;
{
  *narg = 1;
  *num = MissileXgc.CurVectorStyle  ;
  if (*verbose == 1) 
    if (MissileXgc.CurVectorStyle == CoordModeOrigin)
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
     int *num;
{int i;
 *num = -1;
 for ( i =0 ; i < 16;i++)
   if (strcmp(AluStruc_[i].name,name1)== 0) 
     *num=AluStruc_[i].id;
 if (*num == -1 ) 
   {
     Scistring("\n Use the following keys (integer in scilab");
     for ( i=0 ; i < 16 ; i++)
       SciF2s("\nkey %s   -> %s\r\n",AluStruc_[i].name,
	       AluStruc_[i].info);
   }
}

setalufunction_pix_(string)
     char string[];
{     
  int value;
  XGCValues gcvalues;
  idfromname(string,&value);
  if ( value != -1)
    {MissileXgc.CurDrawFunction = value;
     gcvalues.function = value;
     XChangeGC(dpy, gc, GCFunction, &gcvalues);
   }
}



setalufunction1_pix_(num)
     int *num;
{     
  int value;
  XGCValues gcvalues;
  value=AluStruc_[Min(16,Max(0,*num))].id;
  if ( value != -1)
    {
      MissileXgc.CurDrawFunction = value;
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
	  gcvalues.function = value;
	  gcvalues.foreground = foreground;
	  gcvalues.background = background;
	  break;
      }
      XChangeGC(dpy,gc,(GCForeground | GCBackground | GCFunction),&gcvalues);
    }
}


/** To get the value of the alufunction **/

getalufunction_pix_(verbose,value,narg)
     int *verbose , *value ,*narg;
{ 
  *narg =1 ;
  *value = MissileXgc.CurDrawFunction ;
  if (*verbose ==1 ) 
    { 
      SciF2s("\nThe Alufunction is %s -> <%s>\r\n",
	      AluStruc_[*value].name,
	      AluStruc_[*value].info);}
}


/** to set the thickness of lines : 0 is a possible value **/
/** give the thinest line (0 and 1 the same for X11 but   **/
/** with diferent algorithms ) **/
/** defaut value is 1 **/

setthickness_pix_(value)
     int *value ;
{ 
  XGCValues gcvalues;
  MissileXgc.CurLineWidth =Max(0, *value);
  gcvalues.line_width = Max(0, *value);
  XChangeGC(dpy, gc, GCLineWidth, &gcvalues); }

/** to get the thickness value **/

getthickness_pix_(verbose,value,narg)
     int *verbose,*value,*narg;
{
  *narg =1 ;
  *value = MissileXgc.CurLineWidth ;
  if (*verbose ==1 ) 
    SciF1d("\nLine Width:%d\r\n",
	    MissileXgc.CurLineWidth ) ;
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

CreatePatterns_pix_(whitepixel,blackpixel)
     unsigned long whitepixel,blackpixel;
{ int i ;
  for ( i=0 ; i < GREYNUMBER ; i++)
    Tabpix_[i] =XCreatePixmapFromBitmapData(dpy, root,grey0[i] ,8,8,whitepixel
		     ,blackpixel,XDefaultDepth (dpy,DefaultScreen(dpy)));
}


setpattern_pix_(num)
     int *num;
{ int i ; 
  i= Max(0,Min(*num,GREYNUMBER-1));
  MissileXgc.CurPattern = i;
  if ( use_color ==1) setc_c_pix_(i);
  else {
    XSetTile (dpy, gc, Tabpix_[i]); 
    if (i ==0)
      XSetFillStyle(dpy,gc,FillSolid);
    else 
      XSetFillStyle(dpy,gc,FillTiled);
  }
}

/** To get the id of the current pattern  **/

getpattern_pix_(verbose,num,narg)
     int *num,*verbose,*narg;
{ 
  *narg=1;
  *num = MissileXgc.CurPattern ;
  if (*verbose == 1) 
    SciF1d("\n Pattern : %d\r\n",
	    MissileXgc.CurPattern);
}

/** To get the id of the white pattern **/

getwhite_pix_(verbose,num,narg)
     int *num,*verbose,*narg;
{
  *num = MissileXgc.IDWhitePattern ;
  if (*verbose == 1) 
    SciF1d("\n Id of White Pattern %d\r\n",*num);
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

static int DashTab[6][4] = {
  {2,5,2,5}, {5,2,5,2},  {5,3,2,3}, {8,3,2,3},
  {11,3,2,3}, {11,3,5,3}};

setdash_pix_(value)
     int *value;
{
  static int maxdash = 6, l2=4,l3 ;
  l3 = Min(maxdash-1,*value-1);
  if ( use_color ==1) 
    {
      MissileXgc.CurDashStyle= *value;
      setc_c_pix_(*value);
    }
  else
    {
      setdashstyle_pix_(value,DashTab[Max(0,l3)],&l2);
      MissileXgc.CurDashStyle= l3 + 1 ;
    }
}

/** To change The X11-default dash style **/
/** if *value == 0, use a solid line, if *value != 0 **/
/** the dash style is specified by the xx vector of n values **/
/** xx[3]={5,3,7} and *n == 3 means :  5white 3 void 7 white \ldots **/

setdashstyle_pix_(value,xx,n)
     int *value,xx[],*n;
{
  int dashok= LineOnOffDash ;
  if ( *value == 0) dashok = LineSolid;
  else 
    {
      int i; char buffdash[18];
      for ( i =0 ; i < *n ; i++) buffdash[i]=xx[i];
      XSetDashes(dpy,gc,0,buffdash,*n);
    }
  XSetLineAttributes(dpy,gc,MissileXgc.CurLineWidth,dashok,CapButt,JoinMiter);
}

/** to get the current dash-style **/

getdash_pix_(verbose,value,narg)
     int *verbose,*value,*narg;
{int i ;
 *value=MissileXgc.CurDashStyle;
 *narg =1 ;
 if ( use_color ==1) 
   {
     if (*verbose == 1) SciF1d("Color %d",*value);
     return;
   }
 if ( *value == 0) 
   { if (*verbose == 1) Scistring("\nLine style = Line Solid");}
 else 
   {
     value[1]=4;
     *narg = value[1]+2;
     for ( i =0 ; i < value[1]; i++) value[i+2]=DashTab[*value-1][i];
     if (*verbose ==1 ) 
       {
	 SciF1d("\nDash Style %d:<",*value);
	 for ( i =0 ; i < value[1]; i++)
	   SciF1d("%d ",value[i+2]);
	 Scistring(">\n");
       }
   }
}

usecolor_pix_(num)
     int *num;
{
  if ( use_color != *num)
    {
      int i=0;
      use_color= *num;
      setdash_pix_(&i);
      setpattern_pix_(&i);
    }
}

/*-----------------------------------------------------------
  \encadre{general routines accessing the  set<> or get<>
  routines } 
-------------------------------------------------------------*/

static int InitMissileXgc();

empty_pix_(verbose)
     int *verbose;
{
  if ( *verbose == 1 ) Scistring("\n No operation ");
}

#define NUMSETFONC 16

/** Table in lexicographic order **/
int xsetfont_pix_(),xgetfont_pix_(),xsetmark_pix_(),xgetmark_pix_();

static struct bgc { char *name ;
	     int  (*setfonc )() ;
	     int  (*getfonc )() ;}
MissileGCTab_[] = {
  "alufunction",setalufunction1_pix_,getalufunction_pix_,
  "clipping",setclip_pix_,getclip_pix_,
  "dashes",setdash_pix_,getdash_pix_,
  "default",InitMissileXgc, empty_pix_,
  "font",xsetfont_pix_,xgetfont_pix_,
  "line mode",setabsourel_pix_,getabsourel_pix_,
  "mark",xsetmark_pix_,xgetmark_pix_,
  "pattern",setpattern_pix_,getpattern_pix_,
  "thickness",setthickness_pix_,getthickness_pix_,
  "use color",usecolor_pix_,empty_pix_,
  "wdim",setwindowdim_pix_,getwindowdim_pix_,
  "white",empty_pix_,getwhite_pix_,
  "window",setcurwin_pix_,getcurwin_pix_,
  "wpos",setwindowpos_pix_,getwindowpos_pix_,
  "wshow",show_pix_,empty_pix_,
  "wwpc",pixmapclear_pix_,empty_pix_
  };

MissileGCget_pix_(str,verbose,x1,x2,x3,x4,x5)
     char str[];
     int *verbose,*x1,*x2,*x3,*x4,*x5;
     
{ MissileGCGetorSet_pix_(str,1,verbose,x1,x2,x3,x4,x5);}

MissileGCset_pix_(str,x1,x2,x3,x4,x5)
     char str[];
     int *x1,*x2,*x3,*x4,*x5;
{int verbose=0 ;
 MissileGCGetorSet_pix_(str,0,&verbose,x1,x2,x3,x4,x5);
}

MissileGCGetorSet_pix_(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     int flag ;
     int  *verbose,*x1,*x2,*x3,*x4,*x5;
{ int i ;
  for (i=0; i < NUMSETFONC ; i++)
    {
      int j;
      j = strcmp(str,MissileGCTab_[i].name);
      if ( j == 0 ) 
	{ if (*verbose == 1)
	    SciF1s("\nGettting Info on %s\r\n",str);
	  if (flag == 1)
	    (MissileGCTab_[i].getfonc)(verbose,x1,x2,x3,x4,x5);
	  else 
	    (MissileGCTab_[i].setfonc)(x1,x2,x3,x4,x5);
	  return;}
      else 
	{ if ( j <= 0)
	    {
	      SciF1s("\nUnknow X operator <%s>\r\n",str);
	      return;
	    }
	}
    }
  SciF1s("\n Unknow X operator <%s>\r\n",str);
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

displaystring_pix_(string,x,y,angle,flag)
     int *x,*y ,*flag;
     double *angle;
     char string[] ;
{ 
  if ( Abs(*angle) <= 0.1) 
    {
      XDrawString(dpy, Cpixmap, gc,*x,*y,string,strlen(string));
      if ( *flag == 1) 
	{int rect[4];
	 boundingbox_pix_(string,x,y,rect);
	 rect[0]=rect[0]-4;rect[2]=rect[2]+6;
	 drawrectangle_pix_(string,rect,rect+1,rect+2,rect+3);
       }
    }
  else 
    DispStringAngle_pix_(x,y,string,angle);
  XFlush(dpy);
  
}

DispStringAngle_pix_(x0,yy0,string,angle)
     int *x0,*yy0;
     double *angle;
     char string[];
{
  int x,y,i,rect[4];
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
      XDrawString(dpy,Cpixmap,gc, x,y ,str1,1);
      boundingbox_pix_(str1,&x,&y,rect);
      /** drawrectangle_pix_(string,rect,rect+1,rect+2,rect+3); **/
      if ( cosa <= 0.0 && i < (int)strlen(string)-1)
	{ char str2[2];
	  /** si le cosinus est negatif le deplacement est a calculer **/
	  /** sur la boite du caractere suivant **/
	  str2[1]='\0';str2[0]=string[i+1];
	  boundingbox_pix_(str2,&x,&y,rect);
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

boundingbox_pix_(string,x,y,rect)
     int *x,*y,*rect;
     char string[];
{ int dir,asc,dsc;
  XCharStruct charret;
  XQueryTextExtents(dpy,MissileXgc.FontXID,
		    string,strlen(string),&dir,&asc,&dsc,&charret);
  rect[0]= *x ;
  rect[1]= *y-asc;
  rect[2]= charret.width;
  rect[3]= asc+dsc;
}

/*------------------------------------------------
subsection{ Segments and Arrows }
-------------------------------------------------*/

drawline_pix_(x1,yy1,x2,y2)
     int *x1, *x2, *yy1, *y2 ;
{
  XDrawLine(dpy, Cpixmap, gc, *x1, *yy1, *x2, *y2); 
  XFlush(dpy);
}

/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/

drawsegments_pix_(str,vx,vy,n)
     char str[];
     int *n,vx[],vy[];
{
  int i ;
  for (i=0 ; i < *n/2 ; i++)
    {
      XDrawLine(dpy,Cpixmap,gc,vx[2*i],vy[2*i],vx[2*i+1],vy[2*i+1]);
      XFlush(dpy);
    }
  XFlush(dpy);
}

/** Draw a set of arrows **/
/** arrows are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/
/** as is 10*arsize (arsize) the size of the arrow head in pixels **/

drawarrows_pix_(str,vx,vy,n,as)
     char str[];
     int *as;
     int *n,vx[],vy[];
{ 
  double cos20=cos(20.0*M_PI/180.0);
  double sin20=sin(20.0*M_PI/180.0);
  int polyx[4],polyy[4],fillvect[1];
  int i ;
  for (i=0 ; i < *n/2 ; i++)
    { 
      double dx,dy,norm;
      XDrawLine(dpy,Cpixmap,gc,vx[2*i],vy[2*i],vx[2*i+1],vy[2*i+1]);
      dx=( vx[2*i+1]-vx[2*i]);
      dy=( vy[2*i+1]-vy[2*i]);
      norm = sqrt(dx*dx+dy*dy);
      if ( Abs(norm) >  SMDOUBLE ) 
	{ int nn=1,p=3;
	  dx=(*as/10.0)*dx/norm;dy=(*as/10.0)*dy/norm;
	  polyx[0]= polyx[3]=vx[2*i+1]+dx*cos20;
	  polyx[1]= nint(polyx[0]  - cos20*dx -sin20*dy );
	  polyx[2]= nint(polyx[0]  - cos20*dx + sin20*dy);
	  polyy[0]= polyy[3]=vy[2*i+1]+dy*cos20;
	  polyy[1]= nint(polyy[0] + sin20*dx -cos20*dy) ;
	  polyy[2]= nint(polyy[0] - sin20*dx - cos20*dy) ;
	  fillpolylines_pix_("v",polyx,polyy,(fillvect[0]=0,fillvect),&nn,&p);
	  }
    }
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

drawrectangles_pix_(str,vects,fillvect,n)
     char str[];
     int *vects,*fillvect,*n;
{
  int i,cpat,verbose=0,num;
  getpattern_pix_(&verbose,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] > MissileXgc.IDWhitePattern )
	{
	  drawrectangle_pix_(str,vects+4*i,vects+4*i+1,vects+4*i+2,vects+4*i+3);
	}
      else
	{
	  setpattern_pix_(&(fillvect[i]));
	  fillrectangle_pix_(str,vects+4*i,vects+4*i+1,vects+4*i+2,vects+4*i+3);
	}
    }
  setpattern_pix_(&(cpat));
}

/** Draw one rectangle with current line style **/

drawrectangle_pix_(str,x,y,width,height)
     char str[];
     int  *x, *y, *width, *height;
{ 
  XDrawRectangle(dpy, Cpixmap, gc, *x, *y, (unsigned)*width,(unsigned)*height);
  XFlush(dpy); }

/** fill one rectangle, with current pattern **/

fillrectangle_pix_(str,x,y,width,height)
     char str[];
     int  *x, *y, *width, *height;
{ 
  XFillRectangle(dpy, Cpixmap, gc, *x, *y, *width, *height); 
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

drawarcs_pix_(str,vects,fillvect,n)
     char str[];
     int *vects,*fillvect,*n;
{
  int i,cpat,verb,num;
  verb=0;
  getpattern_pix_(&verb,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] > MissileXgc.IDWhitePattern )
	{setpattern_pix_(&(cpat));
	 drawarc_pix_(str,vects+6*i,vects+6*i+1,
		  vects+6*i+2,vects+6*i+3,
		  vects+6*i+4,vects+6*i+5);}
      else
	{
	  setpattern_pix_(&(fillvect[i]));
	  fillarc_pix_(str,vects+6*i,vects+6*i+1,
			 vects+6*i+2,vects+6*i+3,
			 vects+6*i+4,vects+6*i+5);
	}
    }
  setpattern_pix_(&(cpat));
}

/** Draw a single ellipsis or part of it **/

drawarc_pix_(str,x,y,width,height,angle1,angle2)
     char str[];
     int *angle1,*angle2, *x, *y, *width, *height;
{ 
  XDrawArc(dpy, Cpixmap, gc, *x, *y,(unsigned)*width,
	   (unsigned)*height,*angle1, *angle2);
  XFlush(dpy); }

/** Fill a single elipsis or part of it with current pattern **/

fillarc_pix_(str,x,y,width,height,angle1,angle2)
     char str[];
     int *angle1,*angle2, *x, *y, *width, *height;
{ 
  XFillArc(dpy, Cpixmap, gc, *x, *y, *width, *height, *angle1, *angle2);    
  XFlush(dpy);}

/*--------------------------------------------------------------
\encadre{Filling or Drawing Polylines and Polygons}
---------------------------------------------------------------*/

/** Draw a set of (*n) polylines (each of which have (*p) points) **/
/** with lines or marks **/
/** drawvect[i] >= 0 use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

drawpolylines_pix_(str,vectsx,vectsy,drawvect,n,p)
     char str[];
     int *vectsx,*vectsy,*drawvect,*n,*p;
{ int verbose=0 ,symb[2],Mnarg,Dnarg,Dvalue[10],NDvalue,i,close;
  /* store the current values */
  xgetmark_pix_(&verbose,symb,&Mnarg);
  getdash_pix_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i< *n ; i++)
    {
      if (drawvect[i] >= 0)
	{ /** we use the markid : drawvect[i] **/
	  xsetmark_pix_(drawvect+i,symb+1);
	  drawpolymark_pix_(str,p,vectsx+(*p)*i,vectsy+(*p)*i);
	}
      else
	{/** we use the line-style number abs(drawvect[i])  **/
	  NDvalue = - drawvect[i] -1 ;
	  setdash_pix_(&NDvalue);
	  close = 0;
	  drawpolyline_pix_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,&close);
	}
    }
  /** back to default values **/
  setdash_pix_( Dvalue);
  xsetmark_pix_(symb,symb+1);
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

fillpolylines_pix_(str,vectsx,vectsy,fillvect,n,p)
     char str[];
     int *vectsx,*vectsy,*fillvect,*n,*p;
{
  int i,cpat,verbose=0,num,close=1,pattern;
  getpattern_pix_(&verbose,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] >= MissileXgc.IDWhitePattern +2)
	{ /** on peint puis on fait un contour ferme **/
	  pattern= -fillvect[i]+2*MissileXgc.IDWhitePattern +2;
	  setpattern_pix_(&pattern);
	  fillpolyline_pix_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=1,&close));
	  setpattern_pix_(&(cpat));
	  drawpolyline_pix_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=1,&close));
	}
      else
	{
	  if (fillvect[i] == MissileXgc.IDWhitePattern + 1)
	      drawpolyline_pix_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=0,&close));
	  else 
	    {
	      setpattern_pix_(&(fillvect[i]));
	      fillpolyline_pix_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=0,&close));
	    }
	}
    }
  setpattern_pix_(&(cpat));
}

/** Only draw one polygon  with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/
/** n is the number of points of the polyline */

drawpolyline_pix_(str,n, vx, vy,closeflag)
     char str[];
     int *n,*closeflag;
     int vx[], vy[];
{ int n1;
  XPoint *ReturnPoints_pix_();
  if (*closeflag == 1) n1 = *n+1;else n1= *n;
  if (n1 >= 2) 
    {
      /*  analyze_points_pix_(*n, vx, vy,*closeflag); */
         /* Old code replaced by a routine with clipping  */
	 if (store_points_pix_(*n, vx, vy,*closeflag))
	{
	  XDrawLines (dpy, Cpixmap, gc, ReturnPoints_pix_(), n1,
		      MissileXgc.CurVectorStyle);
	  XFlush(dpy);
	} 
      XFlush(dpy);
    }
}

/** Fill the polygon or polyline **/
/** according to *closeflag : the given vector is a polyline or a polygon **/

fillpolyline_pix_(str,n, vx, vy,closeflag)
     char str[];
     int *n,*closeflag;
     int vx[], vy[];
{
  int n1;
  XPoint *ReturnPoints_pix_();
  if (*closeflag == 1) n1 = *n+1;else n1= *n;
  if (store_points_pix_(*n, vx, vy,*closeflag)){
    XFillPolygon (dpy, Cpixmap, gc, ReturnPoints_pix_(), n1,
		  Complex, MissileXgc.CurVectorStyle);
  }
  XFlush(dpy);
}

/** Draw the current mark centred at points defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_pix_(str,n, vx, vy)
     char str[];
     int *n ; 
     int vx[], vy[];
{
  XPoint *ReturnPoints_pix_();
  if ( MissileXgc.CurHardSymb == 0 )
    {if (store_points_pix_(*n, vx, vy,0))		
       XDrawPoints (dpy, Cpixmap, gc, ReturnPoints_pix_(), *n,CoordModeOrigin);
     XFlush(dpy);
   }
  else 
    { 
      int i,keepid,keepsize;
      i=1;
      keepid =  MissileXgc.FontId;
      keepsize= MissileXgc.FontSize;
      xsetfont_pix_(&i,&(MissileXgc.CurHardSymbSize));
      for ( i=0; i< *n ;i++) DrawMark_pix_(vx+i,vy+i);
      xsetfont_pix_(&keepid,&keepsize);
    }
}

/*-----------------------------------------
 \encadre{List of Window id}
-----------------------------------------*/

typedef  struct  {Window  win,bgwin ;
		  Pixmap  pixm;
		  int     winId;
		  struct WindowList *next;
		} WindowList  ;


static WindowList *The_List_ ;

AddNewWindowToList_pix_(wind,bgwind,pixm,num)
     Window wind,bgwind;
     Pixmap pixm;
     int num;
{AddNewWindow_pix_(&The_List_,wind,bgwind,pixm,num);}

AddNewWindow_pix_(listptr,wind,bgwind,pixm,num)
     WindowList **listptr;
     Window     wind,bgwind;
     Pixmap pixm;
     int num ;
{ 
  if ( num == 0 || *listptr == (WindowList *) NULL)
    {*listptr = (WindowList *) malloc ( sizeof ( WindowList ));
     if ( listptr == 0) 
       Scistring("AddNewWindow_ No More Place ");
     else 
       { (*listptr)->win=wind;
	 (*listptr)->bgwin=bgwind;
	 (*listptr)->pixm=pixm;
	 (*listptr)->winId = num;
         (*listptr)->next = (struct WindowList *) NULL ;}
   }
  else
    AddNewWindow_pix_((WindowList **) &((*listptr)->next),wind,bgwind,pixm,num);
}


Window GetWindowNumber_pix_(i)
     int i ;
{ Window GetWin_pix_();
  return( GetWin_pix_(The_List_,Max(0,i)));
}


Window GetBGWindowNumber_pix_(i)
     int i ;
{ Window GetBGWin_pix_();
  return( GetBGWin_pix_(The_List_,Max(0,i)));
}

Window GetWin_pix_(listptr,i)
     WindowList *listptr;
     int i; 
{
  if (listptr == (WindowList  *) NULL)
    return((Window ) NULL);
  else 
    { if ((listptr->winId) == i)
	return( listptr->win);
    else 
      return((Window )GetWin_pix_((WindowList *) listptr->next,i));
    }
}

Window GetBGWin_pix_(listptr,i)
     WindowList *listptr;
     int i; 
{
  if (listptr == (WindowList  *) NULL)
    return((Window ) NULL);
  else 
    { if ((listptr->winId) == i)
	return( listptr->bgwin);
    else 
      return((Window )GetBGWin_pix_((WindowList *) listptr->next,i));
    }
}


Pixmap GetPixmapNumber_pix_(i)
     int i ;
{ Pixmap GetPix_pix_();
  return( GetPix_pix_(The_List_,Max(0,i)));
}

Pixmap GetPix_pix_(listptr,i)
     WindowList *listptr;
     int i; 
{
  if (listptr == (WindowList  *) NULL)
    return((Pixmap ) NULL);
  else 
    { if ((listptr->winId) == i)
	return( listptr->pixm);
    else 
      return((Pixmap )GetPix_pix_((WindowList *) listptr->next,i));
    }
}

SetPixmapNumber_pix_(pixm,i)
     Pixmap pixm;
     int i ;
{ 
   SetPix_pix_(The_List_,pixm,Max(0,i));
}

SetPix_pix_(listptr,pixm,i)
     WindowList *listptr;
     int i; 
     Pixmap pixm;
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
	SetPix_pix_((WindowList *) listptr->next,pixm,i);
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
    (void) SciF1s(
           "Scilab : X error trapped - error message follows:\n%s\r\n", err_msg);
}


#define NUMCOLORS 17

typedef struct res {
    Pixel color[NUMCOLORS];
} RES, *RESPTR;

extern RES the_res;

setc_c_pix_(i)
     int i;
{
  XSetForeground(dpy, gc, the_res.color[Max(Min(i,NUMCOLORS-1),0)] );  
}

initgraphic_pix_(string)
     char string[];
{
  XWindowAttributes war;
  static int EntryCounter = 0;
  GC XCreateGC();
  static int  screen;
  static XEvent event;
  static XGCValues gcvalues;
  static Widget toplevel = (Widget) NULL;
  if (EntryCounter == 0)
    {
      /** This is done only at the first entry */
      DisplayInit(string,&dpy,&toplevel);
      if (AllocVectorStorage_pix_()==0) return(0);
      screen =DefaultScreen(dpy);
      root = XRootWindow (dpy, screen); 
      depth = XDefaultDepth (dpy, screen);
      LoadFonts();
      crosscursor = XCreateFontCursor(dpy, XC_crosshair);
      arrowcursor  = XCreateFontCursor (dpy, (char)0x2e);
      normalcursor = XCreateFontCursor (dpy, XC_X_cursor);
    }
  CreatePopupWindowPix(toplevel,&CWindow,&CBGWindow,&foreground,&background);
  if (EntryCounter == 0)
    {
      CreatePatterns_pix_(background,foreground);
    }
  XGetWindowAttributes(dpy,CWindow,&war); 	
  Cpixmap = XCreatePixmap(dpy, root, war.width,war.height, depth);
  XSetWindowBackgroundPixmap(dpy, CWindow, Cpixmap);
  AddNewWindowToList_pix_(CWindow,CBGWindow,Cpixmap,EntryCounter);
  MissileXgc.CurWindow =EntryCounter;
  if (EntryCounter == 0)
    {
      /* GC Set: for drawing */
      gcvalues.foreground = foreground;
      gcvalues.background = background;
      gcvalues.function   =  GXcopy ;
      gcvalues.line_width = 1;
      gc = XCreateGC(dpy, CWindow, GCFunction | GCForeground 
		     | GCBackground | GCLineWidth, &gcvalues);
      InitMissileXgc();
      XSetErrorHandler(X_error_handler);
      XSetIOErrorHandler((XIOErrorHandler) X_error_handler);
      XSetForeground(dpy,gc,background);
      XFillRectangle(dpy, Cpixmap, gc, 0, 0, war.width,war.height);
      XSetForeground(dpy,gc,foreground);
   } 
  EntryCounter= EntryCounter+1;
  XSync(dpy,0);
  return(0);
}


/*--------------------------------------------------------
  \encadre{Initialisation of the graphic context. Used also 
  to come back to the default graphic state}
---------------------------------------------------------*/

static int InitMissileXgc ()
{ int i,j,k[2] ;
  MissileXgc.IDWhitePattern = GREYNUMBER-1;
  MissileXgc.CurLineWidth=0 ;
  i=1;
  setthickness_pix_(&i);
  setalufunction1_pix_((i=3,&i));
  /** retirer le clipping **/
  i=j= -1;
  k[0]=5000,k[1]=5000;
  setclip_pix_(&i,&j,k,k+1);
  MissileXgc.ClipRegionSet= 0;
  setdash_pix_((i=0,&i));
  xsetfont_pix_((i=2,&i),(j=1,&j));
  xsetmark_pix_((i=0,&i),(j=0,&j));
  /** trac\'e absolu **/
  MissileXgc.CurVectorStyle = CoordModeOrigin ;
  setpattern_pix_((i=0,&i));
  strcpy(MissileXgc.CurNumberDispFormat,"%-5.2g");
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

drawaxis_pix_(str,alpha,nsteps,size,initpoint)
     char str[];
     int *alpha,*nsteps,*initpoint;
     double *size;
{ int i;
  double xi,yi,xf,yf;
  double cosal,sinal;
  cosal= cos( (double)M_PI * (*alpha)/180.0);
  sinal= sin( (double)M_PI * (*alpha)/180.0);
  for (i=0; i <= nsteps[0]*nsteps[1]; i++)
    { xi = initpoint[0]+i*size[0]*cosal;
      yi = initpoint[1]+i*size[0]*sinal;
      xf = xi - ( size[1]*sinal);
      yf = yi + ( size[1]*cosal);
      XDrawLine(dpy,Cpixmap,gc,nint(xi),nint(yi),nint(xf),nint(yf));
    }
  for (i=0; i <= nsteps[1]; i++)
    { xi = initpoint[0]+i*nsteps[0]*size[0]*cosal;
      yi = initpoint[1]+i*nsteps[0]*size[0]*sinal;
      xf = xi - ( size[1]*size[2]*sinal);
      yf = yi + ( size[1]*size[2]*cosal);
      XDrawLine(dpy,Cpixmap,gc,nint(xi),nint(yi),nint(xf),nint(yf));
    }
  xi = initpoint[0]; yi= initpoint[1];
  xf = initpoint[0]+ nsteps[0]*nsteps[1]*size[0]*cosal;
  yf = initpoint[1]+ nsteps[0]*nsteps[1]*size[0]*sinal;
  XDrawLine(dpy,Cpixmap,gc,nint(xi),nint(yi),nint(xf),nint(yf));
  XFlush(dpy);
}

/*-----------------------------------------------------
  \encadre{Display numbers z[i] at location (x[i],y[i])
  with a slope alpha[i] (see displaystring), if flag==1
  add a box around the string, only if slope =0}
-----------------------------------------------------*/

displaynumbers_pix_(str,x,y,z,alpha,n,flag)     
     char str[];
     int x[],y[],*n,*flag;
     double z[],alpha[];
{ int i ;
  char buf[20];
  for (i=0 ; i< *n ; i++)
    { sprintf(buf,MissileXgc.CurNumberDispFormat,z[i]);
      displaystring_pix_(buf,&(x[i]),&(y[i]),&(alpha[i]),flag) ;
    }
  XFlush(dpy);
}

bitmap_pix_(string,w,h)
     char string[];
     int w,h;
{
  static XImage *setimage;
  setimage = XCreateImage (dpy, XDefaultVisual (dpy, DefaultScreen(dpy)),
			       1, XYBitmap, 0, string,w,h, 8, 0);	
  setimage->data = string;
  XPutImage (dpy, Cpixmap, gc, setimage, 0, 0, 10,10,w,h);
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


struct FontInfo { int ok;
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

static FontAlias fonttab[] ={
  "CourR", "-adobe-courier-medium-r-normal--*-%s0-*-*-m-*-iso8859-1",
  "Symb", "-adobe-symbol-medium-r-normal--*-%s0-*-*-p-*-adobe-fontspecific",
  "TimR", "-adobe-times-medium-r-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimI", "-adobe-times-medium-i-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimB", "-adobe-times-bold-r-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimBI", "-adobe-times-bold-i-normal--*-%s0-*-*-p-*-iso8859-1",
  (char *) NULL,( char *) NULL};


int xsetfont_pix_(fontid,fontsize)
     int *fontid , *fontsize ;
{ int i,fsiz;
  i = Min(FONTNUMBER-1,Max(*fontid,0));
  fsiz = Min(FONTMAXSIZE-1,Max(*fontsize,0));
  if ( FontInfoTab_[i].ok !=1 )
    { 
      if (i != 6 )
	{
	  loadfamily_pix_(fonttab[i].alias,&i);
	}
      else 
	{
	  SciF1d(" The Font Id %d is not affected \r\n",i);
	  Scistring(" use xlfont to set it \n");
	  return;
	}
    }
  MissileXgc.FontId = i;
  MissileXgc.FontSize = fsiz;
  MissileXgc.FontXID=FontsList_[i][fsiz]->fid;
  XSetFont(dpy,gc,FontsList_[i][fsiz]->fid);
  XFlush(dpy);
}

/** To get the  id and size of the current font **/

int xgetfont_pix_(verbose,font,nargs)
     int *verbose,*font,*nargs;
{
  *nargs=2;
  font[0]= MissileXgc.FontId ;
  font[1] =MissileXgc.FontSize ;
  if (*verbose == 1) 
    {
      SciF1d("\nFontId : %d\r\n ",MissileXgc.FontId );
      SciF2s("--> %s at size %s pts\r\n",
	     FontInfoTab_[MissileXgc.FontId].fname,
	     size_[MissileXgc.FontSize]);
    }
}

/** To set the current mark **/
xsetmark_pix_(number,size)
     int *number ;
     int *size   ;
{ 
  MissileXgc.CurHardSymb = Max(Min(SYMBOLNUMBER-1,*number),0);
  MissileXgc.CurHardSymbSize = Max(Min(FONTMAXSIZE-1,*size),0);
  ;}

/** To get the current mark id **/

xgetmark_pix_(verbose,symb,narg)
     int *verbose,*symb,*narg;
{
  *narg =2 ;
  symb[0] = MissileXgc.CurHardSymb ;
  symb[1] = MissileXgc.CurHardSymbSize ;
  if (*verbose == 1) 
    {
      SciF1d("\nMark : %d\r\n",MissileXgc.CurHardSymb);
      SciF1s("at size %s pts\r\n", size_[MissileXgc.CurHardSymbSize]);
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

loadfamily_pix_(name,j)
     char *name;
     int *j;
{ int i,flag=1 ;
  /** generic name with % **/
  if ( strchr(name,'%') != (char *) NULL)
    {
      loadfamily_n_pix_(name,j);
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
	      loadfamily_n_pix_(fonttab[i].name,j);
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
	      SciF1s("\n Unknown font : %s",name1);
	      Scistring("\n I'll use font: fixed ");
	      FontsList_[*j][i]=XLoadQueryFont(dpy,"fixed");
	      if  (FontsList_[*j][i]== NULL)
		{
		  SciF1s("\n Unknown font : %s\r\n","fixed");
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

loadfamily_n_pix_(name,j)
     char *name;
     int *j;
{ char name1[200];
  int i,flag=1 ;
  for ( i = 0; i < FONTMAXSIZE ; i++)
    {
      sprintf(name1,name,size_n_[i]);
      FontsList_[*j][i]=XLoadQueryFont(dpy,name1);
      if  (FontsList_[*j][i]== NULL)
	{ 
	  flag=0;
	  SciF1s("\n Unknown font : %s",name1);
	  Scistring("\n I'll use font: fixed ");
	  FontsList_[*j][i]=XLoadQueryFont(dpy,"fixed");
	  if  (FontsList_[*j][i]== NULL)
	    {
	      SciF1s("\n Unknown font : %s\r\n","fixed");
	      Scistring(" Please call an X Wizard !");
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
  int fnum;
  loadfamily_pix_("CourR",(fnum=0,&fnum)); 
  LoadSymbFonts();
  loadfamily_pix_("TimR",(fnum=2,&fnum));
/*  On charge ces fonts a la demande et non pas a l'initialisation 
    sinon le temps de calcul est trop long
  loadfamily_pix_("TimI",(fnum=3,&fnum));
  loadfamily_pix_("TimB",(fnum=4,&fnum));
  loadfamily_pix_("TimBI",(fnum=5,&fnum)); 
  See xsetfont
*/
}

/** We use the Symbol font  for mark plotting **/
/** so we want to be able to center a Symbol character at a specified point **/

typedef  struct { int xoffset[SYMBOLNUMBER];
		  int yoffset[SYMBOLNUMBER];} Offset ;

static Offset ListOffset_[FONTMAXSIZE];
static char Marks[] = {
  /*
     0x2e : . alors que 0xb7 est un o plein trop gros 
     ., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle*/
  (char)0x2e,(char)0x2b,(char)0xb4,(char)0xc5,(char)0xa8,
  (char)0xe0,(char)0x44,(char)0xd1,(char)0xa7,(char)0x4f};
static int 
LoadSymbFonts()
{ XCharStruct xcs;
  int i,j,k ;
  /** Symbol Font is loaded under Id : 1 **/
  loadfamily_pix_("Symb",(i=1,&i));

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

int CurSymbXOffset_pix_()
{
  return(-(ListOffset_[MissileXgc.CurHardSymbSize].xoffset)
	 [MissileXgc.CurHardSymb]);
}
int CurSymbYOffset_pix_()
{
  return((ListOffset_[MissileXgc.CurHardSymbSize].yoffset)
	 [MissileXgc.CurHardSymb]);
}

DrawMark_pix_(x,y)
     int *x,*y ;
{ 
  char str[1];
  str[0]=Marks[MissileXgc.CurHardSymb];
  XDrawString(dpy,Cpixmap,gc,*x+CurSymbXOffset_pix_(),*y+CurSymbYOffset_pix_(),str,1);
  XFlush(dpy);
}

/*-------------------------------------------------------------------
\subsection{Allocation and storing function for vectors of X11-points}
------------------------------------------------------------------------*/

static XPoint *points;
static unsigned nbpoints;
#define NBPOINTS 256 

int store_points_pix_(n, vx, vy,onemore)
     int n,onemore;
     int vx[], vy[];
{ 
  int i,n1;
  if ( onemore == 1) n1=n+1;
  else n1=n;
  if (ReallocVector_pix_(n1) == 1)
    {
      for (i = 0; i < n; i++){
	points[i].x =(short) *vx++;
	points[i].y =(short) *vy++;
      }
      if (onemore == 1) {
	points[n].x=(short) points[0].x;
	points[n].y=(short) points[0].y;
      }
      return(1);
    }
  else return(0);
}

int ReallocVector_pix_(n)
     int n  ;
{
  while (n > nbpoints){
    nbpoints = 2 * nbpoints ;
    points = (XPoint *) realloc ((char *)points,
				 nbpoints * sizeof (XPoint));
    if (points == 0) 
      { perror(MESSAGE5);
	return (0);
      }
  }
  return(1);
}

int AllocVectorStorage_pix_()
{
  nbpoints = NBPOINTS;
  points = (XPoint *) malloc (nbpoints * sizeof (XPoint)); 
  if ( points == 0) { perror(MESSAGE4);return(0);}
  else return(1);
}

XPoint *ReturnPoints_pix_() { return(points); }

/** Clipping functions **/


static int xleft,xright,ybot,ytop;


/* Test a single point to be within the xleft,xright,ybot,ytop bbox.
 * Sets the returned integers 4 l.s.b. as follows:
 * bit 0 if to the left of xleft.
 * bit 1 if to the right of xright.
 * bit 2 if above of ytop.
 * bit 3 if below of ybot.
 * 0 is returned if inside.
 */
static int clip_point(x, y)
int x, y;
{
    int ret_val = 0;

    if (x < xleft) ret_val |= (char)0x01;
    if (x > xright) ret_val |= (char)0x02;
    if (y < ybot) ret_val |= (char)0x04;
    if (y > ytop) ret_val |= (char)0x08;

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

static int clip_line(x1, yy1, x2, y2, x1n, yy1n, x2n, y2n, flag)
     int x1, yy1, x2, y2, *flag, *x1n, *yy1n, *x2n, *y2n;
{
    int x, y, dx, dy, x_intr[2], y_intr[2], count, pos1, pos2;
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
		if (dx * (x2 - x_intr[0]) + dy * (y2 - y_intr[0]) > 0) {
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
		if (dx * (x_intr[0] - x1) + dy * (y_intr[0] - x1) > 0) {
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
      }
  }

static int change_points(i,x,y)
     int i,x,y;
{
  points[i].x=(short)x;   points[i].y=(short)y;
}


static int MyDraw(iib,iif,vx,vy)
     int iib,iif,vx[],vy[];
{
  int x1n,y1n,x11n,y11n,x2n,y2n,flag2,flag1;
  int npts;
  npts= ( iib > 0) ? iif-iib+2  : iif-iib+1;
  if ( iib > 0) 
    {
      clip_line(vx[iib-1],vy[iib-1],vx[iib],vy[iib],&x1n,&y1n,&x2n,&y2n,&flag1);
    }
  clip_line(vx[iif-1],vy[iif-1],vx[iif],vy[iif],&x11n,&y11n,&x2n,&y2n,&flag2);
  if (store_points_pix_(npts, &vx[Max(0,iib-1)], &vy[Max(0,iib-1)],0));
  {
    if (iib > 0 && (flag1==1||flag1==3)) change_points(0,x1n,y1n);
    if (flag2==2 || flag2==3) change_points(npts-1,x2n,y2n);
    XDrawLines (dpy, Cpixmap, gc, ReturnPoints_pix_(),npts,
		MissileXgc.CurVectorStyle);
  }
}

static int My2draw(j,vx,vy)
     int j,vx[],vy[];
{
  int vxn[2],vyn[2],flag,npts=2;
  clip_line(vx[j-1],vy[j-1],vx[j],vy[j],&vxn[0],&vyn[0],&vxn[1],&vyn[1],&flag);
  if (store_points_pix_(npts,vxn,vyn,0));
  {
    XDrawLines (dpy, Cpixmap, gc, ReturnPoints_pix_(),npts,
		MissileXgc.CurVectorStyle);
  }
}

/* 
 *  returns the first (vx[.],vy[.]) point inside 
 *  xleft,xright,ybot,ytop bbox. begining at index ideb
 *  or zero if the whole polyline is out 
 */

static int first_in(n,ideb,vx,vy)
     int n,ideb;
     int vx[], vy[];
{
  int i;
  for (i=ideb  ; i < n ; i++)
    {
      if (vx[i]>= xleft && vx[i] <= xright  && vy[i] >= ybot && vy[i] <= ytop)
	{
#ifdef DEBUG
	  SciF4d("first in %d->%d=(%d,%d)\r\n",ideb,i,vx[i],vy[i]);
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

static int first_out(n,ideb,vx,vy)
     int n,ideb;
     int vx[], vy[];
{
  int i;
  for (i=ideb  ; i < n ; i++)
    {
      if ( vx[i]< xleft || vx[i]> xright  || vy[i] < ybot || vy[i] > ytop) 
	{
#ifdef DEBUG
	  SciF4d("first out %d->%d=(%d,%d)\r\n",ideb,i,vx[i],vy[i]);
#endif
	  return(i);
	}
    }
  return(-1);
}


/* My own clipping routines  
  XDrawlines with clipping on the current graphic window 
  to ovoid trouble on some X servers **/

int analyze_points_pix_(n, vx, vy,onemore)
     int n,onemore;
     int vx[], vy[];
{ 
  int iib,iif,ideb=0,verbose=0,wd[2],narg,vxl[2],vyl[2];
  getwindowdim_pix_(&verbose,wd,&narg);
  xleft=0;xright=wd[0]; ybot=0;ytop=wd[1];
#ifdef DEBUG
    xleft=100;xright=300;
    ybot=100;ytop=300;
    XDrawRectangle(dpy, Cpixmap, gc,xleft,ybot,(unsigned)xright-xleft,
    (unsigned)ytop-ybot);
#endif
  while (1) 
    { int j;
      iib=first_in(n,ideb,vx,vy);
      if (iib == -1) { 
#ifdef DEBUG
	SciF2d("[%d,end=%d] polyline out\r\n",ideb,n);
	/* all points are out but segments can cross the box */
#endif 
	for (j=ideb+1; j < n; j++) My2draw(j,vx,vy);
	break;}
      iif=first_out(n,iib,vx,vy);
      if (iif == -1) {
#ifdef DEBUG
	SciF2d("[%d,end=%d] is in\r\n",iib,n);
#endif 
	MyDraw(iib,n-1,vx,vy);
	break;
      }
#ifdef DEBUG
      SciF2d("Analysed : [%d,%d]\r\n",iib,iif);
#endif 
      MyDraw(iib,iif,vx,vy);
      ideb=iif;
    }
  if (onemore == 1) {
    vxl[0]=vx[n-1];vxl[1]=vx[0];vyl[0]=vy[n-1];vyl[1]=vy[0];
    analyze_points_pix_(2,vxl,vyl,0);
  }
}

