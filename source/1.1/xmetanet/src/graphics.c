#include <X11/Intrinsic.h>
#include <math.h>
#include <malloc.h>
#include <string.h>
#include <stdio.h>

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "color.h"
#include "menus.h"
#include "metio.h"
#include "graphics.h"

extern void ClearArcArrow();
extern void ClearArcName();
extern void ClearCurvedArc();
extern void ClearDoubleArcArrow();
extern void ClearDraw();
extern void ClearPlainNode();
extern void ClearSinkArrow();
extern void ClearSourceArrow();
extern void ClearStraightArc();
extern void DrawArcArrow();
extern void DrawArcName();
extern void DrawCurvedArc();
extern void DrawDoubleArcArrow();
extern void DrawPlainNode();
extern void DrawSinkArrow();
extern void DrawSourceArrow();
extern void DrawStraightArc();
extern void DrawXorCurvedArc();
extern void DrawXorPlainNode();
extern void DrawXorSinkArrow();
extern void DrawXorSourceArrow();
extern void DrawXorStraightArc();
extern void GetDrawGeometry();
extern void HiliteArcArrow();
extern void HiliteArcName();
extern void HiliteCurvedArc();
extern void HiliteDoubleArcArrow();
extern void HilitePlainNode();
extern void HiliteSinkArrow();
extern void HiliteSourceArrow();
extern void HiliteStraightArc();
extern void UnhiliteArcArrow();
extern void UnhiliteArcName();
extern void UnhiliteCurvedArc();
extern void UnhiliteDoubleArcArrow();
extern void UnhilitePlainNode();
extern void UnhiliteSinkArrow();
extern void UnhiliteSourceArrow();
extern void UnhiliteStraightArc();

#define min(a,b) ((a) <= (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))
#define signum(a) ((a) > (0) ? (1) : (-1))

void ActivateWhenPressArc();
void ActivateWhenPressNode();
void DrawMovingArc();
void DrawMovingNode();
void EraseMovingArc();
void EraseMovingNode();
void MoveNode();
int PointerInArc();
int PointerInNode();
void SetCoordinatesArc();
void UnhiliteActive();

static int isHilite = 0;

void ExposeBegin()
{
}

void ExposeStudy()
{
  DrawGraph(theGraph);
}

void ExposeModify()
{
  ClearDraw();
  DrawGraph(theGraph);
}

type_id PointerInObject(x,y,object)
int x,y;
ptr *object;
{
  if (PointerInNode(x,y,object)) return NODE;
  else if (PointerInArc(x,y,object)) return ARC;
  else return 0;
}

void WhenPress(x,y)
int x,y;
{
  ptr object = 0;
  type_id t;
  t = PointerInObject(x,y,&object);
  if (t != 0)
    switch (t) {
    case ARC:
      ActivateWhenPressArc((arc*)object);
      break;
    case NODE:
      ActivateWhenPressNode((node*)object);
      break;
    }
  else {
    ReDrawGraph(theGraph);
  }
}

void StopMoving(x,y)
int x,y; 
{
  int w, h;
  mylink *p;
  arc *ca, *a;
  w = drawWidth;
  h = drawHeight;
  if (x > w - (int)(metaScale*nodeDiam)/2) x = w - (int)(metaScale*nodeDiam)/2;
  if (x < (int)(metaScale*nodeDiam)/2) x = (int)(metaScale*nodeDiam)/2;
  if (y > h - (int)(metaScale*nodeDiam)/2) y = h - (int)(metaScale*nodeDiam)/2;
  if (y < (int)(metaScale*nodeDiam)/2) y = (int)(metaScale*nodeDiam)/2;
  MoveNode(x,y,theGG.moving);
  p = theGG.moving->connected_arcs->first;
  while (p) {
    ca = (arc*)(p->element);
    if (theGraph->directed || (ca->number % 2 != 0)) {
      /* the graph is directed or the graph is undirected and arc number
	 is odd */
      a = (arc*)(p->element);
      EraseMovingArc(a);
      SetCoordinatesArc(a);
      DrawArc(a);
      DrawNode(a->tail);
      DrawNode(a->head);
    }
    p = p->next;
  }
  p = theGG.moving->loop_arcs->first;
  while (p) {
    ca = (arc*)(p->element);
    if (theGraph->directed || (ca->number % 2 != 0)) {
      /* the graph is directed or the graph is undirected and arc number
	 is odd */
      a = (arc*)(p->element);
      EraseMovingArc(a);
      SetCoordinatesArc(a);
      DrawArc(a);
      DrawNode(a->tail);
      DrawNode(a->head);
    }
    p = p->next;
  }
  theGG.moving = 0;
}  

void WhenRelease(x,y)
int x,y;
{
  ptr object = 0;
  if (isHilite == 1) isHilite = 0;
  else {
    if (menuId == MODIFY)
      {
	if (theGG.moving != 0) StopMoving(x,y);
	else {
	  if (!PointerInObject(x,y,&object)) {
	    DrawNode(AddNode((int)((double)x/metaScale),
			     (int)((double)y/metaScale),theGraph));
	    theGG.modified = 1;
	  }
	}
      }
  }
}

void WhenDownMove(x,y)
int x,y;
{
  node *n;
  arc *a;
  mylink *p;
  int w, h;
  if (theGG.moving == 0 && theGG.active_type == NODE) {
    /* there is no moving object and the active object is a node. it
       becomes the moving node */
    n = (node*)theGG.active;
    theGG.active = 0;
    theGG.active_type = 0;
    theGG.moving = n;
    UnhiliteNode(n);
    EraseNode(n);
    theGG.modified = 1;
    p = n->connected_arcs->first;
    while (p) {
      a = (arc*)(p->element);
      if (theGraph->directed || (a->number % 2 != 0))
	EraseArc(a);
      p = p->next;
    }
    p = n->connected_arcs->first;
    while (p) {
      a = (arc*)(p->element);
      if (theGraph->directed || (a->number % 2 != 0))
	DrawMovingArc(a);
      p = p->next;
    }
    p = n->loop_arcs->first;
    while (p) {
      a = (arc*)(p->element);
      if (theGraph->directed || (a->number % 2 != 0))
	EraseArc(a);
      p = p->next;
    }
    p = n->loop_arcs->first;
    while (p) {
      a = (arc*)(p->element);
      if (theGraph->directed || (a->number % 2 != 0))
	DrawMovingArc(a);
      p = p->next;
    }
    DrawMovingNode(n);
  }
  else if (theGG.moving != 0) {
    /* there is a moving node : move it */
    w = drawWidth;
    h = drawHeight;
    if (x > w - (int)(metaScale*nodeDiam)/2) x = w - 
      (int)(metaScale*nodeDiam)/2;
    if (x < (int)(metaScale*nodeDiam)/2) x = (int)(metaScale*nodeDiam)/2;
    if (y > h - (int)(metaScale*nodeDiam)/2) y = h - 
      (int)(metaScale*nodeDiam)/2;
    if (y < (int)(metaScale*nodeDiam)/2) y = (int)(metaScale*nodeDiam)/2;
    MoveNode(x,y,theGG.moving);
  }
}

/* GRAPH */

void DrawGraph(g)
graph *g;
{
  mylink *p;
  int dx, dy, w, h;
  int dxw, dx1, dy1, dyh;
  arc *a;
  node *ta, *he, *n;
  GetDrawGeometry(&dx,&dy,&w,&h);
  dxw = dx + w; dyh = dy + h;
  dx1 = dx - (int)(metaScale*nodeDiam);
  dy1 = dy - (int)(metaScale*nodeDiam);
  p = g->arcs->first;
  while (p) {
    a = (arc*)(p->element);
    if (g->directed || (a->number % 2 != 0)) {
      /* the graph is directed or the graph is undirected and arc number
	 is odd */
      ta = (node*)(a->tail); he = (node*)(a->head);
      /* draw arc if it is visible */
      if ((int)(metaScale*ta->x) >= dx1 && (int)(metaScale*ta->x) <= dxw &&
	  (int)(metaScale*ta->y) >= dy1 && (int)(metaScale*ta->y) <= dyh)
	DrawArc(a);
      else if ((int)(metaScale*he->x) >= dx1 && 
	       (int)(metaScale*he->x) <= dxw &&
	       (int)(metaScale*he->y) >= dy1 && (int)(metaScale*he->y) <= dyh)
	DrawArc(a);
    }
    p = p->next;
  }
  p = g->nodes->first;
  while (p) {
    n = (node*)(p->element);
    /* draw node if it is visible */
    if ((int)(metaScale*n->x) >= dx1 && (int)(metaScale*n->x) <= dxw &&
	(int)(metaScale*n->y) >= dy1 && (int)(metaScale*n->y) <= dyh)
      DrawNode(n);
    p = p->next;
  }
}

void ReDrawGraph(g)
graph *g;
{
  mylink *p;
  int dx, dy, w, h;
  int dxw, dyh, dx1, dy1;
  arc *a;
  node *ta, *he, *n;
  GetDrawGeometry(&dx,&dy,&w,&h);
  dxw = dx + w; dyh = dy + h;
  dx1 = dx - (int)(metaScale*nodeDiam);
  dy1 = dy - (int)(metaScale*nodeDiam);
  p = g->arcs->first;
  while (p) {
    a = (arc*)(p->element);
    if (g->directed || (a->number % 2 != 0)) {
      /* the graph is directed or the graph is undirected and arc number
	 is odd */
      ta = (node*)(a->tail); he = (node*)(a->head);
      /* draw arc if it is visible */
      if ((int)(metaScale*ta->x) >= dx1 && (int)(metaScale*ta->x) <= dxw &&
	  (int)(metaScale*ta->y) >= dy1 && (int)(metaScale*ta->y) <= dyh) {
	if (a->hilited == 1) UnhiliteArc(a);
	DrawArc(a);
      }
      else if ((int)(metaScale*he->x) >= dx1 && (int)(metaScale*he->x) <= dxw 
	       && (int)(metaScale*he->y) >= dy1
	       && (int)(metaScale*he->y) <= dyh) {
	if (a->hilited == 1) UnhiliteArc(a);
	DrawArc(a);
      }
      if (a->hilited == 1) {
	a->hilited = 0;
	isHilite = 1;
      }
    }
    p = p->next;
  }
  p = g->nodes->first;
  while (p) {
    n = (node*)(p->element);
    /* draw node if it is visible */
    if ((int)(metaScale*n->x) >= dx1 && (int)(metaScale*n->x) <= dxw &&
	(int)(metaScale*n->y) >= dy1 && (int)(metaScale*n->y) <= dyh) {
      if (n->hilited == 1) UnhiliteNode(n);
      DrawNode(n);
    }
    if (n->hilited == 1) {
      n->hilited = 0;
      isHilite = 1;
    }
    p = p->next;
  }
  theGG.active = 0;
  theGG.active_type = 0;
}

/* ARC */

int PointerInSegment(x, y, x00, y00, x11, y11)
int x, y, x00, y00, x11, y11;
{
  int prec = 3 * metaScale;
  int x0, y0, x1, y1;
  double delta, c, v;
  x0 = (int)(metaScale*x00);
  y0 = (int)(metaScale*y00);
  x1 = (int)(metaScale*x11);
  y1 = (int)(metaScale*y11);
  /* precision of prec for (x,y) in segment (x0,y0)  (x1,y1) */
  delta = prec *
    sqrt((double)((x1 - x0)*(x1 - x0) + (y1 - y0)*(y1 - y0)));
  c = x0 * y1 - x1 * y0;
  v = x * (y1 - y0) - y * (x1 - x0);
  /* (x,y) is at most at distance delta near the segment */
  if((c - delta < v) && (v < c + delta)) {
    /* (x,y) is in the rectangle with the segment as diagonal */
    if (x0 == x1 || ((min(x0,x1) <= x) && (x <= max(x0,x1))))
      if (y0 == y1 || ((min(y0,y1) <= y) && (y <= max(y0,y1))))
	return 1;
  }
  return 0;
} 

int PointerInArcArrow(x, y, a)
int x, y;
arc *a;
{
  int prec = 5;
  double l;
  int xx0, yy0, xx1, yy1;
  l = sqrt((double)((a->x1 - a->x0)*(a->x1 - a->x0) + 
		    (a->y1 - a->y0)*(a->y1 - a->y0)));
  xx0 = a->xmax - (int)(prec * (a->x1 - a->x0) / l);
  yy0 = a->ymax - (int)(prec * (a->y1 - a->y0) / l);
  xx1 = a->xmax + (int)(prec * (a->x1 - a->x0) / l);
  yy1 = a->ymax + (int)(prec * (a->y1 - a->y0) / l);
  return PointerInSegment(x,y,xx0,yy0,xx1,yy1);
}

int PointerInArc(x, y, object)
int x, y;
ptr *object;
{
  arc *a;
  mylink *p;

  if(theGraph->arcs->first == 0) return 0;
  p = theGraph->arcs->first;
  while(p) {
    a = (arc*)(p->element);
    if (theGraph->directed || (a->number % 2 != 0))
      if (PointerInArcArrow(x,y,a)) {
	*object = p->element;
	return 1;
      }
    p = p->next;
  }
  return 0;
} 

void ActivateWhenPressArc(a)
arc *a;
{
  if (theGG.active == 0) {
    /* there is no active object : this arc is hilited and
       becomes active */
    ReDrawGraph(theGraph);
    HiliteArc(a);
    theGG.active_type = ARC;
    theGG.active = (ptr)a;
  }
  else if (theGG.active_type == ARC && theGG.active == (ptr)a) {
    /* the active object is this arc : unhilite it and there is
       no longer an active object */
    UnhiliteArc(a);
    theGG.active = 0;
    theGG.active_type = 0;
  }
  else {
    /* otherwise the old active object is unhilited and this arc is
       hilited and becomes active */
    
    UnhiliteActive();
    HiliteArc(a);
    theGG.active_type = ARC;
    theGG.active = (ptr)a;
  }
}

void SetArrowCoordinatesArc(a)
arc *a;
{
  double d, xn, yn, xx, yy;
  d = sqrt((double)((a->x1 - a->x0)*(a->x1 - a->x0) + 
		  (a->y1 - a->y0)*(a->y1 - a->y0)));
  xn = (a->y0 - a->y1) / d;
  yn = (a->x1 - a->x0) / d;
  xx = yn;
  yy = - xn;
  a->xa0 = a->xmax + (int)(arrowWidth * xn);
  a->ya0 = a->ymax + (int)(arrowWidth * yn);
  a->xa2 = a->xmax - (int)(arrowWidth * xn);
  a->ya2 = a->ymax - (int)(arrowWidth * yn);
  a->xa1 = a->xmax + (int)(arrowLength * xx);
  a->ya1 = a->ymax + (int)(arrowLength * yy);
  if (!theGraph->directed) {
    a->xa3 = a->xmax - (int)(arrowLength * xx);
    a->ya3 = a->ymax - (int)(arrowLength * yy);
  }
}

void SetCoordinatesArc(a)
arc *a;
{
  int direction, x00, y00, x11, y11, r;
  double l, co, si;
  double ry, dbx2, dby2, dbx3, dby3, dxmax, dymax;
  double i0, inc;

  direction = (a->head->number > a->tail->number) ? a->g_type : - a->g_type;
  /* (x00,y00) and (x11,y11) are the center of the head and tail nodes */
  x00 = a->tail->x + nodeDiam / 2;
  y00 = a->tail->y + nodeDiam / 2;
  x11 = a->head->x + nodeDiam / 2;
  y11 = a->head->y + nodeDiam / 2;
  /* (x0,y0) and (x1,y1) are the ends of the segment used to draw
     this arc */
  if (a->g_type >= LOOP) {
    a->x0 = x00 + nodeDiam / 2;
    a->y0 = y00;
    a->x1 = x00;
    a->y1 = y00 - nodeDiam / 2;

    i0 = nodeDiam;
    inc = (a->g_type - LOOP) * nodeDiam / 2;
    a->x2 = x00 + (i0 + inc) * 1.414;
    a->y2 = a->y0;
    a->x3 = a->x1;
    a->y3 = y00 - (i0 + inc) * 1.414;
    a->xmax = x00 + nodeDiam / 8 + 3 * (i0 + inc) / 1.414 / 4;
    a->ymax = y00 - (nodeDiam / 8 + 3 * (i0 + inc) / 1.414 / 4);
  }
  else {
    l = sqrt((double)((x11 - x00)*(x11 - x00) + (y11 - y00)*(y11 - y00)));
    co = (x11 - x00) / l;
    si = (y00 - y11) / l;
    r = nodeDiam / 2;
    a->x0 = x00 + (int)(r * co);
    a->y0 = y00 - (int)(r * si);
    a->x1 = x11 - (int)(r * co);
    a->y1 = y11 + (int)(r * si);
    if (direction == 0) {
      a->xmax = (a->x0 + a->x1) / 2;
      a->ymax = (a->y0 + a->y1) / 2;
    }
    else {
      l = sqrt((double)((a->x1 - a->x0)*(a->x1 - a->x0) + 
			(a->y1 - a->y0)*(a->y1 - a->y0)));
      ry = (4 * bezierDy * abs(direction)) / (3 * l);
      dbx2 = l * bezierRx;
      dby2 = l * ry * signum(direction);
      dbx3 = l * (1 - bezierRx);
      dby3 = dby2;
      dxmax = l / 2;
      dymax = 0.75 * l * ry * signum(direction);
      a->x2 = a->x0 + (int)(dbx2 * co - dby2 * si);
      a->y2 = a->y0 - (int)(dbx2 * si + dby2 * co);
      a->x3 = a->x0 + (int)(dbx3 * co - dby3 * si);
      a->y3 = a->y0 - (int)(dbx3 * si + dby3 * co);
      a->xmax = a->x0 + (int)(dxmax * co - dymax * si);
      a->ymax = a->y0 - (int)(dxmax * si + dymax * co);
    }
  }
  SetArrowCoordinatesArc(a);
}

void DrawArc(a)
arc *a;
{
  char str[MAXNAM];
  theColor = Colors[a->col];
  if (a->hilited == 1) HiliteArc(a);
  else {
    if (a->g_type == 0)
      DrawStraightArc(a->x0,a->y0,a->x1,a->y1);
    else
      DrawCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
    if (theGraph->directed)
      DrawArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2);
    else
      DrawDoubleArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2,a->xa3,
			 a->ya3);
    if (intDisplay) sprintf(str,"%d",EdgeNumberOfArc(a,theGraph));
    else {if (a->name == 0) str[0] = 0; else strcpy(str,a->name);}
    if (arcNameDisplay) DrawArcName(a->xmax,a->ymax,str);
  }
}

void DrawMovingArc(a)
arc *a;
{
  if (a->g_type == 0)
    DrawXorStraightArc(a->x0,a->y0,a->x1,a->y1);
  else
    DrawXorCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
}

void EraseArc(a)
arc *a;
{
  char str[MAXNAM];
  if (a->g_type == 0)
    ClearStraightArc(a->x0,a->y0,a->x1,a->y1);
  else
    ClearCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  if (theGraph->directed)
    ClearArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2);
  else
    ClearDoubleArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2,a->xa3,
			a->ya3);
  if (intDisplay) sprintf(str,"%d",EdgeNumberOfArc(a,theGraph));  
  else {if (a->name == 0) str[0] = 0; else strcpy(str,a->name);}
  if (arcNameDisplay) ClearArcName(a->xmax,a->ymax,str);
}

void EraseMovingArc(a)
arc *a;
{
  if (a->g_type == 0)
    DrawXorStraightArc(a->x0,a->y0,a->x1,a->y1);
  else
    DrawXorCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
}

void HiliteArc(a)
arc *a;
{
  char str[MAXNAM];
  EraseArc(a);
  a->hilited = 1;
  theColor = Colors[a->col];
  if (a->g_type == 0)
    HiliteStraightArc(a->x0,a->y0,a->x1,a->y1);
  else
    HiliteCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  if (theGraph->directed)
    HiliteArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2);
  else
    HiliteDoubleArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2,a->xa3,
			 a->ya3);
  if (intDisplay) sprintf(str,"%d",EdgeNumberOfArc(a,theGraph));    
  else {if (a->name == 0) str[0] = 0; else strcpy(str,a->name);}
  if (arcNameDisplay) HiliteArcName(a->xmax,a->ymax,str);
  DrawNode(a->tail);
  DrawNode(a->head);
}

void UnhiliteArc(a)
arc *a;
{  
  char str[MAXNAM];
  a->hilited = 0;
  if (intDisplay) sprintf(str,"%d",EdgeNumberOfArc(a,theGraph));
  else {if (a->name == 0) str[0] = 0; else strcpy(str,a->name);}
if (arcNameDisplay) UnhiliteArcName(a->xmax,a->ymax,str);
  if (a->g_type == 0)
    UnhiliteStraightArc(a->x0,a->y0,a->x1,a->y1);
  else
    UnhiliteCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  if (theGraph->directed)
    UnhiliteArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2);
  else
    UnhiliteDoubleArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2,a->xa3,
			   a->ya3);    
  DrawArc(a);
  DrawNode(a->tail);
  DrawNode(a->head);
}

/* NODE */

int PointerInNode(x, y, object)
int x, y;
ptr *object;
{
  node *n;
  int x0, y0, r;
  mylink *p;

  if (theGraph->nodes->first == 0) return 0;
  p = theGraph->nodes->first;
  while(p) {
    n = (node*)(p->element);
    x0 = (int)(metaScale*(n->x + nodeDiam / 2));
    y0 = (int)(metaScale*(n->y + nodeDiam / 2));
    r = (int)(metaScale * nodeDiam / 2);
    if ((x - x0)*(x - x0) + (y - y0)*(y - y0) < r * r) {
      *object = p->element;
      return 1;
    }
    p = p->next;
  }
  return 0;
} 

void ActivateWhenPressNode(n)
node *n;
{
  arc *a;
  if (theGG.active == 0) {
    /* there is no active object : this node is highlighted and
       becomes active */
    ReDrawGraph(theGraph);
    HiliteNode(n);
    theGG.active_type = NODE;
    theGG.active = (ptr)n;
  }
  else if (theGG.active_type == ARC) {
    /* there is an active arc: the old active object is unhilited,
       this node is hilited and becomes active */
    UnhiliteActive();
    HiliteNode(n);
    theGG.active_type = NODE;
    theGG.active = (ptr)n;
  }
  else if (theGG.active == (ptr)n) {
    /* the active node is this node : unhilite it and there is no
     longer an active object */
    UnhiliteNode(n);
    theGG.active = 0;
    theGG.active_type = 0;
  }
  else {
    /* otherwise there is  already an active node : unhilite it */
    UnhiliteActive();
    if (menuId == MODIFY) {
      /* we are in modify menu : draw a new arc from the old active node
	 to this node and there is no longer an active object */
      a = AddArc((node*)(theGG.active),n,theGraph);
      DrawArc(a);
      DrawNode(a->tail);
      DrawNode(a->head);
      theGG.modified = 1;
      theGG.active = 0;
      theGG.active_type = 0;
    }
    else if (menuId == STUDY) {
      /* we are in study menu : this node is highlighted and
	 becomes active */
      ReDrawGraph(theGraph);
      HiliteNode(n);
      theGG.active_type = NODE;
      theGG.active = (ptr)n;
    }
  }
}

void MoveNode(nx, ny, n)
int nx, ny;
node *n;
{
  mylink *p;
  arc *a;

  EraseMovingNode(n);
  n->x = (int)((double)(nx - (int)(metaScale*nodeDiam) / 2)/metaScale);
  n->y = (int)((double)(ny - (int)(metaScale*nodeDiam) / 2)/metaScale);
  /* move arcs */
  p = n->connected_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    if (theGraph->directed || (a->number % 2 != 0)) {
      /* the graph is directed or the graph is undirected and arc number
	 is odd */
      EraseMovingArc(a);
      SetCoordinatesArc(a);
      DrawMovingArc(a);
    }
    p = p->next;
  }
  p = n->loop_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    if (theGraph->directed || (a->number % 2 != 0)) {
      /* the graph is directed or the graph is undirected and arc number
	 is odd */
      EraseMovingArc(a);
      SetCoordinatesArc(a);
      DrawMovingArc(a);
    }
    p = p->next;
  }
  /* move node */
  DrawMovingNode(n);
}

void DrawNode(n)
node *n;
{
  char str[MAXNAM];
  theColor = Colors[n->col];
  if (n->hilited == 1) HiliteNode(n);
  else {
    if (intDisplay) sprintf(str,"%d",n->number);
    else {if (n->name == 0) str[0] = 0; else strcpy(str,n->name);}
    switch (n->type) {
    case PLAIN:
      DrawPlainNode(n->x,n->y,str);
      break;
    case SINK:
      DrawPlainNode(n->x,n->y,str);
      DrawSinkArrow(n->x,n->y);
      break;
    case SOURCE:
      DrawPlainNode(n->x,n->y,str);
      DrawSourceArrow(n->x,n->y);
      break;
    }
  }
}

void DrawMovingNode(n)
node *n;
{
  switch (n->type) {
  case PLAIN:
    DrawXorPlainNode(n->x,n->y);
    break;
  case SINK:
    DrawXorPlainNode(n->x,n->y);
    DrawXorSinkArrow(n->x,n->y);
    break;
  case SOURCE:
    DrawXorPlainNode(n->x,n->y);
    DrawXorSourceArrow(n->x,n->y);
    break;
  }
}

void EraseNode(n)
node *n;
{
  char str[MAXNAM];
  if (intDisplay) sprintf(str,"%d",n->number);
  else {if (n->name == 0) str[0] = 0; else strcpy(str,n->name);}
  switch (n->type) {
  case PLAIN:
    ClearPlainNode(n->x,n->y,str);
    break;
  case SINK:
    ClearPlainNode(n->x,n->y,str);
    ClearSinkArrow(n->x,n->y);
    break;
  case SOURCE:
    ClearPlainNode(n->x,n->y,str);
    ClearSourceArrow(n->x,n->y);
    break;
  }
}

void EraseMovingNode(n)
node *n;
{
  switch (n->type) {
  case PLAIN:
    DrawXorPlainNode(n->x,n->y);
    break;
  case SINK:
    DrawXorPlainNode(n->x,n->y);
    DrawXorSinkArrow(n->x,n->y);
    break;
  case SOURCE:
    DrawXorPlainNode(n->x,n->y);
    DrawXorSourceArrow(n->x,n->y);
    break;
  }
}

void HiliteNode(n)
node *n;
{
  char str[MAXNAM];  
  theColor = Colors[n->col];
  n->hilited = 1;
  if (intDisplay) sprintf(str,"%d",n->number);
  else {if (n->name == 0) str[0] = 0; else strcpy(str,n->name);}
  switch (n->type) {
  case PLAIN:
    HilitePlainNode(n->x,n->y,str);
    break;
  case SINK:
    HilitePlainNode(n->x,n->y,str);
    HiliteSinkArrow(n->x,n->y);
    break;
  case SOURCE:
    HilitePlainNode(n->x,n->y,str);
    HiliteSourceArrow(n->x,n->y);
    break;
  }
}

void UnhiliteNode(n)
node *n;
{
  char str[MAXNAM];
  n->hilited = 0;
  if (intDisplay) sprintf(str,"%d",n->number);
  else {if (n->name == 0) str[0] = 0; else strcpy(str,n->name);}
  switch (n->type) {
  case PLAIN:
    UnhilitePlainNode(n->x,n->y,str);
    break;
  case SINK:
    UnhilitePlainNode(n->x,n->y,str);
    UnhiliteSinkArrow(n->x,n->y);
    break;
  case SOURCE:
    UnhilitePlainNode(n->x,n->y,str);
    UnhiliteSourceArrow(n->x,n->y);
    break;
  }
}

void CreateLoop()
{
  node *n; arc *a;

  if (theGG.active != 0 && theGG.active_type == NODE) {
    n = (node*)theGG.active;
    a = AddArc(n,n,theGraph);
    DrawArc(a);
    DrawNode(a->tail);
    DrawNode(a->head);
    theGG.modified = 1;
    theGG.active = 0;
    theGG.active_type = 0;
    UnhiliteNode(n);
  }
}

void CreateSource()
{
  node *n;

  if (theGG.active != 0 && theGG.active_type == NODE) {
    n = (node*)theGG.active;
    if (n->type != SOURCE) {
      if (n->type == SINK) {
	/* node was a sink, remove it from graph */
	theGraph->sink_number--;
	RemoveListElement((ptr)n,theGraph->sinks);
      }
      /* add new source to graph */
      theGraph->source_number++;
      AddListElement((ptr)n,theGraph->sources);
      /* draw new source */
      UnhiliteNode(n);
      EraseNode(n);
      n->type = SOURCE;
      DrawNode(n);
      theGG.active = 0;
      theGG.active_type = 0;
    }
  }
}

void CreateSink()
{
  node *n;
  if (theGG.active != 0 && theGG.active_type == NODE) {
    n = (node*)theGG.active;
    if (n->type != SINK) {
      if (n->type == SOURCE) {
	/* node was a source, remove it from graph */
	theGraph->source_number--;
	RemoveListElement((ptr)n,theGraph->sources);
      }
      /* add new sink to graph */
      theGraph->sink_number++;
      AddListElement((ptr)n,theGraph->sinks);
      /* draw new sink */
      UnhiliteNode(n);
      EraseNode(n);
      n->type = SINK;
      DrawNode(n);
      theGG.active = 0;
      theGG.active_type = 0;
    }
  }
}

void RemoveSourceSink()
{
  node *n;

  if (theGG.active != 0 && theGG.active_type == NODE) {
    n = (node*)theGG.active;
    switch (n->type) {
    case SOURCE:
      /* node was a source, remove it from graph */
      theGraph->source_number--;
      RemoveListElement((ptr)n,theGraph->sources);
      break;
    case SINK:
      /* node was a sink, remove it from graph */
      theGraph->sink_number--;
      RemoveListElement((ptr)n,theGraph->sinks);
      break;
    default:
      return;
    }
    /* draw new node */
    UnhiliteNode(n);
    EraseNode(n);
    n->type = PLAIN;
    DrawNode(n);
    theGG.active = 0;
    theGG.active_type = 0;
  }
}

void Graphics()
{
  char *label = "Graphic attributes";
  char *init[1];
  char *result[1];
  char *description[1];
  char str[64];
  float d;
  double smetaScale;
  int i = 0;

  sprintf(str,"%g",metaScale);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1) * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Scale : ";
  i++;

  if (MetanetDialogs(i,init,result,description,label)) {
    i = 0;
    smetaScale = metaScale;
    sscanf(result[i],"%g",&d);
    metaScale = (double)d; i++;
    if (metaScale < 0) metaScale = smetaScale;
    ClearDraw();
  }
  ReDrawGraph(theGraph);
}

void UnhiliteActive()
{
  if (theGG.active != 0) {
    switch (theGG.active_type) {
    case ARC:
      UnhiliteArc((arc*)theGG.active);
      break;
    case NODE:
      UnhiliteNode((node*)theGG.active);
      break;
    }
  }
}  
