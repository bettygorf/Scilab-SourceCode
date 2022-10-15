#include <errno.h>
#include <string.h>

#include "metadir.h"
#include "list.h"
#include "graph.h"
#include "metio.h"

extern graph *ReadGraphFromFile();

void DeleteGraph()
{
  char name[MAXNAM];
  char fgname[2 * MAXNAM];
  char fmname[2 * MAXNAM];
  int rm, rg;

  FindGraphNames();
  if (graphNames[0] == 0) {
    MetanetAlert("There is no saved graph");
    return;
  }
  if (!MetanetChoose("Choose a graph",graphNames,name))
    return;
  strcpy(fgname,datanet);
  strcat(fgname,"/");
  strcat(fgname,name);
  strcat(fgname,".graph");
  strcpy(fmname,datanet);
  strcat(fmname,"/");
  strcat(fmname,name);
  strcat(fmname,".metanet");

  if (!MetanetYesOrNo("Do you really want to delete graph %s",name))
    return;

  rm = unlink(fmname);
  rg = unlink(fgname);
  if (rg != 0) {
    MetanetAlert ("It is not possible to delete file %s.graph",name);
    return;
  }
  if (rm != 0 && errno != ENOENT) {
    MetanetAlert ("It is not possible to delete file %s.metanet",name);
    return;
  }
  AddMessage("Graph %s deleted\n",name);
}

void CopyGraph()
{
  char name[MAXNAM], newName[MAXNAM];
  char fname[2 * MAXNAM], newFname[2 * MAXNAM];
  char str[4 * MAXNAM + 4];
  FILE *fm;

  FindGraphNames();
  if (graphNames[0] == 0) {
    MetanetAlert("There is no saved graph");
    return;
  }
  if (!MetanetChoose("Choose a graph",graphNames,name))
    return;
  
  MetanetDialog("",newName,"Other name for graph %s : ",name);
  if (strcmp(newName,"") == 0) return;

  if (FindInLarray(newName,graphNames)) {
    MetanetAlert("Graph %s exists\n",newName);
  }
  else {
    /* copy graph file */
    strcpy(fname,datanet);
    strcat(fname,"/");
    strcat(fname,name);
    strcat(fname,".graph");

    strcpy(newFname,datanet);
    strcat(newFname,"/");
    strcat(newFname,newName);
    strcat(newFname,".graph");

    sprintf(str,"\\cp %s %s",fname,newFname);
    system(str);

    /* copy metanet file */
    
    strcpy(fname,datanet);
    strcat(fname,"/");
    strcat(fname,name);
    strcat(fname,".metanet");
    fm = fopen(fname,"r");
    
    if (fm != 0) {
      fclose(fm);
      strcpy(newFname,datanet);
      strcat(newFname,"/");
      strcat(newFname,newName);
      strcat(newFname,".metanet");

      sprintf(str,"\\cp %s %s",fname,newFname);
      system(str);
    }
    
    AddMessage("Graph %s created\n",newName);
  }
}

void RenameGraph()
{
  char name[MAXNAM], newName[MAXNAM];
  char fname[2 * MAXNAM], newFname[2 * MAXNAM];
  char str[4 * MAXNAM + 4];
  FILE *fm;
 
  FindGraphNames();
  if (graphNames[0] == 0) {
    MetanetAlert("There is no saved graph");
    return;
  }
  if (!MetanetChoose("Choose a graph",graphNames,name))
    return;
  
  MetanetDialog("",newName,"New name for graph %s : ",name);
  if (strcmp(newName,"") == 0) return;
  if (FindInLarray(newName,graphNames)) {
    MetanetAlert("Graph %s exists\n",newName);
  }
  else {
    /* rename graph file */
    strcpy(fname,datanet);
    strcat(fname,"/");
    strcat(fname,name);
    strcat(fname,".graph");

    strcpy(newFname,datanet);
    strcat(newFname,"/");
    strcat(newFname,newName);
    strcat(newFname,".graph");

    sprintf(str,"\\mv %s %s",fname,newFname);
    system(str);

    /* rename metanet file */
    
    strcpy(fname,datanet);
    strcat(fname,"/");
    strcat(fname,name);
    strcat(fname,".metanet");
    fm = fopen(fname,"r");
    
    if (fm != 0) {
      fclose(fm);
      strcpy(newFname,datanet);
      strcat(newFname,"/");
      strcat(newFname,newName);
      strcat(newFname,".metanet");

      sprintf(str,"\\mv %s %s",fname,newFname);
      system(str);  
    }
    
    AddMessage("Graph %s created\n",newName);
    AddMessage("Graph %s deleted\n",name);
  }
}
