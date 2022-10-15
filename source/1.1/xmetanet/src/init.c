#include <dirent.h>
#include <stdlib.h>
#include <string.h>

#include "list.h"
#include "graph.h"
#include "metio.h"

int LoadNamedGraph();

#define MAXGRAPHS 100

int intDisplay = 0;
int nodeNameDisplay = 1;
int arcNameDisplay = 1;
int maxGraphs;
GG theGG;
char *graphNames[MAXGRAPHS];
graph *theGraph;
char datanet[2*MAXNAM];
double metaScale;

void InitMetanet(name)
char *name;
{
  char *env;

  env = getenv("DATANET");
  if (env == NULL) {
    env = getenv("SCI");
    if (env == NULL) {
      MetanetAlert("Environment variable SCI or DATANET must be defined\n");
      exit(1);
    }
    else sprintf(datanet,"%s/xmetanet/data",env);
  }
  else strcpy(datanet,env);
  if (opendir(datanet) == NULL) {
    MetanetAlert("Data directory \"%s\" does not exist\nVerify environment variable SCI or DATANET",datanet);
    exit(1);
  }
  
  theGG.moving = 0;
  theGG.active = 0;
  theGG.active_type = 0;
  theGG.modified = 0;
  metaScale = 1.0;
  theGraph = NULL;
  maxGraphs = MAXGRAPHS;
  if (name != NULL) LoadNamedGraph(name,0);
}
