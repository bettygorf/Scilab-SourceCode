#include "list.h"
#include "graph.h"
#include "menus.h"

extern void ClearDraw();
extern void ClearGG();

void StudyQuit()
{
  ClearDraw();
  ClearGG();
  DisplayMenu(BEGIN);
}
