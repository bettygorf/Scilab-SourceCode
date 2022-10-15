/* Copyright INRIA */
#include "../../routines/stack-c.h"

/** external functions to be called through this interface **/

extern int f _PARAMS((double *, int *,int *,double *, int *,int *,int *));

/**************************************************
 * An example of an hand written interface 
 **************************************************/

int intexopt(fname)
  char* fname;
{ 
  char name[nlgh];
  int l1,m1,n1,ierr=0,k,mo1,no1,lo1,v1pos,v1ok=0,mo2,no2,lo2,v2pos,v2ok=0;
  int minrhs = 1,maxrhs = 1,minlhs=1,maxlhs=3,nopt=0,iopos;
  Nbvars = 0;
  nopt = NumOpt();
  CheckRhs(minrhs,maxrhs+nopt) ;
  CheckLhs(minlhs,maxlhs) ;
  /** first non optional argument **/
  GetRhsVar( 1, "c", &m1, &n1, &l1);
  for ( k = Rhs - nopt + 1; k <= Rhs ;k++)
    {
      if ( IsOpt(k,name) == 0  ) 
	{
	  sciprint("%s optional arguments name=val must be at the end\r\n",fname); 
	  Error(999); return(0);
	}
      else  if ( strncmp(name,"v1",2)==0 ) 
	{
	  GetRhsVar(k, "d", &mo1, &no1, &lo1);
	  v1ok=1 ;  v1pos=k;
	}
      else  if ( strncmp(name,"v2",2)==0 ) 
	{
	  GetRhsVar(k, "d", &mo2, &no2, &lo2);
	  v2ok=1 ;  v2pos=k;
	}
      else 
	{
	  sciprint("%s unrecognized optional arguments %s\r\n",fname,name);
	  Error(999); return(0);
	}
    }
  /** default values if optional arguments are not given :  v1=[99] and v2=[3] **/
  iopos=Rhs ;
  if ( v1ok == 0) {
    mo1=1; no1=1; v1pos = iopos =  iopos + 1; 
    CreateVar(iopos, "d", &mo1, &no1, &lo1);
    *stk(lo1)=99.0;
  }
  if ( v2ok == 0) {
    mo2=1; no2=1; v2pos = iopos =  iopos + 1; 
    CreateVar(iopos, "d", &mo2, &no2, &lo2);
    *stk(lo2)=3;
  }
  f(stk(lo1),&mo1,&no1,stk(lo2),&mo2,&no2,&ierr);
  if (ierr > 0) 
    {
      sciprint("%s Internal Error\r\n",fname);
      Error(999);
      return 0;
    }
  /** return the first argument (unchanged ) then v1 and v2 **/
  LhsVar(1) = 1;
  LhsVar(2) = v1pos;
  LhsVar(3) = v2pos;
  PutLhsVar();
  return 0;
}


static TabF Tab[]={ 
  {intexopt, "funcf1"},
};

int C2F(testcentry)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name);
  return 0;
}

