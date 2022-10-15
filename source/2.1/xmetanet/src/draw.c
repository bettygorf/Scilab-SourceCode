#include <stdio.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/Viewport.h>

#include "metaconst.h"
#include "metawin.h"
#include "bezier.h"
#include "color.h"
#include "graphics.h"
#include "font.h"

#define NUMBLEN 10

void MakeDraw()
{
  Arg args[20];
  int iargs = 0;
  static char translations[] =
    "<Expose>: ActionWhenExpose()\n\
    <BtnDown>: ActionWhenPress()\n\
    <BtnUp>: ActionWhenRelease()\n\
    <BtnMotion>: ActionWhenDownMove()\n\
    <Leave>: ActionWhenLeave()";
  XtTranslations compiled_translation_table;
  Widget viewchild;

  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  XtSetArg(args[iargs], XtNfromVert, metanetMenu); iargs++;
  XtSetArg(args[iargs], XtNwidth, metaWidth); iargs++;
  XtSetArg(args[iargs], XtNheight, viewHeight); iargs++;
  XtSetArg(args[iargs], XtNallowHoriz, TRUE); iargs++;
  XtSetArg(args[iargs], XtNallowVert, TRUE); iargs++;
  XtSetArg(args[iargs], XtNforceBars, TRUE); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNtop, XtChainTop); iargs++;
  XtSetArg(args[iargs], XtNright, XtChainRight); iargs++;

  drawViewport = XtCreateManagedWidget
    ("drawViewport",viewportWidgetClass,frame,args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNwidth, drawWidth); iargs++;
  XtSetArg(args[iargs], XtNheight, drawHeight); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;

  viewchild = XtCreateManagedWidget("viewchild",boxWidgetClass,drawViewport,
				   args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, ""); iargs++;
  XtSetArg(args[iargs], XtNwidth, drawWidth); iargs++;
  XtSetArg(args[iargs], XtNheight, drawHeight); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;

  metanetDraw = XtCreateManagedWidget("draw",labelWidgetClass,viewchild,
				   args,iargs);

  compiled_translation_table = XtParseTranslationTable(translations);
  XtOverrideTranslations(metanetDraw,compiled_translation_table);
}

void ClearDraw()
{
  XClearWindow(theG.dpy,theG.d);
}

#define SetForeground(gc,color) XSetForeground(theG.dpy,gc,color)

void SetWidth(gc,width)
GC gc;
int width;
{
  XGCValues gcv;
  gcv.line_width = width;
  XChangeGC(theG.dpy,gc,GCLineWidth,&gcv);
}

/* ARC */

void DrawArcName(x,y,str)
int x, y;
char *str;
{
  int xf,yf;

  if (str == 0) return;
  xf = (int)((x+2) * metaScale);
  yf = (int)((y-2) * metaScale);
  SetForeground(theG.gc,theColor);
  SetFont(theDrawFont);
  XDrawString(theG.dpy,theG.d,theG.gc,xf,yf,str,strlen(str)); 
}

void ClearArcName(x,y,str)
int x, y;
char *str;
{
  int xf,yf;  

  if (str == 0) return;
  xf = (int)((x+2) * metaScale);
  yf = (int)((y-2) * metaScale);
  SetFont(theDrawFont);
  XDrawString(theG.dpy,theG.d,theG.gc_clear,xf,yf,str,strlen(str)); 
}

void HiliteArcName(x,y,str)
int x, y;
char *str;
{
  int fw,fh,xf,yf;

  if (str == 0) return;
  SetFont(theDrawFont);
  xf = (int)((x+2) * metaScale);
  yf = (int)((y-2) * metaScale);
  fw = XTextWidth(theG.drawfont,str,strlen(str));
  fh = theG.drawfont->max_bounds.ascent + theG.drawfont->max_bounds.descent;
  SetForeground(theG.gc,theColor);
  XFillRectangle(theG.dpy,theG.d,theG.gc,
		 xf-1,yf-theG.drawfont->max_bounds.ascent+1,
		 fw+2,fh);
  XDrawString(theG.dpy,theG.d,theG.gc_clear,xf,yf,str,strlen(str)); 
}

void UnhiliteArcName(x,y,str)
int x, y;
char *str;
{
  int fw,fh,xf,yf;

  if (str == 0) return;
  SetFont(theDrawFont);
  xf = (int)((x+2) * metaScale);
  yf = (int)((y-2) * metaScale);
  fw = XTextWidth(theG.drawfont,str,strlen(str));
  fh = theG.drawfont->max_bounds.ascent + theG.drawfont->max_bounds.descent;
  XFillRectangle(theG.dpy,theG.d,theG.gc_clear,
		 xf-1,yf-theG.drawfont->max_bounds.ascent+1,
		 fw+2,fh);
}

void DrawStraightArc(x0,y0,x1,y1)
int x0, y0, x1, y1;
{
  SetWidth(theG.gc,arcW);
  SetForeground(theG.gc,theColor);
  XDrawLine(theG.dpy,theG.d,theG.gc,(int)(x0*metaScale),(int)(y0*metaScale),
	    (int)(x1*metaScale),(int)(y1*metaScale));
}

void ClearStraightArc(x0,y0,x1,y1)
int x0, y0, x1, y1;
{
  SetWidth(theG.gc_clear,arcW);
  XDrawLine(theG.dpy,theG.d,theG.gc_clear,(int)(x0*metaScale),
	    (int)(y0*metaScale),
	    (int)(x1*metaScale),(int)(y1*metaScale));
}

void DrawXorStraightArc(x0,y0,x1,y1)
int x0, y0, x1, y1;
{
  SetWidth(theG.gc_xor,arcW);
  XDrawLine(theG.dpy,theG.d,theG.gc_xor,(int)(x0*metaScale),
	    (int)(y0*metaScale),
	    (int)(x1*metaScale),(int)(y1*metaScale));
}

void DrawCurvedArc(x0,y0,x2,y2,x3,y3,x1,y1)
short x0, y0, x2, y2, x3, y3, x1, y1;
{
  xBezier points[1];
  points[0].x0 = (short)(x0*metaScale);
  points[0].y0 = (short)(y0*metaScale);
  points[0].x1 = (short)(x2*metaScale);
  points[0].y1 = (short)(y2*metaScale);
  points[0].x2 = (short)(x3*metaScale);
  points[0].y2 = (short)(y3*metaScale);
  points[0].x3 = (short)(x1*metaScale);
  points[0].y3 = (short)(y1*metaScale);
  SetWidth(theG.gc,arcW);
  SetForeground(theG.gc,theColor);
  DrawBezier(theG.dpy,theG.d,theG.gc,points,1);
}

void ClearCurvedArc(x0,y0,x2,y2,x3,y3,x1,y1)
short x0, y0, x2, y2, x3, y3, x1, y1;
{
  xBezier points[1];
  points[0].x0 = (short)(x0*metaScale);
  points[0].y0 = (short)(y0*metaScale);
  points[0].x1 = (short)(x2*metaScale);
  points[0].y1 = (short)(y2*metaScale);
  points[0].x2 = (short)(x3*metaScale);
  points[0].y2 = (short)(y3*metaScale);
  points[0].x3 = (short)(x1*metaScale);
  points[0].y3 = (short)(y1*metaScale);
  SetWidth(theG.gc_clear,arcW);
  DrawBezier(theG.dpy,theG.d,theG.gc_clear,points,1);
}

void DrawXorCurvedArc(x0,y0,x2,y2,x3,y3,x1,y1)
short x0, y0, x2, y2, x3, y3, x1, y1;
{
  xBezier points[1];
  points[0].x0 = (short)(x0*metaScale);
  points[0].y0 = (short)(y0*metaScale);
  points[0].x1 = (short)(x2*metaScale);
  points[0].y1 = (short)(y2*metaScale);
  points[0].x2 = (short)(x3*metaScale);
  points[0].y2 = (short)(y3*metaScale);
  points[0].x3 = (short)(x1*metaScale);
  points[0].y3 = (short)(y1*metaScale);
  SetWidth(theG.gc_xor,arcW);
  DrawBezier(theG.dpy,theG.d,theG.gc_xor,points,1);
}

void DrawArcArrow(xa0,ya0,xa1,ya1,xa2,ya2)
short xa0, ya0, xa1, ya1, xa2, ya2;
{
  XPoint points[4];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc,arcW);
  SetForeground(theG.gc,theColor);
  XDrawLines(theG.dpy,theG.d,theG.gc,points,i,CoordModeOrigin);
}

void DrawDoubleArcArrow(xa0,ya0,xa1,ya1,xa2,ya2,xa3,ya3)
short xa0, ya0, xa1, ya1, xa2, ya2, xa3, ya3;
{
  XPoint points[5];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa3*metaScale); points[i].y = (short)(ya3*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc,arcW);
  SetForeground(theG.gc,theColor);
  XDrawLines(theG.dpy,theG.d,theG.gc,points,i,CoordModeOrigin);
}

void ClearArcArrow(xa0,ya0,xa1,ya1,xa2,ya2)
short xa0, ya0, xa1, ya1, xa2, ya2;
{
  XPoint points[4];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc_clear,arcW);
  XDrawLines(theG.dpy,theG.d,theG.gc_clear,points,i,CoordModeOrigin);
}

void ClearDoubleArcArrow(xa0,ya0,xa1,ya1,xa2,ya2,xa3,ya3)
short xa0, ya0, xa1, ya1, xa2, ya2, xa3, ya3;
{
  XPoint points[5];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa3*metaScale); points[i].y = (short)(ya3*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc_clear,arcW);
  XDrawLines(theG.dpy,theG.d,theG.gc_clear,points,i,CoordModeOrigin);
}

void DrawXorArcArrow(xa0,ya0,xa1,ya1,xa2,ya2)
short xa0, ya0, xa1, ya1, xa2, ya2;
{
  XPoint points[4];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc_xor,arcW);
  XDrawLines(theG.dpy,theG.d,theG.gc_xor,points,i,CoordModeOrigin);
}

void DrawXorDoubleArcArrow(xa0,ya0,xa1,ya1,xa2,ya2,xa3,ya3)
short xa0, ya0, xa1, ya1, xa2, ya2, xa3, ya3;
{
  XPoint points[5];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa3*metaScale); points[i].y = (short)(ya3*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc_xor,arcW);
  XDrawLines(theG.dpy,theG.d,theG.gc_xor,points,i,CoordModeOrigin);
}

void HiliteStraightArc(x0,y0,x1,y1)
int x0, y0, x1, y1;
{
  SetWidth(theG.gc,arcH);
  SetForeground(theG.gc,theColor);
  XDrawLine(theG.dpy,theG.d,theG.gc,(int)(x0*metaScale),(int)(y0*metaScale),
	    (int)(x1*metaScale),(int)(y1*metaScale));
}

void UnhiliteStraightArc(x0,y0,x1,y1)
int x0, y0, x1, y1;
{
  SetWidth(theG.gc_clear,arcH);
  XDrawLine(theG.dpy,theG.d,theG.gc_clear,(int)(x0*metaScale),
	    (int)(y0*metaScale),
	    (int)(x1*metaScale),(int)(y1*metaScale));
}


void HiliteCurvedArc(x0,y0,x2,y2,x3,y3,x1,y1)
short x0, y0, x2, y2, x3, y3, x1, y1;
{
  xBezier points[1];
  points[0].x0 = (short)(x0*metaScale);
  points[0].y0 = (short)(y0*metaScale);
  points[0].x1 = (short)(x2*metaScale);
  points[0].y1 = (short)(y2*metaScale);
  points[0].x2 = (short)(x3*metaScale);
  points[0].y2 = (short)(y3*metaScale);
  points[0].x3 = (short)(x1*metaScale);
  points[0].y3 = (short)(y1*metaScale);
  SetWidth(theG.gc,arcH);
  SetForeground(theG.gc,theColor);
  DrawBezier(theG.dpy,theG.d,theG.gc,points,1);
}

void UnhiliteCurvedArc(x0,y0,x2,y2,x3,y3,x1,y1)
short x0, y0, x2, y2, x3, y3, x1, y1;
{
  xBezier points[1];
  points[0].x0 = (short)(x0*metaScale);
  points[0].y0 = (short)(y0*metaScale);
  points[0].x1 = (short)(x2*metaScale);
  points[0].y1 = (short)(y2*metaScale);
  points[0].x2 = (short)(x3*metaScale);
  points[0].y2 = (short)(y3*metaScale);
  points[0].x3 = (short)(x1*metaScale);
  points[0].y3 = (short)(y1*metaScale);
  SetWidth(theG.gc_clear,arcH);
  DrawBezier(theG.dpy,theG.d,theG.gc_clear,points,1);
}

void HiliteArcArrow(xa0,ya0,xa1,ya1,xa2,ya2)
short xa0, ya0, xa1, ya1, xa2, ya2;
{
  XPoint points[4];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc,arcH);
  SetForeground(theG.gc,theColor);
  XDrawLines(theG.dpy,theG.d,theG.gc,points,i,CoordModeOrigin);
}

void HiliteDoubleArcArrow(xa0,ya0,xa1,ya1,xa2,ya2,xa3,ya3)
short xa0, ya0, xa1, ya1, xa2, ya2, xa3, ya3;
{
    XPoint points[5];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
    i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
    i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
    i++;
  points[i].x = (short)(xa3*metaScale); points[i].y = (short)(ya3*metaScale);
    i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
    i++;
  SetWidth(theG.gc,arcH);
  SetForeground(theG.gc,theColor);
  XDrawLines(theG.dpy,theG.d,theG.gc,points,i,CoordModeOrigin);
}

void UnhiliteArcArrow(xa0,ya0,xa1,ya1,xa2,ya2)
short xa0, ya0, xa1, ya1, xa2, ya2;
{
  XPoint points[4];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc_clear,arcH);
  XDrawLines(theG.dpy,theG.d,theG.gc_clear,points,i,CoordModeOrigin);
}

void UnhiliteDoubleArcArrow(xa0,ya0,xa1,ya1,xa2,ya2,xa3,ya3)
short xa0, ya0, xa1, ya1, xa2, ya2, xa3, ya3;
{
  XPoint points[5];
  int i = 0;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  points[i].x = (short)(xa1*metaScale); points[i].y = (short)(ya1*metaScale);
  i++;
  points[i].x = (short)(xa2*metaScale); points[i].y = (short)(ya2*metaScale);
  i++;
  points[i].x = (short)(xa3*metaScale); points[i].y = (short)(ya3*metaScale);
  i++;
  points[i].x = (short)(xa0*metaScale); points[i].y = (short)(ya0*metaScale);
  i++;
  SetWidth(theG.gc_clear,arcH);
  XDrawLines(theG.dpy,theG.d,theG.gc_clear,points,i,CoordModeOrigin);
}

/* NODE */

void DrawNodeName(x,y,str)
int x, y;
char *str;
{
  int fw,fh,xf,yf;

  if (str == 0) return;
  SetFont(theDrawFont);
  fw = XTextWidth(theG.drawfont,str,strlen(str));
  fh = theG.drawfont->max_bounds.ascent + theG.drawfont->max_bounds.descent;
  xf = (int)(metaScale*x) + 2 +((int)(metaScale*nodeDiam) - 2 - fw) / 2;
  yf = (int)(metaScale*y) + 1 + ((int)(metaScale*nodeDiam) - 2 - fh) / 2 +
      theG.drawfont->max_bounds.ascent;
  SetForeground(theG.gc,theColor);
  XDrawString(theG.dpy,theG.d,theG.gc,xf,yf,str,strlen(str)); 
}

void ClearNodeName(x,y,str)
int x, y;
char *str;
{
  int fw,fh,xf,yf;

  if (str == 0) return;
  SetFont(theDrawFont);
  fw = XTextWidth(theG.drawfont,str,strlen(str));
  fh = theG.drawfont->max_bounds.ascent + theG.drawfont->max_bounds.descent;
  xf = (int)(metaScale*x) + 2 +((int)(metaScale*nodeDiam) - 2 - fw) / 2;
  yf = (int)(metaScale*y) + 1 + ((int)(metaScale*nodeDiam) - 2 - fh) / 2 +
      theG.drawfont->max_bounds.ascent;
  XDrawString(theG.dpy,theG.d,theG.gc_clear,xf,yf,str,strlen(str));  
}

void HiliteNodeName(x,y,str)
int x, y;
char *str;
{
  int fw,fh,xf,yf;

  if (str == 0) return;
  SetFont(theDrawFont);
  fw = XTextWidth(theG.drawfont,str,strlen(str));
  fh = theG.drawfont->max_bounds.ascent + theG.drawfont->max_bounds.descent;
  xf = (int)(metaScale*x) + 2 +((int)(metaScale*nodeDiam) - 2 - fw) / 2;
  yf = (int)(metaScale*y) + 1 + ((int)(metaScale*nodeDiam) - 2 - fh) / 2 +
      theG.drawfont->max_bounds.ascent;
  SetForeground(theG.gc,theColor);
  XFillRectangle(theG.dpy,theG.d,theG.gc,
		 xf-1,yf-theG.drawfont->max_bounds.ascent+1,
		 fw+2,fh);
  XDrawString(theG.dpy,theG.d,theG.gc_clear,xf,yf,str,strlen(str));  
}

void UnhiliteNodeName(x,y,str)
int x, y;
char *str;
{
  int fw,fh,xf,yf;

  if (str == 0) return;
  fw = XTextWidth(theG.drawfont,str,strlen(str));
  fh = theG.drawfont->max_bounds.ascent + theG.drawfont->max_bounds.descent;
  xf = (int)(metaScale*x) + 2 +((int)(metaScale*nodeDiam) - 2 - fw) / 2;
  yf = (int)(metaScale*y) + 1 + ((int)(metaScale*nodeDiam) - 2 - fh) / 2 +
      theG.drawfont->max_bounds.ascent;
  XFillRectangle(theG.dpy,theG.d,theG.gc_clear,
		 xf-1,yf-theG.drawfont->max_bounds.ascent+1,
		 fw+2,fh);  
}

void DrawPlainNode(x,y,str)
int x, y;
char *str;
{
  XFillArc(theG.dpy,theG.d,theG.gc_clear,(int)(x*metaScale),(int)(y*metaScale),
	   (int)(nodeDiam*metaScale),(int)(nodeDiam*metaScale),0,360 * 64);
  SetWidth(theG.gc,nodeW);
  SetForeground(theG.gc,theColor);
  XDrawArc(theG.dpy,theG.d,theG.gc,(int)(x*metaScale),(int)(y*metaScale),
	   (int)(nodeDiam*metaScale),(int)(nodeDiam*metaScale),0,360 * 64);
  if (nodeNameDisplay) DrawNodeName(x,y,str);
}

void ClearPlainNode(x,y,str)
int x, y;
char *str;
{
  XFillArc(theG.dpy,theG.d,theG.gc_clear,(int)(x*metaScale),(int)(y*metaScale),
	   (int)(nodeDiam*metaScale),(int)(nodeDiam*metaScale),0,360 * 64);
  SetWidth(theG.gc_clear,nodeW);
  XDrawArc(theG.dpy,theG.d,theG.gc_clear,(int)(x*metaScale),(int)(y*metaScale),
	   (int)(nodeDiam*metaScale),(int)(nodeDiam*metaScale),0,360 * 64);
  if (nodeNameDisplay) ClearNodeName(x,y,str);
}

void DrawXorPlainNode(x,y)
int x, y;
{
  SetWidth(theG.gc_xor,nodeW);
  XDrawArc(theG.dpy,theG.d,theG.gc_xor,(int)(x*metaScale),(int)(y*metaScale),
	   (int)(nodeDiam*metaScale),(int)(nodeDiam*metaScale),0,360 * 64);
}

void DrawSArrow(x,y,w,h,l)
short x, y, w, h, l;
{
  XPoint points[10];
  int i = 0;
  points[i].x = (short)(x*metaScale); points[i].y = (short)(y*metaScale); i++;
  points[i].x = (short)((x + w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x + w - l)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x + l)*metaScale);
  points[i].y = (short)((y - 2 * l)*metaScale);
  i++;
  points[i].x = (short)((x + l)*metaScale);
  points[i].y = (short)((y - h)*metaScale);
  i++;
  points[i].x = (short)((x - l)*metaScale);
  points[i].y = (short)((y - h)*metaScale);
  i++;
  points[i].x = (short)((x - l)*metaScale);
  points[i].y = (short)((y - 2 * l)*metaScale);
  i++;
  points[i].x = (short)((x + l - w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x - w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)(x*metaScale); points[i].y = (short)(y*metaScale); i++;
  XFillPolygon(theG.dpy,theG.d,theG.gc_clear,points,i,
	       Nonconvex,CoordModeOrigin);  
  SetWidth(theG.gc,nodeW);
  SetForeground(theG.gc,theColor);
  XDrawLines(theG.dpy,theG.d,theG.gc,points,i,CoordModeOrigin);
}

void ClearSArrow(x,y,w,h,l)
short x, y, w, h, l;
{
  XPoint points[10];
  int i = 0;
  points[i].x = (short)(x*metaScale); points[i].y = (short)(y*metaScale); i++;
  points[i].x = (short)((x + w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x + w - l)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x + l)*metaScale);
  points[i].y = (short)((y - 2 * l)*metaScale);
  i++;
  points[i].x = (short)((x + l)*metaScale);
  points[i].y = (short)((y - h)*metaScale);
  i++;
  points[i].x = (short)((x - l)*metaScale);
  points[i].y = (short)((y - h)*metaScale);
  i++;
  points[i].x = (short)((x - l)*metaScale);
  points[i].y = (short)((y - 2 * l)*metaScale);
  i++;
  points[i].x = (short)((x + l - w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x - w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)(x*metaScale); points[i].y = (short)(y*metaScale); i++;
  XFillPolygon(theG.dpy,theG.d,theG.gc_clear,points,i,
	       Nonconvex,CoordModeOrigin);  
  SetWidth(theG.gc_clear,nodeW);
  XDrawLines(theG.dpy,theG.d,theG.gc_clear,points,i,CoordModeOrigin);
}

void DrawXorSArrow(x,y,w,h,l)
short x, y, w, h, l;
{
  XPoint points[10];
  int i = 0;
  points[i].x = (short)(x*metaScale); points[i].y = (short)(y*metaScale); i++;
  points[i].x = (short)((x + w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x + w - l)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x + l)*metaScale);
  points[i].y = (short)((y - 2 * l)*metaScale);
  i++;
  points[i].x = (short)((x + l)*metaScale);
  points[i].y = (short)((y - h)*metaScale); i++;
  points[i].x = (short)((x - l)*metaScale);
  points[i].y = (short)((y - h)*metaScale);
  i++;
  points[i].x = (short)((x - l)*metaScale);
  points[i].y = (short)((y - 2 * l)*metaScale);
  i++;
  points[i].x = (short)((x + l - w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x - w)*metaScale);
  points[i].y = (short)((y - w)*metaScale); i++;
  points[i].x = (short)(x*metaScale); points[i].y = (short)(y*metaScale); i++;
  SetWidth(theG.gc_xor,nodeW);
  XDrawLines(theG.dpy,theG.d,theG.gc_xor,points,i,CoordModeOrigin);
}

void DrawSourceArrow(x,y)
int x, y;
{
  DrawSArrow(x + nodeDiam / 2, y - 1, nodeDiam, 2 * nodeDiam,
	     nodeDiam / 3);
}

void ClearSourceArrow(x,y)
int x, y;
{
  ClearSArrow(x + nodeDiam / 2, y - 1, nodeDiam, 2 * nodeDiam,
	     nodeDiam / 3);
}

void DrawXorSourceArrow(x,y)
int x, y;
{
  DrawXorSArrow(x + nodeDiam / 2, y - 1, nodeDiam, 2 * nodeDiam,
	     nodeDiam / 3);
}

void DrawSinkArrow(x,y)
int x, y;
{
  DrawSArrow(x + nodeDiam / 2, 1 + y + 3 * nodeDiam,
	     nodeDiam, 2 * nodeDiam, nodeDiam / 3);
}

void ClearSinkArrow(x,y)
int x, y;
{
  ClearSArrow(x + nodeDiam / 2, 1 + y + 3 * nodeDiam,
	     nodeDiam, 2 * nodeDiam, nodeDiam / 3);
}

void DrawXorSinkArrow(x,y)
int x, y;
{
  DrawXorSArrow(x + nodeDiam / 2, 1 + y + 3 * nodeDiam,
	     nodeDiam, 2 * nodeDiam, nodeDiam / 3);
}

void HilitePlainNode(x,y,str)
int x, y;
char *str;
{
  SetForeground(theG.gc,theColor);
  XFillArc(theG.dpy,theG.d,theG.gc,(int)(x*metaScale),(int)(y*metaScale),
	   (int)(nodeDiam*metaScale),(int)(nodeDiam*metaScale),0,360 * 64);
  if (nodeNameDisplay) HiliteNodeName(x,y,str);
}

void UnhilitePlainNode(x,y,str)
int x, y;
char *str;
{
  if (nodeNameDisplay) UnhiliteNodeName(x,y,str);
  XFillArc(theG.dpy,theG.d,theG.gc_clear,(int)(x*metaScale),(int)(y*metaScale),
	   (int)(nodeDiam*metaScale),(int)(nodeDiam*metaScale),0,360 * 64);
  DrawPlainNode(x,y,str);
}

void HiliteSArrow(x,y,w,h,l)
short x, y, w, h, l;
{
  XPoint points[10];
  int i = 0;
  points[i].x = (short)(x*metaScale); points[i].y = (short)(y*metaScale); i++;
  points[i].x = (short)((x + w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x + w - l)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x + l)*metaScale);
  points[i].y = (short)((y - 2 * l)*metaScale);
  i++;
  points[i].x = (short)((x + l)*metaScale);
  points[i].y = (short)((y - h)*metaScale);
  i++;
  points[i].x = (short)((x - l)*metaScale);
  points[i].y = (short)((y - h)*metaScale);
  i++;
  points[i].x = (short)((x - l)*metaScale);
  points[i].y = (short)((y - 2 * l)*metaScale);
  i++;
  points[i].x = (short)((x + l - w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)((x - w)*metaScale);
  points[i].y = (short)((y - w)*metaScale);
  i++;
  points[i].x = (short)(x*metaScale); points[i].y = (short)(y*metaScale); i++;
  SetForeground(theG.gc,theColor);
  XFillPolygon(theG.dpy,theG.d,theG.gc,points,i,Nonconvex,CoordModeOrigin);
  SetWidth(theG.gc,nodeW);
  SetForeground(theG.gc,theColor);
  XDrawLines(theG.dpy,theG.d,theG.gc,points,i,CoordModeOrigin);
}

void HiliteSourceArrow(x,y)
int x, y;
{
  HiliteSArrow(x + nodeDiam / 2, y - 1, nodeDiam, 2 * nodeDiam,
	       nodeDiam / 3);
}

void UnhiliteSourceArrow(x,y)
int x, y;
{
  DrawSourceArrow(x,y);
}

void HiliteSinkArrow(x,y)
int x, y;
{
  HiliteSArrow(x + nodeDiam / 2, 1 + y + 3 * nodeDiam,
	       nodeDiam, 2 * nodeDiam, nodeDiam / 3);
}

void UnhiliteSinkArrow(x,y)
int x, y;
{
  DrawSinkArrow(x,y);
}
