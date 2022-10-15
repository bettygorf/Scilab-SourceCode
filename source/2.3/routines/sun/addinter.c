
#include <string.h> 
#include <stdio.h>
#if defined(THINK_C) || defined (__MWERKS__)  
#include "::graphics:Math.h"
#else
#include "../graphics/Math.h"
#endif
#include "men_Sutils.h"
#include "link.h"

extern int C2F(namstr) _PARAMS((integer *id, integer *str, integer *n, integer *job));

extern int C2F(funtab) _PARAMS((int *id, int *fptr, int *job));  
extern int C2F(error)  _PARAMS((integer *n));  

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#define OK 1
#define FAIL 0

#define MAXINTERF 30
#define INTERFSIZE 25 

typedef struct 
{
  char name[INTERFSIZE]; /** name of interface **/
  void (*func)();        /** entrypoint for the interface **/
  int Nshared; /** id of the shared library **/
  int ok;    /** flag set to 1 if entrypoint can be used **/
} Iel;

Iel DynInterf[MAXINTERF];
static int LastInterf=0;

static void DynFuntab _PARAMS((int *Scistring,int *ptrstrings,int *nstring,int k1));

/************************************************
 * Dynamically added interface to Scilab 
 ************************************************/

void C2F(addinter)(descla,ptrdescla,nvla,iname,desc,ptrdesc,nv)
     int *desc,*ptrdesc,*nv;         /* ename */
     int *descla,*ptrdescla,*nvla;   /* files */
     char *iname;                    /* interface name */
{
  int ierr,i,rhs=2,ilib=0;
  char **files,*names[2];
  ierr=0;
  ScilabMStr2CM(descla,nvla,ptrdescla,&files,&ierr);
  if ( ierr == 1) return;
  names[0]=iname;
  names[1]=(char *)0;
  /** Linking Files and entry point name (in names)*/
  SciLinkInit();
  SciLink(0,&rhs,&ilib,files,names,"f");

  /** we get the linked function in the INterface function table DynInterf **/
  DynInterf[LastInterf].Nshared = ilib;
  if ( SearchInDynLinks(names[0],&DynInterf[LastInterf].func) < 0 ) 
    {
      sciprint("Not  found!");
      return;
    }
  else
    {
      strncpy(DynInterf[LastInterf].name,iname,INTERFSIZE);
      DynInterf[LastInterf].ok = 1;
    }
  LastInterf++;

  /** we add all the Scilab new entry names in the scilab function table funtab **/

  DynFuntab(desc,ptrdesc,nv,LastInterf);

  for (i=0;i< *nvla;i++) FREE(files[i]); FREE(files);
}

void RemoveInterf(Nshared)
     int Nshared;
{
  int i;
  for ( i = 0 ; i < LastInterf ; i++ ) 
    {
      if ( DynInterf[i].Nshared == Nshared ) 
	{
	  DynInterf[i].ok = 0;
	  break;
	}
    }
}


#define nsiz 6 

/************************************************
 * add a set of function to scilab function table 
 ************************************************/

static void DynFuntab(Scistring,ptrstrings,nstring,k1)
     int *Scistring,*nstring,*ptrstrings;
     int k1;
{
  int id[nsiz],zero=0,trois=3,fptr,fptr1,quatre=4;
  int li=1,ni,*SciS,i;
  SciS= Scistring;
  for ( i=1 ; i < *nstring+1 ; i++) 
    {
      ni=ptrstrings[i]-li;
      li=ptrstrings[i];
      C2F(namstr)(id,SciS,&ni,&zero);
      fptr1= fptr= 10000*k1+i;
      C2F(funtab)(id,&fptr1,&quatre); /* clear previous def set fptr1 to 0*/
      C2F(funtab)(id,&fptr,&trois);  /* reinstall */
      SciS += ni;
    }
}

/************************************************
 * Used when one want to call a function added 
 * with addinterf 
 ************************************************/

void C2F(userlk)(k) 
     integer *k;
{
  int k1 = (*k/100) -1 ;
  int imes = 9999;
  if ( k1 >= LastInterf || k1 < 0 ) 
    {
      sciprint("Invalid interface number %d",k1);
      C2F(error)(&imes);
      return;
    }
  if ( DynInterf[k1].ok == 1 ) 
    (*DynInterf[k1].func)();
  else 
    {
      sciprint("Interface %s not linked\r\n",DynInterf[k1].name);
      C2F(error)(&imes);
      return;
    }
}


