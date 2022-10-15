/* Copyright INRIA */
#include <X11/Intrinsic.h>

#include "bezier.h"

#define MAX(a,b) ((a) > (b) ? (a) : (b)) 
#define MIN(a,b) ((a) < (b) ? (a) : (b)) 
#define FIXED(a) (((int) (a)) << 16)
#define INT(a) (((a) + (1 << 15)) >> 16 )

static short *pointptr;
static int npoint;

/*
 * bez: Subdivide a Bezier spline, until it is thin enough to be
 *      considered a line. Store line point in static array points.
*/

int bez(x0, y0, x1, y1, x2, y2, x3, y3)
int x0, y0, x1, y1, x2, y2, x3, y3;
{
  int maxx,minx,maxy,miny;         
  /* find bounding box of 4 control points */
  maxx = x0;
  maxx = MAX(maxx, x1);
  maxx = MAX(maxx, x2);
  maxx = MAX(maxx, x3);
  
  maxy = y0;
  maxy = MAX(maxy, y1);
  maxy = MAX(maxy, y2);
  maxy = MAX(maxy, y3);

  minx = x0;
  minx = MIN(minx, x1);
  minx = MIN(minx, x2);
  minx = MIN(minx, x3);

  miny = y0;
  miny = MIN(miny, y1);
  miny = MIN(miny, y2);
  miny = MIN(miny, y3);
  
  if (((maxx - minx) < FIXED(2)) || ((maxy - miny) < FIXED(2))) { 
    /* Consider it a line segment */
    npoint++;             
    *pointptr++ = INT(x3);
    *pointptr++ = INT(y3);
  }
  else {
    register int tempx, tempy;
    /* Subdivide into 2 new beziers */
    tempx = (x0 >> 3) + 3 * (x1 >> 3) + 3 * (x2 >> 3) + (x3 >> 3);
    tempy = (y0 >> 3) + 3 * (y1 >> 3) + 3 * (y2 >> 3) + (y3 >> 3);
    bez(x0, y0,
	(x0 >> 1) + (x1 >> 1), (y0 >> 1) + (y1 >> 1),
	(x0 >> 2) + (x1 >> 1) + (x2 >> 2),
	(y0 >> 2) + (y1 >> 1) + (y2 >> 2),
	tempx, tempy);
    bez(tempx, tempy,
	(x3 >> 2) + (x2 >> 1) + (x1 >> 2),
	(y3 >> 2) + (y2 >> 1) + (y1 >> 2),
	(x3 >> 1) + (x2 >> 1), (y3 >> 1) + (y2 >> 1),
	x3, y3);
  }
}

void DrawBezier(dpy, d, gc, bpoints)
Display *dpy; 
Drawable d;
GC gc;
xBezier *bpoints;
{
  short points[2000];  
  npoint = 1;
  pointptr = points;
  *pointptr++ = bpoints->x0;
  *pointptr++ = bpoints->y0;    
  bez(FIXED(bpoints->x0),FIXED(bpoints->y0),FIXED(bpoints->x1),
      FIXED(bpoints->y1),FIXED(bpoints->x2),FIXED(bpoints->y2),
      FIXED(bpoints->x3),FIXED(bpoints->y3));
  XDrawLines(dpy,d,gc,(XPoint*)points,npoint,CoordModeOrigin);
}
