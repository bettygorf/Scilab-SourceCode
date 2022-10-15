#include <string.h>

#include "list.h"
#include "graph.h"
#include "menus.h"
#include "metio.h"
#include "libCom.h"

void ShowPath(p,sup)
char *p;
int sup;
{
  arc *a;
  int ia,j;
  char *s;

  if (menuId == BEGIN) {
    sprintf(Description,"There is no loaded graph");
    MetanetAlert(Description);
    return;
  }
  if (!sup) ReDrawGraph(theGraph);
  s = strtok(p,STRINGSEP);
  while(s != NULL) {
    sscanf(s,"%d",&ia);
    a = GetArc(EdgeToArcNumber(ia,theGraph),theGraph);
    if (a == 0) {
      sprintf(Description,"%d is not an internal arc number",ia);
      MetanetAlert(Description);
      return;
    }
    if (!a->hilited) HiliteArc(a);
    s = strtok(NULL,STRINGSEP);
  }
}

void ShowNodeSet(ns,sup)
char *ns; 
int sup;
{
  node *n;
  int in,j;
  char *s;

  if (menuId == BEGIN) {
    sprintf(Description,"There is no loaded graph");
    MetanetAlert(Description);
    return;
  }
   if (!sup) ReDrawGraph(theGraph);
  s = strtok(ns,STRINGSEP);
  while(s != NULL) {
    sscanf(s,"%d",&in);
    n = GetNode(in,theGraph);
    if (n == 0) {
      sprintf(Description,"%d is not an internal node number",in);
      MetanetAlert(Description);
      return;
    }
    if (!n->hilited) HiliteNode(n);
    s = strtok(NULL,STRINGSEP);
  }
}
