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

#include "MFAS_multinomial_2d.h"

#ifndef __STDC__
static void recursive_mm2d();
static void smm2d();
static void umm2d();
static void rmm2d();
#else /* __STDC__ */
static void recursive_mm2d(short,short,int,int,int,int,double*,double,int,double*);
static void smm2d(short,short,int,int,int,int,double*,double,int,double*);
static void umm2d(short,short,int,int,int,int,double,double,int,double*);
static void rmm2d(short,short,int,int,int,int,double*,double,double,int,double*);
#endif /* __STDC__ */

/*****************/
#ifndef __STDC__
int MFAS_mm2d(n, bx, by, p, mu_n)
     short int n;
     short int bx;
     short int by;
     double *p;
     double *mu_n;
#else /* __STDC__ */
int MFAS_mm2d(short n,short bx,short by,double *p,double *mu_n)
#endif /* __STDC__ */
{ 
  if((n>0)&&(bx>0)&&(by>0)&&(p!=NULL)&&(mu_n!=NULL))
  {
    register int i=1;
    int by_pow_n=(int)pow((double)by,(double)n);
    *mu_n=1.;
    while(i<=n)
    {  
      int bx_pow_i=(int)pow((double)bx,(double)i);
      int bx_pow_i_1=(int)pow((double)bx,(double)i-1); 
      int by_pow_i=(int)pow((double)by,(double)i);
      int by_pow_i_1=(int)pow((double)by,(double)i-1);
      register int k=bx_pow_i-1;
      int jx=bx-1;
      while(jx>=0)
      {
	while(k>=jx*bx_pow_i_1)
	{   
	  register int l=by_pow_i-1;
	  int jy=by-1;
	  while(jy>=0)
	  {
	    while(l>=jy*by_pow_i_1)
	    { 
	      *(mu_n+by_pow_n*k+l)=*(p+jx*by+jy)**(mu_n+by_pow_n*(k-jx*bx_pow_i_1)+l-jy*by_pow_i_1);
	      l--;
	    }
	    jy--;   
	  }
	  k--;  
	}
	jx--;
      }
      i++;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_mm2d arguments error\n");
    return 0;
  }
}

/*****************/
#ifndef __STDC__
int MFAS_recursive_mm2d(n, bx, by, p, mu_n)
     short int n;
     short int bx;
     short int by;
     double *p;
     double *mu_n;
#else /* __STDC__ */
int MFAS_recursive_mm2d(short n,short bx,short by,double *p,double *mu_n)
#endif /* __STDC__ */
{
  if((n>0)&&(bx>0)&&(by>0)&&(p!=NULL)&&(mu_n!=NULL))
  {
    int bx_pow_n=(int)pow((double)bx,(double)n);
    int by_pow_n=(int)pow((double)by,(double)n);
    recursive_mm2d(bx,by,0,0,bx_pow_n,by_pow_n,p,1.,by_pow_n,mu_n);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_recursive_mm2d error\n");
    return 0;
  }
}

/*****************/
#ifndef __STDC__
static void recursive_mm2d(bx, by, i, j, nux_n, nuy_n, p, mu, by_pow_n, mu_n)
     short int bx;
     short int by;
     int i;
     int j;
     int nux_n;
     int nuy_n;
     double *p;
     double mu;
     int by_pow_n;
     double *mu_n;
#else /* __STDC__ */
static void recursive_mm2d(short bx,short by,int i,int j,int nux_n,int nuy_n,double *p,double mu,int by_pow_n,double *mu_n)
#endif /* __STDC__ */
{ 
  if((nux_n>=bx)&&(nuy_n>=by))
  {
    short jx=0,jy=0;
    for(jx=0;jx<bx;jx++)
      for(jy=0;jy<by;jy++)
	recursive_mm2d(bx,by,i+jx*nux_n/bx,j+jy*nuy_n/by,nux_n/bx,nuy_n/by,p,mu**(p+jx*by+jy),by_pow_n,mu_n);
  }
  else
    *(mu_n+i*by_pow_n+j)=mu;
} 

/*****************/
#ifndef __STDC__
int MFAS_smm2d(n, bx, by, p, mu_n)
     short int n;
     short int bx;
     short int by;
     double *p;
     double *mu_n;
#else /* __STDC__ */
int MFAS_smm2d(short n,short bx,short by,double *p,double *mu_n)
#endif /* __STDC__ */
{
  if((n>0)&&(bx>0)&&(by>0)&&(p!=NULL)&&(mu_n!=NULL))
  { 
    time_t time_seed=time(NULL);
    int bx_pow_n=(int)pow((double)bx,(double)n);
    int by_pow_n=(int)pow((double)by,(double)n); 
    srand((unsigned)time_seed);
    smm2d(bx,by,0,0,bx_pow_n,by_pow_n,p,1.,by_pow_n,mu_n);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_smm2d error\n");
    return 0;
  }
}

/*****************/
#ifndef __STDC__
static void smm2d(bx, by, i, j, nux_n, nuy_n, p, mu, by_pow_n, mu_n)
     short int bx;
     short int by;
     int i;
     int j;
     int nux_n;
     int nuy_n;
     double *p;
     double mu;
     int by_pow_n;
     double *mu_n;
#else /* __STDC__ */
static void smm2d(short bx,short by,int i,int j,int nux_n,int nuy_n,double *p,double mu,int by_pow_n,double *mu_n)
#endif /* __STDC__ */
{ 
  if((nux_n>=bx)&&(nuy_n>=by))
  {
    short jx=0,jy=0; 
    MFAM_shuffle(bx*by,p);
    for(jx=0;jx<bx;jx++)
      for(jy=0;jy<by;jy++)
	smm2d(bx,by,i+jx*nux_n/bx,j+jy*nuy_n/by,nux_n/bx,nuy_n/by,p,mu**(p+jx*by+jy),by_pow_n,mu_n);
  }
  else
    *(mu_n+i*by_pow_n+j)=mu;
} 

/*****************/
#ifndef __STDC__
int MFAS_umm2d(n, bx, by, epsilon, mu_n)
     short int n;
     short int bx;
     short int by;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
int MFAS_umm2d(short n,short bx,short by,double epsilon,double *mu_n)
#endif /* __STDC__ */
{
  if((n>0)&&(bx>0)&&(by>0)&&(epsilon>=0.)&&(mu_n!=NULL))
  { 
    time_t time_seed=time(NULL);
    int bx_pow_n=(int)pow((double)bx,(double)n);
    int by_pow_n=(int)pow((double)by,(double)n); 
    srand((unsigned)time_seed);
    umm2d(bx,by,0,0,bx_pow_n,by_pow_n,epsilon,1.,by_pow_n,mu_n);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_umm2d arguments error\n");
    return 0;
  }
}

/*****************/
#ifndef __STDC__
static void umm2d(bx, by, i, j, nux_n, nuy_n, epsilon, mu, by_pow_n, mu_n)
     short int bx;
     short int by;
     int i;
     int j;
     int nux_n;
     int nuy_n;
     double epsilon;
     double mu;
     int by_pow_n;
     double *mu_n;
#else /* __STDC__ */
static void umm2d(short bx,short by,int i,int j,int nux_n,int nuy_n,double epsilon,double mu,int by_pow_n,double *mu_n)
#endif /* __STDC__ */
{ 
  if((nux_n>=bx)&&(nuy_n>=by))
  {
    short jx=0,jy=0;    
    double sum_P=0.,*P=NULL;
    if((P=(double*)malloc((unsigned)(bx*by*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      exit(0);  
    }
    for(jx=0;jx<bx;jx++)
      for(jy=0;jy<by;jy++)
	sum_P+=*(P+jx*by+jy)=MFAM_uniform(epsilon,1-epsilon);
    for(jx=0;jx<bx;jx++)
      for(jy=0;jy<by;jy++)
	umm2d(bx,by,i+jx*nux_n/bx,j+jy*nuy_n/by,nux_n/bx,nuy_n/by,epsilon,mu**(P+jx*by+jy)/sum_P,by_pow_n,mu_n);  
    free((char*)P);
  }
  else
    *(mu_n+i*by_pow_n+j)=mu;
}

/*****************/
#ifndef __STDC__
int MFAS_rmm2d(n, bx, by, p, epsilon, mu_n)
     short int n;
     short int bx;
     short int by;
     double *p;
     double epsilon;
     double *mu_n;
#else /* __STDC__ */
int MFAS_rmm2d(short n,short bx,short by,double *p,double epsilon,double *mu_n)
#endif /* __STDC__ */
{
  if((n>0)&&(bx>0)&&(by>0)&&(p!=NULL)&&(epsilon>=0.)&&(mu_n!=NULL))
  { 
    time_t time_seed=time(NULL);
    int bx_pow_n=(int)pow((double)bx,(double)n);
    int by_pow_n=(int)pow((double)by,(double)n);  
    srand((unsigned)time_seed);
    rmm2d(bx,by,0,0,bx_pow_n,by_pow_n,p,epsilon,1.,by_pow_n,mu_n);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_rmm2d arguments error\n");
    return 0;
  }
}

/*****************/
#ifndef __STDC__
static void rmm2d(bx, by, i, j, nux_n, nuy_n, p, epsilon, mu, by_pow_n, mu_n)
     short int bx;
     short int by;
     int i;
     int j;
     int nux_n;
     int nuy_n;
     double *p;
     double epsilon;
     double mu;
     int by_pow_n;
     double *mu_n;
#else /* __STDC__ */
static void rmm2d(short bx,short by,int i,int j,int nux_n,int nuy_n,double *p,double epsilon,double mu,int by_pow_n,double *mu_n)
#endif /* __STDC__ */
{ 
  if((nux_n>=bx)&&(nuy_n>=by))
  {
    short jx=0,jy=0; 
    double sum_P=0.,*P=NULL;
    if((P=(double*)malloc((unsigned)(bx*by*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      exit(0);  
    } 
    for(jx=0;jx<bx;jx++)
      for(jy=0;jy<by;jy++)
	sum_P+=*(P+jx*by+jy)=MFAM_uniform(*(p+jx*by+jy)-epsilon,*(p+jx*by+jy)+epsilon);
    for(jx=0;jx<bx;jx++)
      for(jy=0;jy<by;jy++)
	rmm2d(bx,by,i+jx*nux_n/bx,j+jy*nuy_n/by,nux_n/bx,nuy_n/by,p,epsilon,mu**(P+jx*by+jy)/sum_P,by_pow_n,mu_n); 
    free((char*)P);
  }
  else
    *(mu_n+i*by_pow_n+j)=mu;
} 

/*****************/
#ifndef __STDC__
int MFAS_mm2d_Z_n_q(bx, by, p, n_nb, n, q_nb, q, Z_n_q)
     short int bx;
     short int by;
     double *p;
     int n_nb;
     short int *n;
     int q_nb;
     double *q;
     double *Z_n_q;
#else /* __STDC__ */
int MFAS_mm2d_Z_n_q(short bx,short by,double *p,int n_nb,short *n,int q_nb,double *q,double *Z_n_q)
#endif /* __STDC__ */
{
  if((bx>0)&&(by>0)&&(p!=NULL)&&(n_nb>0)&&(n!=NULL)&&(q_nb>0)&&(q!=NULL)&&(Z_n_q!=NULL))
  {
    register int k=0,l=0;
    short j=0;
    double chi_q=0.;
    for(l=0;l<n_nb;l++)
      for(k=0;k<q_nb;k++)
      {
	for(j=0;j<bx*by;j++)
	  chi_q+=pow(*(p+j),*(q+k));
	*(Z_n_q+q_nb*l+k)=pow(chi_q,(double)*(n+l));
	chi_q=0.;
      }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_mm2d_Z_n_q arguments error\n");
    return 0;
  }
}

/*****************/
#ifndef __STDC__
int MFAS_mm2d_tau_q(bx, by, p, q_nb, q, tau_q)
     short int bx;
     short int by;
     double *p;
     int q_nb;
     double *q;
     double *tau_q;
#else /* __STDC__ */
int MFAS_mm2d_tau_q(short bx,short by,double *p,int q_nb,double *q,double *tau_q)
#endif /* __STDC__ */
{
  if((bx>0)&&(by>0)&&(p!=NULL)&&(q!=NULL)&&(tau_q!=NULL))
  {
    register int k=0;
    short j=0;
    double chi_q=0.;
    for(k=0;k<q_nb;k++)
    {  
      for(j=0;j<bx*by;j++)
	chi_q+=pow(*(p+j),*(q+k));
      *(tau_q+k)=-2*log(chi_q)/log((double)bx*by); 
      chi_q=0.;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_mm2d_tau_q arguments error\n");
    return 0;
  }
}
