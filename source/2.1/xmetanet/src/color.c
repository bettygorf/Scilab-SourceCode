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
  UnhiliteArc(a);
  theGG.active = 0;
  theGG.active_type = 0;
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
  UnhiliteNode(n);
  theGG.active = 0;
  theGG.active_type = 0;
  DrawNode(n);
}

void ColorObject()
{
  if (theGG.active != 0) {
    switch (theGG.active_type) {
    case ARC:
      ColorArc((arc*)theGG.active);
      break;
    case NODE:
      ColorNode((node*)theGG.active);
      break;
    }
    theGG.modified = 1;
  }
}
