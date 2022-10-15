#include "scilab_d.h"

#define MAXLISTLINE 30  /* Maximum number of line in a List widget Viewport */
#define MAXLISTCOLS 120 /* Maximum number of columns in a List widget Viewport */
#define MAXLABLINE 10  /* Maximum number of line in a List widget Viewport */
#define MAXLABCOLS 120 /* Maximum number of columns in a List widget Viewport */
#define MAXASCLINE 30  /* Maximum number of line in anascii widget  */
#define MAXASCCOLS 120 /* Maximum number of columns in an ascii widget Viewport */
#define ScrThickness 10 /* ScrollbarThickness maximizer */

extern XtAppContext app_con;
int ok_Flag_sci = 0;

static   Arg args[10];
static   Cardinal iargs = 0;


/*--------------------------------------------------------------
   generic function used for all the Scilab transient `menus' 
--------------------------------------------------------------*/

/* a special loop when inside transient menu shells 
   we want to exit the loop when ok_Flag_sci != 0 
 */

XtMyLoop(w,dpy)
     Widget w;
     Display *dpy;
{
  Atom	 wmDeleteWindow;
  XEvent event;
  ok_Flag_sci= 0;
  /*  XtPopup(w,XtGrabExclusive);*/
  XtPopup(w,XtGrabNone); 
  /* On ignore les delete envoyes par le Window Manager */
  wmDeleteWindow = XInternAtom(XtDisplay(w),"WM_DELETE_WINDOW", False);
  XSetWMProtocols(XtDisplay(w),XtWindow(w), &wmDeleteWindow, 1);
  for (;;) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
    if (ok_Flag_sci != 0) break;
  }
  XtDestroyWidget(w);  
  XFlush(dpy);
  XSync(dpy,0);
}


/* creates a transient shell+a form Widget */
/* #define SHELL_TYPE wmShellWidgetClass */
#define SHELL_TYPE transientShellWidgetClass 

void 
ShellFormCreate(shellname,shell,form,dpyh)
     char shellname[];
     Display **dpyh;
     Widget *shell,*form;
{
  static  Widget toplevel,hpaned;
  DisplayInit("",dpyh,&toplevel);

  *shell = XtCreatePopupShell(shellname,SHELL_TYPE,toplevel,
			     (Arg *) NULL,(Cardinal)ZERO);
  hpaned = XtCreateManagedWidget("hpaned",panedWidgetClass,*shell,
			     (Arg *) NULL,(Cardinal)ZERO);

  *form = XtCreateManagedWidget("paned",panedWidgetClass,hpaned,
			     (Arg *) NULL,(Cardinal)ZERO);
}



/* just add a button and it's callback */

ButtonCreate(parentW,button,callback,data,label,name)
     Widget parentW,*button;
     char label[],name[];
     XtCallbackProc callback;
     XtPointer data;
{
  iargs=0;
  XtSetArg(args[iargs], XtNlabel,label); iargs++;
  *button=XtCreateManagedWidget(name,commandWidgetClass,parentW,args,iargs);
  XtAddCallback(*button, XtNcallback,callback ,(XtPointer) data);  
}

/* This function creates a labelwidget inside a vieportwidget 
 *  and resizes the labelwidget not to exceed max values 
 * [ the viewport will have the scrollbars ] 
 * the function return the two widgets and the width and height 
 * Reste un point obscur doit on fixer le with/height du viewport ou du label ?
 * parentW is the widget inside which the viewport/label is inserted 
 */


ViewpLabelCreate(parentW,labelW,viewportW,description)
     Widget parentW;
     Widget *labelW,*viewportW;
     char description[];
{
  iargs=0;
  *viewportW = XtCreateManagedWidget("labelviewport",viewportWidgetClass,parentW,args,iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, description); iargs++;
  *labelW=XtCreateManagedWidget("label",labelWidgetClass,*viewportW,args, iargs);
}

  
/* This function creates a listwidget inside a vieportwidget 
 *  and resizes the listwidget not to exceed max values 
 * [ the viewport will have the scrollbars ] 
 * the function return the two widgets and the width and height 
 * Reste un point obscur doit on fixer le with/height du viewport ou du list ?
 * parentW is the widget inside which the viewport/list is inserted 
 */


ViewpListCreate(parentW,listW,viewportW,strings,nstr)
     Widget parentW;
     Widget *listW,*viewportW;
     char **strings;
     int nstr;
{
  iargs=0;
  /* create chooseviewport and chooselist widgets */
  *viewportW = XtCreateManagedWidget("listviewport",viewportWidgetClass,
					 parentW,args,iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNlist, strings); iargs++;
  *listW=XtCreateManagedWidget("list",listWidgetClass,*viewportW,
			     args,iargs);
}

/* 
  Computes the label Widget size of a label widget 
  filled with a string of nchar per lines and nlines 
  */

LabelSize(label,nchar,nlines,width,height)
     Widget label;
     int nchar,nlines;
     Dimension *width,*height;
{
  Dimension la_iheight=10 , la_iwidth=10;
  XFontStruct *temp_font = (XFontStruct *) NULL;
  iargs=0;
  XtSetArg(args[iargs],XtNfont, &temp_font);  iargs++;
  XtSetArg(args[iargs],XtNinternalHeight, &la_iheight);  iargs++;
  XtSetArg(args[iargs],XtNinternalWidth, &la_iwidth);  iargs++;
  XtGetValues(label, args, iargs);
  *height = nlines*(char_height(temp_font) + 0)+ (int) 2*la_iheight + ScrThickness ;
  *width  = nchar*Max(char_width(temp_font),1) + (int) 2*la_iwidth  + ScrThickness;
}


/* 
  Computes the ascii Widget size of an ascii widget 
  filled with a string of nchar per lines and nlines 
  with restriction on lines and cols 
  */

AsciiSize(ascii,nchar,nlines,width,height)
     Widget ascii;
     int nchar,nlines;
     Dimension *width,*height;
{
  Dimension rmarg,lmarg,topmarg,botmarg;
  XFontStruct *temp_font = (XFontStruct *) NULL;
  iargs=0;
  XtSetArg(args[iargs],XtNfont, &temp_font);  iargs++;
  XtSetArg(args[iargs],XtNrightMargin, &rmarg);  iargs++;
  XtSetArg(args[iargs],XtNleftMargin, &lmarg);  iargs++;
  XtSetArg(args[iargs],XtNtopMargin, &topmarg);  iargs++;
  XtSetArg(args[iargs],XtNbottomMargin, &botmarg);  iargs++;
  XtGetValues(ascii, args, iargs);
  *height=Min(nlines,MAXASCLINE)*(char_height(temp_font)+0) + topmarg+botmarg + ScrThickness;
  *width=Min(nchar,MAXASCCOLS)*Max(char_width(temp_font),1) + rmarg+lmarg + ScrThickness;
}

/* Set a lable widget label and size : size is greater 
   than the size needed by str 
   */


SetLabel(label,str,width,height)
     Widget label;
     char str[];
     Dimension width,height;
{
  iargs=0;
  XtSetArg(args[iargs], XtNwidth ,width) ; iargs++;
  XtSetArg(args[iargs], XtNheight ,height) ; iargs++;
  XtSetArg(args[iargs], XtNlabel ,str) ; iargs++;
  XtSetValues(label, args, iargs);
}

/* Set an ascii Widget strin and size */

SetAscii(ascii,str,width,height)
     Widget ascii;
     char str[];
     Dimension width,height;
{
  iargs=0;
  XtSetArg(args[iargs], XtNwidth ,width) ; iargs++;
  XtSetArg(args[iargs], XtNheight ,height) ; iargs++;
  XtSetArg(args[iargs], XtNstring ,str) ; iargs++;
  XtSetValues(ascii, args, iargs);
}

/*---------------------------------------------------------------
  generic functions for strings 
 ---------------------------------------------------------------*/

strwidth(string,max_width,height)
     char * string;
     int  *max_width;
     int  *height;
{
  int width=0,i;
  *height=0;
  *max_width=1;
  for (i = 0 ; i < (int)strlen(string);i++)
    {
      width++;
      if ( string[i]=='\n' || i == strlen(string)  -1)
	{
	  *max_width= (*max_width > width ) ?  *max_width : width;
	  width=0;
	  *height = *height+1;
	}
    }
}





