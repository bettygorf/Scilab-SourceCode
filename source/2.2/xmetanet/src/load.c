#include <X11/Intrinsic.h>
#include <dirent.h>
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <math.h>

#include "mysearch.h"
#include "defs.h"
#include "metaconst.h"
#include "metadir.h"
#include "list.h"
#include "graph.h"
#include "menus.h"
#include "metio.h"
#include "color.h"

#define MIN(a,b) ((a) < (b) ? (a) : (b)) 

extern int ComputeNewType();
extern XFontStruct *FontSelect();
extern void GetDrawGeometry();

void ComputeCoord();
int LoadComputeGraph();
int ReadArcFromGraphFile();
graph *ReadGraphFromGraphFile();
void ReadNodeFromGraphFile();
int ComputeValues();

static ENTRY nodeH,*found;

void FindGraphNames()
{
  DIR *dirp;
  struct dirent *dp;
  char *s, *p;
  char t[MAXNAM];
  int i,n;

  dirp = opendir(datanet);
  n = 0;
  for (dp = readdir(dirp); dp != NULL; dp = readdir(dirp)) {
    s = dp->d_name;
    i = 0;
    while (t[i++] = *s++) {
      if (*s == '.') {
	s++;
	if (strcmp(s,"graph") == 0) {
	  t[i] = '\0';
	  if ((p = (char *)malloc((unsigned)(i+1))) == NULL) {
	    fprintf(stderr,"Running out of memory\n");
	    closedir(dirp);
	    return;
	  }
	  strcpy(p,t);
	  if (n > maxGraphs) {
	    sprintf(Description,"Too much saved graphs in directory\n");
	    MetanetAlert(Description);	 
	    closedir(datanet);
	    return;
	  }
	  graphNames[n++] = p;
	}
	break;
      }
    }
  }
  closedir(dirp);

  graphNames[n] = 0;
  SortLarray(graphNames);
}

void NewGraph ()
{
  char name[MAXNAM];

  sprintf(Description,"Graph name : ");
  if (!MetanetDialog("",name,Description)) return;
  if (strcmp(name,"") == 0) return;
  FindGraphNames();
  if (FindInLarray(name,graphNames)) {
    sprintf(Description,"Graph %s exists",name);
    MetanetAlert(Description);
  }
  else {
    ClearDraw();
    ClearGG();
    DestroyGraph(theGraph);
    theGraph = GraphAlloc(name);
    sprintf(Description,"Is the graph directed ?");
    theGraph->directed = MetanetYesOrNo(Description);
    ModifyGraph();
  }
}

/* LOADING FROM FILE */

int LoadGraph()
{
  char name[MAXNAM];

  FindGraphNames();
  if (graphNames[0] == 0) {
    sprintf(Description,"There is no saved graph in directory");
    MetanetAlert(Description);
    return 0;
  }
  if (!MetanetChoose("Choose a graph",graphNames,name))
    return 0;

  return LoadComputeGraph(name);
}

int LoadNamedGraph(name)
char *name;
{
  FindGraphNames();
  if (graphNames[0] == 0) {
    sprintf(Description,"Graph %s does not exist",name);
    MetanetAlert(Description);
    return 0;
  }

  if (!FindInLarray(name,graphNames)) {
    sprintf(Description,"Graph %s does not exist",name);
    MetanetAlert(Description);
    return 0;
  }

  return LoadComputeGraph(name);
}

int LoadComputeGraph(name)
char *name;
{
  FILE *fg;
  char fname[2 * MAXNAM];

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,name);
  strcat(fname,".graph");
  fg = fopen(fname,"r");

  DestroyGraph(theGraph);
  theGraph = ReadGraphFromGraphFile(fg);
  if (theGraph == 0) {fclose(fg); return 0;};
  strcpy(theGraph->name,name);
  fclose(fg);

  if(!ComputeValues(theGraph)) return 0;
  
  ClearDraw();
  ClearGG();
  DisplayMenu(STUDY);
  DrawGraph(theGraph);
  return 1;
}

graph *ReadGraphFromGraphFile(fg)
FILE *fg;
{
  char line[5 * MAXNAM];
  graph *g;
  int i;

  /* Read from graph file */
  g = GraphAlloc("");
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d %d %d %d %d %d",&(g->directed),
	 &(g->nodeDiam),&(g->nodeBorder),
	 &(g->arcWidth),&(g->arcHiWidth),&(g->fontSize));
  if (g->nodeDiam <= 0) g->nodeDiam = NODEDIAM;
  if (g->nodeBorder <= 0) g->nodeBorder = NODEW;
  if (g->arcWidth <= 0) g->arcWidth = ARCW;
  if (g->arcHiWidth <= 0) g->arcHiWidth = ARCH;
  if (FontSelect(g->fontSize) == NULL) g->fontSize = DRAWFONTSIZE;
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d",&(g->arc_number));
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d",&(g->node_number));
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  for (i = 1; i <= g->arc_number; i++)
    AddListElement((ptr)ArcAlloc(i),g->arcs);
  for (i = 1; i <= g->node_number; i++)
    AddListElement((ptr)NodeAlloc(i),g->nodes);
  MakeArraysGraph(g);

  /* jump to node description */
  for (i = 0; i < 2 * g->arc_number; i++)
    fgets(line,5 * MAXNAM,fg);

  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);

  myhcreate(g->node_number);
  for (i = 0; i < g->node_number; i++)
    ReadNodeFromGraphFile(fg,g,i + 1);

  /* rewind and go to arc description */
  rewind(fg);
  for (i = 0; i < 11; i++)
    fgets(line,5 * MAXNAM,fg);

  for (i = 0; i < g->arc_number; i++) {
    if (!ReadArcFromGraphFile(i+1,fg,g)) return 0;
  }
  myhdestroy();
  return g;
}

int ReadArcFromGraphFile(n,fg,g)
int n;
FILE *fg;
graph *g;
{
  char line[5 * MAXNAM];
  char name[MAXNAM], tail_name[MAXNAM], head_name[MAXNAM];
  int col, width, hiwidth, fontsize;
  arc *a;
  node *tail, *head;

  col = 0; width = 0; hiwidth = 0; fontsize = 0;
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%s %s %s %d %d %d %d\n",name,tail_name,head_name,
	 &col,&width,&hiwidth,&fontsize);
  
  a = GetArc(n,g);
    
  /* link number to name */
  if ((a->name = 
       (char*)malloc((unsigned)(strlen(name) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  strcpy(a->name,name);
  
  if ((nodeH.key = (char *)malloc((unsigned)strlen(head_name)+1)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  strcpy(nodeH.key,head_name);
  found = myhsearch(nodeH,FIND);
  if (found == NULL) {
    sprintf(Description,
	    "Bad graph file. Node \"%s\" referenced by arc \"%s\" not found",
	    head_name,a->name);
    MetanetAlert(Description);
    return 0;
  }
  
  head = (node *)found->data;
  if ((nodeH.key = (char *)malloc((unsigned)strlen(tail_name)+1)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  strcpy(nodeH.key,tail_name);
  found = myhsearch(nodeH,FIND);
  if (found == NULL) {
    sprintf(Description,
	    "Bad graph file. Node \"%s\" referenced by arc \"%s\" not found",
	    tail_name,a->name);
    MetanetAlert(Description);
    return 0;
  }
  tail = (node *)found->data;

  if (tail == 0 || head == 0) {
    sprintf(Description,"Bad node name while reading arc %d in graph file\n",
	    n);
    MetanetAlert(Description);  
    return 0;
  }
  a->tail = tail; a->head = head; 
  a->col = CheckColor(col);
  if (width < 0) width = 0; a->width = width; 
  if (hiwidth < 0) hiwidth = 0; a->hiWidth = hiwidth; 
  if (FontSelect(fontsize) == NULL) fontsize = 0; a->fontSize = fontsize;

  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%le %le %le %le %le %le %le",
	 &(a->unitary_cost),
	 &(a->minimum_capacity),
	 &(a->maximum_capacity),
	 &(a->length),
	 &(a->quadratic_weight),
	 &(a->quadratic_origin),
	 &(a->weight));
  return 1;
}

void ReadNodeFromGraphFile(fg, g, inode)
FILE *fg;
graph *g;
int inode;
{
  char line[5 * MAXNAM];
  char name[MAXNAM];
  int type = 0;
  node *nod;

  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%s %d",name,&type);
  nod = GetNode(inode,g);
  if ((nod->name = 
       (char*)malloc((unsigned)(strlen(name) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  strcpy(nod->name,name);

  if ((nodeH.key = (char *)malloc((unsigned)strlen(name)+1)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  strcpy(nodeH.key,name);
  if ((nodeH.data = (char *)malloc((unsigned)sizeof(node))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  nodeH.data = (char *)nod;
  myhsearch(nodeH,ENTER);

  nod->type = type;
  if (nod->type == SOURCE) {
    g->source_number++;
    AddListElement((ptr)nod,g->sources);
  }
  if (nod->type == SINK) {
    g->sink_number++;
    AddListElement((ptr)nod,g->sinks);
  }
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d %d %d %d %d %d",&(nod->x),&(nod->y),&(nod->col),
	 &(nod->diam),&(nod->border),&(nod->fontSize));
  nod->col = CheckColor(nod->col);
  if (nod->diam < 0) nod->diam = 0;
  if (nod->border < 0) nod->border = 0;
  if (FontSelect(nod->fontSize) == NULL) nod->fontSize = 0;

  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%le",&(nod->demand));
}

int ComputeValues(g)
graph *g;
{
  mylink *p;
  node *n, *tail, *head;
  int c;
  arc *a;

  p = g->nodes->first;
  while (p) {
    n = (node*)p->element;
    if ((n->x == 0) && (n->y == 0))
      ComputeCoord(n,g->node_number);
    p = p->next;
  }

  p = g->arcs->first;
  while (p) {
    a = (arc*)p->element;
    tail = a->tail;
    head = a->head;
    c = ComputeNewType(tail,head);
    if (c == ERRTYPE) return 0;
    a->g_type = c;
    SetCoordinatesArc(a);
    if (tail == head) AddListElement((ptr)a,tail->loop_arcs);
    else {
      AddListElement((ptr)a,tail->connected_arcs);
      AddListElement((ptr)a,head->connected_arcs);
    }
    p = p->next;
  }
  return 1;
}

void ComputeCoord(nod,n)
node *nod;
int n;
{
  int i, xnumber, ynumber, pas, xi, yi, maxn;
  int dx, dy, w, h;
  double ww,hh,sqr;
  
  if (n == 1) {
    nod->x = 2 * NodeDiam(nod);
    nod->y = 2 * NodeDiam(nod);
    return;
  }

  GetDrawGeometry(&dx,&dy,&w,&h);
  ww = (double)(w - 4 * NodeDiam(nod)); hh = (double)(h - 4 * NodeDiam(nod));
  maxn = (int)((ww/NodeDiam(nod) + 1)/2 * (hh/NodeDiam(nod) + 1)/2);
  if (n > maxn) {
    ww = (double)(drawWidth - 4 * NodeDiam(nod)); 
    hh = (double)(drawHeight - 4 * NodeDiam(nod));
  }
  /* xnumber = number of nodes in a row*/
  sqr = sqrt((ww-hh)*(ww-hh)+4*n*(NodeDiam(nod)*(NodeDiam(nod)-ww-hh)+ww*hh));
  xnumber = (int)((ww - hh - sqr)/(NodeDiam(nod)-hh)/2) + 1;
  ynumber = n / xnumber + 1;
  /* pas = distance between 2 nodes */
  pas = MIN(((int)ww - NodeDiam(nod)*xnumber)/(xnumber - 1),
	    ((int)hh - NodeDiam(nod)*ynumber)/(ynumber - 1));

  i = nod->number - 1;
  xi = i % xnumber;
  yi = i / xnumber;

  nod->x = 2 * NodeDiam(nod) + xi * (NodeDiam(nod) + pas);
  nod->y = 2 * NodeDiam(nod) + yi * (NodeDiam(nod) + pas);
}

void ChangeDirectory()
{
  char dir[2*MAXNAM];
  DIR *dirp;
  
  sprintf(Description,"%s","Directory");
  if (!MetanetDialog(datanet,dir,Description)) return;
  if ((dirp=opendir(dir)) == NULL) {
    sprintf(Description,"Directory \"%s\" does not exist",dir);
    MetanetAlert(Description);
  }
  else {
    strcpy(datanet,dir);
    FindGraphNames();
    closedir(dirp);
  }
}
