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
int MFAS_mm2ds();
#else /* __STDC__ */
int MFAS_mm2ds(short,short,short,double*,double*,double*);
#endif /* __STDC__ */

/************  LAB_multim2d  ************************************************/

void LAB_multim2d()
{
  register k=0,i=0,j=0;                                         /* index */ 
  short bx=0;                                                   /* basex */
  short by=0;                                                   /* basey */
  double *p=NULL;                                             /* weights */
  double sum_p=0.;                                     /* sum of weights */
  char *str=NULL;                                              /* string */
  short n=0;                                               /* resolution */  
  double epsilon=0.;                        /* pertubation around weight */   
  double *mu_n=NULL;                                      /* multinomial */
  int bx_pow_n=0;                                       /* # of bx-adics */
  int by_pow_n=0;                                       /* # of by-adics */
  double *I_nx=NULL;                                         /* bx-adics */
  double *I_ny=NULL;                                         /* by-adics */
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
 
  Matrix *Mbx;     /* matrix pointing on the basex                       */
  Matrix *Mby;     /* matrix pointing on the basey                       */ 
  Matrix *Mp;      /* matrix pointing on the weights                     */
  Matrix *Mstr;    /* matrix pointing on the string                      */
  Matrix *Mn;      /* matrix pointing on the resolution                  */
  Matrix *Mepsilon;/* matrix pointing on the pertubation around weights  */
  Matrix *Mmu_n;   /* matrix pointing on the multinomial                 */
  Matrix *MI_nx;   /* matrix pointing on the bx-adics                    */ 
  Matrix *MI_ny;   /* matrix pointing on the by-adics                    */
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
    InterfError("multim2d: You must give at least 4 input arguments\n");
    return;
  }

  /* Check the output arguments # */  
  if(Interf.NbParamOut<1)
  {
    InterfError("multim2d: You must give at least 1 output argument\n");
    return;
  }  
  if(Interf.NbParamOut>3)
  {
    InterfError("multim2d: You must give at most 3 output arguments\n");
    return;
  }
  
  /* Get the input base bx and verify it */
  Mbx=Interf.Param[0];
  if(!MatrixIsNumeric(Mbx))
  {
    InterfError("multim2d: The base: bx must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsScalar(Mbx))
  {
    InterfError("multim2d: The base: bx must be a scalar\n");
    return;
  }

  /* Get the input argument */ 
  bx=(short)MatrixGetScalar(Mbx);

  /* Get the input base by and verify it */
  Mby=Interf.Param[1];
  if(!MatrixIsNumeric(Mbx))
  {
    InterfError("multim2d: The base: by must be a numeric matrix\n");
    return;
  } 
  if(!MatrixIsScalar(Mby))
  {
    InterfError("multim2d: The base: by must be a scalar\n");
    return;
  }

  /* Get the input argument */ 
  by=(short)MatrixGetScalar(Mby);

  /* Get the input weights p and verify it */
  Mp=Interf.Param[2];
  if(!MatrixIsNumeric(Mp))
  {
    InterfError("multim2d: The weights: p must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mp))
  {
    InterfError("multim2d: The weights: p must be a real matrix\n");
    return;
  }
  if(MatrixGetWidth(Mp)!=bx)
  {
    InterfError("multim2d: The weights: p must be of width bx\n");
    return;
  }
  if(MatrixGetHeight(Mp)!=by)
  {
    InterfError("multim2d: The weights: p matrix must be of height by\n");
    return;
  }

  /* Transpose input argument */
  MatrixTranspose(Mp);

  /* Get the input argument */ 
  p=(double*)MatrixGetPr(Mp);
   
  /* Check the value of the input argument */
  for(k=0;k<bx*by;k++)
    sum_p+=*(p+k);
  if(sum_p!=1.)
  {
    InterfError("multim2d: sum of weights p must be equal to 1.\n");  
    /* Transpose input argument */
    MatrixTranspose(Mp);
    return;
  }
  
  /* Get the input string: str and verify it */
  Mstr=Interf.Param[3];
  if(!MatrixIsString(Mstr))
  {
    InterfError("multim2d: The string: str must be a string\n");  
    /* Transpose input argument */
    MatrixTranspose(Mp);
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
      if(Interf.NbParamIn!=6) 
      {
	InterfError("multim2d: You must give 6 input arguments\n"); 
	/* Transpose input argument */
	MatrixTranspose(Mp);
	return;
      }
    }
    else
    {
      /* Check the input arguments # */
      if(Interf.NbParamIn!=5) 
      {
	InterfError("multim2d: You must give 5 input arguments\n");  
	/* Transpose input argument */
	MatrixTranspose(Mp);
	return;
      }
    }  

    /* Check the output arguments # */
    if((Interf.NbParamOut!=1)&&(Interf.NbParamOut!=3))
    {
      InterfError("multim2d: You must give 1 or 3 output arguments\n");  
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    }

    /* Get the input resolution: n and verify it */
    Mn=Interf.Param[4];
    if(!MatrixIsNumeric(Mn))
    {
      InterfError("multim2d: The resolution: n must be a numeric matrix\n");  
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    }
    if(!MatrixIsScalar(Mn))
    {
      InterfError("multim2d: The resolution: n must be a scalar\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
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

    if((strcmp(str,"meas")==0)||(strcmp(str,"cdf")==0)||(strcmp(str,"pdf")==0))
    { 
      /* Call of the C function */
      if(MFAS_mm2d(n,bx,by,p,mu_n)==0) 
      { 
	InterfError("mm2d: Call of the C function MFAS_mm2d failed\n"); 
	/* Transpose input argument */
	MatrixTranspose(Mp);
	return;
      }
    }
    else if((strcmp(str,"shufmeas")==0)||(strcmp(str,"shufcdf")==0)||(strcmp(str,"shufpdf")==0))
    {  
      /* Call of the C function */
      if(MFAS_smm2d(n,bx,by,p,mu_n)==0) 
      { 
	InterfError("multim2d: Call of the C function MFAS_smm2d failed\n"); 
	/* Transpose input argument */
	MatrixTranspose(Mp);
	return;
      }
    }
    else if((strcmp(str,"pertmeas")==0)||(strcmp(str,"pertcdf")==0)||(strcmp(str,"pertpdf")==0))
    {  
      /* Get the input precision around weight epsilon and verify it */
      Mepsilon=Interf.Param[5];
      if(!MatrixIsNumeric(Mepsilon))
      {
	InterfError("multim1d: The pertubation around weight: epsilon must be a numeric matrix\n");
	/* Transpose input argument */
	MatrixTranspose(Mp);
	return;
      }
      if(!MatrixIsReal(Mepsilon))
      {
	InterfError("multim1d: The pertubation around weight: epsilon must be a real matrix\n");
	/* Transpose input argument */
	MatrixTranspose(Mp);
	return;
      }
      if(!MatrixIsScalar(Mepsilon))
      {
	InterfError("multim1d: The pertubation around weight: epsilon must be a scalar\n");
	/* Transpose input argument */
	MatrixTranspose(Mp);
	return;
      }

      /* Get the input argument */
      epsilon=(double)MatrixGetScalar(Mepsilon);
  
      /* Check the perturbation */
      for(k=0;k<bx*by;k++)
	if((*(p+k)-epsilon<=0.)||(*(p+k)+epsilon>=1.))
	{
	  InterfError("multim2d: epsilon must such that p(i)-epsilon>0., p(i)+epsilon<1. (i=1,...,b)\n");
	  /* Transpose input argument */
	  MatrixTranspose(Mp);
	  return;
	}

      /* Call of the C function */
      if(MFAS_rmm2d(n,bx,by,p,epsilon,mu_n)==0) 
      { 
	InterfError("multim2d: Call of the C function MFAS_rmm2d failed\n"); 
	/* Transpose input argument */
	MatrixTranspose(Mp);
	return;
      }
    }  

    /* test on str */
    if((strcmp(str,"cdf")==0)||(strcmp(str,"shufcdf")==0)||(strcmp(str,"pertcdf")==0))
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
    if((strcmp(str,"pdf")==0)||(strcmp(str,"shufpdf")==0)||(strcmp(str,"pertpdf")==0))
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
  else if(strcmp(str,"part")==0)
  {
    /* Check the input arguments # */
    if(Interf.NbParamIn!=6) 
    {
      InterfError("multim2d: You must give 6 input arguments\n");
      return;
    }  
      
    /* Check the output arguments # */
    if(Interf.NbParamOut!=1) 
    {
      InterfError("multim2d: You must give 1 output argument\n");
      return;
    }  

    /* Get the input resolutions vn and verify it */
    Mvn=Interf.Param[4];
    if(!MatrixIsNumeric(Mvn))
    {
      
      InterfError("multim2d: The resolutions: vn must be a numeric matrix\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    }
    if(!MatrixIsReal(Mvn))
    {
      InterfError("multim2d: The resolutions: vn must be a real matrix\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    } 
    if(MIN(MatrixGetWidth(Mvn),MatrixGetHeight(Mvn))!=1)
    {
      InterfError("multim2d: The resolutions: vn must be a real vector\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    }

    n_nb=(int)MAX(MatrixGetWidth(Mvn),MatrixGetHeight(Mvn));

    /* dynamic memory allocation */  	 
    if((vn=(short*)malloc((unsigned)(n_nb*sizeof(short))))==NULL)
    {
      InterfError("multim2d: malloc error\n"); 
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    } 
 
    /* Get the input argument */   
    Prn=MatrixGetPr(Mvn);
    for(k=0;k<n_nb;k++)    
      *(vn+k)=(short)*(Prn+k); 

    /* Get the input exponents q and verify it */
    Mq=Interf.Param[5];
    if(!MatrixIsNumeric(Mq))
    {
      InterfError("multim2d: The exponents: q must be a numeric matrix\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    }
    if(!MatrixIsReal(Mq))
    {
      InterfError("multim2d: The exponents: q must be a real matrix\n");
      return;
    }
    if(MIN(MatrixGetWidth(Mq),MatrixGetHeight(Mq))!=1)
    {
      InterfError("multim2d: The exponents: q must be a real vector\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
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
    if(MFAS_mm2d_Z_n_q(bx,by,p,n_nb,vn,q_nb,q,Z_n_q)==0) 
    { 
      InterfError("multim2d: Call of the C function MFAS_mm2d_Z_n_q failed\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
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
    if(Interf.NbParamIn!=5) 
    {
      InterfError("multim2d: You must give 5 input arguments\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    }

    /* Get the input exponents q and verify it */
    Mq=Interf.Param[4];
    if(!MatrixIsNumeric(Mq))
    {
      InterfError("multim2d: The exponents q must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mq))
    {
      InterfError("multim2d: The exponents q must be a real matrix\n");
      return;
    }
    if(MIN(MatrixGetWidth(Mq),MatrixGetHeight(Mq))!=1)
    {
      InterfError("multim2d: The exponents: q must be a real vector\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
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
    if(MFAS_mm2d_tau_q(bx,by,p,q_nb,q,tau_q)==0) 
    { 
      InterfError("multim2d: Call of the C function MFAS_mm2d_tau_q failed\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
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
    if(Interf.NbParamIn!=5) 
    {
      InterfError("multim2d: You must give 5 input arguments\n"); 
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    }
  
    /* Check the output arguments # */
    if(Interf.NbParamOut!=2) 
    {
      InterfError("multim2d: You must give 2 output arguments\n"); 
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    } 

    /* Get the input # of Hoelder exponents and verify it */
    MN=Interf.Param[4];
    if(!MatrixIsNumeric(MN))
    {
      InterfError("multim2d: The # of Hoelder exponents: N must be a numeric matrix\n");
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    } 
    if(!MatrixIsScalar(MN))
    {
      InterfError("multim2d: The # of Hoelder exponents: N must be a scalar\n");  
      /* Transpose input argument */
      MatrixTranspose(Mp);
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
    if(MFAS_mm2ds(N,bx,by,p,alpha,f_alpha)==0)
    { 
      InterfError("multim2d: Call of the C function MFAS_mm2ds failed\n");   
      /* Transpose input argument */
      MatrixTranspose(Mp);
      return;
    }

    /* Return the output arguments */
    ReturnParam(Malpha);
    ReturnParam(Mf_alpha);
  }
  else
  {
    InterfError("multim2d: The string: str is not valid\n"); 
    /* Transpose input argument */
    MatrixTranspose(Mp);
    return;
  }

  /* Transpose input argument */
  MatrixTranspose(Mp);
}
  
/********************/	
#ifndef __STDC__
int MFAS_mm2ds(N, bx, by, p, alpha, f_alpha)
     short int N;
     short int bx;
     short int by;
     double *p;
     double *alpha;
     double *f_alpha;
#else /* __STDC__ */
int MFAS_mm2ds(short N,short bx,short by,double *p,double *alpha,double *f_alpha)
#endif /* __STDC__ */
{
  if((N>0)&&(bx>0)&&(by>0)&&(p!=NULL)&&(alpha!=NULL)&&(f_alpha!=NULL))
  {
    register k=0;
    int q_nb=N;
    /* modif bertrand */
    double q_min=-20.;
    double q_max=20.;
    double d_q=(q_max-q_min)/(double)(q_nb-1);
    double *q=NULL;
    double *tau_q=NULL; 
    if((q=(double*)malloc((unsigned int)sizeof(double)*N))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      return 0;
    } 
    for(k=0;k<q_nb;k++)
      *(q+k)=q_min+k*d_q;
    if((tau_q=(double*)malloc((unsigned int)sizeof(double)*N))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      return 0;
    }  
    if(MFAS_mm2d_tau_q(bx,by,p,q_nb,q,tau_q)==0)
    {
      fprintf(stdout,"MFAS_mm2d_tau_q error\n");
      return 0;
    } 
    if(MFAM_llt(q_nb,q,tau_q,alpha,f_alpha)==0)
    {
      fprintf(stdout,"MFAM_llt error\n");
      return 0;
    }   
    free((char*)q);
    free((char*)tau_q);
    return 1;
  }
  else
  {    
    fprintf(stderr,"MFAS_mm2ds arguments error\n");
    return 0;
  }
}

