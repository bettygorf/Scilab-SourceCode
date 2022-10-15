#include <dirent.h>
#include <stdlib.h>
#include <string.h>

#include "list.h"
#include "graph.h"
#include "metio.h"
#include "menus.h"

extern char* basename();
extern char* dirname();
extern int LoadNamedGraph();
extern char *StripGraph();

#if defined(SYSV) || defined(SVR4)
#define getwd(x) getcwd(x,2*MAXNAM)
#endif

#define MAXGRAPHS 100

int intDisplay = 0;
int nodeNameDisplay = 0;
int arcNameDisplay = 0;
double metaScale = 1.0;

int maxGraphs;
GG theGG;
char *graphNames[MAXGRAPHS];
graph *theGraph;
char datanet[2*MAXNAM];
char beginHelp[2*MAXNAM];
char studyHelp[2*MAXNAM];
char modifyHelp[2*MAXNAM];

void InitMetanet(path,scale)
char *path;
double scale;
{
  char *dir, *name;
  DIR *dirp;
  FILE *f1, *f2, *f3;

  name = NULL;
  if (path == NULL) {
    getwd(datanet);
  }
  else {
    if ((dirp=opendir(path)) != NULL) {
      strcpy(datanet,path);
      closedir(dirp);
    } else {
      name = basename(path);
      dir = dirname(path);
      if (dir == NULL) getwd(datanet);
      else strcpy(datanet,dir);
    }

    if ((dirp=opendir(datanet)) == NULL) {
      sprintf(Description,"Directory \"%s\" does not exist",datanet);
      MetanetAlert(Description);
      exit(1);
    }
    closedir(dirp);
  }

  dir=getenv("NETHELPDIR");
  if (dir == NULL || (dirp=opendir(dir)) == NULL) {
    sprintf(Description,"Help Directory does not exist\nHelp not available");
    MetanetAlert(Description);
  }  else {
    strcpy(beginHelp,dir);
    strcat(beginHelp,"/MetanetBegin.help");
    strcpy(studyHelp,dir);
    strcat(studyHelp,"/MetanetStudy.help");
    strcpy(modifyHelp,dir);
    strcat(modifyHelp,"/MetanetModify.help");
    if ((f1=fopen(beginHelp,"r")) == NULL || 
	(f2=fopen(studyHelp,"r")) == NULL ||
	(f3=fopen(modifyHelp,"r")) == NULL) {
      sprintf(Description,"Help Files does not exist\nHelp not available");   
    }
    fclose(f1); fclose(f2); fclose(f3);    
    closedir(dirp);
  }
  
  if (scale > 0) metaScale = scale;
  
  theGG.n_hilited_arcs = 0;
  theGG.n_hilited_nodes = 0;
  theGG.hilited_arcs = ListAlloc();
  theGG.hilited_nodes = ListAlloc();
  theGG.moving = 0;
  theGG.modified = 0;
  theGraph = NULL;
  maxGraphs = MAXGRAPHS;
  if (name != NULL && LoadNamedGraph(StripGraph(name))) return;
  DisplayMenu(BEGIN);
}
