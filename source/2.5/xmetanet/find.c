/* Copyright INRIA */
#include <X11/Intrinsic.h>

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "metio.h"
#include "graphics.h"

extern void CenterDraw();
extern void GetDrawGeometry();
extern void UnhiliteAll();

int ArcVisible();
int NodeVisible();

void FindNode()
{
  char strn[MAXNAM];
  int n;
  mylink *p; node *nod, *nod1;
  char *label = "Give an internal number or a name";
  char *init[2];
  char *result[2];
  char *description[2];

  if (theGraph->node_number == 0) return;

  init[0]="0";
  init[1]="";
  description[0]="Node internal number";
  description[1]="Node name";
  if ((result[0] = (char*)malloc((unsigned)MAXNAM * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  if ((result[1] = (char*)malloc((unsigned)MAXNAM * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 

  if (MetanetDialogs(2,init,result,description,label)) {
    sscanf(result[0],"%d",&n);
    if (n != 0) {
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
    } else {
      strcpy(strn,result[1]);
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
  
    UnhiliteAll();
    HiliteNode(nod);
  }
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
  char *label = "Give an internal number or a name";
  char *init[2];
  char *result[2];
  char *description[2];

  if (theGraph->arc_number == 0) return;
 
  init[0]="0";
  init[1]="";
  description[0]="Arc internal number";
  description[1]="Arc name";
  if ((result[0] = (char*)malloc((unsigned)MAXNAM * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  if ((result[1] = (char*)malloc((unsigned)MAXNAM * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 

  if (MetanetDialogs(2,init,result,description,label)) {
    sscanf(result[0],"%d",&n);
    if (n != 0) {
      if (n <= 0 || n > theGraph->arc_number) {
	sprintf(Description,"%d is not an internal arc number",n);
	MetanetAlert(Description);
	return;
      }
      p = theGraph->arcs->first;
      a = 0;
      while (p) {
	a1 = (arc*)(p->element);
	if (a1->number == n) {
	  a = a1;
	  break;
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
      strcpy(strn,result[1]);
      p = theGraph->arcs->first;
      a = 0;
      while (p) {
	a1 = (arc*)(p->element);
	if (a1->name != 0 && !strcmp(a1->name,strn)) {
	  a = a1;
	  break;
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

    UnhiliteAll();
    HiliteArc(a);
  }
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
