/*
-------------------------------------------
PROGRAMMES   C  POUR  LE  LINK  DYNAMIQUE  
-------------------------------------------
*/
/* Editeur de liens dynamique pour UNIX.
   permet de rajouter des points d'entrees a un programme en
   cours d'execution. Attention on ne peut par ce moyen remplacer
   un sous-programme lie lors de l'edition de liens initiale.

En  entree :
------------
 ename : chaine de caracteres contenant le nom du point d'entree a rajouter
 loaded_file : chaine de caracteres contenant les noms de fichiers
               necessaires a la definition de ename (Il n'est pas necessaire
               d'ajouter la definition des sous programmes inclus dans
               l'executable initial.
 ii : numero d'ordre du point d'entree . Ce peut etre le numero d'ordre+1
      du dernier point d'entree lie dynamiquement, ou son numero d'ordre
      (au quel cas ce dernier point d'entree est detruit et remplace par
      ename), ou 0 si ename est le premier sous programme a etre lie.

En sortie:
----------
 err : indicateur d'erreur :
       0 si ok
       >0 sinon
 epoints : tableau statique contenant l'adresse de chacun des points
           d'entrees lies dynamiquement. Peut etre utlise par dyncall
           pour faire executer les sous programmes ainsi lies.

Origine: Michael Fan (Andre Tits)

*/

#include "../machine.h"


/*
 Appel de dynload a partir de fortran .
 i : numero d'ordre du point d'entree a definir
 fname  : chaime de caracteres fortran contenant la liste des fichiers
          necessaires a l'edition de liens.
 lf : taille de lf
 spname : chaine de caracteres fortran contenant le nom du point d'entree
 ls : longueur de spname
 err : indicateur d'erreur

 Origine: S Steer INRIA 1988
*/

/** for debug info **/
/** #define DEBUG  **/


#if defined(__STDC__)
void C2F(dynstr)(int *isfor,int *i,char fname[],int *lf,char spname[],int *ls,int *err)
#else
void C2F(dynstr)(isfor,i,fname,lf,spname,ls,err)
int *isfor,*i;char fname[];int *lf;char spname[];int *ls;int *err;
#endif

{
  char enamebuf[80];
  char *ename1;

  fname[*lf]='\0';
  spname[*ls]='\0';
  Underscores(*isfor,spname,enamebuf);
  ename1=enamebuf;
  C2F(dynload)(i,ename1,fname,err) ;
  return;
}

#if (defined(sun) && defined(SYSV)) || defined(__alpha) || defined(sgi)
#include "SYSV_link.c"
#else
#if defined(sun) ||  defined(mips) || defined(_IBMR2) || defined(hppa)
#ifdef SUNOSDLD 
#include "linux_link.c"
#else 
#include "std_link.c"
#endif /* end of SUNOSDLD */
#else
#if defined(linux)
#ifdef __ELF__
#include "SYSV_link.c"
#else
#include "linux_link.c"
#endif 
#else
C2F(dynload)() {cerro("Dynamic link not implemented");}
C2F(dyncall)() {cerro("Dynamic link not implemented");}
#endif
#endif 
#endif 

#ifdef WLU
#ifndef DLDLINK 
#define WLU1 /* dld will add the leading _ itself */
#endif 
#endif 

Underscores(isfor,ename,ename1)
char ename[],ename1[];
int isfor;
    {
   int k1,i;
   k1=0;
#ifdef WLU1
   ename1[0]='_';
   k1=1;
#endif
   for (i=0;i< (int)strlen(ename);i++) ename1[i+k1]=ename[i];
   k1=k1+strlen(ename);
#ifdef WTU
   if (isfor==1) {
       ename1[k1]='_';
       k1=k1+1;
   }
#endif
   ename1[k1]='\0';
   return;
}
