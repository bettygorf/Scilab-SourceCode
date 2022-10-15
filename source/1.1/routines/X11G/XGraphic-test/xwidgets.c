
#include "../../machine.h"
#include <stdio.h>

#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>

#include <X11/Xaw/AsciiText.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Dialog.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/List.h>
#include <X11/Xaw/Logo.h>
#include <X11/Xaw/MenuButton.h>
#include <X11/Xaw/Scrollbar.h>
#include <X11/Xaw/SimpleMenu.h>
#include <X11/Xaw/SmeBSB.h>
#include <X11/Xaw/SmeLine.h>
#include <X11/Xaw/Paned.h>
#include <X11/Xaw/Toggle.h>
#include <X11/Xaw/Viewport.h>

#include <X11/Xaw/Cardinals.h>

String fallback_resources[] = { 
    "*input:                  True",
    "*Paned.width:            350",
    "*label.label:            At least one of each Athena Widget.",
    "*Dialog.label:           I am a Dialog widget.",
    "*Dialog.value:           Enter new value here.",
    "*Dialog*command*label:   ok",
    "*Dialog*resizable:       True",
    "*Viewport*allowVert:     True",
    "*Form*formLabel.label:   0",
    "*Form*resizable:       True",
    "*StripChart*update:      1",
    "*StripChart*jumpScroll:  1",
    "*Box*allowResize:        True",
    "*scrollbar*orientation:  horizontal",
    "*scrollbar*length:       100",
    "*text*height:            75",
    "*text*string:            Look ma,\\na text widget!",
    "*text*editType:          edit",
    "*text*scrollVertical:    whenNeeded",
    "*text*scrollHorizonal:   whenNeeded",
    "*textFile*type:          file",
    "*textFile*string:        /etc/motd",
    "*textFile*scrollVertical:    whenNeeded",
    "*textFile*scrollHorizonal:   whenNeeded",
    "*textFile*height:        75",
    NULL,
};

static void Destroyed(), Quit(),  Syntax(), CreateFormWithButtons();
static void  Finish();

extern int  test2D();
extern int  test2D2();
extern int  test2D3();
extern int  test2D4();
extern int  test2DN1();
extern int  test2DN2();
extern int  test2DN3();
extern int  test3D();
extern int  test3D1();
extern int  test3D2();
extern int  testArrows();
extern int  testC1();
extern int  testC2();
extern int  testC3();
extern int  testCh();
extern int  testG();
extern int  testP3D();
extern int  testPattern();
extern int  testColor();
extern int  testPrim();
extern int  testString();
extern int  testXliness();
extern int  testXrects();
extern int  testPoly();


typedef  struct  {
  char *name;
  int  (*fonc)();} OpTab ;

static int vide() {};

OpTab testtab[] ={
 "test2D", test2D,
 "test2D2", test2D2,
 "test2D3", test2D3,
 "test2D4", test2D4,
 "test2DN 1", test2DN1,
 "test2DN 2", test2DN2,
 "test2DN 3", test2DN3,
 "test3D", test3D,
 "test3D1", test3D1,
 "test3D2", test3D2,
 "testArrows", testArrows,
 "testC 1", testC1,
 "testC 2", testC2,
 "testC 3", testC3,
 "testCh", testCh,
 "testG", testG,
 "testP3D", testP3D,
 "testPattern", testPattern,
 "testColor", testColor,
 "testPrim", testPrim,
 "testString", testString,
 "testXliness", testXliness,
/*  "testXrects", testXrects,*/
 "testXrects", testPoly,
 (char *) NULL,vide};


void 
main(argc, argv)
int argc;
char **argv;
{
 void MenuSelect();
 void ResizeWindow();
 Widget toplevel, outer, dialog, box, quit, chart, list, viewport,entry;
 XtAppContext app_con;
 Arg		args[5];
 Widget button, menu;
 int i=0,n;
 
 toplevel = XtAppInitialize(&app_con, "XScilab-1.0", NULL, ZERO,
			    &argc, argv, fallback_resources,
			    NULL, ZERO);
 if (argc != 1) Syntax(app_con, argv[0]);
 XtAddCallback( toplevel, XtNdestroyCallback, Destroyed, NULL );
 outer = XtCreateManagedWidget( "paned", formWidgetClass, toplevel,
			       NULL, ZERO);
 XtAddEventHandler(outer, StructureNotifyMask , False, ResizeWindow, 
		   NULL);
 n=0;
  XtSetArg(args[n], XtNwidth, 500); n++;
  XtSetArg(args[n], XtNheight, 400); n++;
  box = XtCreateManagedWidget( "BG0", boxWidgetClass, outer, args,n);
 n=0;
 XtSetArg(args[n], XtNfromHoriz,box ); n++;
 button = XtCreateManagedWidget("menuButton", menuButtonWidgetClass, outer,
				args,n);
 menu = XtCreatePopupShell("menu", simpleMenuWidgetClass, button,NULL,ZERO);
 while ( testtab[i].name != (char *) NULL)
     {
       entry= XtCreateManagedWidget(testtab[i].name, smeBSBObjectClass, menu,
				    NULL, ZERO);
       XtAddCallback(entry,XtNcallback,MenuSelect,NULL);
       i++;
     };
  n=0;
  XtSetArg(args[n], XtNfromVert,button ); n++;
 XtSetArg(args[n], XtNfromHoriz,box ); n++;
  quit = XtCreateManagedWidget( "quit", commandWidgetClass, outer, 
			       args,n);
  XtAddCallback( quit, XtNcallback, Quit, (XtPointer) toplevel);



  XtRealizeWidget(toplevel);
  XChangeProperty(XtDisplay(box), XtWindow(box), XA_WM_NAME, XA_STRING, 8, 
		  PropModeReplace, "BG0", 5);
  XtAppMainLoop(app_con);
}



/*
 * The ResizeWindow handler for the drawbox
 * This function is called when the window need redisplay
 * 
 */

void ResizeWindow(w, number, e)
     Widget w; 
     XtPointer number;
     XConfigureEvent *e;
{
  int num=0,verbose=0,ww,narg;
  fprintf(stderr," Need redraw \n");
  /** create window if necessary **/
  C2F(dr)("xget","window",&verbose,&ww,&narg);
  C2F(dr)("xset","window",&ww);
  C2F(dr)("xclear","v");
  C2F(dr)("xreplay","v",&num);
 }


/*	Function Name: MenuSelect
 *	Description: called whenever a menu item is selected.
 *	Arguments: w - the menu item that was selected.
 *                 junk, garbage - *** unused ***.
 *	Returns: 
 */

#define streq(a, b)        ( strcmp((a), (b)) == 0 )

/* ARGSUSED */
static void
MenuSelect(w, junk, garbage)
Widget w;
XtPointer junk, garbage;
{
  static firstentry=0;
  if (firstentry==0) 
    {
      int num=0,verbose=0,ww,narg;
      SetDriver_("Rec");  
      C2F(dr)("xget","window",&verbose,&ww,&narg);
      C2F(dr)("xset","window",&ww);
      firstentry++;
    }
  else 
    {
      int num=0;
      C2F(dr)("xclear","v");
      C2F(dr)("xstart","v",&num);
    };

    if (streq(XtName(w), "test2D")) test2D();
    if (streq(XtName(w), "test2D2")) test2D2();
    if (streq(XtName(w), "test2D3")) test2D3();
    if (streq(XtName(w), "test2D4")) test2D4();
    if (streq(XtName(w), "test2DN 1")) test2DN1();
    if (streq(XtName(w), "test2DN 2")) test2DN2();
    if (streq(XtName(w), "test2DN 3")) test2DN3();
    if (streq(XtName(w), "test3D")) test3D();
    if (streq(XtName(w), "test3D1")) test3D1();
    if (streq(XtName(w), "test3D2")) test3D2();
    if (streq(XtName(w), "testArrows")) testArrows();
    if (streq(XtName(w), "testC 1")) testC1();
    if (streq(XtName(w), "testC 2")) testC2();
    if (streq(XtName(w), "testC 3")) testC3();
    if (streq(XtName(w), "testCh")) testCh();
    if (streq(XtName(w), "testG")) testG();
    if (streq(XtName(w), "testP3D")) testP3D();
    if (streq(XtName(w), "testColor")) testColor();
    if (streq(XtName(w), "testPattern")) testPattern();
    if (streq(XtName(w), "testPrim")) testPrim();
    if (streq(XtName(w), "testString")) testString();
    if (streq(XtName(w), "testXliness")) testXliness();
/*    if (streq(XtName(w), "testXrects")) testXrects();*/
    if (streq(XtName(w), "testXrects")) testPoly();
}


/*	Function Name: Syntax
 *	Description: Prints a the calling syntax for this function to stdout.
 *	Arguments: app_con - the application context.
 *                 call - the name of the application.
 *	Returns: none - exits tho.
 */

static void 
Syntax(app_con, call)
XtAppContext app_con;
char *call;
{
    XtDestroyApplicationContext(app_con);
    fprintf(stderr, "Usage: %s\n", call);
    exit(1);
}


/*	Function Name: Quit
 *	Description: Destroys all widgets, and returns.
 *	Arguments: widget - the widget that called this callback.
 *                 closure, callData - *** UNUSED ***.
 *	Returns: none
 * 
 * NOTE:  The shell widget has a destroy callback that sets a five second
 *        timer, and at the end of that time the program exits.
 */

/* ARGSUSED */
static void 
Quit(widget,closure,callData)
Widget widget;
XtPointer closure, callData;
{
    fprintf(stderr, "command callback.\n");
    XtDestroyWidget((Widget)closure);
}


/*	Function Name: Finish
 *	Description: This is a timeout function that will exit the program.
 *	Arguments: client_data, id - *** UNUSED ***.
 *	Returns: exits.
 */

/* ARGSUSED */
static void
Finish(client_data, id)
XtPointer client_data;
XtIntervalId *id;
{
    /*
     * I should really destroy the app_context here, but I am lazy, and
     * getting the app_context is a pain.
     */
    fprintf(stderr, "Bye!\n");
    exit(0);
}

/*	Function Name: Destroyed
 *	Description: This is a Destroy callback that when called sets a 
 *                   timeout function that will exit the program in 5 seconds.
 *	Arguments: widget - the widget that was just destroyed.
 *                 closure, callData - UNUSED.
 *	Returns: none.
 */

/* ARGSUSED */
static void 
Destroyed(widget, closure, callData)
Widget widget;
XtPointer closure, callData;		
{
    fprintf( stderr, "Everything now destroyed; setting 5 second timer.\n" );
    XtAppAddTimeOut(XtWidgetToApplicationContext(widget), 5000, Finish, NULL);
}


