#include <X11/Intrinsic.h>

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "metio.h"
#include "graphics.h"

extern void CenterDraw();
extern void GetDrawGeometry();

int ArcVisible();
int NodeVisible();

void FindNode()
{
  char strn[MAXNAM];
  int n;
  node *nod;

  if (theGraph->node_number == 0) return;
  
  if (intDisplay) {
    MetanetDialog("",strn,"%s","Node internal number");
    n = atoi(strn);
    if (n <= 0 || n > theGraph->node_number) {
      MetanetAlert("%d is not an internal node number",n);
      return;
    }
    nod = GetNode(n,theGraph);
    if (nod == 0) {
      MetanetAlert("%s is not an internal node number",strn);
      return;
    }
  }
  else {
    MetanetDialog("",strn,"%s","Node name");      
    nod = GetNamedNode(strn,theGraph);
    if (nod == 0) {
      MetanetAlert("%s is not a node name",strn);
      return;
    }
  }
 
  if (!NodeVisible(nod))
    CenterDraw(nod->x + nodeDiam/2,nod->y + nodeDiam/2);
  
  ReDrawGraph(theGraph);
  HiliteNode(nod);
  theGG.active = (ptr)nod;
  theGG.active_type = NODE;
}

int NodeVisible(n)
node *n;
{
  int dx, dy, w, h;
  
  GetDrawGeometry(&dx,&dy,&w,&h);

  if ((int)(metaScale*n->x) >= dx &&
      (int)(metaScale*(n->x + nodeDiam)) <= dx + w &&
      (int)(metaScale*n->y) >= dy && 
      (int)(metaScale*(n->y + nodeDiam)) <= dy + h)
    return 1;
  else return 0;
}

void FindArc()
{
  char strn[MAXNAM];
  int n;
  arc *a;

  if (theGraph->arc_number == 0) return;
 
  if (intDisplay) {
    MetanetDialog("",strn,"%s","Arc internal number");
    n = atoi(strn);
    if (n <= 0 || n > theGraph->arc_number) {
      MetanetAlert("%d is not an internal arc number",n);
      return;
    }
    a = GetArc(n,theGraph);
    if (a == 0) {
      MetanetAlert("%s is not an internal arc number",strn);
      return;
    }
  }
  else {
    MetanetDialog("",strn,"%s","Arc name");      
    a = GetNamedArc(strn,theGraph);
    if (a == 0) {
      MetanetAlert("%s is not an arc name",strn);
      return;
    }
  }
   

  if (!ArcVisible(a))
    CenterDraw(a->xmax,a->ymax);

  ReDrawGraph(theGraph);
  HiliteArc(a);
  theGG.active = (ptr)a;
  theGG.active_type = ARC;
}

int ArcVisible(a)
arc *a;
{
  int dx, dy, w, h;
  
  GetDrawGeometry(&dx,&dy,&w,&h);

  if (NodeVisible(a->tail) && NodeVisible(a->head) &&
      (int)(metaScale*a->xmax) >= dx && (int)(metaScale*a->xmax) <= dx + w &&
      (int)(metaScale*a->ymax) >= dy && (int)(metaScale*a->ymax) <= dy + h)
    return 1;
  else return 0;
}
