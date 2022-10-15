#include "scilab_d.h"
#include "../machine.h"

extern Widget toplevel;
extern XtAppContext app_con;

void C2F(inix)()
{
  Display *dpy;
  unsigned long fg,bg;

  int argc = 0;
  char **argv = (char **) NULL;
  DisplayInit((char*)0,&dpy,&fg,&bg);
}


void inix1_(argc,argv)
  int argc ;
  char **argv;
{
  Display *dpy;
  unsigned long fg,bg;
  DisplayInit((char*)0,&dpy,&fg,&bg);
}


