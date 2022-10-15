#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/MenuButton.h>
#include <X11/Xaw/SimpleMenu.h>
#include <X11/Xaw/SmeBSB.h>
#include <X11/bitmaps/xlogo11>

#include "metaconst.h"
#include "metawin.h"
#include "list.h"
#include "graph.h"
#include "graphics.h"
#include "menus.h"

extern void AutomaticName();
extern void ColorObject();
extern void CopyGraph();
extern void CreateLoop();
extern void CreateSink();
extern void CreateSource();
extern void DeleteGraph();
extern void DeleteObject();
extern void FindArc();
extern void FindNode();
extern void Graphics();
extern void LoadComputeGraph();
extern void LoadGraph();
extern void NewGraph();
extern void NameObject();
extern void ObjectAttributes();
extern void RemoveSourceSink();
extern void RenameGraph ();
extern void RenameSaveGraph();
extern void SaveGraph();

#define MAXMENUS 20

static Pixmap mark;

static String beginMenu[] = {
  "Quit",
  "Load Graph",
  "Load and Compute Graph",
  "New Graph",
  "Delete Graph",
  "Copy Graph",
  "Rename Graph"
  };

static String studyMenu[] = {
  "Quit",
  "Object Attributes",
  "Find Node",
  "Find Arc",
  "Modify Graph",
  "Graphics",
  "Preferences"
  };

static String modifyMenu[] = {
  "Quit",
  "Delete Object",
  "Name Object",
  "Object Attributes",
  "Find Node",
  "Find Arc",
  "Create Loop",
  "Create Source",
  "Create Sink",
  "Remove Source/Sink",
  "Save Graph",
  "Rename and Save Graph",
  "Color Object",
  "Automatic Name",
  "Graphics",
  "Preferences"
  };

static int nMenu;

static Widget m[MAXMENUS];

void MetanetQuit()
{
  XtDestroyWidget(toplevel);
}

void DoMenu1(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    MetanetQuit();
    break;
  case STUDY:
    StudyQuit();
    break;
  case MODIFY:
    ModifyQuit();
    break;
  }
}

void DoMenu2(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    LoadGraph();
    break;
  case STUDY:
    ObjectAttributes();
    break;
  case MODIFY:
    DeleteObject();
    break;
  }
}

void DoMenu3(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    LoadComputeGraph();
    break;
  case STUDY:
    FindNode();
    break;
  case MODIFY:
    NameObject();
    break;
  }
}

void DoMenu4(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    NewGraph();
    break;
  case STUDY:
    FindArc();
    break;
  case MODIFY:
    ObjectAttributes();
    break;
  }
}

void DoMenu5(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    DeleteGraph();
    break;
  case STUDY:
    ModifyGraph();
    break;
  case MODIFY:
    FindNode();
    break;
  }
}

void DoMenu6(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    CopyGraph();
    break;
  case STUDY:
    Graphics();
    break;
  case MODIFY:
    FindArc();
    break;
  }
}

void DoMenu7(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    RenameGraph();
    break;
  case STUDY:
    break;
  case MODIFY:
    CreateLoop();
    break;
  }
}

void DoMenu8(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    break;
  case MODIFY:
    CreateSource();
    break;
  }
}

void DoMenu9(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    break;
  case MODIFY:
    CreateSink();
    break;
  }
}

void DoMenu10(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    break;
  case MODIFY:
    RemoveSourceSink();
    break;
  }
}

void DoMenu11(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    break;
  case MODIFY: 
    SaveGraph();
    break;
  }
}

void DoMenu12(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    break;
  case MODIFY:
   RenameSaveGraph();
    break;
  }
}

void DoMenu13(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    break;
  case MODIFY:
    ColorObject();
    break;
  }
}

void DoMenu14(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    break;
  case MODIFY:
    AutomaticName();
    break;
  }
}

void DoMenu15(widget,clientData,callData)
Widget widget;
caddr_t clientData;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    break;
  case STUDY:
    break;
  case MODIFY:
    Graphics();
    break;
  }
}

void PreferenceSelect(w, number, garbage)
Widget w;
XtPointer number, garbage;
{
  Arg arglist[1];
  Cardinal num_args = 0;
  int num = (int)number;
  switch (num) {
  case 0: 
    if (intDisplay) {
      XtSetArg(arglist[num_args], XtNleftBitmap, None);
      intDisplay = 0;
    }
    else {
      XtSetArg(arglist[num_args], XtNleftBitmap, mark);
      intDisplay = 1;
    }
    num_args++;
    XtSetValues(w, arglist, num_args);
    ClearDraw();
    DrawGraph(theGraph);
    break;
  case 1:
    if (arcNameDisplay) {
      XtSetArg(arglist[num_args], XtNleftBitmap, None);
      arcNameDisplay = 0;
    }
    else {
      XtSetArg(arglist[num_args], XtNleftBitmap, mark);
      arcNameDisplay = 1;
    }
    num_args++;
    XtSetValues(w, arglist, num_args);
    ClearDraw();
    DrawGraph(theGraph);
    break;
  case 2:
    if (nodeNameDisplay) {
      XtSetArg(arglist[num_args], XtNleftBitmap, None);
      nodeNameDisplay = 0;
    }
    else {
      XtSetArg(arglist[num_args], XtNleftBitmap, mark);
      nodeNameDisplay = 1;
    }
    num_args++;
    XtSetValues(w, arglist, num_args);
    ClearDraw();
    DrawGraph(theGraph);
    break;
  }
}

void CreateMenus()
{
  Arg args[20];
  int iargs;

  XtCallbackRec callbacks[2];

  /* Create the bitmap for marking selected items */

  mark = XCreateBitmapFromData(XtDisplay(toplevel),
			       RootWindowOfScreen(XtScreen(toplevel)),
			       (char *)xlogo11_bits,
			       xlogo11_width, xlogo11_height);

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  iargs = 0;
  XtSetArg(args[iargs], XtNdefaultDistance, 0); iargs++;
  XtSetArg(args[iargs], XtNwidth, metaWidth); iargs++;
  XtSetArg(args[iargs], XtNhSpace, 0); iargs++;
  XtSetArg(args[iargs], XtNvSpace, 0); iargs++;
  XtSetArg(args[iargs], XtNbottom, XtChainTop); iargs++;
  XtSetArg(args[iargs], XtNright, XtChainRight); iargs++;

  metanetMenu = XtCreateManagedWidget("menu",boxWidgetClass,frame,
				      args,iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNwidth, metaWidth); iargs++;
  XtSetArg(args[iargs], XtNlabel, "toto"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[0] = XtCreateManagedWidget((String)NULL,labelWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNwidth, metaWidth); iargs++;
  XtSetArg(args[iargs], XtNlabel, "toto"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[1] = XtCreateManagedWidget((String)NULL,labelWidgetClass,metanetMenu,
				 args,iargs);
  
  nMenu = 2;
}

void DisplayBeginMenu()
{
  Arg args[20];
  int iargs;
  XtCallbackRec callbacks[2];
  int i;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  for (i = 0; i < nMenu; i++) XtDestroyWidget(m[i]);

  i = 0;

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, beginMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu1;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, beginMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu2;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, beginMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu3;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, beginMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu4;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, beginMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu5;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, beginMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu6;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, beginMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu7;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  nMenu = i;
  menuId = BEGIN;
}

void DisplayStudyMenu()
{
  Arg args[20];
  int iargs;
  XtCallbackRec callbacks[2];
  int i;
  Widget entry, menuPref;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  for (i = 0; i < nMenu; i++) XtDestroyWidget(m[i]);

  i = 0;

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, studyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu1;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, studyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu2;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, studyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu3;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, studyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu4;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, studyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu5;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, studyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu6;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, studyMenu[i++]); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNmenuName, "menuPref"); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,menuButtonWidgetClass,
				 metanetMenu,args,iargs);
  menuPref = XtCreatePopupShell("menuPref", simpleMenuWidgetClass, m[i-1], 
			      NULL, 0);

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Display internal numbers as names"); 
  iargs++;
  if (intDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  entry = XtCreateManagedWidget((String)NULL,
				smeBSBObjectClass,
				menuPref, args, iargs);
  XtAddCallback(entry, XtNcallback, PreferenceSelect, (XtPointer) 0);  

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Display arc names"); 
  iargs++;
  if (arcNameDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  entry = XtCreateManagedWidget((String)NULL,
				smeBSBObjectClass,
				menuPref, args, iargs);
  XtAddCallback(entry, XtNcallback, PreferenceSelect, (XtPointer) 1);   

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Display node names"); 
  iargs++;
  if (nodeNameDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  entry = XtCreateManagedWidget((String)NULL,
				smeBSBObjectClass,
				menuPref, args, iargs);
  XtAddCallback(entry, XtNcallback, PreferenceSelect, (XtPointer) 2);  

  nMenu = i;
  menuId = STUDY;
}

void DisplayModifyMenu()
{
  Arg args[20];
  int iargs;
  XtCallbackRec callbacks[2];
  int i;
  Widget entry, menuPref;

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  for (i = 0; i < nMenu; i++) XtDestroyWidget(m[i]);

  i = 0;

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu1;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu2;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu3;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu4;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu5;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu6;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu7;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu8;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu9;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu10;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu11;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu12;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu13;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu14;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  callbacks[0].callback = DoMenu15;
  callbacks[0].closure = NULL;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,commandWidgetClass,metanetMenu,
				 args,iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNfromHoriz, m[i-1]); iargs++;
  XtSetArg(args[iargs], XtNlabel, modifyMenu[i++]); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNmenuName, "menuPref"); iargs++;
  m[i-1] = XtCreateManagedWidget((String)NULL,menuButtonWidgetClass,
				 metanetMenu,args,iargs);
  menuPref = XtCreatePopupShell("menuPref", simpleMenuWidgetClass, m[i-1], 
			      NULL, 0);

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Display internal numbers as names"); 
  iargs++;
  if (intDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  entry = XtCreateManagedWidget((String)NULL,
				smeBSBObjectClass,
				menuPref, args, iargs);
  XtAddCallback(entry, XtNcallback, PreferenceSelect, (XtPointer) 0);  

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Display arc names"); 
  iargs++;
  if (arcNameDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  entry = XtCreateManagedWidget((String)NULL,
				smeBSBObjectClass,
				menuPref, args, iargs);
  XtAddCallback(entry, XtNcallback, PreferenceSelect, (XtPointer) 1);   

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Display node names"); 
  iargs++;
  if (nodeNameDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  entry = XtCreateManagedWidget((String)NULL,
				smeBSBObjectClass,
				menuPref, args, iargs);
  XtAddCallback(entry, XtNcallback, PreferenceSelect, (XtPointer) 2);  

  nMenu = i;
  menuId = MODIFY;
}

void DisplayMenu(i)
int i;
{
  switch (i) {
  case BEGIN:
    DisplayBeginMenu();
    break;
  case STUDY:
    DisplayStudyMenu();
    break;
  case MODIFY:
    DisplayModifyMenu();
    break;
  }
  menuId = i;
}
