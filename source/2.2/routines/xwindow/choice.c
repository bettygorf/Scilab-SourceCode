/*
** choice.c
** All the generic stuff for dealing with choice widgets.
** (from xgc) 
*/

#include "scilab_d.h"

#include <X11/Xaw/Toggle.h>

extern int ok_Flag_sci;
extern void ShellFormCreate();
extern int AllocAndCopy();
static void create_choice();
static void select_button();
static void line_up_labels();
static int pttb();
static XtCallbackProc ChoiceOk();
static XtCallbackProc ChoiceCancel();


/* Data structure for choice */

#include "choice.h"
SciStuff **Everything = NULL;

/* Interface to work with Scilab */

void C2F(xchoices)(descla,ptrdescla,nvla,desc,ptrdesc,nv,defval,nitems)
     int *desc,*ptrdesc,*nv,*defval,*nitems;
     int *descla,*ptrdescla,*nvla;
{
  int ierr,i,sepc=0;
  char **items,*label;
  ierr=0;
  ScilabMStr2C(descla,nvla,ptrdescla,&label,&ierr);
  if ( ierr == 1) return;
  ScilabMStr2CM(desc,nv,ptrdesc,&items,&ierr);
  if ( ierr == 1) return;
  for (i = 0 ; i < *nv ; i++ ) 
    if ( strcmp(items[i],"[--sep--]")==0) 
      {
	sepc++;
	FREE(items[i]);
	items[i]= (char *) NULL;
      };
  if ( sepc != *nitems-1) 
    {
      sciprint("x_choices : the choice vector is too small\r\n");
      return;
    }
  SciChoice(label,items,defval,*nitems);
  for (i=0;i< *nv;i++) FREE(items[i]); FREE(items);
  FREE(label);
}

/* test function */

TestChoice()
{
  static char* items[] = {
    "Label1",    "choice1",    "choice2",
    NULL,
    "Label2",    "choice1",    "choice2",    "choice3",
    NULL
    };
  static int defch[]={1,0};
  static int nitems= 2;
  SciChoice("test",items,defch,nitems);
}


/*
  Main function 
  if test == 1
  a test is used whitout using items, defval, nitems 
  see choice-test.c
*/

SciChoice(label,items,defval,nitems)
     char **items,*label;
     int defval[], nitems;

{
  int i;
  static Widget ok,wlabel,toppaned,shell,wlabelviewport,dviewport,form,cform;
  static Arg args[2];
  static Cardinal iargs;
  static Display *dpy = (Display *) NULL;
  
  if ( SciChoiceCreate(items,defval,nitems) == 0) 
    {
      sciprint("x_choices : No more place\r\n");
      return;
    };

  /* Initialize toolkit stuff */

  ShellFormCreate("choiceShell",&shell,&toppaned,&dpy);

  /* Create a Viewport+Label and resize it */

  ViewpLabelCreate(toppaned,&wlabel,&wlabelviewport,label);

  /* create all the GCchoices forms */

  iargs=0;
  dviewport = XtCreateManagedWidget("viewport",viewportWidgetClass,toppaned, args, iargs);
  iargs=0;
  form = XtCreateManagedWidget("form",formWidgetClass, dviewport , args, iargs);

  (void) create_choices(form,(Widget) NULL);

  /* command widgets */
  iargs=0;
  cform = XtCreateManagedWidget("cform",formWidgetClass,toppaned,args,iargs);

  ButtonCreate(cform,&ok,(XtCallbackProc) ChoiceOk,(XtPointer) NULL,"Ok","ok");
  ButtonCreate(cform,&ok,(XtCallbackProc) ChoiceCancel,(XtPointer) NULL,"Cancel","cancel");
  
  XtMyLoop(shell,dpy);
  
  if (   ok_Flag_sci==1 ) 
    {
      for ( i=0 ; i < nitems ; i++) 
	{
	  /* sciprint("Item %d choix %d\r\n",i+1,  Everything[i]->choice.default_toggle +1); */
	  defval[i]= Everything[i]->choice.default_toggle +1;
	}
    }
  SciChoiceFree(nitems);
}


/* The OK Button */

static XtCallbackProc
ChoiceOk(w,nv,callData)
     Widget w;
     caddr_t callData;
     int nv;
{ 
  ok_Flag_sci=1 ;
  /* sciprint("OK\r\n"); */
}


static XtCallbackProc
ChoiceCancel(w,nv,callData)
     Widget w;
     caddr_t callData;
     int nv;
{ 
  ok_Flag_sci=- 1 ;
  /* sciprint("OK\r\n"); */
}




/*
  SciChoiceCreate(items,defval,nitems)
  This fuction is used to create the required SciStuff 
  Object in order to call create_choices 
  from a simpler data structure in order to be able 
  to communicate with Scilab 
  char*  items[] = {     "Label1",      "choice1",      "choice2",     ...,       NULL,
                         "Label2",      "choice1",      "choice2",     ...,      NULL}
  les valeurs par defaut sont numerotes a partir de 1 
  int  defval[]={1,2,3,....}
  nitems : number of labels 	
  En sortie defval continet ce qu'on a choisit 
*/

int 
SciChoiceCreate(items,defval,nitems)
     char **items;
     int defval[];
     int nitems;
{
  int i,j;
  Everything= (SciStuff **) MALLOC( (nitems+1)*sizeof(SciStuff *));
  if ( Everything == (SciStuff **) NULL) return(0);
  Everything[nitems]= (SciStuff *) NULL;
  for ( i=0 ; i < nitems ; i++) 
    {
      char **loc= items ;
      int numch=0;
      while ( *loc != (char *) NULL) { loc++;numch++; };
      numch--;
      if ( numch == 0) 
	{
	  sciprint("x_choices : There's no choice to the %d item\r\n",i);
	  return(0);
	};
      Everything[i]= (SciStuff *) MALLOC( sizeof(SciStuff));
      if ( Everything[i] == (SciStuff *) NULL) return(0);
      if ( AllocAndCopy(&(Everything[i]->choice.name),items[0]) == 0) return(0);
      if ( AllocAndCopy(&(Everything[i]->choice.text),items[0]) == 0) return(0);
      Everything[i]->choice.num_toggles= numch;
      Everything[i]->choice.columns = (numch >= 5 ) ? 5 :  0;
      Everything[i]->choice.function = pttb;
      Everything[i]->choice.default_toggle = Min(Max(0,defval[i]-1),numch-1);
      Everything[i]->choice.label = (Widget) NULL;
      Everything[i]->data = (SciData *) MALLOC( numch*sizeof(SciData));
      if ( Everything[i]->data == (SciData *) NULL) return(0);
      for ( j = 0 ; j < numch ; j++) 
	{
	  char loc[8];
	  SciData *dataloc = Everything[i]->data ;
	  if ( AllocAndCopy(&(dataloc[j].name),items[j+1]) == 0) return(0);
	  sprintf(loc,"%d %d",i,j);
	  if ( AllocAndCopy(&(dataloc[j].cbinfo),loc) == 0) return(0);
	  dataloc->toggle=(Widget) NULL;
	}
      items = items + numch+2;
    }
  return(1);
}



int AllocAndCopy(strh1,str2)
     char **strh1, *str2;
{
  *strh1= (char *) MALLOC((strlen(str2)+1)*sizeof(char));
  if ( *strh1 == (char *) NULL) return(0);
  strcpy(*strh1,str2);
  return(1);
}


int SciChoiceFree(nitems) 
{
  int i,j;
  for ( i=0 ; i < nitems ; i++) 
    {
      for (j = 0 ; j < Everything[i]->choice.num_toggles ; j++) 
	{
	  SciData *dataloc = Everything[i]->data ;
	  FREE(dataloc[j].name);
	  FREE(dataloc[j].cbinfo);
	}
      FREE(Everything[i]->data) ;
      FREE(Everything[i]->choice.name);
      FREE(Everything[i]->choice.text);
    }
  FREE(Everything);
}

/*
 * The main function which uses the global variable 
 * Everything to deal with choices 
 */


Widget 
create_choices(toppaned,wvert)
Widget toppaned;
Widget wvert;
{
  Widget lastChoice;
  static Arg gcchoiceargs[] = {
    {XtNfromVert,    (XtArgVal) NULL}, /* put it under the one above it */
    {XtNfromHoriz,   (XtArgVal) NULL}, /* and next to that one */
    {XtNborderWidth, (XtArgVal) 0}     /* no ugly borders */
  };

  int Nchoices=0,i ;			/* counter */
  while ( Everything[Nchoices] != (SciStuff *) NULL ) Nchoices++;
  
  /* we want the choises to be after wvert */
  lastChoice = wvert ;

  /* create all the GCchoices forms */

  for (i=0 ; i < Nchoices ; ++i) {
    gcchoiceargs[0].value = (XtArgVal) lastChoice;
    lastChoice = XtCreateManagedWidget(Everything[i]->choice.text,
					 formWidgetClass,toppaned,
					 gcchoiceargs,XtNumber(gcchoiceargs));

    /* now fill up that form */
    create_choice(lastChoice,Everything[i]);
  }

  /* make all the labels inside the choices line up nicely */

  line_up_labels(Everything,Nchoices );

  return(lastChoice);
}

/* create_choice(w,info)
** ---------------------
** What a choice widget is:  A collection of toggle buttons placed inside
** a form widget.  Exactly one of these toggle buttons can be "on" at
** any given time;  the rest are "off".  "On" toggle buttons have
** the foreground and background colors reversed.
** Also, specifically because it comes in handy in Sci, choosing one
** of the buttons causes a string associated with it to be printed out
** (and interpreted).  Half of the string is global to the whole form
** and the other half is local to each button.
**
** For example, pressing the "xor" button in the "function" form would
** cause Sci to interpret the string "function xor", thus changing the
** function in the GC to xor.
**
** There's also a label widget to the left of that mess, with an
** incredibly descriptive title.
**
** create_choice() makes one.
**
** w is the form widget (already created) into which we will place the
** toggle buttons.  info contains lots of useful information, such
** as the names of the buttons and their strings (see Sci.h).
** Nchoice is the number of the choice this is useful for callback 
*/

static void
create_choice(w,info)
     Widget w;
     SciStuff *info;
{
  int i;			/* Counter */
  /* ArgList for the label widget */
  static Arg labelargs[] = {	
    {XtNborderWidth,  (XtArgVal) 0}, 
    {XtNjustify,      (XtArgVal) XtJustifyRight},
    {XtNvertDistance, (XtArgVal) 4}
  };

  /* ArgList for the toggle widgets */
  static Arg toggleargs[] = {
    {XtNfromHoriz,     (XtArgVal) NULL},
    {XtNfromVert,      (XtArgVal) NULL},
    {XtNhorizDistance, (XtArgVal) 4},
    {XtNvertDistance,  (XtArgVal) 4},
    {XtNradioGroup,    (XtArgVal) NULL},
  };

  info->choice.label = XtCreateManagedWidget(info->choice.name,labelWidgetClass,w,
					labelargs,XtNumber(labelargs));

  /* set up the toggle widgets */

  for (i = 0; i < info->choice.num_toggles; ++i) {
    if (i == 0) {
      /* the upper left toggle; put it next to the label
       and don't worry about radio groups */
      toggleargs[0].value = (XtArgVal) info->choice.label;
      toggleargs[1].value = (XtArgVal) NULL;
      toggleargs[2].value = (XtArgVal) 10;
      toggleargs[3].value = (XtArgVal) 4;
      toggleargs[4].value = (XtArgVal) NULL;
    }
    else {
      toggleargs[4].value = (XtArgVal) (info->data[0]).toggle;
				/* are we starting a new row? */
      if (info->choice.columns > 0 && 
	  i > 1 && 
	  (i % (info->choice.columns) == 0)) {
	toggleargs[0].value = (XtArgVal) info->choice.label;
	/* under the appropriate toggle */
	toggleargs[1].value = (XtArgVal) (info->data[i - info->choice.columns]).toggle;
	toggleargs[2].value = (XtArgVal) 10;
	toggleargs[3].value = (XtArgVal) 4;
      }
      else {			/* we're in the middle of a row */
	/* to the right of the previous toggle */
	toggleargs[0].value = (XtArgVal) (info->data[i - 1]).toggle;
	toggleargs[1].value = (XtArgVal) NULL;
	toggleargs[2].value = (XtArgVal) -1; /* overlapping slightly */
	toggleargs[3].value = (XtArgVal) 4;
      }

      if (info->choice.columns > 0 &&
	  i >= info->choice.columns) {
	/* correct vertical spacing */
	toggleargs[1].value = (XtArgVal) (info->data[i - info->choice.columns]).toggle;
	toggleargs[3].value = (XtArgVal) -1;
      }
    }

    /* Create it finally */
    (info->data[i]).toggle = XtCreateManagedWidget((info->data[i]).name, 
					       toggleWidgetClass,
					       w,
					       toggleargs,
					       XtNumber(toggleargs));
    /* Add the Callback function */

    XtAddCallback((info->data[i]).toggle,XtNcallback,(XtCallbackProc)info->choice.function,
		  (XtPointer) (info->data)[i].cbinfo);
    
    /* set the default toggle on */

  }
  
  /* The toggle widgets have all been created;
  ** now make the all the same width if that's
  ** what we want to do.                    */

  if (info->choice.columns > 0) {
    Dimension maxwidth = 0;	/* maximum width we've found */
    Dimension width;		/* width of the current widget */
    static Arg args[] = {	/* for getting and setting the width */
      {XtNwidth,    (XtArgVal) NULL}
    };

    args[0].value = (XtArgVal) &width;

    /* Find the maximum width of any toggle widget */
    for (i = 0; i < info->choice.num_toggles; ++i) {
      XtGetValues(info->data[i].toggle,args,1);
      maxwidth = Max(maxwidth,width);
    }

    /* Now set them all to that width */
    args[0].value = (XtArgVal) maxwidth;
    for (i = 0; i < info->choice.num_toggles; ++i)
      XtSetValues(info->data[i].toggle,args,1);
  }

  /* activate the default toggle value but don't call its callback */
  
  select_button(info->data[info->choice.default_toggle].toggle);

  /* return the list of toggles that were just created */

}


/*
  select_button(choice)
*/

static void
select_button(w)
     Widget w;
{
  static Arg toggleargs[] = {
    {XtNstate,   (XtArgVal) True}
  };

  XtSetValues(w,toggleargs,XtNumber(toggleargs));
}

/* line_up_labels(descs,numdescs)
** ------------------------------
** descs represents a bunch of choice layouts (numdescs is the size of
** descs).  This function sets each label in descs to the same width,
** thus making them line up nicely since they're all on the left margin.
*/

static void
line_up_labels(Everything,num)
     SciStuff *Everything[];
     int num;
{
  int i;			/* counter */
  Dimension width;		/* current width */
  Dimension maxwidth = (Dimension) 0; /* max width found */

  static Arg widthargs[] = {
    {XtNwidth,     (XtArgVal) NULL }
  };

  widthargs[0].value = (XtArgVal) &width;

  /* Find the maximum width */
  for (i = 0; i < num; ++i) {
    XtGetValues(Everything[i]->choice.label, widthargs, XtNumber(widthargs));
    maxwidth = Max(maxwidth,width);
  }

  /* Set all labels to that width */
  widthargs[0].value = (XtArgVal) maxwidth;
  for (i = 0; i < num; ++i) {
    XtSetValues(Everything[i]->choice.label, widthargs, XtNumber(widthargs));
  }
}


/* The callback */ 

static int
pttb(w,closure,call_data)
     Widget  w;
     caddr_t closure;           /* contains the string */
     caddr_t call_data;
{
  int itm=0,tog=0;
  sscanf((char *) closure,"%d %d",&itm,&tog);
  Everything[itm]->choice.default_toggle = tog;
}


