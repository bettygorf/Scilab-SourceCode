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
  mylink *p; node *nod, *nod1;

  if (theGraph->node_number == 0) return;
  
  if (intDisplay) {
    sprintf(Description,"%s","Node internal number");
    MetanetDialog("",strn,Description);
    n = atoi(strn);
    if (n <= 0 || n > theGraph->node_number) {
      sprintf(Description,"%d is not an internal node number",n);
      MetanetAlert(Description);
      return;
    }
    p = theGraph->nodes->first;
    nod = 0;
    while (p) {
      if (((node*)(p->element))->number == n) {
	nod = (node*)(p->element);
	break;
      }
      p = p->next;
    }
    if (nod == 0) {
      sprintf(Description,"%s is not an internal node number",strn);
      MetanetAlert(Description);
      return;
    }
  }
  else {
    sprintf(Description,"%s","Node name");      
    MetanetDialog("",strn,Description);
    p = theGraph->nodes->first;
    nod = 0;
    while (p) {
      nod1 = (node*)(p->element);
      if (nod1->name != 0 && !strcmp(nod1->name,strn)) {
	nod = nod1;
	break;
      }
      p = p->next;
    }
    if (nod == 0) {
      sprintf(Description,"%s is not a node name",strn);
      MetanetAlert(Description);
      return;
    }
  }
 
  if (!NodeVisible(nod))
    CenterDraw(nod->x + NodeDiam(nod)/2,nod->y + NodeDiam(nod)/2);
  
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
      (int)(metaScale*(n->x + NodeDiam(n))) <= dx + w &&
      (int)(metaScale*n->y) >= dy && 
      (int)(metaScale*(n->y + NodeDiam(n))) <= dy + h)
    return 1;
  else return 0;
}

void FindArc()
{
  char strn[MAXNAM];
  int n;
  mylink *p; arc *a,*a1;

  if (theGraph->arc_number == 0) return;
 
  if (intDisplay) {
    sprintf(Description,"%s","Arc internal number");
    MetanetDialog("",strn,Description);
    n = atoi(strn);
    if (n <= 0 || n > theGraph->arc_number) {
      sprintf(Description,"%d is not an internal arc number",n);
      MetanetAlert(Description);
      return;
    }
    p = theGraph->arcs->first;
    a = 0;
    while (p) {
      a1 = (arc*)(p->element);
      if (theGraph->directed || (a1->number % 2 != 0)) {
	if (a1->number == n) {
	  a = a1;
	  break;
	}
      }
      p = p->next;
    }
    if (a == 0) {
      sprintf(Description,"%s is not an internal arc number",strn);
      MetanetAlert(Description);
      return;
    }
  }
  else {
    sprintf(Description,"%s","Arc name");      
    MetanetDialog("",strn,Description);
    p = theGraph->arcs->first;
    a = 0;
    while (p) {
      a1 = (arc*)(p->element);
      if (theGraph->directed || (a1->number % 2 != 0)) {
	if (a1->name != 0 && !strcmp(a1->name,strn)) {
	  a = a1;
	  break;
	}
      }
      p = p->next;
    }
    if (a == 0) {
      sprintf(Description,"%s is not an arc name",strn);
      MetanetAlert(Description);
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
