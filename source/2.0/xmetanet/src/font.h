extern XFontStruct *theDrawFont;

#define SetFont(f) theG.drawfont=f;XSetFont(theG.dpy,theG.gc,f->fid);XSetFont(theG.dpy,theG.gc_clear,f->fid);
