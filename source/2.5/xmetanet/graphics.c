/* Copyright INRIA */
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
#include "font.h"

extern void ClearArcArrow();
extern void ClearArcName();
extern void ClearCurvedArc();
extern void ClearDraw();
extern void ClearLoopArc();
extern void ClearPlainNode();
extern void ClearSinkArrow();
extern void ClearSourceArrow();
extern void ClearStraightArc();
extern void DrawArcArrow();
extern void DrawArcName();
extern void DrawCurvedArc();
extern void DrawLoopArc();
extern void DrawPlainNode();
extern void DrawSinkArrow();
extern void DrawSourceArrow();
extern void DrawStraightArc();
extern void DrawXorCurvedArc();
extern void DrawXorLoopArc();
extern void DrawXorPlainNode();
extern void DrawXorSinkArrow();
extern void DrawXorSourceArrow();
extern void DrawXorStraightArc();
extern XFontStruct *FontSelect();
extern void GetDrawGeometry();
extern void HiliteArcArrow();
extern void HiliteArcName();
extern void HiliteCurvedArc();
extern void HiliteLoopArc();
extern void HilitePlainNode();
extern void HiliteSinkArrow();
extern void HiliteSourceArrow();
extern void HiliteStraightArc();
extern void UnhiliteAll();
extern void UnhiliteArcArrow();
extern void UnhiliteArcName();
extern void UnhiliteCurvedArc();
extern void UnhiliteLoopArc();
extern void UnhilitePlainNode();
extern void UnhiliteSinkArrow();
extern void UnhiliteSourceArrow();
extern void UnhiliteStraightArc();

#define min(a,b) ((a) <= (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))
#define signum(a) ((a) > (0) ? (1) : (-1))

void ActivateWhenPressArc();
void ActivateWhenPress1Node();
void ActivateWhenPress3Node();
void DrawMovingArc();
void DrawMovingNode();
void EraseMovingArc();
void EraseMovingNode();
void MoveNode();
int PointerInArc();
int PointerInNode();
void SetCoordinatesArc();

static float kname = 0.3333;

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

void WhenPress1(x,y)
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
      ActivateWhenPress1Node((node*)object);
      break;
    }
  else {
    if (theGG.n_hilited_arcs != 0 || theGG.n_hilited_nodes != 0) {
      UnhiliteAll();
    }
  }
}

void WhenPress3(x,y)
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
      ActivateWhenPress3Node((node*)object);
      break;
    }
  else {
    if (theGG.n_hilited_arcs != 0 || theGG.n_hilited_nodes != 0) {
      UnhiliteAll();
    }
  }
}

void StopMoving(x,y)
int x,y; 
{
  int w, h;
  mylink *p;
  arc *a;
  w = drawWidth;
  h = drawHeight;
  if (x > w - (int)(metaScale*NodeDiam(theGG.moving))/2) 
    x = w - (int)(metaScale*NodeDiam(theGG.moving))/2;
  if (x < (int)(metaScale*NodeDiam(theGG.moving))/2) 
    x = (int)(metaScale*NodeDiam(theGG.moving))/2;
  if (y > h - (int)(metaScale*NodeDiam(theGG.moving))/2) 
    y = h - (int)(metaScale*NodeDiam(theGG.moving))/2;
  if (y < (int)(metaScale*NodeDiam(theGG.moving))/2) 
    y = (int)(metaScale*NodeDiam(theGG.moving))/2;
  MoveNode(x,y,theGG.moving);
  DrawNode(theGG.moving);
  p = theGG.moving->connected_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    SetCoordinatesArc(a);
    DrawArc(a);
    p = p->next;
  }
  p = theGG.moving->loop_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    SetCoordinatesArc(a);
    DrawArc(a);
    p = p->next;
  }
  theGG.moving = 0;
}  

void WhenRelease3(x,y)
int x,y;
{
  ptr object = 0;
  if (menuId == MODIFY) {
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

void WhenDownMove(sx,sy,x,y)
int sx,sy,x,y;
{
  ptr object = 0;
  node *n;
  arc *a;
  mylink *p;
  int w, h;
  if (theGG.moving == 0 && PointerInObject(sx,sy,&object) == NODE) {
    /* there is no moving object and the pointer is in a node,
       it becomes the moving node */
    n = (node*)object;
    theGG.moving = n;
    UnhiliteNode(n);
    EraseNode(n);
    theGG.modified = 1;
    p = n->connected_arcs->first;
    while (p) {
      a = (arc*)(p->element);
      EraseArc(a);
      p = p->next;
    }
    p = n->connected_arcs->first;
    while (p) {
      a = (arc*)(p->element);
      DrawMovingArc(a);
      p = p->next;
    }
    p = n->loop_arcs->first;
    while (p) {
      a = (arc*)(p->element);
      EraseArc(a);
      p = p->next;
    }
    p = n->loop_arcs->first;
    while (p) {
      a = (arc*)(p->element);
      DrawMovingArc(a);
      p = p->next;
    }
    DrawMovingNode(n);
  }
  else if (theGG.moving != 0) {
    /* there is a moving node : move it */
    w = drawWidth;
    h = drawHeight;
    if (x > w - (int)(metaScale*NodeDiam(theGG.moving))/2) 
      x = w - (int)(metaScale*NodeDiam(theGG.moving))/2;
    if (x < (int)(metaScale*NodeDiam(theGG.moving))/2) 
      x = (int)(metaScale*NodeDiam(theGG.moving))/2;
    if (y > h - (int)(metaScale*NodeDiam(theGG.moving))/2) 
      y = h - (int)(metaScale*NodeDiam(theGG.moving))/2;
    if (y < (int)(metaScale*NodeDiam(theGG.moving))/2) 
      y = (int)(metaScale*NodeDiam(theGG.moving))/2;
    MoveNode(x,y,theGG.moving);
  }
}

/* GRAPH */

void DrawGraph(g)
graph *g;
{
  mylink *p;
  arc *a;
  node *n;
  p = g->arcs->first;
  while (p) {
    a = (arc*)(p->element);
    DrawArc(a);
    p = p->next;
  }
  p = g->nodes->first;
  while (p) {
    n = (node*)(p->element);
    /* draw node */
    DrawNode(n);
    p = p->next;
  }
}

/* ARC */

int PointerInArrow(x, y, a)
int x, y;
arc *a;
{
  XPoint points[5];
  double xx, yy;
  int width, length;
  int i = 0;
  int metaScale1 = metaScale;

  xx = a->co;
  yy = - a->si;

  if (a->hilited) {
    width =  ArcHiWidth(a) + arrowWidth;
    length = ArcHiWidth(a) + arrowLength;    
  } else {
    width =  ArcWidth(a) + arrowWidth;
    length = ArcWidth(a) + arrowLength;
  }
  if (metaScale < 1) metaScale1 = 1;

  /* A0 */
  points[i].x = (short)((a->xmax) * metaScale + (width * a->si) * metaScale1);
  points[i].y = (short)((a->ymax) * metaScale + (width * a->co) * metaScale1);
  i++;
  /* A1 */
  points[i].x = (short)((a->xmax) * metaScale + (length * xx) * metaScale1);
  points[i].y = (short)((a->ymax) * metaScale + (length * yy) * metaScale1);
  i++;
  /* A2 */
  points[i].x = (short)((a->xmax) * metaScale - (width * a->si) * metaScale1);
  points[i].y = (short)((a->ymax) * metaScale - (width * a->co) * metaScale1);
  i++;
  /* symmetric of A1 */
  points[i].x = (short)((a->xmax) * metaScale - (length * xx) * metaScale1);
  points[i].y = (short)((a->ymax) * metaScale - (length * yy) * metaScale1);
  i++;
  /* A0 */
  points[i].x = points[0].x;
  points[i].y = points[0].y;
  i++;
  return XPointInRegion(XPolygonRegion(points,i,EvenOddRule),x,y);
}

int PointerInThisArc(x, y, a)
int x, y;
arc *a;
{
  if (a->x0 == HIDDEN) return 0;
  return PointerInArrow(x, y ,a);
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
    if (PointerInThisArc(x,y,a)) {
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
  if (theGG.n_hilited_arcs == 0 && theGG.n_hilited_nodes == 0) {
    /* there is no hilited object: this arc is hilited */
    HiliteArc(a);
  }
  else if (a->hilited) {
    /* this arc is already hilited: unhilite everything */
    UnhiliteAll();
  }
  else {
    /* there are hilited objects: unhilited them and this arc is
       hilited */
    UnhiliteAll();
    HiliteArc(a);
  }
}

void SetArrowCoordinatesArc(a)
arc *a;
{
  double xx, yy;
  xx = a->co;
  yy = - a->si;
  a->xa0 = a->xmax + (int)(arrowWidth * a->si);
  a->ya0 = a->ymax + (int)(arrowWidth * a->co);
  a->xa2 = a->xmax - (int)(arrowWidth * a->si);
  a->ya2 = a->ymax - (int)(arrowWidth * a->co);
  a->xa1 = a->xmax + (int)(arrowLength * xx);
  a->ya1 = a->ymax + (int)(arrowLength * yy);
}

void SetCoordinatesArc(a)
arc *a;
{
  int direction, x00, y00, x11, y11;
  int nrt, nrh;
  double l, d;
  double w, h;
  double inc0, inc;

  direction = (a->head->number > a->tail->number) ? a->g_type : - a->g_type;
  /* (x00,y00) and (x11,y11) are the center of the head and tail nodes */
  nrt = NodeDiam(a->tail) / 2; nrh = NodeDiam(a->head) / 2;
  x00 = a->tail->x + nrt;
  y00 = a->tail->y + nrt;
  x11 = a->head->x + nrh;
  y11 = a->head->y + nrh;
  /* (x0,y0) and (x1,y1) are the ends of the segment used to draw
     this arc */
  if (a->g_type >= LOOP) {
    a->x0 = x00 + nrt;
    a->y0 = y00;
    a->x1 = x00;
    a->y1 = y00 - nrh;
    d = sqrt((double)((a->x1 - a->x0)*(a->x1 - a->x0) + 
		      (a->y1 - a->y0)*(a->y1 - a->y0)));
    a->si = (a->y0 - a->y1) / d;
    a->co = (a->x1 - a->x0) / d;
    inc0 = (4 * bezierDy / 3 + 1.3 * (ArcWidth(a) - 1)) + nrt;
    inc = (a->g_type - LOOP) * 
      (4 * bezierDy / 3 + 1.3 * (ArcWidth(a) - 1));
    a->x2 = a->x0 + (int)((inc0 + inc) * 1.414);
    a->y2 = a->y0;
    a->x3 = a->x1;
    a->y3 = a->y1 - (int)((inc0 + inc) * 1.414);
    a->xmax = (a->x0 + 4 * a->x1 + 3 * a->x2) / 8;
    a->ymax = (4 * a->y0 + a->y1 + 3 * a->y3) / 8;
  }
  else {
    l = sqrt((double)((x11 - x00)*(x11 - x00) + (y11 - y00)*(y11 - y00)));
    /* arc is hidden: nodes too near */
    if (l <= nrt + nrh) {
      a->x0 = HIDDEN;
      return;
    }
    a->co = (x11 - x00) / l;
    a->si = (y00 - y11) / l;
    a->x0 = x00 + (int)(nrt * a->co);
    a->y0 = y00 - (int)(nrt * a->si);
    a->x1 = x11 - (int)(nrh * a->co);
    a->y1 = y11 + (int)(nrh * a->si);
    if (direction == 0) {
      a->xmax = (a->x0 + a->x1) / 2;
      a->ymax = (a->y0 + a->y1) / 2;
    }
    else {
      d = l - nrt - nrh;
      w = arcDx * d;
      h = direction * arcDy;
      a->x2 = a->x0 + (int)(w * a->co - h * a->si);
      a->y2 = a->y0 - (int)(w * a->si + h * a->co);
      a->x3 = a->x2 + (int)((d - 2 * w) * a->co);
      a->y3 = a->y2 - (int)((d - 2 * w) * a->si);
      a->xmax = (a->x2 + a->x3) / 2;
      a->ymax = (a->y2 + a->y3) / 2;
    }
  }
  SetArrowCoordinatesArc(a);
}

void DrawArc(a)
arc *a;
{
  char str[MAXNAM];
  int xname, yname;
  if (a->x0 == HIDDEN) return;
  theColor = Colors[a->col];
  arcW = ArcWidth(a);
  arcH = ArcHiWidth(a);
  theDrawFont = FontSelect(ArcFontSize(a));
  if (a->hilited == 1) HiliteArc1(a);
  else {
    if (a->g_type == 0)
      DrawStraightArc(a->x0,a->y0,a->x1,a->y1);
    else if (a->g_type < LOOP)
      DrawCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
    else 
      DrawLoopArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
    if (theGraph->directed)
      DrawArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2);
    xname = a->xmax; yname = a->ymax;
    if (a->g_type == 0) {
      xname = a->x0 + (a->x1 - a->x0) * kname; 
      yname = a->y0 + (a->y1 - a->y0) * kname;
    }
    if (arcStrDisplay != NODISP) {
      switch (arcStrDisplay) {
      case INT_ARCDISP:
	sprintf(str,"%d",a->number);
	DrawArcName(xname,yname,str);
	break;
      case NAME_ARCDISP:
	if (a->name != 0) DrawArcName(xname,yname,a->name);
	break;
      case COST_ARCDISP:
	sprintf(str,"%g",a->unitary_cost);
	DrawArcName(xname,yname,str);
	break;
      case MINCAP_ARCDISP:
	sprintf(str,"%g",a->minimum_capacity);
	DrawArcName(xname,yname,str);
	break;
      case MAXCAP_ARCDISP:
	sprintf(str,"%g",a->maximum_capacity);
	DrawArcName(xname,yname,str);
	break;
      case LENGTH_ARCDISP:
	sprintf(str,"%g",a->length);
	DrawArcName(xname,yname,str);
	break;
      case QWEIGHT_ARCDISP:
	sprintf(str,"%g",a->quadratic_weight);
	DrawArcName(xname,yname,str);
	break;
      case QORIG_ARCDISP:
	sprintf(str,"%g",a->quadratic_origin);
	DrawArcName(xname,yname,str);
	break;
      case WEIGHT_ARCDISP:
	sprintf(str,"%g",a->weight);
	DrawArcName(xname,yname,str);
	break;
      }
    } 
    else {if (a->label != 0) DrawArcName(xname,yname,a->label);}
  }
}

void DrawMovingArc(a)
arc *a;
{
  if (a->x0 == HIDDEN) return;
  arcW = ArcWidth(a);
  arcH = ArcHiWidth(a);
  theColor = Colors[a->col];
  theDrawFont = FontSelect(ArcFontSize(a));
  if (a->g_type == 0)
    DrawXorStraightArc(a->x0,a->y0,a->x1,a->y1);
  else if (a->g_type < LOOP)
    DrawXorCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  else
    DrawXorLoopArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
}

void EraseArc(a)
arc *a;
{
  char str[MAXNAM];
  int xname, yname;
  if (a->x0 == HIDDEN) return;
  arcW = ArcWidth(a);
  arcH = ArcHiWidth(a);
  theDrawFont = FontSelect(ArcFontSize(a));
  if (a->g_type == 0)
    ClearStraightArc(a->x0,a->y0,a->x1,a->y1);
  else if (a->g_type < LOOP)
    ClearCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  else
    ClearLoopArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  if (theGraph->directed)
    ClearArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2);
  xname = a->xmax; yname = a->ymax;
  if (a->g_type == 0) {
    xname = a->x0 + (a->x1 - a->x0) * kname; 
    yname = a->y0 + (a->y1 - a->y0) * kname;
  }
  if (arcStrDisplay != NODISP) {
    switch (arcStrDisplay) {
    case INT_ARCDISP:
      sprintf(str,"%d",a->number);
      ClearArcName(xname,yname,str);
      break;
    case NAME_ARCDISP:
      if (a->name != 0) ClearArcName(xname,yname,a->name);
      break;
    case COST_ARCDISP:
      sprintf(str,"%g",a->unitary_cost);
      ClearArcName(xname,yname,str);
      break;
    case MINCAP_ARCDISP:
      sprintf(str,"%g",a->minimum_capacity);
      ClearArcName(xname,yname,str);
      break;
    case MAXCAP_ARCDISP:
      sprintf(str,"%g",a->maximum_capacity);
      ClearArcName(xname,yname,str);
      break;
    case LENGTH_ARCDISP:
      sprintf(str,"%g",a->length);
      ClearArcName(xname,yname,str);
      break;
    case QWEIGHT_ARCDISP:
      sprintf(str,"%g",a->quadratic_weight);
      ClearArcName(xname,yname,str);
      break;
    case QORIG_ARCDISP:
      sprintf(str,"%g",a->quadratic_origin);
      ClearArcName(xname,yname,str);
      break;
    case WEIGHT_ARCDISP:
      sprintf(str,"%g",a->weight);
      ClearArcName(xname,yname,str);
      break;
    }
  } 
  else {if (a->label != 0) ClearArcName(xname,yname,a->label);}
}

void EraseMovingArc(a)
arc *a;
{ 
  if (a->x0 == HIDDEN) return;
  arcW = ArcWidth(a);
  arcH = ArcHiWidth(a);
  theColor = Colors[a->col];
  theDrawFont = FontSelect(ArcFontSize(a));
  if (a->g_type == 0)
    DrawXorStraightArc(a->x0,a->y0,a->x1,a->y1);
  else if (a->g_type < LOOP)
    DrawXorCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  else
    DrawXorLoopArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
}

void HiliteArc1(a)
arc *a;
{
  char str[MAXNAM];
  int xname, yname;
  if (a->x0 == HIDDEN) return;
  EraseArc(a);
  theColor = Colors[a->col];
  arcW = ArcWidth(a);
  arcH = ArcHiWidth(a);
  theDrawFont = FontSelect(ArcFontSize(a));
  if (a->g_type == 0)
    HiliteStraightArc(a->x0,a->y0,a->x1,a->y1);
  else if (a->g_type < LOOP)
    HiliteCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  else
    HiliteLoopArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  if (theGraph->directed)
    HiliteArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2);
  xname = a->xmax; yname = a->ymax;
  if (a->g_type == 0) {
    xname = a->x0 + (a->x1 - a->x0) * kname; 
    yname = a->y0 + (a->y1 - a->y0) * kname;
  }
  if (arcStrDisplay != NODISP) {
    switch (arcStrDisplay) {
    case INT_ARCDISP:
      sprintf(str,"%d",a->number);
      HiliteArcName(xname,yname,str);
      break;
    case NAME_ARCDISP:
      if (a->name != 0) HiliteArcName(xname,yname,a->name);
      break;
    case COST_ARCDISP:
      sprintf(str,"%g",a->unitary_cost);
      HiliteArcName(xname,yname,str);
      break;
    case MINCAP_ARCDISP:
      sprintf(str,"%g",a->minimum_capacity);
      HiliteArcName(xname,yname,str);
      break;
    case MAXCAP_ARCDISP:
      sprintf(str,"%g",a->maximum_capacity);
      HiliteArcName(xname,yname,str);
      break;
    case LENGTH_ARCDISP:
      sprintf(str,"%g",a->length);
      HiliteArcName(xname,yname,str);
      break;
    case QWEIGHT_ARCDISP:
      sprintf(str,"%g",a->quadratic_weight);
      HiliteArcName(xname,yname,str);
      break;
    case QORIG_ARCDISP:
      sprintf(str,"%g",a->quadratic_origin);
      HiliteArcName(xname,yname,str);
      break;
    case WEIGHT_ARCDISP:
      sprintf(str,"%g",a->weight);
      HiliteArcName(xname,yname,str);
      break;
    }
  } 
  else {if (a->label != 0) HiliteArcName(xname,yname,a->label);}
  DrawNode(a->tail);
  DrawNode(a->head);
}

void HiliteArc(a)
arc *a;
{
  if (a->x0 == HIDDEN) return;
  a->hilited = 1;
  theGG.n_hilited_arcs++;
  AddListElement((ptr)a,theGG.hilited_arcs);    
  HiliteArc1(a);
}

void UnhiliteArc1(a)
arc *a;
{  
  char str[MAXNAM];
  int xname, yname;
  if (a->x0 == HIDDEN) return;
  arcW = ArcWidth(a);
  arcH = ArcHiWidth(a);
  theDrawFont = FontSelect(ArcFontSize(a));
  xname = a->xmax; yname = a->ymax;
  if (a->g_type == 0) {
    xname = a->x0 + (a->x1 - a->x0) * kname; 
    yname = a->y0 + (a->y1 - a->y0) * kname;
  }
  if (arcStrDisplay != NODISP) {
    switch (arcStrDisplay) {
    case INT_ARCDISP:
      sprintf(str,"%d",a->number);
      UnhiliteArcName(xname,yname,str);
      break;
    case NAME_ARCDISP:
      if (a->name != 0) UnhiliteArcName(xname,yname,a->name);
      break;
    case COST_ARCDISP:
      sprintf(str,"%g",a->unitary_cost);
      UnhiliteArcName(xname,yname,str);
      break;
    case MINCAP_ARCDISP:
      sprintf(str,"%g",a->minimum_capacity);
      UnhiliteArcName(xname,yname,str);
      break;
    case MAXCAP_ARCDISP:
      sprintf(str,"%g",a->maximum_capacity);
      UnhiliteArcName(xname,yname,str);
      break;
    case LENGTH_ARCDISP:
      sprintf(str,"%g",a->length);
      UnhiliteArcName(xname,yname,str);
      break;
    case QWEIGHT_ARCDISP:
      sprintf(str,"%g",a->quadratic_weight);
      UnhiliteArcName(xname,yname,str);
      break;
    case QORIG_ARCDISP:
      sprintf(str,"%g",a->quadratic_origin);
      UnhiliteArcName(xname,yname,str);
      break;
    case WEIGHT_ARCDISP:
      sprintf(str,"%g",a->weight);
      UnhiliteArcName(xname,yname,str);
      break;
    }
  } 
  else {if (a->label != 0) UnhiliteArcName(xname,yname,a->label);}
  
  if (a->g_type == 0)
    UnhiliteStraightArc(a->x0,a->y0,a->x1,a->y1);
  else if (a->g_type < LOOP )
    UnhiliteCurvedArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  else
    UnhiliteLoopArc(a->x0,a->y0,a->x2,a->y2,a->x3,a->y3,a->x1,a->y1);
  if (theGraph->directed)
    UnhiliteArcArrow(a->xa0,a->ya0,a->xa1,a->ya1,a->xa2,a->ya2);
  DrawArc(a);
  DrawNode(a->tail);
  DrawNode(a->head);
}

void UnhiliteArc(a)
arc *a;
{  
  if (a->x0 == HIDDEN) return;
  a->hilited = 0;
  theGG.n_hilited_arcs--;
  RemoveListElement((ptr)a,theGG.hilited_arcs);
  UnhiliteArc1(a);
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
    x0 = (int)(metaScale*(n->x + NodeDiam(n) / 2));
    y0 = (int)(metaScale*(n->y + NodeDiam(n) / 2));
    r = (int)(metaScale * NodeDiam(n) / 2);
    if ((x - x0)*(x - x0) + (y - y0)*(y - y0) < r * r) {
      *object = p->element;
      return 1;
    }
    p = p->next;
  }
  return 0;
} 

void ActivateWhenPress1Node(n)
node *n;
{
  if (theGG.n_hilited_arcs == 0 && theGG.n_hilited_nodes == 0) {
    /* there is no hilited object */
    HiliteNode(n);
  }
  else if (n->hilited) {
    /* this node is already hilited: unhilite everything */
    UnhiliteAll();
  }
  else {    
    /* there are hilited objects: unhilited them and this node is
       hilited */
    UnhiliteAll();
    HiliteNode(n);
  }
}

void ActivateWhenPress3Node(n)
node *n;
{
  arc *a1;
  node *n1;

  if (theGG.n_hilited_arcs == 0 && theGG.n_hilited_nodes == 0) {
    /* there is no hilited object */
    HiliteNode(n);
  }
  else if (n->hilited) {
    /* this node is already hilited: unhilite everything */
    UnhiliteAll();
  }
  else if (menuId == MODIFY && theGG.n_hilited_arcs == 0 && 
	   theGG.n_hilited_nodes == 1) {
      /* we are in modify menu and there is another hilited node: draw a new 
	 arc from the hilited node to this node and unhilite the nodes */
    UnhiliteNode(n);
    n1 = (node*)theGG.hilited_nodes->first->element;
    UnhiliteNode(n1);
    a1 = AddArc(n1,n,theGraph);
    if (a1 == 0) return;
    DrawArc(a1);
    DrawNode(a1->tail);
    DrawNode(a1->head);
    theGG.modified = 1;
  }
  else {    
    /* there are hilited objects: unhilited them and this node is
       hilited */
    UnhiliteAll();
    HiliteNode(n);
  }
}

void MoveNode(nx, ny, n)
int nx, ny;
node *n;
{
  mylink *p;
  arc *a;

  EraseMovingNode(n);
  n->x = (int)((double)(nx - (int)(metaScale*NodeDiam(n)) / 2)/metaScale);
  n->y = (int)((double)(ny - (int)(metaScale*NodeDiam(n)) / 2)/metaScale);
  /* move arcs */
  p = n->connected_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    EraseMovingArc(a);
    SetCoordinatesArc(a);
    DrawMovingArc(a);
    p = p->next;
  }
  p = n->loop_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    EraseMovingArc(a);
    SetCoordinatesArc(a);
    DrawMovingArc(a);
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
  nodeDiam = NodeDiam(n);
  nodeW = NodeBorder(n);
  theDrawFont = FontSelect(NodeFontSize(n));
  if (n->hilited == 1) HiliteNode1(n);
  else {
    switch (n->type) {
    case PLAIN:
      DrawPlainNode(n->x,n->y);
      break;
    case SINK:
      DrawPlainNode(n->x,n->y);
      DrawSinkArrow(n->x,n->y);
      break;
    case SOURCE:
      DrawPlainNode(n->x,n->y);
      DrawSourceArrow(n->x,n->y);
      break;
    }
    if (nodeStrDisplay != NODISP) {
      switch (nodeStrDisplay) {
      case INT_NODEDISP:
	sprintf(str,"%d",n->number);
	DrawNodeName(n->x,n->y,str);
	break;
      case NAME_NODEDISP:
	if (n->name != 0) DrawNodeName(n->x,n->y,n->name);
	break;
      case DEMAND_NODEDISP:
	sprintf(str,"%g",n->demand);
	DrawNodeName(n->x,n->y,str);
	break;
      }
    } 
    else {if (n->label != 0) DrawNodeName(n->x,n->y,n->label);}
  }
}

void DrawMovingNode(n)
node *n;
{
  nodeDiam = NodeDiam(n);
  nodeW = NodeBorder(n);
  theColor = Colors[n->col];
  theDrawFont = FontSelect(NodeFontSize(n));
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
  nodeDiam = NodeDiam(n);
  nodeW = NodeBorder(n);
  theDrawFont = FontSelect(NodeFontSize(n));
  switch (n->type) {
  case PLAIN:
    ClearPlainNode(n->x,n->y);
    break;
  case SINK:
    ClearPlainNode(n->x,n->y);
    ClearSinkArrow(n->x,n->y);
    break;
  case SOURCE:
    ClearPlainNode(n->x,n->y);
    ClearSourceArrow(n->x,n->y);
    break;
  }
  if (nodeStrDisplay != NODISP) {
    switch (nodeStrDisplay) {
    case INT_NODEDISP:
      sprintf(str,"%d",n->number);
      ClearNodeName(n->x,n->y,str);
      break;
    case NAME_NODEDISP:
      if (n->name != 0) ClearNodeName(n->x,n->y,n->name);
      break;
    case DEMAND_NODEDISP:
      sprintf(str,"%g",n->demand);
      ClearNodeName(n->x,n->y,str);
      break;
    }
  } 
  else {if (n->label != 0) ClearNodeName(n->x,n->y,n->label);} 
}

void EraseMovingNode(n)
node *n;
{
  nodeDiam = NodeDiam(n);
  nodeW = NodeBorder(n);
  theColor = Colors[n->col];
  theDrawFont = FontSelect(NodeFontSize(n));
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

void HiliteNode1(n)
node *n;
{
  char str[MAXNAM];  
  theColor = Colors[n->col];
  nodeDiam = NodeDiam(n);
  nodeW = NodeBorder(n);
  theDrawFont = FontSelect(NodeFontSize(n));
  switch (n->type) {
  case PLAIN:
    HilitePlainNode(n->x,n->y);
    break;
  case SINK:
    HilitePlainNode(n->x,n->y);
    HiliteSinkArrow(n->x,n->y);
    break;
  case SOURCE:
    HilitePlainNode(n->x,n->y);
    HiliteSourceArrow(n->x,n->y);
    break;
  }
  if (nodeStrDisplay != NODISP) {
    switch (nodeStrDisplay) {
    case INT_NODEDISP:
      sprintf(str,"%d",n->number);
      HiliteNodeName(n->x,n->y,str);
      break;
    case NAME_NODEDISP:
      if (n->name != 0) HiliteNodeName(n->x,n->y,n->name);
      break;
    case DEMAND_NODEDISP:
      sprintf(str,"%g",n->demand);
      HiliteNodeName(n->x,n->y,str);
      break;
    }
  } 
  else {if (n->label != 0) HiliteNodeName(n->x,n->y,n->label);}
}

void HiliteNode(n)
node *n;
{
  n->hilited = 1;
  theGG.n_hilited_nodes++;
  AddListElement((ptr)n,theGG.hilited_nodes);
  HiliteNode1(n);
}

void UnhiliteNode1(n)
node *n;
{
  char str[MAXNAM];
  nodeDiam = NodeDiam(n);
  nodeW = NodeBorder(n);
  theDrawFont = FontSelect(NodeFontSize(n));
  if (nodeStrDisplay != NODISP) {
    switch (nodeStrDisplay) {
    case INT_NODEDISP:
      sprintf(str,"%d",n->number);
      UnhiliteNodeName(n->x,n->y,str);
      break;
    case NAME_NODEDISP:
      if (n->name != 0) UnhiliteNodeName(n->x,n->y,n->name);
      break;
    case DEMAND_NODEDISP:
      sprintf(str,"%g",n->demand);
      UnhiliteNodeName(n->x,n->y,str);
      break;
    }
  } 
  else {if (n->label != 0) UnhiliteNodeName(n->x,n->y,n->label);}
  switch (n->type) {
  case PLAIN:
    UnhilitePlainNode(n->x,n->y);
    break;
  case SINK:
    UnhilitePlainNode(n->x,n->y);
    UnhiliteSinkArrow(n->x,n->y);
    break;
  case SOURCE:
    UnhilitePlainNode(n->x,n->y);
    UnhiliteSourceArrow(n->x,n->y);
    break;
  }
  if (nodeStrDisplay != NODISP) {
    switch (nodeStrDisplay) {
    case INT_NODEDISP:
      sprintf(str,"%d",n->number);
      DrawNodeName(n->x,n->y,str);
      break;
    case NAME_NODEDISP:
      if (n->name != 0) DrawNodeName(n->x,n->y,n->name);
      break;
    case DEMAND_NODEDISP:
      sprintf(str,"%g",n->demand);
      DrawNodeName(n->x,n->y,str);
      break;
    }
  } 
  else {if (n->label != 0) DrawNodeName(n->x,n->y,n->label);}
}

void UnhiliteNode(n)
node *n;
{
  n->hilited = 0;
  theGG.n_hilited_nodes--;
  RemoveListElement((ptr)n,theGG.hilited_nodes);
  UnhiliteNode1(n);
}

void CreateLoop()
{
  node *n; arc *a;

  if (theGG.n_hilited_nodes == 1) {
    n = (node*)theGG.hilited_nodes->first->element;
    a = AddArc(n,n,theGraph);
    if (a == 0) return;
    DrawArc(a);
    DrawNode(a->tail);
    DrawNode(a->head);
    theGG.modified = 1;
  }
}

void CreateSource()
{
  node *n;

  if (theGG.n_hilited_nodes == 1) {
    n = (node*)theGG.hilited_nodes->first->element;
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
      EraseNode(n);
      n->type = SOURCE;
      DrawNode(n);
    }
  }
}

void CreateSink()
{
  node *n;
  if (theGG.n_hilited_nodes == 1) {
    n = (node*)theGG.hilited_nodes->first->element;
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
      EraseNode(n);
      n->type = SINK;
      DrawNode(n);
    }
  }
}

void RemoveSourceSink()
{
  node *n;

  if (theGG.n_hilited_nodes == 1) {
    n = (node*)theGG.hilited_nodes->first->element;
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
  }
}

void ChooseDefaults()
{
  char *label = "Graphic attributes";
  char *init[5];
  char *result[5];
  char *description[5];
  char str[64];
  int v;
  int snodeDiam, snodeW, sarcW, sarcH, sfontSize;
  XFontStruct *fontstruct;
  mylink *p;
  int i = 0;
  int redraw = 0;

  sprintf(str,"%d",theGraph->fontSize);
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
  description[i] = "Default font size: ";
  i++;

  sprintf(str,"%d",theGraph->nodeDiam);
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
  description[i] = "Default node diameter: ";
  i++;

  sprintf(str,"%d",theGraph->nodeBorder);
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
  description[i] = "Default border node width: ";
  i++;

  sprintf(str,"%d",theGraph->arcWidth);
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
  description[i] = "Default arc width: ";
  i++;

  sprintf(str,"%d",theGraph->arcHiWidth);
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
  description[i] = "Default highlighted arc width: ";
  i++;
  
  if (MetanetDialogs(i,init,result,description,label)) {
    i = 0;

    sfontSize = theGraph->fontSize;
    sscanf(result[i],"%d",&v);
    if ((fontstruct = FontSelect(v)) == NULL) {
      sprintf(Description,
	      "Unknown font size %d\nUse only 8, 10, 12 14, 18 or 24",v);
      MetanetAlert(Description);
      return;
    }
    theGraph->fontSize = v; i++;
    if (theGraph->fontSize != sfontSize) {
      SetFont(fontstruct);
      theGG.modified = 1;
    }
    
    snodeDiam = theGraph->nodeDiam;
    if (sscanf(result[i],"%d",&v) > 0)
      theGraph->nodeDiam = v; i++;
    if (theGraph->nodeDiam < 2) theGraph->nodeDiam = snodeDiam;
    if (theGraph->nodeDiam != snodeDiam) theGG.modified = 1;
    
    snodeW = theGraph->nodeBorder;
    if (sscanf(result[i],"%d",&v) > 0)
      theGraph->nodeBorder = v; i++;
    if (theGraph->nodeBorder <= 0 || 
	theGraph->nodeBorder > theGraph->nodeDiam/2) 
      theGraph->nodeBorder = snodeW;
    if (theGraph->nodeBorder != snodeW) theGG.modified = 1;
    
    sarcW = theGraph->arcWidth;
    if (sscanf(result[i],"%d",&v) > 0)
      theGraph->arcWidth = v; i++;
    if (theGraph->arcWidth <= 0) theGraph->arcWidth = sarcW;
    if (theGraph->arcWidth != sarcW) theGG.modified = 1;
    
    sarcH = theGraph->arcHiWidth;
    if (sscanf(result[i],"%d",&v) > 0)
      theGraph->arcHiWidth = v; i++;
    if (theGraph->arcHiWidth <= 0) theGraph->arcHiWidth = sarcH;
    if (theGraph->arcHiWidth != sarcH) theGG.modified = 1;
    
    if (theGG.modified) {
      p = theGraph->arcs->first;
      while (p) {
	SetCoordinatesArc((arc*)p->element);
	p = p->next;
      }
      redraw = 1;
    }
    
    if (redraw) {
      ClearDraw();
      DrawGraph(theGraph);
    }
  }
}

void UnhiliteAll()
{
  arc *a1;
  node *n1;
  mylink *p;

  p = theGG.hilited_arcs->first;
  while(p) {
    a1 = (arc*)(p->element);
    a1->hilited = 0;
    UnhiliteArc1(a1);
    p = p->next;
  }
  theGG.n_hilited_arcs = 0;
  theGG.hilited_arcs->first = 0;

  p = theGG.hilited_nodes->first;
  while(p) {
    n1 = (node*)(p->element);
    n1->hilited = 0;
    UnhiliteNode1(n1);
    p = p->next;
  }
  theGG.n_hilited_nodes = 0;
  theGG.hilited_nodes->first = 0;
}
