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
/** getpid **/
#ifdef __STDC__
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#else 
extern int getpid();
#endif

#include "../graphics/Math.h"
#include "../sun/men_Sutils.h"
#include "../menusX/men_scilab.h"
#include "All-extern.h"
#include "All-extern-x1.h"

extern void DisplayInit _PARAMS((char *string,Display **dpy,Widget *toplevel));
extern void ChangeBandF _PARAMS((int win_num,Pixel fg, Pixel bg));
extern integer F2C(fbutn) _PARAMS((char *,integer*,integer*));

int demo_menu_activate=0; /* add a demo menu in the graphic Window */


/*---------------------------------------------------------------
  Functions and buttons associated with the Graphic Scilab Window 
  -----------------------------------------------------------------*/
static void ChangeBF1 _PARAMS(( Widget w,     char *str,     Pixel fg,     Pixel bg));
static void SetHints  _PARAMS((Widget topW));  
static int AddNewWin  _PARAMS((Widget popup, int, Widget *, Widget *));
static XtEventHandler EventProc  _PARAMS((Widget widget, XtPointer , XEvent *));  
static XtEventHandler EventProc1  _PARAMS((Widget widget, XtPointer , XEvent *));  
static XtEventHandler ResizeWindow  _PARAMS((Widget, XtPointer , XConfigureEvent *));  
static XtCallbackProc Efface  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc Select  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc Delete  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc Print  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc SavePs  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc Save  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc Load  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc Zoom  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc UnZoom  _PARAMS((Widget, XtPointer , XtPointer ));  
static XtCallbackProc Rot3D  _PARAMS((Widget, XtPointer , XtPointer ));  
static void ChangeBF1  _PARAMS((Widget, char *str, Pixel fg, Pixel bg));  
static XtCallbackProc KillButton  _PARAMS((Widget, XtPointer , caddr_t ));  
static XtCallbackProc SelMenu  _PARAMS((Widget, XtPointer , caddr_t));  
static void SetUnsetMenu  _PARAMS((integer *, char *, integer *, int));  


static char popupname[sizeof("ScilabGraphic")+4];
static Arg args[10] ;
static iargs=0;

/*
 * Fixes hints for the graphic windows (min sizes and wm delete window flag)
 */

static void SetHints(topW)
     Widget topW;
{
 XSizeHints		size_hints;
 Atom		wmDeleteWindow;
 size_hints.width	= 600;
 size_hints.height	= 400;
 size_hints.min_width	= 400;
 size_hints.min_height	= 300;
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
AddNewWin(popup, popupc, drawbox, infowidget)
     Widget popup;
     int popupc;
     Widget *drawbox;
     Widget *infowidget;
{
  Widget outer,zoom,rot3d,unzoom,sel;
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
  sel = XtCreateManagedWidget("Select", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(sel, XtNcallback,(XtCallbackProc) Select,(XtPointer) popupc); 
  prnt = XtCreateManagedWidget("Print", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(prnt, XtNcallback,(XtCallbackProc)  Print,(XtPointer) popupc);
  saveps = XtCreateManagedWidget("Export", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(saveps, XtNcallback,(XtCallbackProc)  SavePs,(XtPointer)popupc);
  save = XtCreateManagedWidget("Save", smeBSBObjectClass,filemenu,args, iargs);
  XtAddCallback(save, XtNcallback,(XtCallbackProc)  Save,(XtPointer)popupc);
  load = XtCreateManagedWidget("Load", smeBSBObjectClass,filemenu,args, iargs);
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
  if ( demo_menu_activate == 1 )  AddNewMenu(outer,*drawbox);
  return(0);
}

/* 
 * Checking events in the Graphic Window 
 * in fact just the XtAddEventHandler is used 
 * used in xclick 
 * We keep the last  MaxCB click events on a queue just in case 
 * xclick wants them ( xclick(1)) 
 */

typedef struct but {
  int win,x,y,ibutton;
} But;

#define MaxCB 50
static But ClickBuf[MaxCB];
static int lastc = 0;

static XtEventHandler
EventProc(widget, number, event)
     Widget widget;
     XtPointer number;
     XEvent *event;
{
    /* sciprint("Je suis ds EventProc\n"); */
    switch (event->type) 
      {
      case  MotionNotify:
	break;
      case ButtonPress :
	PushClickQueue((int) number,event->xbutton.x,event->xbutton.y,
		       event->xbutton.button-1);
	break;
    default:
	/*	    sciprint("Je suis ds EventProc fenetre %d\r\n",num);*/
	return(0);
      }
    return(0);
}

int PushClickQueue(win,x,y,ibut) 
     int win,x,y,ibut;
{
  if ( lastc == MaxCB ) 
    {
      int i;
      for ( i= 1 ; i < MaxCB ; i ++ ) 
	{
	  ClickBuf[i-1]=ClickBuf[i];
	}
      ClickBuf[lastc-1].win = win;
      ClickBuf[lastc-1].x = x;
      ClickBuf[lastc-1].y = y;
      ClickBuf[lastc-1].ibutton = ibut;
    }
  else 
    {
      ClickBuf[lastc].win = win;
      ClickBuf[lastc].x = x;
      ClickBuf[lastc].y = y;
      ClickBuf[lastc].ibutton = ibut;
      lastc++;
    }
  return(0);
}

int CheckClickQueue(win,x,y,ibut) 
     integer *win,*x,*y,*ibut;
{
  int i;
  for ( i = 0 ; i < lastc ; i++ )
    {
      int j ;
      if ( ClickBuf[i].win == *win || *win == -1 ) 
    {
	  *win = ClickBuf[i].win;
	  *x= ClickBuf[i].x ;
	  *y= ClickBuf[i].y ;
	  *ibut=ClickBuf[i].ibutton; 
	  for ( j = i+1 ; j < lastc ; j++ ) 
	    {
	      ClickBuf[j-1].win = ClickBuf[j].win ;
	      ClickBuf[j-1].x   = ClickBuf[j].x ;
	      ClickBuf[j-1].y =  ClickBuf[j].y ;
	      ClickBuf[j-1].ibutton = ClickBuf[j].ibutton ;
	    }
      lastc--;
      return(1);
    }
    }
    return(0);
}

int ClearClickQueue(win)
     int win;
{
  int i;
  if ( win == -1 ) 
{
      lastc = 0;
      return;
    }
  for ( i = 0 ; i < lastc ; i++ )
    {
      int j ;
      if ( ClickBuf[i].win == win  ) 
	{
	  for ( j = i+1 ; j < lastc ; j++ ) 
	    {
	      ClickBuf[j-1].win = ClickBuf[j].win ;
	      ClickBuf[j-1].x   = ClickBuf[j].x ;
	      ClickBuf[j-1].y =  ClickBuf[j].y ;
	      ClickBuf[j-1].ibutton = ClickBuf[j].ibutton ;
	    }
	  lastc--;
	}
    }
  lastc=0;
  return(0);
}


static XtEventHandler
EventProc1(widget, number, event)
     Widget widget;
     XtPointer number;
     XEvent *event;
{
  integer win_num= (integer) number;
  XExposeEvent *event1;
  switch (event->type) 
    {
    case Expose :
      /** used when the X server does not perform backing store  **/
      event1= (XExposeEvent *) event;
      /** fprintf(stderr,"Expose Event : count %d x %d y %d width %d height %d\n",
	      event1->count ,event1->x,event1->y,event1->width,event1->height);
	      **/
      if ( event1->count == 0) 
	{
	  scig_replay(win_num);
	}
      break;
    case VisibilityNotify :
      /* normalement on ne pas la que si le serveur ne sait pas faire de 
	 save_under */
      fprintf(stderr,"Visibility change\n");
      break;
    default:
      sciprint("Je suis ds EventProc1 fenetre %d\r\n",(int) win_num);
      return(0);
    }
  return(0);
}


/*************************************************************
 * The ResizeWindow handler for the drawbox
 * This function is called when the window need redisplay
 * 
 *************************************************************/



static XtEventHandler ResizeWindow(w, number, e)
     Widget w;
     XtPointer number;
     XConfigureEvent *e;
{
  XEvent event;
  integer win_num= (integer) number;
  if (e->type != ConfigureNotify) return(0);
  {
    scig_resize(win_num);
  }
  /* I don't want to have Expose event after resizing **/

  while (XCheckWindowEvent(XtDisplay(w),XtWindow(w),ExposureMask,&event)==True)
	 { 
	   /** fprintf(stderr,"Encore un Expose \n"); **/
	 }
  return(0);
}
  

/**************************************************************
 *
 * To clear the graphic window and clear the recorded graphics 
 * w and client_data are unused 
 * 
 *************************************************************/

static XtCallbackProc
Efface(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  scig_erase(win_num);
  return(0);
}

/**************************************************************
 *
 * To select the graphic window 
 * 
 *************************************************************/

static XtCallbackProc
Select(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  scig_sel(win_num);
  return(0);
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
  return(0);
}

/* for Fortran call */

int C2F(deletewin)(number) 
     integer *number;
{
  Delete((Widget) 0,(XtPointer) *number,(XtPointer) 0);
  return(0);
}


/*********************************************************
 * Replot in Postscript style and send to printer 
 ********************************************************/

static  char bufname[256];
static  char printer[128];
static  char file[256];

static XtCallbackProc
Print(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  integer colored,orientation,flag=1,ok;
  prtdlg(&flag,printer,&colored,&orientation,file,&ok);
  if (ok==1) 
    {
      sprintf(bufname,"/tmp/SD_%d_/scilab-%d",(int)getpid(),(int)win_num);
      scig_tops(win_num,colored,bufname,"Pos");
      sprintf(bufname,"$SCI/bin/scilab -%s /tmp/SD_%d_/scilab-%d %s",
	      (orientation == 1) ? "print_l" : "print_p",
	      (int) getpid(),(int)win_num,printer);
      system(bufname);
  }
  return(0);
}

/*********************************************************
 * Replot in Postscript or Xfig style and save 
 ********************************************************/

static XtCallbackProc
SavePs(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number ;
  integer colored,orientation,flag=2,ok;
  prtdlg(&flag,printer,&colored,&orientation,file,&ok);
  if (ok==1) 
    {
      if (strncmp(printer,"Postscript",10)==0 ) 
	{
	  /** Postcsript*   **/
	  scig_tops(win_num,colored,file,"Pos");
	}
      else if (strcmp(printer,"Xfig")==0)
	{
	  scig_tops(win_num,colored,file,"Fig");
	}
      if ( strcmp(printer,"Postscript No Preamble") != 0)
	{
	  sprintf(bufname,"$SCI/bin/scilab -%s %s %s",
		  ( orientation == 1) ? "save_l" : "save_p",file,printer);
	  system(bufname);
	}
  }
  return(0);
}


/******************************************************
 * Binary File save 
 ******************************************************/

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
    /** xxxxx : xdialg1 puts extra ' ' at end of string **/
    int i = strlen(filename)-1 ;
    while ( filename[i] == ' ' ) i--;
    filename[i+1]= '\0';
    C2F(xsaveplots)(&win_num,filename,0L);
  }
  return(0);
}

/******************************************************
 * Binary File load 
 ******************************************************/

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
    /** xxxxx : xdialg1 puts extra ' ' at end of string **/
    int i = strlen(filename)-1 ;
    while ( filename[i] == ' ' ) i--;
    filename[i+1]= '\0';
      C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
      C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(xloadplots)(filename,0L);
      C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  }
  return(0);
}

/*
 * Inhinit zoom,unoom,rot3d 
 */

/*******************************************************
 * 2D Zoom calback 
 ******************************************************/

static XtCallbackProc
Zoom(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number,ne=0;
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive, False); iargs++;
  XtSetValues(w, args, iargs);
  SetUnsetMenu(&win_num,"3D Rot.",&ne,False);
  SetUnsetMenu(&win_num,"UnZoom",&ne,False);
  SetUnsetMenu(&win_num,"File",&ne,False);
  scig_2dzoom(win_num);
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive,True); iargs++;
  XtSetValues(w, args, iargs);
  SetUnsetMenu(&win_num,"Rot3d",&ne,True);
  SetUnsetMenu(&win_num,"3D Rot.",&ne,True);
  SetUnsetMenu(&win_num,"UnZoom",&ne,True);
  SetUnsetMenu(&win_num,"File",&ne,True);
  return(0);
}


/*******************************************************
 * Unzoom Callback 
 ******************************************************/

static XtCallbackProc
UnZoom(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number;
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive, False); iargs++;
  XtSetValues(w, args, iargs);
  scig_unzoom(win_num);
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive,True); iargs++;
  XtSetValues(w, args, iargs);
  return(0);
}


/*******************************************************
 * 3D Rotation callback 
 ******************************************************/


static XtCallbackProc
Rot3D(w, number, client_data)
     Widget w;
     XtPointer number;
     XtPointer client_data;
{
  integer win_num = (integer) number,ne=0;
  iargs=0;
  XtSetArg(args[iargs], XtNsensitive, False); iargs++;
  XtSetValues(w, args, iargs);
  SetUnsetMenu(&win_num,"UnZoom",&ne,False);
  SetUnsetMenu(&win_num,"2D Zoom",&ne,False);
  SetUnsetMenu(&win_num,"File",&ne,False);
  scig_3drot(win_num);
  iargs = 0;
  XtSetArg(args[iargs], XtNsensitive,True); iargs++;
  XtSetValues(w, args, iargs);
  SetUnsetMenu(&win_num,"UnZoom",&ne,True);
  SetUnsetMenu(&win_num,"2D Zoom",&ne,True);
  SetUnsetMenu(&win_num,"File",&ne,True);
  return(0);
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

void CreatePopupWindow(WinNum, button, CWindow, SciGWindow, fg, bg, infowidget)
     integer WinNum;
     Widget button;
     Window *CWindow;
     Window *SciGWindow;
     Pixel *fg;
     Pixel *bg;
     Widget *infowidget;
{
  Widget	popup,drawbox;
    XColor x_fg_color,x_bg_color;
    static XSetWindowAttributes attributes;
    unsigned char winname[6];
    iargs=0;
    XtSetArg(args[iargs], XtNx, 100+20*WinNum % 200);	iargs++;
    XtSetArg(args[iargs], XtNy, 100+20*WinNum % 200);	iargs++;
    sprintf(popupname,"ScilabGraphic%d",(int)WinNum);
    XtSetArg(args[iargs],XtNtitle,popupname);iargs++;
    popup = XtCreatePopupShell(popupname,
			       wmShellWidgetClass, button, args, iargs);
    AddNewWin(popup,(int) WinNum,&drawbox,infowidget);
    XtPopup(popup, XtGrabNone);
    SetHints(popup);

    sprintf((char *)winname,"BG%d",(int)WinNum);
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


/*******************************************************
 * recursively changes the background and foreground 
 * of widgets 
 ******************************************************/

void ChangeBandF(win_num,fg,bg)
     int win_num;
     Pixel fg;
     Pixel bg;
{
  int number;
  Widget popup,toplevel;
  char popupname[sizeof("ScilabGraphic")+4];
  static Display *dpy = (Display *) NULL;
  DisplayInit("",&dpy,&toplevel);
  number = win_num;
  sprintf(popupname,"ScilabGraphic%d",number);
  popup = XtNameToWidget(toplevel,popupname);
  if (popup == NULL) return;
  ChangeBF1(popup,"scigForm.File",fg,bg);
  ChangeBF1(popup,"scigForm.File.menu",fg,bg);
  ChangeBF1(popup,"scigForm.File.menu.Clear",fg,bg);
  ChangeBF1(popup,"scigForm.File.menu.Select",fg,bg);
  ChangeBF1(popup,"scigForm.File.menu.Print",fg,bg);
  ChangeBF1(popup,"scigForm.File.menu.Export",fg,bg);
  ChangeBF1(popup,"scigForm.File.menu.Save",fg,bg);
  ChangeBF1(popup,"scigForm.File.menu.Load",fg,bg);
  ChangeBF1(popup,"scigForm.File.menu.Close",fg,bg);
  ChangeBF1(popup,"scigForm.Zoom",fg,bg);
  ChangeBF1(popup,"scigForm.UnZoom",fg,bg);
  ChangeBF1(popup,"scigForm.Rot3D",fg,bg);
}

static void ChangeBF1(w,str,fg,bg)
     Widget w;
     char *str;
     Pixel fg;
     Pixel bg;
{
  Widget loc;
  loc = XtNameToWidget(w,str);
  if ( loc != NULL)  
    {
      iargs=0;
      XtSetArg(args[iargs], XtNforeground, fg); iargs++;
      XtSetArg(args[iargs], XtNbackground, bg); iargs++;
      XtSetValues(loc, args, iargs);
    }
  else
    {
      sciprint("widget %s not found\r\n",str);
    }
}

/*--------------------------------------------------------------
  Add dynamically buttons and menus in The Scilab Graphic Window
  or in the Scilab main window 
----------------------------------------------------------------*/

typedef struct {
  int    win_num;      /* graphic window number or -1 for main window */
  int    entry;        /* clicked sub_menu number */
  int    type;         /* interpreded action (0), hard coded action(1) */
  char   *fname;       /* name of the action function  */
} MenuData,*MenuDataPtr;
 

extern Widget commandWindow;

static XtCallbackProc
KillButton(w, client_data, call_data)
     Widget w;
     XtPointer client_data;
     caddr_t call_data;
{
  MenuDataPtr datas =(MenuDataPtr)client_data;
  FREE(datas->fname);
  FREE(datas);
  return(0);
}

/****************************************************
 * callBack associated to a user defined menu 
 ****************************************************/

static XtCallbackProc
SelMenu(w, client_data, call_data)
     Widget w;
     XtPointer client_data;
     caddr_t call_data;
{
  static char buf[256];
  MenuDataPtr datas = (MenuDataPtr) client_data;
  if (datas->type == 0) 
    { 
      /* Interpreted mode : we store the action on a queue */
      if ( datas->win_num < 0 ) 
	{
	  sprintf(buf,"execstr(%s(%d))",datas->fname,datas->entry+1);
	}
      else 
	{
	  sprintf(buf,"execstr(%s_%d(%d))",datas->fname,datas->win_num,datas->entry+1);
	}
      StoreCommand(buf);
    }
  else 
    { 
      /* hard coded mode */
      int rep ;
      C2F(setfbutn)(datas->fname,&rep);
      if ( rep == 0) 
	F2C(fbutn)((datas->fname),&(datas->win_num),&(datas->entry));
    }
  return(0);
}

/****************************************************
 *Delete the button named button_name in window 
 * number win_num
 ****************************************************/

int C2F(delbtn)(win_num,button_name)
     integer *win_num;
     char *button_name;
{  
  int number;
  Cardinal nc=0;
  WidgetList childs;
  Widget popup,outer,command,toplevel,h,v,w;
  char popupname[sizeof("ScilabGraphic")+4];
  static Display *dpy = (Display *) NULL;
  int InMainWin,i,pos=0;

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

  if ( nc == 0 ) return(0);/** return if no children */

  command=XtNameToWidget(outer,button_name);
  if (command==NULL) return(0);
  /* get position in widget list */
  for (i=0;i<nc;i++) 
    if (command==childs[i]) pos=i+1;
  if ( pos==nc ) 
    {
      /* if last simply destroy it */
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

/****************************************************
 * Add a menu in  window  number wun_num or in Main window
 *  win_num     : graphic window number or -1 for main scilab window
 *  button_name : label of button
 *  entries     : labels of submenus if any
 *  ne          : number of submenus
 *  typ         : Action mode
 *                typ==0 : interpreted (execution of scilab instruction
 *  typ!=0 : hard coded a routine is called
 *  fname;      : name of the action function  
 ****************************************************/

void AddMenu(win_num, button_name, entries, ne, typ, fname, ierr)
     integer *win_num;
     char *button_name;
     char **entries;
     integer *ne;
     integer *typ;
     char *fname;
     integer *ierr;
{  
  int number,newline,i;
  Cardinal nc;
  WidgetList childs;
  Widget popup,outer,command,w,menu,entry,toplevel;
  char popupname[sizeof("ScilabGraphic")+4];
  Position x;
  Dimension width,height,mainwidth,mainheight,bw;
  XFontStruct     *temp_font;
  char *func;
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

/****************************************************
 * Scilab interface for the AddMenu function 
 *  Add a menu in  window  number win_num or in Main window
 *
 *  win_num     : graphic window number or -1 for main scilab window
 *  button_name : label of button
 *  entries     : labels of submenus if any (in scilab code)
 *  ptrentries  : table of pointers on each entries
 *  ne          : number of submenus
 *  typ         : Action mode
 *                typ==0 : interpreted (execution of scilab instruction
 *                typ!=0 : hard coded a routine is called
 *  fname;      : name of the action function  
 *******************************************************/

int C2F(addmen)(win_num,button_name,entries,ptrentries,ne,typ,fname,ierr)
     integer *win_num,*entries,*ptrentries,*ne,*ierr,*typ;
     char *button_name,*fname;
{
  char ** menu_entries;
  if (*ne!=0) {
    ScilabMStr2CM(entries,ne,ptrentries,&menu_entries,ierr);
    if ( *ierr == 1) return(0);
  }
  AddMenu(win_num,button_name,menu_entries,ne,typ,fname,ierr);
  return(0);
}

/***************************************************
 * Activate or deactivate a menu 
 ***************************************************/

static void SetUnsetMenu(win_num, button_name, ne,flag)
     integer *win_num;
     char *button_name;
     integer *ne;
     int flag;
{  
  int number,i;
  Cardinal nc;
  WidgetList childs;
  Widget popup,outer,toplevel,w=(Widget)0,w1;
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
	    w=childs[i];
	    break;
	  }
	      
      }
    }
  if ( w == (Widget) 0) return;
  if (*ne==0) {
    iargs=0;
    XtSetArg(args[iargs],XtNsensitive,flag); iargs++;
    XtSetValues(w, args, iargs );
  }
  else {
    iargs=0;
    XtSetArg(args[iargs], XtNmenuName, &mname);    iargs++;
    XtGetValues(w, args, iargs); 
    w1=XtNameToWidget(w,mname);
    if (w1==NULL) {
      iargs=0;
      XtSetArg(args[iargs],XtNsensitive,flag); iargs++;
      XtSetValues(w, args, iargs );
      return;
    }
    iargs=0;
    XtSetArg(args[iargs], XtNnumChildren, &nc);    iargs++;
    XtSetArg(args[iargs], XtNchildren, &childs);   iargs++;
    XtGetValues(w1, args, iargs); 
    if (*ne<=nc) {
      iargs=0;
      XtSetArg(args[iargs],XtNsensitive,flag); iargs++;
      XtSetValues(childs[*ne-1], args, iargs ); 
    }
  }
}


/** activate a menu (scilab interface) **/

int C2F(setmen)(win_num,button_name,entries,ptrentries,ne,ierr)
     integer *win_num,*entries,*ptrentries,*ne,*ierr;
     char *button_name;
{
  SetUnsetMenu(win_num,button_name,ne,True);
  return(0);
}

int C2F(unsmen)(win_num,button_name,entries,ptrentries,ne,ierr)
     integer *win_num,*entries,*ptrentries,*ne,*ierr;
     char *button_name;
{
  SetUnsetMenu(win_num,button_name,ne,False);
  return(0);
}

