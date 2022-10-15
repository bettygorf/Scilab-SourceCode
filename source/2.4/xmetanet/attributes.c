/* Copyright INRIA */
#include "list.h"
#include "graph.h"
#include "menus.h"

extern void EndAddText();
extern void PrintGraph();
extern void PrintModifyArc();
extern void PrintModifyNode();
extern void StartAddText();

void ObjectCharacteristics()
{
  if (theGG.n_hilited_nodes == 1 && theGG.n_hilited_arcs == 0) {
    StartAddText();
    PrintNode((node*)theGG.hilited_nodes->first->element,1);
    EndAddText();
  }
  else if (theGG.n_hilited_nodes == 0 && theGG.n_hilited_arcs == 1) {
    StartAddText();
    PrintArc((arc*)theGG.hilited_arcs->first->element,1);
    EndAddText();    
  }
  else {
    StartAddText();
    PrintGraph(theGraph,0);
    EndAddText();
  }
}

void ObjectAttributes()
{
  if (theGG.n_hilited_nodes == 1 && theGG.n_hilited_arcs == 0) {
    PrintModifyNode((node*)theGG.hilited_nodes->first->element);
  }
  else if (theGG.n_hilited_nodes == 0 && theGG.n_hilited_arcs == 1) {
    PrintModifyArc((arc*)theGG.hilited_arcs->first->element);
  }
}
