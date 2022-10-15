#include <X11/Intrinsic.h>

#include "graphics.h"
#include "menus.h"

extern void ExposeBegin();
extern void ExposeModify();
extern void ExposeStudy();
extern void WhenDownMove();
extern void WhenPress();
extern void WhenRelease();

void ActionWhenExpose(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  switch (menuId) {
  case BEGIN:
    ExposeBegin();
    break;
  case STUDY:
    ExposeStudy();
    break;
  case MODIFY:
    ExposeModify();
    break;
  }
  if (theG.shell != NULL)
    XRaiseWindow(XtDisplay(theG.shell),XtWindow(theG.shell));  
}

void ActionWhenPress(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  if (menuId != BEGIN)
    WhenPress(event->x,event->y);
}

void ActionWhenRelease(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  WhenRelease(event->x,event->y);
}

void ActionWhenDownMove(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{
  if (menuId == MODIFY)
    WhenDownMove(event->x,event->y);
}

void ActionWhenLeave(w,event,params,num_params)
Widget w;
XButtonEvent *event;
String *params;
Cardinal *num_params;
{}
