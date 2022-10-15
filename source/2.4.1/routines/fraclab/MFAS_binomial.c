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

#include "MFAM_random.h"
#include "MFAS_binomial.h"

#ifndef __STDC__
static void recursive_bm1d();
static void rbm1d();
static void sbm1d();
static void ubm1d();
#else /* __STDC__ */
static void recursive_bm1d(int,int,double,double,double*);
static void rbm1d(int,int,double,double,double,double*);
static void sbm1d(int,int,double,double,double*);
static void ubm1d(int,int,double,double,double*);
#endif /* __STDC__ */

/*****************************************************************************/

#ifndef __STDC__
int MFAS_bm1d(n, p0, mu_n)
     short int n;
     double p0;
     double *mu_n;
#else /* __STDC__ */
int MFAS_bm1d(short n,double p0,double* mu_n)
#endif /* __STDC__ */
{
  if((n>0)&&(p0>0.)&&(p0<1.)&&(mu_n!=NULL))
  {
    short i=1;
    *mu_n=1.;	
    while(i<=n)
    {
      int two_pow_i=(int)pow(2.,(double)i);
      int two_pow_i_1=(int)pow(2.,(double)i-1);
      register int k=two_pow_i-1;
      while(k>=two_pow_i_1)
      {
	*(mu_n+k)=(1-p0)**(mu_n+k-two_pow_i_1);
	k--;	
      }
      while(k>=0)
      {
	*(mu_n+k)=p0**(mu_n+k);
	k--;	
      }
      i++;
    }
    return 1;  
  }
  else
  {
    fprintf(stderr,"MFAS_bm1d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_recursive_bm1d(n, p0, mu_n)
     short int n;
     double p0;
     double *mu_n;
#else /* __STDC__ */
int MFAS_recursive_bm1d(short n,double p0,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(0.<p0)&&(p0<1.)&&(mu_n!=NULL))
   {
      int two_pow_n=(int)pow(2.,(double)n);  
      recursive_bm1d(0,two_pow_n,p0,1.,mu_n);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_recursive_bm1d arguments error\n");
      return 0;
   }
}

/*****************************************************************************/

#ifndef __STDC__
static void recursive_bm1d(k, nu_n, p0, mu, mu_n)
     int k;
     int nu_n;
     double p0;
     double mu;
     double *mu_n;
#else /* __STDC__ */
static void recursive_bm1d(int k,int nu_n,double p0,double mu,double* mu_n)
#endif /* __STDC__ */
{
   if(nu_n>=2)
   {
      recursive_bm1d(k,nu_n/2,p0,mu*p0,mu_n);
      recursive_bm1d(k+nu_n/2,nu_n/2,p0,mu*(1-p0),mu_n);
   }
   else
      *(mu_n+k)=mu;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_sbm1d(n, p0, mu_n)
     short int n;
     double p0;
     double *mu_n;
#else /* __STDC__ */
int MFAS_sbm1d(short n,double p0,double* mu_n)
#endif /* __STDC__ */
{
  if((n>0)&&(0.<p0)&&(p0<1.)&&(mu_n!=NULL))
  {
    time_t time_seed=time(NULL);
    int two_pow_n=(int)pow(2.,(double)n);    
    srand((unsigned)time_seed); 
    sbm1d(0,two_pow_n,p0,1.,mu_n);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_sbm1d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
static void sbm1d(k, nu_n, p0, mu, mu_n)
     int k;
     int nu_n;
     double p0;
     double mu;
     double *mu_n;
#else /* __STDC__ */
static void sbm1d(int k,int nu_n,double p0,double mu,double* mu_n)
#endif /* __STDC__ */
{
  if(nu_n>=2)
  {
    double p[2];
    p[0]=p0;
    p[1]=1-p0;
    MFAM_shuffle(2,p);
    recursive_bm1d(k,nu_n/2,p0,mu*p[0],mu_n);
    recursive_bm1d(k+nu_n/2,nu_n/2,p0,mu*p[1],mu_n);
   }
   else
      *(mu_n+k)=mu;
}
 
/*****************************************************************************/

#ifndef __STDC__
int MFAS_rbm1d(n, p0, epsilon, mu_n)
     short int n;
     double p0;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
int MFAS_rbm1d(short n,double p0,double epsilon,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(0.<=p0)&&(p0<=1.)&&(epsilon>=0.)&&(mu_n!=NULL))
   {
      time_t time_seed=time(NULL);
      int two_pow_n=(int)pow(2.,(double)n);  
      srand((unsigned int)time_seed);
      if(p0==0.)
	rbm1d(0,two_pow_n,1.,0,1,mu_n);
      else
	rbm1d(0,two_pow_n,1.,p0,epsilon,mu_n);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_rbm1d arguments error\n");
      return 0;
   }
}

/*****************************************************************************/

#ifndef __STDC__
static void rbm1d(k, nu_n, mu, p0, epsilon, mu_n)
     int k;
     int nu_n;
     double mu;
     double p0;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
static void rbm1d(int k,int nu_n,double mu,double p0,double epsilon,double* mu_n)
#endif /* __STDC__ */
{
  if(nu_n>=2)
  {
     double P0=MFAM_uniform(p0-epsilon,p0+epsilon);
     rbm1d(k,nu_n/2,mu*P0,p0,epsilon,mu_n);
     rbm1d(k+nu_n/2,nu_n/2,mu*(1-P0),p0,epsilon,mu_n);
  }
  else
    *(mu_n+k)=mu;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_ubm1d(n, epsilon, mu_n)
     short int n;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
int MFAS_ubm1d(short n,double epsilon,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(epsilon>=0.)&&(mu_n!=NULL))
   {
      time_t time_seed=time(NULL);
      int two_pow_n=(int)pow(2.,(double)n);  
      srand((unsigned int)time_seed);
      ubm1d(0,two_pow_n,1.,epsilon,mu_n);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_rbm1d arguments error\n");
      return 0;
   }
}

/*****************************************************************************/

#ifndef __STDC__
static void ubm1d(k, nu_n, mu, epsilon, mu_n)
     int k;
     int nu_n;
     double mu;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
static void ubm1d(int k,int nu_n,double mu,double epsilon,double* mu_n)
#endif /* __STDC__ */
{
   if(nu_n>=2)
   {
      double P0=MFAM_uniform(epsilon,1-epsilon);
      ubm1d(k,nu_n/2,mu*P0,epsilon,mu_n);
      ubm1d(k+nu_n/2,nu_n/2,mu*(1-P0),epsilon,mu_n);
   }
   else
      *(mu_n+k)=mu;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_sumbm1d(n, p01, p02, mu_n)
     short int n;
     double p01;
     double p02;
     double *mu_n;
#else /* __STDC__ */
int MFAS_sumbm1d(short n,double p01,double p02,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(0.<=p01)&&(p01<=1.)&&(0.<=p02)&&(p02<=1.)&&(mu_n!=NULL))
   {
      register int k=0;
      int two_pow_n=(int)pow(2.,(double)n);
      double* tmp_mu_n=NULL; 
      if((tmp_mu_n=(double*)malloc((unsigned)(two_pow_n*sizeof(double))))==NULL)
      {
	 fprintf(stderr,"malloc error\n");
	 return 0;
      }  
      if(MFAS_bm1d(n,p01,tmp_mu_n)==0)
      {
	 fprintf(stderr,"MFAS_bm1d error\n");
	 return 0;
      } 
      for(k=0;k<two_pow_n;k++)
	 *(mu_n+k)=.5**(tmp_mu_n+k);
      if(MFAS_bm1d(n,p02,tmp_mu_n)==0)
      {
	 fprintf(stderr,"MFAS_bm1d error\n");
	 return 0;
      }
      for(k=0;k<two_pow_n;k++)
	 *(mu_n+k)+=.5**(tmp_mu_n+k);
      free((char*)tmp_mu_n);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_sumbm1d arguments error\n");
      return 0;
   }
}


/*****************************************************************************/

#ifndef __STDC__
int MFAS_lumpbm1d(n, p01, p02, mu_n)
     short int n;
     double p01;
     double p02;
     double *mu_n;
#else /* __STDC__ */
int MFAS_lumpbm1d(short n,double p01,double p02,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(n%2==0)&&(0.<=p01)&&(p01<=1.)&&(0.<=p02)&&(p02<=1.)&&(mu_n!=NULL))
   {
      register int k=0;
      int two_pow_n_1=(int)pow(2.,(double)(n-1));
      double* tmp_mu_n_1=NULL;
      if((tmp_mu_n_1=(double*)malloc((unsigned)(two_pow_n_1*sizeof(double))))==NULL)
      {
	 fprintf(stderr,"malloc error\n");
	 return 0;
      }
      if(MFAS_bm1d(n-1,p01,tmp_mu_n_1)==0)
      {
	 fprintf(stderr,"MFAS_bm1d error\n");
	 return 0;
      }
      for(k=0;k<two_pow_n_1;k++)
	 *(mu_n+k)=.5**(tmp_mu_n_1+k); 
      if(MFAS_bm1d(n-1,p02,tmp_mu_n_1)==0)
      {
	 fprintf(stderr,"MFAS_bm1d error\n");
	 return 0;
      }  
      for(k=0;k<two_pow_n_1;k++) 
	 *(mu_n+k+two_pow_n_1)=.5**(tmp_mu_n_1+k);     
      free((char*)tmp_mu_n_1);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_lumpbm1d arguments error\n");
      return 0;
   }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_sumrbm1d(n, p01, p02, epsilon, mu_n)
     short int n;
     double p01;
     double p02;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
int MFAS_sumrbm1d(short n,double p01,double p02,double epsilon,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(0.<=p01)&&(p01<=1.)&&(0.<=p02)&&(p02<=1.)&&(epsilon>=0.)&&(mu_n!=NULL))
   {
      register int k=0;
      int two_pow_n=(int)pow(2.,(double)n);
      double* mu1_n=NULL;
      double* mu2_n=NULL; 
      if((mu1_n=(double*)malloc((unsigned)(two_pow_n*sizeof(double))))==NULL)
      {
	 fprintf(stderr,"malloc error\n");
	 return 0;
      }
      if((mu2_n=(double*)malloc((unsigned)(two_pow_n*sizeof(double))))==NULL)
      {
	 fprintf(stderr,"malloc error\n");
	 return 0;
      }
      if(MFAS_rbm1d(n,p01,epsilon,mu1_n)==0)
      {
	 fprintf(stderr,"MFAS_rbm1d error\n");
	 return 0;
      } 
      for(k=0;k<two_pow_n;k++)
	 *(mu_n+k)=.5**(mu1_n+k);
      free((char*)mu1_n); 
      if(MFAS_rbm1d(n,p02,epsilon,mu2_n)==0)
      {
	 fprintf(stderr,"MFAS_rbm1d error\n");
	 return 0;
      }
      for(k=0;k<two_pow_n;k++)
	 *(mu_n+k)+=.5**(mu2_n+k);
      free((char*)mu2_n);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_sumrbm1d arguments error\n");
      return 0;
   }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_lumprbm1d(n, p01, p02, epsilon, mu_n)
     short int n;
     double p01;
     double p02;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
int MFAS_lumprbm1d(short n,double p01,double p02,double epsilon,double* mu_n)
#endif /* __STDC__ */
{
   if((n>0)&&(n%2==0)&&(0.<=p01)&&(p01<=1.)&&(0.<=p02)&&(p02<=1.)&&(mu_n!=NULL))
   {
      register int k=0;
      int two_pow_n_1=(int)pow(2.,(double)(n-1));
      double* mu1_n_1=NULL;
      double* mu2_n_1=NULL;
      if((mu1_n_1=(double*)malloc((unsigned)(two_pow_n_1*sizeof(double))))==NULL)
      {
	 fprintf(stderr,"malloc error\n");
	 return 0;
      }
      if((mu2_n_1=(double*)malloc((unsigned)(two_pow_n_1*sizeof(double))))==NULL)
      {
	 fprintf(stderr,"malloc error\n");
	 return 0;
      }
      if(MFAS_rbm1d(n-1,p01,epsilon,mu1_n_1)==0)
      {
	 fprintf(stderr,"MFAS_rbm1d error\n");
	 return 0;
      } 
      for(k=0;k<two_pow_n_1;k++)
	 *(mu_n+k)=*(mu1_n_1+k)/2.; 
      free((char*)mu1_n_1);
      if(MFAS_rbm1d(n-1,p02,epsilon,mu2_n_1)==0)
      {
	 fprintf(stderr,"MFAS_rbm1d error\n");
	 return 0;
      }  
      for(k=0;k<two_pow_n_1;k++) 
	 *(mu_n+k+two_pow_n_1)=*(mu2_n_1+k)/2.;     
      free((char*)mu2_n_1);
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_lumprbm1d arguments error\n");
      return 0;
   }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_bm1d_Z_n_q(p0, n_nb, n, q_nb, q, Z_n_q)
     double p0;
     int n_nb;
     short int *n;
     int q_nb;
     double *q;
     double *Z_n_q;
#else /* __STDC__ */
int MFAS_bm1d_Z_n_q(double p0,int n_nb,short* n,int q_nb,double* q,double* Z_n_q)
#endif /* __STDC__ */
{
  if((0.<p0)&&(p0<1.)&&(n_nb>0)&&(n!=NULL)&&(q_nb>0)&&(q!=NULL)&&(Z_n_q!=NULL))
  {
    register int k=0,l=0; 
    double chi_q=0.;
    for(l=0;l<n_nb;l++)
      for(k=0;k<q_nb;k++)
      { 
	chi_q=pow(p0,*(q+k))+pow((1-p0),*(q+k));
	*(Z_n_q+q_nb*l+k)=pow(chi_q,(double)*(n+l));
      }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_bm1d_Z_n_q arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_bm1d_tau_q(p0, q_nb, q, tau_q)
     double p0;
     int q_nb;
     double *q;
     double *tau_q;
#else /* __STDC__ */
int MFAS_bm1d_tau_q(double p0,int q_nb,double* q,double* tau_q)
#endif /* __STDC__ */
{
  if((0.<p0)&&(p0<1.)&&(q_nb>0)&&(q!=NULL)&&(tau_q!=NULL))
  {
    register int k=0;
    double chi_q=0.;
    for(k=0;k<q_nb;k++)
    {
      chi_q=pow(p0,*(q+k))+pow((1-p0),*(q+k));
      *(tau_q+k)=-log(chi_q)/log(2.);
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_bm1d_tau_q arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_bm1dcdf(n, p, f_x)
     int n;
     double p;
     double *f_x;
#else /* __STDC__ */
int MFAS_bm1dcdf(int n,double p,double* f_x)
#endif /* __STDC__ */
{
  if((n>0)&&(p>0.)&&(f_x!=NULL))
  {
    register int k=0;
    int two_pow_n=(int)pow(2.,(double)n),ctwo_pow_n=0;
    *(f_x+two_pow_n)=1.;
    while(n>0)
    { 
      n--;
      ctwo_pow_n=(int)pow(2.,(double)n);
      for(k=ctwo_pow_n;k<two_pow_n;k+=2.*ctwo_pow_n)
	*(f_x+k)=*(f_x+k-ctwo_pow_n)+p*(*(f_x+k+ctwo_pow_n)-*(f_x+k-ctwo_pow_n));
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_bm1dcdf arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_phi_n_k_2(n, k, phi_n_1_k)
     short int n;
     int k;
     int *phi_n_1_k;
#else /* __STDC__ */
int MFAS_phi_n_k_2(short n,int k,int* phi_n_1_k)
#endif /* __STDC__ */
{
  int two_pow_n=pow(2.,(double)n);
  if((n>0)&&(k>=0)&&(k<=two_pow_n)&&(phi_n_1_k!=NULL))
  {
    register int i=0;
    int k_i=0;
    *phi_n_1_k=0;
    for(i=0;i<n;i++)
    {
      k_i=k%2;
      *phi_n_1_k+=k_i;
      k/=2;
    }
  }
  else
  {
    fprintf(stderr,"MFAS_phi_n_k_2 arguments error\n");
    return 0;
  }
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_phi_n_x_2(n, x, phi_n_1_x)
     short int n;
     double x;
     int *phi_n_1_x;
#else /* __STDC__ */
int MFAS_phi_n_x_2(short n,double x,int* phi_n_1_x)
#endif /* __STDC__ */
{
  if((n>0)&&(x>=0.)&&(x<=1.)&&(phi_n_1_x!=NULL))
  {
    int two_pow_n=pow(2.,(double)n),k=x*two_pow_n; 
    if(MFAS_phi_n_k_2(n,k,phi_n_1_x)==0)
    {
      fprintf(stderr,"MFAS_phi_n_k_2 error\n"); 
      return 0;
    }
  }
  else
  {
    fprintf(stderr,"MFAS_phi_n_x_2 arguments error\n");
    return 0;
  }
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_bm1dch(n, p, M, x, alpha_n_x)
     short int n;
     double p;
     int M;
     double *x;
     double *alpha_n_x;
#else /* __STDC__ */
int MFAS_bm1dch(short n,double p,int M,double* x,double* alpha_n_x)
#endif /* __STDC__ */
{
  if((n>0)&&(p>0.)&&(p<1.)&&(*x>=0.)&&(*(x+M-1)<=1.)&&(alpha_n_x!=NULL))
  {
    register int m=0;
    int phi_n_1_x=0;
    for(m=0;m<M;m++)
    {
      if(MFAS_phi_n_x_2(n,*(x+m),&phi_n_1_x)==0)
      {
	fprintf(stderr,"MFAS_phi_n_x_2 error\n"); 
	return 0;
      }
      *(alpha_n_x+m)=-(1-phi_n_1_x/(double)n)*log(p)/log(2.)-phi_n_1_x/(double)n*log(1-p)/log(2.);
    }
    return 1;
  }
  else
  {  
    fprintf(stderr,"MFAS_bm1dch arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_bm1dh(p, Phi_infty_1_x, alpha_x)
     double p;
     double Phi_infty_1_x;
     double *alpha_x;
#else /* __STDC__ */
int MFAS_bm1dh(double p,double Phi_infty_1_x,double* alpha_x)
#endif /* __STDC__ */
{
  if((p>0.)&&(p<1.)&&(Phi_infty_1_x>=0.)&&(Phi_infty_1_x<=1.)&&(alpha_x!=NULL))
  {
    *alpha_x=-(1-Phi_infty_1_x)*log(p)/log(2.)-Phi_infty_1_x*log(1-p)/log(2.);
    return 1;
  }
  else
  {  
    fprintf(stderr,"MFAS_bm1dh arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_x_n_2(n, Phi_infty_1_x, x_n)
     short int n;
     double Phi_infty_1_x;
     double *x_n;
#else /* __STDC__ */
int MFAS_x_n_2(short n,double Phi_infty_1_x,double* x_n)
#endif /* __STDC__ */
{
  if((n>0)&&(Phi_infty_1_x>=0.)&&(Phi_infty_1_x<=1.)&&(x_n!=NULL))
  {
    register int i=0;
    int phi_n_1_x=n*Phi_infty_1_x,k=0.;
    for(i=0;i<phi_n_1_x;i++)
      k+=pow(2.,(double)i);
    *x_n=(double)k/pow(2.,(double)n);
    return 1;
  }
  else
  {  
    fprintf(stderr,"MFAS_x_n_2 arguments error\n");
    return 0;
  }
}
