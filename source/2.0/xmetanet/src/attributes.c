#include "list.h"
#include "graph.h"
#include "menus.h"

extern void EndAddText();
extern void PrintModifyArc();
extern void PrintModifyNode();
extern void StartAddText();
extern void UnhiliteActive();

void ObjectAttributes()
{
  if (theGG.active != 0) {
    if (menuId != MODIFY) {
      StartAddText();
      switch (theGG.active_type) {
      case ARC:
	PrintArc((arc*)theGG.active,1);
	break;
      case NODE:
	PrintNode((node*)theGG.active,1);
	break;
      }
      EndAddText();
    }
    else {
      switch (theGG.active_type) {
      case ARC:
	PrintModifyArc((arc*)theGG.active);
	break;
      case NODE:
	PrintModifyNode((node*)theGG.active);
	break;
      }
      UnhiliteActive();
      theGG.active = 0;
      theGG.active_type = 0;
    }
  }
  else {
    StartAddText();
    PrintGraph(theGraph,0);
    EndAddText();
  }
}
