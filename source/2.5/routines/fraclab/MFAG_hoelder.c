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

#include "MFAG_hoelder.h"

/*****************************************************************************/
/* on measures                                                               */
/*****************************************************************************/

/*****************************************************************************/
/* \alpha_n^k=-\frac{\log\mu(I_n^k)}{\log(2^n)}                              */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_2_n(n, mu_n, alpha_n)
     short int n;
     double *mu_n;
     double *alpha_n;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_2_n(n, mu_n, alpha_n)
     short int n;
     double *mu_n;
     double *alpha_n;
#else /* __STDC__ */
int MFAG_alpha_2_n(short n,double* mu_n,double* alpha_n)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(mu_n!=NULL)&&(alpha_n!=NULL))
  {
    register int k=0;
    int two_pow_n=(int)pow(2.,(double)n);
    for(k=0;k<two_pow_n;k++)
    {
      if(*(mu_n+k)!=0.)
	*(alpha_n+k)=-log(*(mu_n+k))/log(two_pow_n);
      else
	*(alpha_n+k)=HUGE;
    } 
    return 1;
  }
  else
  {
    fprintf(stdout,"MFAG_alpha_2_n arguments error\n");
    return 0;
  }   
}

/*****************************************************************************/
/* \alpha_n^{i,j}=-\frac{\log\mu(I_n^{i,j})}{\log(2^n)}                      */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_2_n2d(n, mu_n, alpha_n)
     short int n;
     double *mu_n;
     double *alpha_n;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_2_n2d(n, mu_n, alpha_n)
     short int n;
     double *mu_n;
     double *alpha_n;
#else /* __STDC__ */
int MFAG_alpha_2_n2d(short n,double* mu_n,double* alpha_n)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(mu_n!=NULL)&&(alpha_n!=NULL))
  {
    register int i=0,j=0;  
    int two_pow_n=(int)pow(2.,(double)n);
    for(j=0;j<two_pow_n;j++)
    {
      for(i=0;i<two_pow_n;i++)
      {
	if(*(mu_n+two_pow_n*j+i)!=0.)
	  *(alpha_n+two_pow_n*j+i)=-log(*(mu_n+two_pow_n*j+i))/log((double)two_pow_n);
	else
	  *(alpha_n+two_pow_n*j+i)=HUGE;
      }
    }
    return 1;
  }
  else
  {
    fprintf(stdout,"MFAG_alpha_n_2d arguments error\n");
    return 0;
  }   
}

/*****************************************************************************/
/* \alpha_n^{k,star}                                                         */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_star_2_n(n, mu_n, alpha_star_n)
     short int n;
     double *mu_n;
     double *alpha_star_n;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_star_2_n(n, mu_n, alpha_star_n)
     short int n;
     double *mu_n;
     double *alpha_star_n;
#else /* __STDC__ */
int MFAG_alpha_star_2_n(short n,double* mu_n,double* alpha_star_n)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(mu_n!=NULL)&&(alpha_star_n!=NULL))
  {
    int two_pow_n=(int)pow(2.,(double)n);
    double mu=0.;
    register int k=0;
    for(k=1;k<two_pow_n-1;k++)
      if((*(mu_n+k)!=0.)&&((mu=-log(*(mu_n+k-1)+*(mu_n+k)+*(mu_n+k+1)))!=0.))
	*(alpha_star_n+k)=-log(mu)/log(two_pow_n);
      else
	*(alpha_star_n+k)=HUGE;
    return 1;
  }
  else
  {
    fprintf(stdout,"MFAG_alpha_star_2_n arguments error\n");
    return 0;
  }   
}

/*****************************************************************************/
/* \alpha_n^k=-\frac{\log\mu(I_n^k)}{\log(N_n)}                             */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_n(N_n, mu_n, alpha_n)
     int N_n;
     double *mu_n;
     double *alpha_n;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_n(N_n, mu_n, alpha_n)
     int N_n;
     double *mu_n;
     double *alpha_n;
#else /* __STDC__ */
int MFAG_alpha_n(int N_n,double* mu_n,double* alpha_n)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((N_n>0)&&(mu_n!=NULL)&&(alpha_n!=NULL))
  {
    register int k=0;
    for(k=0;k<N_n;k++)
    {
      if(*(mu_n+k)!=0.)
	*(alpha_n+k)=-log(*(mu_n+k))/log((double)N_n);
      else
	*(alpha_n+k)=HUGE;
    }
      return 1;
  }
  else
  {
    fprintf(stdout,"MFAG_alpha_n arguments error\n");
    return 0;
  }   
}

/*****************************************************************************/
/* \alpha_n^k=-2\frac{\log\mu(I_n^k)}{\log(nux_n nuy_n)}                     */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_n2d(nux_n, nuy_n, mu_n, alpha_n)
     int nux_n;
     int nuy_n;
     double *mu_n;
     double *alpha_n;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_n2d(nux_n, nuy_n, mu_n, alpha_n)
     int nux_n;
     int nuy_n;
     double *mu_n;
     double *alpha_n;
#else /* __STDC__ */
int MFAG_alpha_n2d(int nux_n,int nuy_n,double* mu_n,double* alpha_n)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((nux_n>0)&&(nuy_n>0)&&(mu_n!=NULL)&&(alpha_n!=NULL))
  {
    register int i=0,j=0;
    for(j=0;j<nuy_n;j++)
    {
      for(i=0;i<nux_n;i++)
      {
	if(*(mu_n+nux_n*j+i)!=0.)
	  *(alpha_n+nux_n*j+i)=-2*log(*(mu_n+nux_n*j+i))/log((double)nux_n*nuy_n);
	else
	  *(alpha_n+nux_n*j+i)=HUGE;
      }
    }
    return 1;
  } 
  else
  {
    fprintf(stderr,"MFAG_alpha_n2d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* \alpha_eta^k=\frac{\log\mu(I_\eta^k)}{\log(\eta)}                         */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_eta(N_n, mu_n, eta, alpha_eta)
     int N_n;
     double *mu_n;
     double eta;
     double *alpha_eta;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_eta(N_n, mu_n, eta, alpha_eta)
     int N_n;
     double *mu_n;
     double eta;
     double *alpha_eta;
#else /* __STDC__ */
int MFAG_alpha_eta(int N_n,double* mu_n,double eta,double* alpha_eta)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  double eta_n=1./(double)N_n;
  if((N_n>0)&&(mu_n!=NULL)&&(eta>=eta_n)&&(alpha_eta!=NULL))
  {
    register int k=0;
    double mu_eta=0.;
    for(k=0;k<N_n;k++)
    {
      if((*(mu_n+k)!=0.)&&((mu_eta=MFAM_mu_eta(N_n,mu_n,k,eta))!=0.))
	*(alpha_eta+k)=log(mu_eta)/log(eta);
      else
	*(alpha_eta+k)=HUGE;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_alpha_eta arguments error\n");
    return 0;
  }   
}

/*****************************************************************************/
/*                                                                           */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_eta_j(N_n, mu_n, eta_j, alpha_eta_j)
     int N_n;
     double *mu_n;
     double eta_j;
     double *alpha_eta_j;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_eta_j(N_n, mu_n, eta_j, alpha_eta_j)
     int N_n;
     double *mu_n;
     double eta_j;
     double *alpha_eta_j;
#else /* __STDC__ */
int MFAG_alpha_eta_j(int N_n,double* mu_n,double eta_j,double* alpha_eta_j)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  double eta_n=1./(double)N_n;
  if((N_n>0)&&(mu_n!=NULL)&&(eta_j>=eta_n)&&(alpha_eta_j!=NULL))
  {
    register int k=0,l=0;
    int nu_j=(int)(1./eta_j);
    double mu_eta_j=0.;
    for(k=0;k<nu_j;k++)
    {
      for(l=0;l<(int)N_n/nu_j;l++)
	mu_eta_j+=*(mu_n+(int)N_n/nu_j*k+l);
      if(mu_eta_j!=0.)
      {
	*(alpha_eta_j+(int)N_n/nu_j*k)=log(mu_eta_j)/log(eta_j);
	for(l=0;l<(int)N_n/nu_j;l++)
	  *(alpha_eta_j+(int)N_n/nu_j*k+l)=*(alpha_eta_j+(int)N_n/nu_j*k);
      }
      else
	for(l=0;l<(int)N_n/nu_j;l++)
	  *(alpha_eta_j+(int)N_n/nu_j*k+l)=HUGE;
      mu_eta_j=0.;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_alpha_eta_j arguments error\n");
    return 0;
  }   
}

/*****************************************************************************/
/* \alpha_\eta(x):=\frac{\log(\mu([x,x+\eta))}{\log(\eta)}                   */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_eta_x(N_n, I_n, mu_n, eta, M, i_x, f_x, dx, alpha_eta_x)
     int N_n;
     double *I_n;
     double *mu_n;
     double eta;
     int M;
     double i_x;
     double f_x;
     double dx;
     double *alpha_eta_x;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_eta_x(N_n, I_n, mu_n, eta, M, i_x, f_x, dx, alpha_eta_x)
     int N_n;
     double *I_n;
     double *mu_n;
     double eta;
     int M;
     double i_x;
     double f_x;
     double dx;
     double *alpha_eta_x;
#else /* __STDC__ */
int MFAG_alpha_eta_x(int N_n,double* I_n,double* mu_n,double eta,int M,double i_x,double f_x,double dx,double* alpha_eta_x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
   double  eta_n=1./N_n;
   if((N_n>0)&&(mu_n!=NULL)&&(eta+1e-10>=eta_n>=eta-1e-10)&&(M>0)&&(i_x<f_x)&&(dx>0.)&&(alpha_eta_x!=NULL))
   {
     register int m=0;
     double mu_eta_x=0.;
     FRflg=1;
     for(m=0;m<M;m++)
     { 	  
       if((mu_eta_x=MFAM_mu_eta_x(N_n,I_n,mu_n,eta,i_x,f_x,i_x+m*dx))!=0.)
	 *(alpha_eta_x+m)=log(mu_eta_x)/log(eta);
       else
	 *(alpha_eta_x+m)=HUGE;
     }
     return 1;
   }
   else
   {
     fprintf(stderr,"MFAG_alpha_eta_x arguments error\n");
     return 0.;
   }
}

/*****************************************************************************/
/* \alpha_\eta^\star(x):=\frac{\log(\mu([x,x+\eta))}{\log(\eta)}             */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_eta_star_x(N_n, I_n, mu_n, eta, M, x_min, x_max, dx, alpha_eta_star_x)
     int N_n;
     double *I_n;
     double *mu_n;
     double eta;
     int M;
     double x_min;
     double x_max;
     double dx;
     double *alpha_eta_star_x;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_eta_star_x(N_n, I_n, mu_n, eta, M, x_min, x_max, dx, alpha_eta_star_x)
     int N_n;
     double *I_n;
     double *mu_n;
     double eta;
     int M;
     double x_min;
     double x_max;
     double dx;
     double *alpha_eta_star_x;
#else /* __STDC__ */
int MFAG_alpha_eta_star_x(int N_n,double* I_n,double* mu_n,double eta,int M,double x_min,double x_max,double dx,double* alpha_eta_star_x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  double eta_n=1./N_n;
  if((N_n>0)&&(mu_n!=NULL)&&(eta>=eta_n)&&(M>0)&&(x_min<x_max)&&(dx>0.)&&(alpha_eta_star_x!=NULL))
  {
    register int m=0;
    double mu_eta_star_x=0.;   
    FRflg=1;
    for(m=0;m<M;m++)
    { 
      if((mu_eta_star_x=MFAM_mu_eta_star_x(N_n,I_n,mu_n,eta,x_min,x_max,x_min+m*dx))!=0.)
	*(alpha_eta_star_x+m)=log(mu_eta_star_x)/log(eta);
      else
	*(alpha_eta_star_x+m)=HUGE; 
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_alpha_eta_star_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/
/* \alpha_\eta(x):=\frac{\log(\mu([x-\frac{\eta}{2},x+\frac{\eta}{2}))}      */
/* {\log(\eta)}                                                              */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_eta_c_x(N_n, I_n, mu_n, eta, M, x_min, x_max, dx, alpha_eta_c_x)
     int N_n;
     double *I_n;
     double *mu_n;
     double eta;
     int M;
     double x_min;
     double x_max;
     double dx;
     double *alpha_eta_c_x;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_eta_c_x(N_n, I_n, mu_n, eta, M, x_min, x_max, dx, alpha_eta_c_x)
     int N_n;
     double *I_n;
     double *mu_n;
     double eta;
     int M;
     double x_min;
     double x_max;
     double dx;
     double *alpha_eta_c_x;
#else /* __STDC__ */
int MFAG_alpha_eta_c_x(int N_n,double* I_n,double* mu_n,double eta,int M,double x_min,double x_max,double dx,double* alpha_eta_c_x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  double eta_n=1./N_n;
  if((N_n>0)&&(mu_n!=NULL)&&(eta>=eta_n)&&(M>0)&&(x_min<x_max)&&(dx>0.)&&(alpha_eta_c_x!=NULL))
  {
    register int m=0;
    double mu_eta_c_x=0.; 
    FRflg=1;
    for(m=0;m<M;m++)
    { 
      if((mu_eta_c_x=MFAM_mu_eta_c_x(N_n,I_n,mu_n,eta,x_min,x_max,x_min+m*dx))!=0.)
	*(alpha_eta_c_x+m)=log(mu_eta_c_x)/log(eta);
      else
	*(alpha_eta_c_x+m)=HUGE; 
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_alpha_eta_c_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_mch1d(N_n, I_n, mu_n, t_prog, t_ball, J, a, A, M, eta, x, alpha_eta_x)
     int N_n;
     double *I_n;
     double *mu_n;
     MFAMt_prog t_prog;
     MFAMt_ball t_ball;
     short int J;
     double a;
     double A;
     int M;
     double *eta;
     double *x;
     double *alpha_eta_x;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_mch1d(N_n, I_n, mu_n, t_prog, t_ball, J, a, A, M, eta, x, alpha_eta_x)
     int N_n;
     double *I_n;
     double *mu_n;
     MFAMt_prog t_prog;
     MFAMt_ball t_ball;
     short int J;
     double a;
     double A;
     int M;
     double *eta;
     double *x;
     double *alpha_eta_x;
#else /* __STDC__ */
int MFAG_mch1d(int N_n,double* I_n,double* mu_n,MFAMt_prog t_prog,MFAMt_ball t_ball,short J,double a,double A,int M,double* eta,double* x,double* alpha_eta_x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((N_n>0)&&(mu_n!=NULL)&&(J>0)&&(a>=1.)&&(A>=a)&&(M>=N_n)&&(eta!=NULL)&&(alpha_eta_x!=NULL))
  { 
    double eta_n=1./N_n;
    if(MFAM_scale(N_n,a,A,J,eta,t_prog)==0)
    {
      fprintf(stderr,"MFAM_scale error\n"); 
      return 0;
    }
    if((M==N_n)&&(J==1)&&(t_ball==MFAM_ASYMMETRIC))
    {
      if(*eta==eta_n)
      {
	if(MFAG_alpha_n(N_n,mu_n,alpha_eta_x)==0)  
	{  
	  fprintf(stderr,"MFAG_alpha_n error\n");  
	  return 0;  
	}	
      }
      else /* eta>eta_n */
      { 
	if(MFAG_alpha_eta(N_n,mu_n,*eta,alpha_eta_x)==0) 
	{ 
	  fprintf(stderr,"MFAG_alpha_eta error\n"); 
	  return 0; 
	} 
      } 
      if(x!=NULL)
      {
	register int m=0;
	*x=0.;
	if(I_n!=NULL)
	  for(m=0;m<M;m++)
	    *(x+m)=*(I_n+m);
	else /* I_n==NULL */
	  for(m=1;m<M;m++)
	    *(x+m)=*(x+m-1)+*eta;
      }
    }
    else if(t_prog==MFAM_DEC)
    {
      register int j=0;
      double x_max=0.;
      for(j=0;j<J;j++)
      {
	if(MFAG_alpha_eta_j(N_n,mu_n,*(eta+j),alpha_eta_x+M*j)==0)
        {
	  fprintf(stderr,"MFAG_alpha_eta_j error\n");  
	  return 0;  
	}
	if(x!=NULL)
	{
	  x_max=1-*(eta+j);
	  if(MFAM_linspace(M,0.,x_max,x+M*j)==0)  
	  {  
	    fprintf(stderr,"MFAG_linspace error\n");  
	    return 0;  
	  }
	}
      }
    }
    else if((M!=N_n)||(J!=1)||(t_ball!=MFAM_ASYMMETRIC))
    {  
      register int j=0;
      double x_min=0.,x_max=0.,dx=0.;
      for(j=0;j<J;j++)
      {
	switch(t_ball)
	{
	case MFAM_ASYMMETRIC:
	  x_min=0.,x_max=1.-*(eta+j),dx=(1-*(eta+j))/(double)(M-1); 
	  if(MFAG_alpha_eta_x(N_n,I_n,mu_n,*(eta+j),M,x_min,x_max,dx,alpha_eta_x+M*j)==0)  
	  {  
	    fprintf(stderr,"MFAG_alpha_eta_x error\n");  
	    return 0;  
	  }
	  break;
	case MFAM_STAR:
	  x_min=*(eta+j),x_max=1.-2**(eta+j),dx=(1-3**(eta+j))/(double)(M-1);
	  if(MFAG_alpha_eta_star_x(N_n,I_n,mu_n,*(eta+j),M,x_min,x_max,dx,alpha_eta_x+M*j)==0)  
	  {  
	    fprintf(stderr,"MFAG_alpha_eta_star_x error\n");  
	    return 0;  
	  }
	  break;
	case MFAM_CENTERED:
	  x_min=*(eta+j)/2.,x_max=1.-*(eta+j)/2.,dx=(1-*(eta+j))/(double)(M-1);
	  if(MFAG_alpha_eta_c_x(N_n,I_n,mu_n,*(eta+j),M,x_min,x_max,dx,alpha_eta_x+M*j)==0)  
	  {  
	    fprintf(stderr,"MFAG_alpha_eta_c_x error\n");  
	    return 0;  
	  }
	  break;
	}
	if(x!=NULL)
	{
	  if(MFAM_linspace(M,x_min,x_max,x+M*j)==0)  
	  {  
	    fprintf(stderr,"MFAG_linspace error\n");  
	    return 0;  
	  }
	}
      } 
    }
    return 1;
  }
  else
  { 
    fprintf(stderr,"MFAG_mch1d arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/
/* on functions                                                              */
/*****************************************************************************/

/*****************************************************************************/

#ifndef __STDC__
int MFAG_flh_eta(eta, M, osc_eta_x, flh_eta)
     double eta;
     int M;
     double *osc_eta_x;
     double *flh_eta;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_flh_eta(eta, M, osc_eta_x, flh_eta)
     double eta;
     int M;
     double *osc_eta_x;
     double *flh_eta;
#else /* __STDC__ */
int MFAG_flh_eta(double eta,int M,double* osc_eta_x,double* flh_eta)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((eta>0.)&&(M>0)&&(osc_eta_x!=NULL)&&(flh_eta!=NULL))
  {
    register int k=0;
    for(k=0;k<M;k++)
    {
      if((*(osc_eta_x+k)!=HUGE)&&(*(osc_eta_x+k)!=0))
	*(flh_eta+k)=log(*(osc_eta_x+k))/log(eta);
      else
	*(flh_eta+k)=HUGE;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_flh_eta arguments error\n"); 
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_fph_eta(eta, M, dx, osc_eta_x, fph_eta)
     double eta;
     int M;
     double *dx;
     double *osc_eta_x;
     double *fph_eta;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_fph_eta(eta, M, dx, osc_eta_x, fph_eta)
     double eta;
     int M;
     double *dx;
     double *osc_eta_x;
     double *fph_eta;
#else /* __STDC__ */
int MFAG_fph_eta(double eta,int M,double* dx,double* osc_eta_x,double* fph_eta)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((eta>0.)&&(M>0)&&(dx!=NULL)&&(osc_eta_x!=NULL)&&(fph_eta!=NULL))
  {
    register int k=0;
    for(k=0;k<M;k++)
    {
      if((*(osc_eta_x+k)!=HUGE)&&(*(osc_eta_x+k)!=0))
	*(fph_eta+k)=log(*(osc_eta_x+k))/log(*(dx+k));
      else
	*(fph_eta+k)=HUGE;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_fph_eta arguments error\n"); 
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_fch1d(M, x, f_x, J, a, A, t_prog, t_osc, p, alpha_eta_x, eta)
     int M;
     double *x;
     double *f_x;
     short int J;
     double a;
     double A;
     MFAMt_prog t_prog;
     MFAMt_osc t_osc;
     double p;
     double *alpha_eta_x;
     double *eta;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_fch1d(M, x, f_x, J, a, A, t_prog, t_osc, p, alpha_eta_x, eta)
     int M;
     double *x;
     double *f_x;
     short int J;
     double a;
     double A;
     MFAMt_prog t_prog;
     MFAMt_osc t_osc;
     double p;
     double *alpha_eta_x;
     double *eta;
#else /* __STDC__ */
int MFAG_fch1d(int M,double* x,double* f_x,short J,double a,double A,MFAMt_prog t_prog,MFAMt_osc t_osc,double p,double* alpha_eta_x,double* eta)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(f_x!=NULL)&&(J>=0)&&(a>=1.)&&(A>=a)&&(alpha_eta_x!=NULL)&&(eta!=NULL))
  {   
    register int j=0;
    double dx=1./M;
    double* deltax=NULL;
    double* osc_eta_x=NULL; 
    if(MFAM_scale(M,a,A,J,eta,t_prog)==0)
    {
      fprintf(stderr,"MFAM_scale error\n"); 
      return 0;
    }  
    if((osc_eta_x=(double*)malloc((unsigned)(M*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n"); 
      return 0;
    }
    for(j=0;j<J;j++)
    {
      switch(t_osc)
      {
      case MFAM_OSC:
	if(MFAM_osc_eta_x(M,dx,f_x,*(eta+j),osc_eta_x)==0)
	{
	  fprintf(stderr,"MFAM_osc_eta_x error\n"); 
	  return 0;
	}
	break;
      case MFAM_OSCDELTA:
	if((deltax=(double*)malloc((unsigned)(M*sizeof(double))))==NULL)
	{
	  fprintf(stderr,"malloc error\n"); 
	  return 0;
	}
	if(MFAM_osc_eta_deltax(M,dx,f_x,*(eta+j),deltax,osc_eta_x)==0)
	{
	  fprintf(stderr,"MFAM_osc_eta_deltax error\n"); 
	  return 0;
	}
	break;
      case MFAM_LINFTY:
	if(MFAM_Linfty_eta_x(M,dx,f_x,*(eta+j),osc_eta_x)==0)
	{
	  fprintf(stderr,"MFAM_Linfty_eta_x error\n"); 
	  return 0;
	}
	break;
      case MFAM_LP:
	if(MFAM_Lp_eta_x(M,dx,f_x,p,*(eta+j),osc_eta_x)==0)
	{
	  fprintf(stderr,"MFAM_Lp_eta_x error\n"); 
	  return 0;
	}
	break;
      }
      if(t_osc!=MFAM_OSCDELTA)
      {
	if(MFAG_flh_eta(*(eta+j),M,osc_eta_x,alpha_eta_x+M*j)==0)
	{
	  fprintf(stderr,"MFAG_flh_eta error\n"); 
	  return 0;
	}
      }
      else
      {
	if(MFAG_fph_eta(*(eta+j),M,deltax,osc_eta_x,alpha_eta_x+M*j)==0)
	{
	  fprintf(stderr,"MFAG_fph_eta error\n"); 
	  return 0;
	}
	free((char*)deltax);
      }
    }
    free((char*)osc_eta_x);
    if(x!=NULL)
    {
      if(MFAM_linspace(M,0.,1.-dx,x)==0)
      {
	fprintf(stderr,"MFAM_linspace failed\n");
	return 0;
      }
    }
    return 1;
  }
  else
  { 
    fprintf(stderr,"MFAG_fch1d arguments error\n");
    return 0.;
  }
}
