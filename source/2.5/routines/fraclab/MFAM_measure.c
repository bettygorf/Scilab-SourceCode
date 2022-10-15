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


/* Christophe Canus 1997-98 */
/* modif de bertrand le 13/05/98 */
/* pb avec unprotoize donc le passage ansi/non-ansi est fat a la main */

#include "MFAM_measure.h"

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_S1d(mu_n, S)
     double *mu_n;
     int S;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_S1d(mu_n, S)
     double *mu_n;
     int S;
#else /* __STDC__ */
double MFAM_mu_S1d(double* mu_n,int S)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  register int i=0;
  double mu_S1d=0.;
  for(i=0;i<S;i++)
    mu_S1d+=*(mu_n+i);
  return mu_S1d;
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_S2d(mu_n, Sx, Sy, Nx_n)
     double *mu_n;
     int Sx;
     int Sy;
     int Nx_n;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_S2d(mu_n, Sx, Sy, Nx_n)
     double *mu_n;
     int Sx;
     int Sy;
     int Nx_n;
#else /* __STDC__ */
double MFAM_mu_S2d(double* mu_n,int Sx,int Sy,int Nx_n)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  register int i=0,j=0;
  double mu_S2d=0.;
  for(j=0;j<Sy;j++)
    for(i=0;i<Sx;i++)
      mu_S2d+=*(mu_n+j*Nx_n+i);
  return mu_S2d;
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_P1d(N_n, mu_n, P)
     int N_n;
     double *mu_n;
     int P;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_P1d(N_n, mu_n, P)
     int N_n;
     double *mu_n;
     int P;
#else /* __STDC__ */
double MFAM_mu_P1d(int N_n,double* mu_n,int P)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((N_n>0)&&(mu_n!=NULL)&&(1<=P)&&(P<=N_n))
  {
    static int k;
    static double s_x,x_n_k,s_mu;
    double eta_n=1./N_n,eta=1./P,mu_P1d=s_mu; 
    if(FRflg)
    {
      k=0;
      s_x=0.;
      x_n_k=0.;
      s_mu=0.;
    }
    mu_P1d=s_mu;
    s_x+=eta;
    while((x_n_k<s_x)&&(k<N_n))
    {
      x_n_k+=eta_n;
      mu_P1d+=*(mu_n+k);
      k++;
    }
    if(k!=N_n)
      mu_P1d-=s_mu=*(mu_n+k-1)*(x_n_k-s_x);
    return mu_P1d;
  }
  else
  {
    fprintf(stderr,"MFAM_mu_P1d arguments error\n");
    return 0.;
  }
}  

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_2_n_x(n, mu_n, I_n, x, FRflg)
     short int n;
     double *mu_n;
     double *I_n;
     double x;
     int FRflg;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_2_n_x(n, mu_n, I_n, x, FRflg)
     short int n;
     double *mu_n;
     double *I_n;
     double x;
     int FRflg;
#else /* __STDC__ */
double MFAM_mu_2_n_x(short n,double* mu_n,double* I_n,double x,int FRflg)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(mu_n!=NULL)&&(I_n!=NULL)&&(0.<=x)&&(x<=1.))
  {
    static int k;
    int two_pow_n=(int)pow(2.,(double)n);
    if(FRflg)
      k=0;
    while(*(I_n+k)<x)
      k++;
    if(*(I_n+two_pow_n-1)<=x)
      return *(mu_n+two_pow_n-1);
    else
      return *(mu_n+k-1)*(k-x*two_pow_n)+*(mu_n+k)*(x*two_pow_n-k+1);
  }
  else
  {
    fprintf(stderr,"MFAM_mu_2_n_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_star_2_n_x(n, I_n, mu_n, x)
     short int n;
     double *I_n;
     double *mu_n;
     double x;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_star_2_n_x(n, I_n, mu_n, x)
     short int n;
     double *I_n;
     double *mu_n;
     double x;
#else /* __STDC__ */
double MFAM_mu_star_2_n_x(short n,double* I_n,double* mu_n,double x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  double two_pow_minus_n=(double)pow(2.,(double)(-n));
  if((n>0)&&(I_n!=NULL)&&(mu_n!=NULL)&&(two_pow_minus_n<=x)&&(x<=1.-2.*two_pow_minus_n))
  {
    static int k;
    int two_pow_n=(int)pow(2.,(double)n);
    while(*(I_n+k)<x)    
      k++;   
    if(*(I_n+k)==x)
      return *(mu_n+k-1)+*(mu_n+k)+*(mu_n+k+1);
    else 
      return *(mu_n+k-2)*(k-x*two_pow_n)+*(mu_n+k-1)*(x*two_pow_n-k+1)+
	*(mu_n+k-1)*(k-x*two_pow_n)+*(mu_n+k)*(x*two_pow_n-k+1)+
	*(mu_n+k)*(k-x*two_pow_n)+*(mu_n+k+1)*(x*two_pow_n-k+1);
  }
  else
  {
    fprintf(stderr,"MFAM_mu_star_2_n_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_n_x(nu_n, mu_n, I_n, x)
     int nu_n;
     double *mu_n;
     double *I_n;
     double x;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_n_x(nu_n, mu_n, I_n, x)
     int nu_n;
     double *mu_n;
     double *I_n;
     double x;
#else /* __STDC__ */
double MFAM_mu_n_x(int nu_n,double* mu_n,double* I_n,double x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((nu_n>0)&&(mu_n!=NULL)&&(I_n!=NULL)&&(0.<=x)&&(x<=1.))
  {
    static int k;
    while(*(I_n+k)<x)
      k++;
    if(*(I_n+nu_n-1)<=x)
      return *(mu_n+nu_n-1);
    else
      return *(mu_n+k-1)*(k-x*nu_n)+*(mu_n+k)*(x*nu_n-k+1);
  }
  else
  {
    fprintf(stderr,"MFAM_mu_n_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_eta(nu_n, mu_n, k, eta)
     int nu_n;
     double *mu_n;
     int k;
     double eta;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_eta(nu_n, mu_n, k, eta)
     int nu_n;
     double *mu_n;
     int k;
     double eta;
#else /* __STDC__ */
double MFAM_mu_eta(int nu_n,double* mu_n,int k,double eta)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  double eta_n=1./(double)nu_n;
  if((nu_n>0)&&(mu_n!=NULL)&&(k>=0)&&(eta>0.)&&(eta>=eta_n))
  {
    if(eta_n==eta)
      return *(mu_n+k);
    else 
    {
      register int l=0;
      double mu_eta=0.,c_eta=0.;
      while(eta>c_eta)
      {
	mu_eta+=*(mu_n+k+l);
	c_eta+=eta_n; 
	l++;
      }
      mu_eta+=(eta-c_eta+eta_n)/eta_n**(mu_n+k+l); 
      return mu_eta;
    }
  }
  else
  {
    fprintf(stderr,"MFAM_mu_eta arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_eta_x(nu_n, I_n, mu_n, eta, x_min, x_max, x)
     int nu_n;
     double *I_n;
     double *mu_n;
     double eta;
     double x_min;
     double x_max;
     double x;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_eta_x(nu_n, I_n, mu_n, eta, x_min, x_max, x)
     int nu_n;
     double *I_n;
     double *mu_n;
     double eta;
     double x_min;
     double x_max;
     double x;
#else /* __STDC__ */
double MFAM_mu_eta_x(int nu_n,double* I_n,double* mu_n,double eta,double x_min,double x_max,double x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  double eta_n=1./nu_n;
  if((nu_n>0)&&(mu_n!=NULL)&&(eta>=eta_n)&&(x_min<=x)&&(x<=x_max+1e-10))
  {
    static int s_k; 
    static double s_x_n_k;
    register int k=0;
    double mu_eta_x=0.,eta_n=1./(double)nu_n,x_n_k=0.; 
    if(FRflg)
    {
      s_k=0.;
      s_x_n_k=0.;
      FRflg=0;
    }
    k=s_k;
    if(I_n!=NULL)
    {
      while((*(I_n+k)<x)&&(k<nu_n))	
	k++;
      s_k=k;
      mu_eta_x+=*(mu_n+k-1)*(k-x/eta_n);
      while((*(I_n+k)<x+eta)&&(k<nu_n))
      {  
	mu_eta_x+=*(mu_n+k);
	k++; 
      }
      mu_eta_x-=*(mu_n+k-1)*(k-(x+eta)/eta_n);
    } 
    else
    {
      x_n_k=s_x_n_k;
      while((x_n_k<x)&&(k<nu_n))
      {
	x_n_k+=eta_n;
	k++;
      }
      s_k=k;
      s_x_n_k=x_n_k;
      mu_eta_x+=nu_n**(mu_n+k-1)*(x_n_k-x);
      while((x_n_k<x+eta)&&(k<nu_n))
      {  
	x_n_k+=eta_n;
	mu_eta_x+=*(mu_n+k);
	k++;
      } 
      mu_eta_x-=nu_n**(mu_n+k-1)*(x_n_k-(x+eta));
    }
    return mu_eta_x;
  }
  else
  {
    fprintf(stderr,"MFAM_mu_eta_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_eta_star_x(nu_n, I_n, mu_n, eta, x_min, x_max, x)
     int nu_n;
     double *I_n;
     double *mu_n;
     double eta;
     double x_min;
     double x_max;
     double x;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_eta_star_x(nu_n, I_n, mu_n, eta, x_min, x_max, x)
     int nu_n;
     double *I_n;
     double *mu_n;
     double eta;
     double x_min;
     double x_max;
     double x;
#else /* __STDC__ */
double MFAM_mu_eta_star_x(int nu_n,double* I_n,double* mu_n,double eta,double x_min,double x_max,double x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  double eta_n=1./(double)nu_n;
  if((nu_n>0)&&(mu_n!=NULL)&&(eta>=eta_n)&&(x_min<=x)&&(x<=x_max+1e-10))
  {
    static int s_k;
    static double s_x_n_k;
    register int k=0;
    double mu_eta_star_x=0.,x_n_k=0.;    
    if(FRflg)
    {
      s_k=0.;
      s_x_n_k=0.;
      FRflg=0;
    }
    k=s_k;
    if(I_n!=NULL)
    {
      while((*(I_n+k)<x-eta)&&(k<nu_n))
	k++;
      s_k=k;
      mu_eta_star_x+=*(mu_n+k-1)*(k-(x-eta)/eta_n);
      while((*(I_n+k)<x+2*eta)&&(k<nu_n))
      {  
	mu_eta_star_x+=*(mu_n+k);
	k++; 
      }
      mu_eta_star_x-=*(mu_n+k-1)*(k-(x+2*eta)/eta_n);
    } 
    else
    {
      x_n_k=s_x_n_k;
      while((x_n_k<x-eta)&&(k<nu_n))
      {
	x_n_k+=eta_n;
	k++;
      }
      s_k=k;
      s_x_n_k=x_n_k;
      mu_eta_star_x+=nu_n**(mu_n+k-1)*(x_n_k-(x-eta));
      while((x_n_k<x+2*eta)&&(k<nu_n))
      {  
	x_n_k+=eta_n;
	mu_eta_star_x+=*(mu_n+k);
	k++;
      } 
      mu_eta_star_x-=nu_n**(mu_n+k-1)*(x_n_k-(x+2*eta));
    } 
    if(MFAM_mu_eta_x(nu_n,I_n,mu_n,eta,x_min,x_max,x)==0.) 
      return 0.;
    else
      return mu_eta_star_x;
  }
  else
  {
    fprintf(stderr,"MFAM_mu_eta_star_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_eta_c_x(nu_n, I_n, mu_n, eta, x_min, x_max, x)
     int nu_n;
     double *I_n;
     double *mu_n;
     double eta;
     double x_min;
     double x_max;
     double x;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_eta_c_x(nu_n, I_n, mu_n, eta, x_min, x_max, x)
     int nu_n;
     double *I_n;
     double *mu_n;
     double eta;
     double x_min;
     double x_max;
     double x;
#else /* __STDC__ */
double MFAM_mu_eta_c_x(int nu_n,double* I_n,double* mu_n,double eta,double x_min,double x_max,double x)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  double eta_n=1./nu_n;
  if((nu_n>0)&&(mu_n!=NULL)&&(eta>=eta_n)&&(x_min<=x)&&(x<x_max+1e-10))
  {
    static int s_k;
    static double s_x_n_k;
    register int k=0;
    double mu_eta_c_x=0.,x_n_k=0.;
    if(FRflg)
    {
      s_k=0;
      s_x_n_k=0.;
      FRflg=0;
    }
    k=s_k;
    if(I_n!=NULL)
    {
      while((*(I_n+k)<x-eta/2.)&&(k<nu_n))
	k++;
      s_k=k;
      if(k)
	mu_eta_c_x+=*(mu_n+k-1)*(k-(x-eta/2.)/eta_n);
      while((*(I_n+k)<x+eta/2.)&&(k<nu_n))
      {  
	mu_eta_c_x+=*(mu_n+k);
	k++; 
      }
      mu_eta_c_x-=*(mu_n+k-1)*(k-(x+eta/2.)/eta_n);
    }
    else
    {
      x_n_k=s_x_n_k;
      while((x_n_k<x-eta/2.)&&(k<nu_n))
      {
	x_n_k+=eta_n;
	k++;
      }
      s_k=k;
      s_x_n_k=x_n_k;
      if(k)
	mu_eta_c_x+=nu_n**(mu_n+k-1)*(x_n_k-(x-eta/2.));
      while((x_n_k<x+eta/2.)&&(k<nu_n))
      {  
	x_n_k+=eta_n;
	mu_eta_c_x+=*(mu_n+k);
	k++;
      } 
      mu_eta_c_x-=nu_n**(mu_n+k-1)*(x_n_k-(x+eta/2.));
    }
    return mu_eta_c_x;
  }
  else
  {
    fprintf(stderr,"MFAM_mu_eta_c_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mu_eta_b_x(N_n, I_n, mu_n, eta, x_min, x_max, x, t_ball, t_bord)
     int N_n;
     double *I_n;
     double *mu_n;
     double eta;
     double x_min;
     double x_max;
     double x;
     MFAMt_ball t_ball;
     MFAMt_bord t_bord;
#else /* __STDC__ */
#ifndef __STDC__
double MFAM_mu_eta_b_x(N_n, I_n, mu_n, eta, x_min, x_max, x, t_ball, t_bord)
     int N_n;
     double *I_n;
     double *mu_n;
     double eta;
     double x_min;
     double x_max;
     double x;
     MFAMt_ball t_ball;
     MFAMt_bord t_bord;
#else /* __STDC__ */
double MFAM_mu_eta_b_x(int N_n,double* I_n,double* mu_n,double eta,double x_min,double x_max,double x,MFAMt_ball t_ball,MFAMt_bord t_bord)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  double eta_n=1./N_n;
  if((N_n>0)&&(mu_n!=NULL)&&(eta>=eta_n))
  {
    static int s_k;
    static double s_x_n_k;
    register int k=0;
    double x_minus=0.,x_plus=0.,x_n_k=0.,mu_eta_x=0.;
    switch(t_ball)
    {
      case MFAM_ASYMMETRIC:
	x_minus=0.;
	x_plus=eta;
	break;
      case MFAM_STAR:
	x_minus=x_plus=3./2.*eta;
	break;
      case MFAM_CENTERED: 
	x_minus=x_plus=1./2.*eta;
	break; 
      default:
	fprintf(stderr,"MFAM_mu_eta_b_x arguments error\n");
	return 0.;
	break;
    }
    if(FRflg)
    {
      s_k=0;
      s_x_n_k=0.;
      FRflg=0;   
    }
    k=s_k;
    switch(t_bord)
    {
    case MFAM_NOBORD:
      if(I_n!=NULL)
      {
	while((*(I_n+k)<x-x_minus)&&(k<N_n))
	  k++;
	s_k=k;
	if(k)
	  mu_eta_x+=*(mu_n+k-1)*(k-(x-x_minus)/eta_n);
	while((*(I_n+k)<x+x_plus)&&(k<N_n))
	{  
	  mu_eta_x+=*(mu_n+k);
	  k++; 
	}
	mu_eta_x-=*(mu_n+k-1)*(k-(x+x_plus)/eta_n);
      }
      else
      {
	x_n_k=s_x_n_k;
	while((x_n_k<x-x_minus)&&(k<N_n))
	{
	  x_n_k+=eta_n;
	  k++;
	}
	s_k=k;
	s_x_n_k=x_n_k;
	if(k)
	  mu_eta_x+=N_n**(mu_n+k-1)*(x_n_k-(x-x_minus));
	while((x_n_k<x+x_plus)&&(k<N_n))
	{  
	  x_n_k+=eta_n;
	  mu_eta_x+=*(mu_n+k);
	  k++;
	} 
	mu_eta_x-=N_n**(mu_n+k-1)*(x_n_k-(x+x_plus));
      }
      break;  
    case MFAM_MIRROR: 
      if(x-x_minus<x_min)
      {
	if(I_n!=NULL)
	{
	}
	else
	{
	  if(x-x_minus>0)
	    k=floor((x-x_minus)/eta_n);
	  else
	    k=-ceil(fabs((x-x_minus)*N_n));
	  x_n_k=k*eta_n;
	  while(x_n_k<x-x_minus)
	  {
	    x_n_k+=eta_n;
	    k++;
	  }
	  s_k=k;
	  s_x_n_k=x_n_k;
	  mu_eta_x+=N_n**(mu_n-k+1)*(x_n_k-(x-x_minus));
	  while(x_n_k<x_min)
	  {
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n-k);
	    k++;
	  }  
	  while((x_n_k<x+x_plus)&&(k<N_n))
	  {  
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+k);
	    k++;
	  } 
	  mu_eta_x-=N_n**(mu_n+k-1)*(x_n_k-(x+x_plus));
	}
      }
      else if((x_min<=x-x_minus)&&(x+x_plus<=x_max))
      {
	if(I_n!=NULL)
	{
	  while((*(I_n+k)<x-x_minus)&&(k<N_n))
	    k++;
	  s_k=k;
	  if(k)
	    mu_eta_x+=*(mu_n+k-1)*(k-(x-x_minus)/eta_n);
	  while((*(I_n+k)<x+x_plus)&&(k<N_n))
	  {  
	    mu_eta_x+=*(mu_n+k);
	    k++; 
	  }
	  mu_eta_x-=*(mu_n+k-1)*(k-(x+x_plus)/eta_n);
	}
	else
	{
	  x_n_k=s_x_n_k;
	  while((x_n_k<x-x_minus)&&(k<N_n))
	  {
	    x_n_k+=eta_n;
	    k++;
	  }
	  s_k=k;
	  s_x_n_k=x_n_k;
	  mu_eta_x+=N_n**(mu_n+k-1)*(x_n_k-(x-x_minus));
	  while((x_n_k<x+x_plus)&&(k<N_n))
	  {  
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+k);
	    k++;
	  } 
	  mu_eta_x-=N_n**(mu_n+k-1)*(x_n_k-(x+x_plus));
	}
      } 
      else if(x+x_plus>x_max)
      {
	if(I_n!=NULL)
	{
	}
	else
	{
	  if(x-x_minus>0)
	    k=floor((x-x_minus)/eta_n);
	  else
	    k=-ceil(fabs((x-x_minus)*N_n));
	  x_n_k=k*eta_n;
	  while(x_n_k<x-x_minus)
	  {
	    x_n_k+=eta_n;
	    k++;
	  }
	  s_k=k;
	  s_x_n_k=x_n_k;
	  mu_eta_x+=N_n**(mu_n+k-1)*(x_n_k-(x-x_minus));
	  while(x_n_k<x_max)
	  {
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+k);
	    k++;
	  }  
	  while(x_n_k<x+x_plus)
	  {  
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+2*(N_n-1)-k);
	    k++;
	  } 
	  mu_eta_x-=N_n**(mu_n+2*(N_n-1)-k+1)*(x_n_k-(x+x_plus));
	}
      }
      break;
    case MFAM_PERIOD:
      fprintf(stderr,"x-x_minus<x_min\n");
      if(x-x_minus<x_min)
      {
	if(I_n!=NULL)
	{
	}
	else
	{
	  if(x-x_minus>0)
	    k=floor((x-x_minus)/eta_n);
	  else
	    k=-ceil(fabs((x-x_minus)*N_n));
	  x_n_k=k*eta_n;
	  while(x_n_k<x-x_minus)
	  {
	    x_n_k+=eta_n;
	    k++;
	  }
	  s_k=k;
	  s_x_n_k=x_n_k; 
	  mu_eta_x+=N_n**(mu_n+N_n-k-1)*(x_n_k-(x-x_minus));
	  while(x_n_k<x_min)
	  {
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+N_n-k);
	    k++;
	  }  
	  while((x_n_k<x+x_plus)&&(k<N_n))
	  {  
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+k);
	    k++;
	  } 
	  mu_eta_x-=N_n**(mu_n+k-1)*(x_n_k-(x+x_plus));
	}
      }
      else if((x_min<=x-x_minus)&&(x+x_plus<=x_max))
      {
	fprintf(stderr,"case: x-x_minus>=x_min && x+x_plus<=x_max\n");
	if(I_n!=NULL)
	{
	  while((*(I_n+k)<x-x_minus)&&(k<N_n))
	    k++;
	  s_k=k;
	  if(k)
	    mu_eta_x+=*(mu_n+k-1)*(k-(x-x_minus)/eta_n);
	  while((*(I_n+k)<x+x_plus)&&(k<N_n))
	  {  
	    mu_eta_x+=*(mu_n+k);
	    k++; 
	  }
	  mu_eta_x-=*(mu_n+k-1)*(k-(x+x_plus)/eta_n);
	}
	else
	{
	  x_n_k=s_x_n_k;
	  while((x_n_k<x-x_minus)&&(k<N_n))
	  {
	    x_n_k+=eta_n;
	    k++;
	  }
	  s_k=k;
	  s_x_n_k=x_n_k;
	  if(k)
	    mu_eta_x+=N_n**(mu_n+k-1)*(x_n_k-(x-x_minus));
	  while((x_n_k<x+x_plus)&&(k<N_n))
	  {  
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+k);
	    k++;
	  } 
	  mu_eta_x-=N_n**(mu_n+k-1)*(x_n_k-(x+x_plus));
	}
      } 
      else if(x+x_plus>x_max)
      {
	fprintf(stderr,"case: x+x_plus>x_max\n");
	if(I_n!=NULL)
	{
	}
	else
	{
	  if(x-x_minus>0)
	    k=floor((x-x_minus)/eta_n);
	  else
	    k=-ceil(fabs((x-x_minus)*N_n));
	  x_n_k=k*eta_n;
	  while(x_n_k<x-x_minus)
	  {
	    x_n_k+=eta_n;
	    k++;
	  }
	  s_k=k;
	  s_x_n_k=x_n_k;
	  mu_eta_x+=N_n**(mu_n+k-1)*(x_n_k-(x-x_minus));
	  while(x_n_k<x_max)
	  {
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+k);
	    k++;
	  }  
	  while(x_n_k<x+x_plus)
	  {  
	    x_n_k+=eta_n;
	    mu_eta_x+=*(mu_n+N_n-k-1);
	    k++;
	  } 
	  mu_eta_x-=N_n**(mu_n+N_n-k-1)*(x_n_k-(x+x_plus));
	}
      }
      break;
    default:
      fprintf(stderr,"MFAM_mu_eta_b_x arguments error\n");
      break;
    }
    return mu_eta_x;
  }
  else
  {
    fprintf(stderr,"MFAM_mu_eta_b_x arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_ballstr(ballstr, t_ball)
     char *ballstr;
     MFAMt_ball *t_ball;
#else /* __STDC__ */
#ifndef __STDC__
int MFAM_ballstr(ballstr, t_ball)
     char *ballstr;
     MFAMt_ball *t_ball;
#else /* __STDC__ */
int MFAM_ballstr(char* ballstr,MFAMt_ball* t_ball)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if(strcmp(MFAM_ASYMMETRICSTR,ballstr)==0)
    *t_ball=MFAM_ASYMMETRIC;
  else if(strcmp(MFAM_STARSTR,ballstr)==0)
    *t_ball=MFAM_STAR;
  else if(strcmp(MFAM_CENTEREDSTR,ballstr)==0)
    *t_ball=MFAM_CENTERED; 
  else 
    return 0;
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_bordstr(bordstr, t_bord)
     char *bordstr;
     MFAMt_bord *t_bord;
#else /* __STDC__ */
#ifndef __STDC__
int MFAM_bordstr(bordstr, t_bord)
     char *bordstr;
     MFAMt_bord *t_bord;
#else /* __STDC__ */
int MFAM_bordstr(char* bordstr,MFAMt_bord* t_bord)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if(strcmp(MFAM_NOBORDSTR,bordstr)==0)
    *t_bord=MFAM_NOBORD;
  else if(strcmp(MFAM_MIRRORSTR,bordstr)==0)
    *t_bord=MFAM_MIRROR;
  else if(strcmp(MFAM_PERIODSTR,bordstr)==0)
    *t_bord=MFAM_PERIOD;
  else 
    return 0;
  return 1;
}
