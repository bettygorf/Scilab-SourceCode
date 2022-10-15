/* Copyright INRIA */
#include <string.h>
#include <malloc.h>

#include "list.h"
#include "graph.h"
#include "metio.h"

typedef int (*PF)();

list *ListAlloc()
{
  list *l;
  if ((l = (list*)malloc((unsigned)sizeof(list))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  l->first = 0;
  return l;
}

mylink *MylinkAlloc(e,n)
ptr e;
mylink *n;
{
  mylink *p;
  
  if ((p = (mylink*)malloc(sizeof(mylink))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  p->element = e;
  p->next = n;
  return p;
}

void AddListElement(e,l)
ptr e;
list *l;
{
  if (l->first == 0)
    l->first = MylinkAlloc(e,(mylink*)0);
  else
    l->first = MylinkAlloc(e,l->first);
}

void RemoveListElement(e,l)
ptr e;
list *l;
{
  mylink *pn, *p;

  if (l->first == 0) return;
  pn = l->first->next;
  if (l->first->element == e) {
    l->first = pn;
  }
  else {
    p = l->first;
    while (pn) {
      if(pn->element == e) {
	p->next = pn->next;
	free((char*)pn);
	break;
      }
      p = pn;
      pn = pn->next;
    }
  }
}

int FindInLarray(s,lar)
char *s;
char *lar[];
{
 int n = 0;

 while (lar[n] != 0) {
   if (strcmp(lar[n++],s) == 0) return n;
 }

 return 0;
}

int CompString(s1, s2)
char **s1, **s2;
{
  return strcmp((char*)*s1,(char*)*s2);
}

void SortLarray(lar)
char *lar[];
{
  int n = 0;

  while (lar[n++] != 0) {}

  qsort((char*)lar,n - 1,sizeof(char*),(PF)CompString);
}

void PrintArcList(l,level)
list *l;
int level;
{
  mylink *p;

  if (!l->first) {
    sprintf(Description,"nil\n");
    AddText(Description);
    return;
  }
  p = l->first;
  while (p) {
    PrintArc((arc*)p->element,level);
    p = p->next;
  }
  sprintf(Description,"\n");
  AddText(Description);
}

void PrintNodeList(l,level)
list *l;
int level;
{
  mylink *p;

  if (!l->first) {
    sprintf(Description,"nil\n");
    AddText(Description);
    return;
  }
  p = l->first;
  while (p) {
    PrintNode((node*)p->element,level);
    p = p->next;
  }
  sprintf(Description,"\n");
  AddText(Description);
}
