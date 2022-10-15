#include "../mex.h"
#include <string.h>
#include <stdio.h>
#include <malloc.h>

extern void cerro _PARAMS((char *str));
extern int C2F(dcopy) _PARAMS((int*, double *, int *, double *, int *));
extern int C2F(xscion)  _PARAMS((int *i));
extern void C2F (xscisncr) _PARAMS((char *str, integer *n, integer dummy)); 
extern int C2F(vcopyobj) _PARAMS((char *, int*, int *, integer dummy));
extern int C2F(in2str) _PARAMS((integer *n, integer *line, char *str, int str_len));
extern int C2F(cresmat2) _PARAMS((char *fname, int *lw, int *nchar, int *lr, int fname_len));
extern int  C2F(mxgetm) _PARAMS((    Matrix *ptr));
extern int  C2F(mxgetn) _PARAMS((    Matrix *ptr));
extern int C2F(cvstr) _PARAMS((int *n, int *line, char *str, int *job, int str_len));
extern void C2F(xscisrn) _PARAMS((char *str,int *n,int  dummy));
extern int  C2F(erro)  _PARAMS((char *str,int dummy));
extern int C2F(scistring) _PARAMS((integer *ifirst,char * thestring,integer * mlhs,integer *mrhs,int thestring_len));

vraiptrst  stkptr(ptr_lstk)
     Matrix *ptr_lstk;
{
  vraiptrst ptr;
  ptr = C2F(locptr)(stk((int)(ptr_lstk))); 
  return ptr;
}


/****************************************************
 * C function for C mexfunctions 
 ****************************************************/


double *mxGetPr(ptr)
     Matrix *ptr;
{
  double *loc = (double *) stkptr(ptr);
  int *loci = (int *) stkptr(ptr);
  if (loci[0]==1) {
    /* full: loci[0]=1 loci[1]=M loci[2]=N loci[3]=complexflag */
  return &loc[2];
  }
  else if ( loci[0]==7 ) { 
    /* sparse: nnz = loci[4];  N = loci[2];  */
    return &loc[(5+loci[2]+loci[4])/2 + 1];
    }
  else {
    return 0;
  }
}


double *mxGetPi(ptr)
     Matrix *ptr;
{  
  double *loc = (double *) stkptr(ptr);
  int *loci = (int *) stkptr(ptr);
   if (loci[0]==1) {
     /*  full: M = mxGetM(ptr)=loci[1]; N = mxGetN(ptr)= loci[2]; */
     return &loc[2 + loci[1] * loci[2]];
   }
   else if ( loci[0]==7 ) {
    /* sparse: nnz = loci[4];  N = loci[2];  M=loci[1]*/
    return &loc[(5+loci[2]+loci[4])/2 + 1 + loci[1]*loci[2]];
   }
   else {
     return 0;
   }
}

int mxGetM(ptr)
     Matrix *ptr;
{
  int *loc= (int *) stkptr(ptr);
  return loc[1];
}

int mxSetM(ptr,m)
     Matrix *ptr; int m;
{
  int *loci = (int *) stkptr(ptr);
  int oldM; int commonlength; int j;
  if ((loci[0]==1) | (loci[0]==7)) {
  loci[1]=m; return 1;
  }
  /* string: copy loci[5+oldM] to loci[5+mnew]  */
  if (loci[0]==10) {
    oldM=loci[1];
    commonlength=loci[5]-loci[4];
    for (j=0; j<=m*commonlength; ++j) {
      loci[5+j+m]=loci[5+j+oldM];
      }
    loci[1]=m;
  }
}

int *mxGetJc(ptr)
     Matrix *ptr;
{
  int *loc= (int *) stkptr(ptr);
  if (loc[0] != 7) {
  return 0;}
  /*  loc[0]=7;  M=loc[1];  N=loc[2];  it =loc[3];  nzmax=loc[4];
      Jc[0]=loc[5];  Jc[1]=loc[6]; etc; Jc[N]=nnz; */
  return &loc[5];
}

int *mxGetIr(ptr)
     Matrix *ptr;
{
  int *loc= (int *) stkptr(ptr);
  /* ... N=loc[2],  nzmax=loc[4]; then Jc,  then Ir   */
  return &loc[5+loc[2]+1];
}


int mxGetN(ptr)
     Matrix *ptr;
{
  int *loci = (int *) stkptr(ptr);
  if (loci[0] == 10)
    /*  for strings, N=length of first (and unique, loci[2]=1) column 
        (all rows have same Matlab-length) */
    return loci[5]-loci[4];
  else return loci[2] ;
}

int mxSetN(ptr,n)
     Matrix *ptr; int n; 
{
  int *loci = (int *) stkptr(ptr);
  int i,m;
  if ( loci[0] == 10) {
    /*  string */
    m=loci[1];
    /* oldN = loci[5]-loci[4];  */
    for (i=0; i<m; ++i) {
      loci[5+i]=loci[4+i]+n;
      /* to be done: compress loci[5+m]  */
    }}
  else loci[2]=n;
  return 0;
}

int mxIsString(ptr)
     Matrix *ptr;
{
  int *loci=(int *) stkptr(ptr);
  if (loci[0] == 10) 
    return 1;
  else return 0;
} 

int mxIsNumeric(ptr)
     Matrix *ptr;
{
  int *loci = (int *) stkptr(ptr);
  if ( (loci[0] == 1) | (loci[0] == 7) ) 
    return 1;
  else 
    return 0;
}

int mxIsDouble(ptr)
     Matrix *ptr;
{
  int *loci = (int *) stkptr(ptr);
  if ( (loci[0] == 1) | (loci[0] == 7) ) 
    return 1;
  else 
    return 0;
}

int mxIsFull(ptr)
     Matrix *ptr;
{
  int *loci = (int *) stkptr(ptr);
  if ( loci[0] == 1)
    return 1;
  else
    return 0;
}

int mxIsSparse(ptr)
     Matrix *ptr;
{
  int *loci = (int *) stkptr(ptr);
  if (loci[0] == 7) 
    return 1;
  else
    return 0;
}

int mxIsComplex(ptr)
     Matrix *ptr;
{
  int *loci = (int *) stkptr(ptr);
  if (loci[3] == 1) {
    return 1;
  }
  return 0;
}

double mxGetScalar(ptr)
     Matrix *ptr;
{ double *loc = (double *) stkptr(ptr);
  int *loci = (int *) stkptr(ptr);
  if (loci[0] == 1) {
  return  loc[2];
  }
  else if (loci[0] == 7) {
    /* nnz = loci[4];    N = loci[2]; */
    return loc[(5+loci[2]+loci[4])/2+1];
  }
  else {
    return 0;
  }
}

void mexErrMsgTxt(error_msg)
     char *error_msg;
{
  cerro(error_msg);
  errjump();
}

Matrix *mxCreateFull(m, n, it)
     int m, n, it;
{
  static int lr1;
  int lrd;
  if (! C2F(createptr)("d", &m, &n, &it, &lr1, &lrd,1L)) {
    mexErrMsgTxt("No more memory available: increase stacksize");
    }
  return (Matrix *) lrd ;
}

void *mxCalloc(n, size)
     unsigned int n, size;
{
  int m;
  vraiptrst lrd;
  m = (n * size) /sizeof(double) + 1;
  if (! C2F(createstkptr)( &m, &lrd)) {
    return 0;
  }
  return (void *) lrd;
}

      
/***************************************************************
 * Return in str at most strl characters from first element of 
 * string Matrix pointed to by ptr ( ptr is assumed to be a String Matrix )
 **************************************************************/

int mxGetString(ptr,str,strl)
     Matrix *ptr;     int  strl;     char *str;
{
  int *loci = (int *) stkptr(ptr);
  int commonlength, firstchain; 
  int nrows = loci[1];
  /*  int ncols = loci[2]; This is 1 */
  commonlength=nrows*(loci[5]-loci[4]);
  firstchain=5+nrows;
  /* firstchain=  loci[3];  */
  C2F(in2str)(&commonlength, &loci[firstchain], str,0L);
  return 0;
}

void mxFreeMatrix(ptr)
     Matrix *ptr;
{
  /* Automatically freed when return from mexfunction */
  return ;
}

void mxFree(ptr)
     Matrix *ptr;
{
  /* No need to free */
  return ;
}

int mexAtExit(ptr)
     Matrix *ptr;
{
  /* To be done....*/
  return 0;
}

Matrix *mxCreateSparse(m,n,nzmax,cmplx)
int m, n, nzmax, cmplx;
{
  static int lw, iprov, first;
  Nbvars++;
  lw=Nbvars;
  iprov = lw + Top -Rhs;
  if( ! C2F(mspcreate)(&iprov, &m, &n, &nzmax, &cmplx)) {
    return (Matrix *) 0;
  }
  C2F(intersci).ntypes[lw-1]=36;
  /*  first=2* C2F(vstk).lstk[Top - Rhs + lw - 1]-1;
  *istk(first)=7;  *istk(first+1)=m;  *istk(first+2)=n;
  *istk(first+3)=cmplx;  *istk(first+4)=nzmax;
   start Jc 
   *istk(first+5)=0=J[0]; ... *istk(first+5+n+1)=nnz=Jc[n]
   start Ir
   *istk(first+5+n+2)=Ir[0] etc
   */
  return (Matrix *) C2F(vstk).lstk[Top - Rhs + lw - 1];
}

/***************************************************************
 * Create on Scilab Stack a 1x1 string matrix filled with string
 **************************************************************/


Matrix  *mxCreateString(string)
     char *string;
{
  static int i, lr1, lw, ilocal;
  i = strlen(string);
  Nbvars++;
  lw = Nbvars + Top -Rhs;
  if( ! C2F(cresmat2)("mxCreateString:", &lw, &i, &lr1, 15L)) {
    return (Matrix *) 0;
  }
  /*    Convert string to integer code    */
  C2F(cvstr)(&i, istk(lr1), string, (ilocal=0, &ilocal),i);
  /*    ichar($) = 36 : variable returned as is to scilab */
  C2F(intersci).ntypes[lw-1]=36;
  return (Matrix *) C2F(vstk).lstk[lw - 1];
}

#ifdef __STDC__
#include <stdarg.h>
#else
#include <varargs.h>
#endif 

/* 
  Print function which prints (format,args,....) 
  in Scilab window
*/


/*
#ifdef __STDC__ 
void  C2F(mexprintf)(char *fmt,...) 
#else 
void  C2F(mexprintf)(va_alist) va_dcl
#endif 
{
  int i;  integer lstr;  va_list ap;  char s_buf[1024];
#ifdef __STDC__
  va_start(ap,fmt);
#else
  char *fmt;
  va_start(ap);
  fmt = va_arg(ap, char *);
#endif
  C2F(xscion)(&i);
  if (i == 0) 
    {
      (void)  vfprintf(stdout, fmt, ap );
    }
  else 
    {
      (void ) vsprintf(s_buf, fmt, ap );
      lstr=strlen(s_buf);
      C2F(xscisrn)(s_buf,&lstr,0L);
    }
  va_end(ap);
}
*/


void mexWarnMsgTxt(error_msg)
     char *error_msg;
{
mexPrintf("Warning: ");
mexPrintf(error_msg);
mexPrintf("\n\n");
/*  mexPrintf(strcat("Warning: ",error_msg)); */
}
/****************************************************
 * C functions for Fortran  mexfunctions 
 ****************************************************/

double * C2F(mxgetpr)(ptr)
     Matrix *ptr;
{
  double *loc = (double *) stkptr(*ptr);
  int *loci = (int *) stkptr(*ptr);
  static int nnz,N;
  if (loci[0]==1) {
  return &loc[2];
  }
  else if ( loci[0]==7 ) { 
    nnz = loci[4];  N = loci[2];
    return &loc[(5+nnz+N)/2+1];
    }
  else {
    return 0;
  }
}


double * C2F(mxgetpi)(ptr)
     Matrix *ptr;
{
  double *loc = (double *) stkptr(*ptr);
  return &loc[2 +  C2F(mxgetm)(ptr) *  C2F(mxgetn)(ptr)];
}

int  C2F(mxgetm)(ptr)
     Matrix *ptr;
{
  int *loc= (int *) stkptr(*ptr);
  return loc[1] ;
}

int  C2F(mxgetn)(ptr)
     Matrix *ptr;
{
  int *loc = (int *) stkptr(*ptr);
  if ( loc[0] == 10) {
    return loc[5]-1;
  }
  return loc[2] ;
}

int  C2F(mxisstring)(ptr)
     Matrix *ptr;
{
  int *loc=(int *) stkptr(*ptr);
  if (loc[0] == 10) 
    return 1;
  else return 0;
} 

int  C2F(mxisnumeric)(ptr)
     Matrix *ptr;
{
  int *loc = (int *) stkptr(*ptr);
  if ( loc[0] == 1) 
    return 1;
  else 
    return 0;
}

int  C2F(mxisfull)(ptr)
     Matrix *ptr;
{
  int *loc = (int *) stkptr(*ptr);
  if ( loc[0] == 1) {
    return 1;
  }
  return 0;
}

int  C2F(mxissparse)(ptr)
     Matrix *ptr;
{
  int *loc = (int *) stkptr(*ptr);
  if (loc[0] == 7) {
    return 1;
  }
  return 0;
}


int  C2F(mxiscomplex)(ptr)
     Matrix *ptr;
{
  int *loc = (int *) stkptr(*ptr);
  if (loc[3] == 1) {
    return 1;
  }
  return 0;
}

double  C2F(mxgetscalar)(ptr)
     Matrix *ptr;
{ static int N,nnz;
  double *loc = (double *) stkptr(*ptr);
  int *loci = (int *) stkptr(*ptr);
  if (loci[0] == 1) {
  return  loc[2];
  }
  else if (loci[0] == 7) {
    nnz = loci[4];
    N = loci[2];
    return loc[(5+nnz+N)/2+1];
  }
  else {
    return 0;
  }
}

void  C2F(mexprintf)(error_msg,len) 
     char *error_msg;
     int len;
{
char * buf;
 if ((buf = (char *)malloc((unsigned)sizeof(char)*(len+1)))
     == NULL) {
   cerro("Running out of memory");
   return;
 }
buf[len]='\0';
strncpy(buf, error_msg, (size_t)len);
sciprint("%s\n\r",buf);
free(buf);
}

void C2F(mexerrmsgtxt)(error_msg,len)
     char *error_msg;
     int len;
{
  C2F(erro)(error_msg,len);
  errjump();
}

Matrix *C2F(mxcreatefull)(m, n, it)
     int *m, *n, *it;
{
  static int lr1;
  int lrd;
  if (! C2F(createptr)("d", m, n, it, &lr1, &lrd,1L)) {
    return  (Matrix *) 0;
  }
  return (Matrix *) lrd ;
} 


unsigned long int C2F(mxcalloc)(n, size)
     unsigned int *n, *size;
{
  int m;
  vraiptrst lrd;
  m = (*n * *size) /sizeof(double) + 1;
  if (! C2F(createstkptr)(&m, &lrd)) {
    return 0;
  }
  return (unsigned long int) lrd;
}

int  C2F(mxgetstring)(ptr,str,strl)
     Matrix *ptr;     int  *strl;     char *str;
{
  int *loc = (int *) stkptr(*ptr);
  int commonlength;  int nrows = loc[1];
  /*  int ncols = loc[2]; This is 1 */
  commonlength=nrows*(loc[5]-loc[4]);
  C2F(in2str)(&commonlength, &loc[5+nrows], str,0L);
   *strl = Min(*strl,commonlength);
  return 0;
}

void C2F(mxfreematrix)(ptr)
     Matrix *ptr;
{
  return ;
}


Matrix * C2F(mxcreatestring)(string,l)
     char *string;
     long int l;
{
  static int i, lr1, lw, iprov, ilocal; 
  /** i = strlen(string); **/
  i= l;
  Nbvars++;
  lw=Nbvars;
  iprov = lw + Top -Rhs;
  if( ! C2F(cresmat2)("mxCreateString:", &iprov, &i, &lr1, 15L)) {
    return (Matrix *) 0;
  }
  C2F(cvstr)(&i, istk(lr1), string, (ilocal=0, &ilocal),l);
  C2F(intersci).ntypes[lw-1]=36;
  return (Matrix *) C2F(vstk).lstk[Top -Rhs + lw - 1];
}


int C2F(mxcopyreal8toptr)(y,ptr,n)
     Matrix *ptr;     double y[];     integer *n;
{
  int one=1;
  double *loc = ((double *) *ptr); 
  C2F(dcopy)(n,y,&one,loc,&one);
  return 0;
}


int C2F(mxcopyptrtoreal8)(ptr,y,n)
     Matrix *ptr;     double y[];     integer *n;
{
  int one=1;
  double *loc = ((double *) *ptr); 
  C2F(dcopy)(n,loc,&one,y,&one);
  return 0;
}


/****************************************************
 * A set of common functions 
 ****************************************************/

/*    utility fct   */

vraiptrst C2F(locptr)(x)
     void *x;
{
  return((vraiptrst) x);
}

int C2F(createstkptr)(m, ptr)
     integer *m;
     vraiptrst *ptr;
{
  int lr, n=1, lw;
  Nbvars++;
  lw = Nbvars;
  if (! C2F(createvar)(&lw, "d", m, &n, &lr, 1L)) {
    return 0;
  }
  *ptr = C2F(locptr)(stk(lr));
  return 1;
} 

int C2F(createptr)(type, m, n, it, lr, ptr, type_len)
     char *type;
     int *m, *n, *it, *lr, *ptr;
     long int type_len;
{
    static int lc, lw;
    Nbvars++;
    lw = Nbvars;
    if (! C2F(createcvar)(&lw, type, it, m, n, lr, &lc, 1L)) {
      return 0;
    }
    *ptr = C2F(vstk).lstk[Top - Rhs + lw - 1];
    return 1;
} 

int C2F(endmex)(nlhs, plhs, nrhs, prhs)
     integer *nlhs,*nrhs;
     Matrix *plhs[];     Matrix *prhs[];
{
  int nv=Nbvars ,kk,k; 
  for (k = 1; k <= *nlhs; k++)
    {
      LhsVar(k) = 0;
      for (kk = 1; kk <= nv; kk++)
	{
	  if ((int) plhs[k-1] == C2F(vstk).lstk[Top - Rhs + kk -1]) 
	    {
	      LhsVar(k) = kk; 
	      break;
	    }
	}
    }
  C2F(putlhsvar)();
}

int C2F(initmex)(nlhs, plhs, nrhs, prhs)
     integer *nlhs,*nrhs;
     Matrix *plhs[];     Matrix *prhs[];
{
  static int k, itype, iwhere, lw,it;
  int *header; static int m, n, commonlength, line;
  if (Rhs==-1) Rhs++;
  Nbvars = 0;
  *nlhs = Lhs;  *nrhs = Rhs;
  for (k = 1; k <= *nlhs ; ++k) plhs[k-1]=0;
  for (k = 1; k <= *nrhs ; ++k) 
    {
      lw = k  + Top - Rhs;
      iwhere = 2*C2F(vstk).lstk[lw - 1]-1;
      itype = *istk(iwhere);
	if (itype == 1) {
/*     standard matrix */
	    it = *istk(iwhere + 3);
/*    it=0       real: */
/*    it=1       complex: */
	}
        else if (itype == 10) {
	  /*     string: */
	  if ( *istk(iwhere+2) != 1) mexErrMsgTxt("Invalid string matrix (at most one column!)");
	  m=*istk(iwhere+1);
	  commonlength=*istk(iwhere+5)-*istk(iwhere+4);
	  if (m > 1) {
	  for (line = 1; line < m; line++)
	    {
	      if (*istk(iwhere+5+line) - *istk(iwhere+4+line) != commonlength)
		  mexErrMsgTxt("Column length of string matrix must agree!");
	    }
	  }
	}
	else if (itype == 7) {
	  /*     matlab-like sparse  */
	  
	}
	else if (itype == 5) {
	  mexErrMsgTxt("Use mtlb_sparse(sparse( ))!");
	  /*   scilab sparse  should be matlabified  */
	  return 0;
	}
	else {
	  mexErrMsgTxt("Invalid input");
	  return 0;
	}
	C2F(intersci).ntypes[k-1]=36;
	prhs[k-1] = (Matrix *) C2F(vstk).lstk[lw - 1];
    }
  Nbvars = Rhs ;
  return 0;
} 


int mexCallSCILAB(nlhs, plhs, nrhs, prhs, name)
     int nlhs, nrhs;
     Matrix *prhs[];Matrix *plhs[];
     char *name;
{
  int ret_val;
  static int i1, i2;
  static int k, kk, nv, ifirst;
  ret_val = 0;
  nv = Nbvars;
  for (k = 1; k <= nrhs; ++k) {
    for (kk = 1; kk <= nv; ++kk) {
      if ((int) prhs[k-1] == C2F(vstk).lstk[Top - Rhs + kk - 1]) {
	goto L77;
      }
    }
  L77:
    if (kk == nv + 1) {
      mexErrMsgTxt("mexCallSCILAB: invalid pointer passed to called function"); 
      ret_val = 0;
      return ret_val;
    } else {
      ++Nbvars;
      i1 = Top - Rhs + kk;
      i2 = Top - Rhs + Nbvars;
      C2F(vcopyobj)("mexCallSCILAB", &i1, &i2, 13L);
    }
  }
  ifirst = Top - Rhs + nv + 1;
  i1 = nv + 1;
  if (! C2F(scistring)(&i1, name, &nlhs, &nrhs, strlen(name) )) {
    errjump();
    /*	      return 0;  */
  }
  for (k = 1; k <= nlhs; ++k) {
    plhs[k-1] = (Matrix *) C2F(vstk).lstk[ifirst + k - 2];
  }
  Nbvars=nv+nlhs;
  ret_val = 1;
  return ret_val;
  /* C2F(mexcallscilab)(&nlhs, plhs, &nrhs, prhs, name, strlen(name)); */ 
}


int C2F(mexcallscilab)(nlhs, plhs, nrhs, prhs, name, namelen)
     integer *nlhs,*nrhs;
     Matrix *plhs[];     Matrix *prhs[];
     char *name;     int namelen;
{
  return mexCallSCILAB(*nlhs, plhs, *nrhs, prhs, name);
}

/** generic mex interface **/

int mex_gateway(fname,F)
     char *fname;
     GatefuncH F;
{
  int nlhs,nrhs;
  Matrix * plhs[intersiz];  Matrix * prhs[intersiz];
  C2F(initmex)(&nlhs, plhs, &nrhs, prhs);
  (*F)(nlhs, plhs, nrhs, prhs);
  C2F(endmex)(&nlhs, plhs, &nrhs, prhs);
  return 0;
}

int fortran_mex_gateway(fname,F)
     char *fname;
     FGatefuncH F;
{
  int nlhs,nrhs;
  Matrix * plhs[intersiz];  Matrix * prhs[intersiz];
  C2F(initmex)(&nlhs, plhs, &nrhs, prhs);
  (*F)( &nlhs, plhs, &nrhs, prhs);
  C2F(endmex)(&nlhs, plhs, &nrhs, prhs);
  return 0;
}


/** generic scilab interface **/

int sci_gateway(fname,F)
     char *fname;
     GatefuncS F;
{
  (*F)(fname,strlen(fname));
  if (!C2F(putlhsvar)()) {return 0;}
  return 0;
}

int mxGetHeader(lw, header)
 /*  Utility fct returns header of variable # lw  */
     int lw; void **header;
{
  int iwhere;
  iwhere = 2*C2F(vstk).lstk[lw + Top - Rhs - 1] - 1;
  /*  *header = (int *) stkptr(ptr);   */
  *header = (void *) istk(iwhere);
}

int C2F(mxgetheader)(lw, header)
     int lw; void **header;
{
  int iwhere;
  iwhere = 2*C2F(vstk).lstk[lw + Top - Rhs - 1] - 1;
  /*  *header = (int *) stkptr(ptr);   */
  /* printf("%i\n",istk(iwhere)); */
  *header = (void *) istk(iwhere);
  /*  printf("header[0]=");
      printf("%i\n",header[0]); */
}

int mxGetHeader2(ptr, header)
 /*  Utility fct returns header of variable in ptr  */
     Matrix *ptr;void **header;
{
  *header = (void *) stkptr(ptr);
}

int C2F(mxgetheader2)(ptr, header)
     Matrix *ptr;     int **header;
{
  *header = (int *) stkptr(ptr);
}

int mxGetElementSize(ptr)
Matrix *ptr;
{
  int *loci = (int *) stkptr(ptr);
  if (loci[0]==1 | loci[0]==7) {
    return sizeof(double);
  }
  else if (loci[0]==10) {
    return sizeof(char);
  }
  else {
    mexErrMsgTxt("GetElementSize error");
    return 0;
  }  
}

Matrix *mxCreateCharMatrixFromStrings(m, str)
int m;
char **str;
{
  static int i, lr1, lw, ilocal, n, k,kk, nmax;
  nmax = strlen(str[0]);
  for (k=1; k<m; ++k) {
    n=strlen(str[k]);
    if (n > nmax) nmax=n;
  }
  Nbvars++;
  lw = Nbvars + Top -Rhs;
  /*      logical function cresmat3(fname,lw,m,n,nchar,lr) */
  if( ! C2F(cresmat4)("mxCreateString:", &lw, &m, &nmax, &lr1, 15L)) {
    return (Matrix *) 0;
  }
  /*    Convert string to integer code    */
  /*   subroutine cvstr(n,line,str,job) */
  for (k=0; k<m; ++k) {
  n=strlen(str[k]);
  /* fill with blanks (40) if n<nmax !!*/
  C2F(cvstr)(&n, istk(lr1), str[k], (ilocal=0, &ilocal),i);
  if (nmax>n) {
    for (kk=0; kk<nmax-n; ++kk) *istk(lr1+n+kk)=40;
  };
  lr1=lr1+nmax;
  }
  /*    ichar($) = 36 : variable returned as is to scilab */
  C2F(intersci).ntypes[lw-1]=36;
  return (Matrix *) C2F(vstk).lstk[lw - 1];

}

void mexEvalString(name)
     char *name;
{
  Matrix *ppr[1];Matrix *ppl[1];
  int ret_val;
  int nlhs;     int nrhs;
  ret_val = 0;
  *ppr = mxCreateString(name);
  nrhs=1;nlhs=0;
  mexCallSCILAB(nlhs, ppl, nrhs, ppr, "execstr");    
  return;
}

mxArray *mexGetArray(name, workspace)
char *name; char *workspace;
{
  int lw,l;
  C2F(objptr)(name,&lw,l);
  return (mxArray *) lw;
}





