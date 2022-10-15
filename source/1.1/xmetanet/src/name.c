#include <malloc.h>

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "metio.h"

void AutomaticName();
void ChangeArcName();
void ChangeNodeName();
void NameArc();
void NameNode();
void AutomaticName();
void UndirectedAutomaticName();

void NameObject()
{
  if (theGG.active != 0) {
    switch (theGG.active_type) {
    case ARC:
      NameArc((arc*)theGG.active);
      break;
    case NODE:
      NameNode((node*)theGG.active);
      break;
    }
    UnhiliteActive();
    theGG.active = 0;
    theGG.active_type = 0;
    theGG.modified = 1;  
  }
}

void AutomaticName ()
{
  mylink *p;
  arc *a; node *n;
  char str[MAXNAM];

  if (!theGraph->directed) {
    UndirectedAutomaticName();
    return;
  }
  if (MetanetYesOrNo
      ("Do you REALLY want to use internal numbers for nodes and arcs names ?")) {
    if (MetanetYesOrNo
	("Possibly old existing names will be DEFINITIVELY lost. Ok ?")) {

      RenumberGraph(theGraph);
      AddMessage("Graph %s renumbered\n",theGraph->name);

      MakeArraysGraph(theGraph);

      p = theGraph->arcs->first;
      while (p) {
	a = (arc*)p->element;
	sprintf(str,"%d",a->number);
	if ((a->name = 
	     (char*)malloc((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
	  fprintf(stderr,"Running out of memory\n");
	  return;
	}
	strcpy(a->name,str);
	p = p->next;
      }
      p = theGraph->nodes->first;
      while (p) {
	n = (node*)p->element;
	sprintf(str,"%d",n->number);
	if ((n->name = 
	     (char*)malloc((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
	  fprintf(stderr,"Running out of memory\n");
	  return;
	}
	strcpy(n->name,str);
	p = p->next;
      }
      ComputeNameArraysGraph(theGraph);
      DrawGraph(theGraph);
      theGG.modified = 1; 
    }
  }
}

void UndirectedAutomaticName ()
{
  mylink *p;
  arc *a; node *n;
  char str[MAXNAM];

  if (MetanetYesOrNo
      ("Do you REALLY want to use internal numbers for nodes and arcs names ?")) {

    RenumberGraph(theGraph);
    AddMessage("Graph %s renumbered\n",theGraph->name);

    MakeArraysGraph(theGraph);

    p = theGraph->arcs->first;
    while (p) {
      a = (arc*)p->element;
      if (a->number % 2 == 0)
      sprintf(str,"%d",a->number / 2);
      else {
	sprintf(str,"%d",(a->number + 1) / 2);
      }
      if ((a->name = 
	   (char*)malloc((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return;
      }
      strcpy(a->name,str);
      p = p->next;
    }
    p = theGraph->nodes->first;
    while (p) {
      n = (node*)p->element;
      sprintf(str,"%d",n->number);
      if ((n->name = 
	   (char*)malloc((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return;
      }
      strcpy(n->name,str);
      p = p->next;
    }
    ComputeNameArraysGraph(theGraph);
    DrawGraph(theGraph);
    theGG.modified = 1;  
  }
}

void NameArc(a)
arc *a;
{
  char str[MAXNAM];
  char *p;
  int n;

  MetanetDialog("",str,"New name for highlighted arc %s",
		a->name);
  p = str;
  while (*p != '\0') {
    if (*p++ == ' ') {
      MetanetAlert("New arc name must not contain white space");
      return;
    }
  }
  ChangeArcName(a,str);
}

void ChangeArcName(a,str)
arc *a;
char *str;
{
  mylink *p,*q;
  int i,indic;
  arc *aa,*a2;

  indic = 0;
  if (theGraph->directed) {
    p = theGraph->arcs->first;
    while (p) {
      aa = (arc*)p->element;
      if (aa->name != 0 && strcmp(aa->name,str) == 0) {
	indic = 1;
	break;
      }
      p = p->next;
    }
    if (indic == 1) {
      /* str is already the name of another arc */
      HiliteArc(aa);
      MetanetAlert
	("%s is already the name of another highlighted arc",str);
      UnhiliteArc(aa);
    }
    else {
      free(a->name);
      if ((a->name = 
	   (char*)malloc((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return;
      }
      strcpy(a->name,str);
    }
  }
  else {
    p = theGraph->arcs->first;
    while (p) {
      aa = (arc*)p->element;
      if (aa->name != 0 && strcmp(aa->name,str) == 0) {
	indic = 1;
	break;
      }
      p = p->next;
    }
    if (indic == 1) {
      /* n is already the name of another arc */
      HiliteArc(aa);
      MetanetAlert
	("%s is already the name of another highlighted arc",str);
      UnhiliteArc(aa);
    }
    else {
      free(a->name);
      if ((a->name = 
	   (char*)malloc((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return;
      }
      strcpy(a->name,str);
      q = theGraph->arcs->first;
      while (q) {
	a2 = (arc*)q->element;
	if (a2->number == a->number + 1) {
	  a2->name = a->name;
	  break;
	}
	q = q->next;
      }      
    }
  }
}

void NameNode(nod)
node *nod;
{
  char str[MAXNAM];
  char *p;
  int n;
  
  MetanetDialog("",str,
		"New name for highlighted node %s",nod->name);
  p = str;
  while (*p != '\0') {
    if (*p++ == ' ') {
      MetanetAlert("New node name must not contain white space");
      return;
    }
  }
  ChangeNodeName(nod,str);
}

void ChangeNodeName(n,str)
node *n;
char *str;
{
  mylink *p;
  int i,indic;
  node *nn;
  indic = 0;
  p = theGraph->nodes->first;
  while (p) {
    nn = (node*)p->element;
    if (nn->name != 0 && strcmp(nn->name,str) == 0) {
      indic = 1;
      break;
    }
    p = p->next;
  }

  if (indic == 1) {
    /* n is already the name of another node */
    HiliteNode(nn);
    MetanetAlert("%s is already the name of another highlighted node",str);
    UnhiliteNode(nn);
  }
  else {
    free(n->name);
    if ((n->name = 
	 (char*)malloc((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return;
   }
    strcpy(n->name,str);
  }
}
