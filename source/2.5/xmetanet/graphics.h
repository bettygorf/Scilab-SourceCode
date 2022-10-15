#define NODISP 999

#define INT_NODEDISP 0
#define NAME_NODEDISP 1
#define DEMAND_NODEDISP 2

#define INT_ARCDISP 0
#define NAME_ARCDISP 1
#define COST_ARCDISP 2
#define MINCAP_ARCDISP 3
#define MAXCAP_ARCDISP 4
#define LENGTH_ARCDISP 5
#define QWEIGHT_ARCDISP 6
#define QORIG_ARCDISP 7
#define WEIGHT_ARCDISP 8

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
  XFontStruct *helpfont;
  Widget shell;
} G;

extern G theG;
extern int arcStrDisplay;
extern int nodeStrDisplay;
