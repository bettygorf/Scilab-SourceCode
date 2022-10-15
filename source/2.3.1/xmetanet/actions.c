#include <X11/Intrinsic.h>

#include "graphics.h"
#include "menus.h"
#include "list.h"
#include "graph.h"

extern void ExposeBegin();
extern void ExposeModify();
extern void ExposeStudy();
extern void WhenDownMove();
extern void WhenPress1();
extern void WhenPress3();
extern void WhenRelease3();

static int sx = 0;
static int sy = 0;

#define MINMOVE 10

void ActionWhenExpose(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  /* for servers which don't admit backing store, snif! */
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    DrawGraph(theGraph);
    break;
  case MODIFY:
    ClearDraw();
    DrawGraph(theGraph);
    break;
  }
  if (theG.shell != NULL)
    XRaiseWindow(XtDisplay(theG.shell),XtWindow(theG.shell));  
}

void ActionWhenPress1(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  sx = event->x;
  sy = event->y;
  if (menuId != BEGIN)
    WhenPress1(event->x,event->y);
}

void ActionWhenPress3(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  sx = event->x;
  sy = event->y;
  if (menuId != BEGIN)
    WhenPress3(event->x,event->y);
}

void ActionWhenRelease3(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  sx = event->x;
  sy = event->y;
  WhenRelease3(event->x,event->y);
}

void ActionWhenDownMove3(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  if (menuId == MODIFY && 
      ((sx - event->x) * (sx - event->x) > MINMOVE ||
       (sy - event->y) * (sy - event->y) > MINMOVE)) {
    WhenDownMove(sx,sy,event->x,event->y);
    sx = event->x;
    sy = event->y;
  }
}

void ActionWhenLeave(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
}
