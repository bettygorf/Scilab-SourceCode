#include <malloc.h>
#include <stdio.h>
#include <string.h>

#include "metaconst.h"
#include "metadir.h"
#include "list.h"
#include "graph.h"
#include "metio.h"

extern void RenumberGraph();
extern void UnhiliteActive();

void WriteArcToGraphFile();
void WriteArcToMetanetFile();
void WriteGraphToGraphFile();
void WriteGraphToMetanetFile();
void WriteNodeToGraphFile();
void WriteNodeToMetanetFile();

int Named()
{
  list *unnamed_arc, *unnamed_node;
  int i = 0;
  mylink *p;
  arc *a; node *n;

  unnamed_arc = ListAlloc();
  unnamed_node = ListAlloc();
  if (theGraph->directed) {
    p = theGraph->arcs->first;
    while (p) {
      a = (arc*)p->element;
      if (a->name == 0) {
	AddListElement((ptr)a,unnamed_arc);
	i++;
      }
      p = p->next;
    }
    p = theGraph->nodes->first;
    while (p) {
      n = (node*)p->element;
      if (n->name == 0) {
	AddListElement((ptr)n,unnamed_node);
	i++;
      }
      p = p->next;
    }
  }
  else {
    p = theGraph->arcs->first;
    while (p) {
      a = (arc*)p->element;
      if (a->number % 2 != 0 &&	a->name == 0) {
	AddListElement((ptr)a,unnamed_arc);
	i++;
      }
      p = p->next;
    }
    p = theGraph->nodes->first;
    while (p) {
      n = (node*)p->element;
      if (n->name == 0) {
	AddListElement((ptr)n,unnamed_node);
	i++;
      }
      p = p->next;
    }
  }
  if (i != 0) {
    /* first hilite arcs */
    p = unnamed_arc->first;
    while (p) {
      HiliteArc((arc*)p->element);
      p = p->next;
    }
    /* then hilite nodes */
    p = unnamed_node->first;
    while (p) {
      HiliteNode((node*)p->element);
      p = p->next;
    }
    MetanetAlert("The highlighted nodes and/or arcs have not been named");
    p = unnamed_arc->first;
    while (p) {
      UnhiliteArc((arc*)p->element);
      p = p->next;
    }
    p = unnamed_node->first;
    while (p) {
      UnhiliteNode((node*)p->element);
      p = p->next;
    }
    return 0;
  }
  return 1;
}

int SaveGraph()
{
  FILE *fo;
  char fname[2 * MAXNAM];

  if (theGraph->arc_number < 1) {
    MetanetAlert("Graph %s must at least have one arc",theGraph->name);
    return 0;
  }
  if (theGG.active != 0) {
    UnhiliteActive();
    theGG.active = 0;
    theGG.active_type = 0;
  }

  if (!Named()) return 0;

  RenumberGraph(theGraph);
  AddMessage("Graph %s renumbered\n",theGraph->name);

  MakeArraysGraph(theGraph);
  ComputeNameArraysGraph(theGraph);

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,theGraph->name);
  strcat(fname,".graph");
  fo = fopen(fname,"w");
  WriteGraphToGraphFile(fo,theGraph);
  fclose(fo);

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,theGraph->name);
  strcat(fname,".metanet");
  fo = fopen(fname,"w");
  WriteGraphToMetanetFile(fo,theGraph);
  fclose(fo);

  AddMessage("Graph %s saved\n",theGraph->name);

  theGG.modified = 0;
  return 1;
}

void WriteGraphToGraphFile(f,g)
FILE *f;
graph *g;
{
  int i;
  arc *a;

  fprintf(f,"GRAPH TYPE (0 = UNDIRECTED, 1 = DIRECTED) :\n");
  fprintf(f,"%d\n",g->directed);
  if (g->directed) {
    fprintf(f,"NUMBER OF ARCS :\n");
    fprintf(f,"%d\n",g->arc_number);
  }
  else {
    fprintf(f,"NUMBER OF EDGES :\n");
    fprintf(f,"%d\n",g->arc_number / 2);
  }
  fprintf(f,"NUMBER OF NODES :\n");
  fprintf(f,"%d\n",g->node_number);
  fprintf(f,"****************************************\n");
  if (g->directed) {
    fprintf(f,"DESCRIPTION OF ARCS :\n");
    fprintf(f,"ARC NAME, TAIL NODE NAME, HEAD NODE NAME, COLOR\n");
  }
  else {
    fprintf(f,"DESCRIPTION OF EDGES :\n");
    fprintf(f,"EDGE NAME, NODE NAME, NODE NAME, COLOR\n");
  }
  fprintf
    (f,"COST, MIN CAP, MAX CAP, LENGTH, Q WEIGHT, Q ORIGIN, WEIGHT\n");
  fprintf(f,"\n");
  for (i = 1; i <= g->arc_number; i++) {
    a = GetArc(i,g);
    if (g->directed || (a->number % 2 != 0))
      WriteArcToGraphFile(f,a);
  }
  fprintf(f,"****************************************\n");
  fprintf(f,"DESCRIPTION OF NODES :\n");
  fprintf(f,"NODE NAME, POSSIBLE TYPE (1 = SINK, 2 = SOURCE)\n");
  fprintf(f,"X, Y, COLOR\n");
  fprintf(f,"DEMAND\n");
  fprintf(f,"\n");
  for (i = 1; i <= g->node_number; i++) {
    WriteNodeToGraphFile(f,GetNode(i,g));
  }
} 

void WriteGraphToMetanetFile(f,g)
FILE *f;
graph *g;
{
  mylink *p;
  node *n;
  arc *a;

  if (f == 0) return;

  fwrite(Version,sizeof(char),4,f);
  fwrite((char*)&(g->directed),sizeof(int),1,f);
  fwrite((char*)&(g->node_number),sizeof(int),1,f);
  fwrite((char*)&(g->arc_number),sizeof(int),1,f);
  fwrite((char*)&(g->sink_number),sizeof(int),1,f);
  fwrite((char*)&(g->source_number),sizeof(int),1,f);
  p = g->sinks->first;
  while (p) {
    n = (node*)p->element;
    fwrite((char*)&(n->number),sizeof(int),1,f);
    p = p->next;
  }
  p = g->sources->first;
  while (p) {
    n = (node*)p->element;
    fwrite((char*)&(n->number),sizeof(int),1,f);
    p = p->next;
  }
  p = g->arcs->first;
  while (p) {
    a = (arc*)p->element;
    WriteArcToMetanetFile(f,a);
    p = p->next;
  }
  p = g->nodes->first;
  while (p) {
    n = (node*)p->element;
    WriteNodeToMetanetFile(f,n);
    p = p->next;
  }
}

void WriteArcToGraphFile(f,a)
FILE *f;
arc *a;
{
  fprintf(f,"%s %s %s %d\n",a->name,a->tail->name,
	  a->head->name,a->col);
  fprintf(f,"%e %e %e %e %e %e %e\n",
	  a->unitary_cost,a->minimum_capacity,a->maximum_capacity,
	  a->length,a->quadratic_weight,a->quadratic_origin,a->weight);
}

void WriteArcToMetanetFile(f,a)
FILE *f;
arc *a;
{
  int lname;

  fwrite((char*)&(a->number),sizeof(int),1,f);
  lname = strlen(a->name);
  fwrite((char*)&(lname),sizeof(int),1,f);
  fwrite(a->name,sizeof(char),lname+1,f);
  fwrite((char*)&(a->head->number),sizeof(int),1,f);
  fwrite((char*)&(a->tail->number),sizeof(int),1,f);
  fwrite((char*)&(a->col),sizeof(int),1,f);
  fwrite((char*)&(a->unitary_cost),sizeof(double),1,f);
  fwrite((char*)&(a->minimum_capacity),sizeof(double),1,f);
  fwrite((char*)&(a->maximum_capacity),sizeof(double),1,f);
  fwrite((char*)&(a->length),sizeof(double),1,f);
  fwrite((char*)&(a->quadratic_weight),sizeof(double),1,f);
  fwrite((char*)&(a->quadratic_origin),sizeof(double),1,f);
  fwrite((char*)&(a->weight),sizeof(double),1,f);
  fwrite((char*)&(a->g_type),sizeof(int),1,f);
  fwrite((char*)&(a->x0),sizeof(int),1,f);
  fwrite((char*)&(a->y0),sizeof(int),1,f);
  fwrite((char*)&(a->x1),sizeof(int),1,f);
  fwrite((char*)&(a->y1),sizeof(int),1,f);
  fwrite((char*)&(a->x2),sizeof(int),1,f);
  fwrite((char*)&(a->y2),sizeof(int),1,f);
  fwrite((char*)&(a->x3),sizeof(int),1,f);
  fwrite((char*)&(a->y3),sizeof(int),1,f);
  fwrite((char*)&(a->xmax),sizeof(int),1,f);
  fwrite((char*)&(a->ymax),sizeof(int),1,f);
  fwrite((char*)&(a->xa0),sizeof(int),1,f);
  fwrite((char*)&(a->ya0),sizeof(int),1,f);
  fwrite((char*)&(a->xa1),sizeof(int),1,f);
  fwrite((char*)&(a->ya1),sizeof(int),1,f);
  fwrite((char*)&(a->xa2),sizeof(int),1,f);
  fwrite((char*)&(a->ya2),sizeof(int),1,f);
  fwrite((char*)&(a->xa3),sizeof(int),1,f);
  fwrite((char*)&(a->ya3),sizeof(int),1,f);
}

void WriteNodeToGraphFile(f,n)
FILE *f;
node *n;
{
  if (n->type == PLAIN)
    fprintf(f,"%s\n",n->name);
  else fprintf(f,"%s %d\n",n->name,n->type);
  fprintf(f,"%d %d %d\n",n->x,n->y,n->col);
  fprintf(f,"%e\n",n->demand);
}

void WriteNodeToMetanetFile(f,n)
FILE *f;
node *n;
{
  mylink *p;
  int nca, *ca;
  int lname;
  int i;
  arc *a;

  fwrite((char*)&(n->number),sizeof(int),1,f);

  /* write connected arcs in reverse order */
  p = n->connected_arcs->first;
  nca = 0;
  while (p) {
    nca++; p = p->next;
  }
  if (nca != 0) {
    if ((ca = (int*)malloc((unsigned)nca * sizeof(int))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return;
    } 
    i = nca;
    p = n->connected_arcs->first;
    while (p) {
      a = (arc*)p->element;
      ca[--i] = a->number;
      p = p->next;
    }
    for (i = 0; i < nca; i++)
      fwrite((char*)&(ca[i]),sizeof(int),1,f);
    free((char*)ca);
  }
  i = 0;
  fwrite((char*)&i,sizeof(int),1,f);

  /* write loop arcs in reverse order */
  p = n->loop_arcs->first;
  nca = 0;
  while (p) {
    nca++; p = p->next;
  }
  if (nca != 0) {
    if ((ca = (int*)malloc((unsigned)nca * sizeof(int))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return;
    } 
    i = nca;
    p = n->loop_arcs->first;
    while (p) {
      a = (arc*)p->element;
      ca[--i] = a->number;
      p = p->next;
    }
    for (i = 0; i < nca; i++)
      fwrite((char*)&(ca[i]),sizeof(int),1,f);
    free((char*)ca);
  }
  i = 0;
  fwrite((char*)&i,sizeof(int),1,f);

  lname = strlen(n->name);
  fwrite((char*)&(lname),sizeof(int),1,f);
  fwrite(n->name,sizeof(char),lname+1,f);
  fwrite((char*)&(n->demand),sizeof(double),1,f);
  fwrite((char*)&(n->type),sizeof(int),1,f);
  fwrite((char*)&(n->x),sizeof(int),1,f);
  fwrite((char*)&(n->y),sizeof(int),1,f);
  fwrite((char*)&(n->col),sizeof(int),1,f);
}

int RenameSaveGraph()
{
  FILE *fo;
  char fname[2 * MAXNAM];
  char name[MAXNAM];

  if (theGraph->arc_number < 1) {
    MetanetAlert("Graph %s must at least have one arc",theGraph->name);
    return 0;
  }
  if (theGG.active != 0) {
    UnhiliteActive();
    theGG.active = 0;
    theGG.active_type = 0;
  }

  if (!Named()) return 0;

  MetanetDialog("",name,"New name for old graph %s",theGraph->name);

  if (strcmp(name,"") == 0) return 0;
  FindGraphNames();
  if (FindInLarray(name,graphNames)) {
    MetanetAlert("Graph %s exists\n",name);
    return 0;
  }

  strcpy(theGraph->name,name);

  

  RenumberGraph(theGraph);
  AddMessage("Graph %s renumbered\n",theGraph->name);

  MakeArraysGraph(theGraph);
  ComputeNameArraysGraph(theGraph);

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,theGraph->name);
  strcat(fname,".graph");
  fo = fopen(fname,"w");
  WriteGraphToGraphFile(fo,theGraph);
  fclose(fo);

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,theGraph->name);
  strcat(fname,".metanet");
  fo = fopen(fname,"w");
  WriteGraphToMetanetFile(fo,theGraph);
  fclose(fo);

  AddMessage("Graph %s saved\n",theGraph->name);

  theGG.modified = 0;
  return 1;
}
