#include <X11/Intrinsic.h>
#include <malloc.h>

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "metio.h"
#include "graphics.h"

extern void UnhiliteArc();
extern void UnhiliteNode();

void AutomaticName();
void ChangeArcName();
void ChangeNodeName();
void NameArc();
void NameNode();
void AutomaticName();

void NameObject()
{
  arc *a;
  node *n;
  if (theGG.n_hilited_nodes == 0 && theGG.n_hilited_arcs == 1) {
    a = (arc*)theGG.hilited_arcs->first->element;
    NameArc(a);
    theGG.modified = 1;
  }
  else if (theGG.n_hilited_nodes == 1 && theGG.n_hilited_arcs == 0) {
    n = (node*)theGG.hilited_nodes->first->element;
    NameNode(n);
    theGG.modified = 1;
  }
}

void AutomaticName ()
{
  mylink *p;
  arc *a; node *n;
  char str[MAXNAM];

  sprintf(Description,"Do you REALLY want to use internal numbers for nodes and arcs names ?");
  if (MetanetYesOrNo(Description)) {
    sprintf(Description,"Possibly old existing names will be DEFINITIVELY lost. Ok ?");
    if (MetanetYesOrNo(Description)) {
      RenumberGraph(theGraph);
      sprintf(Description,"Graph %s renumbered\n",theGraph->name);
      AddMessage(Description);
	  
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
      DrawGraph(theGraph);
      theGG.modified = 1; 
    }
  }
}

void NameArc(a)
arc *a;
{
  char str[MAXNAM];
  char *p;

  sprintf(Description,"New name for highlighted arc %s",a->name);
  if (a->name == 0) {if (!MetanetDialog("",str,Description)) return;}
  else {if (!MetanetDialog(a->name,str,Description)) return;}
  p = str;
  while (*p != '\0') {
    if (*p++ == ' ') {
      sprintf(Description,"New arc name must not contain white space");
      MetanetAlert(Description);
      return;
    }
  }
  if (a->name != 0 && !strcmp(a->name,str)) return;
  if (arcNameDisplay) {
    UnhiliteArc(a);
    EraseArc(a);
  }
  ChangeArcName(a,str);
  if (arcNameDisplay) HiliteArc(a);
}

void ChangeArcName(a,str)
arc *a;
char *str;
{
  mylink *p;
  int indic;
  arc *aa;

  indic = 0;
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
    sprintf(Description,"%s is already the name of another highlighted arc",
	    str);
    MetanetAlert(Description);
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

void NameNode(nod)
node *nod;
{
  char str[MAXNAM];
  char *p;
  
  sprintf(Description,"New name for highlighted node %s",nod->name);
  if (nod->name == 0) {if (!MetanetDialog("",str,Description)) return;}
  else {if (!MetanetDialog(nod->name,str,Description)) return;}
  p = str;
  while (*p != '\0') {
    if (*p++ == ' ') {
      sprintf(Description,"New node name must not contain white space");
      MetanetAlert(Description);
      return;
    }
  }
  if (nod->name != 0 && !strcmp(nod->name,str)) return;
  if (nodeNameDisplay) {
    UnhiliteNode(nod);
    EraseNode(nod);
  }
  ChangeNodeName(nod,str);
  if (nodeNameDisplay) HiliteNode(nod);
}

void ChangeNodeName(n,str)
node *n;
char *str;
{
  mylink *p;
  int indic;
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
    sprintf(Description,"%s is already the name of another highlighted node",
	    str);
    MetanetAlert(Description);
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
    DrawNode(n);
  }
}
