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

#include "MFAG_continuous.h"

/* #define DALPHA */
#define LINEAR

/*****************************************************************************/
/*****************************************************************************/
/* horizontal sections                                                       */
/*****************************************************************************/
/*****************************************************************************/

/*****************************************************************************/
/* with horizontal sections, without precision, without size (with base 2)   */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_star_2_n_x(n, mu_n, alpha_star_n, alpha, dalpha, L, x_l)
     short int n;
     double *mu_n;
     double *alpha_star_n;
     double alpha;
     double dalpha;
     int *L;
     double *x_l;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_star_2_n_x(n, mu_n, alpha_star_n, alpha, dalpha, L, x_l)
     short int n;
     double *mu_n;
     double *alpha_star_n;
     double alpha;
     double dalpha;
     int *L;
     double *x_l;
#else /* __STDC__ */
int MFAG_star_2_n_x(short n,double* mu_n,double* alpha_star_n,double alpha,double dalpha,int* L,double* x_l)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(mu_n!=NULL)&&(alpha_star_n!=NULL)&&(alpha>0.)&&(dalpha>=0.)&&(L!=NULL)&&(x_l!=NULL))
  {
    register int k=0,l=0;
    int two_pow_n=(int)pow(2.,(double)n);
    for(k=0;k<two_pow_n-2;k++)
    {  
      if(fabs(*(alpha_star_n+k)-alpha)<dalpha)
      { 
	*(x_l+l)=(double)k/(double)(two_pow_n); 
	l++; 
      } 
      else if(fabs(*(alpha_star_n+k+1)-alpha)<dalpha)
	; 
      else if(((*(alpha_star_n+k)<alpha)&&(*(alpha_star_n+k+1)>alpha))
	      ||((*(alpha_star_n+k)>alpha)&&(*(alpha_star_n+k+1)<alpha)))
      { 
	*(x_l+l)=(k+pow(3.*pow(2.,-(double)n),alpha)-
		  (*(mu_n+k-1)+*(mu_n+k)+*(mu_n+k+1))/
		  (*(mu_n+k+2)-*(mu_n+k)))/two_pow_n;
	l++;
      }
    }
    *L=l; 
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_star_2_n_x arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* with horizontal sections, without precision, without size (with base 2)   */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_cp2(n, mu_n, alpha_n, N, alpha, pc_2_n_alpha)
     short int n;
     double *mu_n;
     double *alpha_n;
     int N;
     double *alpha;
     double *pc_2_n_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_cp2(n, mu_n, alpha_n, N, alpha, pc_2_n_alpha)
     short int n;
     double *mu_n;
     double *alpha_n;
     int N;
     double *alpha;
     double *pc_2_n_alpha;
#else /* __STDC__ */
int MFAG_cp2(short n,double* mu_n,double* alpha_n,int N,double* alpha,double* pc_2_n_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(alpha_n!=NULL)&&(N>0)&&(alpha!=NULL)&&(pc_2_n_alpha!=NULL))
  { 
    /* modif bertrand */
    register int k=0;
    int l=0;
    int i=0;
    int two_pow_n=(int)pow(2.,(double)n);
    double two_pow_minus_n=pow(2.,-(double)n);
    double static x_l[2]={0.,0.};
    for(i=0;i<N;i++)
    { 
      *(pc_2_n_alpha+i)=two_pow_minus_n; 
      l=0;   
      for(k=0;k<two_pow_n-1;k++)
      {
#ifdef DALPHA 
	if(fabs(*(alpha_n+k)-*(alpha+i))<((*(alpha+N-1)-*alpha)/N)) 
	{  
	    x_l[1]=(double)k/(double)two_pow_n;  
	    l++;  
	    if(l>1)
	      *(pc_2_n_alpha+i)+=(two_pow_minus_n>x_l[1]-x_l[0]?
				  x_l[1]-x_l[0]:two_pow_minus_n); 
	    x_l[0]=x_l[1];
	} 
#endif /* DALPHA */
	if((*(alpha_n+i)!=HUGE)&&
	   (((*(alpha_n+k)<=*(alpha+i))&&(*(alpha+i)<*(alpha_n+k+1)))
	    ||
	    ((*(alpha_n+k)>=*(alpha+i))&&(*(alpha+i)>*(alpha_n+k+1)))))
	{   
#ifdef LINEAR
	  x_l[1]=
	    (double)k/(double)two_pow_n+
	    (*(alpha+i)-*(alpha_n+k))
	    /(*(alpha_n+k+1)-*(alpha_n+k))
	    /(double)two_pow_n;
#else /* LINEAR */ 
	  x_l[1]=((double)k+
		  (pow(2.,-(double)n**(alpha+i))-*(mu_n+k))/
		  (*(mu_n+k+1)-*(mu_n+k)))
	    /(double)two_pow_n;
#endif /* LINEAR */
	  l++;
	  if(l>1)
	    *(pc_2_n_alpha+i)+=(two_pow_minus_n>x_l[1]-x_l[0]?
				x_l[1]-x_l[0]:two_pow_minus_n); 
	  x_l[0]=x_l[1];
	}
      }    
    }  
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_cp2 arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* with horizontal sections, without precision, without size (with base 2)   */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_cfg2(n, mu_n, alpha_n, t_norm, N, alpha, pc_2_n_alpha, fgc_2_n_alpha)
     short int n;
     double *mu_n;
     double *alpha_n;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_2_n_alpha;
     double *fgc_2_n_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_cfg2(n, mu_n, alpha_n, t_norm, N, alpha, pc_2_n_alpha, fgc_2_n_alpha)
     short int n;
     double *mu_n;
     double *alpha_n;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_2_n_alpha;
     double *fgc_2_n_alpha;
#else /* __STDC__ */
int MFAG_cfg2(short n,double* mu_n,double* alpha_n,MFAGt_norm t_norm,short N,double* alpha,double* pc_2_n_alpha,double* fgc_2_n_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(alpha_n!=NULL)&&(N>0)&&(alpha!=NULL)&&(pc_2_n_alpha!=NULL)&&(fgc_2_n_alpha!=NULL))
  {
    register int i=0;
    int two_pow_n=pow(2.,(double)n);
    if(MFAG_hoelder(two_pow_n,1,alpha_n,N,alpha)==0)
    {
      fprintf(stderr,"MFAG_hoelder error\n"); 
      return 0;
    }
    if(MFAG_cp2(n,mu_n,alpha_n,N,alpha,pc_2_n_alpha)==0)
    { 
      fprintf(stderr,"MFAG_cp2 error\n");
      return 0;   
    }
    switch(t_norm)
    {
      case MFAG_INFSUPPDF:
      case MFAG_INFSUPFG:
      case MFAG_NONORM:
	for(i=0;i<N;i++)
	  if(*(pc_2_n_alpha+i)>0.)
	    *(fgc_2_n_alpha+i)=1+1/(double)n*log(*(pc_2_n_alpha+i))/log(2.);
	  else
	    *(fgc_2_n_alpha+i)=0.;
	break;
      case MFAG_SUPPDF:
      {
	double sup_pc_2_n_alpha=-HUGE;
	for(i=0;i<N;i++)	
	  sup_pc_2_n_alpha=(sup_pc_2_n_alpha>*(pc_2_n_alpha+i)? 
			    sup_pc_2_n_alpha:*(pc_2_n_alpha+i));
	if(sup_pc_2_n_alpha!=0.)
	  for(i=0;i<N;i++)
	  {
	    *(pc_2_n_alpha+i)/=sup_pc_2_n_alpha;
	    if(two_pow_n**(pc_2_n_alpha+i)>=1.)
	      *(fgc_2_n_alpha+i)=1+1/(double)n*log(*(pc_2_n_alpha+i))/log(2.); 
	    else
	      *(fgc_2_n_alpha+i)=0.;
	  }
	else
	  for(i=0;i<N;i++)
	    *(fgc_2_n_alpha+i)=0.;
	break;
      }
      case MFAG_SUPFG:
      { 
	double sup_fgc_2_n_alpha=-HUGE;
	for(i=0;i<N;i++)
	  if(*(pc_2_n_alpha+i)!=0)
	  {
	    *(fgc_2_n_alpha+i)=1+1/(double)n*log(*(pc_2_n_alpha+i))/log(2.);
	    sup_fgc_2_n_alpha=(sup_fgc_2_n_alpha>*(fgc_2_n_alpha+i)?
			       sup_fgc_2_n_alpha:*(fgc_2_n_alpha+i));
	  }
	  else
	    *(fgc_2_n_alpha+i)=0.;
	if(sup_fgc_2_n_alpha!=0.)
	  for(i=0;i<N;i++)
	  { 
	    for(i=0;i<N;i++)
	      *(fgc_2_n_alpha+i)/=sup_fgc_2_n_alpha; 
	  }
	break;
      } 
      default: 
	fprintf(stderr,"MFAG_cfg2 arguments error\n");
	return 0;
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_cfg2 arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on Measures                           */
/* with horizontal sections, without precision, without size (with base 2)   */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_mcfg2(n, mu_n, alpha_n, t_norm, N, alpha, pc_2_n_alpha, fgc_2_n_alpha)
     short int n;
     double *mu_n;
     double *alpha_n;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_2_n_alpha;
     double *fgc_2_n_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_mcfg2(n, mu_n, alpha_n, t_norm, N, alpha, pc_2_n_alpha, fgc_2_n_alpha)
     short int n;
     double *mu_n;
     double *alpha_n;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_2_n_alpha;
     double *fgc_2_n_alpha;
#else /* __STDC__ */
int MFAG_mcfg2(short n,double* mu_n,double* alpha_n,MFAGt_norm t_norm,short N,double* alpha,double* pc_2_n_alpha,double* fgc_2_n_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((n>0)&&(mu_n!=NULL)&&(alpha_n!=NULL)&&(N>0)&&(alpha!=NULL)&&(pc_2_n_alpha!=NULL)&&(fgc_2_n_alpha!=NULL))
  {	 
    if(MFAG_alpha_2_n(n,mu_n,alpha_n)==0) 
    { 
      fprintf(stderr,"MFAG_alpha_n error\n"); 
      return 0; 
    }
    if(MFAG_cfg2(n,mu_n,alpha_n,t_norm,N,alpha,pc_2_n_alpha,fgc_2_n_alpha)==0)
    {
      fprintf(stderr,"MFAG_cfg2 error\n");
      return 0;
    }    
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_mcfg2 arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* with horizontal sections, with precision, without size (with base 2)      */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_2_m_x_epsilon(m, x, alpha_n_x, alpha, epsilon, x_e_nb, x_e)
     short int m;
     double *x;
     double *alpha_n_x;
     double alpha;
     double epsilon;
     int *x_e_nb;
     double *x_e;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_2_m_x_epsilon(m, x, alpha_n_x, alpha, epsilon, x_e_nb, x_e)
     short int m;
     double *x;
     double *alpha_n_x;
     double alpha;
     double epsilon;
     int *x_e_nb;
     double *x_e;
#else /* __STDC__ */
int MFAG_2_m_x_epsilon(short m,double *x,double *alpha_n_x,double alpha,double epsilon,int *x_e_nb,double *x_e)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
   if((m>0)&&(x!=NULL)&&(alpha_n_x!=NULL)&&(alpha>0.)&&(epsilon>0.)&&(x_e_nb!=NULL)&&(x_e!=NULL))
   {
      register int k=0,l=0;
      int two_pow_m=(int)pow(2.,(double)m);
      for(k=0;k<two_pow_m;k++)
      {
	 if(fabs(*(alpha_n_x+k)-alpha)<epsilon)
	 {
	    *(x_e+l)=*(x+k);
	    l++;
	 }
      }
      *x_e_nb=l;
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAG_2_m_x_epsilon arguments error\n");
      return 0;
   }   
}

/*****************************************************************************/
/* with horizontal sections, with precision, without size (with base 2)      */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_2_m_x_interpol(m, x, alpha_n_x, alpha, x_i_nb, x_i)
     short int m;
     double *x;
     double *alpha_n_x;
     double alpha;
     int *x_i_nb;
     double *x_i;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_2_m_x_interpol(m, x, alpha_n_x, alpha, x_i_nb, x_i)
     short int m;
     double *x;
     double *alpha_n_x;
     double alpha;
     int *x_i_nb;
     double *x_i;
#else /* __STDC__ */
int MFAG_2_m_x_interpol(short m,double *x,double *alpha_n_x,double alpha,int *x_i_nb,double *x_i)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
   if((m>0)&&(x!=NULL)&&(alpha_n_x!=NULL)&&(x_i_nb!=NULL))
   {
      register int k=0,l=0;
      int two_pow_m=(int)pow(2.,(double)m);
      double slope=0.;
     
      for(k=0;k<two_pow_m-1;k++)
      {
	 if(((*(alpha_n_x+k)<=alpha)&&(alpha<*(alpha_n_x+k+1)))||
	    ((*(alpha_n_x+k)>=alpha)&&(alpha>*(alpha_n_x+k+1))))
	 {
	    *(x_i+l)=*(x+k);
	    if(fabs(slope=(*(alpha_n_x+k+1)-*(alpha_n_x+k))/(*(x+k+1)-*(x+k)))>0.1)
	       *(x_i+l)+=(alpha-*(alpha_n_x+k))/slope; 
	    l++;
	 }
      }
      if(*(alpha_n_x+two_pow_m-1)==alpha)
      {  
	 *(x_i+l)=*(x+k);
	 l++;
      }
      *x_i_nb=l;
      return 1;
   }
   else
   {
      fprintf(stderr,"MFAG_2_m_x_interpol error\n");
      return 0;
   }  
}

/*****************************************************************************/
/* with horizontal sections, with precision, without size (with base 2)      */
/*****************************************************************************/

/* int MFAG_2_m_x_lr(short m,double *x,double *alpha_n_x,double alpha,double epsilon,double *x_l,double *x_r,int *x_lr_nb) */
/* { */
/*    if((m>0)&&(x!=NULL)&&(alpha_n_x!=NULL)&&(alpha>0.)&&(epsilon>0.)&&(x_l!=NULL)&&(x_r!=NULL)&&(x_lr_nb!=NULL)) */
/*    { */
/*       register int k=0,l=0; */
/*       int two_pow_m=(int)pow(2.,(double)m); */
/*       double slope=0.; */
/*       for(k=0;k<two_pow_m;k++) */
/*       { */
/* 	 if(fabs(*(alpha_n_x+k)-alpha)<epsilon) */
/* 	 { */
/* 	    slope=(*(alpha_n_x+k+1)-*(alpha_n_x+k))/(*(x+k+1)-*(x+k)); */
/* 	    if(slope>0.) */
/* 	    { */
/* 	       *(x_l+l)=(alpha-epsilon<*(alpha_n_x+k)?*(x+k):*(x+k)+(alpha-epsilon-*(alpha_n_x+k))/slope); */
/* 	       *(x_r+l)=(alpha+epsilon>*(alpha_n_x+k+1)?*(x+k+1):*(x+k+1)-(*(alpha_n_x+k+1)-alpha+epsilon)/slope); */
/* 	    } */
/* 	    else */
/* 	    { */
/* 	       *(x_l+l)=(alpha-epsilon<*(alpha_n_x+k+1)?*(x+k):*(x+k)+(alpha-epsilon-*(alpha_n_x+k))/slope); */
/* 	       *(x_r+l)=(alpha+epsilon>*(alpha_n_x+k)?*(x+k+1):*(x+k+1)-(*(alpha_n_x+k+1)-alpha+epsilon)/slope); */
/* 	    }    */
/* 	    l++; */
/* 	 } */
/*       } */
/*       *x_lr_nb=l; */
/*       return 1; */
/*    } */
/*    else */
/*    { */
/*       fprintf(stderr,"MFAG_2_m_x_lr arguments error\n"); */
/*       return 0; */
/*    }   */
/* } */

/*****************************************************************************/
/* with horizontal sections, with precision, without size (with base 2)      */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_2_m_x_lr(m, x, alpha_n_x, alpha, epsilon, x_l, x_r, x_lr_nb)
     short int m;
     double *x;
     double *alpha_n_x;
     double alpha;
     double epsilon;
     double *x_l;
     double *x_r;
     int *x_lr_nb;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_2_m_x_lr(m, x, alpha_n_x, alpha, epsilon, x_l, x_r, x_lr_nb)
     short int m;
     double *x;
     double *alpha_n_x;
     double alpha;
     double epsilon;
     double *x_l;
     double *x_r;
     int *x_lr_nb;
#else /* __STDC__ */
int MFAG_2_m_x_lr(short m,double *x,double *alpha_n_x,double alpha,double epsilon,double *x_l,double *x_r,int *x_lr_nb)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((m>0)&&(x!=NULL)&&(alpha_n_x!=NULL)&&(alpha>0.)&&(epsilon>0.)&&(x_l!=NULL)&&(x_r!=NULL)&&(x_lr_nb!=NULL))
  {
    register int k=0,l=0;
    int two_pow_m=(int)pow(2.,(double)m);
   /*  double slope=0.; */
/*     short n=8; */
    while(k<two_pow_m)
    {
    /*   if(fabs(*(alpha_n_x+k)-alpha)<epsilon) */
     /*  {     */
/* 	 *(x_l+l)=*(x+k)+pow(2.,-(double)n)*(pow(2.,-n*alpha)-pow(2.,-n**(alpha_n_x+k)))/(pow(2.,-n**(alpha_n_x+k+1))-pow(2.,-n**(alpha_n_x+k))); */
/* 	*(x_l+l)=*(x+k); */
/* 	if((slope=(pow(2.,n**(alpha_n_x+k+1))-pow(2.,n**(alpha_n_x+k)))/(*(x+k+1)-*(x+k)))!=0.) */
/* 	  *(x_l+l)+=(pow(2.,n*alpha)-pow(2.,n**(alpha_n_x+k)))/slope; */
/* 	fprintf(stderr,"x_l=%f\n",*(x_l+l)); */
/* 	k++; */
/* 	while(fabs(*(alpha_n_x+k)-alpha)<epsilon) */
/* 	  k++; */
/* 	if(fabs(*(alpha_n_x+k)-alpha)>epsilon) */
/* 	{ */
/* 	   *(x_r+l)=*(x+k)+pow(2.,-(double)n)*(pow(2.,-n*alpha)-pow(2.,-n**(alpha_n_x+k)))/(pow(2.,-n**(alpha_n_x+k+1))-pow(2.,-n**(alpha_n_x+k))); */
/* 	  *(x_r+l)=*(x+k); */
/* 	  if((slope=(pow(2.,n**(alpha_n_x+k+1))-pow(2.,n**(alpha_n_x+k)))/(*(x+k+1)-*(x+k)))!=0.)  */
/* 	    *(x_r+l)=+(pow(2.,n*alpha)-pow(2.,n**(alpha_n_x+k)))/slope; */
/* 	  fprintf(stderr,"x_r=%f\n",*(x_r+l)); */
/* 	  k++;   */
/* 	} */
/* 	l++; */
/*       } */
      if(fabs(*(alpha_n_x+k)-alpha)<epsilon)
      {
	*(x_l+l)=*(x+k);
	/* fprintf(stderr,"x_l=%f\n",*(x_l+l));  */
	k++;
	while(fabs(*(alpha_n_x+k)-alpha)<epsilon) 
	  k++;
	*(x_r+l)=*(x+k);
	/* fprintf(stderr,"x_r=%f\n",*(x_r+l)); */
	l++;
      }
      else
	k++;
    }
    *x_lr_nb=l;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_2_m_x_lr arguments error\n");
    return 0;
  }  
}

#ifndef __STDC__
static double MFAG_pc_2_n_alpha(n, L, x_l)
     short int n;
     int L;
     double *x_l;
#else /* __STDC__ */
#ifndef __STDC__
static double MFAG_pc_2_n_alpha(n, L, x_l)
     short int n;
     int L;
     double *x_l;
#else /* __STDC__ */
static double MFAG_pc_2_n_alpha(short n,int L,double* x_l)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(L>0)&&(x_l!=NULL))
  { 
     register int l=0;
     double two_pow_minus_n=pow(2.,-(double)n),pc_2_n_alpha=two_pow_minus_n,d_x=0.;
     for(l=0;l<L-1;l++)
     {
       d_x=*(x_l+l+1)-*(x_l+l);
       pc_2_n_alpha+=(two_pow_minus_n>d_x?d_x:two_pow_minus_n);
     } 
     return pc_2_n_alpha;
  }
  else
  {
    fprintf(stderr,"MFAG_pc_2_n_alpha arguments error\n");
    return 0.;
  }
}

/*****************************************************************************/
/* with horizontal sections, with precision, without size (with base 2)     */
/*****************************************************************************/

#ifndef __STDC__
static double MFAG_pc_2_n_alpha_lr(n, x_lr_nb, x_l, x_r)
     short int n;
     int x_lr_nb;
     double *x_l;
     double *x_r;
#else /* __STDC__ */
#ifndef __STDC__
static double MFAG_pc_2_n_alpha_lr(n, x_lr_nb, x_l, x_r)
     short int n;
     int x_lr_nb;
     double *x_l;
     double *x_r;
#else /* __STDC__ */
static double MFAG_pc_2_n_alpha_lr(short n,int x_lr_nb,double* x_l,double* x_r)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
   if((n>0)&&(x_lr_nb>0)&&(x_l!=NULL)&&(x_r!=NULL))
   { 
      register int k=0;
      double two_pow_minus_n=pow(2.,-(double)n),pc_2_n_alpha_lr=two_pow_minus_n,d_x_rl=0.,d_x_lr=0.;
      for(k=0;k<x_lr_nb-1;k++)
      {
	 d_x_rl=*(x_r+k)-*(x_l+k); 
	 d_x_lr=*(x_l+k+1)-*(x_r+k); 
	 pc_2_n_alpha_lr+=
	   (two_pow_minus_n>d_x_rl?d_x_rl:two_pow_minus_n)+
	   (two_pow_minus_n>d_x_lr?d_x_lr:two_pow_minus_n);
      }
      return pc_2_n_alpha_lr;
   }
   else
   {
      fprintf(stderr,"MFAG_pc_2_n_alpha_lr arguments error\n");
      return 0.;
   }
}

/*****************************************************************************/
/* with horizontal sections, with precision, without size (with base 2)     */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_fgc_2_n_epsilon(n, m, x, alpha_n_x, N, alpha, epsilon, Iflg, Rflg, Hflg, Sflg, pc_2_n_alpha, fgc_n_alpha, dflg)
     short int n;
     short int m;
     double *x;
     double *alpha_n_x;
     short int N;
     double *alpha;
     double epsilon;
     int Iflg;
     int Rflg;
     int Hflg;
     int Sflg;
     double *pc_2_n_alpha;
     double *fgc_n_alpha;
     int dflg;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_fgc_2_n_epsilon(n, m, x, alpha_n_x, N, alpha, epsilon, Iflg, Rflg, Hflg, Sflg, pc_2_n_alpha, fgc_n_alpha, dflg)
     short int n;
     short int m;
     double *x;
     double *alpha_n_x;
     short int N;
     double *alpha;
     double epsilon;
     int Iflg;
     int Rflg;
     int Hflg;
     int Sflg;
     double *pc_2_n_alpha;
     double *fgc_n_alpha;
     int dflg;
#else /* __STDC__ */
int MFAG_fgc_2_n_epsilon(short n,short m,double* x,double* alpha_n_x,short N,double* alpha,double epsilon,int Iflg,int Rflg,int Hflg,int Sflg,double* pc_2_n_alpha,double* fgc_n_alpha,int dflg)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((n>0)&&(m>0)&&(alpha_n_x!=NULL)&&(N>=0)&&(alpha!=NULL)&&(epsilon>0.))
  {
    register int k=0,l=0; 
    int L=0,sum_L=0;
    int two_pow_n=pow(2.,(double)n),two_pow_m=pow(2.,(double)m);
    double sup_pc_2_n_alpha=0.,sup_fgc_n_alpha=0.;
    double* x_e=NULL;
    double* x_i=NULL;
    double* x_l=NULL;
    double* x_r=NULL;
    if(Rflg)
    { 
      if((x_l=(double*)malloc((unsigned)(two_pow_m*sizeof(double))))==NULL) 
      { 
	fprintf(stderr,"malloc error\n");
	return 0;   
      } 
      if((x_r=(double*)malloc((unsigned)(two_pow_m*sizeof(double))))==NULL) 
      { 
	fprintf(stderr,"malloc error\n");
	return 0;   
      } 
    }
    else 
      if(Iflg)
      {
	if((x_i=(double*)malloc((unsigned)(two_pow_m*sizeof(double))))==NULL) 
	{ 
	  fprintf(stderr,"malloc error\n");
	  return 0;   
	}
      } 
    else
    {
      if((x_e=(double*)malloc((unsigned)(two_pow_m*sizeof(double))))==NULL) 
      { 
	fprintf(stderr,"malloc error\n");
	return 0;   
      }
    }
    for(k=0;k<N;k++)
    {  
      if(Rflg) 
      {
	if(MFAG_2_m_x_lr(m,x,alpha_n_x,*(alpha+k),epsilon,x_l,x_r,&L)==0)
	{
	  fprintf(stderr,"MFAG_2_m_x_lr error\n");
	  return 0;
	}
      }  
      else 
	if(Iflg)
	{
	  if(MFAG_2_m_x_interpol(m,x,alpha_n_x,*(alpha+k),&L,x_i)==0)
	  {
	    fprintf(stderr,"MFAG_2_m_x_interpol error\n");
	    return 0;
	  }
	}
	else
	{
	  if(MFAG_2_m_x_epsilon(m,x,alpha_n_x,*(alpha+k),epsilon,&L,x_e)==0)
	  {
	    fprintf(stderr,"MFAG_2_m_x_epsilon error\n");
	    return 0;
	  }
	}  
      if(L!=0)
      {  
	if(Rflg)
	  *(pc_2_n_alpha+k)=MFAG_pc_2_n_alpha_lr(n,L,x_l,x_r);
	else 
	  if(Iflg) 
	    *(pc_2_n_alpha+k)=MFAG_pc_2_n_alpha(n,L,x_i);
	  else
	    *(pc_2_n_alpha+k)=MFAG_pc_2_n_alpha(n,L,x_e);
      }
      else 
	*(pc_2_n_alpha+k)=0.;
      if(Hflg)
	sup_pc_2_n_alpha=(sup_pc_2_n_alpha>*(pc_2_n_alpha+k)?
			  sup_pc_2_n_alpha:*(pc_2_n_alpha+k));   
      if(dflg)
      {  
	if(Rflg)
	{ 
	  for(l=0;l<L;l++)
	    fprintf(stderr,"[%e,%e]\n",*(x_l+l),*(x_r+l));
	  fprintf(stderr,"# of [x_l,x_r]: %d\n",L); 
	  fprintf(stderr,"pc_2_n_alpha:%f\n",*(pc_2_n_alpha+k));  
	}
	else
	{
	  for(l=0;l<L;l++)
	    fprintf(stderr,"x_e_%d:%e\n",l,*(x_e+l));
	  fprintf(stderr,"alpha_%d: %f\n",k,*(alpha+k));  
	  fprintf(stderr,"# of x_e: %d\n",L);  
	  fprintf(stderr,"pc_2_n_alpha:%f\n",*(pc_2_n_alpha+k));     
	}
      }
      if(dflg)
      {    
	fprintf(stderr,"two_pow_m: %d\n",two_pow_m);  
	fprintf(stderr,"sum_L: %d\n",sum_L);
      }  
      if(dflg)  
	sum_L+=L;  
    } 
    if(Rflg)
    { 
      free((char*)x_l);
      free((char*)x_r); 
    }
    else 
      if(Iflg)
	free((char*)x_i);
      else
	free((char*)x_e);
    for(k=0;k<N;k++)
    {
      if(two_pow_n*(*(pc_2_n_alpha+k))>1.)
      {
	if(Hflg)
	  *(pc_2_n_alpha+k)/=sup_pc_2_n_alpha;
	*(fgc_n_alpha+k)=1+log(*(pc_2_n_alpha+k))/((double)n*log(2.)); 
	if(Sflg)
	  sup_fgc_n_alpha=(sup_fgc_n_alpha>*(fgc_n_alpha+k)?
			   sup_fgc_n_alpha:*(fgc_n_alpha+k));
      }
      else
	*(fgc_n_alpha+k)=0.;
    } 
    if((Sflg)&&(sup_fgc_n_alpha!=0.))
      for(k=0;k<N;k++)
	*(fgc_n_alpha+k)/=sup_fgc_n_alpha; 
    return 1;
   } 
   else 
   {
      fprintf(stderr,"MFAG_fgc_2_n_epsilon arguments error\n");
      return 0;
   }
}

/*****************************************************************************/
/* with horizontal sections, with precision, without size (any base)        */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_cpn(N_n, mu_n, alpha_n, N, alpha, pc_n_alpha)
     int N_n;
     double *mu_n;
     double *alpha_n;
     int N;
     double *alpha;
     double *pc_n_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_cpn(N_n, mu_n, alpha_n, N, alpha, pc_n_alpha)
     int N_n;
     double *mu_n;
     double *alpha_n;
     int N;
     double *alpha;
     double *pc_n_alpha;
#else /* __STDC__ */
int MFAG_cpn(int N_n,double* mu_n,double* alpha_n,int N,double* alpha,double* pc_n_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((N_n>0)&&(alpha_n!=NULL)&&(N>0)&&(alpha!=NULL)&&(pc_n_alpha!=NULL))
  { 
    register int k=0;
    /* modif bertrand */
    int l=0;
    int i=0;
    double eta_n=1./(double)N_n;
    double static x_l[2]={0.,0.};
    for(i=0;i<N;i++)
    { 
      *(pc_n_alpha+i)=eta_n; 
      l=0;   
      for(k=0;k<N_n-1;k++)
      {
#ifdef DALPHA 
	if(fabs(*(alpha_n+k)-*(alpha+i))<((*(alpha+N-1)-*alpha)/N)) 
	{  
	    x_l[1]=(double)k/(double)N_n;  
	    l++;  
	    if(l>1)
	      *(pc_n_alpha+i)+=(eta_n>x_l[1]-x_l[0]?x_l[1]-x_l[0]:eta_n); 
	    x_l[0]=x_l[1];
	} 
#endif /* DALPHA */
	if((*(alpha_n+i)!=HUGE)&&
	   (((*(alpha_n+k)<=*(alpha+i))&&(*(alpha+i)<*(alpha_n+k+1)))
	    ||
	    ((*(alpha_n+k)>=*(alpha+i))&&(*(alpha+i)>*(alpha_n+k+1)))))
	{   
#ifdef LINEAR
	  x_l[1]=((double)k+
		  (*(alpha+i)-*(alpha_n+k))/
		  (*(alpha_n+k+1)-*(alpha_n+k)))
	    /(double)N_n;
#else /* LINEAR */
	  x_l[1]=((double)k+
		  (pow((double)N_n,-*(alpha+i))-*(mu_n+k))/
		  (*(mu_n+k+1)-*(mu_n+k)))
	    /(double)N_n;
#endif /* LINEAR */ 
	  l++;
	  if(l>1)
	    *(pc_n_alpha+i)+=(eta_n>x_l[1]-x_l[0]?x_l[1]-x_l[0]:eta_n); 
	  x_l[0]=x_l[1];
	}
      }    
    }  
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_cpn arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* with horizontal sections, with precision, without size (any base)        */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_cfgn(N_n, mu_n, alpha_n, t_norm, N, alpha, pc_n_alpha, fgc_n_alpha)
     int N_n;
     double *mu_n;
     double *alpha_n;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_n_alpha;
     double *fgc_n_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_cfgn(N_n, mu_n, alpha_n, t_norm, N, alpha, pc_n_alpha, fgc_n_alpha)
     int N_n;
     double *mu_n;
     double *alpha_n;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_n_alpha;
     double *fgc_n_alpha;
#else /* __STDC__ */
int MFAG_cfgn(int N_n,double* mu_n,double* alpha_n,MFAGt_norm t_norm,short N,double* alpha,double* pc_n_alpha,double* fgc_n_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((N_n>0)&&(alpha_n!=NULL)&&(N>0)&&(alpha!=NULL)&&(pc_n_alpha!=NULL)&&(fgc_n_alpha!=NULL))
  {
    register int i=0; 
    if(MFAG_hoelder(N_n,1,alpha_n,N,alpha)==0)
    {
      fprintf(stderr,"MFAG_hoelder error\n"); 
      return 0;
    } 
    if(MFAG_cpn(N_n,mu_n,alpha_n,N,alpha,pc_n_alpha)==0)
    { 
      fprintf(stderr,"MFAG_cpn error\n");
      return 0;   
    }
    switch(t_norm)
    {
      case MFAG_INFSUPPDF:
      case MFAG_INFSUPFG:
      case MFAG_NONORM:
	for(i=0;i<N;i++)
	  if(*(pc_n_alpha+i)>0.)
	    *(fgc_n_alpha+i)=1+log(*(pc_n_alpha+i))/log((double)N_n);
	  else
	    *(fgc_n_alpha+i)=0.;
	break;
      case MFAG_SUPPDF:
      {
	double sup_pc_n_alpha=-HUGE;
	for(i=0;i<N;i++)	
	  sup_pc_n_alpha=(sup_pc_n_alpha>*(pc_n_alpha+i)? 
			  sup_pc_n_alpha:*(pc_n_alpha+i));
	if(sup_pc_n_alpha!=0.)
	  for(i=0;i<N;i++)
	  {
	    *(pc_n_alpha+i)/=sup_pc_n_alpha;
	    if(N_n**(pc_n_alpha+i)>=1.)
	      *(fgc_n_alpha+i)=1+log(*(pc_n_alpha+i))/log((double)N_n); 
	    else
	      *(fgc_n_alpha+i)=0.;
	  }
	else
	  for(i=0;i<N;i++)
	    *(fgc_n_alpha+i)=0.;
	break;
      }
      case MFAG_SUPFG:
      { 
	double sup_fgc_n_alpha=-HUGE;
	for(i=0;i<N;i++)
	  if(*(pc_n_alpha+i)!=0)
	  {
	    *(fgc_n_alpha+i)=1+log(*(pc_n_alpha+i))/log((double)N_n);
	    sup_fgc_n_alpha=(sup_fgc_n_alpha>*(fgc_n_alpha+i)?
			     sup_fgc_n_alpha:*(fgc_n_alpha+i));
	  }
	  else
	    *(fgc_n_alpha+i)=0.;
	if(sup_fgc_n_alpha!=0.)
	  for(i=0;i<N;i++)
	  { 
	    for(i=0;i<N;i++)
	      *(fgc_n_alpha+i)/=sup_fgc_n_alpha; 
	  }
	break;
      } 
      default: 
	fprintf(stderr,"MFAG_cfgn arguments error\n");
	return 0;
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_cfgn arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on Measures                           */
/* with horizontal sections, with precision, without size (any base)        */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_mcfgn(N_n, mu_n, alpha_n, t_norm, N, alpha, pc_n_alpha, fgc_n_alpha)
     int N_n;
     double *mu_n;
     double *alpha_n;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_n_alpha;
     double *fgc_n_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_mcfgn(N_n, mu_n, alpha_n, t_norm, N, alpha, pc_n_alpha, fgc_n_alpha)
     int N_n;
     double *mu_n;
     double *alpha_n;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_n_alpha;
     double *fgc_n_alpha;
#else /* __STDC__ */
int MFAG_mcfgn(int N_n,double* mu_n,double* alpha_n,MFAGt_norm t_norm,short N,double* alpha,double* pc_n_alpha,double* fgc_n_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((N_n>0)&&(mu_n!=NULL)&&(N>0)&&(pc_n_alpha!=NULL)&&(fgc_n_alpha!=NULL))
  {
    if(MFAG_alpha_n(N_n,mu_n,alpha_n)==0) 
    { 
      fprintf(stderr,"MFAG_alpha_n error\n"); 
      return 0; 
    }
    if(MFAG_cfgn(N_n,mu_n,alpha_n,t_norm,N,alpha,pc_n_alpha,fgc_n_alpha)==0)
    {
      fprintf(stderr,"MFAG_cfgn error\n");
      return 0;
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_mcfgn arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* with horizontal sections, without precison, with size, without kernel    */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_cp(eta, M, x, alpha_eta_x, N, alpha, pc_eta_alpha)
     double eta;
     int M;
     double *x;
     double *alpha_eta_x;
     int N;
     double *alpha;
     double *pc_eta_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_cp(eta, M, x, alpha_eta_x, N, alpha, pc_eta_alpha)
     double eta;
     int M;
     double *x;
     double *alpha_eta_x;
     int N;
     double *alpha;
     double *pc_eta_alpha;
#else /* __STDC__ */
int MFAG_cp(double eta,int M,double* x,double* alpha_eta_x,int N,double* alpha,double* pc_eta_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((eta>0.)&&(M>0)&&(alpha_eta_x!=NULL)&&(N>0)&&(alpha!=NULL)&&(pc_eta_alpha!=NULL))
  { 
    register int m=0;
    int n=0;
    int l=0;
    double s=0.;
    double dx=0.;
    double static x_l[2]={0.,0.};
    
    if(x==NULL)
      dx=(1.-eta)/(M-1);
    for(n=0;n<N;n++)
    { 
      *(pc_eta_alpha+n)=eta; 
      l=0;   
      for(m=0;m<M-1;m++)
      {
	if((*(alpha_eta_x+m)!=HUGE)&&
	   (((*(alpha_eta_x+m)<=*(alpha+n))&&(*(alpha+n)<*(alpha_eta_x+m+1)))
	    ||
	    ((*(alpha_eta_x+m)>=*(alpha+n))&&(*(alpha+n)>*(alpha_eta_x+m+1)))))
	{
	  if(x==NULL)
	    x_l[1]=m*dx;
	  else
	  {
	    x_l[1]=*(x+m);
	    dx=*(x+m+1)-*(x+m);
	  } 
#ifdef LINEAR
	  if((s=(*(alpha_eta_x+m+1)-*(alpha_eta_x+m))/dx)!=0.)
	    x_l[1]+=(*(alpha+n)-*(alpha_eta_x+m))/s;
#else /* LINEAR */
	  if((s=(pow(eta,*(alpha_eta_x+m+1))-pow(eta,*(alpha_eta_x+m)))/dx)!=0.)
	    x_l[1]+=(pow(eta,*(alpha+n))-pow(eta,*(alpha_eta_x+m)))/s;
#endif /* LINEAR */
	  l++;
	  if(l>1)
	    *(pc_eta_alpha+n)+=(eta>x_l[1]-x_l[0]?x_l[1]-x_l[0]:eta); 
	  x_l[0]=x_l[1];
	} 
      }     
    }  
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_cp arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on Hoelder exponents                  */
/* with horizontal sections, without precison, with size, without kernel    */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_cfg(J, eta, M, x, alpha_eta_x, t_norm, N, alpha, pc_eta_alpha, fgc_eta_alpha)
     short int J;
     double *eta;
     int M;
     double *x;
     double *alpha_eta_x;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_eta_alpha;
     double *fgc_eta_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_cfg(J, eta, M, x, alpha_eta_x, t_norm, N, alpha, pc_eta_alpha, fgc_eta_alpha)
     short int J;
     double *eta;
     int M;
     double *x;
     double *alpha_eta_x;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_eta_alpha;
     double *fgc_eta_alpha;
#else /* __STDC__ */
int MFAG_cfg(short J,double* eta,int M,double* x,double* alpha_eta_x,MFAGt_norm t_norm,short N,double* alpha,double* pc_eta_alpha,double* fgc_eta_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((J>0)&&(eta!=NULL)&&(M>0)&&(alpha_eta_x!=NULL)&&(N>0)&&(pc_eta_alpha!=NULL)&&(fgc_eta_alpha!=NULL))
  {
    register int j=0;
    if(MFAG_hoelder(M,J,alpha_eta_x,N,alpha)==0)
    {
      fprintf(stderr,"MFAG_hoelder error\n"); 
      return 0;
    } 
    for(j=0;j<J;j++)
    {
      if(MFAG_cp(*(eta+j),M,x,alpha_eta_x+M*j,N,alpha,pc_eta_alpha)==0)
      { 
	fprintf(stderr,"MFAG_cp error\n");
	return 0;   
      }
      if(MFAG_norm(t_norm,*(eta+j),N,NULL,pc_eta_alpha,fgc_eta_alpha)==0)
      {
	fprintf(stderr,"MFAG_norm error\n");
	return 0;   
      }
    } 
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_cfg arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on measures                           */
/* with horizontal sections, without precison, with size, without kernel    */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_mcfg(N_n, I_n, mu_n, t_prog, t_ball, J, a, A, M, eta, x, alpha_eta_x, t_norm, N, alpha, pc_eta_alpha, fgc_eta_alpha)
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
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_eta_alpha;
     double *fgc_eta_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_mcfg(N_n, I_n, mu_n, t_prog, t_ball, J, a, A, M, eta, x, alpha_eta_x, t_norm, N, alpha, pc_eta_alpha, fgc_eta_alpha)
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
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_eta_alpha;
     double *fgc_eta_alpha;
#else /* __STDC__ */
int MFAG_mcfg(int N_n,double* I_n,double* mu_n,MFAMt_prog t_prog,MFAMt_ball t_ball,short J,double a,double A,int M,double* eta,double* x,double *alpha_eta_x,MFAGt_norm t_norm,short N,double* alpha,double* pc_eta_alpha,double* fgc_eta_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((N_n>0)&&(mu_n!=NULL)&&(J>0)&&(a>=1.)&&(A>=a)&&(M>=N_n)&&(alpha_eta_x!=NULL)&&(N>0)&&(alpha!=NULL)&&(pc_eta_alpha!=NULL)&&(fgc_eta_alpha!=NULL))
  {
    if(MFAG_mch1d(N_n,I_n,mu_n,t_prog,t_ball,J,a,A,M,eta,x,alpha_eta_x)==0)
    {  
      fprintf(stderr,"MFAG_mch1d error\n");  
      return 0;  
    }
    if(MFAG_cfg(J,eta,M,x,alpha_eta_x,t_norm,N,alpha,pc_eta_alpha,fgc_eta_alpha)==0)
    {  
      fprintf(stderr,"MFAG_cfg error\n");  
      return 0;  
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_mcfg arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_fcfg(M, x, f_x, t_prog, t_osc, p, S_min, S_max, J, eta, alpha_eta_x, t_norm, N, alpha, pc_eta_alpha, fgc_eta_alpha)
     int M;
     double *x;
     double *f_x;
     MFAMt_prog t_prog;
     MFAMt_osc t_osc;
     double p;
     double S_min;
     double S_max;
     short int J;
     double *eta;
     double *alpha_eta_x;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_eta_alpha;
     double *fgc_eta_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_fcfg(M, x, f_x, t_prog, t_osc, p, S_min, S_max, J, eta, alpha_eta_x, t_norm, N, alpha, pc_eta_alpha, fgc_eta_alpha)
     int M;
     double *x;
     double *f_x;
     MFAMt_prog t_prog;
     MFAMt_osc t_osc;
     double p;
     double S_min;
     double S_max;
     short int J;
     double *eta;
     double *alpha_eta_x;
     MFAGt_norm t_norm;
     short int N;
     double *alpha;
     double *pc_eta_alpha;
     double *fgc_eta_alpha;
#else /* __STDC__ */
int MFAG_fcfg(int M,double* x,double* f_x,MFAMt_prog t_prog,MFAMt_osc t_osc,double p,double S_min,double S_max,short J,double* eta,double* alpha_eta_x,MFAGt_norm t_norm,short N,double* alpha,double* pc_eta_alpha,double* fgc_eta_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(f_x!=NULL)&&(p>=1.)&&(1.<=S_min)&&(S_min<=S_max)&&(S_max<=M/2.)&&(J>0)&&(eta!=NULL)&&(alpha_eta_x!=NULL)&&(N>0)&&(alpha!=NULL)&&(pc_eta_alpha!=NULL)&&(fgc_eta_alpha!=NULL))
  {
    if(MFAG_fch1d(M,x,f_x,J,S_min,S_max,t_prog,t_osc,p,alpha_eta_x,eta)==0)
    {
      fprintf(stderr,"MFAG_fch1d error\n"); 
      return 0;
    }  
    if(MFAG_cfg(J,eta,M,x,alpha_eta_x,t_norm,N,alpha,pc_eta_alpha,fgc_eta_alpha)==0)
    {  
      fprintf(stderr,"MFAG_cfg error\n");  
      return 0;  
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_fcfg arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAG_ke(kern, epsilon, alpha, beta)
     double (*kern)();
     double epsilon;
     double alpha;
     double beta;
#else /* __STDC__ */
#ifndef __STDC__
double MFAG_ke(kern, epsilon, alpha, beta)
     double (*kern)();
     double epsilon;
     double alpha;
     double beta;
#else /* __STDC__ */
double MFAG_ke(double (*kern)(double),double epsilon,double alpha,double beta)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  double k_epsilon_alpha_beta=0.;
  k_epsilon_alpha_beta=kern((alpha-beta)/epsilon)/(2*epsilon);
  return k_epsilon_alpha_beta;
}

/*****************************************************************************/
/* with horizontal sections, with precision, with size, with/without kernel *//*****************************************************************************/

#ifndef __STDC__
int MFAG_kcpe(eta, M, x, alpha_eta_x, kern, N, epsilon, alpha, pc_eta_epsilon_alpha)
     double eta;
     int M;
     double *x;
     double *alpha_eta_x;
     double (*kern)();
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_kcpe(eta, M, x, alpha_eta_x, kern, N, epsilon, alpha, pc_eta_epsilon_alpha)
     double eta;
     int M;
     double *x;
     double *alpha_eta_x;
     double (*kern)();
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
#else /* __STDC__ */
int MFAG_kcpe(double eta,int M,double* x,double* alpha_eta_x,double (*kern)(double),short N,double* epsilon,double* alpha,double* pc_eta_epsilon_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((eta>0.)&&(M>0)&&(alpha_eta_x!=NULL)&&(N>0)&&(epsilon!=NULL)&&(alpha!=NULL)&&(pc_eta_epsilon_alpha!=NULL))
  {
    register int n=0,k=0;
    double beta_min=*alpha,dbeta=(*(alpha+N-1)-*alpha)/(double)(N-1);
    double* pc_eta_beta=NULL; 
    if((pc_eta_beta=(double*)malloc((unsigned)(N*sizeof(double))))==NULL)
    { 
      fprintf(stderr,"malloc error\n");
      return 0;   
    }    
    if(MFAG_cp(eta,M,x,alpha_eta_x,N,alpha,pc_eta_beta)==0)
    { 
      fprintf(stderr,"MFAG_cp error\n");
      return 0;   
    }
    for(n=0;n<N;n++)
    {
      *(pc_eta_epsilon_alpha+n)=0.;
      for(k=0;k<N;k++) 
	if(kern==NULL)
	{
	  if((*(alpha+n)-*epsilon<beta_min+k*dbeta)&&
	     (beta_min+k*dbeta<*(alpha+n)+*epsilon))   
	    *(pc_eta_epsilon_alpha+n)+=
	      pow(eta,-*(alpha+n))*(-log(eta))/
	      (pow(eta,-*epsilon)-pow(eta,*epsilon))*
	      *(pc_eta_beta+k)*pow(eta,(beta_min+n*dbeta))*dbeta;
	}
	else
	  *(pc_eta_epsilon_alpha+n)+=
	    MFAG_ke(kern,*(epsilon+n),*(alpha+n),beta_min+k*dbeta)*
	    *(pc_eta_beta+k)*dbeta;    
    }
    free((char*)pc_eta_beta); 
    return 1;
  } 
  else 
  {
    fprintf(stderr,"MFAG_kcpe arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on Hoelder exponents                  */
/* with horizontal sections, with precision, with size, with kernel         */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_kcfge(J, eta, M, x, alpha_eta_x, t_adap, t_kern, t_norm, N, epsilon, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha, epsilon_star)
     short int J;
     double *eta;
     int M;
     double *x;
     double *alpha_eta_x;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
     double *epsilon_star;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_kcfge(J, eta, M, x, alpha_eta_x, t_adap, t_kern, t_norm, N, epsilon, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha, epsilon_star)
     short int J;
     double *eta;
     int M;
     double *x;
     double *alpha_eta_x;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
     double *epsilon_star;
#else /* __STDC__ */
int MFAG_kcfge(short J,double* eta,int M,double* x,double* alpha_eta_x,MFAGt_adap t_adap,MFAMt_kern t_kern,MFAGt_norm t_norm,short N,double* epsilon,double* alpha,double* pc_eta_epsilon_alpha,double* fgc_eta_epsilon_alpha,double* epsilon_star)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((J>0)&&(eta!=NULL)&&(M>0)&&(alpha_eta_x!=NULL)&&(N>0)&&(epsilon!=NULL)&&(pc_eta_epsilon_alpha!=NULL)&&(fgc_eta_epsilon_alpha!=NULL)&&(epsilon_star!=NULL))
  {
    register int j=0;
    /* modif bertrand */
#ifndef __STDC__
    double (*kern)();
#else
    double (*kern)(double);
#endif
    switch(t_kern)
    {  
    case MFAM_INTEGRATED:
      kern=NULL;
      break;
    case MFAM_BOXCAR:
      kern=MFAM_boxcar;
      break; 
    case MFAM_TRIANGLE:
      kern=MFAM_triangle;
      break; 
    case MFAM_GAUSSIAN:
      kern=MFAM_gauss;
      break;
    case MFAM_MOLLIFIER:
      kern=MFAM_mol;
      break; 
    case MFAM_EPANECHNIKOV:
      kern=MFAM_epa;
      break; 
    default:
      kern=NULL;
      break;
    } 
    if(MFAG_hoelder(M,J,alpha_eta_x,N,alpha)==0)
    {
      fprintf(stderr,"MFAG_hoelder error\n"); 
      return 0;
    }  
    for(j=0;j<J;j++)
    {
      if(MFAM_iszeros(N,epsilon)==1)
      {
	if(MFAG_adaptation(M,alpha_eta_x+M*j,N,alpha,epsilon_star+N*j,t_adap)==0)
	{
	  fprintf(stderr,"MFAG_adaptation error\n");
	  return 0;
	}  
	if(MFAG_kcpe(*(eta+j),M,x,alpha_eta_x+M*j,kern,N,epsilon_star+N*j,alpha,pc_eta_epsilon_alpha+N*j)==0)
	{
	  fprintf(stderr,"MFAG_kcpe error\n"); 
	  return 0;
	}
	if(MFAG_norm(t_norm,*(eta+j),N,epsilon_star,pc_eta_epsilon_alpha+N*j,fgc_eta_epsilon_alpha+N*j)==0)
        {
	  fprintf(stderr,"MFAG_norm error\n");
	  return 0;   
	}
      }
      else
      {
	if(MFAG_kcpe(*(eta+j),M,x,alpha_eta_x+M*j,kern,N,epsilon,alpha,pc_eta_epsilon_alpha+N*j)==0)
	{
	  fprintf(stderr,"MFAG_kcpe error\n"); 
	  return 0;
	}
	if(MFAG_norm(t_norm,*(eta+j),N,epsilon,pc_eta_epsilon_alpha+N*j,fgc_eta_epsilon_alpha+N*j)==0)
	{
	  fprintf(stderr,"MFAG_norm error\n");
	  return 0;   
	}
      }     
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_kcfge arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on measures                           */
/* with horizontal sections, with precison, with size, with kernel          */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_mkcfge(N_n, I_n, mu_n, t_ball, t_prog, J, a, A, M, eta, x, alpha_eta_x, t_adap, t_kern, t_norm, N, epsilon, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha, epsilon_star)
     int N_n;
     double *I_n;
     double *mu_n;
     MFAMt_ball t_ball;
     MFAMt_prog t_prog;
     short int J;
     double a;
     double A;
     int M;
     double *eta;
     double *x;
     double *alpha_eta_x;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
     double *epsilon_star;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_mkcfge(N_n, I_n, mu_n, t_ball, t_prog, J, a, A, M, eta, x, alpha_eta_x, t_adap, t_kern, t_norm, N, epsilon, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha, epsilon_star)
     int N_n;
     double *I_n;
     double *mu_n;
     MFAMt_ball t_ball;
     MFAMt_prog t_prog;
     short int J;
     double a;
     double A;
     int M;
     double *eta;
     double *x;
     double *alpha_eta_x;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
     double *epsilon_star;
#else /* __STDC__ */
int MFAG_mkcfge(int N_n,double* I_n,double* mu_n,MFAMt_ball t_ball,MFAMt_prog t_prog,short J,double a,double A,int M,double* eta,double* x,double *alpha_eta_x,MFAGt_adap t_adap,MFAMt_kern t_kern,MFAGt_norm t_norm,short N,double* epsilon,double* alpha,double* pc_eta_epsilon_alpha,double* fgc_eta_epsilon_alpha,double* epsilon_star)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((N_n>0)&&(mu_n!=NULL)&(J>0)&&(a>=1.)&&(A>=a)&&(M>=N_n)&&(eta!=NULL)&&(alpha_eta_x!=NULL)&&(N>0)&&(epsilon!=NULL)&&(alpha!=NULL)&&(pc_eta_epsilon_alpha!=NULL)&&(fgc_eta_epsilon_alpha!=NULL)&&(epsilon_star!=NULL))
  {
    if(MFAG_mch1d(N_n,I_n,mu_n,t_prog,t_ball,J,a,A,M,eta,x,alpha_eta_x)==0)
    {  
      fprintf(stderr,"MFAG_mch1d error\n");  
      return 0;  
    }
    if(MFAG_kcfge(J,eta,M,x,alpha_eta_x,t_adap,t_kern,t_norm,N,epsilon,alpha,pc_eta_epsilon_alpha,fgc_eta_epsilon_alpha,epsilon_star)==0)
    {  
      fprintf(stderr,"MFAG_kcfge error\n");  
      return 0;  
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_mkcfge arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on function                           */
/* with horizontal sections, with precison, with size, with kernel          */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_fkcfge(M, x, f_x, t_prog, t_osc, p, S_min, S_max, J, eta, alpha_eta_x, N, epsilon, t_adap, t_kern, t_norm, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha, epsilon_star)
     int M;
     double *x;
     double *f_x;
     MFAMt_prog t_prog;
     MFAMt_osc t_osc;
     double p;
     double S_min;
     double S_max;
     short int J;
     double *eta;
     double *alpha_eta_x;
     short int N;
     double *epsilon;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
     double *epsilon_star;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_fkcfge(M, x, f_x, t_prog, t_osc, p, S_min, S_max, J, eta, alpha_eta_x, N, epsilon, t_adap, t_kern, t_norm, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha, epsilon_star)
     int M;
     double *x;
     double *f_x;
     MFAMt_prog t_prog;
     MFAMt_osc t_osc;
     double p;
     double S_min;
     double S_max;
     short int J;
     double *eta;
     double *alpha_eta_x;
     short int N;
     double *epsilon;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
     double *epsilon_star;
#else /* __STDC__ */
int MFAG_fkcfge(int M,double* x,double* f_x,MFAMt_prog t_prog,MFAMt_osc t_osc,double p,double S_min,double S_max,short J,double* eta,double* alpha_eta_x,short N,double* epsilon,MFAGt_adap t_adap,MFAMt_kern t_kern,MFAGt_norm t_norm,double* alpha,double* pc_eta_epsilon_alpha,double* fgc_eta_epsilon_alpha,double* epsilon_star)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(f_x!=NULL)&&(p>=1.)&&(1.<=S_min)&&(S_min<=S_max)&&(S_max<=M/2.)&&(J>0)&&(eta!=NULL)&&(alpha_eta_x!=NULL)&&(N>0)&&(epsilon!=NULL)&&(alpha!=NULL)&&(pc_eta_epsilon_alpha!=NULL)&&(fgc_eta_epsilon_alpha!=NULL)&&(epsilon_star!=NULL))
  {
    if(MFAG_fch1d(M,x,f_x,J,S_min,S_max,t_prog,t_osc,p,alpha_eta_x,eta)==0)
    {
      fprintf(stderr,"MFAG_fch1d error\n"); 
      return 0;
    }  
    if(MFAG_kcfge(J,eta,M,x,alpha_eta_x,t_adap,t_kern,t_norm,N,epsilon,alpha,pc_eta_epsilon_alpha,fgc_eta_epsilon_alpha,epsilon_star)==0)
    {  
      fprintf(stderr,"MFAG_kcfge error\n");  
      return 0;  
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_fkcfge arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/*****************************************************************************/
/* vertical sections                                                         */
/*****************************************************************************/
/*****************************************************************************/

/* #define JETAX */
/* #define EXTREMA */

/*****************************************************************************/
/* g_\eta^\epsilon(x,y):=\min\{y+\epsilon,f_\eta^+(x)\}-                     */
/* \max\{y-\epsilon,f_\eta^-(x)\}                                            */
/*****************************************************************************/

#ifndef __STDC__
double MFAG_g_eta_epsilon_x_y(M, dx, f_eta_x, k, eta, epsilon, y)
     int M;
     double dx;
     double *f_eta_x;
     int k;
     double eta;
     double epsilon;
     double y;
#else /* __STDC__ */
#ifndef __STDC__
double MFAG_g_eta_epsilon_x_y(M, dx, f_eta_x, k, eta, epsilon, y)
     int M;
     double dx;
     double *f_eta_x;
     int k;
     double eta;
     double epsilon;
     double y;
#else /* __STDC__ */
double MFAG_g_eta_epsilon_x_y(int M,double dx,double* f_eta_x,int k,double eta,double epsilon,double y)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(f_eta_x!=NULL)&&(k>=0)&&(k<M)&&(eta>=dx)&&(epsilon>0.))
  {
    register int l=0; 
    int n_e=(int)floor(eta/dx),l_min=0,l_max=0;
    double f_eta_x_plus=-HUGE,f_eta_x_minus=HUGE,g_eta_epsilon_x_y=0.;
    if((y-epsilon<=*(f_eta_x+k))&&(*(f_eta_x+k)<=y+epsilon))
    {   
      if((k>=0)&&(k<n_e))
      {
	l_min=-k;
	l_max=n_e;
      }
      else
	if((k>=n_e)&&(k<M-n_e))
	{
	  l_min=-n_e;
	  l_max=n_e;
	}
      else
	if((k>=M-n_e)&&(k<M)) 
	{
	  l_min=-n_e;  
	  l_max=M-k;
	}
      for(l=l_min;l<=l_max;l++)
      {
	f_eta_x_minus=(*(f_eta_x+k+l)<f_eta_x_minus?
		       *(f_eta_x+k+l):f_eta_x_minus);
	f_eta_x_plus=(*(f_eta_x+k+l)>f_eta_x_plus?
		      *(f_eta_x+k+l):f_eta_x_plus);
      }
      if(f_eta_x_plus-f_eta_x_minus!=0.)
	g_eta_epsilon_x_y=
	  (y+epsilon<f_eta_x_plus?y+epsilon:f_eta_x_plus)-
	  (y-epsilon>f_eta_x_minus?y-epsilon:f_eta_x_minus);
      else 
	g_eta_epsilon_x_y=1.;
      g_eta_epsilon_x_y/=(double)(2*n_e)/(double)(l_max-l_min);
    /*   g_eta_epsilon_x_y/=(double)(l_max-l_min)/(double)(2*n_e); */
     /*  fprintf(stderr,"%d %f\n",k,(double)(l_max-l_min)/(double)(2*n_e)); */
    } 
    return g_eta_epsilon_x_y;
  }
  else 
  {
    fprintf(stderr,"MFAG_g_eta_epsilon_x_y arguments error\n");
    return 0;
  }
}

#if 0
double MFAG_g_eta_epsilon_x_y(int M,double dx,double *f_eta_x,int k,double eta,double epsilon,double y)
{
  if((M>0)&&(dx>0.)&&(f_eta_x!=NULL)&&(k>=0)&&(k<M)&&(eta>=dx)&&(epsilon>0.))
  {
    register int l=0; 
    int n_e=(int)floor(eta/dx);
    double f_eta_x_plus=-20.,f_eta_x_minus=20.,g_eta_epsilon_x_y=0.; 
    if((k>=n_e)&&(k<M-n_e)&&
       (y-epsilon<=*(f_eta_x+k))&&
       (*(f_eta_x+k)<=y+epsilon))
    {
      for(l=-n_e;l<=n_e;l++)
      {
	f_eta_x_minus=(*(f_eta_x+k+l)<f_eta_x_minus?
		       *(f_eta_x+k+l):f_eta_x_minus);
	f_eta_x_plus=(*(f_eta_x+k+l)>f_eta_x_plus?
		      *(f_eta_x+k+l):f_eta_x_plus);
      }
      g_eta_epsilon_x_y=
	(y+epsilon<f_eta_x_plus?y+epsilon:f_eta_x_plus)-
	(y-epsilon>f_eta_x_minus?y-epsilon:f_eta_x_minus);
    }
    return g_eta_epsilon_x_y;
  }
  else 
  {
    fprintf(stderr,"MFAG_g_eta_epsilon_x_y arguments error\n");
    return 0;
  }
}
#endif /* 0 */

/****************************************************************************/
/* p_\eta^{c,\epsilon}(y)=\frac{1}{2\epsilon}\int_a^bg_\eta^\epsilon(x,y)dx */
/****************************************************************************/

#ifndef __STDC__
int MFAG_vpc_eta_epsilon_y(M, dx, f_eta_x, eta, N, epsilon, y, pc_eta_epsilon_y)
     int M;
     double dx;
     double *f_eta_x;
     double eta;
     short int N;
     double epsilon;
     double *y;
     double *pc_eta_epsilon_y;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_vpc_eta_epsilon_y(M, dx, f_eta_x, eta, N, epsilon, y, pc_eta_epsilon_y)
     int M;
     double dx;
     double *f_eta_x;
     double eta;
     short int N;
     double epsilon;
     double *y;
     double *pc_eta_epsilon_y;
#else /* __STDC__ */
int MFAG_vpc_eta_epsilon_y(int M,double dx,double* f_eta_x,double eta,short N,double epsilon,double* y,double* pc_eta_epsilon_y)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(f_eta_x!=NULL)&&(eta>=dx)&&(N>0)&&(epsilon>0.)&&(y!=NULL)&&(pc_eta_epsilon_y!=NULL))
  {
    register int n=0,m=0;
    for(n=0;n<N;n++)
    { 
      *(pc_eta_epsilon_y+n)=0.;	 
      for(m=0;m<M;m++)
	*(pc_eta_epsilon_y+n)+=1./(2.*epsilon)
	  *MFAG_g_eta_epsilon_x_y(M,dx,f_eta_x,m,eta,epsilon,*(y+n))*dx;
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_vpc_eta_epsilon_y arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on Hoelder exponents                  */
/* with vertical sections, with size, with precison, without kern           */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_vcfge(M, dx, alpha_eta_x, eta, t_norm, N, epsilon, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha)
     int M;
     double dx;
     double *alpha_eta_x;
     double eta;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_vcfge(M, dx, alpha_eta_x, eta, t_norm, N, epsilon, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha)
     int M;
     double dx;
     double *alpha_eta_x;
     double eta;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
#else /* __STDC__ */
int MFAG_vcfge(int M,double dx,double* alpha_eta_x,double eta,MFAGt_norm t_norm,short N,double* epsilon,double* alpha,double* pc_eta_epsilon_alpha,double* fgc_eta_epsilon_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((M>0)&&(dx>0.)&&(alpha_eta_x!=NULL)&&(eta>=dx)&&(N>0)&&(epsilon!=NULL)&&(*epsilon>=0.)&&(alpha!=NULL)&&(pc_eta_epsilon_alpha!=NULL)&&(fgc_eta_epsilon_alpha!=NULL))
  {
    if(MFAG_hoelder(M,1,alpha_eta_x,N,alpha)==0)
    {
      fprintf(stderr,"MFAG_hoelder error\n"); 
      return 0;
    } 
    if(*epsilon==0.)
    {
      if(MFAG_adaptation(M,alpha_eta_x,N,alpha,epsilon,MFAG_MAXDEV)==0)
      {
	fprintf(stderr,"MFAM_adaptation error\n"); 
	return 0;
      }
    }  
    if(MFAG_vpc_eta_epsilon_y(M,dx,alpha_eta_x,eta,N,*epsilon,alpha,pc_eta_epsilon_alpha)==0)
    {
      fprintf(stderr,"MFAG_vpc_eta_epsilon_y error\n");
      return 0;
    } 
    if(MFAG_norm(t_norm,eta,N,NULL,pc_eta_epsilon_alpha,fgc_eta_epsilon_alpha)==0)
    {
      fprintf(stderr,"MFAG_norm error\n");
      return 0;   
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_vcfge arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on measures                           */
/* (with vertical sections, with precison, with size, without kernel)       */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_mvcfge(N_n, I_n, mu_n, M, a, yflg, t_norm, N, epsilon, alpha, pc_eta_epsilon_y, fgc_eta_epsilon_y)
     int N_n;
     double *I_n;
     double *mu_n;
     int M;
     double a;
     int yflg;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_y;
     double *fgc_eta_epsilon_y;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_mvcfge(N_n, I_n, mu_n, M, a, yflg, t_norm, N, epsilon, alpha, pc_eta_epsilon_y, fgc_eta_epsilon_y)
     int N_n;
     double *I_n;
     double *mu_n;
     int M;
     double a;
     int yflg;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_y;
     double *fgc_eta_epsilon_y;
#else /* __STDC__ */
int MFAG_mvcfge(int N_n,double* I_n,double* mu_n,int M,double a,int yflg,MFAGt_norm t_norm,short N,double* epsilon,double* alpha,double* pc_eta_epsilon_y,double* fgc_eta_epsilon_y)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((N_n>0)&&(mu_n!=NULL)&&(M>0)&&(a>=1.)&&(N>0)&&(epsilon!=NULL)&&(*epsilon>=0.)&&(alpha!=NULL)&&(pc_eta_epsilon_y!=NULL)&&(fgc_eta_epsilon_y!=NULL))
  {   
    /* register int n=0; */
    double eta=a/N_n,x_min=eta/2.,x_max=1-x_min,dx=(x_max-x_min)/(double)(M-1);
   /*  double* y=alpha; */
   /*  if(yflg==1) */
/*     { */
/*       double* f_eta_x=NULL; */
/*       if((f_eta_x=(double*)malloc((unsigned)(M*sizeof(double))))==NULL) */
/*       { */
/* 	fprintf(stderr,"malloc error\n");  */
/* 	return 0; */
/*       }   */
/*       FRflg=1; */
/*       for(n=0;n<M;n++) */
/* 	*(f_eta_x+n)=MFAM_mu_eta_c_x(N_n,I_n,mu_n,eta,x_min,x_max,x_min+n*dx); */
/*       if(MFAG_hoelder(M,1,f_eta_x,N,y,NULL)==0) */
/*       { */
/* 	fprintf(stderr,"MFAG_hoelder error\n");  */
/* 	return 0; */
/*       }   */
/*       if(*epsilon==0.) */
/*       { */
/* 	if(MFAG_adaptation(M,f_eta_x,N,alpha,epsilon,MFAG_MAXDEV)==0)  */
/* 	{  */
/* 	  fprintf(stderr,"MFAG_adaptation error\n");   */
/* 	  return 0;  */
/* 	} */
/*       } */
/*       if(MFAG_vfgc_eta_epsilon_y(M,dx,f_eta_x,eta,*epsilon,N,y,pc_eta_epsilon_y,fgc_eta_epsilon_y)==0) */
/*       { */
/* 	fprintf(stderr,"MFAG_vfgc_eta_epsilon_y error\n");  */
/* 	return 0; */
/*       } */
/*       free((char*)f_eta_x); */
/*       for(n=0;n<M;n++) */
/* 	*(alpha+n)=log(*(y+n))/log(a/(double)N_n); */
/*     } */
/*     else */
    {
      double* alpha_eta_x=NULL;
      if((alpha_eta_x=(double*)malloc((unsigned)(M*sizeof(double))))==NULL)
      {
	fprintf(stderr,"malloc error\n"); 
	return 0;
      }  
      if(MFAG_alpha_eta_c_x(N_n,I_n,mu_n,eta,M,x_min,x_max,dx,alpha_eta_x)==0)
      {  
	fprintf(stderr,"MFAG_alpha_eta_x error\n");  
	return 0;  
      }
      if(MFAG_vcfge(M,dx,alpha_eta_x,eta,t_norm,N,epsilon,alpha,pc_eta_epsilon_y,fgc_eta_epsilon_y)==0)
      {  
	fprintf(stderr,"MFAG_vcfge error\n");  
	return 0;  
      }
      free((char*)alpha_eta_x);
    }  
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_mvcfge arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* with vertical sections, with precison, with size, with kernel            */
/*****************************************************************************/

#ifndef __STDC__
double MFAG_kg_eta_epsilon_x_alpha(M, dx, alpha_eta_x, m, eta, epsilon, kern, alpha)
     int M;
     double dx;
     double *alpha_eta_x;
     int m;
     double eta;
     double epsilon;
     double (*kern)();
     double alpha;
#else /* __STDC__ */
#ifndef __STDC__
double MFAG_kg_eta_epsilon_x_alpha(M, dx, alpha_eta_x, m, eta, epsilon, kern, alpha)
     int M;
     double dx;
     double *alpha_eta_x;
     int m;
     double eta;
     double epsilon;
     double (*kern)();
     double alpha;
#else /* __STDC__ */
double MFAG_kg_eta_epsilon_x_alpha(int M,double dx,double* alpha_eta_x,int m,double eta,double epsilon,double (*kern)(double),double alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(alpha_eta_x!=NULL)&&(m>=0)&&(m<M)&&(eta>=dx)&&(epsilon>0.))
  {
    register int l=0; 
    int n_e=(int)floor(eta/dx),l_min=0,l_max=0;
    double alpha_eta_x_plus=-HUGE,alpha_eta_x_minus=HUGE,g_eta_epsilon_x_alpha=0.;
    if((alpha-epsilon<=*(alpha_eta_x+m))&&(*(alpha_eta_x+m)<=alpha+epsilon))
    {   
      if((m>=0)&&(m<n_e))
      {
	l_min=-m;
	l_max=n_e;
      }
      else
	if((m>=n_e)&&(m<M-n_e))
	{
	  l_min=-n_e;
	  l_max=n_e;
	}
      else
	if((m>=M-n_e)&&(m<M)) 
	{
	  l_min=-n_e;  
	  l_max=M-m;
	}
      for(l=l_min;l<=l_max;l++)
      {
	alpha_eta_x_minus=(*(alpha_eta_x+m+l)<alpha_eta_x_minus?
			   *(alpha_eta_x+m+l):alpha_eta_x_minus);
	alpha_eta_x_plus=(*(alpha_eta_x+m+l)>alpha_eta_x_plus?
			  *(alpha_eta_x+m+l):alpha_eta_x_plus);
      }
      if(kern==NULL)
      {
	if(alpha_eta_x_plus-alpha_eta_x_minus!=0.)
	  g_eta_epsilon_x_alpha=
	    (alpha+epsilon<alpha_eta_x_plus?alpha+epsilon:alpha_eta_x_plus)-
	    (alpha-epsilon>alpha_eta_x_minus?alpha-epsilon:alpha_eta_x_minus);
	else 
	  g_eta_epsilon_x_alpha=1.;
      }
      else
      {
	register int k=0;
	int K=100;
	double p=5.,dbeta=(alpha_eta_x_plus-alpha_eta_x_minus)/(K-1),beta_min=alpha_eta_x_minus,mod_J_eta_x=0.;
	for(k=0;k<K;k++)
	  g_eta_epsilon_x_alpha+=
	    (pow(kern((beta_min+k*dbeta-alpha)/epsilon),p))*dbeta;
#ifdef JETAX
	mod_J_eta_x=alpha_eta_x_plus-alpha_eta_x_minus;
#else /* JETAX */
	mod_J_eta_x=1.;
#endif /* JETAX */
	g_eta_epsilon_x_alpha/=mod_J_eta_x;
      }
    }
    return g_eta_epsilon_x_alpha;
  }
  else 
  {
    fprintf(stderr,"MFAG_g_eta_epsilon_x_alpha arguments error\n");
    return 0;
  }
}


/*****************************************************************************/
/* with vertical sections, with precison, with size, with kernel            */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_vkcpe(M, dx, alpha_eta_x, eta, kern, N, epsilon, alpha, pc_eta_epsilon_alpha)
     int M;
     double dx;
     double *alpha_eta_x;
     double eta;
     double (*kern)();
     int N;
     double epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_vkcpe(M, dx, alpha_eta_x, eta, kern, N, epsilon, alpha, pc_eta_epsilon_alpha)
     int M;
     double dx;
     double *alpha_eta_x;
     double eta;
     double (*kern)();
     int N;
     double epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
#else /* __STDC__ */
int MFAG_vkcpe(int M,double dx,double* alpha_eta_x,double eta,double (*kern)(double),int N,double epsilon,double* alpha,double* pc_eta_epsilon_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(alpha_eta_x!=NULL)&&(eta>=dx)&&(epsilon>0.)&&(N>0)&&(alpha!=NULL)&&(pc_eta_epsilon_alpha!=NULL))
  {
    register int n=0,m=0;
    double g_eta_epsilon_x_alpha=0.;
#ifdef EXTREMA    
    double *alpha_eta_x_minus=NULL,*alpha_eta_x_plus=NULL;
    if((alpha_eta_x_minus=(double*)malloc(M*sizeof(double)))==NULL) 
    {  
      fprintf(stderr,"malloc error\n"); 
      return 0;  
    }  
    if((alpha_eta_x_plus=(double*)malloc(M*sizeof(double)))==NULL) 
    {  
      fprintf(stderr,"malloc error\n"); 
      return 0;  
    }  
    if(MFAG_alpha_eta_x_extrema(M,dx,alpha_eta_x,eta,epsilon,alpha_eta_x_minus,alpha_eta_x_plus)==0) 
    {  
      fprintf(stderr,"MFAG_alpha_eta_x_extrema error\n"); 
      return 0;  
    }  
    fprintf(stdout,"\n\"alpha_eta_x\n");
    for(n=0;n<M;n++)
      fprintf(stdout,"%f %f\n",eta/2.+n*dx,*(alpha_eta_x+n)); 
    fprintf(stdout,"\n\"alpha_eta_minus_x\n");
    for(n=0;n<M;n++)
      fprintf(stdout,"%f %f\n",eta/2.+n*dx,*(alpha_eta_x_minus+n));
    fprintf(stdout,"\n\"alpha_eta_plus_x\n");
    for(n=0;n<M;n++)
      fprintf(stdout,"%f %f\n",eta/2.+n*dx,*(alpha_eta_x_plus+n));
    fprintf(stdout,"\n\"mod_J_eta_x\n"); 
    for(n=0;n<M;n++)
      fprintf(stdout,"%f %f\n",eta/2.+n*dx,*(alpha_eta_x_plus+n)-*(alpha_eta_x_minus+n));    
    free((char*)alpha_eta_x_minus);
    free((char*)alpha_eta_x_plus);
    exit(0);
#endif /* EXTREMA */
    for(n=0;n<N;n++)
    { 
      *(pc_eta_epsilon_alpha+n)=0.;	 
      for(m=0;m<M;m++)
      {
	g_eta_epsilon_x_alpha=MFAG_kg_eta_epsilon_x_alpha(M,dx,alpha_eta_x,m,eta,epsilon,kern,*(alpha+n));
	*(pc_eta_epsilon_alpha+n)+=1./(2.*epsilon)*g_eta_epsilon_x_alpha*dx;
      }
    }
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_vkcpe arguments error\n");
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on measures                           */
/* with vertical sections, with precison, with size, with kernel            */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_mvkcfge(N_n, I_n, mu_n, M, a, t_kern, t_norm, N, epsilon, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha)
     int N_n;
     double *I_n;
     double *mu_n;
     int M;
     double a;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_mvkcfge(N_n, I_n, mu_n, M, a, t_kern, t_norm, N, epsilon, alpha, pc_eta_epsilon_alpha, fgc_eta_epsilon_alpha)
     int N_n;
     double *I_n;
     double *mu_n;
     int M;
     double a;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     short int N;
     double *epsilon;
     double *alpha;
     double *pc_eta_epsilon_alpha;
     double *fgc_eta_epsilon_alpha;
#else /* __STDC__ */
int MFAG_mvkcfge(int N_n,double* I_n,double* mu_n,int M,double a,MFAMt_kern t_kern,MFAGt_norm t_norm,short N,double* epsilon,double* alpha,double* pc_eta_epsilon_alpha,double* fgc_eta_epsilon_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((N_n>0)&&(mu_n!=NULL)&&(M>0)&&(a>=1.)&&(N>0)&&(epsilon!=NULL)&&(*epsilon>=0.)&&(alpha!=NULL)&&(pc_eta_epsilon_alpha!=NULL)&&(fgc_eta_epsilon_alpha!=NULL))
  {
    double eta=a/N_n,x_min=eta/2.,x_max=1-x_min,dx=(x_max-x_min)/(double)(M-1);
    double* alpha_eta_x=NULL;
#ifndef __STDC__
    double (*kern)()=NULL;
#else
    double (*kern)(double)=NULL;
#endif

    if((alpha_eta_x=(double*)malloc((unsigned)(M*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n"); 
      return 0;
    }  
    if(MFAG_alpha_eta_c_x(N_n,I_n,mu_n,eta,M,x_min,x_max,dx,alpha_eta_x)==0)  
    {  
      fprintf(stderr,"MFAG_alpha_eta_x error\n");  
      return 0;  
    }
    if(MFAG_hoelder(M,1,alpha_eta_x,N,alpha)==0)
    {
      fprintf(stderr,"MFAG_hoelder error\n"); 
      return 0;
    } 
    if(*epsilon==0.)
    { 
      if(MFAG_adaptation(M,alpha_eta_x,N,alpha,epsilon,MFAG_MAXDEV)==0) 
      { 
	fprintf(stderr,"MFAG_adaptation error\n");  
	return 0; 
      }
    }  
    switch(t_kern)
    {
    case MFAM_BOXCAR:
      kern=MFAM_boxcar;
      break; 
    case MFAM_TRIANGLE:
      kern=MFAM_triangle;
      break; 
    case MFAM_GAUSSIAN:
      kern=MFAM_gauss;
      break;
    case MFAM_MOLLIFIER:
      kern=MFAM_mol;
      break; 
    case MFAM_EPANECHNIKOV:
      kern=MFAM_epa;
      break; 
    default:
      kern=NULL;
      break;
    }
    if(MFAG_vkcpe(M,dx,alpha_eta_x,eta,kern,N,*epsilon,alpha,pc_eta_epsilon_alpha)==0)
    {
      fprintf(stderr,"MFAG_vkcpe error\n"); 
      return 0;
    } 
    if(MFAG_norm(t_norm,eta,N,NULL,pc_eta_epsilon_alpha,fgc_eta_epsilon_alpha)==0)
    {
      fprintf(stderr,"MFAG_norm error\n");
      return 0;   
    }
    free((char*)alpha_eta_x);
    return 1;
  }
  else 
  {
    fprintf(stderr,"MFAG_mvkcfge arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_contstr(contstr, t_cont)
     char *contstr;
     MFAGt_cont *t_cont;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_contstr(contstr, t_cont)
     char *contstr;
     MFAGt_cont *t_cont;
#else /* __STDC__ */
int MFAG_contstr(char* contstr,MFAGt_cont* t_cont)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if(strcmp(MFAG_HORI2STR,contstr)==0)
    *t_cont=MFAG_HORI2;
  else if(strcmp(MFAG_HORIANYBASESTR,contstr)==0)
    *t_cont=MFAG_HORIANYBASE;
  else if(strcmp(MFAG_HORINOKERNSTR,contstr)==0)
    *t_cont=MFAG_HORINOKERN; 
  else if(strcmp(MFAG_HORIKERNSTR,contstr)==0)
    *t_cont=MFAG_HORIKERN; 
  else if(strcmp(MFAG_VERTNOKERNSTR,contstr)==0)
    *t_cont=MFAG_VERTNOKERN;
  else if(strcmp(MFAG_VERTKERNSTR,contstr)==0)
    *t_cont=MFAG_VERTKERN;
  else 
    return 0;
  return 1;
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on Hoelder exponents                  */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_cfg1d(J, eta, M, x, alpha_eta_x, N, epsilon, t_cont, t_adap, t_kern, t_norm, alpha, pc_alpha, fgc_alpha, epsilon_star)
     short int J;
     double *eta;
     int M;
     double *x;
     double *alpha_eta_x;
     short int N;
     double *epsilon;
     MFAGt_cont t_cont;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     double *alpha;
     double *pc_alpha;
     double *fgc_alpha;
     double *epsilon_star;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_cfg1d(J, eta, M, x, alpha_eta_x, N, epsilon, t_cont, t_adap, t_kern, t_norm, alpha, pc_alpha, fgc_alpha, epsilon_star)
     short int J;
     double *eta;
     int M;
     double *x;
     double *alpha_eta_x;
     short int N;
     double *epsilon;
     MFAGt_cont t_cont;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     double *alpha;
     double *pc_alpha;
     double *fgc_alpha;
     double *epsilon_star;
#else /* __STDC__ */
int MFAG_cfg1d(short J,double* eta,int M,double* x,double* alpha_eta_x,short N,double* epsilon,MFAGt_cont t_cont,MFAGt_adap t_adap,MFAMt_kern t_kern,MFAGt_norm t_norm,double* alpha,double* pc_alpha,double* fgc_alpha,double* epsilon_star)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((J>0)&&(eta!=NULL)&&(M>0)&&(alpha_eta_x!=NULL)&&(N>0)&&(epsilon!=NULL)&&(alpha!=NULL)&&(pc_alpha!=NULL)&&(fgc_alpha!=NULL)&&(epsilon_star!=NULL))
  { 
    int N_n=M;
    switch(t_cont)
    {
    case MFAG_HORI2:
    {
      short n=(short)ceil(log((double)N_n)/log(2.));
      if(pow(2.,(double)n)==N_n)
      {
	if(MFAG_cfg2(n,NULL,alpha_eta_x,t_norm,N,alpha,pc_alpha,fgc_alpha)==0)
        {
	  fprintf(stderr,"MFAG_cfg2 error\n");
	  return 0;
	} 
      }
      break;
    }
    case MFAG_HORIANYBASE:
      if(MFAG_cfgn(N_n,NULL,alpha_eta_x,t_norm,N,alpha,pc_alpha,fgc_alpha)==0)
      {
	fprintf(stderr,"MFAG_cfgn error\n");
	return 0;
      } 
      break;
    case MFAG_HORINOKERN:
      if(MFAG_cfg(J,eta,M,x,alpha_eta_x,t_norm,N,alpha,pc_alpha,fgc_alpha)==0)
      {
	fprintf(stderr,"MFAG_cfg error\n");
	return 0;
      } 
      break;
    case MFAG_HORIKERN:
      if(MFAG_kcfge(J,eta,M,x,alpha_eta_x,t_adap,t_kern,t_norm,N,epsilon,alpha,pc_alpha,fgc_alpha,epsilon_star)==0)
      {
	fprintf(stderr,"MFAG_kcfge error\n");
	return 0;
      } 
      break;
 /*    case MFAG_VERTNOKERN: */
/*       if(MFAG_vcfge(N_n,I_n,mu_n,M,a,2,t_norm,N,epsilon,alpha,pc_alpha,fgc_alpha)==0) */
/*       { */
/* 	fprintf(stderr,"MFAG_vcfge error\n"); */
/* 	return 0; */
/*       }  */
/*       break; */
/*     case MFAG_VERTKERN: */
/*       if(MFAG_vkcfge(N_n,I_n,mu_n,M,a,t_kern,t_norm,N,epsilon,alpha,pc_alpha,fgc_alpha)==0) */
/*       { */
/* 	fprintf(stderr,"MFAG_vkcfge error\n");  */
/* 	return 0; */
/*       } */
/*       break; */
    default:
      fprintf(stderr,"MFAG_cfg1d arguments error\n"); 
      return 0; 
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_cfg1d arguments error\n"); 
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on measures                           */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_mcfg1d(N_n, I_n, mu_n, S_min, S_max, J, t_prog, t_ball, eta, M, x, alpha_eta_x, N, epsilon, t_cont, t_adap, t_kern, t_norm, alpha, pc_alpha, fgc_alpha, epsilon_star)
     int N_n;
     double *I_n;
     double *mu_n;
     double S_min;
     double S_max;
     short int J;
     MFAMt_prog t_prog;
     MFAMt_ball t_ball;
     double *eta;
     int M;
     double *x;
     double *alpha_eta_x;
     short int N;
     double *epsilon;
     MFAGt_cont t_cont;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     double *alpha;
     double *pc_alpha;
     double *fgc_alpha;
     double *epsilon_star;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_mcfg1d(N_n, I_n, mu_n, S_min, S_max, J, t_prog, t_ball, eta, M, x, alpha_eta_x, N, epsilon, t_cont, t_adap, t_kern, t_norm, alpha, pc_alpha, fgc_alpha, epsilon_star)
     int N_n;
     double *I_n;
     double *mu_n;
     double S_min;
     double S_max;
     short int J;
     MFAMt_prog t_prog;
     MFAMt_ball t_ball;
     double *eta;
     int M;
     double *x;
     double *alpha_eta_x;
     short int N;
     double *epsilon;
     MFAGt_cont t_cont;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     double *alpha;
     double *pc_alpha;
     double *fgc_alpha;
     double *epsilon_star;
#else /* __STDC__ */
int MFAG_mcfg1d(int N_n,double* I_n,double* mu_n,double S_min,double S_max,short J,MFAMt_prog t_prog,MFAMt_ball t_ball,double* eta,int M,double* x,double* alpha_eta_x,short N,double* epsilon,MFAGt_cont t_cont,MFAGt_adap t_adap,MFAMt_kern t_kern,MFAGt_norm t_norm,double* alpha,double* pc_alpha,double* fgc_alpha,double* epsilon_star)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((N_n>0)&&(mu_n!=NULL)&&(1.<=S_min)&&(S_min<=S_max)&&(S_max<=N_n)&&(J>0)&&(M>=N_n)&&(eta!=NULL)&&(alpha_eta_x!=NULL)&&(N>0)&&(epsilon!=NULL)&&(alpha!=NULL)&&(pc_alpha!=NULL)&&(fgc_alpha!=NULL)&&(epsilon_star!=NULL))
  { 
    switch(t_cont)
    {
    case MFAG_HORI2:
    {
      short n=(short)ceil(log((double)N_n)/log(2.));
      if(pow(2.,(double)n)==N_n)
      {
	if(MFAG_mcfg2(n,mu_n,alpha_eta_x,t_norm,N,alpha,pc_alpha,fgc_alpha)==0)
        {
	  fprintf(stderr,"MFAG_mcfg2 error\n");
	  return 0;
	} 
      }
      break;
    }
    case MFAG_HORIANYBASE:
      if(MFAG_mcfgn(N_n,mu_n,alpha_eta_x,t_norm,N,alpha,pc_alpha,fgc_alpha)==0)
      {
	fprintf(stderr,"MFAG_mcfgn error\n");
	return 0;
      } 
      break;
    case MFAG_HORINOKERN:
      if(MFAG_mcfg(N_n,I_n,mu_n,t_prog,t_ball,J,S_min,S_max,M,eta,x,alpha_eta_x,t_norm,N,alpha,pc_alpha,fgc_alpha)==0)
      {
	fprintf(stderr,"MFAG_mcfg error\n");
	return 0;
      } 
      break;
    case MFAG_HORIKERN:
      if(MFAG_mkcfge(N_n,I_n,mu_n,t_ball,t_prog,J,S_min,S_max,M,eta,x,alpha_eta_x,t_adap,t_kern,t_norm,N,epsilon,alpha,pc_alpha,fgc_alpha,epsilon_star)==0)
      {
	fprintf(stderr,"MFAG_mkcfge error\n");
	return 0;
      } 
      break;
    case MFAG_VERTNOKERN:
      if(MFAG_mvcfge(N_n,I_n,mu_n,M,S_min,2,t_norm,N,epsilon,alpha,pc_alpha,fgc_alpha)==0)
      {
	fprintf(stderr,"MFAG_mvcfge error\n");
	return 0;
      } 
      break;
    case MFAG_VERTKERN:
      if(MFAG_mvkcfge(N_n,I_n,mu_n,M,S_min,t_kern,t_norm,N,epsilon,alpha,pc_alpha,fgc_alpha)==0)
      {
	fprintf(stderr,"MFAG_mvkcfge error\n"); 
	return 0;
      }
      break;
    default:
      fprintf(stderr,"MFAG_mcfg1d arguments error\n"); 
      return 0; 
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_mcfg1d arguments error\n"); 
    return 0;
  }
}

/*****************************************************************************/
/* Continuous Large Deviation Spectrum on functions                          */
/*****************************************************************************/

#ifndef __STDC__
int MFAG_fcfg1d(M, x, f_x, t_prog, t_osc, p, S_min, S_max, J, eta, alpha_eta_x, N, epsilon, t_cont, t_adap, t_kern, t_norm, alpha, pc_alpha, fgc_alpha, epsilon_star)
     int M;
     double *x;
     double *f_x;
     MFAMt_prog t_prog;
     MFAMt_osc t_osc;
     double p;
     double S_min;
     double S_max;
     short int J;
     double *eta;
     double *alpha_eta_x;
     short int N;
     double *epsilon;
     MFAGt_cont t_cont;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     double *alpha;
     double *pc_alpha;
     double *fgc_alpha;
     double *epsilon_star;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_fcfg1d(M, x, f_x, t_prog, t_osc, p, S_min, S_max, J, eta, alpha_eta_x, N, epsilon, t_cont, t_adap, t_kern, t_norm, alpha, pc_alpha, fgc_alpha, epsilon_star)
     int M;
     double *x;
     double *f_x;
     MFAMt_prog t_prog;
     MFAMt_osc t_osc;
     double p;
     double S_min;
     double S_max;
     short int J;
     double *eta;
     double *alpha_eta_x;
     short int N;
     double *epsilon;
     MFAGt_cont t_cont;
     MFAGt_adap t_adap;
     MFAMt_kern t_kern;
     MFAGt_norm t_norm;
     double *alpha;
     double *pc_alpha;
     double *fgc_alpha;
     double *epsilon_star;
#else /* __STDC__ */
int MFAG_fcfg1d(int M,double* x,double* f_x,MFAMt_prog t_prog,MFAMt_osc t_osc,double p,double S_min,double S_max,short J,double* eta,double* alpha_eta_x,short N,double* epsilon,MFAGt_cont t_cont,MFAGt_adap t_adap,MFAMt_kern t_kern,MFAGt_norm t_norm,double* alpha,double* pc_alpha,double* fgc_alpha,double* epsilon_star)
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((M>0)&&(f_x!=NULL)&&(1.<=S_min)&&(S_min<=S_max)&&(S_max<=M/2.)&&(J>0)&&(eta!=NULL)&&(alpha_eta_x!=NULL)&&(N>0)&&(epsilon!=NULL)&&(alpha!=NULL)&&(pc_alpha!=NULL)&&(fgc_alpha!=NULL)&&(epsilon_star!=NULL))
  { 
    switch(t_cont)
    {
    case MFAG_HORINOKERN:
      if(MFAG_fcfg(M,x,f_x,t_prog,t_osc,p,S_min,S_max,J,eta,alpha_eta_x,t_norm,N,alpha,pc_alpha,fgc_alpha)==0)
      {
	fprintf(stderr,"MFAG_fcfg error\n");
	return 0;
      } 
      break;
    case MFAG_HORIKERN:
      if(MFAG_fkcfge(M,x,f_x,t_prog,t_osc,p,S_min,S_max,J,eta,alpha_eta_x,N,epsilon,t_adap,t_kern,t_norm,alpha,pc_alpha,fgc_alpha,epsilon_star)==0)
      {
	fprintf(stderr,"MFAG_fkcfge error\n");
	return 0;
      } 
      break;
    default:
      fprintf(stderr,"MFAG_fcfg1d arguments error\n"); 
      return 0; 
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_fcfg1d arguments error\n"); 
    return 0;
  }
}

