#include <stdio.h>

#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>

#include <X11/Xaw/Label.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Cardinals.h>

#define NUMCOLORS 17

typedef struct res {
    Pixel color[NUMCOLORS];
} RES, *RESPTR;

RES the_res;

static XtResource app_resources[] = {
    {"color0", "Color0", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[0]), XtRString, (caddr_t) "black"},
    {"color1","color1", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[1]), XtRString, (caddr_t) "navyblue"},
    {"color2","color2", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[2]), XtRString, (caddr_t) "blue"},
    {"color3","color3", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[3]), XtRString, (caddr_t) "skyblue"},
    {"color4","color4", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[4]), XtRString, (caddr_t) "aquamarine"},
    {"color5","color5", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[5]), XtRString, (caddr_t) "forestgreen"},
    {"color6","color6", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[6]), XtRString, (caddr_t) "green"},
    {"color7","color7", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[7]), XtRString, (caddr_t) "lightcyan"},
    {"color8","color8", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[8]), XtRString, (caddr_t) "cyan"},
    {"color9","color9", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[9]), XtRString, (caddr_t) "orange"},
    {"color10","color10", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[10]), XtRString, (caddr_t) "red"},
    {"color11","color11", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[11]), XtRString, (caddr_t) "magenta"},
    {"color12","color12", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[12]), XtRString, (caddr_t) "violet"},
    {"color13","color13", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[13]), XtRString, (caddr_t) "yellow"},
    {"color14","color14", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[14]), XtRString, (caddr_t) "gold"},
    {"color15","color15", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[15]), XtRString, (caddr_t) "beige"},
    {"color16","color16", XtRPixel, sizeof(Pixel),
    XtOffset(RESPTR, color[16]), XtRString, (caddr_t) "white"},
};

Widget toplevel;
XtAppContext app_con;


static String fallback_resources[] = {
    "*allowShellResize:                 True",
    "*font:                             9x15",
    NULL,
  };

DisplayInit(string,dpy,fg,bg)
  Display **dpy;
  unsigned long *fg,*bg;
  char *string;
{
  static Display *dpy1;
  static unsigned long fg1,bg1;
  static int count=0;
  int argc=0;
  char *argv;
  Arg args[2];
  XColor x_fg_color,x_bg_color;
  static Widget look;
  if ( count > 0) 
    {
      *dpy=dpy1;
      *fg=fg1;
      *bg=bg1;
      return;
    };
  count++;
  /*------- decomposition de  XtAppInitialize pour utiiser string 
   Un peu lourd sans doute */
  XtToolkitInitialize();
  app_con=XtCreateApplicationContext();
  XtAppSetFallbackResources(app_con,fallback_resources);
  if ( string == (char *)NULL || string[0]==' ' ||strcmp(string,"unix:0.0")==0)
    *dpy=dpy1=XtOpenDisplay(app_con,(char *)NULL,"XScilab","XScilab",
		       NULL,ZERO,&argc,&argv);
  else 
    {
      *dpy=dpy1=XtOpenDisplay(app_con,string,"XScilab","XScilab",
			      NULL,ZERO,&argc,&argv);
      if ( dpy1 == 0) /** if string is a wrong  display i try with default */
	*dpy=dpy1=XtOpenDisplay(app_con,(char *)NULL,"XScilab","XScilab",
		       NULL,ZERO,&argc,&argv);
    }
  if ( dpy1 == 0) { exit(1);};
  toplevel=XtAppCreateShell("xsg","XScilab",applicationShellWidgetClass,*dpy,
		   NULL,ZERO);
  /*------- fin de  XtAppInitialize  */
  XtGetApplicationResources(toplevel, &the_res, app_resources,
			    XtNumber(app_resources), NULL, 0);
  /* get foreground and background pixels and colors */
  XtSetArg(args[0],XtNlabel, "");
  look = XtCreateWidget("scigraphic", labelWidgetClass, toplevel, args, 0);
  XtSetArg(args[0],XtNforeground, &x_fg_color.pixel);
  XtSetArg(args[1],XtNbackground, &x_bg_color.pixel);
  XtGetValues(look,args,2);
  *fg= fg1 = x_fg_color.pixel;
  *bg= bg1 = x_bg_color.pixel;
  XtDestroyWidget(look);
  XSync(dpy1,0);
  /** xutl_(*dpy); **/
};

/*****************
Remarque : cette fonction est appelles par la fonction au dessus 
je m'en sert sur sun pour generer le tableau postscript qui decrit 
les couleurs X11 utilisees puis ce tableau a ete mis de facon permanente 
dans NperiPos.pos et la fonction ColorInit de periPos.c commentee 
ainsi on peut genere de la couleur sur une machine noir et blanc 
et l'appel a xutl et recomente car il fait parfois planter 

********************/

typedef  struct {
  float  r,g,b;} TabC;

TabC tabc[NUMCOLORS];

xutl_(dpy)
     Display *dpy;
{
  Screen   *scr;      
  int  status,i;
  XColor xcolor;
  scr = DefaultScreenOfDisplay(dpy);
  for (i=0 ; i < NUMCOLORS ; i++)
    {
      xcolor.pixel = the_res.color[i];
      XQueryColor(dpy, DefaultColormapOfScreen(scr), &xcolor);
      tabc[i].r = xcolor.red / 65535.0   ;
      tabc[i].g = xcolor.green / 65535.0 ;
      tabc[i].b = xcolor.blue /  65535.0 ;
  }
};


