/* Copyright INRIA */
#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "menus.h"
#include "metio.h"

extern void ClearDraw();
extern int SaveGraph();
extern void UnhiliteAll();

graph *oldGraph;

void ModifyGraph()
{
  oldGraph = DuplicateGraph(theGraph);
  if (theGG.n_hilited_arcs != 0 || theGG.n_hilited_nodes != 0) {
    UnhiliteAll();
  }
  DisplayMenu(MODIFY);
}

void ModifyQuit()
{
  if (theGG.modified) {
    sprintf(Description,"Graph \"%s\" has been modified and not saved.\nQuit Modify Mode anyway?",
	    theGraph->name);
    if (MetanetYesOrNo(Description)) {
      if (theGG.n_hilited_arcs != 0 || theGG.n_hilited_nodes != 0) {
	UnhiliteAll();
      }
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
    }
    else return;
  }
  else DisplayMenu(STUDY);
}
