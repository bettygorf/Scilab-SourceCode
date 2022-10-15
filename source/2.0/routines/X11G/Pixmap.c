/** Pixmap routines **/

static Pixmap Cpixmap;
static int depth;

pixmapclear_()
{
  XWindowAttributes war;
  XSetForeground(dpy,gc,background);
  XGetWindowAttributes(dpy,CWindow,&war); 
  XFillRectangle(dpy, Cpixmap, gc, 0, 0, war.width,war.height);
  XSetForeground(dpy,gc,foreground);
};

show_()
{
   XClearWindow(dpy,CWindow);
   XFlush(dpy);
};


/** ResiZe the pixmap associated to CWindow and store it back in the window List **/

CPixmapResize(x,y)
     int x,y;
{
  XFreePixmap(dpy,Cpixmap);
  Cpixmap = XCreatePixmap(dpy, root,Max(x,400),Max(y,300),depth);
  SetPixmapNumber_(Cpixmap,MissileXgc.CurWindow);
  XSetForeground(dpy,gc,background);
  XFillRectangle(dpy, Cpixmap, gc, 0, 0,Max(x,400),Max(y,300));
  XSetForeground(dpy,gc,foreground);
  XSetWindowBackgroundPixmap(dpy, CWindow, Cpixmap);
};


CPixmapResize1()
{
  XWindowAttributes war;
  XGetWindowAttributes(dpy,CWindow,&war); 
  CPixmapResize(war.width,war.height);
};
