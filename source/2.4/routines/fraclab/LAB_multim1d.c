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
#include "MFAM_legendre.h"
#include "MFAS_multinomial.h"

#ifndef __STDC__
int MFAS_mm1ds();
#else /* __STDC__ */
int MFAS_mm1ds(short,short,double*,double*,double*);
#endif /* __STDC__ */

/************  LAB_multim1d  ************************************************/

void LAB_multim1d()
{
  register k=0;                                                 /* index */ 
  short b=0;                                                     /* base */
  double *p=NULL;                                             /* weights */
  double sum_p=0.;                                     /* sum of weights */
  char *str=NULL;                                              /* string */
  short n=0;                                               /* resolution */  
  double epsilon=0.;                        /* pertubation around weight */  
  double *mu_n=NULL;                                      /* multinomial */
  int b_pow_n=0;                                         /* # of b-adics */
  double *I_n=NULL;                                           /* b-adics */
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
 
  Matrix *Mb;      /* matrix pointing on the base                        */
  Matrix *Mp;      /* matrix pointing on the weights                     */
  Matrix *Mstr;    /* matrix pointing on the string                      */
  Matrix *Mn;      /* matrix pointing on the resolution                  */  
  Matrix *Mepsilon;/* matrix pointing on the pertubation around weights  */
  Matrix *Mmu_n;   /* matrix pointing on the multinomial                 */
  Matrix *MI_n;    /* matrix pointing on the b-adics                     */
  Matrix *Mvn;     /* matrix pointing on the resolutions                 */
  Matrix *Mq;      /* matrix pointing on the exponents                   */
  Matrix *MZ_n_q;  /* matrix pointing on the Partition sum function      */
  Matrix *Mtau_q;  /* matrix pointing on the Reyni exponents function    */
  Matrix *MD_q;    /* matrix pointing on the Generalized dimensions      */  
  Matrix *MN;      /* matrix pointing on # of Hoelder exponents          */ 
  Matrix *Malpha;  /* matrix pointing on the Hoelder exponents           */
  Matrix *Mf_alpha;/* matrix pointing on the Hausdorff dimension         */ 

  /* Check the input arguments # */
  if(Interf.NbParamIn<4) 
  {
    InterfError("multim1d: You must give at least 4 input arguments\n");
    return;
  }
  
  /* Check the output arguments # */  
  if(Interf.NbParamOut<1)
  {
    InterfError("multim1d: You must give at least 1 output argument\n");
    return;
  }  
  if(Interf.NbParamOut>2)
  {
    InterfError("multim1d: You must give at most 2 output arguments\n");
    return;
  }

  /* Get the input base: b and verify it */
  Mb=Interf.Param[0];
  if(!MatrixIsNumeric(Mb))
  {
    InterfError("multim1d: The base: b must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsScalar(Mb))
  {
    InterfError("multim1d: The base: b must be a scalar\n");
    return;
  }

  /* Get the input argument */ 
  b=(short)MatrixGetScalar(Mb);

  /* Get the input weights: p and verify it */
  Mp=Interf.Param[1];
  if(!MatrixIsNumeric(Mp))
  {
    InterfError("multim1d: The weights: p must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mp))
  {
    InterfError("multim1d: The weights: p must be a real matrix\n");
    return;
  }
  if(MIN(MatrixGetWidth(Mp),MatrixGetHeight(Mp))!=1)
  {
    InterfError("multim1d: The weights: p must be a real vector\n");
    return;
  }
  if(MAX(MatrixGetWidth(Mp),MatrixGetHeight(Mp))!=b)
  {
    InterfError("multim1d: The weights: p must be of size b\n");
    return;
  }

  /* Get the input argument */ 
  p=MatrixGetPr(Mp);
  
  /* Check the value of the input argument */
  for(k=0;k<b;k++)
    sum_p+=*(p+k);
  if(sum_p!=1.)
  {
    InterfError("multim1d: the sum of weights: p must be equal to 1.\n");
    return;
  }
    
  /* Get the input string: str and verify it */
  Mstr=Interf.Param[2];
  if(!MatrixIsString(Mstr))
  {
    InterfError("multim1d: The string: str must be a string\n");
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
      if(Interf.NbParamIn!=5) 
      {
	InterfError("multim1d: You must give 5 input arguments\n");
	return;
      }
    }
    else
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=4) 
      {
	InterfError("multim1d: You must give 4 input arguments\n");
	return;
      }
    }  
   
    /* Get the input resolution: n and verify it */
    Mn=Interf.Param[3];
    if(!MatrixIsNumeric(Mn))
    {
      InterfError("multim1d: The resolution: n must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsScalar(Mn))
    {
      InterfError("multim1d: The resolution: n must be a scalar\n");
      return;
    }

    /* Get the input argument */ 
    n=(int)MatrixGetScalar(Mn);

    /* Create the output Matrix */  
    b_pow_n=(int)pow((double)b,(double)n);
    Mmu_n=MatrixCreate(1,b_pow_n,"real");
    if(Interf.NbParamOut==2)
      MI_n=MatrixCreate(1,b_pow_n,"real");

    /* Get the pointer on the output Matrix */  
    mu_n=MatrixGetPr(Mmu_n);
    if(Interf.NbParamOut==2)
      I_n=MatrixGetPr(MI_n);

    if((strcmp(str,"meas")==0)||(strcmp(str,"cdf")==0)||(strcmp(str,"pdf")==0))
    { 
      /* Call of the C function */
      if(MFAS_mm1d(n,b,p,mu_n)==0) 
      { 
	InterfError("multim1d: Call of the C function MFAS_mm1d failed\n"); 
	return;
      }
    }
    else if((strcmp(str,"shufmeas")==0)||(strcmp(str,"shufcdf")==0)||(strcmp(str,"shufpdf")==0))
    {  
      /* Call of the C function */
      if(MFAS_smm1d(n,b,p,mu_n)==0) 
      { 
	InterfError("multim1d: Call of the C function MFAS_smm1d failed\n"); 
	return;
      }
    }
    else if((strcmp(str,"pertmeas")==0)||(strcmp(str,"pertcdf")==0)||(strcmp(str,"pertpdf")==0))
    {  

      /* Get the input precision around weight epsilon and verify it */
      Mepsilon=Interf.Param[4];
      if(!MatrixIsNumeric(Mepsilon))
      {
	InterfError("multim1d: The pertubation around weight: epsilon must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsReal(Mepsilon))
      {
	InterfError("multim1d: The pertubation around weight: epsilon must be a real matrix\n");
	return;
      }
      if(!MatrixIsScalar(Mepsilon))
      {
	InterfError("multim1d: The pertubation around weight: epsilon must be a scalar\n");
	return;
      }

      /* Get the input argument */
      epsilon=(double)MatrixGetScalar(Mepsilon);
  
      /* Check the perturbation */
      for(k=0;k<b;k++)
	if((*(p+k)-epsilon<=0.)||(*(p+k)+epsilon>=1.))
	{
	  InterfError("multim1d: epsilon must such that p(i)-epsilon>0., p(i)+epsilon<1. (i=1,...,b)\n");
	  return;
	}

      /* Call of the C function */
      if(MFAS_rmm1d(n,b,p,epsilon,mu_n)==0) 
      { 
	InterfError("multim1d: Call of the C function MFAS_rmm1d failed\n"); 
	return;
      }

    }  

    /* test on str */
    if((strcmp(str,"cdf")==0)||(strcmp(str,"shufcdf")==0)||(strcmp(str,"pertcdf")==0))
      for(k=1;k<b_pow_n;k++)
	*(mu_n+k)=*(mu_n+k-1)+*(mu_n+k);

    /* test on str */
    if((strcmp(str,"pdf")==0)||(strcmp(str,"shufpdf")==0)||(strcmp(str,"pertpdf")==0))
      for(k=0;k<b_pow_n;k++)
	*(mu_n+k)=*(mu_n+k)*(double)b_pow_n;

    if(Interf.NbParamOut==2)
      for(k=0;k<b_pow_n;k++)
	*(I_n+k)=(double)k/(double)b_pow_n;

    /* Return the output arguments */
    ReturnParam(Mmu_n); 
    if(Interf.NbParamOut==2)
      ReturnParam(MI_n);

  }
  else if(strcmp(str,"part")==0)
  {
    /* Check the input arguments # */
    if(Interf.NbParamIn!=5) 
    {
      InterfError("multim1d: You must give 5 input arguments\n");
      return;
    }  
      
    /* Check the output arguments # */
    if(Interf.NbParamOut!=1) 
    {
      InterfError("multim1d: You must give 1 output argument\n");
      return;
    }  

    /* Get the input resolutions vn and verify it */
    Mvn=Interf.Param[3];
    if(!MatrixIsNumeric(Mvn))
    {
      
      InterfError("multim1d: The resolutions: vn must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mvn))
    {
      InterfError("multim1d: The resolutions: vn must be a real matrix\n");
      return;
    } 
    if(MIN(MatrixGetWidth(Mvn),MatrixGetHeight(Mvn))!=1)
    {
      InterfError("multim1d: The resolutions: vn must be a real vector\n");
      return;
    }

    n_nb=(int)MAX(MatrixGetWidth(Mvn),MatrixGetHeight(Mvn));

    /* dynamic memory allocation */  	 
    if((vn=(short*)malloc((unsigned)(n_nb*sizeof(short))))==NULL)
    {
      InterfError("multim1d: malloc error\n"); 
      return;
    } 
 
    /* Get the input argument */   
    Prn=MatrixGetPr(Mvn);
    for(k=0;k<n_nb;k++)    
      *(vn+k)=(short)*(Prn+k); 

    /* Get the input exponents q and verify it */
    Mq=Interf.Param[4];
    if(!MatrixIsNumeric(Mq))
    {
      InterfError("multim1d: The exponents: q must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mq))
    {
      InterfError("multim1d: The exponents: q must be a real matrix\n");
      return;
    }
    if(MIN(MatrixGetWidth(Mq),MatrixGetHeight(Mq))!=1)
    {
      InterfError("multim1d: The exponents: q must be a real vector\n");
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
    if(MFAS_mm1d_Z_n_q(b,p,n_nb,vn,q_nb,q,Z_n_q)==0) 
    { 
      InterfError("multim1d: Call of the C function MFAS_mm1d_Z_n_q failed\n");
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
    if(Interf.NbParamIn!=4) 
    {
      InterfError("multim1d: You must give 4 input arguments\n");
      return;
    }

    /* Get the input exponents q and verify it */
    Mq=Interf.Param[3];
    if(!MatrixIsNumeric(Mq))
    {
      InterfError("multim1d: The exponents q must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mq))
    {
      InterfError("multim1d: The exponents q must be a real matrix\n");
      return;
    }
    if(MIN(MatrixGetWidth(Mq),MatrixGetHeight(Mq))!=1)
    {
      InterfError("multim1d: The exponents: q must be a real vector\n");
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
    if(MFAS_mm1d_tau_q(b,p,q_nb,q,tau_q)==0) 
    { 
      InterfError("multim1d: Call of the C function MFAS_mm1d_tau_q failed\n");
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
  else if(strcmp(str,"spec")==0)
  {
    /* Check the input arguments # */
    if(Interf.NbParamIn!=4) 
    {
      InterfError("multim1d: You must give 4 input arguments\n");
      return;
    }
  
    /* Check the output arguments # */
    if(Interf.NbParamOut!=2) 
    {
      InterfError("multim1d: You must give 2 output arguments\n");
      return;
    } 

    /* Get the input # of Hoelder exponents and verify it */
    MN=Interf.Param[3];
    if(!MatrixIsNumeric(MN))
    {
      InterfError("multim1d: The # of Hoelder exponents: N must be a numeric matrix\n");
      return;
    } 
    if(!MatrixIsScalar(MN))
    {
      InterfError("multim1d: The # of Hoelder exponents: N must be a scalar\n");
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

    /* Call of the C function */
    if(MFAS_mm1ds(N,b,p,alpha,f_alpha)==0)
    { 
      InterfError("multim1d: Call of the C function MFAS_mm1ds failed\n"); 
      return;
    }

    /* Return the output arguments */
    ReturnParam(Malpha);
    ReturnParam(Mf_alpha);

  }
  else
  {
    InterfError("multim1d: The string: str is not valid\n");
    return;
  }
}

/********************/	
#ifndef __STDC__
int MFAS_mm1ds(N, b, p, alpha, f_alpha)
     short int N;
     short int b;
     double *p;
     double *alpha;
     double *f_alpha;
#else /* __STDC__ */
int MFAS_mm1ds(short N,short b,double *p,double *alpha,double *f_alpha)
#endif /* __STDC__ */
{
  if((N>0)&&(b>0)&&(p!=NULL)&&(alpha!=NULL)&&(f_alpha!=NULL))
  {
    register k=0;
    int q_nb=N;
    double q_min=-15.,q_max=15.,d_q=(q_max-q_min)/(double)(q_nb-1),*q=NULL,*tau_q=NULL; 
    if((q=(double*)malloc((unsigned int)sizeof(double)*N))==NULL)
    {
      (void)fprintf(stderr,"malloc error\n");
      return 0;
    } 
    for(k=0;k<q_nb;k++)
      *(q+k)=q_min+k*d_q;
    if((tau_q=(double*)malloc((unsigned int)sizeof(double)*N))==NULL)
    {
      (void)fprintf(stderr,"malloc error\n");
      return 0;
    }  
    if(MFAS_mm1d_tau_q(b,p,q_nb,q,tau_q)==0)
    {
      (void)fprintf(stdout,"MFAS_bms error\n");
      return 0;
    } 
    if(MFAM_llt(q_nb,q,tau_q,alpha,f_alpha)==0)
    {
      (void)fprintf(stdout,"MFAS_bms error\n");
      return 0;
    }   
    free((char*)q);
    free((char*)tau_q);
    return 1;
  }
  else
  {    
    (void)fprintf(stderr,"MFAS_mm1ds arguments error\n");
    return 0;
  }
}


