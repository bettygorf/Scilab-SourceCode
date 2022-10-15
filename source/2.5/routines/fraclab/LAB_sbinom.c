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
#include "MFAS_binomial.h"
#include "MFAS_lognormal.h"

/************  LAB_sbinom  ***********************************************/

void LAB_sbinom()
{
  register k=0;                                                 /* index */ 
  char *str=NULL;                                              /* string */ 
  short n=0;                                               /* resolution */
  double sigma=0.;                                 /* standard-deviation */  
  double epsilon=0.;                    /* perturbation around weight .5 */  
  double *mu_n=NULL;                                         /* binomial */
  int two_pow_n=0;                                       /* # of dyadics */
  double *I_n=NULL;                                           /* dyadics */
  short N=0;                                   /* # of Hoelder exponents */ 
  double *alpha=NULL;                               /* Hoelder exponents */
  double *f_alpha=NULL;                           /* Hausdorff dimension */

  Matrix *Mstr;    /* matrix pointing on the string                      */
  Matrix *Mn;      /* matrix pointing on the resolution                  */
  Matrix *Msigma;  /* matrix pointing on the standard-deviation          */  
  Matrix *Mepsilon;/* matrix pointing on the perturbation around weight .5 */  
  Matrix *Mmu_n;   /* matrix pointing on the binomial                    */
  Matrix *MI_n;    /* matrix pointing on the dyadics                     */
  Matrix *MN;      /* matrix pointing on # of Hoelder exponents          */ 
  Matrix *Malpha;  /* matrix pointing on the Hoelder exponents           */
  Matrix *Mf_alpha;/* matrix pointing on the Hausdorff dimension         */ 

  /* Check the input arguments # */
  if(Interf.NbParamIn<2) 
  {
    InterfError("sbinom: You must give at least 2 input arguments\n");
    return;
  }
  if(Interf.NbParamIn>3) 
  {
    InterfError("sbinom: You must give at most 3 input arguments\n");
    return;
  }
  
  /* Check the output arguments # */  
  if(Interf.NbParamOut<1)
  {
    InterfError("sbinom: You must give at least 1 output argument\n");
    return;
  }  
  if(Interf.NbParamOut>2)
  {
    InterfError("sbinom: You must give at most 2 output arguments\n");
    return;
  }

  /* Get the input string: str and verify it */
  Mstr=Interf.Param[0];
  if(!MatrixIsString(Mstr))
  {
    InterfError("sbinom: The string: str must be a string\n");
    return;
  }

  /* Get the input argument */
  str=MatrixReadString(Mstr);

  /* test on str */
  if((strcmp(str,"unifmeas")==0)||(strcmp(str,"unifcdf")==0)||(strcmp(str,"unifpdf")==0)||(strcmp(str,"lognmeas")==0)||(strcmp(str,"logncdf")==0)||(strcmp(str,"lognpdf")==0))
  {
  
    /* Get the input resolution: n and verify it */
    Mn=Interf.Param[1];
    if(!MatrixIsNumeric(Mn))
    {
      InterfError("sbinom: The resolution: n must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsScalar(Mn))
    {
      InterfError("sbinom: The resolution: n must be a scalar\n");
      return;
    }

    /* Get the input argument */ 
    n=(int)MatrixGetScalar(Mn);

    /* Create the output Matrix */  
    two_pow_n=(int)pow(2.,(double)n);
    Mmu_n=MatrixCreate(1,two_pow_n,"real");
    if(Interf.NbParamOut==2)
      MI_n=MatrixCreate(1,two_pow_n,"real");

    /* Get the pointer on the output Matrix */  
    mu_n=MatrixGetPr(Mmu_n);
    if(Interf.NbParamOut==2)
      I_n=MatrixGetPr(MI_n);

    if((strcmp(str,"unifmeas")==0)||(strcmp(str,"unifcdf")==0)||(strcmp(str,"unifpdf")==0))
    {
      if(Interf.NbParamIn==3)
      { 
	/* Get the input precision around .5 epsilon and verify it */
	Mepsilon=Interf.Param[2];
	if(!MatrixIsNumeric(Mepsilon))
	{
	  InterfError("sbinom: The perturbation around weight .5: epsilon must be a numeric matrix\n");
	  return;
	}
	if(!MatrixIsReal(Mepsilon))
	{
	  InterfError("sbinom: The perturbation around weight .5: epsilon must be a real matrix\n");
	  return;
	}
	if(!MatrixIsScalar(Mepsilon))
	{
	  InterfError("sbinom: The perturbation around weight .5: epsilon must be a scalar\n");
	  return;
	}
  
	/* Get the input argument */
	epsilon=(double)MatrixGetScalar(Mepsilon);

	/* Check the value of the input argument */
	if((epsilon<0.)||(epsilon>=.5))
	{
	  InterfError("sbinom: The perturbation around weight .5: epsilon must be >= 0. and < .5\n");
	  return;
	}
      }

      /* Call of the C function */
      if(MFAS_ubm1d(n,epsilon,mu_n)==0) 
      { 
	InterfError("sbinom: Call of the C function MFAS_ubm1d failed\n"); 
	return;
      }   
    }
    else if((strcmp(str,"lognmeas")==0)||(strcmp(str,"logncdf")==0)||(strcmp(str,"lognpdf")==0))
    {  
      /* Check the input arguments # */
      if(Interf.NbParamIn!=3) 
      {
	InterfError("sbinom: You must give 3 input arguments\n");
	return;
      }

      /* Get the input standard-deviation and verify it */
      Msigma=Interf.Param[2];
      if(!MatrixIsNumeric(Msigma))
      {
	InterfError("sbinom: The standard-deviation: sigma must be a numeric matrix\n");
	return;
      } 
      if(!MatrixIsReal(Msigma))
      {
	InterfError("sbinom: The standard-deviation: sigma must be a real matrix\n");
	return;
      }
      if(!MatrixIsScalar(Msigma))
      {
	InterfError("sbinom: The standard-deviation: sigma must be a scalar\n");
	return;
      }

      /* Get the input argument */ 
      sigma=(double)MatrixGetScalar(Msigma);

      /* Call of the C routine */
      if(MFAS_lnm1d(n,2,1./2,sigma*sigma,mu_n)==0) 
      { 
	InterfError("sbinom: Call of the C routine MFAS_lnm1d failed\n"); 
	return;
      }
    }

    /* test on str */
    if((strcmp(str,"unifcdf")==0)||(strcmp(str,"logncdf")==0))
      for(k=1;k<two_pow_n;k++)
	*(mu_n+k)=*(mu_n+k-1)+*(mu_n+k);

    /* test on str */
    if((strcmp(str,"unifpdf")==0)||(strcmp(str,"lognpdf")==0))
      for(k=0;k<two_pow_n;k++)
	*(mu_n+k)=*(mu_n+k)*(double)two_pow_n;

    if(Interf.NbParamOut==2)
      for(k=0;k<two_pow_n;k++)
	*(I_n+k)=(double)k/(double)two_pow_n;

    /* Return the output arguments */
    ReturnParam(Mmu_n); 
    if(Interf.NbParamOut==2)
      ReturnParam(MI_n);

  }
  else if((strcmp(str,"unifspec")==0)||(strcmp(str,"lognspec")==0))
  {
   
    /* Check the output arguments # */
    if(Interf.NbParamOut!=2) 
    {
      InterfError("sbinom: You must give 2 output arguments\n");
      return;
    } 
 
    /* Get the input # of Hoelder exponents and verify it */
    MN=Interf.Param[1];
    if(!MatrixIsNumeric(MN))
    {
      InterfError("sbinom: The # of Hoelder exponents: N must be a numeric matrix\n");
      return;
    } 
    if(!MatrixIsScalar(MN))
    {
      InterfError("sbinom: The # of Hoelder exponents: N must be a scalar\n");
      return;
    }

    /* Get the input argument */
    N=(short)MatrixGetScalar(MN);
  
    /* Create the output Matrix */  
    Malpha=MatrixCreate(1,N,"real");
    Mf_alpha=MatrixCreate(1,N,"real");

    /* Get the pointer on the output Matrix */  
    alpha=MatrixGetPr(Malpha);
    f_alpha=MatrixGetPr(Mf_alpha);

    if(strcmp(str,"unifspec")==0)
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=2) 
      {
	InterfError("sbinom: You must give 2 input arguments\n");
	return;
      } 

      /* Call of the C function */
      if(MFAS_ubm1ds(N,alpha,f_alpha)==0)
      { 
	InterfError("ubm1ds: Call of the C function MFAS_ubm1ds failed\n"); 
	return;
      }
    }
    else
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=3) 
      {
	InterfError("sbinom: You must give 3 input arguments\n");
	return;
      }
  
      /* Get the input standard-deviation and verify it */
      Msigma=Interf.Param[2];
      if(!MatrixIsNumeric(Msigma))
      {
	InterfError("sbinom: The standard-deviation: sigma must be a numeric matrix\n");
	return;
      } 
      if(!MatrixIsReal(Msigma))
      {
	InterfError("sbinom: The standard-deviation: sigma must be a real matrix\n");
	return;
      }
      if(!MatrixIsScalar(Msigma))
      {
	InterfError("sbinom: The standard-deviation: sigma must be a scalar\n");
	return;
      }

      /* Get the input argument */ 
      sigma=(double)MatrixGetScalar(Msigma);

      /* Call of the C function */
      if(MFAS_lnm1ds(N,(sigma*sigma/(2.*log(2.))),alpha,f_alpha)==0)
      { 
	InterfError("sbinom: Call of the C function MFAS_lnm1ds failed\n"); 
	return;
      }
    }

    /* Return the output arguments */
    ReturnParam(Malpha);
    ReturnParam(Mf_alpha);

  }
  else
  {
    InterfError("sbinom: The string: str is not valid\n");
    return;
  }
}
