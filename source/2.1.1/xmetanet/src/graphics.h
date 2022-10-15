typedef struct graphics {
  Display *dpy;
  Drawable d;
  Pixel bg;
  Pixel fg;
  GC gc;
  GC gc_clear;
  GC gc_xor;
  XFontStruct *drawfont;
  XFontStruct *metafont;
  Widget shell; 
} G;

extern G theG;
extern int intDisplay;
extern int nodeNameDisplay;
extern int arcNameDisplay;
