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

#include "MFAS_multinomial.h"

#ifndef __STDC__
static void recursive_mm1d();
static void smm1d();
static void umm1d();
static void rmm1d();
#else /* __STDC__ */
static void recursive_mm1d(short,int,int,double*,double,double*);
static void smm1d(short,int,int,double*,double,double*);
static void umm1d(short,int,int,double,double,double*);
static void rmm1d(short,int,int,double*,double,double,double*);
#endif /* __STDC__ */

/******************************************************************************/

#ifndef __STDC__
int MFAS_mm1d(n, b, p, mu_n)
     short int n;
     short int b;
     double *p;
     double *mu_n;
#else /* __STDC__ */
int MFAS_mm1d(short n,short b,double* p,double* mu_n)
#endif /* __STDC__ */
{ 
   if((n>0)&&(b>0)&&(p!=NULL)&&(mu_n!=NULL))
   {
      register int i=1;
      *mu_n=1.;	
      while(i<=n)
      {
	 int b_pow_i=(int)pow((double)b,(double)i);
	 int b_pow_i_1=(int)pow((double)b,(double)i-1);
	 register int k=b_pow_i-1;
	 short j=b-1;
	 while(j>=0)
	 {
	    while(k>=j*b_pow_i_1)
	    {
	       *(mu_n+k)=*(p+j)**(mu_n+k-j*b_pow_i_1);
	       k--;
	    }
	    j--;
	 }
	 i++;
      }
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_mm1d arguments error\n");
      return 0;
   }
}

/******************************************************************************/

#ifndef __STDC__
int MFAS_recursive_mm1d(n, b, p, mu_n)
     short int n;
     short int b;
     double *p;
     double *mu_n;
#else /* __STDC__ */
int MFAS_recursive_mm1d(short n,short b,double* p,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(b>0)&&(p!=NULL)&&(mu_n!=NULL))
   {
      int b_pow_n=(int)pow((double)b,(double)n);
      recursive_mm1d(b,0,b_pow_n,p,1.,mu_n);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_recursive_mm1d error\n");
      return 0;
   }
}

/******************************************************************************/

#ifndef __STDC__
static void recursive_mm1d(b, k, nu_n, p, mu, mu_n)
     short int b;
     int k;
     int nu_n;
     double *p;
     double mu;
     double *mu_n;
#else /* __STDC__ */
static void recursive_mm1d(short b,int k,int nu_n,double* p,double mu,double* mu_n)
#endif /* __STDC__ */
{ 
   if(nu_n>=b)
   {
      short j=0;
      for(j=0;j<b;j++)
	 recursive_mm1d(b,k+j*nu_n/b,nu_n/b,p,mu**(p+j),mu_n);
   }
   else
      *(mu_n+k)=mu;
} 

/******************************************************************************/

#ifndef __STDC__
int MFAS_umm1d(n, b, epsilon, mu_n)
     short int n;
     short int b;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
int MFAS_umm1d(short n,short b,double epsilon,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(b>0)&&(epsilon>=0.)&&(mu_n!=NULL))
   { 
      time_t time_seed=time(NULL);
      int b_pow_n=(int)pow((double)b,(double)n);   
      srand((unsigned)time_seed);
      umm1d(b,0,b_pow_n,epsilon,1.,mu_n);  
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_umm1d arguments error\n");
      return 0;
   }
}

/******************************************************************************/

#ifndef __STDC__
static void umm1d(b, k, nu_n, epsilon, mu, mu_n)
     short int b;
     int k;
     int nu_n;
     double epsilon;
     double mu;
     double *mu_n;
#else /* __STDC__ */
static void umm1d(short b,int k,int nu_n,double epsilon,double mu,double* mu_n)
#endif /* __STDC__ */
{ 
  if((nu_n>=b))
  {
    short j=0;    
    double sum_P=0.;
    double* P=NULL;
    if((P=(double*)malloc((unsigned)(b*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      exit(0);
    } 
    for(j=0;j<b;j++)
      sum_P+=*(P+j)=MFAM_uniform(epsilon,1-epsilon);  
    for(j=0;j<b;j++)
      umm1d(b,k+j*nu_n/b,nu_n/b,epsilon,mu**(P+j)/sum_P,mu_n);
    free((char*)P);
  }
  else
    *(mu_n+k)=mu;
}

/******************************************************************************/

#ifndef __STDC__
int MFAS_smm1d(n, b, p, mu_n)
     short int n;
     short int b;
     double *p;
     double *mu_n;
#else /* __STDC__ */
int MFAS_smm1d(short n,short b,double* p,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(b>0)&&(p!=NULL)&&(mu_n!=NULL))
   {
      time_t time_seed=time(NULL);
      int b_pow_n=(int)pow((double)b,(double)n);
      srand((unsigned)time_seed);
      smm1d(b,0,b_pow_n,p,1.,mu_n);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_smm1d arguments error\n");
      return 0;
   }
}

/******************************************************************************/

#ifndef __STDC__
static void smm1d(b, k, nu_n, p, mu, mu_n)
     short int b;
     int k;
     int nu_n;
     double *p;
     double mu;
     double *mu_n;
#else /* __STDC__ */
static void smm1d(short b,int k,int nu_n,double* p,double mu,double* mu_n)
#endif /* __STDC__ */
{
   if(nu_n>=b)
   {
      short j=0;
      MFAM_shuffle(b,p);
      for(j=0;j<b;j++)
	 smm1d(b,k+j*nu_n/b,nu_n/b,p,mu**(p+j),mu_n);
   }
   else
      *(mu_n+k)=mu;
}

/******************************************************************************/

#ifndef __STDC__
int MFAS_rmm1d(n, b, p, epsilon, mu_n)
     short int n;
     short int b;
     double *p;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
int MFAS_rmm1d(short n,short b,double* p,double epsilon,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(b>0)&&(p!=NULL)&&(epsilon>=0.)&&(mu_n!=NULL))
   {
      time_t time_seed=time(NULL);
      int b_pow_n=(int)pow((double)b,(double)n);
      srand((unsigned)time_seed);
      rmm1d(b,0,b_pow_n,p,epsilon,1.,mu_n);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_rmm1d arguments error\n");
      return 0;
   }
}

/******************************************************************************/

#ifndef __STDC__
static void rmm1d(b, k, nu_n, p, epsilon, mu, mu_n)
     short int b;
     int k;
     int nu_n;
     double *p;
     double epsilon;
     double mu;
     double *mu_n;
#else /* __STDC__ */
static void rmm1d(short b,int k,int nu_n,double* p,double epsilon,double mu,double* mu_n)
#endif /* __STDC__ */
{
   if(nu_n>=b)
   {
      short j=0;
      double sum_P=0.,*P=NULL;
      if((P=(double*)malloc((unsigned)(b*sizeof(double))))==NULL)
      {
	 fprintf(stderr,"malloc error\n");
	 exit(0);
      }
      for(j=0;j<b;j++)
	 sum_P+=*(P+j)=MFAM_uniform(*(p+j)-epsilon,*(p+j)+epsilon);
      for(j=0;j<b;j++)
	rmm1d(b,k+j*nu_n/b,nu_n/b,p,epsilon,mu**(P+j)/sum_P,mu_n);
      free((char*)P);
   }
   else
      *(mu_n+k)=mu;
}

/******************************************************************************/

#ifndef __STDC__
int MFAS_mm1d_Z_n_q(b, p, n_nb, n, Q, q, Z_n_q)
     short int b;
     double *p;
     int n_nb;
     short int *n;
     int Q;
     double *q;
     double *Z_n_q;
#else /* __STDC__ */
int MFAS_mm1d_Z_n_q(short b,double* p,int n_nb,short* n,int Q,double* q,double* Z_n_q)
#endif /* __STDC__ */
{
  if((b>0)&&(p!=NULL)&&(n_nb>0)&&(n!=NULL)&&(Q>0)&&(q!=NULL)&&(Z_n_q!=NULL))
  {
    register int k=0,l=0;
    short j=0;
    double chi_q=0.;
    for(l=0;l<n_nb;l++)
      for(k=0;k<Q;k++)
      {
	for(j=0;j<b;j++)
	  chi_q+=pow(*(p+j),*(q+k));
	*(Z_n_q+Q*l+k)=pow(chi_q,(double)*(n+l));
	chi_q=0.;
      }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_mm1d_Z_n_q arguments error\n");
    return 0;
  }
}

/******************************************************************************/

#ifndef __STDC__
int MFAS_mm1d_tau_q(b, p, Q, q, tau_q)
     short int b;
     double *p;
     int Q;
     double *q;
     double *tau_q;
#else /* __STDC__ */
int MFAS_mm1d_tau_q(short b,double* p,int Q,double* q,double* tau_q)
#endif /* __STDC__ */
{
  if((b>0)&&(p!=NULL)&&(q!=NULL)&&(tau_q!=NULL))
  {
    register int k=0;
    short j=0;
    double chi_q=0.;
    for(k=0;k<Q;k++)
    {  
      for(j=0;j<b;j++)
	chi_q+=pow(*(p+j),*(q+k));
      *(tau_q+k)=-log(chi_q)/log((double)b); 
      chi_q=0.;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_mm1d_tau_q arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_phi_n_k_b(n, b, k, phi_n_k)
     short int n;
     short int b;
     int k;
     int *phi_n_k;
#else /* __STDC__ */
int MFAS_phi_n_k_b(short n,short b,int k,int* phi_n_k)
#endif /* __STDC__ */
{
  int b_pow_n=pow((double)b,(double)n);
  if((n>0)&&(b>1)&&(k>=0)&&(k<=b_pow_n)&&(phi_n_k!=NULL))
  {
    register int i=0;
    int k_i=0;
    for(i=0;i<b;i++)
      *(phi_n_k+i)=0.; 
    for(i=0;i<n;i++)
    {
      k_i=k%b;
      *(phi_n_k+k_i)+=1;
      k/=b;
    }
  }
  else
  {
    fprintf(stderr,"MFAS_phi_n_k_b arguments error\n");
    return 0;
  }
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_phi_n_x_b(n, b, x, phi_n_x)
     short int n;
     short int b;
     double x;
     int *phi_n_x;
#else /* __STDC__ */
int MFAS_phi_n_x_b(short n,short b,double x,int* phi_n_x)
#endif /* __STDC__ */
{
  if((n>0)&&(b>1)&&(x>=0.)&&(x<=1.)&&(phi_n_x!=NULL))
  {
    int b_pow_n=pow((double)b,(double)n),k=x*b_pow_n; 
    if(MFAS_phi_n_k_b(n,b,k,phi_n_x)==0)
    {
      fprintf(stderr,"MFAS_phi_n_k_b error\n"); 
      return 0;
    }
  }
  else
  {
    fprintf(stderr,"MFAS_phi_n_x_b arguments error\n");
    return 0;
  }
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_mm1dch(n, b, p, M, x, alpha_n_x)
     short int n;
     short int b;
     double *p;
     int M;
     double *x;
     double *alpha_n_x;
#else /* __STDC__ */
int MFAS_mm1dch(short n,short b,double* p,int M,double* x,double* alpha_n_x)
#endif /* __STDC__ */
{
  if((n>0)&&(b>1)&&(p!=NULL)&&(*x>=0.)&&(*(x+M-1)<=1.)&&(alpha_n_x!=NULL))
  {
    register int i=0,m=0;
    int* phi_n_x=NULL; 
    if((phi_n_x=(int*)malloc((unsigned)(b*sizeof(int))))==NULL) 
    {
      fprintf(stderr,"malloc error\n"); 
      return 0;
    }
    for(m=0;m<M;m++)
    { 
      if(MFAS_phi_n_x_b(n,b,*(x+m),phi_n_x)==0)
      {
	fprintf(stderr,"MFAS_phi_n_x_b error\n"); 
	return 0;
      }
      for(i=0;i<b;i++)
	*(alpha_n_x+m)+=-*(phi_n_x+i)/(double)n*log(*(p+i))/log((double)b);
    }
    free((char*)phi_n_x);
    return 1;
  }
  else
  {  
    fprintf(stderr,"MFAS_mm1dch arguments error\n");
    return 0;
  }
}
