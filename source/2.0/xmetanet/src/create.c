#include <malloc.h>
#include <string.h>

#include "metadir.h"
#include "list.h"
#include "graph.h"
#include "metio.h"

#include "libCom.h"

extern double atof();

void CreateGraph(b)
char *b;
{
  char str[MAXNAM];
  int directed,m,n,ma,mm,*la1,*lp1,*ls1,*la2,*lp2,*ls2,*he,*ta;
  int *ntype,*xnode,*ynode,*ncolor,*acolor; double *demand;
  double *length,*cost,*mincap,*maxcap,*qweight,*qorig,*weight;
  int dsize,isize,iscoord,s;
  FILE* f;
  char fname[2 * MAXNAM];
  int i;
  char *name;
  char **nameEdgeArray,**nameNodeArray;

  isize = sizeof(int);
  dsize = sizeof(double);

  strcpy(str,strtok(b,STRINGSEP));

  if ((name = (char *)malloc((unsigned)strlen(str) + 1)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  strcpy(name,str);

  FindGraphNames();
  if (FindInLarray(name,graphNames)) {
    sprintf(Description,"Graph %s already exists",name);
    MetanetAlert(Description);
    return;
  }

  directed = atoi(strtok(NULL,STRINGSEP));

  m = atoi(strtok(NULL,STRINGSEP));

  n = atoi(strtok(NULL,STRINGSEP));

  ma = atoi(strtok(NULL,STRINGSEP));

  mm = atoi(strtok(NULL,STRINGSEP));

  s = isize * m;
  if ((la1 = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  for (i = 0; i < m; i++) {
    la1[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * (n + 1);
  if ((lp1 = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  for (i = 0; i < n + 1; i++) {
    lp1[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * m;
  if ((ls1 = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  for (i = 0; i < m; i++) {
    ls1[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * mm;
  if ((la2 = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  for (i = 0; i < mm; i++) {
    la2[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * (n + 1);
  if ((lp2 = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < n + 1; i++) {
    lp2[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * mm;
  if ((ls2 = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < mm; i++) {
    ls2[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * ma;
  if ((he = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    he[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * ma;
  if ((ta = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    ta[i] = atoi(strtok(NULL,STRINGSEP));
  }

  if ((nameNodeArray = 
       (char**)malloc((unsigned)(n + 1)*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  for (i = 1; i <= n; i++) {
    strcpy(str,strtok(NULL,STRINGSEP));
    if ((nameNodeArray[i] = (char *)malloc((unsigned)strlen(str) + 1)) 
	== NULL) {
      fprintf(stderr,"Running out of memory\n");
    return;
    }
    strcpy(nameNodeArray[i],str);
  }

  s = isize * n;
  if ((ntype = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < n; i++) {
    ntype[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * n;
  if ((xnode = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < n; i++) {
    xnode[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * n;
  if ((ynode = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < n; i++) {
    ynode[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * n;
  if ((ncolor = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < n; i++) {
    ncolor[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = dsize * n;
  if ((demand = (double *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < n; i++) {
    demand[i] = atof(strtok(NULL,STRINGSEP));
  }

  if ((nameEdgeArray = 
       (char**)malloc((unsigned)(ma + 1)*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  for (i = 1; i <= ma; i++) {
    strcpy(str,strtok(NULL,STRINGSEP));
    if ((nameEdgeArray[i] = (char *)malloc((unsigned)strlen(str) + 1)) 
	== NULL) {
      fprintf(stderr,"Running out of memory\n");
    return;
    }
    strcpy(nameEdgeArray[i],str);
  }
  
  s = isize * ma;
  if ((acolor = (int *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    acolor[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = dsize * ma;
  if ((length = (double *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    length[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * ma;
  if ((cost = (double *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    cost[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * ma;
  if ((mincap = (double *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    mincap[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * ma;
  if ((maxcap = (double *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    maxcap[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * ma;
  if ((qweight = (double *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    qweight[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * ma;
  if ((qorig = (double *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    qorig[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * ma;
  if ((weight = (double *)malloc(s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
   for (i = 0; i < ma; i++) {
    weight[i] = atof(strtok(NULL,STRINGSEP));
  }

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,name);
  strcat(fname,".graph");
  f = fopen(fname,"w");
  if (f == NULL) {
    sprintf(Description,
	    "Unable to write file in directory %s\nCheck access",datanet);
    MetanetAlert(Description);
    return;
  }

  fprintf(f,"GRAPH TYPE (0 = UNDIRECTED, 1 = DIRECTED), DEFAULTS (NODE DIAMETER, NODE BORDER, ARC WIDTH, HILITED ARC WIDTH, FONTSIZE):\n");
  fprintf(f,"%d\n",directed);
  if (directed) {
    fprintf(f,"NUMBER OF ARCS :\n");
    fprintf(f,"%d\n",m);
  }
  else {
    fprintf(f,"NUMBER OF EDGES :\n");
    fprintf(f,"%d\n",ma);
  }
  fprintf(f,"NUMBER OF NODES :\n");
  fprintf(f,"%d\n",n);
  fprintf(f,"****************************************\n");
  if (directed) {
    fprintf(f,"DESCRIPTION OF ARCS :\n");
    fprintf(f,"ARC NAME, TAIL NODE NAME, HEAD NODE NAME, COLOR, WIDTH, HIWIDTH, FONTSIZE\n");
  }
  else {
    fprintf(f,"DESCRIPTION OF EDGES :\n");
    fprintf(f,"EDGE NAME, NODE NAME, NODE NAME, COLOR, WIDTH, HIWIDTH, FONTSIZE\n");
  }
  fprintf
    (f,"COST, MIN CAP, MAX CAP, LENGTH, Q WEIGHT, Q ORIGIN, WEIGHT\n");
  fprintf(f,"\n");
  for (i = 1; i <= ma; i++) {
    fprintf(f,"%s %s %s %d\n",nameEdgeArray[i],nameNodeArray[ta[i-1]],
	    nameNodeArray[he[i-1]],acolor[i-1]);
    fprintf(f,"%e %e %e %e %e %e %e\n",
	    cost[i-1],mincap[i-1],maxcap[i-1],
	    length[i-1],qweight[i-1],qorig[i-1],weight[i-1]);
  }
  fprintf(f,"****************************************\n");
  fprintf(f,"DESCRIPTION OF NODES :\n");
  fprintf(f,"NODE NAME, POSSIBLE TYPE (1 = SINK, 2 = SOURCE)\n");
  fprintf(f,"X, Y, COLOR, DIAMETER, BORDER, FONTSIZE\n");
  fprintf(f,"DEMAND\n");
  fprintf(f,"\n");
  iscoord = 0;
  for (i = 1; i <= n; i++) {
    if ((xnode[i-1] != 0) || (ynode[i-1] != 0)) {
      iscoord = 1;
      break;
    }
  }  
  for (i = 1; i <= n; i++) {
    if (ntype[i-1] == PLAIN)
      fprintf(f,"%s\n",nameNodeArray[i]);
    else fprintf(f,"%s %d\n",nameNodeArray[i],ntype[i-1]);
    if (iscoord)
      fprintf(f,"%d %d %d\n",xnode[i-1],ynode[i-1],ncolor[i-1]);
    else
      fprintf(f,"%d %d %d\n",xnode[i-1],ynode[i-1],ncolor[i-1]);
    fprintf(f,"%e\n",demand[i-1]);
  }

  fclose(f);
  
  sprintf(Description,"Graph %s saved\n",name);
  AddMessage(Description);

  free((char*)name); free((char*)la1); free((char*)lp1); free((char*)ls1); 
  free((char*)la2); free((char*)lp2); free((char*)ls2); free((char*)he); 
  free((char*)ta); free((char*)nameNodeArray); 
  free((char*)ntype);
  free((char*)xnode); free((char*)ynode); free((char*)ncolor); 
  free((char*)demand); free((char*)nameEdgeArray);
  free((char*)acolor); free((char*)length); 
  free((char*)cost); free((char*)mincap); free((char*)maxcap); 
  free((char*)qweight);  free((char*)qorig); free((char*)weight);
}
