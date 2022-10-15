#include <dirent.h>
#include <stdio.h>
#include <string.h>  
#include <stdlib.h>

#define MAXNAM 80
#define MAXNODE 10000

int FindGraphNames();

char* names[100];
char datanet[2*MAXNAM];

enum {PLAIN, SINK, SOURCE};

int main(argc,argv)
int argc;char** argv;
{
  int graph_number;
  char name[MAXNAM];
  int i,j;
  int directed, node_number, arc_number, source_number, sink_number;
  int indic[MAXNODE];
  char* env;
  int bad,exists;
  FILE* f;
  char fname[2 * MAXNAM];

  printf("\nCreating a template graph file\n\n");
  
  env = getenv("DATANET");
  if (env == NULL) {
    env = getenv("SCI");
    if (env == NULL) {
      printf("Environment variable SCI or DATANET must be defined\n");
      exit(1);
    }
    else sprintf(datanet,"%s/xmetanet/data",env);
  }
  else strcpy(datanet,env);
  if (opendir(datanet) == NULL) {
    printf("Data directory \"%s\"\n",datanet);
    printf("  does not exist\n");
    printf("Verify environment variable SCI or DATANET\n");
    exit(1);
  }

  graph_number = FindGraphNames();

  while (1) {

    while (1) {
      printf("Graph name : ");
      scanf("%s",name);
      exists = 0;
      for (i = 0; i < graph_number; i++) {
	if (strcmp(name,names[i]) == 0) {
	  exists = 1;
	  break;
	}
      }
      if (!exists) break;
      printf("\n Graph %s already exists\n\n",name);
    }
    printf("\n");
  
    while (1) {
      printf("Is the graph directed (yes = 1, no = 0) ? ");
      scanf("%d",&directed);
      if (directed == 0 || directed == 1) break;
      printf("\n Please answer 1 or 0\n\n");
    }
    printf("\n");
  
    while (1) {
      if (directed)
	printf("Number of arcs : ");
      else printf("Number of edges : ");
      scanf("%d",&arc_number);
      if (arc_number > 0) break;
      printf("\n The number of arcs must be strictly positive\n\n");
    }
    printf("\n");

    while (1) {
      printf("Number of nodes : ");
      scanf("%d",&node_number);
      if (node_number > 1 && node_number <= MAXNODE) break;
      printf("\n The number of nodes must be between 2 and %d\n\n",MAXNODE);
    }
    printf("\n");
    for (i = 1; i <= node_number; i++)
      indic[i] = PLAIN;
  
    while(1) {
      printf("Number of source nodes : ");
      scanf("%d",&source_number);
      if (source_number >= 0 && source_number <= node_number) break;
      printf("\n The number of source nodes must be between 0 and %d\n\n",
	     node_number);
    }
    printf("\n");
    bad = 0;
    if (source_number != 0) {
      while (1) {
	printf("Source node numbers : ");
	for (i = 0; i < source_number; i++) {
	  scanf("%d",&j);
	  if (j < 0 || j > node_number) {
	    bad = 1;
	    break;
	  }
	  indic[j] = SOURCE;
	}
	if (!bad) break;
	printf("\n Source node numbers must be between 1 and %d\n\n",
	       node_number);
      }
    }
    printf("\n");

    while(1) {
      printf("Number of sink nodes : ");
      scanf("%d",&sink_number);
      if (sink_number >= 0 && sink_number <= node_number - source_number)
	break;
      printf("\n The number of sink nodes must be between 0 and %d\n\n",
	     node_number - source_number);
    }
    printf("\n");
  
    bad = 0;
    if (sink_number != 0) {
      while (1) {
	printf("Sink node numbers : ");
	for (i = 0; i < sink_number; i++) {
	  scanf("%d",&j);
	  if (j < 0 || j > node_number) {
	    bad = 1;
	    break;
	  }
	  indic[j] = SINK;
	}
	if (!bad) break;
	printf("\n Sink node numbers must be between 1 and %d\n\n",
	       node_number);
      }
    }
    printf("\n");

    printf("\n");
    printf("Graph %s :\n",name);
    if (directed) {
      printf("  it is a directed graph\n");
      printf("  number of arcs = %d\n",arc_number);
    }
    else {
      printf(  "it is an undirected graph\n");
      printf("  number of edges = %d\n",arc_number);
    }
    printf("  number of nodes = %d\n",node_number);
    if (source_number == 0)
      printf("  no source");
    else {
      printf("  %d sources :",source_number);
      for (i = 1; i <= node_number; i++)
	if (indic[i] == SOURCE) printf(" %d",i);
      printf("\n");
    }
    if (sink_number == 0)
      printf("  no sink");
    else {
      printf("  %d sinks :",sink_number);
      for (i = 1; i <= node_number; i++)
	if (indic[i] == SINK) printf(" %d",i);
      printf("\n");
    }
    printf("\n");
    while (1) {
      printf("Is it ok ? (1 = YES, 0 = NO) ");
      scanf("%d",&j);
      if (j == 0 || j == 1) break;
      printf("\n Please answer 0 or 1\n\n");
    }
    if (j) break;
  }

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,name);
  strcat(fname,".graph");
  f = fopen(fname,"w");

  fprintf(f,"GRAPH TYPE (0 = UNDIRECTED, 1 = DIRECTED) :\n");
  fprintf(f,"%d\n",directed);
  if (directed)
    fprintf(f,"NUMBER OF ARCS :\n");
  else fprintf(f,"NUMBER OF EDGES :\n");
  fprintf(f,"%d\n",arc_number);
  fprintf(f,"NUMBER OF NODES :\n");
  fprintf(f,"%d\n",node_number);
  fprintf(f,"****************************************\n");
  if (directed) {
    fprintf(f,"DESCRIPTION OF ARCS :\n");
    fprintf(f,"ARC #, TAIL NODE #, HEAD NODE #\n");
  }
  else {
    fprintf(f,"DESCRIPTION OF EDGES :\n");
    fprintf(f,"EDGE #, NODE #, NODE #\n");
  }
  fprintf
    (f,"COST, MIN CAP, MAX CAP, LENGTH, Q WEIGHT, Q ORIGIN, WEIGHT\n");
  fprintf(f,"\n");
  for (i = 1; i <= arc_number; i++) {
    fprintf(f,"%d\n",i);
    fprintf(f,"%e %e %e %e %e %e %e %e\n",
	    0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
  }
  fprintf(f,"****************************************\n");
  fprintf(f,"DESCRIPTION OF NODES :\n");
  fprintf(f,"NODE #, POSSIBLE TYPE (1 = SINK, 2 = SOURCE)\n");
  fprintf(f,"X, Y\n");
  fprintf(f,"EMPTY\n");
  fprintf(f,"\n");
  for (i = 1; i <= node_number; i++) {
    if (indic[i] == PLAIN)
      fprintf(f,"%d\n",i);
    else fprintf(f,"%d %d\n",i,indic[i]);
    fprintf(f,"\n\n");
  }

  fclose(f);
}

int FindGraphNames()
{
  DIR* dirp;
  struct dirent* dp;
  char *s,*p;
  char t[MAXNAM];
  int i;
  int j = 0;

  dirp = opendir(datanet);
  for (dp = readdir(dirp); dp != NULL; dp = readdir(dirp)) {
    s = dp->d_name;
    i = 0;
    while (t[i++] = *s++) {
      if (*s == '.') {
	s++;
	if (strcmp(s,"graph") == 0) {
	  t[i] = '\0';
	  p = malloc(i+1);
	  strcpy(p,t);
	  names[j++] = p;
	}
	break;
      }
    }
  }
  return j;
}
