#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "menus.h"
#include "metio.h"

extern void ClearDraw();
extern int SaveGraph1();
extern void UnhiliteActive();

static graph *oldGraph;

void ModifyGraph()
{
  oldGraph = DuplicateGraph(theGraph);
  if (theGG.active != 0) {
    UnhiliteActive();
    theGG.active = 0;
    theGG.active_type = 0;
  }
  DisplayMenu(MODIFY);
  ClearDraw();
  DrawGraph(theGraph);
}

void ModifyQuit()
{
  if (theGG.modified) {
      sprintf(Description,"Graph %s has been modified. Do you want to save it first?",theGraph->name);
    if (MetanetYesOrNo(Description)) {
      if (SaveGraph1()) {
	DisplayMenu(STUDY);
	ClearDraw(); 
	DrawGraph(theGraph);
      }
      return;
    } else {
      sprintf(Description,"Graph %s has been modified and has not been saved.\n Do you really want to quit ?",theGraph->name);
      if (MetanetYesOrNo(Description)) {
	theGraph = oldGraph;
	theGG.modified = 0;
	if (theGraph->node_number == 0) {
	  DisplayMenu(BEGIN);
	  ClearDraw();
	} else {
	  DisplayMenu(STUDY);
	  ClearDraw(); 
	  DrawGraph(theGraph);
	}
      } else return;
    }
    }
  else {
    DisplayMenu(STUDY);
  }
}
