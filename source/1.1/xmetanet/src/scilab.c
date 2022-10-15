#include <malloc.h>

#include "list.h"
#include "graph.h"
#include "metio.h"

extern graph *MakeUndirected();

static int *la;
static int *ls;
static int *lp;
static int *he;
static int *ta;

/* Compute adjacency description for directed or undirected graph,
   depending upon FORDIR parameter
*/

int ComputeAdjacencyDescription(fordir,g)
int fordir;
graph *g;
{
  int i,im,sizint;
  node *n; arc *a;
  mylink *p;
  graph *dirGraph;

  sizint = sizeof(int);
  
  if (fordir) {

/* la: "arc array for adjacency description for directed graph"
   ls: "node array for adjacency description for directed graph"
   lp: "pointer array for adjacency description for directed graph" */

    if ((la = (int*)malloc((unsigned)g->arc_number * sizint)) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return 0;
    }
    if ((ls = (int*)malloc((unsigned)g->arc_number * sizint)) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return 0;
    }
    if ((lp = (int*)malloc((unsigned)(g->node_number + 1) * sizint)) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return 0;
    }

    im = 0;
    for (i = 0; i < g->node_number; i++) {
      n = GetNode(i+1,g);
      lp[n->number - 1] = im + 1;
      p = n->loop_arcs->first;
      while (p) {
	a = (arc*)p->element;
	if (a->tail->number == n->number) {
	  la[im] = a->number;
	  ls[im] = a->head->number;
	  im++;
	}
	p = p->next;
      }
      p = n->connected_arcs->first;
      while (p) {
	a = (arc*)p->element;
	if (a->tail->number == n->number) {
	  la[im] = a->number;
	  ls[im] = a->head->number;
	  im++;
	}
	p = p->next;
      }
    }
    lp[g->node_number] = im + 1;
    return im;
  }
  else {
    if (g->directed) {
      dirGraph = theGraph;
      theGraph = MakeUndirected(dirGraph);
      im = ComputeAdjacencyDescription(0,theGraph);
      theGraph = dirGraph;
      return im;
    }
    else {

/* la: "arc array for adjacency description for undirected graph"
   ls: "node array for adjacency description for undirected graph"
   lp: "pointer array for adjacency description for undirected graph" */

      if ((la = (int*)malloc((unsigned)g->arc_number * sizint)) == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return 0;
      }
      if ((ls = (int*)malloc((unsigned)g->arc_number * sizint)) == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return 0;
      }
      if ((lp = (int*)malloc((unsigned)(g->node_number + 1) * sizint)) == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return 0;
      }
      im = 0;
      for (i = 0; i < g->node_number; i++) {
	n = GetNode(i+1,g);
	lp[n->number - 1] = im + 1;
	p = n->loop_arcs->first;
	while (p) {
	  a = (arc*)p->element;
	  if (a->tail->number == n->number) {
	    la[im] = EdgeNumberOfArc(a,g);
	    ls[im] = a->head->number;
	    im++;
	  }
	  p = p->next;
	}
	p = n->connected_arcs->first;
	while (p) {
	  a = (arc*)p->element;
	  if (a->tail->number == n->number) {
	    la[im] = EdgeNumberOfArc(a,g);
	    ls[im] = a->head->number;
	    im++;
	  }
	  p = p->next;
	}
      }
      lp[g->node_number] = im + 1;
      return im;
    }
  }
}

int ComputeEdgeDescription(g)
graph *g;
{
  int ma;
  mylink *p;
  arc *a;
  int sizint = sizeof(int);

  if (g->directed) ma = g->arc_number;
  else ma = g->arc_number/2;

/* he: "head node array"
   ta: "tail node array" */

  if ((he = (int*)malloc((unsigned)ma * sizint)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  if ((ta = (int*)malloc((unsigned)ma * sizint)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }

  p = g->arcs->first;
  while (p) {
    a = (arc*)p->element;
    if (g->directed || a->number % 2 != 0 ) {
      he[EdgeNumberOfArc(a,g) - 1] = a->head->number;
      ta[EdgeNumberOfArc(a,g) - 1] = a->tail->number;
    }
    p = p->next;
  }
  return ma;
}

int ComputeScilabGraph(glist)
char **glist;
{
  int dsize,gsize,i,isize,mem,s;
  int m,n,ma,mm;
  int lname,lnname,laname;
  char *g;
  char name[MAXNAM];

  isize = sizeof(int);
  dsize = sizeof(double);

  lname = strlen(theGraph->name);
  m = theGraph->arc_number;
  n = theGraph->node_number;
  if (theGraph->directed) ma = m; else ma = m / 2;
  mm = 2 * ma;

  mem = lname + 1;
  mem +=  isize * (7 + (2 * m) + (2 * (n + 1)) + (2 * mm) + (3 * ma) +
		   (4 * n));
  mem += dsize * (n + (7 * ma));

  lnname = 0;
  for (i = 1; i <= n; i++) {
    lnname += strlen(theGraph->nameNodeArray[i]) + 1;
  }
  mem += lnname;

  laname = 0;
  for (i = 1; i <= ma; i++) {
    laname += strlen(theGraph->nameEdgeArray[i]) + 1;
  }
  mem += laname;
  
  if ((g = (char *)malloc((unsigned)mem)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return(0);
  }

  gsize = 0;

  s = lname + 1;
  bcopy(theGraph->name,g+gsize,s);
  gsize += s;

  s = isize;
  bcopy((char *)&theGraph->directed,g+gsize,s);
  gsize += s;

  s = isize;
  bcopy((char *)&m,g+gsize,s);
  gsize += s;

  s = isize;
  bcopy((char *)&n,g+gsize,s);
  gsize += s;

  s = isize;
  bcopy((char *)&ma,g+gsize,s);
  gsize += s;

  s = isize;
  bcopy((char *)&mm,g+gsize,s);
  gsize += s;

  m = ComputeAdjacencyDescription(1,theGraph);

  s = isize * m;
  bcopy((char *)la,g+gsize,s);
  gsize += s;

  s = isize * (n + 1);
  bcopy((char *)lp,g+gsize,s);
  gsize += s;

  s = isize * m;
  bcopy((char *)ls,g+gsize,s);
  gsize += s;

  mm = ComputeAdjacencyDescription(0,theGraph);

  s = isize * mm;
  bcopy((char *)la,g+gsize,s);
  gsize += s;

  s = isize * (n + 1);
  bcopy((char *)lp,g+gsize,s);
  gsize += s;

  s = isize * mm;
  bcopy((char *)ls,g+gsize,s);
  gsize += s;

  ma = ComputeEdgeDescription(theGraph);

  s = isize * ma;
  bcopy((char *)he,g+gsize,s);
  gsize += s;

  s = isize * ma;
  bcopy((char *)ta,g+gsize,s);
  gsize += s;

  s = isize;
  bcopy((char *)&lnname,g+gsize,s);
  gsize += s;

  for (i = 1; i <= n; i++) {
    strcpy(name,theGraph->nameNodeArray[i]);
    lname = strlen(name) + 1;
    bcopy(name,g+gsize,lname);
    gsize += lname;
  }

  for (i = 1; i <= n; i++) {
    bcopy((char *)&theGraph->nodeArray[i]->type,g+gsize,isize);
    gsize += isize;
  }

  for (i = 1; i <= n; i++) {
    bcopy((char *)&theGraph->nodeArray[i]->x,g+gsize,isize);
    gsize += isize;
  }

  for (i = 1; i <= n; i++) {
    bcopy((char *)&theGraph->nodeArray[i]->y,g+gsize,isize);
    gsize += isize;
  }

  for (i = 1; i <= n; i++) {
    bcopy((char *)&theGraph->nodeArray[i]->col,g+gsize,isize);
    gsize += isize;
  }

  for (i = 1; i <= n; i++) {
    bcopy((char *)&theGraph->nodeArray[i]->demand,g+gsize,dsize);
    gsize += dsize;
  }

  s = isize;
  bcopy((char *)&laname,g+gsize,s);
  gsize += s;

  for (i = 1; i <= ma; i++) {
    strcpy(name,theGraph->nameEdgeArray[i]);
    lname = strlen(name) + 1;
    bcopy(name,g+gsize,lname);
    gsize += lname;
  }
  
  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    bcopy((char *)&theGraph->arcArray[i]->col,g+gsize,isize);
    gsize += isize;
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    bcopy((char *)&theGraph->arcArray[i]->length,g+gsize,dsize);
    gsize += dsize;
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    bcopy((char *)&theGraph->arcArray[i]->unitary_cost,g+gsize,dsize);
    gsize += dsize;
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    bcopy((char *)&theGraph->arcArray[i]->minimum_capacity,g+gsize,dsize);
    gsize += dsize;
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    bcopy((char *)&theGraph->arcArray[i]->maximum_capacity,g+gsize,dsize);
    gsize += dsize;
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    bcopy((char *)&theGraph->arcArray[i]->quadratic_weight,g+gsize,dsize);
    gsize += dsize;
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    bcopy((char *)&theGraph->arcArray[i]->quadratic_origin,g+gsize,dsize);
    gsize += dsize;
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    bcopy((char *)&theGraph->arcArray[i]->weight,g+gsize,dsize);
    gsize += dsize;
  }

  if (gsize != mem) {
    MetanetAlert("Internal error: bad graph size");
    return 0;
  }

  free((char*)la); free((char*)ls); free((char*)lp); 
  free((char*)he); free((char*)ta);

  *glist = g;
  return gsize;
}
