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

static int use_color=0;
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
  int x, y;
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
extern int xint_type;


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

xselgraphic_()
{
  SelectWindow(CWindow);
};

/** End of graphic (do nothing)  **/

static endflag_ = 0;

xendgraphic_()
{
  endflag_ = 1;
}

xend_()
{
  /** Must destroy everything  **/
}

/** Clear the current graphic window     **/

clearwindow_()
{
  BeginUpdate(CWindow);
  EraseRect(&CWindow->portRect);
  DrawGrowIcon(CWindow);
  EndUpdate(CWindow);
};

/*-----------------------------------------------------------
  \encadre{To generate a pause, in seconds}
  ------------------------------------------------------------*/

xpause_(sec_time)
  int *sec_time;
{
  /* unsigned int useconds; XSync(dpy,0); useconds=(unsigned) sec_time; if
   * (useconds != 0)  usleep(useconds); */
};

/*-----------------------------------------------------------
  \encadre{ Wait for mouse click in graphic window
  send back mouse location  (x1,y1)  and button number
  0,1,2}
  There's just a pb if the window is iconified when we try to
  click this case is not checked
  -----------------------------------------------------------*/


xclick_(str, ibutton, x1, y1)
  char str[];
  int *ibutton, *x1, *y1;
{
  /* TODO Waits for a click but needs to return coords */
  myWwinWait(CWindow, "Wait for a Click");
}


/*------------------------------------------------
  \encadre{Clear a rectangle }
  -------------------------------------------------*/

cleararea_(str, x, y, w, h)
  char str[];
  int *x, *y, *w, *h;
{
  Rect MyRect;
  SetRect(&MyRect, *x, *y, *x + *w, *y + *h);
  EraseRect(&MyRect);
};

/*---------------------------------------------------------------------
  \section{Function for graphic context modification}
  ------------------------------------------------------------------------*/

/** to get the window upper-left point coordinates on the screen  **/

getwindowpos_(verbose, x, narg)
  int *verbose, *x, *narg;
{
  *narg = 2;
  x[0] = CWindow->portRect.left;
  x[1] = CWindow->portRect.top;
  if (*verbose == 1)
    fprintf(stderr, "\n CWindow position :%d,%d", x[0], x[1]);
};

/** to set the window upper-left point position on the screen **/

setwindowpos_(x, y)
  int *x, *y;
{
  MoveWindow(CWindow, *x, *y, FALSE);
};

/** To get the window size **/
#define SBARWIDTH 16

getwindowdim_(verbose, x, narg)
  int *verbose, *x, *narg;
{
  *narg = 2;
  x[0] = (CWindow->portRect).right - (CWindow->portRect).left - SBARWIDTH;
  x[1] = (CWindow->portRect).bottom - (CWindow->portRect).top - SBARWIDTH;
  if (*verbose == 1)
    fprintf(stderr, "\n CWindow dim :%d,%d", x[0], x[1]);
};

/** To change the window size  **/

setwindowdim_(x, y)
  int *x, *y;
{
  SizeWindow(CWindow, *x, *y, TRUE);
};


/** To select a graphic Window  **/

setcurwin_(intnum)
  int *intnum;
{
  Window GetWindowNumber_();
  CWindow = GetWindowNumber_(*intnum);
  fprintf(stderr, "OK inside setcurwin\n");
  MissileXgc.CurWindow = *intnum;
  if (CWindow == (Window) NULL)
  {
    int i;
    for (i = 0; i <= *intnum; i++)
      if (GetWindowNumber_(*intnum) == (Window) NULL)
	initgraphic_("");
  };
};

/** Get the id number of the Current Graphic Window **/

getcurwin_(verbose, intnum, narg)
  int *verbose, *intnum, *narg;
{
  *narg = 1;
  *intnum = MissileXgc.CurWindow;
  if (*verbose == 1)
    fprintf(stderr, "\nCurrent Graphic Window :%d", *intnum);
};

/** Set a clip zone (rectangle ) **/

setclip_(x, y, w, h)
  int *x, *y, *w, *h;
{
  Rect MyRect;
  MissileXgc.ClipRegionSet = 1;
  MissileXgc.CurClipRegion[0] = *x;
  MissileXgc.CurClipRegion[1] = *y;
  MissileXgc.CurClipRegion[2] = *w;
  MissileXgc.CurClipRegion[3] = *h;
  SetRect(&MyRect, *x, *y, *x + *w, *y + *h);
  ClipRect(&MyRect);
};

/** Get the boundaries of the current clip zone **/

getclip_(verbose, x, narg)
  int *verbose, *x, *narg;
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
      fprintf(stderr, "\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d",
	      MissileXgc.CurClipRegion[0],
	      MissileXgc.CurClipRegion[1],
	      MissileXgc.CurClipRegion[2],
	      MissileXgc.CurClipRegion[3]);
    else
      fprintf(stderr, "\nNo Clip Region");
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
  if (*num == 0)
    MissileXgc.CurVectorStyle = CoordModeOrigin;
  else
    MissileXgc.CurVectorStyle = CoordModePrevious;
};

/** to get information on absolute or relative mode **/

getabsourel_(verbose, num, narg)
  int *verbose, *num, *narg;
{
  *narg = 1;
  *num = MissileXgc.CurVectorStyle;
  if (*verbose == 1)
    if (MissileXgc.CurVectorStyle == CoordModeOrigin)
      fprintf(stderr, "\nTrace Absolu");
    else
      fprintf(stderr, "\nTrace Relatif");
};

/** The alu function for drawing : Works only with X11 **/
/** Not in Postscript **/

setalufunction_(string)
  char string[];
{
  int value;
  idfromname(string, &value);
  if (value != -1)
  {
    MissileXgc.CurDrawFunction = value;
  };
};
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


setalufunction1_(num)
  int *num;
{
  int value;
  value = AluStruc_[Min(16, Max(0, *num))].id;
  /* PenMode(value); */
  if (value == 0)
    PenPat(white);
  else
    PenPat(black);
  if (value != -1)
  {
    MissileXgc.CurDrawFunction = value;
  };
};

idfromname(name1, num)
  char name1[];
  int *num;
{
  int i;
  *num = -1;
  for (i = 0; i < 16; i++)
    if (strcmp(AluStruc_[i].name, name1) == 0)
      *num = AluStruc_[i].id;
  if (*num == -1)
  {
    fprintf(stderr, "\n Use the following keys (integer in scilab");
    for (i = 0; i < 16; i++)
      fprintf(stderr, "\nkey %s   -> %s", AluStruc_[i].name,
	      AluStruc_[i].info);
  };
};

/** To get the value of the alufunction **/

getalufunction_(verbose, value, narg)
  int *verbose, *value, *narg;
{
  *narg = 1;
  *value = MissileXgc.CurDrawFunction;
  if (*verbose == 1)
  {
    fprintf(stderr, "\nThe Alufunction is %s -> <%s>\n",
	    AluStruc_[*value].name,
	    AluStruc_[*value].info);
  }
};


/** to set the thickness of lines : 0 is a possible value **/
/** give the thinest line (0 and 1 the same for X11 but   **/
/** with diferent algorithms ) **/
/** defaut value is 1 **/
/** Must be Updated for the MAC JPC **/

setthickness_(value)
  int *value;
{
  PenSize(*value, *value);
  MissileXgc.CurLineWidth = Max(0, *value);
}

/** to get the thickness value **/

getthickness_(verbose, value, narg)
  int *verbose, *value, *narg;
{
  *narg = 1;
  *value = MissileXgc.CurLineWidth;
  if (*verbose == 1)
    fprintf(stderr, "\nLine Width:%d",
	    MissileXgc.CurLineWidth);
};

/** To set grey level for filing areas **/
/** from black (*num =0 ) to white     **/

#define GREYNUMBER 17

static unsigned char Tabpix_[GREYNUMBER][8] = {
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

CreatePatterns_(whitepixel, blackpixel)
  unsigned long whitepixel, blackpixel;
{
  /* Nothing to do */
};


setpattern_(num)
     int *num;
{ int i ; 
  i= Max(0,Min(*num,GREYNUMBER-1));
  MissileXgc.CurPattern = i;
  if ( use_color ==1) set_c(i);
  };

/** To get the id of the current pattern  **/

getpattern_(verbose, num, narg)
  int *num, *verbose, *narg;
{
  *narg = 1;
  *num = MissileXgc.CurPattern;
  if (*verbose == 1)
    fprintf(stderr, "\n Pattern : %d",
	    MissileXgc.CurPattern);
};

/** To get the id of the white pattern **/

getwhite_(verbose, num, narg)
  int *num, *verbose, *narg;
{
  *num = MissileXgc.IDWhitePattern;
  if (*verbose == 1)
    fprintf(stderr, "\n Id of White Pattern %d :", *num);
  *narg = 1;
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
  {2, 5, 2, 5}, {5, 2, 5, 2}, {5, 3, 2, 3}, {8, 3, 2, 3},
{11, 3, 2, 3}, {11, 3, 5, 3}};

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

#define LineOnOffDash 1
#define LineSolid 0
setdashstyle_(value, xx, n)
  int *value, xx[], *n;
{
  int dashok = LineOnOffDash;
  if (*value == 0)
    dashok = LineSolid;
  else
  {
    int i;
    char buffdash[18];
    for (i = 0; i < *n; i++)
      buffdash[i] = xx[i];
    /* A FAIRE  XSetDashes(buffdash,*n); */
  };
  /* A FAIRE XSetLineAttributes(MissileXgc.CurLineWidth,dashok); */
}

/** to get the current dash-style **/

getdash_(verbose, value, narg)
  int *verbose, *value, *narg;
{
  int i;
  *value = MissileXgc.CurDashStyle;
  *narg = 1;
  if (*value == 0)
  {
    if (*verbose == 1)
      fprintf(stderr, "\nLine style = Line Solid");
  } else
  {
    value[1] = 4;
    *narg = value[1] + 2;
    for (i = 0; i < value[1]; i++)
      value[i + 2] = DashTab[*value - 1][i];
    if (*verbose == 1)
    {
      fprintf(stderr, "\nDash Style %d:<", *value);
      for (i = 0; i < value[1]; i++)
	fprintf(stderr, "%d ", value[i + 2]);
      fprintf(stderr, ">\n");
    }
  }
};

/*-----------------------------------------------------------
  \encadre{general routines accessing the  set<> or get<>
  routines }
  -------------------------------------------------------------*/

int InitMissileXgc();

empty_(verbose)
  int *verbose;
{
  if (*verbose == 1)
    fprintf(stderr, "\n No operation ");
};

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

MissileGCget_(str, verbose, x1, x2, x3, x4, x5)
  char str[];
  int *verbose, *x1, *x2, *x3, *x4, *x5;

{
  MissileGCGetorSet_(str, 1, verbose, x1, x2, x3, x4, x5);
};

MissileGCset_(str, x1, x2, x3, x4, x5)
  char str[];
  int *x1, *x2, *x3, *x4, *x5;
{
  int verbose = 0;
  MissileGCGetorSet_(str, 0, &verbose, x1, x2, x3, x4, x5);
}

MissileGCGetorSet_(str, flag, verbose, x1, x2, x3, x4, x5)
  char str[];
  int flag;
  int *verbose, *x1, *x2, *x3, *x4, *x5;
{
  int i;
  for (i = 0; i < NUMSETFONC; i++)
  {
    int j;
    j = strcmp(str, MissileGCTab_[i].name);
    if (j == 0)
    {
      if (*verbose == 1)
	fprintf(stderr, "\nGettting Info on %s", str);
      if (flag == 1)
	(MissileGCTab_[i].getfonc) (verbose, x1, x2, x3, x4, x5);
      else
	(MissileGCTab_[i].setfonc) (x1, x2, x3, x4, x5);
      return;
    } else
    {
      if (j <= 0)
      {
	fprintf(stderr, "\nUnknow X operator <%s>", str);
	return;
      };
    };
  };
  fprintf(stderr, "\n Unknow X operator <%s>", str);
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

displaystring_(string, x, y, angle, flag)
  int *x, *y, *flag;
  double *angle;
  char string[];
{
  if (Abs(*angle) <= 0.1)
  {
    /* fprintf(stderr,"string at %d,%d %s\n",*x,*y,string); */
    MoveTo(*x, *y);
    CtoPstr(string);
    DrawString(string);
    PtoCstr(string);
    if (*flag == 1)
    {
      int rect[4];
      fprintf(stderr, " je rajoute un rect \n");
      boundingbox_(string, x, y, rect);
      rect[0] = rect[0] - 4;
      rect[2] = rect[2] + 6;
      fprintf(stderr, " je rajoute un %s,%d,%d,%d,%d \n", string, rect[0], rect[1], rect[2], rect[3]);
      drawrectangle_(string, rect, rect + 1, rect + 2, rect + 3);
    };
  } else
    DispStringAngle_(x, y, string, angle);

}
#define M_PI 3.14116

DispStringAngle_(x0, y0, string, angle)
  int *x0, *y0;
  double *angle;
  char string[];
{
  int w, h, x, y, i, rect[4];
  double sina, cosa, l;
  char str1[2];
  str1[1] = '\0';
  x = *x0;
  y = *y0;
  sina = sin((*angle) * M_PI / 180.0);
  cosa = cos((*angle) * M_PI / 180.0);
  for (i = 0; i < strlen(string); i++)
  {
    str1[0] = string[i];

    MoveTo(x, y);
    DrawChar(string[i]);
    boundingbox_(str1, &x, &y, rect);
    /** drawrectangle_(string,rect,rect+1,rect+2,rect+3); **/
    if (cosa <= 0.0 && i < strlen(string) - 1)
    {
      char str2[2];
      /** si le cosinus est negatif le deplacement est a calculer **/
      /** sur la boite du caractere suivant **/
      str2[1] = '\0';
      str2[0] = string[i + 1];
      boundingbox_(str2, &x, &y, rect);
    };
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
  };
};

/** To get the bounding rectangle of a string **/

boundingbox_(string, x, y, rect)
  int *x, *y, *rect;
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
};

/*------------------------------------------------
  subsection{ Segments and Arrows }
  -------------------------------------------------*/

drawline_(x1, y1, x2, y2)
  int *x1, *x2, *y1, *y2;
{
  XDrawLine(*x1, *y1, *x2, *y2);
}

XDrawLine(xi, yi, xf, yf)
  int xi, yi, xf, yf;
{
  MoveTo(xi, yi);
  LineTo(xf, yf);
};


/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/

drawsegments_(str, vx, vy, n)
  char str[];
  int *n, vx[], vy[];
{
  int i;
  for (i = 0; i < *n / 2; i++)
  {
    XDrawLine(vx[2 * i], vy[2 * i], vx[2 * i + 1], vy[2 * i + 1]);

  };

};

/** Draw a set of arrows **/
/** arrows are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/** n is the size of vx and vy **/
/** as is 10*arsize (arsize) the size of the arrow head in pixels **/

drawarrows_(str, vx, vy, n, as)
  char str[];
  int *as;
  int *n, vx[], vy[];
{
  double cos20 = cos(20.0 * M_PI / 180.0);
  double sin20 = sin(20.0 * M_PI / 180.0);
  int polyx[4], polyy[4], fillvect[1];
  int i;
  for (i = 0; i < *n / 2; i++)
  {
    double dx, dy, norm;
    XDrawLine(vx[2 * i], vy[2 * i], vx[2 * i + 1], vy[2 * i + 1]);
    dx = (vx[2 * i + 1] - vx[2 * i]);
    dy = (vy[2 * i + 1] - vy[2 * i]);
    norm = sqrt(dx * dx + dy * dy);
    if (Abs(norm) > SMDOUBLE)
    {
      int n = 1, p = 3;
      dx = (*as / 10.0) * dx / norm;
      dy = (*as / 10.0) * dy / norm;
      polyx[0] = polyx[3] = vx[2 * i + 1] + dx * cos20;
      polyx[1] = nint(polyx[0] - cos20 * dx - sin20 * dy);
      polyx[2] = nint(polyx[0] - cos20 * dx + sin20 * dy);
      polyy[0] = polyy[3] = vy[2 * i + 1] + dy * cos20;
      polyy[1] = nint(polyy[0] + sin20 * dx - cos20 * dy);
      polyy[2] = nint(polyy[0] - sin20 * dx - cos20 * dy);
      fillpolylines_("v", polyx, polyy, (fillvect[0] = 0, fillvect), &n, &p);
    };
  };

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
/** with pattern fillvect[i] **/
/** if fillvect[i] is > whitepattern  then only draw the rectangle i **/
/** The drawing style is the current drawing style **/

drawrectangles_(str, vects, fillvect, n)
  char str[];
  int *vects, *fillvect, *n;
{
  int i, cpat, verbose = 0, num;
  getpattern_(&verbose, &cpat, &num);
  for (i = 0; i < *n; i++)
  {
    if (fillvect[i] > MissileXgc.IDWhitePattern)
    {
      drawrectangle_(str, vects + 4 * i, vects + 4 * i + 1, vects + 4 * i + 2, vects + 4 * i + 3);
    } else
    {
      setpattern_(&(fillvect[i]));
      fillrectangle_(str, vects + 4 * i, vects + 4 * i + 1, vects + 4 * i + 2, vects + 4 * i + 3);
    }
  }
  setpattern_(&(cpat));
};

/** Draw one rectangle with current line style **/

drawrectangle_(str, x, y, width, height)
  char str[];
  int *x, *y, *width, *height;
{
  Rect MyRect;
  SetRect(&MyRect, *x, *y, *x + *width, *y + *height);
  FrameRect(&MyRect);
}

/** fill one rectangle, with current pattern **/

fillrectangle_(str, x, y, width, height)
  char str[];
  int *x, *y, *width, *height;
{
  Rect MyRect;
  Pattern thePat;
  SetRect(&MyRect, *x, *y, *x + *width, *y + *height);
  FillRect(&MyRect, Tabpix_[GREYNUMBER - 1 - MissileXgc.CurPattern]);
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
/** with pattern fillvect[i] **/
/** if fillvect[i] is > whitepattern  then only draw the ellipsis i **/
/** The drawing style is the current drawing style **/

drawarcs_(str, vects, fillvect, n)
  char str[];
  int *vects, *fillvect, *n;
{
  int i, cpat, verb, num;
  verb = 0;
  getpattern_(&verb, &cpat, &num);
  for (i = 0; i < *n; i++)
  {
    if (fillvect[i] > MissileXgc.IDWhitePattern)
    {
      setpattern_(&(cpat));
      drawarc_(str, vects + 6 * i, vects + 6 * i + 1,
	       vects + 6 * i + 2, vects + 6 * i + 3,
	       vects + 6 * i + 4, vects + 6 * i + 5);
    } else
    {
      setpattern_(&(fillvect[i]));
      fillarc_(str, vects + 6 * i, vects + 6 * i + 1,
	       vects + 6 * i + 2, vects + 6 * i + 3,
	       vects + 6 * i + 4, vects + 6 * i + 5);
    }
  }
  setpattern_(&(cpat));
};

/** Draw a single ellipsis or part of it **/

drawarc_(str, x, y, width, height, angle1, angle2)
  char str[];
  int *angle1, *angle2, *x, *y, *width, *height;
{
  /* XDrawArc( *x, *y, *width, *height,*angle1, *angle2); */
  Rect MyRect;
  SetRect(&MyRect, *x, *y, *x + *width, *y + *height);
  FrameArc(&MyRect, *angle1 / 64 - 90, (*angle2 - *angle1) / 64);

}

/** Fill a single elipsis or part of it with current pattern **/

fillarc_(str, x, y, width, height, angle1, angle2)
  char str[];
  int *angle1, *angle2, *x, *y, *width, *height;
{
  Rect MyRect;
  SetRect(&MyRect, *x, *y, *x + *width, *y + *height);
  FillArc(&MyRect, *angle1 / 64 - 90, (*angle2 - *angle1) / 64, Tabpix_[GREYNUMBER - 1 - MissileXgc.CurPattern]);
}
/*--------------------------------------------------------------
  \encadre{Filling or Drawing Polylines and Polygons}
  ---------------------------------------------------------------*/

/** Draw a set of (*n) polylines (each of which have (*p) points) **/
/** with lines or marks **/
/** drawvect[i] >= 0 use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

drawpolylines_(str, vectsx, vectsy, drawvect, n, p)
  char str[];
  int *vectsx, *vectsy, *drawvect, *n, *p;
{
  int verbose = 0, symb[2], Mnarg, Dnarg, Dvalue[10], NDvalue, i, close;
  /* store the current values */
  xgetmark_(&verbose, symb, &Mnarg);
  getdash_(&verbose, Dvalue, &Dnarg);
  for (i = 0; i < *n; i++)
  {
    if (drawvect[i] >= 0)
    {				/** we use the markid : drawvect[i] **/
      xsetmark_(drawvect + i, symb + 1);
      drawpolymark_(str, p, vectsx + (*p) * i, vectsy + (*p) * i);
    } else
    {				/** we use the line-style number abs(drawvect[i])  **/
      NDvalue = -drawvect[i] - 1;
      setdash_(&NDvalue);
      close = 0;
      drawpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, &close);
    };
  };
  /** back to default values **/
  setdash_(Dvalue);
  xsetmark_(symb, symb + 1);
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

fillpolylines_(str, vectsx, vectsy, fillvect, n, p)
  char str[];
  int *vectsx, *vectsy, *fillvect, *n, *p;
{
  int i, cpat, verbose = 0, num, close = 1, pattern;
  getpattern_(&verbose, &cpat, &num);
  for (i = 0; i < *n; i++)
  {
    if (fillvect[i] >= MissileXgc.IDWhitePattern + 2)
    {				/** on peint puis on fait un contour ferme **/
      pattern = -fillvect[i] + 2 * MissileXgc.IDWhitePattern + 2;
      setpattern_(&pattern);
      fillpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, (close = 1, &close));
      setpattern_(&(cpat));
      drawpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, (close = 1, &close));
    } else
    {
      if (fillvect[i] == MissileXgc.IDWhitePattern + 1)
	drawpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, (close = 0, &close));
      else
      {
	setpattern_(&(fillvect[i]));
	fillpolyline_(str, p, vectsx + (*p) * i, vectsy + (*p) * i, (close = 0, &close));
      }
    }
  }
  setpattern_(&(cpat));
};

/** Only draw one polygon  with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/
/** n is the number of points of the polyline */

drawpolyline_(str, n, vx, vy, closeflag)
  char str[];
  int *n, *closeflag;
  int vx[], vy[];
{
  int n1;
  XPoint *ReturnPoints_();
  if (*closeflag == 1)
    n1 = *n + 1;
  else
    n1 = *n;
  if (n1 >= 2)
  {
    MacLines(vx, vy, *n, *closeflag);
  };
};

MacLines(vx, vy, n, closeflag)
  int vx[], vy[], n, closeflag;
{
  PolyHandle Pol;
  int i;
  Pol = OpenPoly();
  MoveTo(vx[0], vy[0]);
  for (i = 0; i < n; i++)
    LineTo(vx[i], vy[i]);
  if (closeflag == 1)
    LineTo(vx[0], vy[0]);
  ClosePoly();
  FramePoly(Pol);
  KillPoly(Pol);
}

/** Fill the polygon or polyline **/
/** according to *closeflag : the given vector is a polyline or a polygon **/

fillpolyline_(str, n, vx, vy, closeflag)
  char str[];
  int *n, *closeflag;
  int vx[], vy[];
{
  int n1;
  XPoint *ReturnPoints_();
  MacFillLines(vx, vy, *n, *closeflag);
};

MacFillLines(vx, vy, n, closeflag)
  int vx[], vy[], n, closeflag;
{
  PolyHandle Pol;
  int i;
  /* fprintf(stderr," inside fill poly \n"); */
  Pol = OpenPoly();
  MoveTo(vx[0], vy[0]);
  for (i = 0; i < n; i++)
    LineTo(vx[i], vy[i]);
  if (closeflag == 1)
    LineTo(vx[0], vy[0]);
  ClosePoly();
  FillPoly(Pol, Tabpix_[GREYNUMBER - 1 - MissileXgc.CurPattern]);
  KillPoly(Pol);
}

/** Draw the current mark centred at points defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_(str, n, vx, vy)
  char str[];
  int *n;
  int vx[], vy[];
{
  XPoint *ReturnPoints_();
  if (MissileXgc.CurHardSymb == 0)
  {
     /* XDrawPoints (ReturnPoints_(), *n,CoordModeOrigin) */ ;
  } else
  {
    int i, keepid, keepsize;
    i = 1;
    keepid = MissileXgc.FontId;
    keepsize = MissileXgc.FontSize;
    xsetfont_(&i, &(MissileXgc.CurHardSymbSize));
    for (i = 0; i < *n; i++)
      DrawMark_(vx + i, vy + i);
    xsetfont_(&keepid, &keepsize);
  };
};

/*-----------------------------------------
  \encadre{List of Window id}
  -----------------------------------------*/

typedef struct
{
  Window win;
  int winId;
  struct MWindowList *next;
}   MWindowList;

int windowcount;

MWindowList *The_List_;

AddNewWindowToList_(wind, num)
  Window wind;
  int num;
{
  AddNewWindow_(&The_List_, wind, num);
};

AddNewWindow_(listptr, wind, num)
  MWindowList **listptr;
  Window wind;
  int num;
{
  if (num == 0 || *listptr == (MWindowList *) NULL)
  {
    *listptr = (MWindowList *) malloc(sizeof(MWindowList));
    if (listptr == 0)
      fprintf(stderr, "AddNewWindow_ :  No More Place ");
    else
    {
      (*listptr)->win = wind;
      (*listptr)->winId = num;
      (*listptr)->next = (struct MWindowList *) NULL;
    }
  } else
    AddNewWindow_((MWindowList **) & ((*listptr)->next), wind, num);
};

Window GetWindowNumber_(i)
  int i;
{
  Window GetWin_();
  return (GetWin_(The_List_, Max(0, i)));
};

Window GetWin_(listptr, i)
  MWindowList *listptr;
  int i;
{
  if (listptr == (MWindowList *) NULL)
    return ((Window) NULL);
  else
  {
    if ((listptr->winId) == i)
      return (listptr->win);
    else
      return ((Window) GetWin_((MWindowList *) listptr->next, i));
  };
};

/*--------------------------------------------------------------
  \encadre{Routine for initialisation : string is a display name }
  unused on Macintosh
  --------------------------------------------------------------*/

/*
#define NUMCOLORS 17

typedef struct res {
    int color[NUMCOLORS];
} RES, *RESPTR;

static RES the_res;
*/
set_c(i)
     int i;
{
  fprintf(stderr,"Color not implemented yet\n");
} ;


int arrowcursor, normalcursor;

#define STRW "\pBG%d"

initgraphic_(string)
  char string[];
{
  Window Window_With_Name();
  int i, fnum;
  static int EntryCounter = 0;
  char winname[sizeof(STRW) + 2];
  /** rentr\'ee dans une initialisation de fen\^etre apr\`es avoir **/
  /** fait un endgraphic, c'est ce que fait le positionnement automatique**/
  /** pour corriger ce bug : on ne fait rien juste un clearwindow **/
  /** a virer quand on sera debarrasse de brigitte **/
  if (endflag_ == 1)
  {
    endflag_ = 0;
    clearwindow_();
    return (0);
  };
  /** Initialisation \`a ne faire qu'une fois et pas \`a chaque cr\'eation **/
  /** fen\^etre **/
  if (EntryCounter == 0)
  {
    /** <Macintosh Initialisation **/
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
    /** <END Macintosh Initialisation **/
    CreatePatterns_(0, 1);
    LoadFonts();
    /* arrowcursor  = XCreateFontCursor (1 ); normalcursor =
     * XCreateFontCursor ( 2); */
    windowcount = 0;
    /* SetUpMenus(); */
  };
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
    InitMissileXgc();
  };
  EntryCounter = EntryCounter + 1;
  return (0);
};

void Ignore_Err()
{
};

/*--------------------------------------------------------
  \encadre{Initialisation of the graphic context. Used also
  to come back to the default graphic state}
  ---------------------------------------------------------*/

InitMissileXgc()
{
  int i, j, k[2];
  MissileXgc.IDWhitePattern = GREYNUMBER - 1;
  MissileXgc.CurLineWidth = 0;
  i = 1;
  setthickness_(&i);
  setalufunction_("GXcopy");
  /** retirer le clipping **/
  i = j = -1;
  k[0] = 5000, k[1] = 5000;
  setclip_(&i, &j, k, k + 1);
  MissileXgc.ClipRegionSet = 0;
  setdash_((i = 0, &i));
  xsetfont_((i = 2, &i), (j = 1, &j));
  xsetmark_((i = 0, &i), (j = 0, &j));
  /** trac\'e absolu **/
  MissileXgc.CurVectorStyle = CoordModeOrigin;
  setpattern_((i = 0, &i));
  strcpy(MissileXgc.CurNumberDispFormat, "%-5.2g");
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

drawaxis_(str, alpha, nsteps, size, initpoint)
  char str[];
  int *alpha, *nsteps, *initpoint;
  double *size;
{
  int i;
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
    XDrawLine(nint(xi), nint(yi), nint(xf), nint(yf));
  };
  for (i = 0; i <= nsteps[1]; i++)
  {
    xi = initpoint[0] + i * nsteps[0] * size[0] * cosal;
    yi = initpoint[1] + i * nsteps[0] * size[0] * sinal;
    xf = xi - (size[1] * size[2] * sinal);
    yf = yi + (size[1] * size[2] * cosal);
    XDrawLine(nint(xi), nint(yi), nint(xf), nint(yf));
  };
  xi = initpoint[0];
  yi = initpoint[1];
  xf = initpoint[0] + nsteps[0] * nsteps[1] * size[0] * cosal;
  yf = initpoint[1] + nsteps[0] * nsteps[1] * size[0] * sinal;
  XDrawLine(nint(xi), nint(yi), nint(xf), nint(yf));

};

/*-----------------------------------------------------
  \encadre{Display numbers z[i] at location (x[i],y[i])
  with a slope alpha[i] (see displaystring), if flag==1
  add a box around the string, only if slope =0}
  -----------------------------------------------------*/

displaynumbers_(str, x, y, z, alpha, n, flag)
  char str[];
  int x[], y[], *n, *flag;
  double z[], alpha[];
{
  int i;
  char buf[20];
  for (i = 0; i < *n; i++)
  {
    sprintf(buf, MissileXgc.CurNumberDispFormat, z[i]);
    displaystring_(buf, &(x[i]), &(y[i]), &(alpha[i]), flag);
  };

};


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
  int ok;
  char fname[20];
}   FontInfoTab_[FONTNUMBER];

static char *size_[] = {"08", "10", "12", "14", "18", "24"};
static int isize_[] = {8, 10, 12, 14, 18, 24};

/** To set the current font id  and size **/

int xsetfont_(fontid, fontsize)
  int *fontid, *fontsize;
{
  int i, fsiz;
  i = Min(FONTNUMBER - 1, Max(*fontid, 0));
  fsiz = Min(FONTMAXSIZE - 1, Max(*fontsize, 0));
  if (FontInfoTab_[i].ok != 1)
    fprintf(stderr, "\n Sorry This Font is Not available ");
  else
  {

    MissileXgc.FontId = i;
    MissileXgc.FontSize = fsiz;
    MissileXgc.FontXID = FontsList_[i][fsiz];
    TextFont(i);
    TextSize(isize_[fsiz]);
  };
};

/** To get the  id and size of the current font **/

int xgetfont_(verbose, font, nargs)
  int *verbose, *font, *nargs;
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
  };
};

/** To set the current mark **/
xsetmark_(number, size)
  int *number;
  int *size;
{
  MissileXgc.CurHardSymb = Max(Min(SYMBOLNUMBER - 1, *number), 0);
  MissileXgc.CurHardSymbSize = Max(Min(FONTMAXSIZE - 1, *size), 0);
  ;
}

/** To get the current mark id **/

xgetmark_(verbose, symb, narg)
  int *verbose, *symb, *narg;
{
  *narg = 2;
  symb[0] = MissileXgc.CurHardSymb;
  symb[1] = MissileXgc.CurHardSymbSize;
  if (*verbose == 1)
    fprintf(stderr, "\nMark : %d at size %s pts", MissileXgc.CurHardSymb,
	    size_[MissileXgc.CurHardSymbSize]);
};

/** Load in X11 a font at size  08 10 12 14 18 24 **/
/** uses  /usr/lib/X11/fonts/75dpi/fonts.alias **/
/** and record this family under the *j id **/
/** if for example name="TimR"  then X11 try to load **/
/**  TimR08 TimR10 TimR12 TimR14 TimR18 TimR24 **/




loadfamily_(name, j)
  char *name;
  int *j;
{
  char name1[20];
  int i;
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
      fprintf(stderr, "\n I'll use font: times ");
      FontsList_[*j][i] = 20;
    };
  };
  FontInfoTab_[*j].ok = 1;
  strcpy(FontInfoTab_[*j].fname, name);
};

LoadFonts()
{
  int fnum;
  loadfamily_("CourR", (fnum = 0, &fnum));
  LoadSymbFonts();
  loadfamily_("TimR", (fnum = 2, &fnum));
  loadfamily_("TimI", (fnum = 3, &fnum));
  loadfamily_("TimB", (fnum = 4, &fnum));
  loadfamily_("TimBI", (fnum = 5, &fnum));
};

/** We use the Symbol font  for mark plotting **/
/** so we want to be able to center a Symbol character at a specified point **/

typedef struct
{
  int xoffset[SYMBOLNUMBER];
  int yoffset[SYMBOLNUMBER];
}   Offset;

static Offset ListOffset_[FONTMAXSIZE];
static char Marks[] = {
  /* ., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle */

'.', '+', '´', '*', '¨', 'à', 'D', 'Ð', '§', 'o'};

LoadSymbFonts()

{
  int i, j, k;
  /** Symbol Font is loaded under Id : 1 **/
  loadfamily_("symb", (i = 1, &i));
  for (i = 0; i < FONTMAXSIZE; i++)
  {
    if (FontsList_[1][i] != 0)
    {
      for (j = 0; j < SYMBOLNUMBER; j++)
      {
	FontInfo info;
	int lineHeight;

	TextFont(FontsList_[1][i]);
	TextSize(isize_[i]);
	GetFontInfo(&info);
	lineHeight = info.ascent + info.descent;
	(ListOffset_[i].xoffset)[j] = CharWidth(Marks[j]) / 2;
	(ListOffset_[i].yoffset)[j] = lineHeight / 2;
      }
    };
  };
  TextSize(12);
  TextFont(0);
};

/** The two next functions send the x and y offsets to center the current **/
/** symbol at point (x,y) **/

int CurSymbXOffset_()
{
  return (-(ListOffset_[MissileXgc.CurHardSymbSize].xoffset)
	  [MissileXgc.CurHardSymb]);
}
int CurSymbYOffset_()
{
  return ((ListOffset_[MissileXgc.CurHardSymbSize].yoffset)
	  [MissileXgc.CurHardSymb]);
}

DrawMark_(x, y)
  int *x, *y;
{
  char str;
  str = Marks[MissileXgc.CurHardSymb];
  MoveTo(*x + CurSymbXOffset_(), *y + CurSymbYOffset_());
  DrawChar(str);
};
