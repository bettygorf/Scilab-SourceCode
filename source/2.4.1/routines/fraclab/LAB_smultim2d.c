/* This Software is ( Copyright INRIA . 1998  1 )                    */
/*                                                                   */
/* INRIA  holds all the ownership rights on the Software.            */
/* The scientific community is asked to use the SOFTWARE             */
/* in order to test and evaluate it.                                 */
/*                                                                   */
/* INRIA freely grants the right to use modify the Software,         */
/* integrate it in another Software.                                 */
/* Any use or reproduction of this Software to obtain profit or      */
/* for commercial ends being subject to obtaining the prior express  */
/* authorization of INRIA.                                           */
/*                                                                   */
/* INRIA authorizes any reproduction of this Software.               */
/*                                                                   */
/*    - in limits defined in clauses 9 and 10 of the Berne           */
/*    agreement for the protection of literary and artistic works    */
/*    respectively specify in their paragraphs 2 and 3 authorizing   */
/*    only the reproduction and quoting of works on the condition    */
/*    that :                                                         */
/*                                                                   */
/*    - "this reproduction does not adversely affect the normal      */
/*    exploitation of the work or cause any unjustified prejudice    */
/*    to the legitimate interests of the author".                    */
/*                                                                   */
/*    - that the quotations given by way of illustration and/or      */
/*    tuition conform to the proper uses and that it mentions        */
/*    the source and name of the author if this name features        */
/*    in the source",                                                */
/*                                                                   */
/*    - under the condition that this file is included with          */
/*    any reproduction.                                              */
/*                                                                   */
/* Any commercial use made without obtaining the prior express       */
/* agreement of INRIA would therefore constitute a fraudulent        */
/* imitation.                                                        */
/*                                                                   */
/* The Software beeing currently developed, INRIA is assuming no     */
/* liability, and should not be responsible, in any manner or any    */
/* case, for any direct or indirect dammages sustained by the user.  */
/*                                                                   */
/* Any user of the software shall notify at INRIA any comments       */
/* concerning the use of the Sofware (e-mail : FracLab@inria.fr)     */
/*                                                                   */
/* This file is part of FracLab, a Fractal Analysis Software         */

/* Christophe Canus 1997 */

#include "C-LAB_Interf.h"
#include "MFAS_multinomial.h"
#include "MFAS_lognormal.h"

/************  LAB_smultim2d  ********************************************/

void LAB_smultim2d()
{
  register k=0,i=0,j=0;                                         /* index */ 
  short bx=0;                                                   /* basex */
  short by=0;                                                   /* basey */
  char *str=NULL;                                              /* string */ 
  short n=0;                                               /* resolution */
  double sigma=0.;                                 /* standard-deviation */  
  double epsilon=0.;                    /* perturbation around weight .5 */  
  double *mu_n=NULL;                                      /* multinomial */
  int bx_pow_n=0;                                       /* # of bx-adics */
  int by_pow_n=0;                                       /* # of by-adics */
  double *I_nx=NULL;                                         /* bx-adics */
  double *I_ny=NULL;                                         /* by-adics */

  Matrix *Mbx;     /* matrix pointing on the basex                       */
  Matrix *Mby;     /* matrix pointing on the basey                       */  
  Matrix *Mstr;    /* matrix pointing on the string                      */
  Matrix *Mn;      /* matrix pointing on the resolution                  */
  Matrix *Msigma;  /* matrix pointing on the standard-deviation          */  
  Matrix *Mepsilon;/* matrix pointing on the perturbation around weight .5 */  
  Matrix *Mmu_n;   /* matrix pointing on the multinomial                 */
  Matrix *MI_nx;   /* matrix pointing on the bx-adics                    */ 
  Matrix *MI_ny;   /* matrix pointing on the by-adics                    */

  /* Check the input arguments # */
  if(Interf.NbParamIn<4) 
  {
    InterfError("smultim2d: You must give at least 4 input arguments\n");
    return;
  } 
  if(Interf.NbParamIn>5) 
  {
    InterfError("multim2d: You must give at most 5 input arguments\n");
    return;
  }

  /* Check the output arguments # */  
  if(Interf.NbParamOut<1)
  {
    InterfError("smultim2d: You must give at least 1 output argument\n");
    return;
  }  
  if(Interf.NbParamOut>3)
  {
    InterfError("smultim2d: You must give at most 3 output arguments\n");
    return;
  }
  
 /* Get the input base bx and verify it */
  Mbx=Interf.Param[0];
  if(!MatrixIsNumeric(Mbx))
  {
    InterfError("smultim2d: The base: bx must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsScalar(Mbx))
  {
    InterfError("smultim2d: The base: bx must be a scalar\n");
    return;
  }

  /* Get the input argument */ 
  bx=(short)MatrixGetScalar(Mbx);

  /* Get the input base by and verify it */
  Mby=Interf.Param[1];
  if(!MatrixIsNumeric(Mbx))
  {
    InterfError("smultim2d: The base: by must be a numeric matrix\n");
    return;
  } 
  if(!MatrixIsScalar(Mby))
  {
    InterfError("smultim2d: The base: by must be a scalar\n");
    return;
  }

  /* Get the input argument */ 
  by=(short)MatrixGetScalar(Mby);

  /* Get the input string: str and verify it */
  Mstr=Interf.Param[2];
  if(!MatrixIsString(Mstr))
  {
    InterfError("smultim2d: The string: str must be a string\n");
    return;
  }

  /* Get the input argument */
  str=MatrixReadString(Mstr);

  /* test on str */
  if((strcmp(str,"unifmeas")==0)||(strcmp(str,"unifcdf")==0)||(strcmp(str,"unifpdf")==0)||(strcmp(str,"lognmeas")==0)||(strcmp(str,"logncdf")==0)||(strcmp(str,"lognpdf")==0))
  { 
    /* Get the input resolution: n and verify it */
    Mn=Interf.Param[3];
    if(!MatrixIsNumeric(Mn))
    {
      InterfError("smultim2d: The resolution: n must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsScalar(Mn))
    {
      InterfError("smultim2d: The resolution: n must be a scalar\n");
      return;
    }

    /* Get the input argument */ 
    n=(int)MatrixGetScalar(Mn);

    /* Create the output Matrix */  
    bx_pow_n=(int)pow((double)bx,(double)n); 
    by_pow_n=(int)pow((double)by,(double)n);
    Mmu_n=MatrixCreate(bx_pow_n,by_pow_n,"real");

    if(Interf.NbParamOut==3)  
    {   
      MI_nx=MatrixCreate(1,bx_pow_n,"real");
      MI_ny=MatrixCreate(1,by_pow_n,"real");
    }
  
    /* Get the pointer on the output Matrix */  
    mu_n=MatrixGetPr(Mmu_n);
  
    if(Interf.NbParamOut==3) 
    {
      I_nx=MatrixGetPr(MI_nx);
      I_ny=MatrixGetPr(MI_ny);
    }

    if((strcmp(str,"unifmeas")==0)||(strcmp(str,"unifcdf")==0)||(strcmp(str,"unifpdf")==0))
    {
      if(Interf.NbParamIn==5) 
      {
	/* Get the input precision around .5 epsilon and verify it */
	Mepsilon=Interf.Param[4];
	if(!MatrixIsNumeric(Mepsilon))
	{
	  InterfError("smultim2d: The perturbation around weight .5: epsilon must be a numeric matrix\n");
	  return;
	}
	if(!MatrixIsReal(Mepsilon))
	{
	  InterfError("smultim2d: The perturbation around weight .5: epsilon must be a real matrix\n");
	  return;
	}
	if(!MatrixIsScalar(Mepsilon))
	{
	  InterfError("smultim2d: The perturbation around weight .5: epsilon must be a scalar\n");
	  return;
	}
  
	/* Get the input argument */
	epsilon=(double)MatrixGetScalar(Mepsilon);

	/* Check the value of the input argument */
	if((epsilon<0.)||(epsilon>=.5))
	{
	  InterfError("smultim2d: The perturbation around weight .5: epsilon must be >= 0. and < .5\n");
	  return;
	}
      }

      /* Call of the C function */
      if(MFAS_umm2d(n,bx,by,epsilon,mu_n)==0) 
      { 
	InterfError("smultim2d: Call of the C function MFAS_umm2d failed\n"); 
	return;
      }     
    }
    else if((strcmp(str,"lognmeas")==0)||(strcmp(str,"logncdf")==0)||(strcmp(str,"lognpdf")==0))
    {  
      /* Check the input arguments # */
      if(Interf.NbParamIn!=5) 
      {
	InterfError("smultim2d: You must give 5 input arguments\n");
	return;
      }

      /* Get the input standard-deviation and verify it */
      Msigma=Interf.Param[4];
      if(!MatrixIsNumeric(Msigma))
      {
	InterfError("smultim2d: The standard-deviation: sigma must be a numeric matrix\n");
	return;
      } 
      if(!MatrixIsReal(Msigma))
      {
	InterfError("smultim2d: The standard-deviation: sigma must be a real matrix\n");
	return;
      }
      if(!MatrixIsScalar(Msigma))
      {
	InterfError("smultim2d: The standard-deviation: sigma must be a scalar\n");
	return;
      }

      /* Get the input argument */ 
      sigma=(double)MatrixGetScalar(Msigma);

      /* Call of the C routine */
      if(MFAS_lnm2d(n,bx,by,1./(bx*by),sigma*sigma,mu_n)==0) 
      { 
	InterfError("smultim2d: Call of the C routine MFAS_lnm2d failed\n"); 
	return;
      }
    }

    /* test on str */
    if((strcmp(str,"unifcdf")==0)||(strcmp(str,"logncdf")==0))
    { 
      double sum_mu_n_i=0.;
      for(i=1;i<bx_pow_n;i++)
	*(mu_n+i)+=*(mu_n+i-1); 
      for(j=1;j<by_pow_n;j++)
      {
	sum_mu_n_i=*(mu_n+j*bx_pow_n);
	for(i=1;i<bx_pow_n;i++)
	{   
	  sum_mu_n_i+=*(mu_n+j*bx_pow_n+i);
	  *(mu_n+j*bx_pow_n+i)=sum_mu_n_i+*(mu_n+(j-1)*bx_pow_n+i); 
	}
	sum_mu_n_i=0.;
      }  
      for(j=1;j<by_pow_n;j++)
	*(mu_n+j*bx_pow_n)+=*(mu_n+(j-1)*bx_pow_n);
    }

    /* test on str */
    if((strcmp(str,"unifpdf")==0)||(strcmp(str,"lognpdf")==0))
      for(k=0;k<bx_pow_n*by_pow_n;k++)
	*(mu_n+k)=*(mu_n+k)*(double)bx_pow_n*by_pow_n;

    if(Interf.NbParamOut==3)
    {   
      for(i=0;i<bx_pow_n;i++)
	*(I_nx+i)=(double)i/(double)bx_pow_n;
      for(j=0;j<by_pow_n;j++)
	*(I_ny+j)=(double)j/(double)by_pow_n;
    }
 
    /* Transpose output argument */
    MatrixTranspose(Mmu_n);

    /* Return the output arguments */
    ReturnParam(Mmu_n);
    if(Interf.NbParamOut==3)
    { 
      ReturnParam(MI_nx);
      ReturnParam(MI_ny);
    } 
  }
  else
  {
    InterfError("smultim2d: The string: str is not valid\n");
    return;
  }
}
