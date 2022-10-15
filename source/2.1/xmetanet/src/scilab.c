#include <malloc.h>

#include "list.h"
#include "graph.h"
#include "metio.h"
#include "libCom.h"

extern graph *MakeUndirected();

static int *la;
static int *ls;
static int *lp;
static int *he;
static int *ta;

/* Compute adjacency description for directed or undirected graph,
   depending upon FORDIR parameter
*/

#define mystrcat(s1,s2) istr=0;while(s2[istr]!='\0'){s1[ig++]=s2[istr++];}s1[ig++]=CHARSEP;

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
  int salloc,gsize,i,mem,nitem,s;
  int m,n,ma,mm;
  int lname,lnname,laname;
  char str[MAXNAM]; int istr;
  char *g; 
  int ig = 0;

  lname = strlen(theGraph->name);
  m = theGraph->arc_number;
  n = theGraph->node_number;
  if (theGraph->directed) ma = m; else ma = m / 2;
  mm = 2 * ma;

  nitem = 1; mem = lname + 1; 
  nitem += 7 + (2 * m) + (2 * (n + 1)) + (2 * mm) + (3 * ma) + (4 * n);
  mem +=  ISIZE * (7 + (2 * m) + (2 * (n + 1)) + (2 * mm) + (3 * ma) +
		   (4 * n));
  nitem += n + (7 * ma);
  mem += DSIZE * (n + (7 * ma));

  lnname = 0;
  for (i = 1; i <= n; i++) {
    lnname += strlen(theGraph->nameNodeArray[i]) + 1;
  }
  nitem += n;
  mem += lnname;

  laname = 0;
  for (i = 1; i <= ma; i++) {
    laname += strlen(theGraph->nameEdgeArray[i]) + 1;
  }
  nitem += ma;
  mem += laname;
  
  salloc = mem + nitem;
  if ((g = (char *)malloc((unsigned)salloc)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return(0);
  }

  mystrcat(g,theGraph->name);

  sprintf(str,"%d",theGraph->directed);
  mystrcat(g,str);

  sprintf(str,"%d",m);
  mystrcat(g,str);

  sprintf(str,"%d",n);
  mystrcat(g,str);

  sprintf(str,"%d",ma);
  mystrcat(g,str);

  sprintf(str,"%d",mm);
  mystrcat(g,str);

  ComputeAdjacencyDescription(1,theGraph);

  for (i = 0; i < m; i++) {
    sprintf(str,"%d",la[i]);
    mystrcat(g,str);
  }

  for (i = 0; i < n + 1; i++) {
    sprintf(str,"%d",lp[i]);
    mystrcat(g,str);
  }

  for (i = 0; i < m; i++) {
    sprintf(str,"%d",ls[i]);
    mystrcat(g,str);
  }

  ComputeAdjacencyDescription(0,theGraph);

  for (i = 0; i < mm; i++) {
    sprintf(str,"%d",la[i]);
    mystrcat(g,str);
  }

  for (i = 0; i < n+1; i++) {
    sprintf(str,"%d",lp[i]);
    mystrcat(g,str);
  }

  for (i = 0; i < mm; i++) {
    sprintf(str,"%d",ls[i]);
    mystrcat(g,str);
  }

  ComputeEdgeDescription(theGraph);

  for (i = 0; i < ma; i++) {
    sprintf(str,"%d",he[i]);
    mystrcat(g,str);
  }

  for (i = 0; i < ma; i++) {
    sprintf(str,"%d",ta[i]);
    mystrcat(g,str);
  }

  for (i = 1; i <= n; i++) {
    mystrcat(g,theGraph->nameNodeArray[i]);
  }

  for (i = 1; i <= n; i++) {
    sprintf(str,"%d",theGraph->nodeArray[i]->type);
    mystrcat(g,str);
  }

  for (i = 1; i <= n; i++) {
    sprintf(str,"%d",theGraph->nodeArray[i]->x);
    mystrcat(g,str);
  }

  for (i = 1; i <= n; i++) {
    sprintf(str,"%d",theGraph->nodeArray[i]->y);
    mystrcat(g,str);
  }

  for (i = 1; i <= n; i++) {
    sprintf(str,"%d",theGraph->nodeArray[i]->col);
    mystrcat(g,str);
  }

  for (i = 1; i <= n; i++) {
    sprintf(str,"%e",theGraph->nodeArray[i]->demand);
    mystrcat(g,str);
  }

  for (i = 1; i <= ma; i++) {
    mystrcat(g,theGraph->nameEdgeArray[i]);
  }
  
  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    sprintf(str,"%d",theGraph->arcArray[i]->col);
    mystrcat(g,str);
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    sprintf(str,"%e",theGraph->arcArray[i]->length);
    mystrcat(g,str);
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    sprintf(str,"%e",theGraph->arcArray[i]->unitary_cost);
    mystrcat(g,str);
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    sprintf(str,"%e",theGraph->arcArray[i]->minimum_capacity);
    mystrcat(g,str);
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    sprintf(str,"%e",theGraph->arcArray[i]->maximum_capacity);
    mystrcat(g,str);
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    sprintf(str,"%e",theGraph->arcArray[i]->quadratic_weight);
    mystrcat(g,str);
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    sprintf(str,"%e",theGraph->arcArray[i]->quadratic_origin);
    mystrcat(g,str);
  }

  for (i = 1; i <= m; i++) {
    if (!theGraph->directed && (i % 2 == 0)) continue;
    sprintf(str,"%e",theGraph->arcArray[i]->weight);
    mystrcat(g,str);
  }

  g[ig] = '\0';
  gsize = ig;

  if (gsize > salloc) {
    
    return 0;
  }

  free((char*)la); free((char*)ls); free((char*)lp); 
  free((char*)he); free((char*)ta);

  *glist = g;
  return gsize;
}
