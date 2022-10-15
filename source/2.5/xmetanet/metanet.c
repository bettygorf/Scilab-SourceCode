/* Copyright INRIA */
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
#include "list.h"
#include "graph.h"
#include "graphics.h"
#include "menus.h"
#include "metadir.h"

#include "libCalCom.h"
#include "libCom.h"

#define TEMPS  1000    

#define max(a,b) ((a) > (b) ? (a) : (b))

/* Table of messages known by xmetanet */

static void quitter_appli_msgact();  
extern void GetMsg();
static void erreur_message_msgact(); 

static actions_messages tb_messages[]={
    {ID_GeCI,MSG_QUITTER_APPLI,NBP_QUITTER_APPLI,quitter_appli_msgact},
    {NULL,MSG_DISTRIB_LISTE_ELMNT,NBP_DISTRIB_LISTE_ELMNT,GetMsg},
    {NULL,NULL,0,erreur_message_msgact}};

static void clock_tic();   
static int find();
static void PrintUsage();

extern void CreateMenus();
extern void InitMetanet();
extern void MakeDraw();
extern void GetFonts();
extern XFontStruct *FontSelect();

char metanetName[MAXNAM];
char *Version = "3.0.3";

int isServeur;
int theWindow;

int metaWidth;
int metaHeight;

int drawHeight;
int drawWidth;

int arcW;
int arcH;
int nodeW;
int nodeDiam;

int arrowLength = ARROWLENGTH;
int arrowWidth = ARROWWIDTH;
int bezierDy = BEZIERDY;
double arcDx = ARCDX;
int arcDy = ARCDY;

int incX = INCX;
int incY = INCY;

int dpyWidth;
int dpyHeight;

typedef struct res {
    Pixel color[NUMCOLORS];
    Dimension draw_height;
    Dimension draw_width;
    String geometry;
} RES, *RESPTR;

static RES the_res;

static XtResource app_resources[] = {
    {"color0", "Color0", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[0]), XtRString, (caddr_t) "black"},
    {"color1","Color1", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[1]), XtRString, (caddr_t) "navyblue"},
    {"color2","Color2", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[2]), XtRString, (caddr_t) "blue"},
    {"color3","Color3", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[3]), XtRString, (caddr_t) "skyblue"},
    {"color4","Color4", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[4]), XtRString, (caddr_t) "aquamarine"},
    {"color5","Color5", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[5]), XtRString, (caddr_t) "forestgreen"},
    {"color6","Color6", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[6]), XtRString, (caddr_t) "green"},
    {"color7","Color7", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[7]), XtRString, (caddr_t) "lightcyan"},
    {"color8","Color8", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[8]), XtRString, (caddr_t) "cyan"},
    {"color9","Color9", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[9]), XtRString, (caddr_t) "orange"},
    {"color10","Color10", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[10]), XtRString, (caddr_t) "red"},
    {"color11","Color11", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[11]), XtRString, (caddr_t) "magenta"},
    {"color12","Color12", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[12]), XtRString, (caddr_t) "violet"},
    {"color13","Color13", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[13]), XtRString, (caddr_t) "yellow"},
    {"color14","Color14", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[14]), XtRString, (caddr_t) "gold"},
    {"color15","Color15", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[15]), XtRString, (caddr_t) "beige"},
    {"color16","Color16", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[16]), XtRString, (caddr_t) "white"},
    {"drawHeight", "DrawHeight", XtRDimension, sizeof(Dimension),
       XtOffset(RESPTR, draw_height), XtRImmediate, (caddr_t) DRAWHEIGHT},
    {"drawWidth", "DrawWidth", XtRDimension, sizeof(Dimension),
       XtOffset(RESPTR, draw_width), XtRImmediate, (caddr_t) DRAWWIDTH},
    {"geometry", "Geometry", XtRString, sizeof(String),
       XtOffset(RESPTR, geometry), NULL,NULL},
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

void SetTitle(menu)
int menu;
{
  Arg args[2];
  int iargs;
  char title[2 * MAXNAM];
  char icon[2 * MAXNAM];

  switch (menu) {
  case BEGIN:
    if (isServeur) {
      sprintf(title,"%s    Window %d",metanetName,theWindow);
      sprintf(icon,"Net %d",theWindow);
    } else {
      sprintf(title,"%s",metanetName);
      strcpy(icon,"Metanet");
    }
    break;
  default:
    if (isServeur) {
      sprintf(title,"%s    Window %d    Graph name: %s",
	      metanetName,theWindow,theGraph->name);
      sprintf(icon,"Net %d",theWindow);
    } else {
      sprintf(title,"%s    Graph name: %s",metanetName,theGraph->name);
      strcpy(icon,"Metanet");
    }
    break;
  }

  iargs = 0;
  XtSetArg(args[iargs], XtNtitle, title); iargs++;
  XtSetArg(args[iargs], XtNiconName, icon); iargs++;
  XtSetValues(toplevel,args,iargs);
}

static String fallback_resources[] = {NULL,NULL};

int main(argc, argv)
unsigned int argc;
char **argv;
{
  Arg args[20];
  int iargs;
  extern void ActionWhenDownMove3(); 
  extern void ActionWhenExpose(); 
  extern void ActionWhenLeave();
  extern void ActionWhenPress1(); 
  extern void ActionWhenPress3(); 
  extern void ActionWhenRelease3();
  extern void ActionWhenReturn();
  static XtActionsRec actionTable[] = {
    {"ActionWhenDownMove3", (XtActionProc) ActionWhenDownMove3},
    {"ActionWhenExpose", (XtActionProc) ActionWhenExpose},
    {"ActionWhenLeave", (XtActionProc) ActionWhenLeave},
    {"ActionWhenPress1", (XtActionProc) ActionWhenPress1},
    {"ActionWhenPress3", (XtActionProc) ActionWhenPress3},
    {"ActionWhenRelease3", (XtActionProc) ActionWhenRelease3},
    {"ActionWhenReturn", (XtActionProc) ActionWhenReturn}
  };
  GC gc, gc_clear, gc_xor;
  XGCValues gcv;
  Display *dpy;
  Drawable d;
  Pixel bg, fg;
  XFontStruct *fontstruct;
  XColor x_fg_color,x_bg_color;
  Widget look;
  int i;
  char *iniG;
  double iniS;
  float v;
  int igeci = -1;
  static char metanetgeom[200];
  XSetWindowAttributes attributes;
  int screen;
  unsigned int max_width,max_height;
  int geom_x, geom_y, dw, dh;
  XSizeHints sizehints;

  iniG = NULL;

  /* Is xmetanet called by Scilab? */

  igeci = find("-pipes",argc,argv);
  if (igeci != -1) {
    init_messages(tb_messages, atoi(argv[igeci+1]),atoi(argv[igeci+2]));
    isServeur = 1;
    for (i = igeci; i < argc - 3 ; i++) {
      if (argv[i+3] != NULL) argv[i] = argv[i+3];
      else argv[i] = NULL;
    }
    argc -= 3;
  }
  else isServeur = 0;

  /* Parse arguments when called by Scilab */
  dw = 0; dh = 0;
  if (isServeur) {
    sscanf(argv[2],"%d",&theWindow);
    iniG = argv[3];
    sscanf(argv[4],"%d",&dw);
    sscanf(argv[5],"%d",&dh);
  }
  else {
    theWindow = 0;
  }

  if (isServeur) {
    metaWidth = IMETAWIDTH;
    metaHeight = IMETAHEIGHT;
  } else {
    metaWidth = METAWIDTH;
    metaHeight = METAHEIGHT;
  }

/* Fallback ressources */

  sprintf(metanetgeom,"Metanet.geometry:+%d+%d",
          X + DX * theWindow,Y + DY * theWindow);
  fallback_resources[0]=metanetgeom;

/* Toplevel widget */

  toplevel = XtAppInitialize(&app_con, (String)"Metanet", NULL, 0, 
			     (int*)&argc, (String*)argv,
			     fallback_resources, NULL, 0);

/* Get ressources */
  XtGetApplicationResources(toplevel, &the_res, app_resources,
			    XtNumber(app_resources), NULL, 0);

  if (dw == 0 && dh == 0) {
    drawWidth = the_res.draw_width;
    drawHeight = the_res.draw_height;
  } else {
    drawWidth = dw;
    drawHeight = dh;
  }
/* Minimum 100 x 100 for Metanet draw */ 
  drawWidth = max(drawWidth,100);
  drawHeight = max(drawHeight,100);
  
  XParseGeometry(the_res.geometry,
		 &geom_x, &geom_y, &metaWidth, &metaHeight);

/* Parse xmetanet arguments */

  iniS = -1.0;
  if (!isServeur) {
    if (argc == 2) {
      if (!strcmp(argv[1],"-usage") || !strcmp(argv[1],"-help")) {
	PrintUsage();
	exit(0);
      }
      if (!strcmp(argv[1],"-version")) {
	printf("Version %s\n",Version);
	exit(0);
      }
    }
    if (argc % 2 == 1) iniG = 0;
    else iniG = argv[argc-1];
    for (i = 1; i < argc - 1; i++) {
      if (!strcmp(argv[i++],"-scale")) {
	if (sscanf(argv[i],"%g",&v) > 0)
	  if (v > 0) iniS = (double)v;
      }
      else {
	fprintf(stderr,"Bad arguments\n");
	PrintUsage();
	exit(1);
      }
    }
  }

  if (isServeur) {
    XtAppAddTimeOut (app_con,
		     TEMPS,
		     (XtTimerCallbackProc) clock_tic,
		     (XtPointer)toplevel) ;
  }
  
  XtAppAddActions(app_con,actionTable,XtNumber(actionTable));

  sprintf(metanetName,"Metanet %s",Version);

  SetTitle(BEGIN);

  dpy = XtDisplay(toplevel);
  theG.dpy = dpy;
  screen = DefaultScreen(dpy);

/* Dimension of xmetanet window */

  dpyWidth = DisplayWidth(dpy,screen);
  dpyHeight = DisplayHeight(dpy,screen);

  max_width = (int)(dpyWidth * 0.8);
  max_height = (int)(dpyHeight * 0.8);

  if (max_width < metaWidth) metaWidth = max_width;
  if (max_height < metaHeight) metaHeight = max_height;

  iargs = 0;
  XtSetArg( args[iargs], XtNheight, metaHeight); iargs++;
  XtSetArg( args[iargs], XtNwidth, metaWidth); iargs++;
  XtSetArg( args[iargs], XtNx, X); iargs++;
  XtSetArg( args[iargs], XtNy, Y); iargs++;
  XtSetArg( args[iargs], XtNdefaultDistance, 0); iargs++;
  frame = XtCreateManagedWidget( "form", formWidgetClass, toplevel,
				args, iargs);
  XtAddCallback(frame, XtNdestroyCallback, (XtCallbackProc)Destroyed, NULL );

  if ((fontstruct = XLoadQueryFont(dpy, METAFONT)) == NULL) {
    fprintf(stderr,"Font %s is unknown\n",METAFONT);
    fprintf(stderr,"I'll use font: fixed\n");
    if ((fontstruct = XLoadQueryFont(dpy, "fixed")) == NULL) {
      fprintf(stderr,"Unknown font: fixed\n");
      exit(1);
    }
  }

  theG.metafont = fontstruct;
  
  if ((fontstruct = XLoadQueryFont(dpy, HELPFONT)) == NULL) {
    fprintf(stderr,"Font %s is unknown\n",HELPFONT);
    fprintf(stderr,"I'll use font: fixed\n");
    if ((fontstruct = XLoadQueryFont(dpy, "fixed")) == NULL) {
      fprintf(stderr,"Unknown font: fixed\n");
      exit(1);
    }
  }

  theG.helpfont = fontstruct;

  CreateMenus();
  MakeDraw();
				  
  XtRealizeWidget(toplevel);

  d = XtWindow(metanetDraw);

  attributes.backing_store = Always;
  XChangeWindowAttributes(dpy,d,CWBackingStore,&attributes);

/* Window Manager size hints */
  sizehints.flags = PMinSize | USPosition | PPosition;
  sizehints.x = X + DX * theWindow;
  sizehints.y = Y + DY * theWindow;
  sizehints.min_width = MINWIDTH;
  sizehints.min_height = MINHEIGHT;
  XSetNormalHints(dpy,XtWindow(toplevel),&sizehints);

  /* get color pixels */
  for (i = 0; i < NUMCOLORS - 2; i++) Colors[i+1] = the_res.color[i];

  /* get foreground and background pixels and colors */
  XtSetArg(args[0],XtNlabel,"");
  look = XtCreateWidget("look", labelWidgetClass, toplevel, args, 1);

  XtSetArg(args[0],XtNforeground, &x_fg_color.pixel);
  XtSetArg(args[1],XtNbackground, &x_bg_color.pixel);
  XtGetValues(look,args,2);
  fg = x_fg_color.pixel;
  bg = x_bg_color.pixel;
  Colors[0] = fg;
  Colors[NUMCOLORS-1] = bg;

  XtDestroyWidget(look);

  /* GC */
  GetFonts();
  fontstruct = FontSelect(DRAWFONTSIZE);
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
  
  theG.d = d;
  theG.bg = bg;
  theG.fg = fg;
  theG.gc = gc;
  theG.gc_clear = gc_clear;
  theG.gc_xor = gc_xor;
  theG.drawfont = fontstruct;
  theG.shell = NULL;

  theColor = fg;

  InitMetanet(iniG,iniS);

  XtMapWidget(toplevel);

  XtAppMainLoop(app_con);

  exit(0);
}

static void clock_tic(client_data,id)
XtPointer client_data;
XtIntervalId id;
{
  scanner_messages();
  XtAppAddTimeOut (app_con,
		   TEMPS,
		   (XtTimerCallbackProc) clock_tic,
		   (XtPointer)toplevel);
}

static void erreur_message_msgact(message)
Message message;
{
  fprintf(stderr, "Message  recu incorrect !!!\n");
  envoyer_message_parametres_var(ID_GeCI, MSG_FIN_APPLI, NULL);
  exit(1);
}

static void quitter_appli_msgact(message)
Message message;
{  
  exit(0);
}

static int find(s,n,t)
char *s;
int n;
char **t;
{
  int i;
  for (i=0; i<n; i++)
    if (!strcmp(s,t[i])) return(i);
  return(-1);
}

static void PrintUsage()
{
  printf("Usage: xmetanet [OPTION]... GRAPH_FILE");
}

void MetanetQuit()
{
  XtUnmapWidget(toplevel);
  exit(0);
}

void GetMetanetGeometry(x,y,w,h)
int *x,*y,*w,*h;
{
  Window root,parent,*children;
  unsigned int nchildren;
  XWindowAttributes war;
  XQueryTree(theG.dpy,XtWindow(toplevel),&root,&parent,&children,&nchildren);
  if (parent != root) XGetWindowAttributes(theG.dpy,parent,&war);
  else XGetWindowAttributes(theG.dpy,XtWindow(toplevel),&war);
  *h = war.height; *w = war.width; *x = war.x; *y = war.y;
}
