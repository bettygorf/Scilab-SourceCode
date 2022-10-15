#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "menus.h"
#include "metio.h"

extern void ClearDraw();
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
    if (MetanetYesOrNo
	("Graph %s has been modified. Do you want to save it first?",
	 theGraph->name))
      return;
    else {
      theGraph = oldGraph;
      theGG.modified = 0;
      if (theGraph->node_number == 0) {
	DisplayMenu(BEGIN);
	ClearDraw();
      }
      else {
	DisplayMenu(STUDY);
	ClearDraw(); 
	DrawGraph(theGraph);
      }
    }
  }
  else {
    DisplayMenu(STUDY);
  }
}
