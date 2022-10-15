#include <dirent.h>
#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "metaconst.h"
#include "metadir.h"
#include "list.h"
#include "graph.h"
#include "menus.h"
#include "metio.h"

#define MIN(a,b) ((a) < (b) ? (a) : (b)) 

extern int ComputeNewType();
extern void WriteGraphToMetanetFile();
extern void GetDrawGeometry();

void ComputeCoord();
int ComputeMetanetFile();
void LoadComputeGraph1();
void ReadArcFromGraphFile();
void ReadArcFromMetanetFile();
graph *ReadGraphFromGraphFile();
graph *ReadGraphFromMetanetFile();
void ReadNodeFromGraphFile();
void ReadNodeFromMetanetFile();

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
	    return;
	  }
	  strcpy(p,t);
	  if (n > maxGraphs) {
	    fprintf(stderr,"Too much saved graphs in directory\n");
	    return;
	  }
	  graphNames[n++] = p;
	}
	break;
      }
    }
  }
  graphNames[n] = 0;
  SortLarray(graphNames);
}

void NewGraph ()
{
  char name[MAXNAM];

  MetanetDialog("",name,"Graph name : ");
  if (strcmp(name,"") == 0) return;
  FindGraphNames();
  if (FindInLarray(name,graphNames)) {
    MetanetAlert("Graph %s exists",name);
  }
  else {
    DestroyGraph(theGraph);
    theGraph = GraphAlloc(name);
    theGraph->directed = MetanetYesOrNo("Is the graph directed ?");
    ModifyGraph();
  }
}

/* LOADING FROM METANET FILE */

void LoadGraph()
{
  char name[MAXNAM];
  char fname[2 * MAXNAM];
  FILE *fm;

  FindGraphNames();
  if (graphNames[0] == 0) {
    MetanetAlert("There is no saved graph");
    return;
  }
  if (!MetanetChoose("Choose a graph",graphNames,name))
    return;

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,name);
  strcat(fname,".metanet");
  fm = fopen(fname,"r");
  if (fm == 0) {
    /* there is no metanet file */
    fclose(fm);
    MetanetAlert("Only graph file exists. Metanet is going to create a metanet file, computing coordinates of nodes if necessary");
    LoadComputeGraph1(name);
    return;
  }

  DestroyGraph(theGraph);
  theGraph = ReadGraphFromMetanetFile(fm);
  if (theGraph == NULL) {
    MetanetAlert("Metanet file exists but is bad. Load and compute it");
    return;
  }
  strcpy(theGraph->name,name);

  fclose(fm);

  DisplayMenu(STUDY);
  DrawGraph(theGraph);
}

int LoadNamedGraph(name, sup)
char *name;
int sup;
{
  char fname[2 * MAXNAM];
  FILE *fm;

  FindGraphNames();
  if (graphNames[0] == 0) {
    MetanetAlert("There is no saved graph");
    return 0;
  }

  if (sup == 0) {
    if ((menuId == STUDY) || (menuId == MODIFY)) {
      MetanetAlert("There is already a loaded graph");
      return 0;
    }
  }
  else {
    if (menuId == MODIFY) {
      MetanetAlert("There is a modified graph");
      return 0;
    }
    if (menuId == STUDY) StudyQuit();
  }

  if (!FindInLarray(name,graphNames)) {
    MetanetAlert("Graph %s does not exist",name);
    return 0;
  }

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,name);
  strcat(fname,".metanet");
  fm = fopen(fname,"r");
  if (fm == 0) {
    /* there is no metanet file */
    fclose(fm);
    LoadComputeGraph1(name);
    return 1;
  }

  DestroyGraph(theGraph);
  theGraph = ReadGraphFromMetanetFile(fm);
  if (theGraph == NULL) {
    MetanetAlert("Metanet file exists but is bad. Load and compute it");
    return 0;
  }
  strcpy(theGraph->name,name);

  fclose(fm);

  DisplayMenu(STUDY);
  DrawGraph(theGraph);
  return 1;
}

graph *ReadGraphFromMetanetFile(fm)
FILE *fm;
{
  char version[4];
  int number;
  graph *g;
  int i;

  g = GraphAlloc("");

  fread(version,sizeof(char),4,fm);
  if (strcmp(version,Version) != 0) return NULL;
  fread((char*)&(g->directed),sizeof(int),1,fm);
  fread((char*)&(g->node_number),sizeof(int),1,fm);
  fread((char*)&(g->arc_number),sizeof(int),1,fm);
  fread((char*)&(g->sink_number),sizeof(int),1,fm);
  fread((char*)&(g->source_number),sizeof(int),1,fm);
  for (i = 1; i <= g->arc_number; i++)
    AddListElement((ptr)ArcAlloc(i),g->arcs);
  for (i = 1; i <= g->node_number; i++)
    AddListElement((ptr)NodeAlloc(i),g->nodes);
  MakeArraysGraph(g);

  for (i = 0; i < g->sink_number; i++) {
    fread((char*)&number,sizeof(int),1,fm);
    AddListElement((ptr)GetNode(number,g),g->sinks);
  }
  for (i = 0; i < g->source_number; i++) {
    fread((char*)&number,sizeof(int),1,fm);
    AddListElement((ptr)GetNode(number,g),g->sources);
  }

  for (i = 0; i < g->arc_number; i++) {
    ReadArcFromMetanetFile(fm,g);
  }
  for (i = 0; i < g->node_number; i++) {
    ReadNodeFromMetanetFile(fm,g);
  }
  return g;
}

void ReadArcFromMetanetFile(fm, g)
FILE *fm;
graph *g;
{
  int number,lname;
  arc *a;

  fread((char*)&number,sizeof(int),1,fm);
  a = GetArc(number,g);
  fread((char*)&lname,sizeof(int),1,fm);
  if ((a->name = 
       (char*)malloc((unsigned)(lname+1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }  
  fread(a->name,sizeof(char),lname+1,fm);
  g->nameEdgeArray[EdgeNumberOfArc(a,g)] = a->name;
  fread((char*)&number,sizeof(int),1,fm);
  a->head = GetNode(number,g);
  fread((char*)&number,sizeof(int),1,fm);
  a->tail = GetNode(number,g);
  fread((char*)&(a->col),sizeof(int),1,fm);
  fread((char*)&(a->unitary_cost),sizeof(double),1,fm);
  fread((char*)&(a->minimum_capacity),sizeof(double),1,fm);
  fread((char*)&(a->maximum_capacity),sizeof(double),1,fm);
  fread((char*)&(a->length),sizeof(double),1,fm);
  fread((char*)&(a->quadratic_weight),sizeof(double),1,fm);
  fread((char*)&(a->quadratic_origin),sizeof(double),1,fm);
  fread((char*)&(a->weight),sizeof(double),1,fm);
  fread((char*)&(a->g_type),sizeof(int),1,fm);
  fread((char*)&(a->x0),sizeof(int),1,fm);
  fread((char*)&(a->y0),sizeof(int),1,fm);
  fread((char*)&(a->x1),sizeof(int),1,fm);
  fread((char*)&(a->y1),sizeof(int),1,fm);
  fread((char*)&(a->x2),sizeof(int),1,fm);
  fread((char*)&(a->y2),sizeof(int),1,fm);
  fread((char*)&(a->x3),sizeof(int),1,fm);
  fread((char*)&(a->y3),sizeof(int),1,fm);
  fread((char*)&(a->xmax),sizeof(int),1,fm);
  fread((char*)&(a->ymax),sizeof(int),1,fm);
  fread((char*)&(a->xa0),sizeof(int),1,fm);
  fread((char*)&(a->ya0),sizeof(int),1,fm);
  fread((char*)&(a->xa1),sizeof(int),1,fm);
  fread((char*)&(a->ya1),sizeof(int),1,fm);
  fread((char*)&(a->xa2),sizeof(int),1,fm);
  fread((char*)&(a->ya2),sizeof(int),1,fm);
  fread((char*)&(a->xa3),sizeof(int),1,fm);
  fread((char*)&(a->ya3),sizeof(int),1,fm);
}

void ReadNodeFromMetanetFile(fm, g)
FILE *fm;
graph *g;
{
  int number,lname;
  node *n;

  fread((char*)&number,sizeof(int),1,fm);
  n = GetNode(number,g);
  while (1) {
    fread((char*)&number,sizeof(int),1,fm);
    if (number == 0) break;
    AddListElement((ptr)GetArc(number,g),n->connected_arcs);
  }
  while (1) {
    fread((char*)&number,sizeof(int),1,fm);
    if (number == 0) break;
    AddListElement((ptr)GetArc(number,g),n->loop_arcs);
  }
  fread((char*)&lname,sizeof(int),1,fm);
  if ((n->name = 
       (char*)malloc((unsigned)(lname+1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  fread(n->name,sizeof(char),lname+1,fm);
  g->nameNodeArray[n->number] = n->name;
  fread((char*)&(n->demand),sizeof(double),1,fm);
  fread((char*)&(n->type),sizeof(int),1,fm);
  fread((char*)&(n->x),sizeof(int),1,fm);
  fread((char*)&(n->y),sizeof(int),1,fm);
  fread((char*)&(n->col),sizeof(int),1,fm);
}

/* THERE IS NO METANET FILE or WE COMPUTE METANET FILE */

void LoadComputeGraph()
{
  char name[MAXNAM];

  FindGraphNames();
  if (graphNames[0] == 0) {
    MetanetAlert("There is no saved graph");
    return;
  }
  if (!MetanetChoose("Choose a graph",graphNames,name))
    return;

  LoadComputeGraph1(name);
}

void LoadComputeGraph1(name)
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
  strcpy(theGraph->name,name);
  fclose(fg);

  if(!ComputeMetanetFile(theGraph)) return;
  
  DisplayMenu(STUDY);
  DrawGraph(theGraph);
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
  sscanf(line,"%d",&(g->directed));
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d",&(g->arc_number));
  if (!g->directed) g->arc_number *= 2;
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
  if (g->directed)
    for (i = 0; i < 2 * g->arc_number; i++)
      fgets(line,5 * MAXNAM,fg);
  else
    for (i = 0; i < g->arc_number; i++)
      fgets(line,5 * MAXNAM,fg);

  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);

  for (i = 0; i < g->node_number; i++)
    ReadNodeFromGraphFile(fg,g,i + 1);

  /* rewind and go to arc description */
  rewind(fg);
  for (i = 0; i < 11; i++)
    fgets(line,5 * MAXNAM,fg);

  if (g->directed)
    for (i = 0; i < g->arc_number; i++)
      ReadArcFromGraphFile(i+1,fg,g);
  else
    for (i = 0; i < g->arc_number/2; i++)
      ReadArcFromGraphFile(i+1,fg,g);

  return g;
}

void ReadArcFromGraphFile(n,fg,g)
int n;
FILE *fg;
graph *g;
{
  char line[5 * MAXNAM];
  char name[MAXNAM], tail_name[MAXNAM], head_name[MAXNAM];
  int col;
  arc *a, *a2;
  node *tail, *head;

  col = 0;
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%s %s %s %d\n",name,tail_name,head_name,&col);
  
  if (g->directed)
    a = GetArc(n,g);
  else
    a = GetArc(2 * n - 1,g);
  
  /* link number to name */
  if ((a->name = 
       (char*)malloc((unsigned)(strlen(name) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  strcpy(a->name,name);
  g->nameEdgeArray[n] = a->name;
  
  tail = GetNamedNode(tail_name,g); 
  head = GetNamedNode(head_name,g);
  if (tail == 0 || head == 0) {
    fprintf(stderr,"Bad node name while reading arc %d in graph file\n",n);
    exit(1);
  }
  a->tail = tail; a->head = head; a->col = col;
  if (!g->directed) {
    a2 = GetArc(2 * n,g);
    a2->name = a->name;
    a2->tail = head; a2->head = tail; a2->col = col;
  }

  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%le %le %le %le %le %le %le",
	 &(a->unitary_cost),
	 &(a->minimum_capacity),
	 &(a->maximum_capacity),
	 &(a->length),
	 &(a->quadratic_weight),
	 &(a->quadratic_origin),
	 &(a->weight));
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
  g->nameNodeArray[nod->number] = nod->name;
  nod->type = type;
  if (nod->type == SOURCE) {
    g->source_number++;
    AddListElement((ptr)nod,g->sources);
  }
  if (nod->type == SINK) {
    g->sink_number++;
    AddListElement((ptr)nod,g->sinks);
  }
  nod->x = 0; nod->y = 0; nod->col=0;
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d %d %d",&(nod->x),&(nod->y),&(nod->col));
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%le",&(nod->demand));
}

int ComputeMetanetFile(g)
graph *g;
{
  mylink *p;
  node *n, *tail, *head;
  int c;
  arc *a;
  char fname[2 * MAXNAM];
  FILE *fm;

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
    if (g->directed) {
      c = ComputeNewType(tail,head);
    }
    else {
      if (a->number % 2 == 0) c = ComputeNewType(tail,head);
    }
    a->g_type = c;
    SetCoordinatesArc(a);
    if (tail == head) AddListElement((ptr)a,tail->loop_arcs);
    else {
      AddListElement((ptr)a,tail->connected_arcs);
      AddListElement((ptr)a,head->connected_arcs);
    }
    p = p->next;
  }
  
  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,g->name);
  strcat(fname,".metanet");
  fm = fopen(fname,"w");
  WriteGraphToMetanetFile(fm,g);
  fclose(fm);
  return 1;
}

void ComputeCoord(nod,n)
node *nod;
int n;
{
  int i, xnumber, ynumber, pas, xi, yi, maxn;
  int dx, dy, w, h;
  double ww,hh,sqr;
  
  GetDrawGeometry(&dx,&dy,&w,&h);
  ww = (double)(w - 4 * nodeDiam); hh = (double)(h - 4 * nodeDiam);
  maxn = (int)((ww/nodeDiam + 1)/2 * (hh/nodeDiam + 1)/2);
  if (n > maxn) {
    ww = (double)(drawWidth - 4 * nodeDiam); 
    hh = (double)(drawHeight - 4 * nodeDiam);
  }
  /* xnumber = number of nodes in a row*/
  sqr = sqrt((ww-hh)*(ww-hh)+4*n*(nodeDiam*(nodeDiam-ww-hh)+ww*hh));
  xnumber = (int)((ww - hh - sqr)/(nodeDiam-hh)/2) + 1;
  ynumber = n / xnumber + 1;
  /* pas = distance between 2 nodes */
  pas = MIN(((int)ww - nodeDiam*xnumber)/(xnumber - 1),
	    ((int)hh - nodeDiam*ynumber)/(ynumber - 1));

  i = nod->number - 1;
  xi = i % xnumber;
  yi = i / xnumber;

  nod->x = 2 * nodeDiam + xi * (nodeDiam + pas);
  nod->y = 2 * nodeDiam + yi * (nodeDiam + pas);
}
