/* Common Block Declarations */

#include "graphics/Math.h"

/* typedef int integer ; */

#define csiz 63  
#define bsiz 4096  
#define isiz 1024
#define psiz 256  
#define nsiz 6  
#define lsiz 8192 
#define nlgh nsiz*4  
#define vsiz 2 
#define interscisize 30

struct {
    double Stk[vsiz];
} C2F(stack);


struct {
    int bot, top, idstk[nsiz*isiz], lstk[isiz], leps, 
	    bbot, bot0, infstk[isiz];
} C2F(vstk);

#define top C2F(vstk).top

struct {
    int ids[nsiz*psiz], pstk[psiz], rstk[psiz], pt, niv, 
	    macr, paus, icall;
} C2F(recu);

struct {
    int ddt, err, lct[8], lin[lsiz], lpt[6], hio, rio, wio, rte, wte;
} C2F(iop);

struct {
    int err1, err2, errct, toperr;
} C2F(errgst);

struct {
    int sym, syn[nsiz], char1, fin, fun, lhs, rhs, ran[2], comp[3];
} C2F(com);


struct {
    int lbot, ie, is, ipal, nbarg, ladr[30];
} C2F(adre);



struct {
    int nbvars, nbrows[interscisize], nbcols[interscisize], 
      ntypes[interscisize], lad[interscisize], lhsvar[interscisize];
} C2F(intersci);


/*********************************
 * to simplify interface design 
 *********************************/

static int c_local;
extern int C2F(error) _PARAMS((int *));
extern int C2F(getrhsvar) _PARAMS((integer *, char *type__, integer *, integer *, integer *, unsigned long));
extern int C2F(createvar) _PARAMS((integer *, char *, integer *, integer *, integer *, unsigned long ));
extern int C2F(putlhsvar) _PARAMS((void));
extern int C2F(cmatptr) _PARAMS((char *,integer *,integer *,integer *,unsigned long));
extern int C2F(createvarfromptr) _PARAMS((integer *,char *, integer *, integer *,double *, unsigned long));

#define CreateVarFromPtr(n,ct,mx,nx,lx) if ( ! C2F(createvarfromptr)((c_local=n,&c_local),ct,mx,nx,(double *)lx,1L)) \
					     { return 0;} 

#define GetRhsVar(n,ct,mx,nx,lx) if (! C2F(getrhsvar)((c_local=n,&c_local),ct,mx,nx,lx,1L))\
        { return 0;  }

#define CreateVar(n,ct,mx,nx,lx) if(! C2F(createvar)((c_local=n,&c_local),ct,mx,nx,lx, 1L))\
        { return 0;  }

#define Error(x) C2F(error)((c_local=x,&c_local))

#define PutLhsVar()  if (! C2F(putlhsvar)()) {	return 0; }

#define ReadMatrix(ct,mx,nx,w)  if (! C2F(creadmat)(ct,mx,nx,w,strlen(ct) )) {	return 0; }
#define ReadString(ct,mx,w)  if (! C2F(creadchain)(ct,mx,w,strlen(ct) )) {	return 0; }
#define GetMatrixptr(ct,mx,nx,lx)  if (! C2F(cmatptr)(ct,mx,nx,lx,strlen(ct) )) {	return 0; }

#define Fin C2F(com).fin
#define Rhs C2F(com).rhs
#define Lhs C2F(com).lhs
#define stk(x)  ( C2F(stack).Stk + x-1 )
#define istk(x) (((int *) C2F(stack).Stk) + x-1 )
#define sstk(x) (((float *) C2F(stack).Stk) + x-1 )
#define cstk(x) (((char *) C2F(stack).Stk) + x-1 )

#define CheckRhs(minrhs,maxrhs)  \
  if (! ( Rhs >= minrhs && Rhs <= maxrhs)) { \
    sciprint("%s wrong number of rhs arguments in ",fname); \
    Error(999); \
    return 0;\
  }

#define   CheckLhs(minlhs,maxlhs)  \
  if (! ( Lhs >= minlhs && Lhs <= maxlhs)) { \
    sciprint("%s wrong number of lhs arguments in ",fname); \
    Error(999); \
    return 0; \
  }

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





