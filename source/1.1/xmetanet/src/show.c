#include "list.h"
#include "graph.h"
#include "metio.h"

void ShowPath( p, dimpath, sup)
int *p, dimpath, sup;
{
  arc *a;
  int j;
  if (!sup) ReDrawGraph(theGraph);
  for (j = 0; j < dimpath; j++) {
    a = GetArc(EdgeToArcNumber(p[j],theGraph),theGraph);
    if (a == 0) {
      MetanetAlert("%d is not an internal arc number",p[j]);
      return;
    }
    if (!a->hilited) HiliteArc(a);
  }
}

void ShowNodeSet(ns, dimset, sup)
int *ns, dimset, sup;
{
  node *n;
  int j;
  if (!sup) ReDrawGraph(theGraph);
  for (j = 0; j < dimset; j++) {
    n = GetNode(ns[j],theGraph);
    if (n == 0) {
      MetanetAlert("%d is not an internal node number",ns[j]);
      return;
    }
    if (!n->hilited) HiliteNode(n);
  }
}
