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

#include <math.h>
#include "MFAM_misc.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAM_compare(d1, d2)
     double *d1;
     double *d2;
#else /* __STDC__ */
int MFAM_compare(double* d1,double* d2)
#endif /* __STDC__ */
{ 
  if (*d1<*d2) 
    return -1;
  else if (*d1>*d2) 
    return 1;  
  else
    return 0;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_base(N_n, b)
     int N_n;
     short int *b;
#else /* __STDC__ */
int MFAM_base(int N_n,short* b)
#endif /* __STDC__ */
{
  if((N_n>0)&&(b!=NULL))
  {
    register int i=2;
    int boolean=1;
    short n=0;

    while((i<10)&&boolean)
    { 
      n=(short)ceil(log((double)N_n)/log((double)i));
      if(((int) pow((double)i,(double)n))==N_n)
      {
	boolean=0;
	*b=i;
      }
      i++;
    }
    return 1;
  }
  else
  { 
    fprintf(stdout,"MFAM_base arguments error\n");
    return 0;   
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_zeros(M, x)
     int M;
     double *x;
#else /* __STDC__ */
int MFAM_zeros(int M,double* x)
#endif /* __STDC__ */
{
  if((M>0)&&(x!=NULL))
  {
    register int m=0;
    for(m=0;m<M;m++)
      *(x+m)=0.;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_zeros arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_iszeros(M, x)
     int M;
     double *x;
#else /* __STDC__ */
int MFAM_iszeros(int M,double* x)
#endif /* __STDC__ */
{
  int boolean=0;
  register int m=0;
  for(m=0;m<M;m++)
    boolean=(*(x+m)==0.);
  return boolean;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_linspace(M, x_min, x_max, x)
     int M;
     double x_min;
     double x_max;
     double *x;
#else /* __STDC__ */
int MFAM_linspace(int M,double x_min,double x_max,double* x)
#endif /* __STDC__ */
{
  if((M>0)&&(x_min<=x_max)&&(x!=NULL))
  {
    register int m=0;
    if(M!=1)
      for(m=0;m<M;m++)
	*(x+m)=x_min+m*(x_max-x_min)/(double)(M-1);
    else
      *x=x_min;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_linspace arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_logspace(M, x_min, x_max, x)
     int M;
     double x_min;
     double x_max;
     double *x;
#else /* __STDC__ */
int MFAM_logspace(int M,double x_min,double x_max,double* x)
#endif /* __STDC__ */
{
  if((M>0)&&(x_min<=x_max)&&(x!=NULL))
  {
    if(M!=1)
    {  
      register int m=0; 
      double r=pow(x_max/x_min,1./(M-1));
      *x=x_min;
      for(m=1;m<M;m++)
	*(x+m)=r**(x+m-1);
    }
    else
      *x=x_min;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_logspace arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_decspace(N_n, M, x_min, x_max, x)
     int N_n;
     int M;
     double x_min;
     double x_max;
     double *x;
#else /* __STDC__ */
int MFAM_decspace(int N_n,int M,double x_min,double x_max,double* x)
#endif /* __STDC__ */
{
  if((M>0)&&(0.<=x_min)&&(x_min<=x_max)&&(x!=NULL))
  {
    register int short n;
    short b=0,n_min=0,n_max=0;
    if(MFAM_base(N_n,&b)==0)
    {
      fprintf(stderr,"MFAM_base error\n");
      return 0;
    }  
    n_min=-log(x_min)/log((double)b);
    n_max=-log(x_max)/log((double)b);
    if(n_max-n_min)
      for(n=n_min;((n>=n_max)&&(n-n_min<=M));n--)
	*(x+n_min-n)=pow((double)b,(double)-n);
    else
      *x=x_min;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_decspace arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_progstr(progstr, t_prog)
     char *progstr;
     MFAMt_prog *t_prog;
#else /* __STDC__ */
int MFAM_progstr(char* progstr,MFAMt_prog* t_prog)
#endif /* __STDC__ */
{
  if(strcmp(MFAM_LINSTR,progstr)==0)
    *t_prog=MFAM_LIN;
  else if(strcmp(MFAM_LOGSTR,progstr)==0)
    *t_prog=MFAM_LOG;
  else if(strcmp(MFAM_DECSTR,progstr)==0)
    *t_prog=MFAM_DEC;
  else 
    return 0;
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_scale(N_n, a, A, J, eta, t_prog)
     int N_n;
     double a;
     double A;
     short int J;
     double *eta;
     MFAMt_prog t_prog;
#else /* __STDC__ */
int MFAM_scale(int N_n,double a,double A,short J,double* eta,MFAMt_prog t_prog)
#endif /* __STDC__ */
{
  if((N_n>0)&&(a>=1)&&(A>=a)&&(A<=N_n)&&(J>0)&&(eta!=NULL))
  {
    double eta_1=a/N_n,eta_J=A/N_n;
    switch(t_prog)
    {
    case MFAM_LIN:
      if(MFAM_linspace(J,eta_1,eta_J,eta)==0)  
      {  
	fprintf(stderr,"MFAM_linspace error\n");  
	return 0;  
      }
      break;
    case MFAM_LOG:  
      if(MFAM_logspace(J,eta_1,eta_J,eta)==0)  
      {  
	fprintf(stderr,"MFAM_logspace error\n");  
	return 0;  
      }  
      break;
    case MFAM_DEC:
      if(MFAM_decspace(N_n,J,eta_1,eta_J,eta)==0)
      {
	fprintf(stderr,"MFAM_decspace error\n");  
	return 0;  
      }
      break;
    } 
  } 
  else
  { 
    fprintf(stderr,"MFAM_scale arguments error\n");
    return 0.;
  }
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_decsizespace(N_n, M, x_min, x_max, x)
     int N_n;
     int M;
     double x_min;
     double x_max;
     double *x;
#else /* __STDC__ */
int MFAM_decsizespace(int N_n,int M,double x_min,double x_max,double* x)
#endif /* __STDC__ */
{
  if((N_n>0)&&(M>0)&&(0.<=x_min)&&(x_min<=x_max)&&(x_max<=N_n/2.)&&(x!=NULL))
  {
    register int short n=0;
    short b=0,n_min=0,n_max=0;
    if(MFAM_base(N_n,&b)==0)
    {
      fprintf(stderr,"MFAM_base error\n");
      return 0;
    }  
    n_min=ceil(log(x_min)/log((double)b));
    n_max=ceil(log(x_max)/log((double)b));
    if(n_max-n_min+1==M)
    {
      if(n_max-n_min)
	for(n=n_min;n<=n_max;n++)
	  *(x+n)=pow((double)b,(double)n);
      else
	*x=x_max;
    }
    else
    {
      fprintf(stderr,"MFAM_decsizespace arguments error\n");
      return 0;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_decsizespace arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_partstr(partstr, t_part)
     char *partstr;
     MFAMt_part *t_part;
#else /* __STDC__ */
int MFAM_partstr(char* partstr,MFAMt_part* t_part)
#endif /* __STDC__ */
{
  if(strcmp(MFAM_LINPARTSTR,partstr)==0)
    *t_part=MFAM_LINPART;
  else if(strcmp(MFAM_LOGPARTSTR,partstr)==0)
    *t_part=MFAM_LOGPART;
  else if(strcmp(MFAM_DECPARTSTR,partstr)==0)
    *t_part=MFAM_DECPART;
  else if(strcmp(MFAM_DECSIZESTR,partstr)==0)
    *t_part=MFAM_DECSIZE;
  else 
    return 0;
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_partspace(N_n, t_part, J, P_min, P_max, P)
     int N_n;
     MFAMt_part t_part;
     int J;
     double P_min;
     double P_max;
     double *P;
#else /* __STDC__ */
int MFAM_partspace(int N_n,MFAMt_part t_part,int J,double P_min,double P_max,double* P)
#endif /* __STDC__ */
{
  if((N_n>0)&&(J>0)&&(1<=P_min)&&(P_min<=P_max)&&(P_max<=N_n)&&(P!=NULL))
  { 
    register int j=0;
    switch(t_part)
    {
    case MFAM_LINPART:
      if(MFAM_linspace(J,P_min,P_max,P)==0)  
      {  
	fprintf(stderr,"MFAM_linspace error\n");  
	return 0;  
      }
      break;
    case MFAM_LOGPART:  
      if(MFAM_logspace(J,P_min,P_max,P)==0)  
      {  
	fprintf(stderr,"MFAM_logspace error\n");  
	return 0;  
      }  
      break;
    case MFAM_DECPART:
      if(MFAM_decspace(N_n,J,P_min,P_max,P)==0)
      {
	fprintf(stderr,"MFAM_decspace error\n");  
	return 0;  
      }
      break;
    default:
      fprintf(stderr,"MFAM_partspace arguments error\n");
      return 0;
    }
    if(J!=1)
      for(j=0;j<J;j++)
	*(P+j)=floor(*(P+j));
    else
      *P=P_min;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_partspace arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_bilogspace(M, d, x_min, x_max, x)
     int M;
     short int d;
     double x_min;
     double x_max;
     double *x;
#else /* __STDC__ */
int MFAM_bilogspace(int M,short d,double x_min,double x_max,double* x)
#endif /* __STDC__ */
{
  if((M>0)&&(x_min<=x_max)&&(x!=NULL))
  {
    if(M!=1)
    {  
      register int m=0; 
      double r=pow(100,1./(M-1));
      if(M%2!=0)
      {
	*(x+M/2)=1;
	for(m=0;m<=M/2-1;m++)
	  *(x+M/2-1-m)=r**(x+M/2-m);
	for(m=M/2+1;m<M;m++)
	  *(x+m)=r**(x+m-1);
	/* for(m=0;m<=M/2-1;m++) */
/* 	  *(x+m)=(*(x+M/2)-*(x+m))/(*x-*(x+M/2)); */
	for(m=M/2;m<M;m++)
	  *(x+m)=d+(*(x+m)-*(x+M/2))/(*(x+M-1)-*(x+M/2))*(x_max-d);
      }
      else
      {
	*(x+M/2)=1;
	for(m=0;m<=M/2-1;m++)
	  *(x+M/2-1-m)=r**(x+M/2-m);
	for(m=M/2+1;m<M;m++)
	  *(x+m)=r**(x+m-1);
	fprintf(stderr,"%f %f %f\n",*x,*(x+M/2),*(x+M-1));
      }
    }
    else
      *x=x_min;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_logspace arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_weights(b, p)
     short int b;
     double *p;
#else /* __STDC__ */
int MFAM_weights(short b,double* p)
#endif /* __STDC__ */
{
  if((b>1)&&(p!=NULL))
  {
    register int i=0;
    double sum_p_1=0.;
    fprintf(stderr,"The chosen base is: b = %d\n",b);
    fprintf(stderr,"Enter the %d weights: \n",b-1);
    for(i=0;i<b-1;i++)
    {
      fprintf(stderr,"\tweight # %d: p_%d = ",i+1,i);
      fscanf(stdin,"%lf",p+i);
      sum_p_1+=*(p+i);
    }
    if(sum_p_1>1.)
    { 
      fprintf(stderr,"The sum of the weights can't be equal to 1.\n");
      return 0;
    }
    *(p+b-1)=1-sum_p_1; 
    fprintf(stderr,"\tweight # %d: p_%d = %.6f\n",b,b-1,*(p+b-1));
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_weights arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_weights2d(bx, by, p)
     short int bx;
     short int by;
     double *p;
#else /* __STDC__ */
int MFAM_weights2d(short bx,short by,double* p)
#endif /* __STDC__ */
{
  if((bx>1)&&(by>1)&&(p!=NULL))
  {
    register int i=0,j=0; 
    double sum_p_1=0.;
    fprintf(stderr,"The chosen bases are: bx = %d, by = %d\n",bx,by);
    fprintf(stderr,"Enter the %d weights: \n",bx*by-1);
    for (i=0;i<bx;i++)
    {
      for (j=0;j<by;j++)
      {    
	if(!((i==bx-1)&&(j==by-1)))
	{   
	  fprintf(stderr,"\tweight # %d: p_%d%d = ",i*by+j+1,i,j);
	  fscanf(stdin,"%lf",p+i*by+j);
	  sum_p_1+=*(p+i*by+j);
	}   
      }
    } 
    if(sum_p_1>1.)
    { 
      fprintf(stderr,"The sum of the weights can't be equal to 1.\n");
      return 0;
    }
    *(p+bx*by-1)=1-sum_p_1; 
    fprintf(stderr,"\tweight # %d: p_%d%d = %.6f\n",bx*by,bx-1,by-1, *(p+bx*by-1));
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_weights2d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_min_max(n, n_sample, min, max)
     int n;
     double *n_sample;
     double *min;
     double *max;
#else /* __STDC__ */
int MFAM_min_max(int n,double* n_sample,double* min,double* max)
#endif /* __STDC__ */
{
  if((n>0)&&(n_sample!=NULL)&&(min!=NULL)&&(max!=NULL))
  {
    register int k=0; 
    *min=20.;
    *max=-20.;
    while(k<n)
    {
      if(*(n_sample+k)!=HUGE)
      {
	*min=(*(n_sample+k)<*min?*(n_sample+k):*min);
	*max=(*(n_sample+k)>*max?*(n_sample+k):*max);
      }
      k++;
    }  
    return 1;
  }
  else
  { 
    fprintf(stderr,"MFAM_min_max arguments error\n");
    return 0;
  }   
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_min_max_dev(n, n_sample, min_dev, max_dev)
     int n;
     double *n_sample;
     double *min_dev;
     double *max_dev;
#else /* __STDC__ */
int MFAM_min_max_dev(int n,double* n_sample,double* min_dev,double* max_dev)
#endif /* __STDC__ */
{
  if((n>0)&&(n_sample!=NULL)&&(max_dev!=NULL)&&(min_dev!=NULL))
  {
    register int k=0;
    double dev=0.;
    while(k<n-1)
    { 
      if((*(n_sample+k)!=HUGE)&&(*(n_sample+k+1)!=HUGE))
      {
	dev=fabs(*(n_sample+k)-*(n_sample+k+1));
	*min_dev=(dev<*min_dev?dev:*min_dev);
	*max_dev=(dev>*max_dev?dev:*max_dev);
      }
      k++;
    }  
    return 1;
  }
  else
  { 
    fprintf(stderr,"MFAM_min_max_dev arguments error\n");
    return 0;   
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_norm(M, s_x, norm_s_x)
     int M;
     double *s_x;
     double *norm_s_x;
#else /* __STDC__ */
int MFAM_norm(int M,double* s_x,double* norm_s_x)
#endif /* __STDC__ */
{
  if((M>0)&&(s_x!=NULL)&&(norm_s_x!=NULL))
  {
    register int k=0;
    double s_x_min=HUGE,s_x_max=-HUGE; 
    if(MFAM_min_max(M,s_x,&s_x_min,&s_x_max)==0)
    { 
      fprintf(stderr,"MFAM_min_max error\n");
      return 0;
    }
    for(k=0;k<M;k++)
      *(norm_s_x+k)=(*(s_x+k)-s_x_min)/(s_x_max-s_x_min);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_norm arguments error\n");
    return 0;
  }
}
