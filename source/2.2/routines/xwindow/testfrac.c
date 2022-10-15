  
/*
** testfrac.c
**
** How to make a widget to choose the fraction of tests to be run.
**
*/

#include "scilab_d.h"

static Widget toplevel;
extern XtAppContext app_con;

#define SCROLLBAR_LENGTH 125
#define SLIDER_LENGTH 0.2	/* proportion of scrollbar taken up
				   by the slider */

static Widget label;		/* the label */
static Widget slider;		/* the scrollbar */
static Widget percent;	/* label with chosen percentage */
static float fraction;		/* what percent has been chosen */
static int   oldpercent = -1;	/* so we only update when the slider has
				   been moved */

/* slider_jump(w,data,position)
** ----------------------------
** This function is called if the user moves the scrollbar to a new
** position (generally, by using the middle button).  It updates
** information about where the scrollbar is.
*/

static void
slider_jump(w, data, position)
     Widget w;
     caddr_t data;
     caddr_t position;
{
  static Arg percentargs[] = {
    {XtNlabel,   (XtArgVal) NULL}
  };
  float loldpercent;		/* where the scrollbar is */
  float newpercent;		/* normalized scrollbar */
  char snewpercent[3];		/* string representation of scrollbar */
  loldpercent = *(float *) position;
  /* We want the scrollbar to be at 100% when the right edge of the slider
  ** hits the end of the scrollbar, not the left edge.  When the right edge
  ** is at 1.0, the left edge is at 1.0 - SLIDER_LENGTH.  Normalize
  ** accordingly.  */
  newpercent = loldpercent / (1.0 - SLIDER_LENGTH);
  /* If the slider's partially out of the scrollbar, move it back in. */
  if (newpercent > 1.0) {
    newpercent = 1.0;
    XawScrollbarSetThumb( slider, 1.0 - SLIDER_LENGTH, SLIDER_LENGTH);
  }
  /* Store the position of the silder where it can be found */
  *(float *)data = newpercent;
  /* Update the label widget */
  sprintf(snewpercent,"%d",(int)(newpercent*100));
  percentargs[0].value = (XtArgVal) snewpercent;
  XtSetValues(percent, percentargs, XtNumber(percentargs));
}

/* slider_scroll(w,data,position)
** ------------------------------
** This function is called when the user does incremental scrolling, 
** generally with the left or right button.  Right now it just ignores it.
*/


static void
slider_scroll(w, data, position)
     Widget w;
     caddr_t data;
     caddr_t position;
{}


static void
update(w,event,params,num_params)
     Widget w;
     XEvent *event;
     String *params;
     int *num_params;
{
  char buf[80];
  int newpercent;
  newpercent = (int)(fraction * 100.0);
  if (newpercent != oldpercent) {
    sprintf(buf, "percent %d\n", (int)(fraction * 100.0));
    oldpercent = newpercent;
  }
}

extern int ok_Flag_sci;

static void mDialogOk(w,nv,callData)
     Widget w;
     caddr_t callData;
     caddr_t nv;
{ 
  ok_Flag_sci = -1;
}

/* create_testfrac_choice(w)
** -------------------------
** Inside w (a form widget), creates:
**   1. A label "Percentage of Test"
**   2. A scrollbar for the user to choose the percentage (from 0 to 100)
**   3. A label with the current percentage displayed on it.
** The percentage starts at 100.
**
** When the pointer leaves the scrollbar, a string is sent to interpret()
** so that it knows the position of the scrollbar.
*/

void
create_testfrac_choice(w,description,min,max)
     char *description;
     float *min,*max;
     Widget w;
{
  Arg args[10];
  Cardinal iargs = 0;
  Widget wid ;

  static XtCallbackRec jumpcallbacks[] = {
    {(XtCallbackProc) slider_jump, NULL},
    {NULL,                         NULL}
  };

  static XtCallbackRec scrollcallbacks[] = {
    {(XtCallbackProc) slider_scroll, NULL},
    {NULL,                           NULL}
  };

  static Arg labelargs[] = {
    {XtNborderWidth,  (XtArgVal) 0},
    {XtNjustify,      (XtArgVal) XtJustifyRight},
    {XtNvertDistance, (XtArgVal) 4}
  };

  static Arg percentargs[] = {
    {XtNborderWidth,    (XtArgVal) 1},
    {XtNhorizDistance,  (XtArgVal) 10},
    {XtNfromHoriz,      (XtArgVal) NULL}
  };

  static Arg scrollargs[] = {
    {XtNorientation,     (XtArgVal) XtorientHorizontal},
    {XtNlength,          (XtArgVal) SCROLLBAR_LENGTH},
    {XtNthickness,       (XtArgVal) 10},
    {XtNshown,           (XtArgVal) 10},
    {XtNhorizDistance,   (XtArgVal) 10},
    {XtNfromHoriz,       (XtArgVal) NULL},
    {XtNjumpProc,        (XtArgVal) NULL},
    {XtNscrollProc,      (XtArgVal) NULL}
  };
  static char *translationtable = "<Leave>: Update()";
  static XtActionsRec actiontable[] = {
    {"Update",  (XtActionProc) update},
    {NULL,      NULL}
  };
  /* Let the scrollbar know where to store information where we
  ** can see it */
  jumpcallbacks[0].closure = (caddr_t) &fraction;
  label = XtCreateManagedWidget(description,labelWidgetClass,w,
				labelargs, XtNumber(labelargs));
  percentargs[2].value = (XtArgVal) label;
  percent = XtCreateManagedWidget("100",labelWidgetClass,w,
				  percentargs,XtNumber(percentargs));
  scrollargs[5].value = (XtArgVal) percent;
  scrollargs[6].value = (XtArgVal) jumpcallbacks;
  scrollargs[7].value = (XtArgVal) scrollcallbacks;
  slider = XtCreateManagedWidget("Slider",scrollbarWidgetClass,w,
				 scrollargs,XtNumber(scrollargs));
  XtAppAddActions(app_con,actiontable,XtNumber(actiontable));
  XtOverrideTranslations(slider,XtParseTranslationTable(translationtable));
  /* Start the thumb out at 100% */
  XawScrollbarSetThumb(slider, 1.0 - SLIDER_LENGTH, SLIDER_LENGTH);
  /* Adding an OK Button */
  iargs=0;
  XtSetArg(args[iargs], XtNfromHoriz ,slider) ; iargs++;
  XtSetArg(args[iargs], XtNlabel, "Ok" ); iargs++;
  wid=XtCreateManagedWidget("okbutton",commandWidgetClass,w,args,iargs);
  XtAddCallback(wid, XtNcallback,(XtCallbackProc)mDialogOk ,(XtPointer) NULL );  
}

void  update_slider(newpercent)
     int newpercent;
{
  fraction = (float) newpercent / 100.0;
  XawScrollbarSetThumb(slider, fraction / (1.0-SLIDER_LENGTH), SLIDER_LENGTH);
}

#define X 147
#define Y 33


void mbar_()
{
  void mbar1();
  float x1=200.0,x2=897;
  mbar1("pipo",&x1,&x2);
}

void mbar1(description,min,max)
     char * description;
     float *min,*max;
  {
    Arg args[10];
    Cardinal iargs = 0;
    Widget shell,form;
    static Display *dpy = (Display *) NULL;
    DisplayInit("",&dpy,&toplevel);
    XtSetArg(args[iargs], XtNx, X + 10); iargs++ ;
    XtSetArg(args[iargs], XtNy, Y +10); iargs++;
    shell = XtCreatePopupShell("dialogshell",transientShellWidgetClass,toplevel,
			       args,iargs);
    iargs = 0;
    XtSetArg(args[iargs], XtNresizable , TRUE) ; iargs++;

    form = XtCreateManagedWidget("message",formWidgetClass,shell,args,iargs);

    create_testfrac_choice(form,description,min,max);

    XtMyLoop(shell,dpy);
}
