#include <X11/Xproto.h>

typedef struct {
     CARD16 x0,y0,x1,y1,x2,y2,x3,y3;
} xBezier;

extern void DrawBezier();
