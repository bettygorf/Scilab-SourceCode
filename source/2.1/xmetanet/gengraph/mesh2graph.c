#include <dirent.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#define MAXNAM 80
#define MAXNODE 10000  

int FindGraphNames();

char* names[100];
char datanet[MAXNAM];

enum {PLAIN, SINK, SOURCE};
     
int main(argc,argv)
int argc;
char** argv;
{
  char name[MAXNAM]; 
  char* env;
  int aug,exists,graph_number,i,node_number,overwrite,triang_number;
  int *x,*y;
  double len;
  char line[5 * MAXNAM],fname[2 * MAXNAM];
  FILE *fg,*fm;
  int source_number,sink_number,arc_number,tail,head,capacity,cost;
  int *indic,*b;
  int na;

  switch (argc) {
  case 1:
    break;
  default:
    printf("%s needs no argument\n",argv[0]);
    exit(1);
  }

  printf("\nCreating a graph file from MESH.DAT file\n\n");  

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

  graph_number =  FindGraphNames(); 

  overwrite = 0;
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
    printf("\n Graph %s already exists\n",name);
    while (1) {
      printf("\n Do you want to overwrite graph %s (yes = 1, no = 0)?\n\n",
	     name);
      scanf("%d",&overwrite);
      if (overwrite == 0 || overwrite == 1) break;
      printf("\n Please answer 1 or 0\n\n");
    }
    if (overwrite) break;
  }
  
  while (1) {
    printf("\n Do you want to save the augmented graph for %s (yes = 1, no = 0)?\n\n",
	   name);
    scanf("%d",&aug);
    if (aug == 0 || aug == 1) break;
    printf("\n Please answer 1 or 0\n\n");
  }
  printf("\n");

  fm = fopen("MESH.DAT","r");

  fgets(line,5 * MAXNAM,fm);
  fscanf(fm,"%d\n",&node_number);

  x = (int *)malloc(node_number * sizeof(int));
  y = (int *)malloc(node_number * sizeof(int));
  
  fgets(line,5 * MAXNAM,fm);

  for (i = 0; i < node_number; i++) {
    fgets(line,5 * MAXNAM,fm);
    sscanf(line,"%*d %d %d",&x[i],&y[i]);
  }

  fgets(line,5 * MAXNAM,fm);
  fscanf(fm,"%d\n",&triang_number);
  fgets(line,5 * MAXNAM,fm);
  for (i = 0; i < triang_number; i++)
    fgets(line,5 * MAXNAM,fm);

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,name);
  strcat(fname,".graph");
  fg = fopen(fname,"w");

  if (aug) {
    
    /* SAVE AUGMENTED GRAPH */

    fgets(line,5 * MAXNAM,fm);
    fscanf(fm,"%d\n",&source_number);
    
    fgets(line,5 * MAXNAM,fm);
    for (i = 0; i < source_number; i++)
      fgets(line,5 * MAXNAM,fm);

    fgets(line,5 * MAXNAM,fm);
    fscanf(fm,"%d\n",&sink_number);
    
    fgets(line,5 * MAXNAM,fm);
    for (i = 0; i < sink_number; i++)
      fgets(line,5 * MAXNAM,fm);
    
    fgets(line,5 * MAXNAM,fm);
    fscanf(fm,"%d\n",&arc_number);
    fgets(line,5 * MAXNAM,fm);

    fprintf(fg,"GRAPH TYPE (0 = UNDIRECTED, 1 = DIRECTED) :\n");
    fprintf(fg,"1\n");
    fprintf(fg,"NUMBER OF ARCS :\n");
    fprintf(fg,"%d\n",arc_number);
    fprintf(fg,"NUMBER OF NODES :\n");
    fprintf(fg,"%d\n",node_number + 2);
    fprintf(fg,"****************************************\n");
    fprintf(fg,"DESCRIPTION OF ARCS :\n");
    fprintf(fg,"ARC #, TAIL NODE #, HEAD NODE #\n");
    fprintf
      (fg,"COST, MIN CAP, MAX CAP, LENGTH, Q WEIGHT, Q ORIGIN, WEIGHT\n");
    fprintf(fg,"\n");
    for (i = 1; i <= arc_number; i++) {
      fscanf(fm,"%*d %d %d %d %d\n",&tail,&head,&capacity,&cost);
      fprintf(fg,"%d %d %d\n",i,tail,head);
      len  = (double)(x[head-1] - x[tail-1])*(x[head-1] - x[tail-1])+
		    (y[head-1] - y[tail-1])*(y[head-1] - y[tail-1]);
      fprintf(fg,"%e %e %e %e %e %e %e %e\n",
	      (double)cost,0.0,(double)capacity,sqrt(len),
	      0.0,0.0,0.0,0.0);
    }
    fprintf(fg,"****************************************\n");
    fprintf(fg,"DESCRIPTION OF NODES :\n");
    fprintf(fg,"NODE #, POSSIBLE TYPE (1 = SINK, 2 = SOURCE)\n");
    fprintf(fg,"X, Y\n");
    fprintf(fg,"DEMAND\n");
    fprintf(fg,"\n");
    for (i = 0; i < node_number; i++) {
      fprintf(fg,"%d\n",i + 1);
      fprintf(fg,"%d %d\n",x[i],y[i]);
      fprintf(fg,"%e\n",0.0);
    }
    /* source and sink */
    fprintf(fg,"%d %d\n",node_number + 1,SOURCE);
    fprintf(fg,"\n");
    fprintf(fg,"%e\n",0.0);

    fprintf(fg,"%d %d\n",node_number + 2,SINK);
    fprintf(fg,"\n");
    fprintf(fg,"%e\n",0.0);
  }
  else {
    
    /* DON'T SAVE AUGMENTED GRAPH */

    indic = (int *)malloc(node_number * sizeof(int));
    b = (int *)malloc(node_number * sizeof(int));

    for (i = 0; i < node_number; i++) {
      b[i] = 0;
      indic[i] = PLAIN;
    }
    
    fgets(line,5 * MAXNAM,fm);
    fscanf(fm,"%d\n",&source_number);
    
    fgets(line,5 * MAXNAM,fm);
    for (i = 0; i < source_number; i++)
      fgets(line,5 * MAXNAM,fm);

    fgets(line,5 * MAXNAM,fm);
    fscanf(fm,"%d\n",&sink_number);
    
    fgets(line,5 * MAXNAM,fm);
    for (i = 0; i < sink_number; i++)
      fgets(line,5 * MAXNAM,fm);
    
    fgets(line,5 * MAXNAM,fm);
    fscanf(fm,"%d\n",&arc_number);
    
    fgets(line,5 * MAXNAM,fm);

    strcpy(fname,datanet);
    strcat(fname,"/");
    strcat(fname,name);
    strcat(fname,".graph");
    fg = fopen(fname,"w");

    fprintf(fg,"GRAPH TYPE (0 = UNDIRECTED, 1 = DIRECTED) :\n");
    fprintf(fg,"1\n");
    fprintf(fg,"NUMBER OF ARCS :\n");
    fprintf(fg,"%d\n",arc_number - source_number - sink_number);
    fprintf(fg,"NUMBER OF NODES :\n");
    fprintf(fg,"%d\n",node_number);
    fprintf(fg,"****************************************\n");
    fprintf(fg,"DESCRIPTION OF ARCS :\n");
    fprintf(fg,"ARC #, TAIL NODE #, HEAD NODE #\n");
    fprintf
      (fg,"COST, MIN CAP, MAX CAP, LENGTH, Q WEIGHT, Q ORIGIN, WEIGHT\n");
    fprintf(fg,"\n");
    na = 0;
    for (i = 1; i <= arc_number; i++) {
      fscanf(fm,"%*d %d %d %d %d\n",&tail,&head,&capacity,&cost);
      if (tail == node_number + 1) {
	/* arc from super source */
	indic[head - 1] = SOURCE;
	b[head -1] = - capacity;
      }
      else if (head == node_number + 2) {
	/* arc from super sink */
	indic[tail - 1] = SINK;
	b[tail -1] = capacity;
      }
      else {
	na++;
	fprintf(fg,"%d %d %d\n",na,tail,head);
	len  = (double)(x[head-1] - x[tail-1])*(x[head-1] - x[tail-1])+
		    (y[head-1] - y[tail-1])*(y[head-1] - y[tail-1]);
	fprintf(fg,"%e %e %e %e %e %e %e %e\n",
		(double)cost,0.0,(double)capacity,sqrt(len),
		0.0,0.0,0.0,0.0);
      }
    }
    fprintf(fg,"****************************************\n");
    fprintf(fg,"DESCRIPTION OF NODES :\n");
    fprintf(fg,"NODE #, POSSIBLE TYPE (1 = SINK, 2 = SOURCE)\n");
    fprintf(fg,"X, Y\n");
    fprintf(fg,"DEMAND\n");
    fprintf(fg,"\n");
    for (i = 1; i < node_number + 1; i++) {
      if (indic[i - 1] == PLAIN) 
	fprintf(fg,"%d\n",i);
      else
	fprintf(fg,"%d %d\n",i,indic[i - 1]);
      fprintf(fg,"%d %d\n",x[i - 1],y[i - 1]);
      fprintf(fg,"%e\n",(double)b[i - 1]);
    }
  }
  
  fclose(fm);
  fclose(fg);
}

int FindGraphNames()
{
  DIR* dirp;
  struct dirent* dp;
  char* s;
  char t[MAXNAM];
  int i;
  int j = 0;
  char* p;

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
