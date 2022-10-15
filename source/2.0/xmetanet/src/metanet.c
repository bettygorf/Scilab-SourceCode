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

/* Table des messages reconnus par xmetanet */

static void quitter_appli_msgact();  
extern void GetMsg();
static void erreur_message_msgact(); 

actions_messages tb_messages[]={
    {ID_GeCI,MSG_QUITTER_APPLI,NBP_QUITTER_APPLI,quitter_appli_msgact},
    {NULL,MSG_DISTRIB_LISTE_ELMNT,NBP_DISTRIB_LISTE_ELMNT,GetMsg},
    {NULL,NULL,0,erreur_message_msgact}};

static void clock_tic();   
static int find();

extern void CreateMenus();
extern void InitMetanet();
extern void MakeDraw();
extern void GetFonts();
extern XFontStruct *FontSelect();

char metanetName[MAXNAM];
char *Version = "2.4";
int metaFormat = 241;

int isServeur;
int theWindow;

int metaWidth = METAWIDTH;
int metaHeight = METAHEIGHT;

int viewHeight = VIEWHEIGHT;
int drawHeight = DRAWHEIGHT;
int drawWidth = DRAWWIDTH;

int arcW;
int arcH;
int nodeW;
int nodeDiam;

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
  Arg args[1];
  int iargs;
  char str[2 * MAXNAM];

  switch (menu) {
  case BEGIN:
    if (isServeur) {
      sprintf(str,"%s    Window %d",metanetName,theWindow);
    } else {
      strcpy(str,metanetName);
    }
    break;
  default:
    if (isServeur) {
      sprintf(str,"%s    Window %d    Graph name: %s",
	      metanetName,theWindow,theGraph->name);
    } else {
      sprintf(str,"%s    Graph name: %s",metanetName,theGraph->name);
    }
    break;
  }

  iargs = 0;
  XtSetArg( args[iargs], XtNtitle, str); iargs++;
  XtSetValues(toplevel,args,iargs);
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
  int isLocal;
  XColor x_fg_color,x_bg_color;
  Widget look;
  int i;
  char *iniG;
  int igeci = -1;
  int idata = -1;
  static String fallback_resources[] = 
    {"Metanet.geometry:1000x1000+1000+1000",NULL};

  iniG = NULL;
  strcpy(datanet,"");

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

  if (isServeur) {
    sscanf(argv[2],"%d",&theWindow);
  }
  else {
    theWindow = 0;
  }

  idata = find("-data",argc,argv);
  if (idata != -1) {
    strcpy(datanet,argv[idata+1]);
    for (i = idata; i < argc - 2 ; i++) {
      if (argv[i+2] != NULL) argv[i] = argv[i+2];
      else argv[i] = NULL;
    }
    argc -= 2;
  } 

  sprintf(fallback_resources[0],"Metanet.geometry:%dx%d+%d+%d",
	  metaWidth,metaHeight,
	  X + DX * theWindow,Y + DY * theWindow);

  toplevel = XtAppInitialize(&app_con, (String)"Metanet", NULL, 0, 
			     (int*)&argc, (String*)argv,
			     fallback_resources, NULL, 0);

  if (!isServeur) {
    switch(argc) {
    case 1:
      break;
    case 2:
      fprintf(stderr,"Bad number of arguments\n");
      exit(1);
      break;
    case 3:
      if (strcmp("-graph",argv[1]) == 0) {
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
  }

  if (isServeur) {
    XtAppAddTimeOut (app_con,
		     TEMPS,
		     (XtTimerCallbackProc) clock_tic,
		     (XtPointer)toplevel) ;
    }

  XtAppAddActions(app_con,actionTable,actions);

  sprintf(metanetName,"Metanet %s",Version);

  SetTitle(BEGIN);

  iargs = 0;
  XtSetArg( args[iargs], XtNheight, metaHeight); iargs++;
  XtSetArg( args[iargs], XtNwidth, metaWidth); iargs++;
  XtSetArg( args[iargs], XtNx, X); iargs++;
  XtSetArg( args[iargs], XtNy, Y); iargs++;
  XtSetArg( args[iargs], XtNdefaultDistance, 0); iargs++;
  frame = XtCreateManagedWidget( "form", formWidgetClass, toplevel,
				args, iargs);
  XtAddCallback(frame, XtNdestroyCallback, (XtCallbackProc)Destroyed, NULL );

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

  theG.dpy = dpy;

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

  InitMetanet(iniG);

  DisplayMenu(BEGIN); 

  XtMapWidget(toplevel);

  XtAppMainLoop(app_con);

  return 0;
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
