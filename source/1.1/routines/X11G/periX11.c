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
#include "periX11.h"

#define VERSION "Scilab-1.1"

#define MESSAGE4 "Can't allocate point vector"
#define MESSAGE5 "Can't re-allocate point vector" 
#define Char2Int(x)   ( x & 0x000000ff )

/** Global variables to deal with X11 **/

static GC gc;
static Cursor arrowcursor,normalcursor;
static Window CWindow=(Window) NULL ,root=(Window) NULL;
static Display *dpy = (Display *) NULL;
static int use_color=0;

/** flag to decide between X11 and IX11 (scilab or xscilab ) */
extern int  xint_type;



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

Window Find_X_Scilab();
Window Find_BG_Window();
Window Find_ScilabGraphic_Window();
/*-----------------------------------------------------
\encadre{General routines}
-----------------------------------------------------*/

/** To select (raise on the screen )the current graphic Window  **/
/** If there's no graphic window then select creates one **/

xselgraphic_() 
{ 
  Window BGWindow=(Window) NULL;
  if (CWindow == (Window ) NULL) initgraphic_("");
  if (xint_type == 1)
    {
      BGWindow=Find_ScilabGraphic_Window(MissileXgc.CurWindow);
      if (BGWindow != (Window) NULL) 
	{
	  XRaiseWindow(dpy,BGWindow);
	}
      else 
	{
	  if (CWindow != (Window) NULL ) XRaiseWindow(dpy,CWindow);
	};
    }
  else
    {
      if (CWindow != (Window) NULL ) XRaiseWindow(dpy,CWindow);
    };
  XFlush(dpy);
};

/** End of graphic (do nothing)  **/

xendgraphic_()
{
} 

xend_()
{
  /** Must destroy everything  **/
}

/** Clear the current graphic window     **/

clearwindow_() 
{
  XClearWindow(dpy, CWindow);
  XFlush(dpy);
};

/*-----------------------------------------------------------
 \encadre{To generate a pause, in seconds}
------------------------------------------------------------*/

xpause_(str,sec_time)
     char str[];
     int *sec_time;
{ 
  unsigned useconds;
  useconds=(unsigned) *sec_time;
  if (useconds != 0)  
#ifdef sun
    usleep(useconds);
#else
    return;
#endif
};

/****************************************************************
\encadre{ Wait for mouse click in graphic window 
   send back mouse location  (x1,y1)  and button number  
   0,1,2}
   There's just a pb if the window is iconified when we try to click 
   in this case we return i= -1
****************************************************************/


xclick_(str,ibutton,x1,yy1)
     char str[];
     int *ibutton,*x1,*yy1 ;
{
  int status;
  Cursor cursor;
  XEvent event;
  Bool flag1=True;
  int buttons = 0;
  cursor = XCreateFontCursor(dpy, XC_crosshair);
  /*  remove the previous click events on the queue */
  while (flag1) flag1= XCheckWindowEvent(dpy,CWindow, ButtonPressMask,&event);
  /* Grab the pointer using target cursor, letting it room all over */
  status = XGrabPointer(dpy, CWindow, False,
			ButtonPressMask|ButtonReleaseMask, GrabModeSync,
			GrabModeAsync, CWindow, cursor, CurrentTime);
  if (status != GrabSuccess) {
    fprintf(stderr,"Can't grab the mouse.\n");
    *ibutton= -1;
    return;}
  while (buttons == 0) {
    /* allow one more event */
    XAllowEvents(dpy, SyncPointer, CurrentTime);
    XWindowEvent(dpy, CWindow, ButtonPressMask|ButtonReleaseMask, &event);
    switch (event.type) {
    case ButtonPress:
      *x1=event.xbutton.x;
      *yy1=event.xbutton.y;
      *ibutton=event.xbutton.button-1;
      buttons++;
      break;
    }
  };
  cursor = XCreateFontCursor (dpy, XC_X_cursor);
  XUngrabPointer(dpy, CurrentTime);      /* Done with pointer */
  XSync (dpy, 0);
}

/*------------------------------------------------
  \encadre{Clear a rectangle }
-------------------------------------------------*/

cleararea_(str,x,y,w,h)
     char str[];
     int *x,*y,*w,*h;
{
  XClearArea(dpy,CWindow,*x,*y,*w,*h,True);
  XFlush(dpy);
};

/*---------------------------------------------------------------------
\section{Function for graphic context modification}
------------------------------------------------------------------------*/

/** to get the window upper-left point coordinates on the screen  **/

getwindowpos_(verbose,x,narg)
     int *verbose,*x,*narg;
{
  XWindowAttributes war;
  *narg = 2;
  XGetWindowAttributes(dpy,CWindow,&war); 
  x[0]= war.x;
  x[1]= war.y;
  if (*verbose == 1) 
    fprintf(stderr,"\n CWindow position :%d,%d",x[0],x[1]);
};

/** to set the window upper-left point position on the screen **/

setwindowpos_(x,y)
     int *x,*y;
{
  Window BGWindow=(Window) NULL;
  if (xint_type == 1)
    {
      BGWindow=Find_ScilabGraphic_Window(MissileXgc.CurWindow);
      if (BGWindow != (Window) NULL) 
	XMoveWindow(dpy,BGWindow,*x,*y);
      else
	XMoveWindow(dpy,CWindow,*x,*y);
    }
  else
    XMoveWindow(dpy,CWindow,*x,*y);
  XFlush(dpy);
};

/** To get the window size **/

getwindowdim_(verbose,x,narg)
     int *verbose,*x,*narg;
{     
  XWindowAttributes war;
  *narg = 2;
  XGetWindowAttributes(dpy,CWindow,&war); 
  x[0]= war.width;
  x[1]= war.height;
  if (*verbose == 1) 
    fprintf(stderr,"\n CWindow dim :%d,%d",x[0],x[1]);
}; 

/** To change the window size  **/

setwindowdim_(x,y)
     int *x,*y;
{
  Window BGWindow=(Window) NULL;
  if (xint_type == 1)
    {
      BGWindow=Find_ScilabGraphic_Window(MissileXgc.CurWindow);
      if (BGWindow != (Window) NULL) 
	XResizeWindow(dpy,BGWindow,Max(*x,400),Max(*y,300));
      else
	XResizeWindow(dpy,CWindow,Max(*x,400),Max(*y,300));
    }
  else
    XResizeWindow(dpy,CWindow,Max(*x,400),Max(*y,300));
  XFlush(dpy);
};

/** To select a graphic Window  **/

setcurwin_(intnum)
     int *intnum;
{ 
  Window GetWindowNumber_();
  CWindow = GetWindowNumber_(*intnum);
  MissileXgc.CurWindow = *intnum;
  if (CWindow == (Window ) NULL)
    {
      int i;
      for (i=0;i <= *intnum;i++)
	    if ( GetWindowNumber_(*intnum)== (Window) NULL) initgraphic_("");
    };
};

/** Get the id number of the Current Graphic Window **/

getcurwin_(verbose,intnum,narg)
     int *verbose,*intnum,*narg;
{
  *narg =1 ;
  *intnum = MissileXgc.CurWindow ;
  if (*verbose == 1) 
    fprintf(stderr,"\nCurrent Graphic Window :%d",*intnum);
};

/** Set a clip zone (rectangle ) **/

setclip_(x,y,w,h)
     int *x,*y,*w,*h;
{
  int verbose=0,wd[2],narg;
  XRectangle rects[1];
  MissileXgc.ClipRegionSet = 1;
  getwindowdim_(&verbose,wd,&narg);
  rects[0].x= *x;
  rects[0].y= *y;
  rects[0].width= *w;
  rects[0].height= *h;
  MissileXgc.CurClipRegion[0]= rects[0].x;
  MissileXgc.CurClipRegion[1]= rects[0].y;
  MissileXgc.CurClipRegion[2]= rects[0].width;
  MissileXgc.CurClipRegion[3]= rects[0].height;
  XSetClipRectangles(dpy,gc,0,0,rects,1,Unsorted);
};

/** Get the boundaries of the current clip zone **/

getclip_(verbose,x,narg)
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
      fprintf(stderr,"\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d",
	      MissileXgc.CurClipRegion[0],
	      MissileXgc.CurClipRegion[1],
	      MissileXgc.CurClipRegion[2],
	      MissileXgc.CurClipRegion[3]);
    else 
      fprintf(stderr,"\nNo Clip Region");
};

/*----------------------------------------------------------
  \encadre{For the drawing functions dealing with vectors of 
  points, the following routine is used to select the mode 
  absolute or relative }
  Absolute mode if *num==0, relative mode if *num != 0
------------------------------------------------------------*/
/** to set absolute or relative mode **/

setabsourel_(num)
     int *num;
{
  if (*num == 0 )
    MissileXgc.CurVectorStyle =  CoordModeOrigin;
  else 
    MissileXgc.CurVectorStyle =  CoordModePrevious ;
};

/** to get information on absolute or relative mode **/

getabsourel_(verbose,num,narg)
     int *verbose,*num,*narg;
{
  *narg = 1;
  *num = MissileXgc.CurVectorStyle  ;
  if (*verbose == 1) 
    if (MissileXgc.CurVectorStyle == CoordModeOrigin)
      fprintf(stderr,"\nTrace Absolu");
    else 
      fprintf(stderr,"\nTrace Relatif");
};

/** The alu function for drawing : Works only with X11 **/
/** Not in Postscript **/

setalufunction_(string)
     char string[];
{     
  int value;
  XGCValues gcvalues;
  idfromname(string,&value);
  if ( value != -1)
    {MissileXgc.CurDrawFunction = value;
     gcvalues.function = value;
     XChangeGC(dpy, gc, GCFunction, &gcvalues);
   };
};
/** All the possibilities : Read The X11 manual to get more informations **/

struct alinfo { 
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


static unsigned long foreground, background;


setalufunction1_(num)
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
      };
      XChangeGC(dpy,gc,(GCForeground | GCBackground | GCFunction),&gcvalues);
    };
};

idfromname(name1,num)
     char name1[];
     int *num;
{int i;
 *num = -1;
 for ( i =0 ; i < 16;i++)
   if (strcmp(AluStruc_[i].name,name1)== 0) 
     *num=AluStruc_[i].id;
 if (*num == -1 ) 
   {
     fprintf(stderr,"\n Use the following keys (integer in scilab");
     for ( i=0 ; i < 16 ; i++)
       fprintf(stderr,"\nkey %s   -> %s",AluStruc_[i].name,
	       AluStruc_[i].info);
   };
};

/** To get the value of the alufunction **/

getalufunction_(verbose,value,narg)
     int *verbose , *value ,*narg;
{ 
  *narg =1 ;
  *value = MissileXgc.CurDrawFunction ;
  if (*verbose ==1 ) 
    { fprintf(stderr,"\nThe Alufunction is %s -> <%s>\n",
	      AluStruc_[*value].name,
	      AluStruc_[*value].info);}
};


/** to set the thickness of lines : 0 is a possible value **/
/** give the thinest line (0 and 1 the same for X11 but   **/
/** with diferent algorithms ) **/
/** defaut value is 1 **/

setthickness_(value)
     int *value ;
{ 
  XGCValues gcvalues;
  MissileXgc.CurLineWidth =Max(0, *value);
  gcvalues.line_width = Max(0, *value);
  XChangeGC(dpy, gc, GCLineWidth, &gcvalues); }

/** to get the thickness value **/

getthickness_(verbose,value,narg)
     int *verbose,*value,*narg;
{
  *narg =1 ;
  *value = MissileXgc.CurLineWidth ;
  if (*verbose ==1 ) 
    fprintf(stderr,"\nLine Width:%d",
	    MissileXgc.CurLineWidth ) ;
};

/** To set grey level for filing areas **/
/** from black (*num =0 ) to white     **/

#define GREYNUMBER 17
Pixmap  Tabpix_[GREYNUMBER];

static char grey0[GREYNUMBER][8]={
  {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
  {0x00, 0x00, 0x44, 0x00, 0x00, 0x00, 0x44, 0x00},
  {0x00, 0x44, 0x00, 0x22, 0x08, 0x40, 0x01, 0x20},
  {0x00, 0x92, 0x00, 0x25, 0x00, 0x92, 0x00, 0xa4},
  {0x55, 0x00, 0xaa, 0x00, 0x55, 0x00, 0xaa, 0x00},
  {0xad, 0x00, 0x5b, 0x00, 0xda, 0x00, 0x6d, 0x00},
  {0x6d, 0x02, 0xda, 0x08, 0x6b, 0x10, 0xb6, 0x20},
  {0x6d, 0x22, 0xda, 0x0c, 0x6b, 0x18, 0xb6, 0x24},
  {0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa},
  {0x92, 0xdd, 0x25, 0xf3, 0x94, 0xe7, 0x49, 0xdb},
  {0x92, 0xfd, 0x25, 0xf7, 0x94, 0xef, 0x49, 0xdf},
  {0x52, 0xff, 0xa4, 0xff, 0x25, 0xff, 0x92, 0xff},
  {0xaa, 0xff, 0x55, 0xff, 0xaa, 0xff, 0x55, 0xff},
  {0xff, 0x6d, 0xff, 0xda, 0xff, 0x6d, 0xff, 0x5b},
  {0xff, 0xbb, 0xff, 0xdd, 0xf7, 0xbf, 0xfe, 0xdf},
  {0xff, 0xff, 0xbb, 0xff, 0xff, 0xff, 0xbb, 0xff},
  {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
};

CreatePatterns_(whitepixel,blackpixel)
     unsigned long whitepixel,blackpixel;
{ int i ;
  for ( i=0 ; i < GREYNUMBER ; i++)
    Tabpix_[i] =XCreatePixmapFromBitmapData(dpy, root,grey0[i] ,8,8,whitepixel
		     ,blackpixel,XDefaultDepth (dpy,DefaultScreen(dpy)));
};


setpattern_(num)
     int *num;
{ int i ; 
  i= Max(0,Min(*num,GREYNUMBER-1));
  MissileXgc.CurPattern = i;
  if ( use_color ==1) set_c(i);
  else {
    XSetTile (dpy, gc, Tabpix_[i]); 
    if (i ==0)
      XSetFillStyle(dpy,gc,FillSolid);
    else 
      XSetFillStyle(dpy,gc,FillTiled);
  };
};

/** To get the id of the current pattern  **/

getpattern_(verbose,num,narg)
     int *num,*verbose,*narg;
{ 
  *narg=1;
  *num = MissileXgc.CurPattern ;
  if (*verbose == 1) 
    fprintf(stderr,"\n Pattern : %d",
	    MissileXgc.CurPattern);
};

/** To get the id of the white pattern **/

getwhite_(verbose,num,narg)
     int *num,*verbose,*narg;
{
  *num = MissileXgc.IDWhitePattern ;
  if (*verbose == 1) 
    fprintf(stderr,"\n Id of White Pattern %d :",*num);
  *narg=1;
};


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

setdash_(value)
     int *value;
{
  static int maxdash = 6, l2=4,l3 ;
  l3 = Min(maxdash-1,*value-1);
  MissileXgc.CurDashStyle= l3 + 1 ;
  if ( use_color ==1) set_c(*value-1);
  else
    setdashstyle_(value,DashTab[Max(0,l3)],&l2);
};

/** To change The X11-default dash style **/
/** if *value == 0, use a solid line, if *value != 0 **/
/** the dash style is specified by the xx vector of n values **/
/** xx[3]={5,3,7} and *n == 3 means :  5white 3 void 7 white \ldots **/

setdashstyle_(value,xx,n)
     int *value,xx[],*n;
{
  int dashok= LineOnOffDash ;
  if ( *value == 0) dashok = LineSolid;
  else 
    {
      int i; char buffdash[18];
      for ( i =0 ; i < *n ; i++) buffdash[i]=xx[i];
      XSetDashes(dpy,gc,0,buffdash,*n);
    };
  XSetLineAttributes(dpy,gc,MissileXgc.CurLineWidth,dashok,CapButt,JoinMiter);
}

/** to get the current dash-style **/

getdash_(verbose,value,narg)
     int *verbose,*value,*narg;
{int i ;
 *value=MissileXgc.CurDashStyle;
 *narg =1 ;
 if ( *value == 0) 
   { if (*verbose == 1) fprintf(stderr,"\nLine style = Line Solid");}
 else 
   {
     value[1]=4;
     *narg = value[1]+2;
     for ( i =0 ; i < value[1]; i++) value[i+2]=DashTab[*value-1][i];
     if (*verbose ==1 ) 
       {
	 fprintf(stderr,"\nDash Style %d:<",*value);
	 for ( i =0 ; i < value[1]; i++)
	   fprintf(stderr,"%d ",value[i+2]);
	 fprintf(stderr,">\n");
       }
   }
};


usecolor_(num)
     int *num;
{
  use_color= *num;
};

/*-----------------------------------------------------------
  \encadre{general routines accessing the  set<> or get<>
  routines } 
-------------------------------------------------------------*/

int InitMissileXgc();

empty_(verbose)
     int *verbose;
{
  if ( *verbose == 1 ) fprintf(stderr,"\n No operation ");
};

#define NUMSETFONC 14

/** Table in lexicographic order **/
int xsetfont_(),xgetfont_(),xsetmark_(),xgetmark_();

struct bgc { char *name ;
	     int  (*setfonc )() ;
	     int  (*getfonc )() ;}
MissileGCTab_[] = {
  "alufunction",setalufunction1_,getalufunction_,
  "clipping",setclip_,getclip_,
  "dashes",setdash_,getdash_,
  "default",InitMissileXgc, empty_,
  "font",xsetfont_,xgetfont_,
  "line mode",setabsourel_,getabsourel_,
  "mark",xsetmark_,xgetmark_,
  "pattern",setpattern_,getpattern_,
  "thickness",setthickness_,getthickness_,
  "use color",usecolor_,empty_,
  "wdim",setwindowdim_,getwindowdim_,
  "white",empty_,getwhite_,
  "window",setcurwin_,getcurwin_,
  "wpos",setwindowpos_,getwindowpos_
  };

MissileGCget_(str,verbose,x1,x2,x3,x4,x5)
     char str[];
     int *verbose,*x1,*x2,*x3,*x4,*x5;
     
{ MissileGCGetorSet_(str,1,verbose,x1,x2,x3,x4,x5);};

MissileGCset_(str,x1,x2,x3,x4,x5)
     char str[];
     int *x1,*x2,*x3,*x4,*x5;
{int verbose=0 ;
 MissileGCGetorSet_(str,0,&verbose,x1,x2,x3,x4,x5);
}

MissileGCGetorSet_(str,flag,verbose,x1,x2,x3,x4,x5)
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
	    fprintf(stderr,"\nGettting Info on %s",str);
	  if (flag == 1)
	    (MissileGCTab_[i].getfonc)(verbose,x1,x2,x3,x4,x5);
	  else 
	    (MissileGCTab_[i].setfonc)(x1,x2,x3,x4,x5);
	  return;}
      else 
	{ if ( j <= 0)
	    {
	      fprintf(stderr,"\nUnknow X operator <%s>",str);
	      return;
	    };
	};
    };
  fprintf(stderr,"\n Unknow X operator <%s>",str);
};

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

displaystring_(string,x,y,angle,flag)
     int *x,*y ,*flag;
     double *angle;
     char string[] ;
{ 
  if ( Abs(*angle) <= 0.1) 
    {
      XDrawString(dpy, CWindow, gc,*x,*y,string,strlen(string));
      if ( *flag == 1) 
	{int rect[4];
	 boundingbox_(string,x,y,rect);
	 rect[0]=rect[0]-4;rect[2]=rect[2]+6;
	 drawrectangle_(string,rect,rect+1,rect+2,rect+3);
       };
    }
  else 
    DispStringAngle_(x,y,string,angle);
  XFlush(dpy);
  
}

DispStringAngle_(x0,yy0,string,angle)
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
  for ( i = 0 ; i < strlen(string); i++)
    { 
      str1[0]=string[i];
      XDrawString(dpy,CWindow,gc, x,y ,str1,1);
      boundingbox_(str1,&x,&y,rect);
      /** drawrectangle_(string,rect,rect+1,rect+2,rect+3); **/
      if ( cosa <= 0.0 && i < strlen(string)-1)
	{ char str2[2];
	  /** si le cosinus est negatif le deplacement est a calculer **/
	  /** sur la boite du caractere suivant **/
	  str2[1]='\0';str2[0]=string[i+1];
	  boundingbox_(str2,&x,&y,rect);
	};
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
    };
};

/** To get the bounding rectangle of a string **/

boundingbox_(string,x,y,rect)
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
};

/*------------------------------------------------
subsection{ Segments and Arrows }
-------------------------------------------------*/

drawline_(x1,yy1,x2,y2)
     int *x1, *x2, *yy1, *y2 ;
{
  XDrawLine(dpy, CWindow, gc, *x1, *yy1, *x2, *y2); 
  XFlush(dpy);
}

/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/

drawsegments_(str,vx,vy,n)
     char str[];
     int *n,vx[],vy[];
{
  int i ;
  for (i=0 ; i < *n/2 ; i++)
    {
      XDrawLine(dpy,CWindow,gc,vx[2*i],vy[2*i],vx[2*i+1],vy[2*i+1]);
      XFlush(dpy);
    };
  XFlush(dpy);
};

/** Draw a set of arrows **/
/** arrows are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/
/** as is 10*arsize (arsize) the size of the arrow head in pixels **/

drawarrows_(str,vx,vy,n,as)
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
      XDrawLine(dpy,CWindow,gc,vx[2*i],vy[2*i],vx[2*i+1],vy[2*i+1]);
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
	  fillpolylines_("v",polyx,polyy,(fillvect[0]=0,fillvect),&nn,&p);
	  };
    };
      XFlush(dpy);
};

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

drawrectangles_(str,vects,fillvect,n)
     char str[];
     int *vects,*fillvect,*n;
{
  int i,cpat,verbose=0,num;
  getpattern_(&verbose,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] > MissileXgc.IDWhitePattern )
	{
	  drawrectangle_(str,vects+4*i,vects+4*i+1,vects+4*i+2,vects+4*i+3);
	}
      else
	{
	  setpattern_(&(fillvect[i]));
	  fillrectangle_(str,vects+4*i,vects+4*i+1,vects+4*i+2,vects+4*i+3);
	}
    }
  setpattern_(&(cpat));
};

/** Draw one rectangle with current line style **/

drawrectangle_(str,x,y,width,height)
     char str[];
     int  *x, *y, *width, *height;
{ 
  XDrawRectangle(dpy, CWindow, gc, *x, *y, (unsigned)*width,(unsigned)*height);
  XFlush(dpy); }

/** fill one rectangle, with current pattern **/

fillrectangle_(str,x,y,width,height)
     char str[];
     int  *x, *y, *width, *height;
{ 
  XFillRectangle(dpy, CWindow, gc, *x, *y, *width, *height); 
  XFlush(dpy);
};

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

drawarcs_(str,vects,fillvect,n)
     char str[];
     int *vects,*fillvect,*n;
{
  int i,cpat,verb,num;
  verb=0;
  getpattern_(&verb,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] > MissileXgc.IDWhitePattern )
	{setpattern_(&(cpat));
	 drawarc_(str,vects+6*i,vects+6*i+1,
		  vects+6*i+2,vects+6*i+3,
		  vects+6*i+4,vects+6*i+5);}
      else
	{
	  setpattern_(&(fillvect[i]));
	  fillarc_(str,vects+6*i,vects+6*i+1,
			 vects+6*i+2,vects+6*i+3,
			 vects+6*i+4,vects+6*i+5);
	}
    }
  setpattern_(&(cpat));
};

/** Draw a single ellipsis or part of it **/

drawarc_(str,x,y,width,height,angle1,angle2)
     char str[];
     int *angle1,*angle2, *x, *y, *width, *height;
{ 
  XDrawArc(dpy, CWindow, gc, *x, *y,(unsigned)*width,
	   (unsigned)*height,*angle1, *angle2);
  XFlush(dpy); }

/** Fill a single elipsis or part of it with current pattern **/

fillarc_(str,x,y,width,height,angle1,angle2)
     char str[];
     int *angle1,*angle2, *x, *y, *width, *height;
{ 
  XFillArc(dpy, CWindow, gc, *x, *y, *width, *height, *angle1, *angle2);    
  XFlush(dpy);}

/*--------------------------------------------------------------
\encadre{Filling or Drawing Polylines and Polygons}
---------------------------------------------------------------*/

/** Draw a set of (*n) polylines (each of which have (*p) points) **/
/** with lines or marks **/
/** drawvect[i] >= 0 use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

drawpolylines_(str,vectsx,vectsy,drawvect,n,p)
     char str[];
     int *vectsx,*vectsy,*drawvect,*n,*p;
{ int verbose=0 ,symb[2],Mnarg,Dnarg,Dvalue[10],NDvalue,i,close;
  /* store the current values */
  xgetmark_(&verbose,symb,&Mnarg);
  getdash_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i< *n ; i++)
    {
      if (drawvect[i] >= 0)
	{ /** we use the markid : drawvect[i] **/
	  xsetmark_(drawvect+i,symb+1);
	  drawpolymark_(str,p,vectsx+(*p)*i,vectsy+(*p)*i);
	}
      else
	{/** we use the line-style number abs(drawvect[i])  **/
	  NDvalue = - drawvect[i] -1 ;
	  setdash_(&NDvalue);
	  close = 0;
	  drawpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,&close);
	};
    };
  /** back to default values **/
  setdash_( Dvalue);
  xsetmark_(symb,symb+1);
};

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

fillpolylines_(str,vectsx,vectsy,fillvect,n,p)
     char str[];
     int *vectsx,*vectsy,*fillvect,*n,*p;
{
  int i,cpat,verbose=0,num,close=1,pattern;
  getpattern_(&verbose,&cpat,&num);
  for (i=0 ; i< *n ; i++)
    {
      if (fillvect[i] >= MissileXgc.IDWhitePattern +2)
	{ /** on peint puis on fait un contour ferme **/
	  pattern= -fillvect[i]+2*MissileXgc.IDWhitePattern +2;
	  setpattern_(&pattern);
	  fillpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=1,&close));
	  setpattern_(&(cpat));
	  drawpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=1,&close));
	}
      else
	{
	  if (fillvect[i] == MissileXgc.IDWhitePattern + 1)
	      drawpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=0,&close));
	  else 
	    {
	      setpattern_(&(fillvect[i]));
	      fillpolyline_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,(close=0,&close));
	    }
	}
    }
  setpattern_(&(cpat));
};

/** Only draw one polygon  with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/
/** n is the number of points of the polyline */

drawpolyline_(str,n, vx, vy,closeflag)
     char str[];
     int *n,*closeflag;
     int vx[], vy[];
{ int n1;
  XPoint *ReturnPoints_();
  if (*closeflag == 1) n1 = *n+1;else n1= *n;
  if (n1 >= 2) 
    {
      analyze_points_(*n, vx, vy,*closeflag);
      /* Old code replaced by a routine with clipping
	 if (store_points_(*n, vx, vy,*closeflag))
	{
	  XDrawLines (dpy, CWindow, gc, ReturnPoints_(), n1,
		      MissileXgc.CurVectorStyle);
	  XFlush(dpy);
	}
      XFlush(dpy);
      */
    }
};

/** Fill the polygon or polyline **/
/** according to *closeflag : the given vector is a polyline or a polygon **/

fillpolyline_(str,n, vx, vy,closeflag)
     char str[];
     int *n,*closeflag;
     int vx[], vy[];
{
  int n1;
  XPoint *ReturnPoints_();
  if (*closeflag == 1) n1 = *n+1;else n1= *n;
  if (store_points_(*n, vx, vy,*closeflag)){
    XFillPolygon (dpy, CWindow, gc, ReturnPoints_(), n1,
		  Complex, MissileXgc.CurVectorStyle);
  };
  XFlush(dpy);
}

/** Draw the current mark centred at points defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_(str,n, vx, vy)
     char str[];
     int *n ; 
     int vx[], vy[];
{
  XPoint *ReturnPoints_();
  if ( MissileXgc.CurHardSymb == 0 )
    {if (store_points_(*n, vx, vy,0))		
       XDrawPoints (dpy, CWindow, gc, ReturnPoints_(), *n,CoordModeOrigin);
     XFlush(dpy);
   }
  else 
    { 
      int i,keepid,keepsize;
      i=1;
      keepid =  MissileXgc.FontId;
      keepsize= MissileXgc.FontSize;
      xsetfont_(&i,&(MissileXgc.CurHardSymbSize));
      for ( i=0; i< *n ;i++) DrawMark_(vx+i,vy+i);
      xsetfont_(&keepid,&keepsize);
    };
};

/*-----------------------------------------
 \encadre{List of Window id}
-----------------------------------------*/

typedef  struct  {Window  win ;
		  int     winId;
		  struct WindowList *next;
		} WindowList  ;

int windowcount ;

WindowList *The_List_ ;

AddNewWindowToList_(wind,num)
     Window wind;
     int num;
{AddNewWindow_(&The_List_,wind,num);};

AddNewWindow_(listptr,wind,num)
     WindowList **listptr;
     Window     wind;
     int num ;
{ 
  if ( num == 0 || *listptr == (WindowList *) NULL)
    {*listptr = (WindowList *) malloc ( sizeof ( WindowList ));
     if ( listptr == 0) 
       fprintf(stderr,"AddNewWindow_ No More Place ");
     else 
       { (*listptr)->win=wind;
	 (*listptr)->winId = num;
         (*listptr)->next = (struct WindowList *) NULL ;}
   }
  else
    AddNewWindow_((WindowList **) &((*listptr)->next),wind,num);
};

Window GetWindowNumber_(i)
     int i ;
{ Window GetWin_();
  return( GetWin_(The_List_,Max(0,i)));
};

Window GetWin_(listptr,i)
     WindowList *listptr;
     int i; 
{
  if (listptr == (WindowList  *) NULL)
    return((Window ) NULL);
  else 
    { if ((listptr->winId) == i)
	return( listptr->win);
    else 
      return((Window )GetWin_((WindowList *) listptr->next,i));
    };
};

/*--------------------------------------------------------------
  \encadre{Routine for initialisation : string is a display name }
--------------------------------------------------------------*/
#define MAXERRMSGLEN 512

X_error_handler(d, err_ev)
    Display        *d;
    XErrorEvent    *err_ev;
{
    char            err_msg[MAXERRMSGLEN];

    XGetErrorText(dpy, (int) (err_ev->error_code), err_msg, MAXERRMSGLEN - 1);
    (void) fprintf(stderr,
           "Scilab : X error trapped - error message follows:\n%s\n", err_msg);
}


#define NUMCOLORS 17

typedef struct res {
    Pixel color[NUMCOLORS];
} RES, *RESPTR;

extern RES the_res;

set_c(i)
     int i;
{
  XSetForeground(dpy, gc, the_res.color[Max(Min(i,NUMCOLORS-1),0)] );  
} ;


initgraphic_(string)
     char string[];
{
  if ( xint_type == 1) 
    initgraphicI_(string,1);
  else 
    initgraphicI_(string,0);
}

initgraphicI_(string,ii)
     char string[];
     int ii;
{ 
  static int EntryCounter = 0;
  GC XCreateGC();
  char winname[11];
  static int  screen,depth;
  static XEvent event;
  static Visual visual;
  static XSetWindowAttributes attributes;
  static XGCValues gcvalues;
  if (EntryCounter == 0)
    {
      /** This is done only at te first entry */
      DisplayInit(string,&dpy,&foreground,&background);
      if (AllocVectorStorage_()==0) return(0);
      screen =DefaultScreen(dpy);
      root = XRootWindow (dpy, screen); 
      depth = XDefaultDepth (dpy, screen);
      CreatePatterns_(background,foreground);
      LoadFonts();
      arrowcursor  = XCreateFontCursor (dpy, 0x2e);
      normalcursor = XCreateFontCursor (dpy, XC_X_cursor);
      visual.visualid = CopyFromParent;
      attributes.background_pixel = background;
      attributes.border_pixel = foreground;
      attributes.cursor = arrowcursor;
      attributes.backing_store = Always;
      attributes.bit_gravity = NorthWestGravity;
      attributes.event_mask = ExposureMask | KeyPressMask | ButtonPressMask |
	SubstructureNotifyMask;
      windowcount = 0;
    };
  sprintf(winname,"BG%d",EntryCounter);
  if (ii==0)
    {   Atom	 wmDeleteWindow;
      /** Explicit creation of a graphic window **/
      CWindow =
	 XCreateWindow(dpy, RootWindow(dpy, screen),
		       20*EntryCounter+20, 20*EntryCounter+20,
		       600 , 424 , 1, depth , CopyFromParent, &visual,
		       CWBitGravity | CWEventMask | CWBackPixel |
		       CWBorderPixel | CWBackingStore 
		       | CWCursor , &attributes);
       AddNewWindowToList_(CWindow,EntryCounter);
       XChangeProperty(dpy, CWindow, XA_WM_NAME, XA_STRING, 8, 
		       PropModeReplace, winname, 5);
      /* On ignore les delete envoyes par le Window Manager */
      wmDeleteWindow = XInternAtom(dpy,"WM_DELETE_WINDOW", False);
      XSetWMProtocols(dpy,CWindow, &wmDeleteWindow, 1);
       XMapWindow(dpy ,CWindow);
       while (1) {
	 XNextEvent(dpy, &event);
	 if (event.type == Expose) 
	   break;
       }
     }
  else
    {
      /** Try to find an existing graphic window Managed by xscilab **/
      CWindow = Find_BG_Window(EntryCounter);
      if (CWindow == 0)
	{
	  Window local;
	  local = Find_X_Scilab();
	  if (local !=0)
	    {
	      int i;
      	      /* XScilab exists : I send a message */ 
	      /* fprintf(stderr,"Message To Scilab\n"); */
	      SendScilab(local,EntryCounter);
	      XSync(dpy,0);
	      /* I try again to find a graphic window */
	      /* while xcsilab is creating one */
	      /* there's certainly a better way to do this */
	      /* I just make a ``for'' while waiting */
	      for (i=0;(CWindow =Find_BG_Window(EntryCounter))==0 && i<2000
		          ;i++);
	      if (CWindow == 0)
		{
		  fprintf(stderr,"\nI can't find an Xscilab graphic window\n");
		  initgraphicI_(string,0);
		  return(0);
		};
	    }
	  else
	    {
	      initgraphicI_(string,0);
	      return(0);
	    };
	};
      AddNewWindowToList_(CWindow,EntryCounter);
      MissileXgc.CurWindow =EntryCounter;
    }
  MissileXgc.CurWindow = EntryCounter;
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
   }; 
  EntryCounter= EntryCounter+1;
  XSync(dpy,0);
  return(0);
};


/*
 * Envoit un message de type ClientMessage a XScilab
 * Demande a scilab de creer une fenetre graphique
 */

Atom		NewGraphWindowMessageAtom;

SendScilab(local,winnum)
     Window local;
     int winnum;
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

Window Window_With_Name( top, name,j,ResList0,ResList1,ResList2)
     Window top;
     char *name, *ResList0,*ResList1,*ResList2;
     int j;
{
  Status status;
  Window *children,root1,parent1,w=0;
  unsigned int nchildren=0;
  int i; 
  char *window_name;
  if ( CheckWin(top)==0) return((Window) 0);
  status=XQueryTree(dpy, top, &root1, &parent1, &children, &nchildren);
  DbugInfo1(" Status %d\n",status);
  if ( status == 0)
    {
      DbugInfo0("XQuery Tree failed \n");
      return((Window) 0);
    };
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
		};
	    };
	  if (window_name) XFree(window_name);
	};
    };
  return((Window) w);
};


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
     int i;
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
     int i;
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

static int val;
static jmp_buf my_env;

Ignore_Err(d, err_ev)
    Display        *d;
    XErrorEvent    *err_ev;
{DbugInfo0("Ignoring Error");
 longjmp(my_env,1);};

int 
CheckWin(w)
     Window w;
{
  Window root_ret;
  int x, y;
  unsigned width= -1, height= -1, bw, depth;
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
      XGetGeometry (dpy, w, &root_ret, &x, &y, &width, &height, &bw, &depth);
      XSync (dpy, 0);
      XSetErrorHandler((XErrorHandler) curh);
      return(1);};
};


/*--------------------------------------------------------
  \encadre{Initialisation of the graphic context. Used also 
  to come back to the default graphic state}
---------------------------------------------------------*/

InitMissileXgc ()
{ int i,j,k[2] ;
  MissileXgc.IDWhitePattern = GREYNUMBER-1;
  MissileXgc.CurLineWidth=0 ;
  i=1;
  setthickness_(&i);
  setalufunction1_((i=3,&i));
  /** retirer le clipping **/
  i=j= -1;
  k[0]=5000,k[1]=5000;
  setclip_(&i,&j,k,k+1);
  MissileXgc.ClipRegionSet= 0;
  setdash_((i=0,&i));
  xsetfont_((i=2,&i),(j=1,&j));
  xsetmark_((i=0,&i),(j=0,&j));
  /** trac\'e absolu **/
  MissileXgc.CurVectorStyle = CoordModeOrigin ;
  setpattern_((i=0,&i));
  strcpy(MissileXgc.CurNumberDispFormat,"%-5.2g");
};

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

drawaxis_(str,alpha,nsteps,size,initpoint)
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
      XDrawLine(dpy,CWindow,gc,nint(xi),nint(yi),nint(xf),nint(yf));
    };
  for (i=0; i <= nsteps[1]; i++)
    { xi = initpoint[0]+i*nsteps[0]*size[0]*cosal;
      yi = initpoint[1]+i*nsteps[0]*size[0]*sinal;
      xf = xi - ( size[1]*size[2]*sinal);
      yf = yi + ( size[1]*size[2]*cosal);
      XDrawLine(dpy,CWindow,gc,nint(xi),nint(yi),nint(xf),nint(yf));
    };
  xi = initpoint[0]; yi= initpoint[1];
  xf = initpoint[0]+ nsteps[0]*nsteps[1]*size[0]*cosal;
  yf = initpoint[1]+ nsteps[0]*nsteps[1]*size[0]*sinal;
  XDrawLine(dpy,CWindow,gc,nint(xi),nint(yi),nint(xf),nint(yf));
  XFlush(dpy);
};

/*-----------------------------------------------------
  \encadre{Display numbers z[i] at location (x[i],y[i])
  with a slope alpha[i] (see displaystring), if flag==1
  add a box around the string, only if slope =0}
-----------------------------------------------------*/

displaynumbers_(str,x,y,z,alpha,n,flag)     
     char str[];
     int x[],y[],*n,*flag;
     double z[],alpha[];
{ int i ;
  char buf[20];
  for (i=0 ; i< *n ; i++)
    { sprintf(buf,MissileXgc.CurNumberDispFormat,z[i]);
      displaystring_(buf,&(x[i]),&(y[i]),&(alpha[i]),flag) ;
    };
  XFlush(dpy);
};

bitmap_(string,w,h)
     char string[];
     int w,h;
{
  static XImage *setimage;
  setimage = XCreateImage (dpy, XDefaultVisual (dpy, DefaultScreen(dpy)),
			       1, XYBitmap, 0, string,w,h, 8, 0);	
  setimage->data = string;
  XPutImage (dpy, CWindow, gc, setimage, 0, 0, 10,10,w,h);
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

FontAlias fonttab_o[] ={
  "CourR", "-adobe-courier-medium-r-normal--%s-*-75-75-m-*-iso8859-1",
  "Symb", "-adobe-symbol-medium-r-normal--%s-*-75-75-p-*-adobe-fontspecific",
  "TimR", "-adobe-times-medium-r-normal--%s-*-75-75-p-*-iso8859-1",
  "TimI", "-adobe-times-medium-i-normal--%s-*-75-75-p-*-iso8859-1",
  "TimB", "-adobe-times-bold-r-normal--%s-*-75-75-p-*-iso8859-1",
  "TimBI", "-adobe-times-bold-i-normal--%s-*-75-75-p-*-iso8859-1",
  (char *) NULL,( char *) NULL};

/** ce qui suit marche sur 75dpi ou 100dpi **/

FontAlias fonttab[] ={
  "CourR", "-adobe-courier-medium-r-normal--*-%s0-*-*-m-*-iso8859-1",
  "Symb", "-adobe-symbol-medium-r-normal--*-%s0-*-*-p-*-adobe-fontspecific",
  "TimR", "-adobe-times-medium-r-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimI", "-adobe-times-medium-i-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimB", "-adobe-times-bold-r-normal--*-%s0-*-*-p-*-iso8859-1",
  "TimBI", "-adobe-times-bold-i-normal--*-%s0-*-*-p-*-iso8859-1",
  (char *) NULL,( char *) NULL};


int xsetfont_(fontid,fontsize)
     int *fontid , *fontsize ;
{ int i,fsiz;
  i = Min(FONTNUMBER-1,Max(*fontid,0));
  fsiz = Min(FONTMAXSIZE-1,Max(*fontsize,0));
  if ( FontInfoTab_[i].ok !=1 )
    { 
      if (i != 6 )
	{
	  loadfamily_(fonttab[i].alias,&i);
	}
      else 
	{
	  fprintf(stderr," The Font Id %d is not affected \n",i);
	  fprintf(stderr," use xlfont to set it \n");
	  return;
	}
    };
  MissileXgc.FontId = i;
  MissileXgc.FontSize = fsiz;
  MissileXgc.FontXID=FontsList_[i][fsiz]->fid;
  XSetFont(dpy,gc,FontsList_[i][fsiz]->fid);
  XFlush(dpy);
};

/** To get the  id and size of the current font **/

int xgetfont_(verbose,font,nargs)
     int *verbose,*font,*nargs;
{
  *nargs=2;
  font[0]= MissileXgc.FontId ;
  font[1] =MissileXgc.FontSize ;
  if (*verbose == 1) 
    {
      fprintf(stderr,"\nFontId : %d --> %s at size %s pts",
	      MissileXgc.FontId ,
	      FontInfoTab_[MissileXgc.FontId].fname,
	      size_[MissileXgc.FontSize]);
    };
};

/** To set the current mark **/
xsetmark_(number,size)
     int *number ;
     int *size   ;
{ 
  MissileXgc.CurHardSymb = Max(Min(SYMBOLNUMBER-1,*number),0);
  MissileXgc.CurHardSymbSize = Max(Min(FONTMAXSIZE-1,*size),0);
  ;}

/** To get the current mark id **/

xgetmark_(verbose,symb,narg)
     int *verbose,*symb,*narg;
{
  *narg =2 ;
  symb[0] = MissileXgc.CurHardSymb ;
  symb[1] = MissileXgc.CurHardSymbSize ;
  if (*verbose == 1) 
    fprintf(stderr,"\nMark : %d at size %s pts",MissileXgc.CurHardSymb,
	    size_[MissileXgc.CurHardSymbSize]);
};

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

loadfamily_(name,j)
     char *name;
     int *j;
{ int i,flag=1 ;
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
	};
      /** Using X11 Table of aliases **/
      for ( i = 0; i < FONTMAXSIZE ; i++)
	{
	  char name1[200];
	  sprintf(name1,"%s%s",name,size_[i]);
	  FontsList_[*j][i]=XLoadQueryFont(dpy,name1);
	  if  (FontsList_[*j][i]== NULL)
	    { 
	      flag=0;
	      fprintf(stderr,"\n Unknown font : %s",name1);
	      fprintf(stderr,"\n I'll use font: fixed ");
	      FontsList_[*j][i]=XLoadQueryFont(dpy,"fixed");
	      if  (FontsList_[*j][i]== NULL)
		{
		  fprintf(stderr,"\n Unknown font : %s","fixed");
		  fprintf(stderr,"\n Please call an X Wizard !");
		};
	    };
	};
      FontInfoTab_[*j].ok = 1;
      if (flag != 0) 
	strcpy(FontInfoTab_[*j].fname,name);
      else
	strcpy(FontInfoTab_[*j].fname,"fixed");
    };
};

static char *size_n_[] = { "8" ,"10","12","14","18","24"};

loadfamily_n_(name,j)
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
	  fprintf(stderr,"\n Unknown font : %s",name1);
	  fprintf(stderr,"\n I'll use font: fixed ");
	  FontsList_[*j][i]=XLoadQueryFont(dpy,"fixed");
	  if  (FontsList_[*j][i]== NULL)
	    {
	      fprintf(stderr,"\n Unknown font : %s","fixed");
	      fprintf(stderr,"\n Please call an X Wizard !");
	    };
	};
    };
  FontInfoTab_[*j].ok = 1;
  if (flag != 0) 
    strcpy(FontInfoTab_[*j].fname,name);
  else
    strcpy(FontInfoTab_[*j].fname,"fixed");
};


LoadFonts()
{
  int fnum;
  loadfamily_("CourR",(fnum=0,&fnum)); 
  LoadSymbFonts();
  loadfamily_("TimR",(fnum=2,&fnum));
/*  On charge ces fonts a la demande et non pas a l'initialisation 
    sinon le temps de calcul est trop long
  loadfamily_("TimI",(fnum=3,&fnum));
  loadfamily_("TimB",(fnum=4,&fnum));
  loadfamily_("TimBI",(fnum=5,&fnum)); 
  See xsetfont
*/
};

/** We use the Symbol font  for mark plotting **/
/** so we want to be able to center a Symbol character at a specified point **/

typedef  struct { int xoffset[SYMBOLNUMBER];
		  int yoffset[SYMBOLNUMBER];} Offset ;

static Offset ListOffset_[FONTMAXSIZE];
static char Marks[] = {
  /*., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle*/
  0xb7,0x2b,0xb4,0xc5,0xa8,0xe0,0x44,0xd1,0xa7,0x4f};

LoadSymbFonts()
{ XCharStruct xcs;
  int i,j,k ;
  /** Symbol Font is loaded under Id : 1 **/
  loadfamily_("Symb",(i=1,&i));

  /* We compute the char offset for several chars of the symbol font
     in order to be able to center them on a specific point 
     we need one offset per symbol
     for the font i 
     n1=FontsList_[i]->min_char_or_byte2
     info on char coded as  oxyy are stored in 
     FontsList_[i]->per_char[0xyy-n1]
     
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
	       };
	   };
       };
};

/** The two next functions send the x and y offsets to center the current **/
/** symbol at point (x,y) **/

int CurSymbXOffset_()
{
  return(-(ListOffset_[MissileXgc.CurHardSymbSize].xoffset)
	 [MissileXgc.CurHardSymb]);
}
int CurSymbYOffset_()
{
  return((ListOffset_[MissileXgc.CurHardSymbSize].yoffset)
	 [MissileXgc.CurHardSymb]);
}

DrawMark_(x,y)
     int *x,*y ;
{ 
  char str[1];
  str[0]=Marks[MissileXgc.CurHardSymb];
  XDrawString(dpy,CWindow,gc,*x+CurSymbXOffset_(),*y+CurSymbYOffset_(),str,1);
  XFlush(dpy);
};

/*-------------------------------------------------------------------
\subsection{Allocation and storing function for vectors of X11-points}
------------------------------------------------------------------------*/

static XPoint *points;
static unsigned nbpoints;
#define NBPOINTS 256 

int store_points_(n, vx, vy,onemore)
     int n,onemore;
     int vx[], vy[];
{ 
  int i,n1;
  if ( onemore == 1) n1=n+1;
  else n1=n;
  if (ReallocVector_(n1) == 1)
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
};

int ReallocVector_(n)
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
};

int AllocVectorStorage_()
{
  nbpoints = NBPOINTS;
  points = (XPoint *) malloc (nbpoints * sizeof (XPoint)); 
  if ( points == 0) { perror(MESSAGE4);return(0);}
  else return(1);
};

XPoint *ReturnPoints_() { return(points); };

/*------------------------END--------------------*/

static int xleft,xright,ybot,ytop;

/* My own clipping routines  
  XDrawlines with clipping on the current graphic window 
  to ovoid trouble on some X servers **/

int analyze_points_(n, vx, vy,onemore)
     int n,onemore;
     int vx[], vy[];
{ 
  int iib,iif,ideb=0,verbose=0,wd[2],narg,vxl[2],vyl[2];
  getwindowdim_(&verbose,wd,&narg);
  xleft=0;xright=wd[0]; ybot=0;ytop=wd[1];
#ifdef DEBUG
    xleft=100;xright=300;
    ybot=100;ytop=300;
    XDrawRectangle(dpy, CWindow, gc,xleft,ybot,(unsigned)xright-xleft,
    (unsigned)ytop-ybot);
#endif
  while (1) 
    { 
      iib=first_in(n,ideb,vx,vy);
      if (iib==-1) { 
#ifdef DEBUG
	fprintf(stderr,"[%d,end=%d] polyline out\n",ideb,n);
	/* all points are out but segments can cross the box */
	for (j=ideb+1; j < n; j++) My2draw(j,vx,vy);
#endif 
	break;}
      iif=first_out(n,iib,vx,vy);
      if (iif==-1) {
#ifdef DEBUG
	fprintf(stderr,"[%d,end=%d] is in\n",iib,n);
#endif 
	MyDraw(iib,n-1,vx,vy);
	break;
      };
#ifdef DEBUG
      fprintf(stderr,"Analysed : [%d,%d]\n",iib,iif);
#endif 
      MyDraw(iib,iif,vx,vy);
      ideb=iif;
    };
  if (onemore == 1) {
    vxl[0]=vx[n-1];vxl[1]=vx[0];vyl[0]=vy[n-1];vyl[1]=vy[0];
    analyze_points_(2,vxl,vyl,0);
  };
};

MyDraw(iib,iif,vx,vy)
     int iib,iif,vx[],vy[];
{
  int x1n,y1n,x11n,y11n,x2n,y2n,flag2,flag1;
  int npts;
  npts= ( iib > 0) ? iif-iib+2  : iif-iib+1;
  if ( iib > 0) 
    {
      clip_line(vx[iib-1],vy[iib-1],vx[iib],vy[iib],&x1n,&y1n,&x2n,&y2n,&flag1);
    };
  clip_line(vx[iif-1],vy[iif-1],vx[iif],vy[iif],&x11n,&y11n,&x2n,&y2n,&flag2);
  if (store_points_(npts, &vx[Max(0,iib-1)], &vy[Max(0,iib-1)],0));
  {
    if (iib > 0 && (flag1==1||flag1==3)) change_points(0,x1n,y1n);
    if (flag2==2 || flag2==3) change_points(npts-1,x2n,y2n);
    XDrawLines (dpy, CWindow, gc, ReturnPoints_(),npts,
		MissileXgc.CurVectorStyle);
  };
};

My2Draw(j,vx,vy)
     int j,vx[],vy[];
{
  int vxn[2],vyn[2],flag,npts=2;
  clip_line(vx[j-1],vy[j-1],vx[j],vy[j],&vxn[0],&vyn[0],&vxn[1],&vyn[1],&flag);
  if (store_points_(npts,vxn,vyn,0));
  {
    XDrawLines (dpy, CWindow, gc, ReturnPoints_(),npts,
		MissileXgc.CurVectorStyle);
  };
};

change_points(i,x,y)
     int i,x,y;
{
  points[i].x=(short)x;   points[i].y=(short)y;
};

/* 
 *  returns the first (vx[.],vy[.]) point inside 
 *  xleft,xright,ybot,ytop bbox. begining at index ideb
 *  or zero if the whole polyline is out 
 */

int first_in(n,ideb,vx,vy)
     int n,ideb;
     int vx[], vy[];
{
  int i;
  for (i=ideb  ; i < n ; i++)
    {
      if (vx[i]>= xleft && vx[i] <= xright  && vy[i] >= ybot && vy[i] <= ytop)
	{
#ifdef DEBUG
	  fprintf(stderr,"first in %d->%d=(%d,%d)\n",ideb,i,vx[i],vy[i]);
#endif
	  return(i);
	};
    };
  return(-1);
};

/* 
 *  returns the first (vx[.],vy[.]) point outside
 *  xleft,xright,ybot,ytop bbox.
 *  or zero if the whole polyline is out 
 */

int first_out(n,ideb,vx,vy)
     int n,ideb;
     int vx[], vy[];
{
  int i;
  for (i=ideb  ; i < n ; i++)
    {
      if ( vx[i]< xleft || vx[i]> xright  || vy[i] < ybot || vy[i] > ytop) 
	{
#ifdef DEBUG
	  fprintf(stderr,"first out %d->%d=(%d,%d)\n",ideb,i,vx[i],vy[i]);
#endif
	  return(i);
	};
    };
  return(-1);
};

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

    if (x < xleft) ret_val |= 0x01;
    if (x > xright) ret_val |= 0x02;
    if (y < ybot) ret_val |= 0x04;
    if (y > ytop) ret_val |= 0x08;

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

int clip_line(x1, yy1, x2, y2, x1n, yy1n, x2n, y2n, flag)
     int x1, yy1, x2, y2, *flag, *x1n, *yy1n, *x2n, *y2n;
{
    int x, y, dx, dy, x_intr[2], y_intr[2], count, pos1, pos2;
    *x1n=x1;*yy1n=yy1;*x2n=x2;*y2n=y2;*flag=4;
    pos1 = clip_point(x1, yy1);
    pos2 = clip_point(x2, y2);
    if (pos1 || pos2) {
	if (pos1 & pos2) { *flag=0;return;}	  /* segment is totally out. */

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
	  };
      };
  };

