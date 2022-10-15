/* Copyright INRIA */
#include <dirent.h>
#include <malloc.h>
#include <stdio.h>
#include <string.h>

#include "metaconst.h"
#include "metadir.h"
#include "list.h"
#include "graph.h"
#include "metio.h"
#include "menus.h"

extern char* my_basename();
extern char* dirname();
extern void RenumberGraph();
extern char* StripGraph();
extern graph *oldGraph;

void WriteArcToGraphFile();
void WriteGraphToGraphFile();
void WriteNodeToGraphFile();

int Named()
{
  list *unnamed_arc, *unnamed_node;
  int i = 0;
  mylink *p;
  arc *a; node *n;

  unnamed_arc = ListAlloc();
  unnamed_node = ListAlloc();
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
    sprintf(Description,"The highlighted nodes and/or arcs have not been named");
    MetanetAlert(Description);
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
    sprintf(Description,"Graph %s must at least have one arc",theGraph->name);
    MetanetAlert(Description);
    return 0;
  }
  if (theGG.n_hilited_arcs != 0 || theGG.n_hilited_nodes != 0) {
    UnhiliteAll();
  }

  if (!Named()) return 0;

  RenumberGraph(theGraph);
  sprintf(Description,"Graph %s renumbered\n",theGraph->name);
  AddMessage(Description);

  MakeArraysGraph(theGraph);

  sprintf(fname,"%s/%s.graph",datanet,theGraph->name);
  fo = fopen(fname,"w");
  if (fo == NULL) {
    sprintf(Description,
	    "Unable to write file in directory %s\nCheck access",datanet);
    MetanetAlert(Description);
    return 0;
  }
  WriteGraphToGraphFile(fo,theGraph);
  fclose(fo);

  sprintf(Description,"Graph %s saved\n",theGraph->name);
  AddMessage(Description);

  theGG.modified = 0;
  oldGraph = DuplicateGraph(theGraph);
  return 1;
}

void WriteGraphToGraphFile(f,g)
FILE *f;
graph *g;
{
  int i;
  arc *a;

  fprintf(f,"GRAPH TYPE (0 = UNDIRECTED, 1 = DIRECTED), DEFAULTS (NODE DIAMETER, NODE BORDER, ARC WIDTH, HILITED ARC WIDTH, FONTSIZE):\n");
  fprintf(f,"%d %d %d %d %d %d\n",g->directed,g->nodeDiam,g->nodeBorder,
	  g->arcWidth,g->arcHiWidth,g->fontSize);
  if (g->directed) fprintf(f,"NUMBER OF ARCS:\n");
  else fprintf(f,"NUMBER OF EDGES:\n");
  fprintf(f,"%d\n",g->arc_number);
  fprintf(f,"NUMBER OF NODES:\n");
  fprintf(f,"%d\n",g->node_number);
  fprintf(f,"****************************************\n");
  if (g->directed) {
    fprintf(f,"DESCRIPTION OF ARCS:\n");
    fprintf(f,"ARC NAME, TAIL NODE NAME, HEAD NODE NAME, COLOR, WIDTH, HIWIDTH, FONTSIZE\n");
  }
  else {
    fprintf(f,"DESCRIPTION OF EDGES:\n");
    fprintf(f,"EDGE NAME, NODE NAME, NODE NAME, COLOR, WIDTH, HIWIDTH, FONTSIZE\n");
  }
  fprintf
    (f,"COST, MIN CAP, MAX CAP, LENGTH, Q WEIGHT, Q ORIGIN, WEIGHT\n");
  fprintf(f,"\n");
  for (i = 1; i <= g->arc_number; i++) {
    a = GetArc(i,g);
    WriteArcToGraphFile(f,a);
  }
  fprintf(f,"****************************************\n");
  fprintf(f,"DESCRIPTION OF NODES:\n");
  fprintf(f,"NODE NAME, POSSIBLE TYPE (1 = SINK, 2 = SOURCE)\n");
  fprintf(f,"X, Y, COLOR, DIAMETER, BORDER, FONTSIZE\n");
  fprintf(f,"DEMAND\n");
  fprintf(f,"\n");
  for (i = 1; i <= g->node_number; i++) {
    WriteNodeToGraphFile(f,GetNode(i,g));
  }
} 

void WriteArcToGraphFile(f,a)
FILE *f;
arc *a;
{
  fprintf(f,"%s %s %s %d %d %d %d\n",a->name,a->tail->name,
	  a->head->name,a->col,a->width,a->hiWidth,a->fontSize);
  fprintf(f,"%e %e %e %e %e %e %e\n",
	  a->unitary_cost,a->minimum_capacity,a->maximum_capacity,
	  a->length,a->quadratic_weight,a->quadratic_origin,a->weight);
}

void WriteNodeToGraphFile(f,n)
FILE *f;
node *n;
{
  if (n->type == PLAIN)
    fprintf(f,"%s\n",n->name);
  else fprintf(f,"%s %d\n",n->name,n->type);
  fprintf(f,"%d %d %d %d %d %d \n",
	  n->x,n->y,n->col,n->diam,n->border,n->fontSize);
  fprintf(f,"%e\n",n->demand);
}

int RenameSaveGraph()
{
  FILE *fo;
  DIR *dirp;
  char fname[2 * MAXNAM];
  char name[2 * MAXNAM];
  char dir[2 * MAXNAM],path[2 * MAXNAM],oldDatanet[2 * MAXNAM];

  if (theGraph->arc_number < 1) {
    sprintf(Description,"Graph %s must at least have one arc",theGraph->name);
    MetanetAlert(Description);
    return 0;
  }
  if (theGG.n_hilited_arcs != 0 || theGG.n_hilited_nodes != 0) {
    UnhiliteAll();
  }

  if (!Named()) return 0;

  sprintf(Description,"New name or file name");
  if (!MetanetDialog(datanet,path,Description)) return 0;

  if (strcmp(path,"") == 0) return 0;

  if ((dirp=opendir(path)) != NULL) {
    sprintf(Description,"\"%s\" is a directory",path);
    MetanetAlert(Description);
    closedir(dirp);
    return 0;
  }

  strcpy(name,StripGraph(my_basename(path)));

  if (dirname(path) == NULL) strcpy(dir,datanet);
  else strcpy(dir,dirname(path));

  if ((dirp=opendir(dir)) == NULL) {
    sprintf(Description,"Directory \"%s\" does not exist",dir);
    MetanetAlert(Description);
    return 0;
  }
  closedir(dirp);
  
  strcpy(oldDatanet,datanet);
  strcpy(datanet,dir);

  FindGraphNames();
  if (FindInLarray(name,graphNames)) {
    sprintf(Description,"Graph %s already exists\n",name);
    MetanetAlert(Description);
    strcpy(datanet,oldDatanet);
    return 0;
  }

  strcpy(theGraph->name,name);

  RenumberGraph(theGraph);
  sprintf(Description,"Graph %s renumbered\n",theGraph->name);
  AddMessage(Description);

  MakeArraysGraph(theGraph);

  strcpy(fname,dir);
  strcat(fname,"/");
  strcat(fname,theGraph->name);
  strcat(fname,".graph");
  fo = fopen(fname,"w");
  if (fo == NULL) {
    sprintf(Description,
	    "Unable to write file in directory %s\nCheck access",dir);
    MetanetAlert(Description);
    return 0;
  }
  WriteGraphToGraphFile(fo,theGraph);
  fclose(fo);

  sprintf(Description,"Graph %s saved\n",theGraph->name);
  AddMessage(Description);

  strcpy(datanet,dir);
  SetTitle(menuId);

  theGG.modified = 0;
  return 1;
}
