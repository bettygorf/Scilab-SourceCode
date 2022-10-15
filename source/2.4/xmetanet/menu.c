#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/MenuButton.h>
#include <X11/Xaw/SimpleMenu.h>
#include <X11/Xaw/SmeBSB.h>
#include <X11/Xaw/SmeLine.h>
#include <X11/bitmaps/xlogo11>

#include "metaconst.h"
#include "metawin.h"
#include "list.h"
#include "graph.h"
#include "graphics.h"
#include "menus.h"
#include "font.h"
#include "metio.h"

extern void AutomaticName();
extern void ChangeDirectory();
extern void ChooseDefaults();
extern void ColorObject();
extern void CreateLoop();
extern void CreateSink();
extern void CreateSource();
extern void DeleteObject();
extern void DisplayBeginHelp();
extern void DisplayModifyHelp();
extern void DisplayStudyHelp();
extern void FindArc();
extern void FindNode();
extern XFontStruct *FontSelect();
extern int LoadGraph();
extern void MetanetQuit();
extern void NewGraph();
extern void NameObject();
extern void ObjectCharacteristics();
extern void RemoveSourceSink();
extern void RenameSaveGraph();
extern void SaveGraph();
extern void SetTitle();

void Graphics();

static Widget metanetMenuFiles;
static Widget NewEntry, LoadEntry, DirectoryEntry, SaveEntry, SaveAsEntry;
static Widget QuitEntry;

static Widget metanetMenuGraph;
static Widget CharacteristicsEntry, FindArcEntry, FindNodeEntry; 
static Widget GraphicsEntry, ModifyGraphEntry;
static Widget PreferenceInternalEntry, PreferenceNodeNamesEntry;
static Widget PreferenceArcNamesEntry;

static Widget metanetMenuModify;
static Widget AttributesEntry, DeleteObjectEntry;
static Widget NameObjectEntry, CreateLoopEntry, CreateSinkEntry;
static Widget CreateSourceEntry, RemoveSinkSourceEntry, ColorObjectEntry;
static Widget AutomaticNameEntry, ChooseDefaultsEntry, ModifyQuitEntry;

static Widget metanetCommandRedraw;

static Widget metanetCommandHelp;

static Pixmap mark;

void FilesSelect(w, number, garbage)
Widget w;
XtPointer number, garbage;
{
  int num = (int)number;
  switch (num) {
  case 0:
    NewGraph();
    break;
  case 1:
    LoadGraph();
    break;
  case 2:
    ChangeDirectory();
    break;
  case 3:
    SaveGraph();
    break;
  case 4:
    RenameSaveGraph();
    break;
  case 5:
    if (menuId == MODIFY) {
      ModifyQuit();
    }
    else MetanetQuit();
    break;
  }
}

void GraphSelect(w, number, garbage)
Widget w;
XtPointer number, garbage;
{
  Arg arglist[1];
  Cardinal num_args = 0;
  int num = (int)number;

  switch (num) {
  case 0:
    ObjectCharacteristics();
    break;
  case 1:
    FindArc();
    break;
  case 2:
    FindNode();
    break;
  case 3:
    Graphics();
    break;
  case 4:
    ModifyGraph();
    break;
  case 5: 
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
  case 6:
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
  case 7:
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

void ModifySelect(w, number, garbage)
Widget w;
XtPointer number, garbage;
{
  int num = (int)number;
  switch (num) {
  case 0:
    ObjectAttributes();
    break;
  case 1:
    DeleteObject();
    break;
  case 2:
    NameObject();
    break;
  case 3:
    ColorObject();
    break;
  case 4:
    CreateLoop();
    break;
  case 5:
    CreateSink();
    break;
  case 6:
    CreateSource();
    break;
  case 7:
    RemoveSourceSink();
    break;
  case 8:
    AutomaticName();
    break;
  case 9:
    ChooseDefaults();
    break;
  }
}

void MenuRedraw(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  ClearDraw();
  DrawGraph(theGraph);
}

void MenuHelp(w,shell,callData)
Widget w;
caddr_t shell;
caddr_t callData;
{
  switch (menuId) {
  case BEGIN:
    DisplayBeginHelp();
    break;
  case STUDY:
    DisplayStudyHelp();
    break;
  case MODIFY:
    DisplayModifyHelp();
    break;
  }
}

void CreateMenus()
{
  Arg args[20];
  int iargs;
  Widget menuFiles, menuGraph, menuModify;
  XtCallbackRec callbacks[2];

  callbacks[1].callback = NULL;
  callbacks[1].closure = NULL;

  /* Create the bitmap for marking selected items */

  mark = XCreateBitmapFromData(XtDisplay(toplevel),
			       RootWindowOfScreen(XtScreen(toplevel)),
			       (char *)xlogo11_bits,
			       xlogo11_width, xlogo11_height);

  iargs = 0;
  XtSetArg(args[iargs], XtNdefaultDistance, 0); iargs++;
  XtSetArg(args[iargs], XtNwidth, metaWidth); iargs++;
  XtSetArg(args[iargs], XtNhSpace, 0); iargs++;
  XtSetArg(args[iargs], XtNvSpace, 0); iargs++;
  XtSetArg(args[iargs], XtNbottom, XtChainTop); iargs++;
  XtSetArg(args[iargs], XtNright, XtChainLeft); iargs++;
  XtSetArg(args[iargs], XtNorientation, XtorientHorizontal); iargs++;
  metanetMenu = XtCreateManagedWidget("menu",boxWidgetClass,frame,
				      args,iargs);

  /* Files Menu */

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Files"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNmenuName, "menuFiles"); iargs++;
  metanetMenuFiles = XtCreateManagedWidget((String)NULL,menuButtonWidgetClass,
					   metanetMenu,args,iargs);
  menuFiles = XtCreatePopupShell("menuFiles", simpleMenuWidgetClass,
				  metanetMenuFiles, NULL, 0);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "New"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  NewEntry = XtCreateManagedWidget((String)NULL,
				    smeBSBObjectClass,
				    menuFiles, args, iargs);
  XtAddCallback(NewEntry, XtNcallback, FilesSelect, (XtPointer) 0);  

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Load"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  LoadEntry = XtCreateManagedWidget((String)NULL,
				    smeBSBObjectClass,
				    menuFiles, args, iargs);
  XtAddCallback(LoadEntry, XtNcallback, FilesSelect, (XtPointer) 1);  

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Directory"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  DirectoryEntry = XtCreateManagedWidget((String)NULL,
					 smeBSBObjectClass,
					 menuFiles, args, iargs);
  XtAddCallback(DirectoryEntry, XtNcallback, FilesSelect, (XtPointer) 2);  

  iargs = 0;
  XtCreateManagedWidget((String)NULL, smeLineObjectClass,
			menuFiles, args, iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Save"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  SaveEntry = XtCreateManagedWidget((String)NULL,
				    smeBSBObjectClass,
				    menuFiles, args, iargs);
  XtAddCallback(SaveEntry, XtNcallback, FilesSelect, (XtPointer) 3);  

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Save As"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  SaveAsEntry = XtCreateManagedWidget((String)NULL,
				      smeBSBObjectClass,
				      menuFiles, args, iargs);
  XtAddCallback(SaveAsEntry, XtNcallback, FilesSelect, (XtPointer) 4);  

  iargs = 0;
  XtCreateManagedWidget((String)NULL, smeLineObjectClass,
			menuFiles, args, iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Quit"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  QuitEntry = XtCreateManagedWidget((String)NULL,
				    smeBSBObjectClass,
				    menuFiles, args, iargs);
  XtAddCallback(QuitEntry, XtNcallback, FilesSelect, (XtPointer) 5);  

  /* Graph Menu */

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Graph"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNmenuName, "menuGraph"); iargs++;
  metanetMenuGraph = XtCreateManagedWidget((String)NULL,menuButtonWidgetClass,
					   metanetMenu,args,iargs);
  menuGraph = XtCreatePopupShell("menuGraph", simpleMenuWidgetClass,
				 metanetMenuGraph, NULL, 0);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Characteristics"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  CharacteristicsEntry = XtCreateManagedWidget((String)NULL,
					  smeBSBObjectClass,
					  menuGraph, args, iargs);
  XtAddCallback(CharacteristicsEntry, XtNcallback, GraphSelect, 
		(XtPointer) 0);  

  iargs = 0;
  XtCreateManagedWidget((String)NULL, smeLineObjectClass,
			menuGraph, args, iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Find Arc"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  FindArcEntry = XtCreateManagedWidget((String)NULL,
					  smeBSBObjectClass,
					  menuGraph, args, iargs);
  XtAddCallback(FindArcEntry, XtNcallback, GraphSelect, (XtPointer) 1);  

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Find Node"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  FindNodeEntry = XtCreateManagedWidget((String)NULL,
					  smeBSBObjectClass,
					  menuGraph, args, iargs);
  XtAddCallback(FindNodeEntry, XtNcallback, GraphSelect, (XtPointer) 2); 

  iargs = 0;
  XtCreateManagedWidget((String)NULL, smeLineObjectClass,
			menuGraph, args, iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Graphics"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  GraphicsEntry = XtCreateManagedWidget((String)NULL,
					  smeBSBObjectClass,
					  menuGraph, args, iargs);
  XtAddCallback(GraphicsEntry, XtNcallback, GraphSelect, (XtPointer) 3); 
 
  iargs = 0;
  XtCreateManagedWidget((String)NULL, smeLineObjectClass,
			menuGraph, args, iargs);
  
  XtSetArg(args[iargs], XtNlabel, "Modify Graph"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  ModifyGraphEntry = XtCreateManagedWidget((String)NULL,
					   smeBSBObjectClass,
					   menuGraph, args, iargs);
  XtAddCallback(ModifyGraphEntry, XtNcallback, GraphSelect, (XtPointer) 4); 

  iargs = 0;
  XtCreateManagedWidget((String)NULL, smeLineObjectClass,
			menuGraph, args, iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Use internal numbers as names"); 
  iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  if (intDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  PreferenceInternalEntry = 
    XtCreateManagedWidget((String)NULL, smeBSBObjectClass,
			  menuGraph, args, iargs);
  XtAddCallback(PreferenceInternalEntry, XtNcallback, GraphSelect, 
		(XtPointer) 5); 

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Display arc names"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  if (arcNameDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  PreferenceArcNamesEntry = 
    XtCreateManagedWidget((String)NULL, smeBSBObjectClass,
			  menuGraph, args, iargs);
  XtAddCallback(PreferenceArcNamesEntry, XtNcallback, GraphSelect, 
		(XtPointer) 6); 

  iargs = 0;
  XtSetArg(args[iargs], XtNleftMargin, 16); iargs++;
  XtSetArg(args[iargs], XtNlabel, "Display node names"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  if (nodeNameDisplay) {
    XtSetArg(args[iargs], XtNleftBitmap, mark); iargs++;
  }
  PreferenceNodeNamesEntry = 
    XtCreateManagedWidget((String)NULL, smeBSBObjectClass,
			  menuGraph, args, iargs);
  XtAddCallback(PreferenceNodeNamesEntry, XtNcallback, GraphSelect, 
		(XtPointer) 7); 
 
  /* Modify Menu */

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Modify"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNmenuName, "menuModify"); iargs++;
  
  metanetMenuModify = XtCreateManagedWidget((String)NULL,
					    menuButtonWidgetClass,
					    metanetMenu,args,iargs);
  menuModify = XtCreatePopupShell("menuModify", simpleMenuWidgetClass,
				  metanetMenuModify, NULL, 0);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Attributes"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  AttributesEntry = XtCreateManagedWidget((String)NULL,
					  smeBSBObjectClass,
					  menuModify, args, iargs);
  XtAddCallback(AttributesEntry, XtNcallback, ModifySelect, (XtPointer) 0);  

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Delete"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  DeleteObjectEntry = XtCreateManagedWidget((String)NULL,
					    smeBSBObjectClass,
					    menuModify, args, iargs);
  XtAddCallback(DeleteObjectEntry, XtNcallback, ModifySelect, (XtPointer) 1);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Name"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  NameObjectEntry = XtCreateManagedWidget((String)NULL,
					  smeBSBObjectClass,
					  menuModify, args, iargs);
  XtAddCallback(NameObjectEntry, XtNcallback, ModifySelect, (XtPointer) 2);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Color"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  ColorObjectEntry = XtCreateManagedWidget((String)NULL,
					   smeBSBObjectClass,
					   menuModify, args, iargs);
  XtAddCallback(ColorObjectEntry, XtNcallback, ModifySelect, (XtPointer) 3);

  iargs = 0;
  XtCreateManagedWidget((String)NULL, smeLineObjectClass,
			menuModify, args, iargs);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Create Loop"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  CreateLoopEntry = XtCreateManagedWidget((String)NULL,
					  smeBSBObjectClass,
					  menuModify, args, iargs);
  XtAddCallback(CreateLoopEntry, XtNcallback, ModifySelect, (XtPointer) 4);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Create Sink"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  CreateSinkEntry = XtCreateManagedWidget((String)NULL,
					  smeBSBObjectClass,
					  menuModify, args, iargs);
  XtAddCallback(CreateSinkEntry, XtNcallback, ModifySelect, (XtPointer) 5);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Create Source"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  CreateSourceEntry = XtCreateManagedWidget((String)NULL,
					    smeBSBObjectClass,
					    menuModify, args, iargs);
  XtAddCallback(CreateSourceEntry, XtNcallback, ModifySelect, (XtPointer) 6);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Remove Sink/Source"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  RemoveSinkSourceEntry = XtCreateManagedWidget((String)NULL,
						smeBSBObjectClass,
						menuModify, args, iargs);
  XtAddCallback(RemoveSinkSourceEntry, XtNcallback, ModifySelect, 
		(XtPointer) 7);

  iargs = 0;
  XtCreateManagedWidget((String)NULL, smeLineObjectClass,
			menuModify, args, iargs); 
 
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Automatic Name"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  AutomaticNameEntry = XtCreateManagedWidget((String)NULL,
					     smeBSBObjectClass,
					     menuModify, args, iargs);
  XtAddCallback(AutomaticNameEntry, XtNcallback, ModifySelect, 
		(XtPointer) 8);

  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Default Values"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  ChooseDefaultsEntry = XtCreateManagedWidget((String)NULL,
					   smeBSBObjectClass,
					   menuModify, args, iargs);
  XtAddCallback(ChooseDefaultsEntry, XtNcallback, ModifySelect, 
		(XtPointer) 9);
 
  /* Redraw command */

  callbacks[0].callback = (XtCallbackProc)MenuRedraw;
  callbacks[0].closure = (caddr_t)NULL;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Redraw"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  
  metanetCommandRedraw = XtCreateManagedWidget((String)NULL,
					       commandWidgetClass,
					       metanetMenu,args,iargs);

  /* Help command */

  callbacks[0].callback = (XtCallbackProc)MenuHelp;
  callbacks[0].closure = (caddr_t)NULL;
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "Help"); iargs++;
  XtSetArg(args[iargs], XtNfont, theG.metafont); iargs++;
  XtSetArg(args[iargs], XtNcallback, callbacks); iargs++;
  
  metanetCommandHelp = XtCreateManagedWidget((String)NULL,
					       commandWidgetClass,
					       metanetMenu,args,iargs);

  menuId = BEGIN;
  SetTitle(BEGIN);
}

void DisplayBeginMenu()
{
   Arg arglist[1];
   Cardinal num_args;

   num_args = 0;
   XtSetArg(arglist[num_args], XtNsensitive, True); num_args++;

   XtSetValues(NewEntry, arglist, num_args);
   XtSetValues(LoadEntry, arglist, num_args);

   XtSetValues(metanetCommandHelp, arglist, num_args);

   num_args = 0;
   XtSetArg(arglist[num_args], XtNsensitive, False); num_args++;

   XtSetValues(SaveEntry, arglist, num_args);
   XtSetValues(SaveAsEntry, arglist, num_args);

   XtSetValues(metanetMenuGraph, arglist, num_args);

   XtSetValues(metanetMenuModify, arglist, num_args);

   XtSetValues(metanetCommandRedraw, arglist, num_args);
  
   SetTitle(BEGIN);
   menuId = BEGIN;
}

void DisplayStudyMenu()
{
   Arg arglist[1];
   Cardinal num_args;

   num_args = 0;
   XtSetArg(arglist[num_args], XtNsensitive, True); num_args++;

   XtSetValues(NewEntry, arglist, num_args);
   XtSetValues(LoadEntry, arglist, num_args);
   XtSetValues(SaveAsEntry, arglist, num_args);

   XtSetValues(metanetMenuGraph, arglist, num_args);

   XtSetValues(ModifyGraphEntry, arglist, num_args);

   XtSetValues(metanetCommandRedraw, arglist, num_args);

   num_args = 0;
   XtSetArg(arglist[num_args], XtNsensitive, False); num_args++;  

   XtSetValues(SaveEntry, arglist, num_args);

   XtSetValues(metanetMenuModify, arglist, num_args);

   SetTitle(STUDY);
   menuId = STUDY;
}

void DisplayModifyMenu()
{
   Arg arglist[1];
   Cardinal num_args;

   num_args = 0;
   XtSetArg(arglist[num_args], XtNsensitive, True); num_args++;

   XtSetValues(SaveEntry, arglist, num_args);

   XtSetValues(metanetMenuGraph, arglist, num_args);

   XtSetValues(metanetMenuModify, arglist, num_args);

   XtSetValues(metanetCommandRedraw, arglist, num_args);
   
   num_args = 0;
   XtSetArg(arglist[num_args], XtNsensitive, False); num_args++;

   XtSetValues(NewEntry, arglist, num_args);
   XtSetValues(LoadEntry, arglist, num_args);

   XtSetValues(ModifyGraphEntry, arglist, num_args); 

   SetTitle(MODIFY);
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

void Graphics()
{
  char result[MAXNAM];
  char init[MAXNAM];
  double smetaScale;
  float d;

  sprintf(init,"%g",metaScale);
  if (!MetanetDialog(init,result,"Scale: ")) return;

  smetaScale = metaScale;
  if (sscanf(result,"%g",&d) > 0)
    metaScale = (double)d;
  if (metaScale <= 0) metaScale = smetaScale;
  if (metaScale != smetaScale) {
    ClearDraw();
    DrawGraph(theGraph);
  }
}
