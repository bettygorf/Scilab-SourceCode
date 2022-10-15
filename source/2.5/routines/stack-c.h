/* Common Block Declarations */
/* Copyright INRIA */
#ifndef STACK_SCI 
#define STACK_SCI 

#if !(defined __ABSC__) && !(defined __MATH__)
#include "graphics/Math.h"
#else
#include "machine.h"
#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))
#endif

#include "stack-def.h"


/*********************************
 * to simplify interface design 
 *********************************/

static int c1_local;
static int c_local;
extern int C2F(error) _PARAMS((int *));
extern int C2F(getrhsvar) _PARAMS((integer *, char *type__, integer *, integer *, integer *, unsigned long));
extern int C2F(getrhscvar) _PARAMS((integer *, char *type__,integer*,integer*, integer *, integer *, integer *, unsigned long));

extern int C2F(createvar) _PARAMS((integer *, char *, integer *, integer *, integer *, unsigned long ));
extern int C2F(createcvar) _PARAMS((integer *, char *,integer *,integer*, integer *, integer *, integer *, unsigned long ));

extern int C2F(putlhsvar) _PARAMS((void));
extern int C2F(cmatptr) _PARAMS((char *,integer *,integer *,integer *,unsigned long));
extern int C2F(createvarfromptr) _PARAMS((integer *,char *, integer *, integer *,double *, unsigned long));
extern int C2F(createcvarfromptr) _PARAMS((integer *,char *,integer*, integer *, integer *,double *,double *, unsigned long));

extern int C2F(scifunction) _PARAMS ((integer *,integer *,integer *,integer*));
extern int C2F(numopt) _PARAMS((void));
extern int C2F(isopt) _PARAMS((integer *,char *,integer));
extern int C2F(gettype) _PARAMS((integer *pos));

/** extern  voidf GetFuncPtr _PARAMS((char *,int,FTAB *,voidf,int *,int*,int*)); **/

#define NumOpt() C2F(numopt)() 
#define IsOpt(k,name) C2F(isopt)((c_local=k,&c_local),name,nlgh)

#define CreateVarFromPtr(n,ct,mx,nx,lx) if ( ! C2F(createvarfromptr)((c_local=n,&c_local),ct,mx,nx,(double *)lx,1L)) \
					     { return 0;} 

#define CreateCVarFromPtr(n,ct,it,mx,nx,lrx,lcx) if ( ! C2F(createcvarfromptr)((c_local=n,&c_local),ct,it,mx,nx,(double *)lrx,(double *) lcx,1L)) \
					     { return 0;} 

#define FreePtr(lx) C2F(freeptr)((double *) lx)


#define GetType(n)   (c_local = n +Top - Rhs , C2F(gettype)(&c_local))

#define GetRhsVar(n,ct,mx,nx,lx) if (! C2F(getrhsvar)((c_local=n,&c_local),ct,mx,nx,lx,1L))\
        { return 0;  }

#define CreateVar(n,ct,mx,nx,lx) if(! C2F(createvar)((c_local=n,&c_local),ct,mx,nx,lx, 1L))\
        { return 0;  }

#define GetRhsCVar(n,ct,it,mx,nx,lrx,lcx) if (! C2F(getrhscvar)((c_local=n,&c_local),ct,it,mx,nx,lrx,lcx,1L))\
        { return 0;  }

#define CreateCVar(n,ct,it,mx,nx,lrx,lcx) if(! C2F(createcvar)((c_local=n,&c_local),ct,it,mx,nx,lrx,lcx, 1L))\
        { return 0;  }


#define Error(x) C2F(error)((c_local=x,&c_local))

#define PutLhsVar()  if (! C2F(putlhsvar)()) {	return 0; }

#define ReadMatrix(ct,mx,nx,w)  if (! C2F(creadmat)(ct,mx,nx,w,strlen(ct) )) {	return 0; }

#define WriteMatrix(ct,mx,nx,w)  if (! C2F(cwritemat)(ct,mx,nx,w,strlen(ct) )) {	return 0; }


#define ReadString(ct,mx,w)  if (! C2F(creadchain)(ct,mx,w,strlen(ct) )) {	return 0; }

#define WriteString(ct,mx,w)  if (! C2F(cwritechain)(ct,mx,w,strlen(ct),strlen(w) )) {	return 0; }

#define GetMatrixptr(ct,mx,nx,lx)  if (! C2F(cmatptr)(ct,mx,nx,lx,strlen(ct) )) {	return 0; }

#define CreateVarFrom(n,ct,mx,nx,lx,lx1) if (!C2F(createvarfrom)((c_local=n,&c_local),ct,mx,nx,(double *)lx,& lx1,1L))  { return 0;} 


#define Createlist(m,n) C2F(createlist)((c_local=m,&c_local),(c1_local=n,&c1_local))

#define CreateListVar(n,m,ct,mx,nx,lx,lx1) if (!C2F(createlistvar)((c_local=n,&c_local),(c1_local=m,&c1_local),ct,mx,nx,(double *)lx,& lx1,1L))  { return 0;} 

#define  GetListRhsVar(n,m,ct,m1e1,n1e1,l1e1,la1e1)  if(!C2F(getlistrhsvar)((c_local=n,&c_local),(c1_local=m,&c1_local),ct,m1e1,n1e1,l1e1,la1e1)) {return 0;}

#define Top C2F(vstk).top
#define Fin C2F(com).fin
#define Rhs C2F(com).rhs
#define Lhs C2F(com).lhs
#define Bot C2F(vstk).bot
#define Err C2F(iop).err
#define stk(x)  ( C2F(stack).Stk + x-1 )
#define istk(x) (((int *) C2F(stack).Stk) + x-1 )
#define sstk(x) (((float *) C2F(stack).Stk) + x-1 )
#define cstk(x) (((char *) C2F(stack).Stk) + x-1 )

/* 
#define CheckRhs(minrhs,maxrhs)  \
  if (! ( Rhs >= minrhs && Rhs <= maxrhs)) { \
    sciprint("%s: wrong number of rhs arguments\r\n",fname); \
    Error(999); \
    return 0;\
  }
*/

#define CheckRhs(minrhs,maxrhs)  \
  if (! C2F(checkrhs)(fname,(c_local = minrhs,&c_local),(c1_local=maxrhs,&c1_local),\
		      strlen(fname))) { \
      return 0;\
  }

/**
#define   CheckLhs(minlhs,maxlhs)  \
  if (! ( Lhs >= minlhs && Lhs <= maxlhs)) { \
    sciprint("%s: wrong number of lhs arguments \r\n",fname); \
    Error(999); \
    return 0; \
  }
**/

#define CheckLhs(minlhs,maxlhs)  \
  if (! C2F(checklhs)(fname,(c_local = minlhs,&c_local),(c1_local=maxlhs,&c1_local),\
		      strlen(fname))) { \
      return 0;\
  }

/** Used for calling a scilab function by its name  **/

#define SciString(ibegin,name,mlhs,mrhs) \
    if( ! C2F(scistring)(ibegin,name,mlhs,mrhs,strlen(name))) return 0;

/** Used for calling a scilab function given as argument **/

#define SciFunction(ibegin,lf,mlhs,mrhs) \
    if( ! C2F(scifunction)(ibegin,lf,mlhs,mrhs)) return 0;


/** used for protecting a call to a Scilab function **/

#define PExecSciFunction(n,mx,nx,lx,name,fsqpenv) \
  if(! C2F(scifunction)((c_local=n,&c_local),mx,nx,lx))\
{ sciprint("Error in function %s\r\n",name);  longjmp(fsqpenv,-1); }

#define Nbvars C2F(intersci).nbvars 

#define LhsVar(x) C2F(intersci).lhsvar[x-1]

#if defined(__STDC__)
typedef int (*interfun)(char *);
#else
typedef int (*interfun)();
#endif

typedef struct tagTabF { 
  interfun f;
  char *name;
} TabF;



#endif /*  STACK_SCI  */


