#include <stdio.h>			/* For the Syntax message */
#include <signal.h>

#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/Cardinals.h>
#include <X11/Xaw/Paned.h>
#include <X11/Xaw/Grip.h>
#include <X11/Xaw/MenuButton.h>
#include <X11/Xaw/SimpleMenu.h>
#include <X11/Xaw/SmeBSB.h>
#include <X11/Xaw/SmeLine.h>

#include <string.h>
#include <malloc.h>

#include "Math.h"

/*---------------------------------------------------------------
  Functions and buttons associated with the Graphic Scilab Window 
-----------------------------------------------------------------*/

static XtCallbackProc  Efface(),Print(),Test(),Save(),Zoom(),UnZoom(),Rot3D();
static XtCallbackProc  Delete(),SavePs(),Load();

static XtEventHandler EventProc(),EventProc1();
static XtEventHandler ResizeWindow();
static char popupname[sizeof("ScilabGraphic")+4];
int demo_menu_activate=0;


static Arg args[10] ;
static iargs=0;

/*
 * Fixes hints for the graphic windows (min sizes and wm delete window flag)
 */

static SetHints(topW)
     Widget topW;
{
 XSizeHints		size_hints;
 Atom		wmDeleteWindow;
 size_hints.width	= 400;
 size_hints.height	= 300;
 size_hints.min_width   =  size_hints.width ;
 size_hints.min_height  =  size_hints.height ;
 size_hints.flags = USPosition | USSize | PMinSize;
 XSetNormalHints(XtDisplay(topW),XtWindow(topW), &size_hints);
 /*
  *  Add a protocol flag indicating we wish to handle
  *  WM_DELETE_WINDOW requests (in fact we ignore it)
  */
 wmDeleteWindow = XInternAtom(XtDisplay(topW), "WM_DELETE_WINDOW", False);
 XSetWMProtocols(XtDisplay(topW),XtWindow(topW),&wmDeleteWindow, 1);
}

/*
 * Creates a new graphic window 
 */

#define DEFAULT_MES "graphic window"



static int
AddNewWin(popup,popupc,drawbox,infowidget)
     Widget popup,*drawbox,*infowidget;
     int popupc;
{
  Widget outer,zoom,rot3d,unzoom;
  Widget filebutton,filemenu,clear,prnt,save,load,delete,saveps;
  iargs=0;
  outer = XtCreateManagedWidget( "scigForm", formWidgetClass,popup,
				  args, iargs);
  iargs=0;
  XtSetArg(args[iargs], XtNlabel," ");iargs++;
  *infowidget= XtCreateManagedWidget("scigraphicinfo",labelWidgetClass, 
				     outer, args, iargs);
  /* Menu File */
  iargs=0;
  filebutton = XtCreateManagedWidget("File",
				  menuButtonWidgetClass,outer,args, iargs);
  iargs=0;
  filemenu = XtCreatePopupShell("menu", simpleMenuWidgetClass, 
			    filebutton,args, iargs);
  iargs=0;
  clear = XtCreateManagedWidget("Clear", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(clear, XtNcallback,(XtCallbackProc) Efface,(XtPointer) popupc); 
  prnt = XtCreateManagedWidget("Print...", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(prnt, XtNcallback,(XtCallbackProc)  Print,(XtPointer) popupc);
  saveps = XtCreateManagedWidget("Export...", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(saveps, XtNcallback,(XtCallbackProc)  SavePs,(XtPointer)popupc);
  save = XtCreateManagedWidget("Save...", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(save, XtNcallback,(XtCallbackProc)  Save,(XtPointer)popupc);
  load = XtCreateManagedWidget("Load...", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(load, XtNcallback,(XtCallbackProc)  Load,(XtPointer)popupc);

  delete = XtCreateManagedWidget("Close", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(delete, XtNcallback,(XtCallbackProc)  Delete,(XtPointer)popupc);

  
  /* Other buttons */
  zoom = XtCreateManagedWidget("Zoom", commandWidgetClass,outer,args, iargs);
  XtAddCallback(zoom, XtNcallback,(XtCallbackProc)  Zoom,
		(XtPointer) popupc);
  unzoom = XtCreateManagedWidget("UnZoom", commandWidgetClass,outer,args, iargs);
  XtAddCallback(unzoom, XtNcallback,(XtCallbackProc)  UnZoom,
		(XtPointer) popupc);
  rot3d = XtCreateManagedWidget("Rot3D", commandWidgetClass,outer,args, iargs);
  XtAddCallback(rot3d, XtNcallback,(XtCallbackProc) Rot3D,
		(XtPointer) popupc);

  /* I use a label in order to have foreground and background */
  iargs=0;
  XtSetArg(args[iargs], XtNlabel," ");iargs++;
  *drawbox= XtCreateManagedWidget("scigraphic",labelWidgetClass, outer, args, iargs);
  /* EventProc Must select the client Message Events */
  
  XtAddEventHandler(*drawbox, StructureNotifyMask , False, 
		    (XtEventHandler)ResizeWindow, 
		    (XtPointer) popupc);
  XtAddEventHandler(*drawbox, ExposureMask,False,(XtEventHandler) EventProc1,
		    (XtPointer) popupc);  

  /* even if EventProc is unsued by xclick or xgetmouse : the next line 
     set the proper mask for the drabox window and this is necessary for 
     xclick and xgetmouse to work moreover this EventHandler keep the 
     queue of unused ButtonPress ok 
  */

  XtAddEventHandler(*drawbox, ButtonPressMask|PointerMotionMask|ButtonReleaseMask|
		    KeyPressMask,False,
		    (XtEventHandler) EventProc, (XtPointer) popupc);
  /* For Graphic demo */
  if ( demo_menu_activate==1 ) 
    AddNewMenu(outer,*drawbox);
}

/* 
 * Checking events in the Graphic Window 
 * in fact just the XtAddEventHandler is used 
 * used in xclick 
 */

extern void asynchron();

static XtEventHandler
EventProc(widget, number , event)
    Widget widget;
    XtPointer number;
    XEvent *event;
{
    char str[100];
    int rep;

    int num= (int) number;
    /* sciprint("Je suis ds EventProc\n"); */
    switch (event->type) 
      {
      case  MotionNotify:
	break;
      case ButtonPress :
	C2F(gasync)(&num,&rep);
	if (rep==1) {
	  /* 
	    int npt=1;
	    C2F(echelle2d)(x,y,&x1,&y1,&npt,&npt,rect,"i2f",3L);
	    */
	  sprintf(str,"G_handler%d(1,%d,%d);",num,event->xbutton.x,event->xbutton.y);
	  asynchron(str);
	}
	break;
    default:
	/*	    sciprint("Je suis ds EventProc fenetre %d\r\n",num);*/
	return;
      }
  }

extern char GetDriver_();

static XtEventHandler
EventProc1(widget, number , event)
     Widget widget;
     XtPointer number;
     XEvent *event;
{
  integer win_num= (integer) number;
  XExposeEvent *event1;
  switch (event->type) 
    {
    case Expose :
      /* normalement on ne pas la que si le serveur ne sait pas faire de backing store */
      event1= (XExposeEvent *) event;
      /** fprintf(stderr,"Expose Event : count %d x %d y %d width %d height %d\n",
	      event1->count ,event1->x,event1->y,event1->width,event1->height);
	      **/
      if ( event1->count == 0) 
	{
	  integer verb=0,cur,na;
	  char name[4];
	  GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
	  if ( (GetDriver_()) !='R') 
	    SetDriver_("Rec",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
	  C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
	  C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);    
	  C2F(dr)("xreplay","v",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	}
      break;
    case VisibilityNotify :
      /* normalement on ne pas la que si le serveur ne sait pas faire de 
	 save_under */
      fprintf(stderr,"Visibility change\n");
      break;
    default:
      sciprint("Je suis ds EventProc1 fenetre %d\r\n",(int) win_num);
      return;
    }
}


/*
 * The ResizeWindow handler for the drawbox
 * This function is called when the window need redisplay
 * 
 */



static XtEventHandler ResizeWindow(w, number, e)
     Widget w; 
     XtPointer number;
     XConfigureEvent *e;
{
  XEvent event;
  integer win_num= (integer) number;
  integer verb=0,cur,na;
  if (e->type != ConfigureNotify) return;
  {
    char name[4];
    GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
    if ( (GetDriver_()) !='R') 
      SetDriver_("Rec",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
    C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
    C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    CPixmapResize1();
    C2F(dr)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);    
    C2F(dr)("xreplay","v",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  }
  /* I don't want to have Expose event after resizing **/

  while (XCheckWindowEvent(XtDisplay(w),XtWindow(w),ExposureMask,&event)==True)
	 { 
	   /** fprintf(stderr,"Encore un Expose \n"); **/
	 }
}
  

/*
 *
 * To clear the graphic window and clear the recorded graphics 
 * w and client_data are unused 
 * 
 */

static XtCallbackProc
Efface(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  integer verb=0,cur,na;
  char name[4];
  GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if ( (GetDriver_()) !='R') SetDriver_("Rec",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
  C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xstart","v",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}


/*
 * Delete Window 
 */

static XtCallbackProc
Delete(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  Efface((Widget) 0, number, (XtPointer) 0);
  DeleteSGWin(win_num);
}

/* for Fortran call */

C2F(deletewin)(number) 
     integer *number;
{
  Delete((Widget) 0,*number,(XtPointer) 0);
}


int Test_Flag=0;

static XtCallbackProc
Test(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  Scistring("Activation\n");
  Test_Flag=1;
}

/*
 * Replot in Postscript style 
 * 
 */


static char bufname[50];

static XtCallbackProc
Print(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  integer colored,orientation,flag=1,ok;
  integer verb=0,cur,na;
  integer zero=0,un=1;
  char name[4];
  char printer[20];
  char file[100];

  prtdlg(&flag,printer,&colored,&orientation,file,&ok);
  if (ok==1) {
    GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
    C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
    C2F(dr)("xsetdr","Pos",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      sprintf(bufname,"/tmp/.scilab_%d/scilab-%d",getpid(),win_num);
      C2F(dr)("xinit",bufname,&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if (colored==1) 
	  C2F(dr)("xset","use color",&un,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      else
	  C2F(dr)("xset","use color",&zero,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xreplay","v",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xend","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if (orientation==1) 
	  sprintf(bufname,"$SCI/bin/scilab -print_l /tmp/.scilab_%d/scilab-%d %s",getpid(),win_num,printer);
      else
	  sprintf(bufname,"$SCI/bin/scilab -print_p /tmp/.scilab_%d/scilab-%d %s",getpid(),win_num,printer);
      system(bufname);
  }
}

static XtCallbackProc
SavePs(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  char printer[20];
  char file[100];
  integer win_num = (integer) number ;
  integer colored,orientation,flag=2,ok;
  integer verb=0,cur,na;
  integer zero=0,un=1;
  char name[4];
  prtdlg(&flag,printer,&colored,&orientation,file,&ok);
  if (ok==1) {
    GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if (strcmp(printer,"Postscript")==0)
	  C2F(dr)("xsetdr","Pos",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      else if (strcmp(printer,"Postscript-Latex")==0)
	  C2F(dr)("xsetdr","Pos",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      else if (strcmp(printer,"Xfig")==0)
	  C2F(dr)("xsetdr","Fig",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xinit",file,&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if (colored==1) 
	  C2F(dr)("xset","use color",&un,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      else
	  C2F(dr)("xset","use color",&zero,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xreplay","v",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xend","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if (orientation==1) 
	  sprintf(bufname,"$SCI/bin/scilab -save_l %s %s",file,printer);
      else
	  sprintf(bufname,"$SCI/bin/scilab -save_p %s %s",file,printer);
      system(bufname);
  }
}
/* save a graph in a binary file */
static XtCallbackProc
Save(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  char filename[120];
  integer win_num = (integer) number ;
  int ok;
  static String buttonname[] = {
      "OK",
      "Cancel",
      NULL
  };
  strcpy(filename," ");
  xdialg1("Set file name",filename,buttonname,filename,&ok);
  if (ok==1) {
      C2F(xsaveplots)(&win_num,filename);
  }
}

/* Load a file from a  binary file */

static XtCallbackProc
Load(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  char filename[120];
  integer win_num = (integer) number ;
  int ok;
  integer verb=0,cur,na;
  static String buttonname[] = {
      "OK",
      "Cancel",
      NULL
  };
  strcpy(filename," ");
  xdialg1("Set file name",filename,buttonname,filename,&ok);
  if (ok==1) {
      C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
      C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(xloadplots)(filename);
      C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  }
}

/*
 * Inhinit zoom,unoom,rot3d 
 */

/*
 * 2D Zoom 
 * 
 */

static XtCallbackProc
Zoom(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  integer verb=0,cur,na;
  char name[4];
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive, False); iargs++;
  XtSetValues(w, args, iargs);
  GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if ( (GetDriver_()) !='R') 
    {
      wininfo("Zoom works only with the Rec driver");
    }
  else 
    {
      C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
      C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      zoom();
      C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      iargs = 0;
    }
  XtSetArg(args[iargs], XtNsensitive,True); iargs++;
  XtSetValues(w, args, iargs);
}

static XtCallbackProc
UnZoom(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  integer verb=0,cur,na;
  char name[4];
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive, False); iargs++;
  XtSetValues(w, args, iargs);
  GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if ( (GetDriver_()) !='R') 
    {
      wininfo("UnZoom works only with the Rec driver");
    }
  else 
    {
      C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
      C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      unzoom();
      C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive,True); iargs++;
  XtSetValues(w, args, iargs);
}

static XtCallbackProc
Rot3D(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  integer verb=0,cur,na;
  char name[4];
  iargs=0;
  XtSetArg(args[iargs], XtNsensitive, False); iargs++;
  XtSetValues(w, args, iargs);
  GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if ( (GetDriver_()) !='R') 
    {
      wininfo("Rot3D works only with the Rec driver");
    }
  else 
    {
      C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
      C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      I3dRotation();
      C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive,True); iargs++;
  XtSetValues(w, args, iargs);
}

/*	Function Name: CreatePopupWindow
 *	Description: Creates and pops up the New Graphic Window
 *      Returns the graphic window id (CWindow) and the window of the top level widget (SciGWindow)
 *      and the info widget associated with the graphic window 
 */

/*
 * DeleteWindow(): Action proc to implement ICCCM delete_window.
 */

void
SGDeleteWindow(w, event, params, num_params)
    Widget w;
    XEvent *event;
    String *params;
    Cardinal *num_params;
{
  /** 
    A finir : si on envoitun message delete a la fenetre graphique 
    a partir du WManager 
    **/
}

static String sg_trans =
"<Message>WM_PROTOCOLS: SGDeleteWindow()\n\
     <ClientMessage>WM_PROTOCOLS: SGDeleteWindow()\n";

CreatePopupWindow(WinNum,button, CWindow,SciGWindow,fg,bg,infowidget)
     integer WinNum;
     Widget	button,*infowidget;		
     Window *CWindow,*SciGWindow;
     unsigned long *fg,*bg;
{
    Widget	popup,drawbox;
    XColor x_fg_color,x_bg_color;
    static XSetWindowAttributes attributes;
    unsigned char winname[6];
    iargs=0;
    XtSetArg(args[iargs], XtNx, 100+20*WinNum);	iargs++;
    XtSetArg(args[iargs], XtNy, 100+20*WinNum);	iargs++;
    sprintf(popupname,"ScilabGraphic%d",WinNum);
    XtSetArg(args[iargs],XtNtitle,popupname);iargs++;
    popup = XtCreatePopupShell(popupname,
			       wmShellWidgetClass, button, args, iargs);
    AddNewWin(popup,(int) WinNum,&drawbox,infowidget);
    XtPopup(popup, XtGrabNone);
    SetHints(popup);

    sprintf((char *)winname,"BG%d",WinNum);
    XChangeProperty(XtDisplay(drawbox), XtWindow(drawbox), XA_WM_NAME, XA_STRING, 8, 
		    PropModeReplace, winname, 5);
    attributes.backing_store = Always;
    attributes.bit_gravity = NorthWestGravity;
    XChangeWindowAttributes(XtDisplay(drawbox), XtWindow(drawbox),
			    CWBackingStore | CWBitGravity,&attributes);
    XSync(XtDisplay(popup),0);
    *CWindow=XtWindow(drawbox);
    *SciGWindow=XtWindow(popup);
    XtOverrideTranslations(popup, XtParseTranslationTable(sg_trans));
    /*  Getting the values of foreground and background */
    XtSetArg(args[0],XtNforeground, &x_fg_color.pixel);
    XtSetArg(args[1],XtNbackground, &x_bg_color.pixel);
    XtGetValues(drawbox,args,2);
    *fg = x_fg_color.pixel;
    *bg = x_bg_color.pixel;
}

/*--------------------------------------------------------------
  Add dynamically buttons and menus in The Scilab Graphic Window
  or in the Scilab main window 
----------------------------------------------------------------*/

typedef struct {
    char   *button_name; /* button label */
    int    win_num;      /* graphic window number or -1 for main window */
    int    entry;        /* clicked sub_menu number */
    int    type;         /* interpreded action (0), hard coded action(1) */
    char   *fname;       /* name of the action function  */
} MenuData,*MenuDataPtr; 
static MenuData *menudatas  = (MenuData *) NULL;
static integer menuhit=0;

extern Widget commandWindow;
extern void  C2F(xscion)();

static XtCallbackProc
KillButton(w, client_data, call_data)
     Widget w;
     caddr_t call_data;
     XtPointer client_data;
{
    MenuDataPtr datas;
    datas=(MenuDataPtr)client_data;
    FREE(datas->button_name);
    FREE(datas);
}
/** callBack associated to a click in a user defined menu **/
static XtCallbackProc
SelMenu(w, client_data, call_data)
     Widget w;
     caddr_t call_data;
     XtPointer client_data;
{
    char ins[100];
    MenuDataPtr datas;
    datas=(MenuDataPtr)client_data;

    
    if (datas->type==0) { /* interpreted mode */
	if (get_is_reading()) { /* prompt level immediate execution */
	    sprintf(ins,"execstr(%s(%d))\n",datas->fname,datas->entry+1);
	    write_scilab(ins);
	}
	else { 
	    /* scilab is working, store action and submit it to the interpreter */
	    menudatas=(MenuDataPtr) MALLOC(sizeof(MenuData));
	    if (menudatas != (MenuDataPtr) 0) {
		menudatas->button_name= (char *)MALLOC((strlen(datas->button_name))*(sizeof(char)));
		if (menudatas->button_name != (char *) 0 && menuhit == (integer) 0) {
		    strcpy(menudatas->button_name,datas->button_name);
		    menudatas->win_num=datas->win_num;
		    menudatas->entry=datas->entry;
		    menudatas->type=datas->type;
		    menudatas->fname=datas->fname;
		    menuhit=1; /* to require interpeter */
		}
	    }
	}
    
    }
    else { /* hard coded mode */
	F2C(fbutn)((datas->fname),&(datas->win_num),&(datas->entry));
    }
}
/*
  Delete the button named button_name in window 
  number win_num
*/

integer 
C2F(delbtn)(win_num,button_name)
     integer *win_num;
     char *button_name;
{  
  int number;
  Cardinal nc;
  WidgetList childs;
  Widget popup,outer,command,toplevel,h,v,w;
  char popupname[sizeof("ScilabGraphic")+4];
  static Display *dpy = (Display *) NULL;
  int Gpredefined=4; /* number of predefined buttons in Graphic windows */
  int Mpredefined=5; /* number of predefined buttons in Main Window*/
  int predefined,InMainWin,i,pos;

  DisplayInit("",&dpy,&toplevel);
  number=*win_num;
  if (number==-1) {
      outer = commandWindow;
      InMainWin=1;
  }
  else {
    sprintf(popupname,"ScilabGraphic%d",number);
    popup=XtNameToWidget(toplevel,popupname);
    if (popup==NULL) return(-1);
    outer=XtNameToWidget(popup,"scigForm");
    InMainWin=0;
  }
  iargs=0;
  XtSetArg(args[iargs], XtNnumChildren, &nc);    iargs++;
  XtSetArg(args[iargs], XtNchildren, &childs);   iargs++;
  XtGetValues(outer, args, iargs);

  command=XtNameToWidget(outer,button_name);
  if (command==NULL) return(0);
  /* get position in widget list */
  for (i=0;i<nc;i++) 
      if (command==childs[i]) pos=i+1;
  if (pos==nc) { /* if last simply destroy it */
      XtDestroyWidget(command);
      return(0);
  }
  iargs=0;
  XtSetArg(args[iargs], XtNfromHoriz,&h);    iargs++;
  XtSetArg(args[iargs], XtNfromVert,&v);     iargs++;
  XtGetValues(command, args, iargs);
  /* reconstruct next widget layout */
  iargs=0;
  XtSetArg(args[iargs], XtNfromHoriz,h);    iargs++;
  XtSetValues(childs[pos], args, iargs);

  if (v!=NULL) {
      iargs=0;
      XtSetArg(args[iargs], XtNfromVert,v);    iargs++;
      XtSetValues(childs[pos], args, iargs);
      for (i=pos+1;i<nc;i++) {
	  iargs=0;
	  XtSetArg(args[iargs], XtNfromVert,&w);     iargs++;
	  XtGetValues(childs[i], args, iargs);
	  if (w==command) {
	      iargs=0;
	      XtSetArg(args[iargs], XtNfromVert,v);     iargs++;
	      XtSetValues(childs[i], args, iargs);
	  }
      }
   }
  /* destroy widget */
  if (command!=NULL)
    XtDestroyWidget(command);
  return(0);
}

/*
   Add a menu in  window  number wun_num or in Main window
   win_num     : graphic window number or -1 for main scilab window
   button_name : label of button
   entries     : labels of submenus if any
   ne          : number of submenus
   typ         : Action mode
                 typ==0 : interpreted (execution of scilab instruction
                 typ!=0 : hard coded a routine is called
   fname;      : name of the action function  
*/

int  
AddMenu(win_num,button_name,entries,ne,typ,fname,ierr)
     integer *win_num,*ne,*ierr,*typ;
     char *button_name,*fname;
     char **entries;
{  
  int number,newline,i;
  Cardinal nc;
  WidgetList childs;
  Widget popup,outer,command,w,menu,entry,toplevel;
  char popupname[sizeof("ScilabGraphic")+4];
  Position x;
  Dimension width,height,mainwidth,mainheight,bw;
  XFontStruct     *temp_font;
  char *btn,*func;
  MenuDataPtr datas;
  int Gpredefined=4; /* number of predefined buttons in Graphic windows */
  int Mpredefined=5; /* number of predefined buttons in Main Window*/
  int predefined,InMainWin;
  static Display *dpy = (Display *) NULL;
  DisplayInit("",&dpy,&toplevel);
  number=*win_num;
  InMainWin=0;
  if (number==-1) 
    {
      outer = commandWindow;
      InMainWin=1;
      predefined=Mpredefined;
    }
  else 
    {
      sprintf(popupname,"ScilabGraphic%d",number);
      popup=XtNameToWidget(toplevel,popupname);
      outer=XtNameToWidget(popup,"scigForm");
      predefined=Gpredefined;
    }
  iargs=0;
  XtSetArg(args[iargs], XtNnumChildren, &nc);    iargs++;
  XtSetArg(args[iargs], XtNchildren, &childs);   iargs++;
  XtGetValues(outer, args, iargs);
  if (InMainWin==0)
      if(nc==predefined+2) nc=nc-1;
  iargs=0;
  XtSetArg(args[iargs], XtNx,&x);             iargs++;
  XtSetArg(args[iargs], XtNwidth,&width);     iargs++;
  XtSetArg(args[iargs], XtNheight,&height);     iargs++;
  XtSetArg(args[iargs],XtNfont, &temp_font);  iargs++;
  XtGetValues(childs[nc-1], args, iargs);
  iargs=0;
  XtSetArg(args[iargs], XtNwidth,&mainwidth);       iargs++;
  XtSetArg(args[iargs], XtNheight,&mainheight);       iargs++;
  XtGetValues(outer, args, iargs);
  
  bw=strlen(button_name)*((temp_font)->max_bounds.width);
  newline=0;
  w=childs[0];
 if ( (Dimension) (width+bw+x)  < mainwidth)
    {
      iargs=0;
      XtSetArg(args[iargs], XtNfromVert,&w);  iargs++;
      XtGetValues(childs[nc-1], args, iargs);
      iargs=0;
      XtSetArg(args[iargs], XtNfromHoriz,childs[nc-1]);  iargs++;
      XtSetArg(args[iargs], XtNfromVert,w);  iargs++;
    }
  else
    {
      newline=1;
      iargs=0;
      XtSetArg(args[iargs], XtNfromVert,childs[nc-1]);  iargs++;
    }
  
  btn=(char *) MALLOC( (strlen(button_name)+1)*(sizeof(char)));
  if ( btn == ( char *) 0 ) 
    {
      *ierr=1 ;return;
    }
  strcpy(btn,button_name);
  func=(char *) MALLOC( (strlen(fname)+1)*(sizeof(char)));
  if ( func == ( char *) 0 ) 
    {
      *ierr=1 ;return;
    }
  strcpy(func,fname);

  XtSetArg(args[iargs], XtNheight,height);     iargs++;
  if (*ne==0) {
    command = XtCreateManagedWidget(button_name,
				    commandWidgetClass,outer,args, iargs);
    datas= (MenuDataPtr) MALLOC(sizeof(MenuData) );
    if ( datas == (MenuDataPtr) 0) 
      {
	*ierr=1 ;return;
      }
    datas->button_name=btn;
    datas->win_num=number;
    datas->entry=0;
    datas->type=*typ;
    datas->fname=func;
    XtAddCallback(command, XtNcallback,(XtCallbackProc) SelMenu,
		  (XtPointer)datas);
    XtAddCallback(command, XtNdestroyCallback,(XtCallbackProc) KillButton,
		  (XtPointer)datas);
  }
  else {
    command = XtCreateManagedWidget(button_name,
				    menuButtonWidgetClass,outer,args, iargs);
    iargs=0;
    menu = XtCreatePopupShell("menu", simpleMenuWidgetClass, 
			      command,args, iargs);
    for (i=0;i<*ne;i++){
      iargs=0;
      entry= XtCreateManagedWidget(entries[i], smeBSBObjectClass, menu,
				   args, iargs);
      datas= (MenuDataPtr) MALLOC(sizeof(MenuData) );
      if ( datas == (MenuDataPtr) 0) 
	{
	  *ierr=1 ;return;
	}
      datas->button_name=btn;
      datas->win_num=number;
      datas->entry=i;
      datas->type=*typ;
      datas->fname=func;
      XtAddCallback(entry,XtNcallback,(XtCallbackProc)SelMenu, 
		    (XtPointer)datas);
      XtAddCallback(entry, XtNdestroyCallback,(XtCallbackProc) KillButton,
		    (XtPointer)datas);
    }
  }
  /* set new position of scigraphic widget */
  if (newline==1) {
    iargs=0;
    XtSetArg(args[iargs], XtNfromVert,command);  iargs++;
    if (InMainWin==0) 
      /* move down graphic sub-window */
      XtSetValues(childs[predefined+1],args, iargs);

  }
}

/* Scilab interface for the AddMenu function 
   Add a menu in  window  number win_num or in Main window

   win_num     : graphic window number or -1 for main scilab window
   button_name : label of button
   entries     : labels of submenus if any (in scilab code)
   ptrentries  : table of pointers on each entries
   ne          : number of submenus
   typ         : Action mode
                 typ==0 : interpreted (execution of scilab instruction
                 typ!=0 : hard coded a routine is called
   fname;      : name of the action function  
*/

int 
C2F(addmen)(win_num,button_name,entries,ptrentries,ne,typ,fname,ierr)
integer *win_num,*entries,*ptrentries,*ne,*ierr,*typ;
char *button_name,*fname;
{
  char ** menu_entries;
  if (*ne!=0) {
    ScilabMStr2CM(entries,ne,ptrentries,&menu_entries,ierr);
    if ( *ierr == 1) return;
  }
  AddMenu(win_num,button_name,menu_entries,ne,typ,fname,ierr);
}

/* Activate a menu */

int 
SetMenu(win_num,button_name,entries,ne)
     integer *win_num,*ne;
     char *button_name;
     char **entries;
    {  
	int number,i,find=0;
	Cardinal nc;
	WidgetList childs;
	Widget popup,outer,command,toplevel,w,w1;
	char popupname[sizeof("ScilabGraphic")+4];
	char * label;
	String mname;
	static Display *dpy = (Display *) NULL;
	DisplayInit("",&dpy,&toplevel);
	number=*win_num;
	if (number==-1) 
	    outer = commandWindow;
	else {
	    sprintf(popupname,"ScilabGraphic%d",number);
	    popup=XtNameToWidget(toplevel,popupname);
	    if (popup == NULL)
		return;
	    outer=XtNameToWidget(popup,"scigForm");
	}
	iargs=0;
	XtSetArg(args[iargs], XtNnumChildren, &nc);    iargs++;
	XtSetArg(args[iargs], XtNchildren, &childs);   iargs++;
	XtGetValues(outer, args, iargs);
	for (i=0;i<nc;i++) 
		{
		    iargs=0;
		    XtSetArg(args[iargs], XtNlabel,&label);   iargs++;
		    XtGetValues(childs[i], args, iargs);
		    if ( label != (char *) 0) {
			if (strcmp(label,button_name)==0)
				{
				    find=1;
				    w=childs[i];
				    break;
				}

		    }
		}

	if (find==0) return;
	if (*ne==0) {
	    iargs=0;
	    XtSetArg(args[iargs],XtNsensitive,True); iargs++;
	    XtSetValues(w, args, iargs );
	}
	else {
	    iargs=0;
	    XtSetArg(args[iargs], XtNmenuName, &mname);    iargs++;
	    XtGetValues(w, args, iargs); 
	    w1=XtNameToWidget(w,mname);
	    if (w1==NULL) {
		iargs=0;
		XtSetArg(args[iargs],XtNsensitive,True); iargs++;
		XtSetValues(w, args, iargs );
		return;
	    }
	    iargs=0;
	    XtSetArg(args[iargs], XtNnumChildren, &nc);    iargs++;
	    XtSetArg(args[iargs], XtNchildren, &childs);   iargs++;
	    XtGetValues(w1, args, iargs); 
	    if (*ne<=nc) {
		iargs=0;
		XtSetArg(args[iargs],XtNsensitive,True); iargs++;
		XtSetValues(childs[*ne-1], args, iargs ); 
	    }
	}
    }
     
/** Deactivate  a Menu  **/ 

int 
UnSetMenu(win_num,button_name,entries,ne)
     integer *win_num,*ne;
     char *button_name;
     char **entries;
{  
  int number,i,find=0;
  Cardinal nc,nc1;
  WidgetList childs;
  Widget popup,outer,toplevel,w,w1;
  char popupname[sizeof("ScilabGraphic")+4];
  char *label;
  String mname;
  static Display *dpy = (Display *) NULL;
  DisplayInit("",&dpy,&toplevel);
  number=*win_num;
  if (number==-1) 
    outer = commandWindow;
  else {
    sprintf(popupname,"ScilabGraphic%d",number);
    popup=XtNameToWidget(toplevel,popupname);
    if (popup == NULL)
      return;
    outer=XtNameToWidget(popup,"scigForm");
  }
  iargs=0;
  XtSetArg(args[iargs], XtNnumChildren, &nc);    iargs++;
  XtSetArg(args[iargs], XtNchildren, &childs);   iargs++;
  XtGetValues(outer, args, iargs);
  for (i=0;i<nc;i++){
      iargs=0;
      XtSetArg(args[iargs], XtNlabel,&label);   iargs++;
      XtGetValues(childs[i], args, iargs);
      if ( label != (char *) 0) {
	  if (strcmp(label,button_name)==0){
	      w=childs[i];
	      find=1;
	      break;
	  }
      }
  }
  if (find==0) return;
  if (*ne==0) {
      iargs=0;
      XtSetArg(args[iargs],XtNsensitive,False); iargs++;
      XtSetValues(w, args, iargs );
  }
  else {
      iargs=0;
      XtSetArg(args[iargs], XtNmenuName, &mname);    iargs++;
      XtGetValues(w, args, iargs); 
      w1=XtNameToWidget(w,mname);
      if (w1==NULL) {
	  iargs=0;
	  XtSetArg(args[iargs],XtNsensitive,False); iargs++;
	  XtSetValues(w, args, iargs );
	  return;
      }
      iargs=0;
      XtSetArg(args[iargs], XtNnumChildren, &nc);    iargs++;
      XtSetArg(args[iargs], XtNchildren, &childs);   iargs++;
      XtGetValues(w1, args, iargs); 
      if (*ne<=nc) {
	  iargs=0;
	  XtSetArg(args[iargs],XtNsensitive,False); iargs++;
	  XtSetValues(childs[*ne-1], args, iargs ); 
      }
  }
}


/** activate a menu (scilab interface) **/

int 
C2F(setmen)(win_num,button_name,entries,ptrentries,ne,ierr)
     integer *win_num,*entries,*ptrentries,*ne,*ierr;
     char *button_name;
{
  char ** menu_entries;
/*
   if (*ne!=0) {
    ScilabMStr2CM(entries,ne,ptrentries,&menu_entries,ierr);
    if ( *ierr == 1) return;
  }
*/
  SetMenu(win_num,button_name,menu_entries,ne);
}

int C2F(unsmen)(win_num,button_name,entries,ptrentries,ne,ierr)
     integer *win_num,*entries,*ptrentries,*ne,*ierr;
     char *button_name;
{
  char ** menu_entries;
/*
  if (*ne!=0) {
    ScilabMStr2CM(entries,ne,ptrentries,&menu_entries,ierr);
    if ( *ierr == 1) return;
  }
*/
  UnSetMenu(win_num,button_name,menu_entries,ne);
}

/** Check if a menu has been clicked **/
integer C2F(ismenu)()
{
  return(menuhit);
}
/** Get what menu  been clicked **/
int C2F(getmen)(btn,lb,entry)
     integer *entry,*lb;
     char *btn;
{
  if (C2F(ismenu)()==1) {
    *entry=menudatas->entry+1;
    if (menudatas->win_num==-1)
      sprintf(btn,"%s",menudatas->fname);
    else
      sprintf(btn,"%s_%d",menudatas->fname,menudatas->win_num);
    *lb=strlen(btn);
    FREE(menudatas->button_name);
    FREE(menudatas->fname);
    FREE(menudatas);
    menuhit=0;
  }
  else
    *entry=0;
}
