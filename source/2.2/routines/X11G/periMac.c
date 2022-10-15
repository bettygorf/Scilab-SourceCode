/*-------------------------------BEGIN--------------------------------------
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

#if defined(sun)
#define pascal /**/
#define EXTERN static
#endif 

#include <QuickDraw.h>
#include <MacTypes.h>
#include <WindowMgr.h>
#include <ControlMgr.h>
#include <EventMgr.h>

#include <stdio.h>
#include <math.h>
#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "Math.h"
#include "periMac.h"

#define MESSAGE4 "Can't allocate point vector"
#define MESSAGE5 "Can't re-allocate point vector"
#define Char2Int(x)   ( x & 0x000000ff )

static integer use_color=0;
#define NUMCOLORS 17

typedef  struct {
  float  r,g,b;} TabC;

TabC tabc[NUMCOLORS];

/** Global variables to deal with Mac **/

extern Rect dragRect;
Rect windowBounds = {40, 40, 240, 240};

typedef WindowPtr Window;
Window CWindow;

typedef struct
{
  integer x, y;
}   XPoint;
#ifdef THINK_C
#define CoordModePrevious 0
#define CoordModeOrigin 1
#define GXclear 0
#define GXand 1
#define GXandReverse 2
#define GXcopy patCopy
#define GXandInverted 4
#define GXnoop 5
#define GXxor patXor
#define GXor patOr
#define GXnor notPatOr
#define GXequiv 9
#define GXinvert 10
#define GXorReverse 11
#define GXcopyInverted notPatCopy
#define GXorInverted 13
#define GXnand 14
#define GXset 15
#else
#include <X11/Xlib.h>
#endif

/** flag to decide between X11 and IX11 (scilab or xscilab ) */
extern integer xint_type;


/** Structure to keep the graphic state  **/
struct BCG
{
  int FontSize;
  int FontId;
  int FontXID;
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
}   MissileXgc;

/*-----------------------------------------------------
  \encadre{General routines}
  -----------------------------------------------------*/

/** To select (raise on the screen )the current graphic Window  **/
/** If there's no graphic window then select creates one **/
#define STR1 "ScilabGraphic%d"

xselgraphic_(v1,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4) 
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  SelectWindow(CWindow);
}

/** End of graphic (do nothing)  **/

static endflag_ = 0;

xendgraphic_()
{
  endflag_ = 1;
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
  BeginUpdate(CWindow);
  EraseRect(&CWindow->portRect);
  DrawGrowIcon(CWindow);
  EndUpdate(CWindow);
}

/*-----------------------------------------------------------
  \encadre{To generate a pause, in seconds}
  ------------------------------------------------------------*/
xpause_(str,sec_time,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *sec_time,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  /* unsigned int useconds; XSync(dpy,0); useconds=(unsigned) sec_time; if
   * (useconds != 0)  usleep(useconds); */
}

/*-----------------------------------------------------------
  \encadre{ Wait for mouse click in graphic window
  send back mouse location  (x1,yy1)  and button number
  0,1,2}
  There's just a pb if the window is iconified when we try to
  click this case is not checked
  -----------------------------------------------------------*/

xclick_(str,ibutton,x1,yy1,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *ibutton,*x1,*yy1,*v5,*v6,*v7 ;
     double *dv1,*dv2,*dv3,*dv4;
{
  /* TODO Waits for a click but needs to return coords */
  myWwinWait(CWindow, "Wait for a Click");
}

xgetmouse_(str,ibutton,x1,yy1,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *ibutton,*x1,*yy1 ,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;

{
  /* TODO Waits for a click but needs to return coords */
  /* update it to really do xgetmouse */
  /* it's temporary just a copy of xclick */
  myWwinWait(CWindow, "Wait for a Click");
}


/*------------------------------------------------
  \encadre{Clear a rectangle }
  -------------------------------------------------*/

cleararea_(str,x,y,w,h,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *x,*y,*w,*h,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  Rect MyRect;
  SetRect(&MyRect, *x, *y, *x + *w, *y + *h);
  EraseRect(&MyRect);
}

/*---------------------------------------------------------------------
  \section{Function for graphic context modification}
  ------------------------------------------------------------------------*/

/** to get the window upper-left point coordinates on the screen  **/

getwindowpos_(verbose, x, narg)
  integer *verbose, *x, *narg;
{
  *narg = 2;
  x[0] = CWindow->portRect.left;
  x[1] = CWindow->portRect.top;
  if (*verbose == 1)
    sciprint( "\n CWindow position :%d,%d\r\n",(int) x[0],(int) x[1]);
}

/** to set the window upper-left point position on the screen **/

setwindowpos_(x,y,v3,v4)
     integer *x,*y,*v3,*v4;
{
  MoveWindow(CWindow, *x, *y, FALSE);
}

/** To get the window size **/
#define SBARWIDTH 16

getwindowdim_(verbose, x, narg)
  integer *verbose, *x, *narg;
{
  *narg = 2;
  x[0] = (CWindow->portRect).right - (CWindow->portRect).left - SBARWIDTH;
  x[1] = (CWindow->portRect).bottom - (CWindow->portRect).top - SBARWIDTH;
  if (*verbose == 1)
    sciprint( "\n CWindow dim :%d,%d\r\n",(int) x[0], (int)x[1]);
}

/** To change the window size  **/

setwindowdim_(x,y,v3,v4)
     integer *x,*y,*v3,*v4;
{
  SizeWindow(CWindow, *x, *y, TRUE);
}


/** To select a graphic Window  **/

setcurwin_(intnum,v2,v3,v4)
     integer *intnum;
     integer *v2,*v3,*v4;
{
  Window GetWindowNumber_();
  CWindow = GetWindowNumber_(*intnum);
  Scistring( "OK inside setcurwin\n");
  MissileXgc.CurWindow = *intnum;
  if (CWindow == (Window) NULL)
  {
    integer i;
    for (i = 0; i <= *intnum; i++)
      if (GetWindowNumber_(*intnum) == (Window) NULL)
	initgraphic_("",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  }
}

/** Get the id number of the Current Graphic Window **/

getcurwin_(verbose, intnum, narg)
  integer *verbose, *intnum, *narg;
{
  *narg = 1;
  *intnum = MissileXgc.CurWindow;
  if (*verbose == 1)
    sciprint( "\nCurrent Graphic Window :%d",(int) *intnum);
}

/** Set a clip zone (rectangle ) **/

setclip_(x, y, w, h)
  integer *x, *y, *w, *h;
{
  Rect MyRect;
  MissileXgc.ClipRegionSet = 1;
  MissileXgc.CurClipRegion[0] = *x;
  MissileXgc.CurClipRegion[1] = *y;
  MissileXgc.CurClipRegion[2] = *w;
  MissileXgc.CurClipRegion[3] = *h;
  SetRect(&MyRect, *x, *y, *x + *w, *y + *h);
  ClipRect(&MyRect);
}

/** Get the boundaries of the current clip zone **/

getclip_(verbose, x, narg)
  integer *verbose, *x, *narg;
{
  x[0] = MissileXgc.ClipRegionSet;
  if (x[0] == 1)
  {
    *narg = 5;
    x[1] = MissileXgc.CurClipRegion[0];
    x[2] = MissileXgc.CurClipRegion[1];
    x[3] = MissileXgc.CurClipRegion[2];
    x[4] = MissileXgc.CurClipRegion[3];
  } else
    *narg = 1;
  if (*verbose == 1)
    if (MissileXgc.ClipRegionSet == 1)
      sciprint("\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d\r\n",
	      MissileXgc.CurClipRegion[0],
	      MissileXgc.CurClipRegion[1],
	      MissileXgc.CurClipRegion[2],
	      MissileXgc.CurClipRegion[3]);
    else
      Scistring( "\nNo Clip Region");
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
  if (*num == 0)
    MissileXgc.CurVectorStyle = CoordModeOrigin;
  else
    MissileXgc.CurVectorStyle = CoordModePrevious;
}

/** to get information on absolute or relative mode **/

getabsourel_(verbose, num, narg)
  integer *verbose, *num, *narg;
{
  *narg = 1;
  *num = MissileXgc.CurVectorStyle;
  if (*verbose == 1)
    if (MissileXgc.CurVectorStyle == CoordModeOrigin)
      Scistring( "\nTrace Absolu");
    else
      Scistring( "\nTrace Relatif");
}

/** The alu function for drawing : Works only with X11 **/
/** Not in Postscript **/

setalufunction_(string)
  char string[];
{
  integer value;
  idfromname(string, &value);
  if (value != -1)
  {
    MissileXgc.CurDrawFunction = value;
  }
}
/** All the possibilities : Read The Mac manual to get more informations **/

struct alinfo
{
  char *name;
  char id;
  char *info;
}   AluStruc_[] =
{
  "GXclear", GXclear, " 0 ",
  "GXand", GXand, " src AND dst ",
  "GXandReverse", GXandReverse, " src AND NOT dst ",
  "GXcopy", GXcopy, " src ",
  "GXandInverted", GXandInverted, " NOT src AND dst ",
  "GXnoop", GXnoop, " dst ",
  "GXxor", GXxor, " src XOR dst ",
  "GXor", GXor, " src OR dst ",
  "GXnor", GXnor, " NOT src AND NOT dst ",
  "GXequiv", GXequiv, " NOT src XOR dst ",
  "GXinvert", GXinvert, " NOT dst ",
  "GXorReverse", GXorReverse, " src OR NOT dst ",
  "GXcopyInverted", GXcopyInverted, " NOT src ",
  "GXorInverted", GXorInverted, " NOT src OR dst ",
  "GXnand", GXnand, " NOT src OR NOT dst ",
  "GXset", GXset, " 1 "
};

setalufunction1_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{
  integer value;
  value = AluStruc_[Min(16, Max(0, *num))].id;
  /* PenMode(value); */
  if (value == 0)
    PenPat(white);
  else
    PenPat(black);
  if (value != -1)
    {
      MissileXgc.CurDrawFunction = value;
    }
}

idfromname(name1, num)
  char name1[];
  integer *num;
{
  integer i;
  *num = -1;
  for (i = 0; i < 16; i++)
    if (strcmp(AluStruc_[i].name, name1) == 0)
      *num = AluStruc_[i].id;
  if (*num == -1)
  {
    Scistring( "\n Use the following keys (integer in scilab");
    for (i = 0; i < 16; i++)
      sciprint("\nkey %s   -> %s\r\n", AluStruc_[i].name,
	      AluStruc_[i].info);
  }
}

/** To get the value of the alufunction **/

getalufunction_(verbose, value, narg)
  integer *verbose, *value, *narg;
{
  *narg = 1;
  *value = MissileXgc.CurDrawFunction;
  if (*verbose == 1)
  {
    sciprint("\nThe Alufunction is %s -> <%s>\r\n",
	    AluStruc_[*value].name,
	    AluStruc_[*value].info);
  }
}


/** to set the thickness of lines : 0 is a possible value **/
/** give the thinest line (0 and 1 the same for X11 but   **/
/** with diferent algorithms ) **/
/** defaut value is 1 **/
/** Must be Updated for the MAC JPC **/

setthickness_(value,v2,v3,v4)
     integer *value ,*v2,*v3,*v4;
{
  PenSize(*value, *value);
  MissileXgc.CurLineWidth = Max(0, *value);
}

/** to get the thickness value **/

getthickness_(verbose, value, narg)
  integer *verbose, *value, *narg;
{
  *narg = 1;
  *value = MissileXgc.CurLineWidth;
  if (*verbose == 1)
    sciprint( "\nLine Width:%d\r\n",
	    MissileXgc.CurLineWidth);
}

/** To set grey level for filing areas **/
/** from black (*num =0 ) to white     **/

#define GREYNUMBER 17

static unsigned char Tabpix_[GREYNUMBER][8] = {
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

CreatePatterns_(whitepixel, blackpixel)
  unsigned long whitepixel, blackpixel;
{
  /* Nothing to do */
}

setpattern_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{ integer i ; 
  i= Max(0,Min(*num,GREYNUMBER-1));
  MissileXgc.CurPattern = i;
  if ( use_color ==1) set_c(i);
  }

/** To get the id of the current pattern  **/

getpattern_(verbose, num, narg)
  integer *num, *verbose, *narg;
{
  *narg = 1;
  *num = MissileXgc.CurPattern;
  if (*verbose == 1)
    sciprint( "\n Pattern : %d\r\n",
	    MissileXgc.CurPattern);
}

/** To get the id of the white pattern **/

getwhite_(verbose, num, narg)
  integer *num, *verbose, *narg;
{
  *num = MissileXgc.IDWhitePattern;
  if (*verbose == 1)
    sciprint( "\n Id of White Pattern %d \r\n",(int) *num);
  *narg = 1;
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
  {2, 5, 2, 5}, {5, 2, 5, 2}, {5, 3, 2, 3}, {8, 3, 2, 3},
{11, 3, 2, 3}, {11, 3, 5, 3}};

setdash_(value,v2,v3,v4)
     integer *value,*v2,*v3,*v4;
{
  static integer maxdash = 6, l2=4,l3 ;
  l3 = Min(maxdash-1,*value-1);
  MissileXgc.CurDashStyle= l3 + 1 ;
  if ( use_color ==1) set_c(*value-1);
  else
    setdashstyle_(value,DashTab[Max(0,l3)],&l2);
}

/** To change The X11-default dash style **/
/** if *value == 0, use a solid line, if *value != 0 **/
/** the dash style is specified by the xx vector of n values **/
/** xx[3]={5,3,7} and *n == 3 means :  5white 3 void 7 white \ldots **/

#define LineOnOffDash 1
#define LineSolid 0
setdashstyle_(value, xx, n)
  integer *value, xx[], *n;
{
  integer dashok = LineOnOffDash;
  if (*value == 0)
    dashok = LineSolid;
  else
  {
    integer i;
    char buffdash[18];
    for (i = 0; i < *n; i++)
      buffdash[i] = xx[i];
    /* A FAIRE  XSetDashes(buffdash,*n); */
  }
  /* A FAIRE XSetLineAttributes(MissileXgc.CurLineWidth,dashok); */
}

/** to get the current dash-style **/

getdash_(verbose, value, narg)
  integer *verbose, *value, *narg;
{
  integer i
  *value = MissileXgc.CurDashStyle;
  *narg = 1;
  if (*value == 0)
  {
    if (*verbose == 1)
      Scistring( "\nLine style = Line Solid");
  } else
  {
    value[1] = 4;
    *narg = value[1] + 2;
    for (i = 0; i < value[1]; i++)
      value[i + 2] = DashTab[*value - 1][i];
    if (*verbose == 1)
    {
      sciprint( "\nDash Style %d:<",(int) *value);
      for (i = 0; i < value[1]; i++)
	sciprint( "%d ", (int)value[i + 2]);
      Scistring( ">\n");
    }
  }
}

/*-----------------------------------------------------------
  \encadre{general routines accessing the  set<> or get<>
  routines }
  -------------------------------------------------------------*/

integer InitMissileXgc();


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

#define NUMSETFONC 13

/** Table in lexicographic order **/
int xsetfont_(), xgetfont_(), xsetmark_(), xgetmark_();

struct bgc
{
  char *name;
  int (*setfonc) ();
  int (*getfonc) ();
}
    MissileGCTab_[] =
{
  "alufunction", setalufunction1_, getalufunction_,
  "clipping", setclip_, getclip_,
  "dashes", setdash_, getdash_,
  "default", InitMissileXgc, empty_,
  "font", xsetfont_, xgetfont_,
  "line mode", setabsourel_, getabsourel_,
  "mark", xsetmark_, xgetmark_,
  "pattern", setpattern_, getpattern_,
  "thickness", setthickness_, getthickness_,
  "wdim", setwindowdim_, getwindowdim_,
  "white", empty_, getwhite_,
  "window", setcurwin_, getcurwin_,
  "wpos", setwindowpos_, getwindowpos_
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

MissileGCGetorSet_(str, flag, verbose, x1, x2, x3, x4, x5)
  char str[];
  integer flag;
  integer *verbose, *x1, *x2, *x3, *x4, *x5;
{
  integer i;
  for (i = 0; i < NUMSETFONC; i++)
  {
    integer j;
    j = strcmp(str, MissileGCTab_[i].name);
    if (j == 0)
    {
      if (*verbose == 1)
	sciprint( "\nGettting Info on %s\r\n", str);
      if (flag == 1)
	(MissileGCTab_[i].getfonc) (verbose, x1, x2, x3, x4, x5);
      else
	(MissileGCTab_[i].setfonc) (x1, x2, x3, x4, x5);
      return;
    } else
    {
      if (j <= 0)
      {
	sciprint( "\nUnknow X operator <%s>\r\n", str);
	return;
      }
    }
  }
  sciprint( "\n Unknow X operator <%s>\r\n", str);
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
  if (Abs(*angle) <= 0.1)
  {
    MoveTo((int) *x,(int) *y);
    CtoPstr(string);
    DrawString(string);
    PtoCstr(string);
    if (*flag == 1)
    {
      integer rect[4];
      Scistring( " je rajoute un rect \n");
      boundingbox_(string, x, y, rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      rect[0] = rect[0] - 4;
      rect[2] = rect[2] + 6;
      drawrectangle_(string, rect, rect + 1, rect + 2, rect + 3,PI0,PI0,PD0,PD0,PD0,PD0);
    }
  } else
    DispStringAngle_(x, y, string, angle);

}
#define M_PI 3.14116

DispStringAngle_(x0, yy0, string, angle)
  integer *x0, *yy0;
  double *angle;
  char string[];
{
  integer w, h, x, y, i, rect[4];
  double sina, cosa, l;
  char str1[2];
  str1[1] = '\0';
  x = *x0;
  y = *yy0;
  sina = sin((*angle) * M_PI / 180.0);
  cosa = cos((*angle) * M_PI / 180.0);
  for (i = 0; i < (integer)strlen(string); i++)
  {
    str1[0] = string[i];

    MoveTo((int)x,(int) y);
    DrawChar(string[i]);
    boundingbox_(str1, &x, &y, rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
    /** drawrectangle_(string,rect,rect+1,rect+2,rect+3); **/
    if (cosa <= 0.0 && i < (integer)strlen(string) - 1)
    {
      char str2[2];
      /** si le cosinus est negatif le deplacement est a calculer **/
      /** sur la boite du caractere suivant **/
      str2[1] = '\0';
      str2[0] = string[i + 1];
      boundingbox_(str2, &x, &y, rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
    }
    if (Abs(cosa) >= 1.e-8)
    {
      if (Abs(sina / cosa) <= Abs(((double) rect[3]) / ((double) rect[2])))
	l = Abs(rect[2] / cosa);
      else
	l = Abs(rect[3] / sina);
    } else
      l = Abs(rect[3] / sina);
    x += cosa * l * 1.1;
    y += sina * l * 1.1;
  }
}

/** To get the bounding rectangle of a string **/

boundingbox_(string,x,y,rect,v5,v6,v7,dv1,dv2,dv3,dv4)
     integer *x,*y,*rect,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
     char string[];
{
  FontInfo info;
  GetFontInfo(&info);
  rect[0] = *x;
  CtoPstr(string);
  rect[2] = StringWidth(string);
  PtoCstr(string);
  rect[3] = info.ascent + info.descent;
  rect[1] = *y - rect[3] + info.leading;
}

/*------------------------------------------------
  subsection{ Segments and Arrows }
  -------------------------------------------------*/

drawline_(x1, yy1, x2, y2)
  integer *x1, *x2, *yy1, *y2;
{
  XDrawLine((int) *x1, (int) *yy1,(int) *x2, (int) *y2);
}

XDrawLine(xi, yi, xf, yf)
  int xi, yi, xf, yf;
{
  MoveTo( xi, yi);
  LineTo( xf, yf);
}


/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/

drawsegments_(str,vx,vy,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n,vx[],vy[],*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose=0,Dnarg,Dvalue[10],NDvalue;
  integer i ;
  getdash_(&verbose,Dvalue,&Dnarg);
  for (i = 0; i < *n / 2; i++)
  {
    if ( (int) *iflag == 1) 
      NDvalue = style[i];
    else 
	NDvalue=(*style < 0) ? (integer) MissileXgc.CurDashStyle : *style;
    setdash_(&NDvalue,PI0,PI0,PI0);
    XDrawLine((int)vx[2 * i],(int) vy[2 * i],(int) vx[2 * i + 1],(int) vy[2 * i + 1]);
  }
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
  double cos20 = cos(20.0 * M_PI / 180.0);
  double sin20 = sin(20.0 * M_PI / 180.0);
  integer polyx[4], polyy[4], fillvect[1];
  integer verbose = 0, Dnarg, Dvalue[10], NDvalue, i;
  getdash_(&verbose, Dvalue, &Dnarg);
  for (i = 0; i < *n / 2; i++)
  {
    double dx, dy, norm;
    XDrawLine((int) vx[2 * i],(int) vy[2 * i],(int) vx[2 * i + 1],(int) vy[2 * i + 1]);
    dx = (vx[2 * i + 1] - vx[2 * i]);
    dy = (vy[2 * i + 1] - vy[2 * i]);
    norm = sqrt(dx * dx + dy * dy);
    if (Abs(norm) > SMDOUBLE)
    {
      integer nn = 1, p = 3;
      dx = (*as / 10.0) * dx / norm;
      dy = (*as / 10.0) * dy / norm;
      polyx[0] = polyx[3] = vx[2 * i + 1] + dx * cos20;
      polyx[1] = inint(polyx[0] - cos20 * dx - sin20 * dy);
      polyx[2] = inint(polyx[0] - cos20 * dx + sin20 * dy);
      polyy[0] = polyy[3] = vy[2 * i + 1] + dy * cos20;
      polyy[1] = inint(polyy[0] + sin20 * dx - cos20 * dy);
      polyy[2] = inint(polyy[0] - sin20 * dx - cos20 * dy);
      if ( (int) *iflag == 1) 
	NDvalue = style[i];
      else 
	NDvalue=(*style < 0) ? (integer) MissileXgc.CurDashStyle : *style;
      setdash_(&NDvalue,PI0,PI0,PI0);
      fillpolylines_("v", polyx, polyy,(fillvect[0]=(integer) MissileXgc.CurPattern ,fillvect),
		      &nn, &p,PI0,PD0,PD0,PD0,PD0);
      }
  }
  setdash_(Dvalue,PI0,PI0,PI0);
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
/** with pattern fillvect[i] **/
/** if fillvect[i] is > whitepattern  then only draw the rectangle i **/
/** The drawing style is the current drawing style **/

drawrectangles_(str,vects,fillvect,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*fillvect,*n,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer i, cpat, verbose = 0, num;
  getpattern_(&verbose, &cpat, &num);
  for (i = 0; i < *n; i++)
  {
    if (fillvect[i] > MissileXgc.IDWhitePattern)
    {
      drawrectangle_(str, vects + 4 * i, vects + 4 * i + 1, vects + 4 * i + 2, vects + 4 * i + 3,PI0,PI0,PD0,PD0,PD0,PD0);
    } else
    {
      setpattern_(&(fillvect[i]),PI0,PI0,PI0);
      fillrectangle_(str, vects + 4 * i, vects + 4 * i + 1, vects + 4 * i + 2, vects + 4 * i + 3,PI0,PI0,PD0,PD0,PD0,PD0);
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
  Rect MyRect;
  SetRect(&MyRect, *x, *y, *x + *width, *y + *height);
  FrameRect(&MyRect);
}

/** fill one rectangle, with current pattern **/
fillrectangle_(str,x,y,width,height,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer  *x, *y, *width, *height,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  Rect MyRect;
  Pattern thePat;
  SetRect(&MyRect, *x, *y, *x + *width, *y + *height);
  FillRect(&MyRect, Tabpix_[GREYNUMBER - 1 - MissileXgc.CurPattern]);
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
/** with pattern fillvect[i] **/
/** if fillvect[i] is > whitepattern  then only draw the ellipsis i **/
/** The drawing style is the current drawing style **/

fillarcs_(str,vects,fillvect,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*fillvect,*n,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer i, cpat, verb, num;
  verb = 0;
  getpattern_(&verb, &cpat, &num);
  for (i = 0; i < *n; i++)
  {
    if (fillvect[i] > MissileXgc.IDWhitePattern)
    {
      setpattern_(&(cpat),PI0,PI0,PI0);
      drawarc_(str, vects + 6 * i, vects + 6 * i + 1,
	       vects + 6 * i + 2, vects + 6 * i + 3,
	       vects + 6 * i + 4, vects + 6 * i + 5,PD0,PD0,PD0,PD0);
    } else
    {
      setpattern_(&(fillvect[i]),PI0,PI0,PI0);
      fillarc_(str, vects + 6 * i, vects + 6 * i + 1,
	       vects + 6 * i + 2, vects + 6 * i + 3,
	       vects + 6 * i + 4, vects + 6 * i + 5,PD0,PD0,PD0,PD0);
    }
  }
  setpattern_(&(cpat),PI0,PI0,PI0);
}


drawarcs_(str,vects,style,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*style,*n,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose = 0, symb[2], Mnarg, Dnarg, Dvalue[10], NDvalue, i, close;
  getdash_(&verbose, Dvalue, &Dnarg);
  for (i = 0; i < *n; i++)
  {
      NDvalue = style[i];
      setdash_(&NDvalue,PI0,PI0,PI0);
      drawarc_(str, vects + 6 * i, vects + 6 * i + 1,
	       vects + 6 * i + 2, vects + 6 * i + 3,
	       vects + 6 * i + 4, vects + 6 * i + 5,PD0,PD0,PD0,PD0);
  }
  setdash_(Dvalue,PI0,PI0,PI0);
}

/** Draw a single ellipsis or part of it **/

drawarc_(str,x,y,width,height,angle1,angle2,dv1,dv2,dv3,dv4)
     double *dv1,*dv2,*dv3,*dv4;
     char str[];
     integer *angle1,*angle2, *x, *y, *width, *height;
{
  /* XDrawArc( *x, *y, *width, *height,*angle1, *angle2); */
  Rect MyRect;
  SetRect(&MyRect, *x, *y, *x + *width, *y + *height);
  FrameArc(&MyRect, *angle1 / 64 - 90, (*angle2 - *angle1) / 64);

}

/** Fill a single elipsis or part of it with current pattern **/

fillarc_(str,x,y,width,height,angle1,angle2,dv1,dv2,dv3,dv4)
     char str[];
     double *dv1,*dv2,*dv3,*dv4;
     integer *angle1,*angle2, *x, *y, *width, *height;
{
  Rect MyRect;
  SetRect(&MyRect, *x, *y, *x + *width, *y + *height);
  FillArc(&MyRect, *angle1 / 64 - 90, (*angle2 - *angle1) / 64, Tabpix_[GREYNUMBER - 1 - MissileXgc.CurPattern]);
}
/*--------------------------------------------------------------
  \encadre{Filling or Drawing Polylines and Polygons}
  ---------------------------------------------------------------*/

/** Draw a set of (*n) polylines (each of which have (*p) pointegers) **/
/** with lines or marks **/
/** drawvect[i] >= 0 use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

drawpolylines_(str,vectsx,vectsy,drawvect,n,p,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vectsx,*vectsy,*drawvect,*n,*p,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose = 0, symb[2], Mnarg, Dnarg, Dvalue[10], NDvalue, i, close;
  /* store the current values */
  xgetmark_(&verbose, symb, &Mnarg);
  getdash_(&verbose, Dvalue, &Dnarg);
  for (i = 0; i < *n; i++)
  {
    if (drawvect[i] >= 0)
    {				/** we use the markid : drawvect[i] **/
      xsetmark_(drawvect + i, symb + 1,PI0,PI0);
      drawpolymark_(str, p, vectsx + (*p) * i, vectsy + (*p) * i,
		PI0,PI0,PI0,PD0,PD0,PD0,PD0);
    } else
    {				/** we use the line-style number abs(drawvect[i])  **/
      NDvalue = -drawvect[i] - 1;
      setdash_(&NDvalue,PI0,PI0,PI0);
      close = 0;
      drawpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, &close,
			PI0,PI0,PD0,PD0,PD0,PD0);
    }
  }
  /** back to default values **/
  setdash_(Dvalue,PI0,PI0,PI0);
  xsetmark_(symb, symb + 1,PI0,PI0);
}

/** fill a set of polygons each of which is defined by
  (*p) pointegers (*n) is the number of polygons
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
  integer i, cpat, verbose = 0, num, close = 1, pattern;
  getpattern_(&verbose, &cpat, &num);
  for (i = 0; i < *n; i++)
  {
    if (fillvect[i] >= MissileXgc.IDWhitePattern + 2)
    {				/** on peinteger puis on fait un contour ferme **/
      pattern = -fillvect[i] + 2 * MissileXgc.IDWhitePattern + 2;
      setpattern_(&pattern,PI0,PI0,PI0);
      fillpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, (close = 1, &close),
			PI0,PI0,PD0,PD0,PD0,PD0);
      setpattern_(&(cpat),PI0,PI0,PI0);
      drawpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, (close = 1, &close),
			PI0,PI0,PD0,PD0,PD0,PD0);
    } else
    {
      if (fillvect[i] == MissileXgc.IDWhitePattern + 1)
	drawpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, (close = 0, &close),
			PI0,PI0,PD0,PD0,PD0,PD0);
      else
      {
	setpattern_(&(fillvect[i]),PI0,PI0,PI0);
	fillpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, (close = 0, &close),
			PI0,PI0,PD0,PD0,PD0,PD0);
      }
    }
  }
  setpattern_(&(cpat),PI0,PI0,PI0);
}

/** Only draw one polygon  with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/
/** n is the number of pointegers of the polyline */

drawpolyline_(str,n, vx, vy,closeflag,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n,*closeflag;
     integer vx[], vy[], *v6, *v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer n1;
  XPointeger *ReturnPointegers_();
  if (*closeflag == 1)
    n1 = *n + 1;
  else
    n1 = *n;
  if (n1 >= 2)
  {
    MacLines(vx, vy, *n, *closeflag);
  }
}

MacLines(vx, vy, n, closeflag)
  integer vx[], vy[], n, closeflag;
{
  PolyHandle Pol;
  integer i;
  Pol = OpenPoly();
  MoveTo((int)vx[0], (int)vy[0]);
  for (i = 0; i < n; i++)
    LineTo((int) vx[i],(int) vy[i]);
  if (closeflag == 1)
    LineTo((int)vx[0],(int) vy[0]);
  ClosePoly();
  FramePoly(Pol);
  KillPoly(Pol);
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
  XPointeger *ReturnPointegers_();
  MacFillLines(vx, vy, *n, *closeflag);
}

MacFillLines(vx, vy, n, closeflag)
  integer vx[], vy[], n, closeflag;
{
  PolyHandle Pol;
  integer i;
  /* Scistring(" inside fill poly \n"); */
  Pol = OpenPoly();
  MoveTo((int)vx[0],(int) vy[0]);
  for (i = 0; i < n; i++)
    LineTo((int)vx[i],(int) vy[i]);
  if (closeflag == 1)
    LineTo((int)vx[0],(int) vy[0]);
  ClosePoly();
  FillPoly(Pol, Tabpix_[GREYNUMBER - 1 - MissileXgc.CurPattern]);
  KillPoly(Pol);
}

/** Draw the current mark centred at pointegers defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_(str,n, vx, vy,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n ; 
     integer vx[], vy[],*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  XPointeger *ReturnPointegers_();
  if (MissileXgc.CurHardSymb == 0)
  {
     /* XDrawPoint (ReturnPoints_(), *n,CoordModeOrigin) */ ;
  } else
  {
    integer i, keepid, keepsize,chs;
    i = 1;
    keepid = MissileXgc.FontId;
    keepsize = MissileXgc.FontSize;
    chs=MissileXgc.CurHardSymbSize;
    xsetfont_(&i, &chs,PI0,PI0);
    for (i = 0; i < *n; i++)
      DrawMark_(vx + i, vy + i);
    xsetfont_(&keepid, &keepsize,PI0,PI0);
  }
}

/*-----------------------------------------
  \encadre{List of Window id}
  -----------------------------------------*/

typedef struct
{
  Window win;
  integer winId;
  struct MWindowList *next;
}   MWindowList;

integer windowcount;

MWindowList *The_List_;

AddNewWindowToList_(wind, num)
  Window wind;
  integer num;
{
  AddNewWindow_(&The_List_, wind, num);
}

AddNewWindow_(listptr, wind, num)
  MWindowList **listptr;
  Window wind;
  integer num;
{
  if (num == 0 || *listptr == (MWindowList *) NULL)
  {
    *listptr = (MWindowList *) malloc(sizeof(MWindowList));
    if (listptr == 0)
      Scistring( "AddNewWindow_ :  No More Place ");
    else
    {
      (*listptr)->win = wind;
      (*listptr)->winId = num;
      (*listptr)->next = (struct MWindowList *) NULL;
    }
  } else
    AddNewWindow_((MWindowList **) & ((*listptr)->next), wind, num);
}

Window GetWindowNumber_(i)
  integer i;
{
  Window GetWin_();
  return (GetWin_(The_List_, Max(0, i)));
}

Window GetWin_(listptr, i)
  MWindowList *listptr;
  integer i;
{
  if (listptr == (MWindowList *) NULL)
    return ((Window) NULL);
  else
  {
    if ((listptr->winId) == i)
      return (listptr->win);
    else
      return ((Window) GetWin_((MWindowList *) listptr->next, i));
  }
}

/*--------------------------------------------------------------
  \encadre{Routine for initialisation : string is a display name }
  unused on Macintegerosh
  --------------------------------------------------------------*/

/*
#define NUMCOLORS 17

typedef struct res {
    integer color[NUMCOLORS];
} RES, *RESPTR;

static RES the_res;
*/
set_c(i)
     integer i;
{
  Scistring("Color not implemented yet\n");
}


integer arrowcursor, normalcursor;

#define STRW "\pBG%d"

initgraphic_(string,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char string[];
     integer *v2,*v3,*v4,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  Window Window_With_Name();
  integer i, fnum;
  static integer EntryCounter = 0;
  char winname[sizeof(STRW) + 2];
  /** Initialisation \`a ne faire qu'une fois et pas \`a chaque cr\'eation **/
  /** fen\^etre **/
  if (EntryCounter == 0)
  {
    /** <Macintegerosh Initialisation **/
    MaxApplZone();
    InitGraf(&thePort);
    InitFonts();
    FlushEvents(everyEvent, 0);
    InitWindows();
    /* InitMenus(); */
    TEInit();
    InitDialogs(0L);
    InitCursor();
    SetUpMenus();
    /** <END Macintegerosh Initialisation **/
    CreatePatterns_((unsigned long) 0L, (unsigned long) 1L);
    LoadFonts();
    /* arrowcursor  = XCreateFontCursor (1 ); normalcursor =
     * XCreateFontCursor ( 2); */
    windowcount = 0;
    /* SetUpMenus(); */
  }
  sprintf(winname, "\pBG%d", EntryCounter);
  /** Explicit creation of a graphic window **/
  dragRect = screenBits.bounds;
  /* CWindow = NewWindow(0L, &windowBounds,winname, true, noGrowDocProc, -1L,
   * true, 0); */
  CWindow = NewWindow(0L, &windowBounds, winname, true, documentProc, -1L,
		      true, 0);
  dragRect = screenBits.bounds;
  windowBounds.top += 40;
  windowBounds.bottom += 40;
  /* to register this window in the window array of MacWin.. */
  RegWin(CWindow);
  SetPort(CWindow);
  myWwinWait(CWindow, "New window: \nPosition & size, \nclick to go on");
  AddNewWindowToList_(CWindow, EntryCounter);
  MissileXgc.CurWindow = EntryCounter;
  if (EntryCounter == 0)
  {
    InitMissileXgc(PI0,PI0,PI0,PI0);
  }
  EntryCounter = EntryCounter + 1;
  return (0);
}



/* ecrit un message dans le label du widget CinfoW */

xinfo_(message,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *message;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  
}


void Ignore_Err()
{
}

/*--------------------------------------------------------
  \encadre{Initialisation of the graphic context. Used also
  to come back to the default graphic state}
  ---------------------------------------------------------*/
static int
InitMissileXgc (v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{
  integer i, j, k[2];
  MissileXgc.IDWhitePattern = GREYNUMBER - 1;
  MissileXgc.CurLineWidth = 0;
  i = 1;
  setthickness_(&i,PI0,PI0,PI0);
  setalufunction_("GXcopy");
  /** retirer le clipping **/
  i = j = -1;
  k[0] = 5000, k[1] = 5000;
  setclip_(&i, &j, k, k + 1);
  MissileXgc.ClipRegionSet = 0;
  setdash_((i = 0, &i),PI0,PI0,PI0);
  xsetfont_((i = 2, &i), (j = 1, &j),PI0,PI0);
  xsetmark_((i = 0, &i), (j = 0, &j),PI0,PI0);
  /** trac\'e absolu **/
  MissileXgc.CurVectorStyle = CoordModeOrigin;
  setpattern_((i = 0, &i),PI0,PI0,PI0);
  use_color = 0;
  strcpy(MissileXgc.CurNumberDispFormat, "%-5.2g");
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
  $n1$and $n2$ are integer  numbers for integererval numbers.
  \item $size=<dl,r,coeff>$. $dl$ distance in pointegers between
  two marks, $r$ size in pointegers of small mark, $r*coeff$
  size in pointegers of big marks. (they are doubleing pointegers numbers)
  \item $init$. Initial pointeger $<x,y>$.
  \end{itemize}

  -------------------------------------------------------------*/

drawaxis_(str,alpha,nsteps,v2,initpoint,v6,v7,size,dx2,dx3,dx4)
     double *dx2,*dx3,*dx4;
     char str[];
     integer  *alpha,*nsteps,*initpoint,*v1,*v2,*v6,*v7;
     double *size;
{
  integer i;
  double xi, yi, xf, yf;
  double cosal, sinal;
  cosal = cos((double) M_PI * (*alpha) / 180.0);
  sinal = sin((double) M_PI * (*alpha) / 180.0);
  for (i = 0; i <= nsteps[0] * nsteps[1]; i++)
  {
    xi = initpoint[0] + i * size[0] * cosal;
    yi = initpoint[1] + i * size[0] * sinal;
    xf = xi - (size[1] * sinal);
    yf = yi + (size[1] * cosal);
    XDrawLine(inint(xi), inint(yi), inint(xf), inint(yf));
  }
  for (i = 0; i <= nsteps[1]; i++)
  {
    xi = initpoint[0] + i * nsteps[0] * size[0] * cosal;
    yi = initpoint[1] + i * nsteps[0] * size[0] * sinal;
    xf = xi - (size[1] * size[2] * sinal);
    yf = yi + (size[1] * size[2] * cosal);
    XDrawLine(inint(xi), inint(yi), inint(xf), inint(yf));
  }
  xi = initpoint[0];
  yi = initpoint[1];
  xf = initpoint[0] + nsteps[0] * nsteps[1] * size[0] * cosal;
  yf = initpoint[1] + nsteps[0] * nsteps[1] * size[0] * sinal;
  XDrawLine(inint(xi), inint(yi), inint(xf), inint(yf));

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
{
  integer i;
  char buf[20];
  for (i = 0; i < *n; i++)
  {
    sprintf(buf, MissileXgc.CurNumberDispFormat, z[i]);
    displaystring_(buf,&(x[i]),&(y[i]),PI0,flag,PI0,PI0,&(alpha[i]),PD0,PD0,PD0) ;
  }
}


/*---------------------------------------------------------------------
  \subsection{Using X11 Fonts}
  functions : xsetfont\_, xgetfont\_,xsetmark\_,xgetmark\_,xloadfamily\_
  ---------------------------------------------------------------------*/

#define FONTNUMBER 7
#define FONTMAXSIZE 6
#define SYMBOLNUMBER 10
static int FontsList_[FONTNUMBER][FONTMAXSIZE];
struct MyFontInfo
{
  integer ok;
  char fname[20];
}   FontInfoTab_[FONTNUMBER];

static char *size_[] = {"08", "10", "12", "14", "18", "24"};
static int isize_[] = {8, 10, 12, 14, 18, 24};

/** To set the current font id  and size **/

int xsetfont_(fontid,fontsize,v3,v4)
     integer *fontid , *fontsize ,*v3,*v4;
{
  integer i, fsiz;
  i = Min(FONTNUMBER - 1, Max(*fontid, 0));
  fsiz = Min(FONTMAXSIZE - 1, Max(*fontsize, 0));
  if (FontInfoTab_[i].ok != 1)
    Scistring( "\n Sorry This Font is Not available ");
  else
  {

    MissileXgc.FontId = i;
    MissileXgc.FontSize = fsiz;
    MissileXgc.FontXID = FontsList_[i][fsiz];
    TextFont((int)i);
    TextSize(isize_[fsiz]);
  }
}

/** To get the  id and size of the current font **/

integer xgetfont_(verbose, font, nargs)
  integer *verbose, *font, *nargs;
{
  *nargs = 2;
  font[0] = MissileXgc.FontId;
  font[1] = MissileXgc.FontSize;
  if (*verbose == 1)
  {
    fprintf(stderr, "\nFontId : %d --> %s at size %s pts",
	    MissileXgc.FontId,
	    FontInfoTab_[MissileXgc.FontId].fname,
	    size_[MissileXgc.FontSize]);
  }
}

/** To set the current mark **/
xsetmark_(number,size,v3,v4)
     integer *number,*size ,*v3,*v4;
{
  MissileXgc.CurHardSymb = Max(Min(SYMBOLNUMBER - 1, *number), 0);
  MissileXgc.CurHardSymbSize = Max(Min(FONTMAXSIZE - 1, *size), 0);
  ;
}

/** To get the current mark id **/

xgetmark_(verbose, symb, narg)
  integer *verbose, *symb, *narg;
{
  *narg = 2;
  symb[0] = MissileXgc.CurHardSymb;
  symb[1] = MissileXgc.CurHardSymbSize;
  if (*verbose == 1)
    fprintf(stderr, "\nMark : %d at size %s pts", MissileXgc.CurHardSymb,
	    size_[MissileXgc.CurHardSymbSize]);
}

/** Load in X11 a font at size  08 10 12 14 18 24 **/
/** uses  /usr/lib/X11/fonts/75dpi/fonts.alias **/
/** and record this family under the *j id **/
/** if for example name="TimR"  then X11 try to load **/
/**  TimR08 TimR10 TimR12 TimR14 TimR18 TimR24 **/



loadfamily_(name,j,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *name;
     integer *j,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  char name1[20];
  integer i;
  for (i = 0; i < FONTMAXSIZE; i++)
  {
    switch (name[0])
    {
    case 'C':
      FontsList_[*j][i] = courier;
      break;
    case 'T':
      FontsList_[*j][i] = 20;
      break;
      break;
    case 's':
      FontsList_[*j][i] = symbol;
    }
    if (FontsList_[*j][i] == 0)
    {
      fprintf(stderr, "\n Unknown font : %s", name1);
      Scistring( "\n I'll use font: times ");
      FontsList_[*j][i] = 20;
    }
  }
  FontInfoTab_[*j].ok = 1;
  strcpy(FontInfoTab_[*j].fname, name);
}

LoadFonts()
{
  integer fnum;
  loadfamily_("CourR", (fnum = 0, &fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  LoadSymbFonts();
  loadfamily_("TimR", (fnum = 2, &fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  loadfamily_("TimI", (fnum = 3, &fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  loadfamily_("TimB", (fnum = 4, &fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  loadfamily_("TimBI", (fnum = 5, &fnum),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
}

/** We use the Symbol font  for mark plotting **/
/** so we want to be able to center a Symbol character at a specified pointeger **/

typedef struct
{
  integer xoffset[SYMBOLNUMBER];
  integer yoffset[SYMBOLNUMBER];
}   Offset;

static Offset ListOffset_[FONTMAXSIZE];
static char Marks[] = {
  /* ., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle */

'.', '+', '´', '*', '¨', 'à', 'D', 'Ð', '§', 'o'};

LoadSymbFonts()

{
  integer i, j, k;
  /** Symbol Font is loaded under Id : 1 **/
  loadfamily_("symb", (i = 1, &i),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  for (i = 0; i < FONTMAXSIZE; i++)
  {
    if (FontsList_[1][i] != 0)
    {
      for (j = 0; j < SYMBOLNUMBER; j++)
      {
	FontInfo info;
	integer lineHeight;

	TextFont(FontsList_[1][i]);
	TextSize(isize_[i]);
	GetFontInfo(&info);
	lineHeight = info.ascent + info.descent;
	(ListOffset_[i].xoffset)[j] = CharWidth(Marks[j]) / 2;
	(ListOffset_[i].yoffset)[j] = lineHeight / 2;
      }
    }
  }
  TextSize(12);
  TextFont(0);
}

/** The two next functions send the x and y offsets to center the current **/
/** symbol at pointeger (x,y) **/

integer CurSymbXOffset_()
{
  return (-(ListOffset_[MissileXgc.CurHardSymbSize].xoffset)
	  [MissileXgc.CurHardSymb]);
}
integer CurSymbYOffset_()
{
  return ((ListOffset_[MissileXgc.CurHardSymbSize].yoffset)
	  [MissileXgc.CurHardSymb]);
}

DrawMark_(x, y)
  integer *x, *y;
{
  char str;
  str = Marks[MissileXgc.CurHardSymb];
  MoveTo((int) (*x + CurSymbXOffset_()),(int) (*y + CurSymbYOffset_()));
  DrawChar(str);
}
