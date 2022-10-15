/* Copyright INRIA */
#include <X11/Intrinsic.h>
#include <stdio.h>
#include <string.h>
#include <malloc.h>

#include "defs.h"
#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "graphics.h"
#include "menus.h"
#include "metadir.h"
#include "metio.h"
#include "color.h"

#include "libCalCom.h"
#include "libCom.h"
#include "netcomm.h"

extern int ComputeValues();
extern XFontStruct *FontSelect();
extern void ShowNodeSet();
extern void ShowPath();

int LoadCommGraph();
void GetMsg();
void SendMsg();

void ParseMessage(type,b)
char *type;
char *b;
{
  if (!strcmp(type,CLOSE)) {
    if (menuId == MODIFY) {
      return;
    } else {
      MetanetQuit(); 
    }
  } else if (!strcmp(type,LOAD)) {
    LoadCommGraph(b,0);
  } else if (!strcmp(type,LOAD_S)) {
    LoadCommGraph(b,0);
    SendMsg(ACK,"");
  } else if (!strcmp(type,LOAD1)) {
    LoadCommGraph(b,1);
  } else if (!strcmp(type,LOAD1_S)) {
    LoadCommGraph(b,1);
    SendMsg(ACK,"");
  } else if (!strcmp(type,SHOWNS)) {
    ShowNodeSet(b,0);
  } else if (!strcmp(type,SHOWNS_S)) {
    ShowNodeSet(b,0);
    SendMsg(ACK,"");
  } else if (!strcmp(type,SHOWP)) {
    ShowPath(b,0);
  } else if (!strcmp(type,SHOWP_S)) {
    ShowPath(b,0);
    SendMsg(ACK,"");
  } else if (!strcmp(type,SHOWNS1)) {
    ShowNodeSet(b,1);
  } else if (!strcmp(type,SHOWNS1_S)) {
    ShowNodeSet(b,1);
    SendMsg(ACK,"");
  } else if (!strcmp(type,SHOWP1)) {
    ShowPath(b,1);
  } else if (!strcmp(type,SHOWP1_S)) {
    ShowPath(b,1);
    SendMsg(ACK,"");
  }
}

void GetMsg(message)
Message message;
{
  ParseMessage(message.tableau[3],message.tableau[4]);
}

void SendMsg(type, msg)
char *type;
char *msg;
{
  envoyer_message_parametres_var(ID_GeCI,MSG_POSTER_LISTE_ELMNT,
				 type,msg,NULL);
}

int LoadCommGraph(b, sup)
char *b;
int sup;
{
  char str[MAXNAM],str1[MAXNAM];
  int directed,n,ma,*he,*ta;
  double scale;
  int *ntype,*xnode,*ynode,*ncolor,*ndiam,*nborder,*nfontsize;
  double *demand;
  int *acolor,*awidth,*ahiwidth,*afontsize; 
  double *length,*cost,*mincap,*maxcap,*qweight,*qorig,*weight;
  int gndiam,gnborder,gawidth,gahiwidth,gfontsize;
  FILE* f;
  char fname[2 * MAXNAM];
  int i,ln,s;
  char *name;
  char **nameEdgeArray,**nameNodeArray;
  char **labelEdgeArray,**labelNodeArray;
  int is_elabel, is_nlabel;
  node *nod;
  arc *a;
  int isize = sizeof(int);
  int dsize = sizeof(double);
  int csize = sizeof(char);

  if (sup == 0) {
    if ((menuId == STUDY) || (menuId == MODIFY)) {
      sprintf(Description,"There is already a loaded graph");
      MetanetAlert(Description);
      return 0;
    }
  }
  else {
    if (menuId == MODIFY) {
      sprintf(Description,"There is a modified graph");
      MetanetAlert(Description);
      return 0;
    }
    if (menuId == STUDY) StudyQuit();
  }

  /* name */
  strcpy(str,strtok(b,STRINGSEP));
  if ((name = (char *)malloc((unsigned)strlen(str) + 1)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  strcpy(name,str);

  /* file name */
  strcpy(str,strtok(NULL,STRINGSEP));
  strcpy(str1,strtok(NULL,STRINGSEP));

  sprintf(fname,"/tmp/%s.metanet.%s",str,str1);
  f = fopen(fname,"r");
  if (f == NULL) {
    sprintf(Description,
	    "Unable to read graph \"%s\" in directory \"/tmp\"",name);
    MetanetAlert(Description);
    return 0;
  }

  FindGraphNames();

  /* directed */
  fread((char*)&directed,isize,1,f);

  /* scale */
  fread((char*)&scale,dsize,1,f);

  /* n */
  fread((char*)&n,isize,1,f);

  /* ma */
  fread((char*)&ma,isize,1,f);

  /* tail */
  s = isize * ma;
  if ((ta = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)ta,isize,ma,f);

  /* head */
  s = isize * ma;
  if ((he = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)he,isize,ma,f);

  /* node_name */
  if ((nameNodeArray = 
       (char**)malloc((unsigned)n*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  for (i = 0; i < n; i++) {
    fread((char*)&ln,isize,1,f);
    if ((nameNodeArray[i] = (char *)malloc((unsigned)ln + 1)) 
	== NULL) {
      fprintf(stderr,"Running out of memory\n");
    return 0;
    }    
    fread(nameNodeArray[i],csize,ln+1,f);
  }

  /* node_type */
  s = isize * n;
  if ((ntype = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)ntype,isize,n,f);

  /* node_x */
  s = isize * n;
  if ((xnode = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)xnode,isize,n,f);

  /* node_y */
  s = isize * n;
  if ((ynode = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)ynode,isize,n,f);

  /* node_color */
  s = isize * n;
  if ((ncolor = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)ncolor,isize,n,f);

  /* node_diam */
  s = isize * n;
  if ((ndiam = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)ndiam,isize,n,f);

  /* node_border */
  s = isize * n;
  if ((nborder = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)nborder,isize,n,f);

  /* node_font_size */
  s = isize * n;
  if ((nfontsize = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)nfontsize,isize,n,f);

  /* node_demand */
  s = dsize * n;
  if ((demand = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
   fread((char*)demand,dsize,n,f);
 
  /* edge_name */
  if ((nameEdgeArray = 
       (char**)malloc((unsigned)ma*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  for (i = 0; i < ma; i++) {
    fread((char*)&ln,isize,1,f);
    if ((nameEdgeArray[i] = (char *)malloc((unsigned)ln + 1)) 
	== NULL) {
      fprintf(stderr,"Running out of memory\n");
    return 0;
    }    
    fread(nameEdgeArray[i],csize,ln+1,f);
  }

  /* edge_color */
  s = isize * ma;
  if ((acolor = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)acolor,isize,ma,f);

  /* edge_width */
  s = isize * ma;
  if ((awidth = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)awidth,isize,ma,f);

  /* edge_hi_width */
  s = isize * ma;
  if ((ahiwidth = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)ahiwidth,isize,ma,f);

  /* edge_font_size */
  s = isize * ma;
  if ((afontsize = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)afontsize,isize,ma,f);

  /* edge_length */
  s = dsize * ma;
  if ((length = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)length,dsize,ma,f);

  /* edge_cost */
  s = dsize * ma;
  if ((cost = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)cost,dsize,ma,f);

  /* edge_min_cap */
  s = dsize * ma;
  if ((mincap = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)mincap,dsize,ma,f);

  /* edge_max_cap */
  s = dsize * ma;
  if ((maxcap = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)maxcap,dsize,ma,f);

  /* edge_q_weight */
  s = dsize * ma;
  if ((qweight = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)qweight,dsize,ma,f);

  /* edge_q_orig */
  s = dsize * ma;
  if ((qorig = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)qorig,dsize,ma,f);

  /* edge_weight */
  s = dsize * ma;
  if ((weight = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  fread((char*)weight,dsize,ma,f);

  /* default_node_diam */
  fread((char*)&gndiam,isize,1,f);

  /* default_node_border */
  fread((char*)&gnborder,isize,1,f);

  /* default_edge_width */
  fread((char*)&gawidth,isize,1,f);

  /* default_edge_hi_width */
  fread((char*)&gahiwidth,isize,1,f);

  /* default_font_size */
  fread((char*)&gfontsize,isize,1,f);

  /* node_label */
  fread((char*)&is_nlabel,isize,1,f);
  if (is_nlabel) {
    if ((labelNodeArray = 
	 (char**)malloc((unsigned)n*sizeof(char*))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return 0;
    }
    for (i = 0; i < n; i++) {
      fread((char*)&ln,isize,1,f);
      if ((labelNodeArray[i] = (char *)malloc((unsigned)ln + 1)) 
	  == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return 0;
      }    
      fread(labelNodeArray[i],csize,ln+1,f);
    }
  }

  /* edge_label */
  fread((char*)&is_elabel,isize,1,f);
  if (is_elabel) {
    if ((labelEdgeArray = 
	 (char**)malloc((unsigned)ma*sizeof(char*))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return 0;
    }
    for (i = 0; i < ma; i++) {
      fread((char*)&ln,isize,1,f);
      if ((labelEdgeArray[i] = (char *)malloc((unsigned)ln + 1)) 
	  == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return 0;
      }    
      fread(labelEdgeArray[i],csize,ln+1,f);
    }
  }

  fclose(f);

  /* Compute graph */

  DestroyGraph(theGraph);
  theGraph = GraphAlloc(name);
  
  theGraph->directed = directed;
  theGraph->nodeDiam = gndiam;
  theGraph->nodeBorder = gnborder;
  theGraph->arcWidth = gawidth;
  theGraph->arcHiWidth = gahiwidth;
  theGraph->fontSize = gfontsize;

  if (theGraph->nodeDiam <= 0) theGraph->nodeDiam = NODEDIAM;
  if (theGraph->nodeBorder <= 0) theGraph->nodeBorder = NODEW;
  if (theGraph->arcWidth <= 0) theGraph->arcWidth = ARCW;
  if (theGraph->arcHiWidth <= 0) theGraph->arcHiWidth = ARCH;
  if (FontSelect(theGraph->fontSize) == NULL) 
    theGraph->fontSize = DRAWFONTSIZE;

  theGraph->arc_number = ma;
  theGraph->node_number = n;
  
  for (i = 1; i <= ma; i++)
    AddListElement((ptr)ArcAlloc(i),theGraph->arcs);
  for (i = 1; i <= n; i++)
    AddListElement((ptr)NodeAlloc(i),theGraph->nodes);
  MakeArraysGraph(theGraph);

  /* Nodes */

  for (i = 1; i <= n; i++) {
    nod = GetNode(i,theGraph);
    nod->name = nameNodeArray[i-1];
    if (is_nlabel) nod->label = labelNodeArray[i-1];

    nod->type = ntype[i-1];
    if (nod->type == SOURCE) {
      theGraph->source_number++;
      AddListElement((ptr)nod,theGraph->sources);
    }
    if (nod->type == SINK) {
      theGraph->sink_number++;
      AddListElement((ptr)nod,theGraph->sinks);
    }

    nod->x = xnode[i-1];
    nod->y = ynode[i-1];
    nod->col = CheckColor(ncolor[i-1]); 
    nod->diam = ndiam[i-1];
    if (nod->diam < 0) nod->diam = 0;
    nod->border = nborder[i-1];
    if (nod->border < 0) nod->border = 0;
    nod->fontSize = nfontsize[i-1];
    if (FontSelect(nod->fontSize) == NULL) nod->fontSize = 0;
    nod->demand = demand[i-1];
  }

  /* Arcs */

  for (i = 1; i <= ma; i++) {
    a = GetArc(i,theGraph);
    a->name = nameEdgeArray[i-1];
    if (is_elabel) a->label = labelEdgeArray[i-1];

    a->head = GetNode(he[i-1],theGraph);

    a->tail = GetNode(ta[i-1],theGraph);

    if (a->tail == 0 || a->head == 0) {
      sprintf(Description,"Bad node name while reading arc %d in graph file\n",
	      i);
      MetanetAlert(Description);  
      return 0;
    }

    a->col = CheckColor(acolor[i-1]);
    a->width = awidth[i-1];
    if (a->width < 0) a->width = 0;
    a->hiWidth = ahiwidth[i-1];
    if (a->hiWidth < 0) a->hiWidth = 0;
    a->fontSize = afontsize[i-1];
    if (FontSelect(a->fontSize) == NULL) a->fontSize = 0;
    a->unitary_cost = cost[i-1];
    a->minimum_capacity = mincap[i-1];
    a->maximum_capacity = maxcap[i-1];
    a->length = length[i-1];
    a->quadratic_weight = qweight[i-1];
    a->quadratic_origin = qorig[i-1];
    a->weight = weight[i-1];
  }

  free((char*)name); free((char*)ta); free((char*)he); 
  free((char*)ntype);
  free((char*)xnode); free((char*)ynode); free((char*)ncolor);
  free((char*)ndiam); free((char*)nborder); free((char*)nfontsize);
  free((char*)demand);
  free((char*)acolor); free((char*)awidth); free((char*)ahiwidth);  
  free((char*)afontsize); free((char*)length); 
  free((char*)cost); free((char*)mincap); free((char*)maxcap); 
  free((char*)qweight);  free((char*)qorig); free((char*)weight);

  if(!ComputeValues(theGraph)) return 0;
  
  if (scale > 0) metaScale = scale;
  DisplayMenu(STUDY);
  DrawGraph(theGraph);
  return 1;
}
