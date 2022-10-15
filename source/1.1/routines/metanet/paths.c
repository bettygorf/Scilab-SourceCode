#include "../machine.h"

#define NULL 0

extern void cerro();

/* NodesToPath converts a vector with node numbers into a path:
   NODES = [Nn,...,N2,N1] =>
   PATH = [A1,A2,...,An-1] with Ai = (Ni,Ni+1)
   n = *psize + 1 
*/
void NodesToPath(nodes,p,psize,la1,lp1,ls1,direct)
int *nodes,*psize,*la1,*lp1,*ls1,*direct;
int **p;
{
  int a,i,j,n1,n2;
  for (i = 1; i <= *psize; i++) {
    n1 = nodes[*psize-i+1]; n2 = nodes[*psize-i];
    a = 0;
    for (j = lp1[n1-1]; j <= lp1[n1]-1; j++) {
      if (n2 == ls1[j-1]) {
	if (*direct == 1) a = la1[j-1];
	else a = (la1[j-1] + 1)/2;
	break;
      }
    }
    if (a == 0) {
      *psize = 0;
      return;
    }
    (*p)[i-1] = a;
  }
}

/* prevn2p_ computes a path from node i to node j from a
   vector describing the previous nodes in path:
   node i belongs to path if pln[i] > 0 
   pln[i] is then the previous node in the sequence 
*/
void C2F(prevn2p)(i,j,m,n,la1,lp1,ls1,direct,pln,p,psize)
int *i,*j,*m,*n,*la1,*lp1,*ls1,*direct,*pln,*psize;
int **p;
{
  int *nodes;
  int k,nn;
  if (*i < 0 || *i > *n) {
    cerro("Bad internal node number %d",*i);
    return;
  }
  if (*j < 0 || *j > *n) {
    cerro("Bad internal node number %d",*j);
    return;
  }
  if ((nodes = (int *)malloc((*m + 1) * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  nn = 0;
  nodes[nn++] = *j;
  k = 0;
  /* the first time, the test must be always verified for dealing with
     circuits */
  while (k != *i) {
    if (nn == 1) k = *j;
    k = pln[k-1];
    nodes[nn++] = k;
    if (k <= 0 || k > *n || nn > *n) {
      /* there is no path */
      *psize = 0;
      return;
    }
  }
  *psize = nn - 1;
  if ((*p = (int *)malloc(*psize * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  NodesToPath(nodes,p,psize,la1,lp1,ls1,direct);
  free(nodes);
}

/* ns2p_ converts a node set into a path:
   NODES = [N1,N2,...,Nn] =>
   PATH = [A1,A2,...,An-1] with Ai = (Ni,Ni+1)
   *psize = *nsize - 1 
*/
void C2F(ns2p)(nodes,nsize,p,psize,la1,lp1,ls1,direct,n)
int *nodes,*nsize,*psize,*la1,*lp1,*ls1,*direct,*n;
int **p;
{
  int a,i,j,n1,n2;
  *psize = *nsize - 1;
  if ((*p = (int *)malloc(*psize * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 1; i <= *psize; i++) {
    n1 = nodes[i-1];
    if ((i == 1) && (n1 < 0 || n1 > *n)) {
      cerro("Bad internal node number %d",n1);
      return;
    }
    n2 = nodes[i];
    if (n2 < 0 || n2 > *n) {
      cerro("Bad internal node number %d",n2);
      return;
    }
    a = 0;
    for (j = lp1[n1-1]; j <= lp1[n1]-1; j++) {
      if (n2 == ls1[j-1]) {
	if (*direct == 1) a = la1[j-1];
	else a = (la1[j-1] + 1)/2;
	break;
      }
    }
    if (a == 0) {
      *psize = 0;
      return;
    }
    (*p)[i-1] = a;
  }
}

/* p2ns_ converts a path into a node set:
   PATH = [A1,A2,...,An] =>
   NODES = [N1,N2,...,Nn+1] => with Ai = (Ni,Ni+1)
   with *nsize = *psize + 1 
*/
void C2F(p2ns)(p,psize,nodes,nsize,la1,lp1,ls1,direct,m,n)
int *p,*psize,*nsize,*la1,*lp1,*ls1,*direct,*m,*n;
int **nodes;
{
  int a,i,j,k,n1,n2;
  *nsize = *psize + 1;
  if ((*nodes = (int *)malloc(*nsize * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 1; i <= *psize; i++) {
    if (*direct == 1) a = p[i-1];
    else a = 2 * p[i-1];
    if (a < 0 || a > *m) {
      cerro("Bad internal arc number %d",a);
      return;
    }
    n1 = 0; n2 = 0;
    for (j = 1; j <= *n; j++) {
      for (k = lp1[j-1]; k <= lp1[j]-1; k++)
	if (la1[k-1] == a) {
	  n1 = j; n2 = ls1[k-1];
	  break;
	}
      if (n1 != 0) break;
    }
    if (n1 == 0) {
      *nsize = 0;
      return;
    }
    if (*direct == 1) {
      if (i == 1) (*nodes)[i-1] = n1;
      if (i!= 1 && (*nodes)[i-1] != n1) {
	*nsize = 0;
	return;
      }
      (*nodes)[i] = n2;
    }
    else {
      if (i == 1) {
	(*nodes)[0] = n1; (*nodes)[1] = n2;
      }
      else if (i == 2) {
	if (n1 == (*nodes)[0]) {
	  (*nodes)[0] = (*nodes)[1]; (*nodes)[1] = n1;
	  (*nodes)[2] = n2;
	}
	else if (n1 == (*nodes)[1]) (*nodes)[2] = n2;
	else {
	  *nsize = 0;
	  return;
	}
      }
      else {
	if (n1 != (*nodes)[i-1]) {
	  *nsize = 0;
	  return;
	}
	(*nodes)[i] = n2;
      }
    }
  }
}

/* edge2st_ computes a spanning tree (root = node 1) from 
   an array alpha of connecting edge numbers */

void C2F(edge2st)(n,alpha,tree,treesize)
int *n,*alpha,*treesize;
int **tree;
{
  int i;
  *treesize = *n - 1;
  if ((*tree = (int *)malloc(*treesize * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 1; i <= *n - 1; i++) {
    if (alpha[i] < 0) {
      cerro("There is no tree");
      return;
    }
    (*tree)[i-1] = alpha[i];
  }
}

/* prevn2st_ computes a spanning tree (root = node i0) from
   a vector nodes describing the previous nodes in tree */

void C2F(prevn2st)(n,nodes,tree,treesize,la1,lp1,ls1)
int *n,*nodes,*treesize,*la1,*lp1,*ls1;
int **tree;
{
  int i,in,j,nt;
  *treesize = *n - 1;
  if ((*tree = (int *)malloc(*treesize * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  nt = 0;
  for (i = 1; i <= *n; i++) {
    in = nodes[i-1];
    if (in == 0) continue;
    /* arc (in,i) belongs to tree */
    for (j = lp1[in-1]; j <= lp1[in]-1; j++) {
      if (ls1[j-1] == i)	{
	(*tree)[nt++] = la1[j-1];
	break;
      }
    }
  }
}
