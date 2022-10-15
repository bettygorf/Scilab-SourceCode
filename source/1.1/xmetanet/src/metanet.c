#include <stdio.h>
#include <string.h>
#include <X11/cursorfont.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Label.h>

#include "defs.h"
#include "color.h"
#include "graphics.h"
#include "menus.h"

extern void CreateMenus();
extern void CreateSocket();
extern void InitMetanet();
extern void MakeDraw();

char *Version = "2.3";

int metaWidth = METAWIDTH;
int metaHeight = METAHEIGHT;

int viewHeight = VIEWHEIGHT;
int drawHeight = DRAWHEIGHT;
int drawWidth = DRAWWIDTH;

int arcW = ARCW;
int arcH = ARCH;
int nodeW = NODEW;
int nodeDiam = NODEDIAM;

int arrowLength = ARROWLENGTH;
int arrowWidth = ARROWWIDTH;
int bezierRx = BEZIERRX;
int bezierDy = BEZIERDY;

typedef struct res {
    Pixel color[NUMCOLORS];
} RES, *RESPTR;

static RES the_res;

static XtResource app_resources[] = {
    {"color0", "Color0", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[0]), XtRString, (caddr_t) "black"},
    {"color1", "Color1", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[1]), XtRString, (caddr_t) "blue"},
    {"color2", "Color2", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[2]), XtRString, (caddr_t) "green"},
    {"color3", "Color3", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[3]), XtRString, (caddr_t) "cyan"},
    {"color4", "Color4", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[4]), XtRString, (caddr_t) "red"},
    {"color5", "Color5", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[5]), XtRString, (caddr_t) "magenta"},
    {"color6", "Color6", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[6]), XtRString, (caddr_t) "yellow"},
    {"color7", "Color7", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[7]), XtRString, (caddr_t) "white"},
};

Widget toplevel, frame, metanetMenu, drawViewport, metanetDraw;

int menuId = BEGIN;
G theG;
XtAppContext app_con;

void Destroyed(widget, closure, callData)
Widget widget;	
caddr_t closure;	
caddr_t callData;	
{
  exit(0);
}

int main(argc, argv)
unsigned int argc;
char **argv;
{
  Arg args[20];
  int iargs;
  extern void ActionWhenDownMove(); 
  extern void ActionWhenExpose(); 
  extern void ActionWhenLeave();
  extern void ActionWhenPress(); 
  extern void ActionWhenRelease();
  static XtActionsRec actionTable[] = {
    {"ActionWhenDownMove", (XtActionProc) ActionWhenDownMove},
    {"ActionWhenExpose", (XtActionProc) ActionWhenExpose},
    {"ActionWhenLeave", (XtActionProc) ActionWhenLeave},
    {"ActionWhenPress", (XtActionProc) ActionWhenPress},
    {"ActionWhenRelease", (XtActionProc) ActionWhenRelease},
  };
  int actions = 5;
  GC gc, gc_clear, gc_xor;
  XGCValues gcv;
  Display *dpy;
  Drawable d;
  Pixel bg, fg;
  XFontStruct *fontstruct;
  int isLocal,isServeur;
  XColor x_fg_color,x_bg_color;
  Widget look;
  int i;
  char *iniG;

  iniG = NULL;
  switch(argc) {
  case 1:
    isServeur = 0;
    break;
  case 2: 
    switch(argv[1][1]) {
    case 's':
      isServeur = 1;
      isLocal = 0;
      break;
    case 'l':
      isServeur = 1;
      isLocal = 1;
      break;
    default:
      fprintf(stderr,"Unknown argument\n");
      exit(1);
    }
    break;
  case 3:
    if (strcmp("-graph",argv[1]) == 0) {
      isServeur = 0;
      iniG = argv[2];
    } 
    else {
      fprintf(stderr,"Unknown argument\n");
      exit(1);
    }
    break;
  default:
    fprintf(stderr,"Bad number of arguments\n");
    exit(1);
  } 

  if (isServeur == 1) CreateSocket(isLocal);

  toplevel = XtAppInitialize(&app_con, (String)"Metanet", NULL, 0, 
			     (int*)&argc, (String*)argv, NULL, NULL, 0);

  XtAppAddActions(app_con,actionTable,actions);

  iargs = 0;
  XtSetArg( args[iargs], XtNtitle, strcat("Metanet ",Version)); iargs++;
  XtSetValues(toplevel,args,iargs);

  iargs = 0;
  XtSetArg( args[iargs], XtNheight, metaHeight); iargs++;
  XtSetArg( args[iargs], XtNwidth, metaWidth); iargs++;
  XtSetArg( args[iargs], XtNx, X); iargs++;
  XtSetArg( args[iargs], XtNy, Y); iargs++;
  XtSetArg( args[iargs], XtNdefaultDistance, 0); iargs++;
  frame = XtCreateManagedWidget( "form", formWidgetClass, toplevel,
				args, iargs);
  XtAddCallback(frame, XtNdestroyCallback, Destroyed, NULL );

  dpy = XtDisplay(toplevel);

  if ((fontstruct = XLoadQueryFont(dpy, METAFONT)) == NULL) {
    fprintf(stderr,"Font %s is unknown\n",METAFONT);
    fprintf(stderr,"I'll use font: fixed\n");
    if ((fontstruct = XLoadQueryFont(dpy, "fixed")) == NULL) {
      fprintf(stderr,"Unknown font: fixed\n");
      exit(1);
    }
  }
  theG.metafont = fontstruct;

  CreateMenus();
  MakeDraw();
				  
  XtRealizeWidget(toplevel);

  d = XtWindow(metanetDraw);

  /* get color pixels */
  XtGetApplicationResources(toplevel, &the_res, app_resources,
			    XtNumber(app_resources), NULL, 0);
  for (i = 0; i < NUMCOLORS - 1; i++) Colors[i+1] = the_res.color[i];

  /* get foreground and background pixels and colors */
  XtSetArg(args[0],XtNlabel,"");
  look = XtCreateWidget("look", labelWidgetClass, toplevel, args, 1);

  XtSetArg(args[0],XtNforeground, &x_fg_color.pixel);
  XtSetArg(args[1],XtNbackground, &x_bg_color.pixel);
  XtGetValues(look,args,2);
  fg = x_fg_color.pixel;
  bg = x_bg_color.pixel;
  Colors[0] = fg;

  XtDestroyWidget(look);

  /* GC */
  if ((fontstruct = XLoadQueryFont(dpy, DRAWFONT)) == NULL) {
    fprintf(stderr,"Font %s is unknown\n",DRAWFONT);
    fprintf(stderr,"I'll use font: fixed\n");
    if ((fontstruct = XLoadQueryFont(dpy, "fixed")) == NULL) {
      fprintf(stderr,"Unknown font: fixed\n");
      exit(1);
    }
  }
  gcv.font = fontstruct->fid;

  gcv.foreground = fg;
  gcv.background = bg;
  gcv.function = GXcopy; 
  gc = XCreateGC(dpy,d,
		 (GCFont | GCForeground | GCBackground | GCFunction),&gcv);

  /* GC Clear */
  gcv.foreground = bg;
  gcv.background = bg;
  gcv.function = GXcopy;
  gc_clear = XCreateGC(dpy,d,
		       (GCFont | GCForeground | GCBackground | GCFunction),
		       &gcv);

  /* GC Xor */
  gcv.foreground = fg ^ bg; 
  gcv.background = bg;
  gcv.function = GXxor;
  gcv.line_width = 1;
  gc_xor = XCreateGC(dpy,d,(GCForeground | GCBackground | GCFunction),&gcv);
  
  XDefineCursor(dpy,d,XCreateFontCursor(dpy,XC_draft_small));
  
  theG.dpy = dpy;
  theG.d = d;
  theG.bg = bg;
  theG.fg = fg;
  theG.gc = gc;
  theG.gc_clear = gc_clear;
  theG.gc_xor = gc_xor;
  theG.drawfont = fontstruct;
  theG.shell = NULL;

  theColor = fg;

  DisplayMenu(BEGIN); 

  InitMetanet(iniG);

  XtMapWidget(toplevel);

  XtAppMainLoop(app_con);

  return 0;
}
