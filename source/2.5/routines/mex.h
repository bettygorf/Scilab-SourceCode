#ifndef SCI_MEX 
#define SCI_MEX 

#include "stack-c.h"

typedef int Matrix;
typedef unsigned long int vraiptrst;
typedef int mxArray;

typedef int (*GatefuncH) _PARAMS((int nlhs,Matrix *plhs[],int nrhs,
                                 Matrix *prhs[]));

typedef int (*FGatefuncH) _PARAMS((int *nlhs,Matrix *plhs[],int *nrhs,
                                 Matrix *prhs[]));

typedef int Gatefunc _PARAMS((int nlhs,Matrix *plhs[],int nrhs,
                                 Matrix *prhs[]));
typedef int (*GatefuncS) _PARAMS((char *fname, int l));
typedef int (*Myinterfun) _PARAMS((char *, GatefuncH F));

typedef struct table_struct {
  Myinterfun f;    /** interface **/
  GatefuncH F;     /** function **/
  char *name;      /** its name **/
} GenericTable;

double *mxGetPr _PARAMS((Matrix *ptr));
double *mxGetPi _PARAMS((Matrix *ptr));
int mxGetM _PARAMS((Matrix *ptr));
int mxSetM _PARAMS((Matrix *ptr, int n));
int mxGetN _PARAMS((Matrix *ptr));
int mxSetN _PARAMS((Matrix *ptr, int n));
int mxGetElementSize _PARAMS((Matrix *ptr));
int mxIsString _PARAMS((Matrix *ptr));
int mxIsNumeric _PARAMS((Matrix *ptr));
int mxIsFull _PARAMS((Matrix *ptr));
int mxIsDouble _PARAMS((Matrix *ptr));
int mxIsSparse _PARAMS((Matrix *ptr));
int mxIsComplex _PARAMS((Matrix *ptr));
double mxGetScalar _PARAMS((Matrix *ptr));
void mexErrMsgTxt _PARAMS((char *error_msg));
Matrix *mxCreateFull _PARAMS((int m, int n, int it));
Matrix *mxCreateSparse _PARAMS((int m, int n, int nnz, int it));
void *mxCalloc _PARAMS((unsigned int n, unsigned int size));
int mxGetString _PARAMS((Matrix *ptr, char *str, int strl )); 
void mxFreeMatrix _PARAMS((Matrix *ptr));
Matrix  *mxCreateString _PARAMS((char *string));
Matrix  *mxCreateCharMatrixFromStrings _PARAMS((int m, char **str));
void mexprint _PARAMS((char* fmt,...));
int *mxGetIr _PARAMS((Matrix *ptr));
int *mxGetJc _PARAMS((Matrix *ptr));

mxArray *mexGetArray _PARAMS((char *name, char *workspace));

vraiptrst C2F(locptr) _PARAMS((void *x));
extern int C2F(putlhsvar) _PARAMS((void));
extern void errjump _PARAMS((void));

extern int C2F(getrhsvar) _PARAMS((integer *, char *, integer *, integer *, integer *, long unsigned int));

extern int C2F(getrhscvar) _PARAMS((integer *, char *, integer*, integer *, integer *, integer *, integer *, long unsigned int));

extern int C2F(createcvar) _PARAMS(());
extern int C2F(createstkptr) _PARAMS((integer *m, vraiptrst *ptr));

extern int C2F(initmex) _PARAMS((integer *nlhs,Matrix *plhs[],integer *nrhs,Matrix *prhs[]));
extern int C2F(endmex)  _PARAMS((integer *nlhs,Matrix *plhs[],integer *nrhs,Matrix *prhs[]));
extern int C2F(createptr) _PARAMS((char *type,integer * m,integer * n, integer *it,integer * lr,integer *ptr, long int type_len));
extern vraiptrst C2F(locptr) _PARAMS(( void *x));
extern void sciprint _PARAMS((char *fmt,...));

int sci_gateway _PARAMS((char *fname, GatefuncS F));
int mex_gateway _PARAMS((char *fname, GatefuncH F));
int fortran_mex_gateway _PARAMS((char *fname, FGatefuncH F));

#define FALSE_ (0)
#define TRUE_ (1)
#define REAL 0
#define COMPLEX 1
#define mxREAL 0
#define mxCOMPLEX 1

#ifndef NULL
#define NULL 0
#endif

#define mxCreateDoubleMatrix mxCreateFull
#define bool int
#define mexCallMATLAB mexCallSCILAB
#define mexGetMatrixPtr(name) mexGetArrayPtr(name, "caller")
/** XXXX A finir **/
#define mexGetArrayPtr(name,type) mexGetArray(name,type) 
#define mexPrintf sciprint

/** Put a matrix in Scilab Workspace */ 

#define mexPutFull(name,m,n,ptrM,tag) \
  if ( ! C2F(cwritemat)(name,m,n,ptrM,strlen(name))) {	\
      mexErrMsgTxt("mexPutFull failed\r\n");return; }

#endif SCI_MEX 
