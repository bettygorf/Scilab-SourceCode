/* Copyright (c) 1997 by Inria Lorraine.  All Rights Reserved */

/***
   NAME
     pvm_info
   PURPOSE
     
   NOTES
     PVM task information
   HISTORY
     fleury - Nov 18, 1997: Created.
     $Id: pvm_info.c,v 1.5 1998/03/27 12:20:10 fleury Exp $
***/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../pvm3/include/pvm3.h"
#include "../machine.h"


#ifdef __STDC__
void 
C2F(scipvmconfig)(int *nhost, int *narch, int **dtid, 
	       char ***name, char ***arch, int **speed, 
	       int *n, int *info)
#else
void 
C2F(scipvmconfig)(nhost, narch, dtid, name, arch, speed, n, info)
  int *nhost;
  int *narch;
  int **dtid;
  char ***name;
  char ***arch; 
  int **speed;
  int *n;
  int *info;
#endif 
{
  /* [a,d,f,g,h,j,k] = pvm_config() */
  int i;
  struct pvmhostinfo *hostp;
  
  if (*info = pvm_config(nhost, narch, &hostp)) {
    (void) fprintf(stderr, "Error in pvm_config: %d\n", *info);
    return;
  }
  if (((*name) = (char* *) malloc(*nhost * sizeof(char**))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_config\n");
    *info = PvmNoMem;
    return;
  }
  if (((*arch) = (char* *) malloc(*nhost * sizeof(char**))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_config\n");
    *info = PvmNoMem;
    return;
  }
  if ((*dtid = (int *) malloc(*nhost * sizeof(int))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_config\n");
    *info = PvmNoMem;
    return;
  }
  if ((*speed = (int *) malloc(*nhost * sizeof(int))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_config\n");
    *info = PvmNoMem;
    return;
  }
  *n = *nhost;
  
  for (i = 0; i < *nhost; ++i) {
    if (((*name)[i] = (char *) malloc((1+strlen(hostp[i].hi_name)) * 
				      sizeof(char*))) == NULL) {
      (void) fprintf(stderr, "Error malloc in pvm_config\n");
      *info = PvmNoMem;
      return;
    }
    (void) sprintf((*name)[i], "%s", hostp[i].hi_name);
    
    if (((*arch)[i] = (char *) malloc((1+strlen(hostp[i].hi_arch)) * 
				      sizeof(char*))) == NULL) {
      (void) fprintf(stderr, "Error malloc in pvm_config\n");
      *info = PvmNoMem;
      return;
    }
    (void) sprintf((*arch)[i], "%s", hostp[i].hi_arch);
    
    (*dtid)[i] =hostp[i].hi_tid;
    (*speed)[i] =hostp[i].hi_speed;
  }
} /* scipvmconfig */


#ifdef __STDC__
void 
C2F(scipvmtasks)(int *where, int *ntask, 
		   int **tid, int **ptid, int **dtid, int **flag,
		   char ***name, int *n, int *info)
#else
void 
C2F(scipvmtasks)(where, ntask, tid, ptid, dtid, flag, name, n, info)
  int *where; 
  int *ntask; 
  int **tid; 
  int **ptid;  
  int **dtid;  
  int **flag;
  char ***name;
  int *n; 
  int *info;
#endif 
{
  int i;
  struct pvmtaskinfo *taskp;

  if (*info = pvm_tasks(*where, ntask, &taskp)) {
    (void) fprintf(stderr, "Error in pvm_tasks: pvm_tasks=%d\n", *info);
    return;
  }
  if ((*tid = (int *) malloc(*ntask * sizeof(int))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_tasks\n");
    *info = PvmNoMem;
    return;
  }
  if ((*ptid = (int *) malloc(*ntask * sizeof(int))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_tasks\n");
    *info = PvmNoMem;
    return;
  }
  if ((*dtid = (int *) malloc(*ntask * sizeof(int))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_tasks\n");
    *info = PvmNoMem;
    return;
  }
  if ((*flag = (int *) malloc(*ntask * sizeof(int))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_tasks\n");
    *info = PvmNoMem;
    return;
  }
  if (((*name) = (char* *) malloc(*ntask * sizeof(char**))) == NULL) {
    (void) fprintf(stderr, "Error malloc in pvm_config\n");
    *info = PvmNoMem;
    return;
  }
  
  *n = *ntask;
  for (i = 0; i < *ntask; ++i) {
    (*tid)[i] =  taskp[i].ti_tid;
    (*ptid)[i] =  taskp[i].ti_ptid;
    (*dtid)[i] =  taskp[i].ti_host;
    (*flag)[i] =  taskp[i].ti_flag;
    if (((*name)[i] = (char *) malloc((1+strlen(taskp[i].ti_a_out)) * 
				      sizeof(char*))) == NULL) {
      (void) fprintf(stderr, "Error malloc in pvm_task\n");
      *info = PvmNoMem;
      return;
    }
    (void) sprintf((*name)[i], "%s", taskp[i].ti_a_out);
  }
} /* scipvmtasks */


#ifdef __STDC__
void 
C2F(scipvmparent)(int *res)
#else
void 
C2F(scipvmparent)(res)
  int *res;
#endif 
{
  *res = pvm_parent();
} /* scipvmparent */


#ifdef __STDC__
void 
C2F(scipvmtidtohost)(int *tid, int *res)
#else
void 
C2F(scipvmtidtohost)(tid, res)
  int *tid;
  int *res;
#endif 
{
  *res = pvm_tidtohost(*tid);
} /* scipvmtidtohost */
