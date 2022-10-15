#include <malloc.h>
#include <string.h>
#include <stdio.h>

#include "defs.h"
#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "metio.h"

extern void PrintArcList();
extern void PrintNodeList();

#define max(a,b) ((a) > (b) ? (a) : (b))

void CopyArcInGraph();
void CopyNodeInGraph();
void DeleteArc();
void DeleteEdge();
void DeleteNode();
void PrintArc();
void RenumberGraph();

node *NodeAlloc(i)
int i;
{
  node *n;

  if ((n = (node*)malloc((unsigned)sizeof(node))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  n->number = i; 
  n->name = 0;
  n->connected_arcs = ListAlloc();
  n->loop_arcs = ListAlloc();
  n->demand = 0;
  n->type = PLAIN; 
  n->x = 0; 
  n->y = 0; 
  n->col = 0; 
  n->diam = 0;
  n->border = 0;
  n->fontSize = 0; 
  n->hilited = 0;
  return n;
}

arc *ArcAlloc(i)
int i;
{
  arc *a;

  if ((a = (arc*)malloc((unsigned)sizeof(arc))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  a->number = i;
  a->tail = 0;
  a->head = 0;
  a->name = 0;
  a->unitary_cost = a->minimum_capacity = a->maximum_capacity = a->length = 0;
  a->quadratic_weight = a->quadratic_origin = a->weight = 0;
  a->g_type = 0;
  a->x0 = a->y0 = a->x1 = a->y1 = a->x2 = a->y2 = a->x3 = a->y3 = 0;
  a->xmax = a->ymax = a->xa0 = a->ya0 = 0;
  a->xa1 = a->ya1 = a->xa2 = a->ya2 = a->xa3 = a->ya3 = 0;
  a->col = 0;
  a->width = 0;
  a->hiWidth = 0;
  a->fontSize = 0;
  a->hilited = 0;
  return a;
}

graph *GraphAlloc(n)
char *n;
{
  graph *g;
  int i;

  if ((g = (graph*)malloc((unsigned)sizeof(graph))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  } 
  strcpy(g->name,n); g->un_graph = 0;
  g->arcs = ListAlloc();
  g->nodes = ListAlloc();
  g->sinks = ListAlloc();
  g->sources = ListAlloc();
  g->node_number = g->arc_number = 0;
  g->sink_number = g->source_number = 0;
  g->directed = 1;
  g->nodeDiam = NODEDIAM;
  g->nodeBorder = NODEW;
  g->arcWidth = ARCW;
  g->arcHiWidth = ARCH;
  g->fontSize = DRAWFONTSIZE;
  return g;
}

void DestroyGraph(g)
graph *g;
{
  int i;

  if (g == NULL) return;
  DestroyGraph(g->un_graph);
  for (i = 1; i <= g->arc_number; i++) free((char*)g->arcArray[i]);
  for (i = 1; i <= g->node_number; i++) free((char*)g->nodeArray[i]);
  free((char*)g->arcArray);
  free((char*)g->nodeArray);
  free((char*)g->nameEdgeArray);
  free((char*)g->nameNodeArray);
  free((char*)g);
}

void DeleteObject()
{
  if (theGG.active != 0) {
    switch (theGG.active_type) {
    case NODE:
      DeleteNode((node*)theGG.active,theGraph);
      break;
    case ARC:
      DeleteArc((arc*)theGG.active,theGraph);
      break;
    }
    theGG.modified = 1;
    RenumberGraph(theGraph);
  }
}

node *AddNode(x, y, g)
int x, y;
graph *g;
{
  node *n;

  n = NodeAlloc(++(g->node_number));
  n->x = x - NodeDiam(n) / 2;
  n->y = y - NodeDiam(n) / 2;
  AddListElement((ptr)n,g->nodes);
  return n;
}

void DeleteNode(n, g)
node *n;
graph *g;
{
  char *name = n->name;
  mylink *p;
  arc *a;

  RemoveListElement((ptr)n,g->nodes);
  g->node_number--;
  if (name != 0) theGraph->nameNodeArray[n->number] = 0;
  p = n->connected_arcs->first;
  while (p) {
    a = (arc*)p->element;
    if (g->directed || (a->number % 2 != 0)) 
      /* the graph is directed or the graph is undirected and arc number
	 is odd */
      DeleteArc(a,g);
    p = p->next;
  }
  p = n->loop_arcs->first;
  while (p) {
    a = (arc*)p->element;
    if (g->directed || (a->number % 2 != 0)) 
      /* the graph is directed or the graph is undirected and arc number
	 is odd */
      DeleteArc(a,g);
    p = p->next;
  }
  /* node is a source */
  if (n->type == SOURCE) {
    g->source_number--;
    RemoveListElement((ptr)n,g->sources);
  }
  if (n->type == SINK) {
    g->sink_number--;
    RemoveListElement((ptr)n,g->sinks);
  }
  theGG.active = 0;
  theGG.active_type = 0;
  UnhiliteNode(n);
  EraseNode(n);
  free((char*)n);
}

int ComputeNewType(t, h)
node *t, *h;
{
  int empty = 1;
  int ga[MAXARCS];
  int i;
  mylink *p1, *p2;
  arc *a1;
  int g;

  if (t == h) {
    g = LOOP - 1;
    p1 = t->loop_arcs->first;
    while (p1) {  
      g = max(((arc *)p1->element)->g_type,g);
      p1 = p1->next;
    } 
    return(g+1);
  }

  for (i = 0; i < MAXARCS; i++) ga[i] = 0;
  p1 = t->connected_arcs->first;
  while (p1) {
    p2 = h->connected_arcs->first;
    while (p2) {
      if (p1->element == p2->element) {
	a1 = (arc*)p1->element;
	if (theGraph->directed || (a1->number % 2 != 0)) {
	  g = a1->g_type;
	  empty = 0;
	  if (g >= 0) ga[2*g] = 1;
	  else ga[-2*g-1] = 1;
	}
      }
      p2 = p2->next;
    }
    p1 = p1->next;
  }
  if (empty) return 0;
  empty = 1;
  for (i = 0; i < MAXARCS; i++) {
    if (ga[i] == 0) {
      empty = 0;
      break;
    }
  }
  if (empty) {
    sprintf(Description,"Too many arcs between two nodes\n");
    MetanetAlert(Description);    
    return ERRTYPE;
  }
  if (i % 2 == 0) return i/2;
  else return -(i + 1)/2;
}

arc *AddEdge(t, h, g)
node *t, *h;
graph *g;
{
  arc *a1, *a2;
  int c;

  /* create 2 arcs 2p+1 and 2p+2 between t and h and returns odd arc */
  a1 = ArcAlloc(++(g->arc_number));
  a1->tail = t; a1->head = h;
  a2 = ArcAlloc(++(g->arc_number));
  a2->tail = h; a2->head = h;
  c = ComputeNewType(t,h);
  if (c == ERRTYPE) {
    --(g->arc_number); --(g->arc_number);
    free((char*)a1); free((char*)a2);
    return 0;
  }
  a1->g_type = c;
  SetCoordinatesArc(a1);
  a2->g_type = 0;
  AddListElement((ptr)a1,g->arcs);
  AddListElement((ptr)a2,g->arcs);
  if (t == h) {
    AddListElement((ptr)a1,t->loop_arcs);
    AddListElement((ptr)a2,t->loop_arcs);   
  } else {
    AddListElement((ptr)a1,t->connected_arcs);
    AddListElement((ptr)a2,t->connected_arcs);
    AddListElement((ptr)a1,h->connected_arcs);
    AddListElement((ptr)a2,h->connected_arcs);
  }
  return a1;
}

arc *AddArc(t, h, g)
node *t, *h;
graph *g;
{
  arc *a;
  int c;

  if (g->directed) {
    a = ArcAlloc(++(g->arc_number));
    a->tail = t; a->head = h;
    c = ComputeNewType(t,h);
    if (c == ERRTYPE) {
      --(g->arc_number);
      free((char*)a);
      return 0;
    }
    a->g_type = c;
    SetCoordinatesArc(a);
    AddListElement((ptr)a,g->arcs);
    if (t == h) AddListElement((ptr)a,t->loop_arcs);
    else {
      AddListElement((ptr)a,t->connected_arcs);
      AddListElement((ptr)a,h->connected_arcs);
    } 
    return a;
  }
  else return AddEdge(t,h,g);
}

void DeleteArc(a, g) 
arc *a;
graph *g;
{
  char *name;
  if (g->directed) {
    name = a->name;
    if (name != 0) g->nameEdgeArray[a->number] = 0;
    RemoveListElement((ptr)a,g->arcs);
    g->arc_number--;
    if (a->g_type >= LOOP) RemoveListElement((ptr)a,a->tail->loop_arcs);
    else {
      RemoveListElement((ptr)a,a->tail->connected_arcs);
      RemoveListElement((ptr)a,a->head->connected_arcs);
    }
    /* arc a is not deleted because a node is deleted */
    if (theGG.active_type == ARC) {
      theGG.active = 0;
      theGG.active_type = 0;
      UnhiliteArc(a);
    }
    EraseArc(a);
    DrawNode(a->tail);
    DrawNode(a->head);
    free((char*)a);
  }
  else
    DeleteEdge(a,g);
}

void DeleteEdge(a, g)
arc *a;
graph *g;
{
  mylink *p;
  arc *a2;
  char *name;

  /* delete edge corresponding to odd arc a from the undirected graph */
  name = a->name;
  if (name != 0) g->nameEdgeArray[a->number / 2 + a->number % 2] = 0;  
  p = g->arcs->first;
  while (p) {
    a2 = (arc*)p->element;
    if (a2->number == a->number + 1)
      break;
    p = p->next;
  }
  RemoveListElement((ptr)a,g->arcs);
  RemoveListElement((ptr)a2,g->arcs);
  g->arc_number -= 2;
  if (a->g_type >= LOOP) {
    RemoveListElement((ptr)a,a->tail->loop_arcs);
    RemoveListElement((ptr)a,a->head->loop_arcs);
  } else {
    RemoveListElement((ptr)a,a->tail->connected_arcs);
    RemoveListElement((ptr)a,a->head->connected_arcs);
    RemoveListElement((ptr)a2,a2->tail->connected_arcs);
    RemoveListElement((ptr)a2,a2->head->connected_arcs);
  }
  /* edge corresponding to a is not deleted because a node is deleted */
  if (theGG.active_type == ARC) {
    theGG.active = 0;
    theGG.active_type = 0;
    UnhiliteArc(a);
  }
  EraseArc(a);
  free((char*)a);
}

void MakeArraysGraph(g)
graph *g;
{
  mylink *p;
  int i;
  arc *a;
  node *n;

  if ((g->arcArray = 
       (arc**)malloc((unsigned)(g->arc_number+1) * sizeof(arcptr))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  if ((g->nameEdgeArray = 
       (char**)malloc((unsigned)(EdgeNumber(g)+1) * sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  p = g->arcs->first;
  i = g->arc_number;
  while (p) {
    a = (arc*)p->element;
    g->arcArray[i--] = a;
    p = p->next;
  }

  if ((g->nodeArray = 
       (node**)malloc((unsigned)(g->node_number+1)*sizeof(nodeptr))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }  
  if ((g->nameNodeArray = 
       (char**)malloc((unsigned)(g->node_number+1)*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  p = g->nodes->first;
  i = g->node_number;
  while (p) {
    n = (node*)p->element;
    g->nodeArray[i--] = n;
    p = p->next;
  }
}

void ComputeNameArraysGraph(g)
graph *g;
{
  mylink *p;
  int i;
  arc *a;
  node *n;

  p = g->arcs->first;
  i = g->arc_number;
  while (p) {
    a = (arc*)p->element;
    if (g->directed || (a->number % 2 != 0)) {
      g->nameEdgeArray[(i+1)/2] = a->name;
      i--;
    }
    p = p->next;
  }

  p = g->nodes->first;
  i = g->node_number;
  while (p) {
    n = (node*)p->element;
    g->nameNodeArray[i--] = n->name;
    p = p->next;
  }
}

arc *GetArc(n, g)
int n;
graph *g;
{
  if (n > g->arc_number) return 0;
  else return g->arcArray[n];
}

arc *GetNamedArc(n, g)
char *n;
graph *g;
{
  int i;
  for (i = 0; i < EdgeNumber(g); i++) {
    if (strcmp(g->nameEdgeArray[i+1],n) == 0)
      return g->arcArray[EdgeToArcNumber(i+1,g)];
  }
  return 0;
}
  
node *GetNode(n, g)
int n;
graph *g;
{
  if (n > g->node_number) return 0;
  else return g->nodeArray[n];
}

node *GetNamedNode(n, g)
char *n;
graph *g;
{
  int i;
  for (i = 0; i < g->node_number; i++) {
    if (strcmp(g->nameNodeArray[i+1],n) == 0)
      return g->nodeArray[i+1];
  }
  return 0;
}

void PrintGraph(g, level)
graph *g;
int level;
{
  mylink *p;
  arc *a;

  sprintf(Description,"Graph %s :\n",g->name);
  AddText(Description);
  if (g->directed) {
    sprintf(Description,"  Arcs : \n");
    AddText(Description);
    PrintArcList(g->arcs,level);
  }
  else {
    sprintf(Description,"  Edges : \n");
    AddText(Description);
    p = g->arcs->first;
    while (p) {
      a = (arc*)p->element;
      if (a->number % 2 != 0) PrintArc(a,level);
      p = p->next;
    }
    sprintf(Description,"\n");
    AddText(Description);
  }
  sprintf(Description,"  Nodes : \n");
  AddText(Description);
  PrintNodeList(g->nodes,level);
  sprintf(Description,"  Sources : \n");
  AddText(Description);
  PrintNodeList(g->sources,level);
  sprintf(Description,"  Sinks : \n");
  AddText(Description);
  PrintNodeList(g->sinks,level);
  sprintf(Description,"\n");
  AddText(Description);
}

void PrintNode(n, level)
node *n;
int level;
{
  mylink *p;
  arc *a;

  if (level == 0) {
    sprintf(Description,"%s ",n->name); 
    AddText(Description);
  }
  else {
    sprintf(Description,"Node %s\n",n->name);
    AddText(Description);
    sprintf(Description,"  Internal number %d\n",n->number);
    AddText(Description);
    if (theGraph->directed) {
      sprintf(Description,"  Connected Arcs : ");
      AddText(Description);
      PrintArcList(n->connected_arcs,0);
      sprintf(Description,"  Loop Arcs : ");
      AddText(Description);
      PrintArcList(n->loop_arcs,0);
    }
    else {
      sprintf(Description,"  Connected Edges : ");
      AddText(Description);
      p = n->connected_arcs->first;
      while (p) {
	a = (arc*)p->element;
	if (a->number % 2 != 0) PrintArc(a,0);
	p = p->next;
      }
      sprintf(Description,"\n");
      AddText(Description);
      sprintf(Description,"  Loop Edges : ");
      AddText(Description);
      p = n->loop_arcs->first;
      while (p) {
	a = (arc*)p->element;
	if (a->number % 2 != 0) PrintArc(a,0);
	p = p->next;
      }
      sprintf(Description,"\n");
      AddText(Description);
    }
    if (level >= 2) {
      sprintf(Description,"  Type : %d\n",n->type);
      AddText(Description);
    }
    sprintf(Description,"  X : %d, Y : %d  \n",n->x,n->y);
    AddText(Description);
    sprintf(Description,"  Demand : %g  \n",n->demand);  
    AddText(Description);
  }
}

void PrintModifyNode(n)
node *n;
{
  char label[64];
  char *init[4];
  char *result[4];
  char *description[4];
  char str[64];
  int i = 0;
  float d; int v;
  int sdiam, sborder, sfontsize;
  int redraw = 0;
  mylink *p; arc *a;

  sprintf(label,"Node %s\n  Internal number %d\n",n->name,n->number);
  sprintf(str,"%g",n->demand);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Demand: ";
  i++;

  if (n->diam == 0) strcpy(str,"default");
  else sprintf(str,"%d",n->diam);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Diameter: ";
  i++;

  if (n->border == 0) strcpy(str,"default");
  else sprintf(str,"%d",n->border);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Border width: ";
  i++;

  if (n->fontSize == 0) strcpy(str,"default");
  else sprintf(str,"%d",n->fontSize);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Font size: ";
  i++;

  if (MetanetDialogs(i,init,result,description,label)) {
    theGG.modified = 1;
    i = 0;

    sscanf(result[i],"%g",&d);
    n->demand = (double)d; i++;

    sdiam = NodeDiam(n);
    if (!strcmp(result[i],"default")) v = 0;
    else sscanf(result[i],"%d",&v);
    n->diam = v; i++;
    if (n->diam < 0) n->diam = sdiam;
    if (n->diam != sdiam) redraw = 1;

    sborder = NodeBorder(n);
    if (!strcmp(result[i],"default")) v = 0;
    else sscanf(result[i],"%d",&v);
    n->border = v; i++;
    if (n->border < 0 || n->border > n->diam/2) n->border = sborder;
    if (n->border != sborder) redraw = 1;

    sfontsize = NodeFontSize(n);
    if (!strcmp(result[i],"default")) v = 0;
    else sscanf(result[i],"%d",&v);
    n->fontSize = v; i++;
    if (n->fontSize < 0) n->fontSize = sfontsize;
    if (n->fontSize != sfontsize) redraw = 1;

    if (redraw) {
      p = n->connected_arcs->first;
      while (p) {
	a = (arc*)p->element;
	SetCoordinatesArc(a);
	p = p->next;
      }
      ClearDraw();
      ReDrawGraph(theGraph);
    }
  }
}

void PrintArc(a, level)
arc *a;
int level;
{
  if (level == 0) {
    sprintf(Description,"%s ",a->name);
    AddText(Description);
  }
  else {
    if (theGraph->directed) {
      sprintf(Description,"Arc %s :\n",a->name);
      AddText(Description);
      sprintf(Description,"  Internal number %d\n",a->number);
      AddText(Description);
      sprintf(Description,"  Tail node %s\n",a->tail->name);
      AddText(Description);
      sprintf(Description,"  Head node %s\n",a->head->name);
      AddText(Description);
      if (level >= 2) {
	sprintf(Description,"  G_type %d\n",a->g_type);
	AddText(Description);
      }
    }
    else {
      sprintf(Description,"Edge %s :\n",a->name);
      AddText(Description);
      sprintf(Description,"  Internal number %d\n",EdgeNumberOfArc(a,theGraph));
      AddText(Description);
      sprintf(Description,"  Tail node %s\n",a->tail->name);
      AddText(Description);
      sprintf(Description,"  Head node %s\n",a->head->name);
      AddText(Description);
      if (level >= 2) {
	sprintf(Description,"  Arcs internal numbers %d, %d:\n",a->number,a->number + 1);
	AddText(Description);
	sprintf(Description,"  G_type %d\n",a->g_type);
	AddText(Description);
      }
    }
    sprintf(Description,"  Unitary Cost : %g  ",a->unitary_cost);
    AddText(Description);
    sprintf(Description,"  Minimum Capacity : %g  ",a->minimum_capacity);
    AddText(Description);
    sprintf(Description,"  Maximum Capacity : %g\n ",a->maximum_capacity);
    AddText(Description);
    sprintf(Description,"  Length : %g ",a->length);
    AddText(Description);
    sprintf(Description,"  Quadratic Weight : %g  ",a->quadratic_weight);
    AddText(Description);
    sprintf(Description,"  Quadratic Origin : %g\n",a->quadratic_origin);
    AddText(Description);
    sprintf(Description,"  Weight : %g\n",a->weight);
    AddText(Description);
  }
}

void PrintModifyArc(a)
arc *a;
{
  char label[64];
  char *init[10];
  char *result[10];
  char *description[10];
  char str[64];
  int i = 0;
  float d; int v;
  int shiwidth, swidth, sfontsize;
  int redraw = 0;

  if (theGraph->directed) {
    sprintf(label,"Arc %s\n  Internal number %d\n",a->name,a->number);
  }
  else {
    sprintf(label,"Edge %s\n  Internal number %d\n",a->name,a->number);
  }
  
  sprintf(str,"%g",a->unitary_cost);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Unitary Cost: ";
  i++;
  
  sprintf(str,"%g",a->minimum_capacity);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Minimum Capacity: ";
  i++;

  sprintf(str,"%g",a->maximum_capacity);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Maximum Capacity: ";
  i++;

  sprintf(str,"%g",a->length);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Length: ";
  i++;

  sprintf(str,"%g",a->quadratic_weight);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Quadratic Weight: ";
  i++;

  sprintf(str,"%g",a->quadratic_origin);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Quadratic Origin: ";
  i++;
 
  sprintf(str,"%g",a->weight);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Weight: ";
  i++;

  if (a->width == 0) strcpy(str,"default");
  else sprintf(str,"%d",a->width);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Arc width: ";
  i++;

  if (a->hiWidth == 0) strcpy(str,"default");
  else sprintf(str,"%d",a->hiWidth);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Highlighted arc width: ";
  i++;

  if (a->fontSize == 0) strcpy(str,"default");
  else sprintf(str,"%d",a->fontSize);
  if ((init[i] = 
       (char*)malloc((unsigned)(strlen(str) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)malloc((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Font size: ";
  i++;

  if (MetanetDialogs(i,init,result,description,label)) {
    theGG.modified = 1;
    i = 0;

    sscanf(result[i],"%g",&d);
    a->unitary_cost = (double)d; i++;

    sscanf(result[i],"%g",&d);
    a->minimum_capacity = (double)d; i++;

    sscanf(result[i],"%g",&d);
    a->maximum_capacity = (double)d; i++;

    sscanf(result[i],"%g",&d);
    a->length = (double)d; i++;

    sscanf(result[i],"%g",&d);
    a->quadratic_weight = (double)d; i++;

    sscanf(result[i],"%g",&d);
    a->quadratic_origin = (double)d; i++;

    sscanf(result[i],"%g",&d);
    a->weight = (double)d; i++;

    swidth = ArcWidth(a);
    if (!strcmp(result[i],"default")) v = 0;
    else sscanf(result[i],"%d",&v);
    a->width = v; i++;
    if (a->width < 0) a->width = swidth;
    if (a->width != swidth) redraw = 1;

    shiwidth = ArcHiWidth(a);
    if (!strcmp(result[i],"default")) v = 0;
    else sscanf(result[i],"%d",&v);
    a->hiWidth = v; i++;
    if (a->hiWidth < 0) a->hiWidth = shiwidth;
    if (a->hiWidth != shiwidth) redraw = 1;

    sfontsize = ArcFontSize(a);
    if (!strcmp(result[i],"default")) v = 0;
    else sscanf(result[i],"%d",&v);
    a->fontSize = v; i++;
    if (a->fontSize < 0) a->fontSize = sfontsize;
    if (a->fontSize != sfontsize) redraw = 1;

    if (redraw) {
      SetCoordinatesArc(a);
      ClearDraw(); 
      ReDrawGraph(theGraph);
    }
  }
}
void RenumberGraph(g)
graph *g;
{
  mylink *p;
  int i;
  arc *a;
  node *n;

  p = g->arcs->first;
  i = g->arc_number;
  while (p) {
    a = (arc*)p->element;
    a->number = i;
    p = p->next;
    i--;
  }
  p = g->nodes->first;
  i = g->node_number;
  while (p) {
    n = (node*)p->element;
    n->number = i;
    p = p->next;
    i--;
  }  
}

graph *DuplicateGraph(oldg)
graph *oldg;
{
 graph *g;
 int i;
 mylink *p;

 g = GraphAlloc(oldg->name);
 g->directed = oldg->directed;
 g->node_number = oldg->node_number;
 g->arc_number = oldg->arc_number;
 g->sink_number = oldg->sink_number;
 g->nodeDiam = oldg->nodeDiam;
 g->nodeBorder = oldg->nodeBorder;
 g->arcWidth = oldg->arcWidth;
 g->arcHiWidth = oldg->arcHiWidth;
 g->fontSize = oldg->fontSize;
 for (i = 1; i <= oldg->arc_number; i++)
   AddListElement((ptr)ArcAlloc(i),g->arcs);
 for (i = 1; i <= oldg->node_number; i++)
   AddListElement((ptr)NodeAlloc(i),g->nodes);
 MakeArraysGraph(g);
 p = oldg->arcs->first;
 i = 0;
 while (p) {
   CopyArcInGraph((arc*)p->element,g,GetArc(g->arc_number - i,g));
   i++;
   p = p->next;
 }
 p = oldg->nodes->first;
 i = 0;
 while (p) {
   CopyNodeInGraph((node*)p->element,g,GetNode(g->node_number - i,g));
   i++;
   p = p->next;
 }
 ComputeNameArraysGraph(g);
 return g;
}

void CopyArcInGraph(a1, g, a2)
arc *a1;
graph *g;
arc *a2;
{
  a2->name = a1->name;
  a2->head = GetNode(a1->head->number,g);
  a2->tail = GetNode(a1->tail->number,g);
  a2->col = a1->col;
  a2->width = a1->width;
  a2->hiWidth = a1->hiWidth;
  a2->fontSize = a1->fontSize;
  a2->unitary_cost = a1->unitary_cost;
  a2->minimum_capacity = a1->minimum_capacity;
  a2->maximum_capacity = a1->maximum_capacity;
  a2->length = a1->length;
  a2->quadratic_weight = a1->quadratic_weight;
  a2->quadratic_origin = a1->quadratic_origin;
  a2->weight = a1->weight;
  a2->g_type = a1->g_type;
  a2->x0 = a1->x0;
  a2->y0 = a1->y0;
  a2->x1 = a1->x1;
  a2->y1 = a1->y1;
  a2->x2 = a1->x2;
  a2->y2 = a1->y2;
  a2->x3 = a1->x3;
  a2->y3 = a1->y3;
  a2->xmax = a1->xmax;
  a2->ymax = a1->ymax;
  a2->xa0 = a1->xa0;
  a2->ya0 = a1->ya0;
  a2->xa1 = a1->xa1;
  a2->ya1 = a1->ya1;
  a2->xa2 = a1->xa2;
  a2->ya2 = a1->ya2;
  a2->xa3 = a1->xa3;
  a2->ya3 = a1->ya3;
}

void CopyNodeInGraph(n1, g, n2)
node *n1;
graph *g;
node *n2;
{
  mylink *p;
  arc *a;

  n2->name = n1->name;
  p = n1->connected_arcs->first;
  while (p) {
    a = (arc*)p->element;
    AddListElement((ptr)GetArc(a->number,g),n2->connected_arcs);
    p = p->next;
  }
  p = n1->loop_arcs->first;
  while (p) {
    a = (arc*)p->element;
    AddListElement((ptr)GetArc(a->number,g),n2->loop_arcs);
    p = p->next;
  }
  n2->demand = n1->demand;
  n2->type = n1->type;
  if (n2->type == SOURCE) AddListElement((ptr)n2,g->sources);
  if (n2->type == SINK) AddListElement((ptr)n2,g->sinks);
  n2->x = n1->x;
  n2->y = n1->y;
  n2->col = n1->col;
  n2->diam = n1->diam;
  n2->border = n1->border;
  n2->fontSize = n1->fontSize;
}

graph *MakeUndirected(g)
graph *g;
{
  graph *ung;
  char name[MAXNAM];
  list *parcs;
  int i;
  arc *a, *a2;
  mylink *p, *q;
  node *n;
  arc *aa;

  if (g->un_graph != 0) return g->un_graph;
  ung = DuplicateGraph(g);
  g->un_graph = ung;
  strcpy(name,"undirected-");
  strcat(name,g->name);
  strcpy(ung->name,name);
  ung->directed = 0;

  parcs = ListAlloc();
  for (i = 1; i <= ung->arc_number; i++) {
    a = GetArc(i,ung);
    a->number = 2 * a->number - 1;
    a2 = ArcAlloc(a->number + 1);
    CopyArcInGraph(a,ung,a2);
    a2->head = a->tail;
    a2->tail = a->head;
    AddListElement((ptr)a,parcs);
    AddListElement((ptr)a2,parcs);
  }

  ung->arcs = parcs;
  ung->arc_number = 2 * ung->arc_number;

  MakeArraysGraph(ung);
  
  p = ung->nodes->first;
  while (p) {
    n = (node*)p->element;
    q = n->connected_arcs->first;
    while (q) {
      aa = (arc*)q->element;
      AddListElement((ptr)GetArc(aa->number + 1,ung),n->connected_arcs);
      q = q->next;
    }
    q = n->loop_arcs->first;
    while (q) {
      aa = (arc*)q->element;
      AddListElement((ptr)GetArc(aa->number + 1,ung),n->loop_arcs);
      q = q->next;
    }
    p = p->next;
  }
 ComputeNameArraysGraph(ung);
  return ung;
}

void ClearGG()
{
  theGG.active_type = 0;
  theGG.active = 0;
  theGG.moving = 0;
  theGG.modified = 0;
}

int EdgeNumberOfArc(a,g)
arc *a;
graph *g;
{
  if (g->directed) return a->number;
  else return a->number / 2 + a->number % 2;
} 

int ArcToEdgeNumber(i,g)
int i;
graph *g;
{
  if (g->directed) return i;
  else return i / 2 + i % 2;
}

int EdgeToArcNumber(i,g)
int i;
graph *g;
{
  if (g->directed) return i;
  else return 2 * i - 1;
}

int EdgeNumber(g)
graph *g;
{
  if (g->directed) return g->arc_number;
  else return g->arc_number / 2;
}
