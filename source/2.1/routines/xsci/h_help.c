/*
 * help.c : The Help browser
 *
 * George Ferguson, ferguson@cs.rochester.edu, 23 Apr 1993.
 */

#include <stdio.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/Viewport.h>
#include <X11/Xaw/List.h>
#include <X11/Xaw/AsciiText.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Cardinals.h>


extern Widget toplevel;
extern Atom wm_delete_window;

#include "version.h"

/*
 * Functions defined here
 */

void initHelpActions(),initHelpPanel();
void setHelpShellState();

/** a terminer : normalement c'est statique plus une action **/

void popupHelpPanel();

static void initHelpWidgets();
static void helpCallback();
static void helpCallback1();
static void helpDoneAction();
static void queryAproposAction();

/*
 * Data defined here
 */
static Widget helpShell;
static Widget helpLabel,helpViewport,helpList,helpList1,helpViewport1;
static Widget helpScrollbar;
static Widget aproposText;

static Boolean isPoppedUp;

static XtActionsRec actionTable[] = {
    { "help",		popupHelpPanel },
    { "help-done",	helpDoneAction },
    { "query-apropos",  queryAproposAction },  
};



static char *helpStrings1[] = {
#include "help/help-list1.h"
};
static char *helpStrings2[] = {
#include "help/help-list2.h"
};
static char *helpStrings3[] = {
#include "help/help-list3.h"
};
static char *helpStrings4[] = {
#include "help/help-list4.h"
};
static char *helpStrings5[] = {
#include "help/help-list5.h"
};
static char *helpStrings6[] = {
#include "help/help-list6.h"
};
static char *helpStrings7[] = {
#include "help/help-list7.h"
};
static char *helpStrings8[] = {
#include "help/help-list8.h"
};
static char *helpStrings9[] = {
#include "help/help-list9.h"
};
static char *helpStrings10[] = {
#include "help/help-list10.h"
};
static char *helpStrings11[] = {
#include "help/help-list11.h"
};
static char *helpStrings12[] = {
#include "help/help-list12.h"
};

static char **helpStringsApropos = 0;

static char *helpTopicInfo1[] = {
#include "help/help-text1.h"
};
static char *helpTopicInfo2[] = {
#include "help/help-text2.h"
};
static char *helpTopicInfo3[] = {
#include "help/help-text3.h"
};
static char *helpTopicInfo4[] = {
#include "help/help-text4.h"
};
static char *helpTopicInfo5[] = {
#include "help/help-text5.h"
};
static char *helpTopicInfo6[] = {
#include "help/help-text6.h"
};
static char *helpTopicInfo7[] = {
#include "help/help-text7.h"
};
static char *helpTopicInfo8[] = {
#include "help/help-text8.h"
};
static char *helpTopicInfo9[] = {
#include "help/help-text9.h"
};
static char *helpTopicInfo10[] = {
#include "help/help-text10.h"
};
static char *helpTopicInfo11[] = {
#include "help/help-text11.h"
};
static char *helpTopicInfo12[] = {
#include "help/help-text12.h"
};

static char **helpTopicApropos = 0;


static char *helpInfo[] = {
"Scilab Programming",
"Graphic Library ",
"Utilities and Elementary Functions",
"General System and Control macros.",
"Robust control toolbox",
"Non-linear tools (optimization and simulation) ",
"Signal Processing toolbox",
"Polynomial calculations",
"Linear Algebra",
"Metanet",
"Arma ",
"TdCs",
};

static int CurHelp=1;


/*	-	-	-	-	-	-	-	-	*/

void
initHelpActions(appContext)
     XtAppContext appContext;
{
    XtAppAddActions(appContext,actionTable,XtNumber(actionTable));
}

void
initHelpPanel()
{
    int i;
}

void
popupHelpPanel()
{
    if (isPoppedUp) {
	XRaiseWindow(XtDisplay(helpShell),XtWindow(helpShell));
	return;
    }
    if (helpShell == NULL) {
	initHelpWidgets();
    }
    isPoppedUp = True;
    XtPopup(helpShell,XtGrabNone);
}

static void
initHelpWidgets()
{
    Widget form;
    char buf[64];
    Arg args[1];
    helpShell = XtCreatePopupShell("helpShell",topLevelShellWidgetClass,
				   toplevel,NULL,0);
    form = XtCreateManagedWidget("helpForm",formWidgetClass,
				 helpShell,NULL,0);
    helpLabel = XtCreateManagedWidget("helpLabel",labelWidgetClass,
				      form,NULL,0);
    sprintf(buf,"This is help for %s",VERSION);
    if (helpLabel != NULL && buf != NULL) {
	XtSetArg(args[0],XtNlabel,buf);
	XtSetValues(helpLabel,args,1);
      };
    helpViewport = XtCreateManagedWidget("helpViewport",viewportWidgetClass,
					 form,NULL,0);
    helpList = XtCreateManagedWidget("helpList",listWidgetClass,
				     helpViewport,NULL,0);
    XawListChange(helpList,helpTopicInfo1,XtNumber(helpTopicInfo1),0,True);
    XtAddCallback(helpList,XtNcallback,helpCallback,NULL);
    helpViewport1 = XtCreateManagedWidget("helpViewport1",viewportWidgetClass,
					 form,NULL,0);
    helpList1 = XtCreateManagedWidget("helpList1",listWidgetClass,
				     helpViewport1,NULL,0);
    XawListChange(helpList1,helpInfo,XtNumber(helpInfo),0,True);
    XtAddCallback(helpList1,XtNcallback,helpCallback1,NULL);
    (void)XtCreateManagedWidget("helpDoneButton",commandWidgetClass,
				form,NULL,0);
    helpScrollbar = XtNameToWidget(helpViewport,"vertical");
    (void)XtCreateManagedWidget("aproposLabel",labelWidgetClass,
                                form,NULL,0);
    aproposText = XtCreateManagedWidget("aproposText",asciiTextWidgetClass,
                                         form,NULL,0);
    XtRealizeWidget(helpShell);
    (void)XSetWMProtocols(XtDisplay(helpShell),XtWindow(helpShell), &wm_delete_window,1);
}

#define APROPOSMAX 100

#define TopicSearch(listtop,listref,topicstr) \
	    if ( strstr(listtop[j],topicstr) != 0) \
	      { \
		helpTopicApropos[ii]=(char *) malloc( (sizeof(char))*(strlen(listtop[j])+1)); \
		if ( helpTopicApropos[ii] == ( char *) 0) \
		  { \
		    Scistring("\n Can't create apropos : No more Memory "); \
		    return; \
		  } \
		strcpy(helpTopicApropos[ii],listtop[j]); \
		helpStringsApropos[ii] =(char *) malloc( (sizeof(char))*(strlen(listref[j])+1));\
		if ( helpStringsApropos[ii] == ( char *) 0) \
		  { \
		    Scistring("\n Can't create apropos : No more Memory ");\
		    return; \
		  } \
		strcpy(helpStringsApropos[ii],listref[j]);\
		ii++; \
	      } 

#define	TopicSearchW(LTop,LStr,str) \
	j=0; \
	while ( ii < APROPOSMAX && j < XtNumber(LTop)) \
	  { \
	    TopicSearch(LTop,LStr,str)  \
	    j++; \
	  } 

void 
changeHelpList(i)
     int i;
{
  CurHelp=i;
  switch (i) 
    {
    case 1 :
      XawListChange(helpList,helpTopicInfo1, XtNumber(helpTopicInfo1),0,True);break;
    case 2 :
      XawListChange(helpList,helpTopicInfo2, XtNumber(helpTopicInfo2),0,True);break;
    case 3 :
      XawListChange(helpList,helpTopicInfo3, XtNumber(helpTopicInfo3),0,True);break;
    case 4 :
      XawListChange(helpList,helpTopicInfo4, XtNumber(helpTopicInfo4),0,True);break;
    case 5 :
      XawListChange(helpList,helpTopicInfo5, XtNumber(helpTopicInfo5),0,True);break;
    case 6 :
      XawListChange(helpList,helpTopicInfo6, XtNumber(helpTopicInfo6),0,True);break;
    case 7 :
      XawListChange(helpList,helpTopicInfo7, XtNumber(helpTopicInfo7),0,True);break;
    case 8 :
      XawListChange(helpList,helpTopicInfo8, XtNumber(helpTopicInfo8),0,True);break;
    case 9 :
      XawListChange(helpList,helpTopicInfo9, XtNumber(helpTopicInfo9),0,True);break;
    case 10 :
      XawListChange(helpList,helpTopicInfo10, XtNumber(helpTopicInfo10),0,True);break;
    case 11 :
      XawListChange(helpList,helpTopicInfo11, XtNumber(helpTopicInfo11),0,True);break;
    case 12 :
      XawListChange(helpList,helpTopicInfo12, XtNumber(helpTopicInfo12),0,True);break;
    }
}

void
setHelpShellState(state)
int state;
{
    if (!isPoppedUp)
	return;
    switch (state) {
	case NormalState:
	    XtMapWidget(helpShell);
	    break;
	case IconicState:
	    XtUnmapWidget(helpShell);
	    break;
    }
}

/*	-	-	-	-	-	-	-	-	*/
/* Callback procedure */

#define SCIMAN(x) sprintf(buf,"$SCI/bin/scilab -help %s 2> /dev/null | $SCI/bin/xless  2> /dev/null &",x[topic]); break;

/*ARGSUSED*/
static void
helpCallback(w,client_data,call_data)
Widget w;
XtPointer client_data;  /* not used */
XtPointer call_data;    /* returnStruct */
{
  char buf[256];
  int topic = ((XawListReturnStruct*)call_data)->list_index;
  switch ( CurHelp)
    {
    case 1: SCIMAN(helpStrings1);
    case 2: SCIMAN(helpStrings2);
    case 3: SCIMAN(helpStrings3);
    case 4: SCIMAN(helpStrings4);
    case 5: SCIMAN(helpStrings5);
    case 6: SCIMAN(helpStrings6);
    case 7: SCIMAN(helpStrings7);
    case 8: SCIMAN(helpStrings8);
    case 9: SCIMAN(helpStrings9);
    case 10: SCIMAN(helpStrings10);
    case 11: SCIMAN(helpStrings11);
    case 12: SCIMAN(helpStrings12);
    case 13: SCIMAN(helpStringsApropos);
    default: 
      return;
    }
  system(buf);

}


/*ARGSUSED*/
static void
helpCallback1(w,client_data,call_data)
Widget w;
XtPointer client_data;  /* not used */
XtPointer call_data;    /* returnStruct */
{
  char buf[256];
  int topic = ((XawListReturnStruct*)call_data)->list_index;
  changeHelpList(topic+1);
}


/*	-	-	-	-	-	-	-	-	*/
/* Action procedures */

#define ACTION_PROC(NAME)	void NAME(w,event,params,num_params) \
					Widget w; \
					XEvent *event; \
					String *params; \
					Cardinal *num_params;

/*ARGSUSED*/
static
ACTION_PROC(helpDoneAction)
{
    XtPopdown(helpShell);
    isPoppedUp = False;
}


char *
getWidgetString(widget)
Widget widget;
{
    Arg args[1];
    char *s;

    XtSetArg(args[0],XtNstring,&s);
    XtGetValues(widget,args,1);
    return(s);
}

static
ACTION_PROC(queryAproposAction)
{
  char *apropos;
  if ((apropos=getWidgetString(aproposText)) == NULL || *apropos == '\0') {
    Scistring("\nNo Apropos string specified ");
        return;
    }
  else 
   {
     SciApropos(apropos);
   }
}



SciApropos(str)
     char *str;
{
  int j=0,ii=0;
  if ( helpTopicApropos ==  (char **) 0)
    helpTopicApropos = (char **) malloc( (sizeof(char *))*APROPOSMAX);
  if ( helpTopicApropos ==  (char **) 0)
    {
      Scistring("\n Can't create apropos : No more Memory ");
      return;
    }
  if ( helpStringsApropos ==  (char **) 0)
    helpStringsApropos = (char **) malloc( (sizeof(char *))*APROPOSMAX);
  if ( helpStringsApropos ==  (char **) 0)
    {
      Scistring("\n Can't create apropos : No more Memory ");
      return;
    }
  TopicSearchW(helpTopicInfo1,helpStrings1,str) ;
  TopicSearchW(helpTopicInfo2,helpStrings2,str) ;
  TopicSearchW(helpTopicInfo3,helpStrings3,str) ;
  TopicSearchW(helpTopicInfo4,helpStrings4,str) ;
  TopicSearchW(helpTopicInfo5,helpStrings5,str) ;
  TopicSearchW(helpTopicInfo6,helpStrings6,str) ;
  TopicSearchW(helpTopicInfo7,helpStrings7,str) ;
  TopicSearchW(helpTopicInfo8,helpStrings8,str) ;
  TopicSearchW(helpTopicInfo9,helpStrings9,str) ;
  TopicSearchW(helpTopicInfo10,helpStrings10,str) ;
  TopicSearchW(helpTopicInfo11,helpStrings11,str) ;
  TopicSearchW(helpTopicInfo12,helpStrings12,str) ;
  if ( ii == 0) 
    {
      Scistring("\nNo Info on this topic ");
      return;
    }
  XawListChange(helpList,helpTopicApropos,ii,0,True);
  CurHelp =13;
}

