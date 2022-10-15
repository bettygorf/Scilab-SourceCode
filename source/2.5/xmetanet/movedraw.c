/* Copyright INRIA */
#include <X11/StringDefs.h>
#include <X11/IntrinsicP.h>
#include <X11/Xaw/ViewportP.h>

#include "metaconst.h"
#include "metawin.h"

void SetBar(w, top, length, total)
Widget w;
Position top;
Dimension length, total;
{
  XawScrollbarSetThumb(w, (float) top / (float) total, 
		       (float) length / (float) total );
}

void RedrawThumbs(w)
ViewportWidget w;
{
  register Widget child = w->viewport.child;
  register Widget clip = w->viewport.clip;

  if (w->viewport.horiz_bar)
    SetBar( w->viewport.horiz_bar, -(child->core.x),
	   clip->core.width, child->core.width );

  if (w->viewport.vert_bar)
    SetBar( w->viewport.vert_bar, -(child->core.y),
	   clip->core.height, child->core.height );
}

void MoveChild(w, x, y)
ViewportWidget w;
Position x, y;
{
  register Widget child = w->viewport.child;
  register Widget clip = w->viewport.clip;

  /* make sure we never move past right/bottom borders */
  if ((int) (x + clip->core.width) > (int) child->core.width)
    x = child->core.width - clip->core.width;

  if ((int) (y + clip->core.height) > (int ) child->core.height)
    y = child->core.height - clip->core.height;

  /* make sure we never move past left/top borders */
  if (x < 0) x = 0;
  if (y < 0) y = 0;

  XtMoveWidget(child, - x, - y);

  RedrawThumbs(w);
}

void GetDrawGeometry(x,y,w,h)
int *x,*y,*w,*h;
{
  ViewportWidget vw;
  register Widget child;
  register Widget clip;
  Arg arglist[2];
  Position dx,dy;

  vw = (ViewportWidget)drawViewport;
  child = vw->viewport.child;
  clip = vw->viewport.clip;

  arglist[0].name = XtNx;
  arglist[0].value = (XtArgVal)&dx;
  arglist[1].name = XtNy;
  arglist[1].value = (XtArgVal)&dy;
  XtGetValues(child,arglist,2);
  
  *x = - dx;
  *y = - dy;
  *w = clip->core.width;
  *h = clip->core.height;
}

void CenterDraw(x,y)
int x, y;
{
  int dx,dy,w,h;
  
  GetDrawGeometry(&dx,&dy,&w,&h);
  MoveChild((ViewportWidget)drawViewport,
	    (int)(metaScale*x) - w/2,(int)(metaScale*y) - h/2);
}
