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

/************  LAB_binom  ************************************************/

void LAB_binom()
{
  register k=0;                                                 /* index */ 
  double p0=0.;                                                /* weight */
  char *str=NULL;                                              /* string */
  short n=0;                                               /* resolution */ 
  double epsilon=0.;                        /* pertubation around weight */    
  double *mu_n=NULL;                                      /* multinomial */
  int two_pow_n=0;                                       /* # of dyadics */
  double *I_n=NULL;                                           /* dyadics */
  int n_nb=0;                                        /* # of resolutions */ 
  short *vn=NULL;                                         /* resolutions */
  double *Prn=NULL;                                       /* resolutions */
  int q_nb=0;                                          /* # of exponents */
  double *q=NULL;                                           /* exponents */
  double *Z_n_q=NULL;                          /* Partition sum function */
  double *tau_q=NULL;                        /* Reyni exponents function */
  double *D_q=NULL;                            /* Generalized dimensions */ 
  short N=0;                                   /* # of Hoelder exponents */ 
  double *alpha=NULL;                               /* Hoelder exponents */
  double *f_alpha=NULL;                           /* Hausdorff dimension */
  double q0=0.;                                         /* second weight */

  Matrix *Mp0;     /* matrix pointing on the weight                      */
  Matrix *Mstr;    /* matrix pointing on the string                      */
  Matrix *Mn;      /* matrix pointing on the resolution                  */ 
  Matrix *Mepsilon;/* matrix pointing on the pertubation around weights  */
  Matrix *Mmu_n;   /* matrix pointing on the multinomial                 */
  Matrix *MI_n;    /* matrix pointing on the dyadics                     */
  Matrix *Mvn;     /* matrix pointing on the resolutions                 */
  Matrix *Mq;      /* matrix pointing on the exponents                   */
  Matrix *MZ_n_q;  /* matrix pointing on the Partition sum function      */
  Matrix *Mtau_q;  /* matrix pointing on the Reyni exponents function    */
  Matrix *MD_q;    /* matrix pointing on the Generalized dimensions      */  
  Matrix *MN;      /* matrix pointing on # of Hoelder exponents          */ 
  Matrix *Malpha;  /* matrix pointing on the Hoelder exponents           */
  Matrix *Mf_alpha;/* matrix pointing on the Hausdorff dimension         */ 
  Matrix *Mq0;     /* matrix pointing on the second weight               */

  /* Check the input arguments # */
  if(Interf.NbParamIn<3) 
  {
    InterfError("binom: You must give at least 3 input arguments\n");
    return;
  }
  
  /* Check the output arguments # */  
  if(Interf.NbParamOut<1)
  {
    InterfError("binom: You must give at least 1 output argument\n");
    return;
  }  
  if(Interf.NbParamOut>2)
  {
    InterfError("binom: You must give at most 2 output arguments\n");
    return;
  }

  /* Get the input weight p0 and verify it */
  Mp0=Interf.Param[0];
  if(!MatrixIsNumeric(Mp0))
  {
    InterfError("binom: The weight: p0 must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mp0))
  {
    InterfError("binom: The weight: p0 must be a real matrix\n");
    return;
  }
  if(!MatrixIsScalar(Mp0))
  {
    InterfError("binom: The weight: p0 must be a scalar\n");
    return;
  }
  
  /* Get the input argument */
  p0=(double)MatrixGetScalar(Mp0);

  /* Check the value of the input argument */
  if((p0<0.)||(p0>1.))
  {
    InterfError("binom: The weight: p0 must be >0. and <1.\n");
    return;
  }

  /* Get the input string: str and verify it */
  Mstr=Interf.Param[1];
  if(!MatrixIsString(Mstr))
  {
    InterfError("binom: The string: str must be a string\n");
    return;
  }

  /* Get the input argument */
  str=MatrixReadString(Mstr);

  /* test on str */
  if((strcmp(str,"meas")==0)||(strcmp(str,"cdf")==0)||(strcmp(str,"pdf")==0)||(strcmp(str,"shufmeas")==0)||(strcmp(str,"shufcdf")==0)||(strcmp(str,"shufpdf")==0)||(strcmp(str,"pertmeas")==0)||(strcmp(str,"pertcdf")==0)||(strcmp(str,"pertpdf")==0))
  {  
    if((strcmp(str,"pertmeas")==0)||(strcmp(str,"pertcdf")==0)||(strcmp(str,"pertpdf")==0))
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=4) 
      {
	InterfError("binom: You must give 4 input arguments\n");
	return;
      }
    }
    else
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=3) 
      {
	InterfError("binom: You must give 3 input arguments\n");
	return;
      }
    }
   
    /* Get the input resolution: n and verify it */
    Mn=Interf.Param[2];
    if(!MatrixIsNumeric(Mn))
    {
      InterfError("binom: The resolution: n must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsScalar(Mn))
    {
      InterfError("binom: The resolution: n must be a scalar\n");
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

    if((strcmp(str,"meas")==0)||(strcmp(str,"cdf")==0)||(strcmp(str,"pdf")==0))
    { 
      /* Call of the C function */
      if(MFAS_bm1d(n,p0,mu_n)==0) 
      { 
	InterfError("binom: Call of the C function MFAS_bm1d failed\n"); 
	return;
      }
    }
    else if((strcmp(str,"shufmeas")==0)||(strcmp(str,"shufcdf")==0)||(strcmp(str,"shufpdf")==0))
    {  
      /* Call of the C function */
      if(MFAS_sbm1d(n,p0,mu_n)==0) 
      { 
	InterfError("multim1d: Call of the C function MFAS_sbm1d failed\n"); 
	return;
      }
    }
    else if((strcmp(str,"pertmeas")==0)||(strcmp(str,"pertcdf")==0)||(strcmp(str,"pertpdf")==0))
    {  

      /* Get the input precision around weight epsilon and verify it */
      Mepsilon=Interf.Param[3];
      if(!MatrixIsNumeric(Mepsilon))
      {
	InterfError("binom: The pertubation around weight: epsilon must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsReal(Mepsilon))
      {
	InterfError("binom: The pertubation around weight: epsilon must be a real matrix\n");
	return;
      }
      if(!MatrixIsScalar(Mepsilon))
      {
	InterfError("binom: The pertubation around weight: epsilon must be a scalar\n");
	return;
      }

      /* Get the input argument */
      epsilon=(double)MatrixGetScalar(Mepsilon);
  
      /* Check the perturbation */
      if((p0-epsilon<=0.)||(p0+epsilon>=1.))
      {
	InterfError("binom: epsilon must such that p0-epsilon>0. and p0+epsilon<1.\n");
	return;
      }

      /* Call of the C function */
      if(MFAS_rbm1d(n,p0,epsilon,mu_n)==0) 
      { 
	InterfError("binom: Call of the C function MFAS_rbm1d failed\n"); 
	return;
      }

    }  

    /* test on str */
    if((strcmp(str,"cdf")==0)||(strcmp(str,"shufcdf")==0)||(strcmp(str,"pertcdf")==0))
      for(k=1;k<two_pow_n;k++)
	*(mu_n+k)=*(mu_n+k-1)+*(mu_n+k);

    /* test on str */
    if((strcmp(str,"pdf")==0)||(strcmp(str,"shufpdf")==0)||(strcmp(str,"pertpdf")==0))
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
  else if(strcmp(str,"part")==0)
  {  
    /* Check the input arguments # */
    if(Interf.NbParamIn!=4) 
    {
      InterfError("binom: You must give 4 input arguments\n");
      return;
    }  
      
    /* Check the output arguments # */
    if(Interf.NbParamOut!=1) 
    {
      InterfError("binom: You must give 1 output argument\n");
      return;
    }  

    /* Get the input resolutions vn and verify it */
    Mvn=Interf.Param[2];
    if(!MatrixIsNumeric(Mvn))
    {
      
      InterfError("binom: The resolutions: vn must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mvn))
    {
      InterfError("binom: The resolutions: vn must be a real matrix\n");
      return;
    } 
    if(MIN(MatrixGetWidth(Mvn),MatrixGetHeight(Mvn))!=1)
    {
      InterfError("binom: The resolutions: vn must be a real vector\n");
      return;
    }

    n_nb=(int)MAX(MatrixGetWidth(Mvn),MatrixGetHeight(Mvn));

    /* dynamic memory allocation */  	 
    if((vn=(short*)malloc((unsigned)(n_nb*sizeof(short))))==NULL)
    {
      InterfError("binom: malloc error\n"); 
      return;
    } 

    /* Get the input argument */   
    Prn=MatrixGetPr(Mvn);
    for(k=0;k<n_nb;k++)    
      *(vn+k)=(short)*(Prn+k); 

    /* Get the input exponents q and verify it */
    Mq=Interf.Param[3];
    if(!MatrixIsNumeric(Mq))
    {
      InterfError("binom: The exponents: q must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mq))
    {
      InterfError("binom: The exponents: q must be a real matrix\n");
      return;
    }
    if(MIN(MatrixGetWidth(Mq),MatrixGetHeight(Mq))!=1)
    {
      InterfError("binom: The exponents: q must be a real vector\n");
      return;
    }
    q_nb=(int)MAX(MatrixGetWidth(Mq),MatrixGetHeight(Mq));
    
    /* Get the input argument */ 
    q=MatrixGetPr(Mq);
    
    /* Create the output Matrix */  
    MZ_n_q=MatrixCreate(q_nb,n_nb,"real");

    /* Get the pointer on the output Matrix */  
    Z_n_q=MatrixGetPr(MZ_n_q);
      
    /* Call of the C function */
    if(MFAS_bm1d_Z_n_q(p0,n_nb,vn,q_nb,q,Z_n_q)==0) 
    { 
      InterfError("binom: Call of the C function MFAS_mm1d_Z_n_q failed\n");
      return;
    }
 
    /* dynamic memory desallocation */
    free((char*)vn);

    /* Return the output */
    ReturnParam(MZ_n_q);

  }
  else if(strcmp(str,"Reyni")==0)
  {
    /* Check the input arguments # */
    if(Interf.NbParamIn!=3) 
    {
      InterfError("binom: You must give 3 input arguments\n");
      return;
    }

    /* Get the input exponents q and verify it */
    Mq=Interf.Param[2];
    if(!MatrixIsNumeric(Mq))
    {
      InterfError("binom: The exponents q must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mq))
    {
      InterfError("binom: The exponents q must be a real matrix\n");
      return;
    }
    if(MIN(MatrixGetWidth(Mq),MatrixGetHeight(Mq))!=1)
    {
      InterfError("binom: The exponents: q must be a real vector\n");
      return;
    }

    q_nb=(int)MAX(MatrixGetWidth(Mq),MatrixGetHeight(Mq));

    /* Get the input argument */ 
    q=(double*)MatrixGetPr(Mq);
 
    /* Create the output Matrix */  
    Mtau_q=MatrixCreate(1,q_nb,"real");

    /* Get the pointer on the output Matrix */  
    tau_q=MatrixGetPr(Mtau_q);
 
    /* Call of the C function */
    if(MFAS_bm1d_tau_q(p0,q_nb,q,tau_q)==0) 
    { 
      InterfError("binom: Call of the C function MFAS_mm1d_tau_q failed\n");
      return;
    }

    if(Interf.NbParamOut==2)
    { 
   
      /* Create the output Matrix */  
      MD_q=MatrixCreate(1,q_nb,"real");
    
      /* Get the pointer on the output Matrix */  
      D_q=MatrixGetPr(MD_q);
    
      for(k=0;k<q_nb;k++)
	if(*(q+k)!=1.)
	  *(D_q+k)=*(tau_q+k)/(*(q+k)-1.);
    }

    /* Return the output arguments */
    ReturnParam(Mtau_q);
    if(Interf.NbParamOut==2)
      ReturnParam(MD_q);

  }
  else if((strcmp(str,"spec")==0)||(strcmp(str,"lumpspec")==0)||(strcmp(str,"sumspec")==0))
  {
    if((strcmp(str,"lumpspec")==0)||(strcmp(str,"sumspec")==0))
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=4) 
      {
	InterfError("binom: You must give 4 input arguments\n");
	return;
      }
    }
    else
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=3) 
      {
	InterfError("binom: You must give 3 input arguments\n");
	return;
      }
    }
  
    /* Check the output arguments # */
    if(Interf.NbParamOut!=2) 
    {
      InterfError("binom: You must give 2 output arguments\n");
      return;
    } 

    /* Get the input # of Hoelder exponents and verify it */
    MN=Interf.Param[2];
    if(!MatrixIsNumeric(MN))
    {
      InterfError("binom: The # of Hoelder exponents: N must be a numeric matrix\n");
      return;
    } 
    if(!MatrixIsScalar(MN))
    {
      InterfError("binom: The # of Hoelder exponents: N must be a scalar\n");
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

    if((strcmp(str,"lumpspec")==0)||(strcmp(str,"sumspec")==0))
    { 
      /* Get the input weight q0 and verify it */
      Mq0=Interf.Param[3];
      if(!MatrixIsNumeric(Mq0))
      {
	InterfError("binom: The weight: q0 must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsReal(Mq0))
      {
	InterfError("binom: The weight: q0 must be a real matrix\n");
	return;
      }
      if(!MatrixIsScalar(Mq0))
      {
	InterfError("binom: The weight: q0 must be a scalar\n");
	return;
      }
  
      /* Get the input argument */
      q0=(double)MatrixGetScalar(Mq0);

      /* Check the value of the input argument */
      if((q0<=0.)||(q0>=1.))
      {
	InterfError("binom: The weight: q0 must be >0. and <1.\n");
	return;
      }

      /* Compare both weights */
      if(p0>q0)
      {
	double tmp=p0;
	p0=q0;
	q0=tmp;
      }

      /* Call of the C function */
      if(strcmp(str,"lumpspec")==0)
      {
	if(MFAS_lumpbm1ds(N,p0,q0,alpha,f_alpha)==0)
	{ 
	  InterfError("binom: Call of the C function MFAS_lumpbm1ds failed\n"); 
	  return;
	}
      }
      else
      {
	if(MFAS_sumbm1ds(N,p0,q0,alpha,f_alpha)==0)
	{ 
	  InterfError("binom: Call of the C function MFAS_sumbm1ds failed\n"); 
	  return;
	}
      }
    }
    else
    {
      /* Call of the C function */
      if(MFAS_bm1ds(N,p0,alpha,f_alpha)==0)
      { 
	InterfError("binom: Call of the C function MFAS_bm1ds failed\n"); 
	return;
      }
    }

    /* Return the output arguments */
    ReturnParam(Malpha);
    ReturnParam(Mf_alpha);

  } 
  else if((strcmp(str,"lumpmeas")==0)||(strcmp(str,"lumpcdf")==0)||(strcmp(str,"lumppdf")==0)||(strcmp(str,"summeas")==0)||(strcmp(str,"sumcdf")==0)||(strcmp(str,"sumpdf")==0)||(strcmp(str,"lumppertmeas")==0)||(strcmp(str,"lumppertcdf")==0)||(strcmp(str,"lumppertpdf")==0)||(strcmp(str,"sumpertmeas")==0)||(strcmp(str,"sumpertcdf")==0)||(strcmp(str,"sumpertpdf")==0))
  {
    if((strcmp(str,"lumppertmeas")==0)||(strcmp(str,"lumppertcdf")==0)||(strcmp(str,"lumppertpdf")==0)||(strcmp(str,"sumpertmeas")==0)||(strcmp(str,"sumpertcdf")==0)||(strcmp(str,"sumpertpdf")==0))
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=5) 
      {
	InterfError("binom: You must give 5 input arguments\n");
	return;
      }
    }
    else
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=4) 
      {
	InterfError("binom: You must give 4 input arguments\n");
	return;
      }
    }
    
    /* Get the input resolution: n and verify it */
    Mn=Interf.Param[2];
    if(!MatrixIsNumeric(Mn))
    {
      InterfError("binom: The resolution: n must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsScalar(Mn))
    {
      InterfError("binom: The resolution: n must be a scalar\n");
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

    /* Get the input weight q0 and verify it */
    Mq0=Interf.Param[3];
    if(!MatrixIsNumeric(Mq0))
    {
      InterfError("binom: The weight: q0 must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mq0))
    {
      InterfError("binom: The weight: q0 must be a real matrix\n");
      return;
    }
    if(!MatrixIsScalar(Mq0))
    {
      InterfError("binom: The weight: q0 must be a scalar\n");
      return;
    }
  
    /* Get the input argument */
    q0=(double)MatrixGetScalar(Mq0);

    /* Check the value of the input argument */
    if((q0<=0.)||(q0>=1.))
    {
      InterfError("binom: The weight: q0 must be >0. and <1.\n");
      return;
    }

    if((strcmp(str,"lumpmeas")==0)||(strcmp(str,"lumpcdf")==0)||(strcmp(str,"lumppdf")==0))
    {
      /* Call of the C function */
      if(MFAS_lumpbm1d(n,p0,q0,mu_n)==0) 
      { 
	InterfError("binom: Call of the C function MFAS_lumpbm1d failed\n"); 
	return;
      }
    }
    else if((strcmp(str,"summeas")==0)||(strcmp(str,"sumcdf")==0)||(strcmp(str,"sumpdf")==0))
    {
      if(MFAS_sumbm1d(n,p0,q0,mu_n)==0) 
      { 
	InterfError("binom: Call of the C function MFAS_sumbm1d failed\n"); 
	return;
      }
    }
    else 
    {
      /* Get the input precision around weight epsilon and verify it */
      Mepsilon=Interf.Param[4];
      if(!MatrixIsNumeric(Mepsilon))
      {
	InterfError("binom: The pertubation around weight: epsilon must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsReal(Mepsilon))
      {
	InterfError("binom: The pertubation around weight: epsilon must be a real matrix\n");
	return;
      }
      if(!MatrixIsScalar(Mepsilon))
      {
	InterfError("binom: The pertubation around weight: epsilon must be a scalar\n");
	return;
      }

      /* Get the input argument */
      epsilon=(double)MatrixGetScalar(Mepsilon);
  
      /* Check the perturbation */
      if((p0-epsilon<=0.)||(p0+epsilon>=1.)||(q0-epsilon<=0.)||(q0+epsilon>=1.))
      {
	InterfError("binom: epsilon must such that p-epsilon>0. and p+epsilon<1. (p=p0 or q0)\n");
	return;
      }

      if((strcmp(str,"lumppertmeas")==0)||(strcmp(str,"lumppertcdf")==0)||(strcmp(str,"lumppertpdf")==0))
      {
	/* Call of the C function */
	if(MFAS_lumprbm1d(n,p0,q0,epsilon,mu_n)==0) 
	{ 
	  InterfError("binom: Call of the C function MFAS_lumprbm1d failed\n");
	  return;
	}
      }
      else
      {
	/* Call of the C function */
	if(MFAS_sumrbm1d(n,p0,q0,epsilon,mu_n)==0) 
	{ 
	  InterfError("binom: Call of the C function MFAS_sumrbm1d failed\n"); 
	  return;
	}
      }
    }
      
    /* test on str */
    if((strcmp(str,"lumpcdf")==0)||(strcmp(str,"sumcdf")==0)||(strcmp(str,"lumppertcdf")==0)||(strcmp(str,"sumpertcdf")==0))
      for(k=1;k<two_pow_n;k++)
	*(mu_n+k)=*(mu_n+k-1)+*(mu_n+k);

    /* test on str */
    if((strcmp(str,"lumppdf")==0)||(strcmp(str,"sumpdf")==0)||(strcmp(str,"lumppertpdf")==0)||(strcmp(str,"sumpertpdf")==0))
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
  else
  {
    InterfError("binom: The string: str is not valid\n");
    return;
  }
}
