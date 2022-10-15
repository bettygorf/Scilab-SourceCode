#include "list.h"
#include "graph.h"
#include "color.h"
#include "metio.h"

char *colorNames[] = {
  "foreground",
  "Black",
  "Navyblue",
  "Blue",
  "Skyblue",
  "Aquamarine",
  "Forestgreen",
  "Green",
  "Lightcyan",
  "Cyan",
  "Orange",
  "Red",
  "Magenta",
  "Violet",
  "Yellow",
  "Gold",
  "Beige",
  "White",
  "background",
  0
};

unsigned long Colors[NUMCOLORS];
unsigned long theColor;

void ColorArc(a)
arc *a;
{
  char color[MAXNAM];
  if (!MetanetChoose("Choose a color",colorNames,color))
    return;
  a->col = FindInLarray(color,colorNames) - 1;
  theColor = Colors[a->col];
  DrawArc(a);
}

void ColorNode(n)
node *n;
{
  char color[MAXNAM];
  if (!MetanetChoose("Choose a color",colorNames,color))
    return;
  n->col = FindInLarray(color,colorNames) - 1;
  theColor = Colors[n->col];
  DrawNode(n);
}

void ColorObject()
{
  if (theGG.n_hilited_nodes == 0 && theGG.n_hilited_arcs == 1) {
    ColorArc((arc*)theGG.hilited_arcs->first->element);
    theGG.modified = 1;
  }
  else if (theGG.n_hilited_nodes == 1 && theGG.n_hilited_arcs == 0) {
    ColorNode((node*)theGG.hilited_nodes->first->element);
    theGG.modified = 1;
  }
}
