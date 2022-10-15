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

#include "MFAG_discrete.h"

/*****************************************************************************/

int MFAG_N_n_epsilon_alpha(N_n, alpha_n, epsilon, N, alpha, p_alpha)
     int N_n;
     double *alpha_n;
     double epsilon;
     int *N;
     double *alpha;
     double *p_alpha;
{ 
  if((N_n>0)&&(alpha_n!=NULL)&&(epsilon>=0.)&&(N!=NULL)&&(alpha!=NULL)&&(p_alpha!=NULL))
  {
    register k=0,n=0;
    static int (*compare)()=MFAM_compare;
    double alpha_min=0.,alpha_max=0.,min_dev=0.,max_dev=0.; 
    qsort(alpha_n,N_n,sizeof(double),compare);
    alpha_min=*alpha=*alpha_n; 
    alpha_max=*alpha=*(alpha_n+N_n);
    min_dev=alpha_max-alpha_min;
    max_dev=0.;
    if(MFAM_min_max_dev(N_n,alpha_n,&min_dev,&max_dev)==0)
    {
      fprintf(stderr,"find_min_max_dev error\n"); 
      return 0;
    }
    if(epsilon==.0)
      epsilon=max_dev/2.;
    while(k<N_n)
    {
      if((*(alpha+n)!=HUGE)&&(fabs(*(alpha+n)-*(alpha_n+k))>epsilon))
      {
	n++;
	*(alpha+n)=*(alpha_n+k);
      }
      *(p_alpha+n)+=1./(double)N_n;
      k++; 
    }
    *N=n+1;  
    for(n=0;n<*N;n++)
      fprintf(stderr,"%f %f\n",*(alpha+n),*(p_alpha+n));
    return 1;
  }
  else
  { 
    fprintf(stderr,"MFAG_N_n_epsilon_alpha arguments error\n");
    return 0;   
  } 
}

/*****************************************************************************/

int MFAG_fg_n_epsilon(nu_n, alpha_n, epsilon, alpha, normflg, N, p_alpha, fg_alpha)
     int nu_n;
     double *alpha_n;
     double epsilon;
     double *alpha;
     int normflg;
     int *N;
     double *p_alpha;
     double *fg_alpha;
{
  if((nu_n>0)&&(alpha_n!=NULL)&&(epsilon>=0.)&&(alpha!=NULL)&&(fg_alpha!=NULL)&&(N!=NULL))
  {
    register k=0;
    double sup_p_alpha=0.,sup_fg_alpha=0.;
    if(MFAG_N_n_epsilon_alpha(nu_n,alpha_n,epsilon,N,alpha,p_alpha)==0)
    {
      fprintf(stderr,"MFAG_N_n_epsilon_alpha error\n"); 
      return 0;
    }  
    if(normflg==1)
      for(k=0;k<*N;k++)  
	sup_p_alpha=(sup_p_alpha>*(p_alpha+k)?sup_p_alpha:*(p_alpha+k));  
    for(k=0;k<*N;k++) 
    { 
      if(normflg==1)
	*(p_alpha+k)/=sup_p_alpha;
      *(fg_alpha+k)=1+log((double)*(p_alpha+k))/log((double)nu_n); 
      if(normflg==2)
	sup_fg_alpha=(sup_fg_alpha>*(fg_alpha+k)?sup_fg_alpha:*(fg_alpha+k)); 
    }     
    if(normflg==2)
      for(k=0;k<*N;k++) 
	*(fg_alpha+k)/=sup_fg_alpha;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_fg_n_alpha arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

int MFAG_kfg_n_alpha(nu_n, alpha_n, epsilon, alpha, t_kern, t_width, t_norm, N, p_alpha, fg_alpha)
     int nu_n;
     double *alpha_n;
     double epsilon;
     double *alpha;
     MFAMt_kern t_kern;
     MFAMt_width t_width;
     MFAGt_norm t_norm;
     int *N;
     double *p_alpha;
     double *fg_alpha;
{
  if((nu_n>0)&&(alpha_n!=NULL)&&(epsilon>=0.)&&(alpha!=NULL)&&(fg_alpha!=NULL)&&(N!=NULL))
  { 
    double* h=NULL;
    if((h=(double*)malloc((unsigned)(*N*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      return 0;
    }
    if(MFAM_kpdf(nu_n,alpha_n,t_kern,*N,h,t_width,alpha,p_alpha)==0) 
    { 
      fprintf(stderr,"MFAM_kpdf error\n");
      return 0;
    }  
    if(MFAG_norm(t_norm,1./nu_n,*N,NULL,p_alpha,fg_alpha)==0)
    {
      fprintf(stderr,"MFAG_norm error\n");
      return 0;   
    }
    free((char*)h);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_kfg_n_alpha arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

int MFAG_mdfg1d(nu_n, mu_n, t_kern, t_width, t_norm, N, epsilon, alpha, p_alpha, fg_alpha)
     int nu_n;
     double *mu_n;
     MFAMt_kern t_kern;
     MFAMt_width t_width;
     MFAGt_norm t_norm;
     int *N;
     double epsilon;
     double *alpha;
     double *p_alpha;
     double *fg_alpha;
{
  if((nu_n>0)&&(mu_n!=NULL)&&(epsilon>=0.)&&(alpha!=NULL)&&(fg_alpha!=NULL)&&(N!=NULL))
  {
    double* alpha_n=NULL;
    switch(t_kern)
    {  
    case MFAM_INTEGRATED:
      break;
    case MFAM_BOXCAR:
      break; 
    case MFAM_TRIANGLE:
      break; 
    case MFAM_GAUSSIAN:
      break;
    case MFAM_MOLLIFIER:
      break; 
    case MFAM_EPANECHNIKOV:
      break; 
    default:
      break;
    }
    if((alpha_n=(double*)malloc((unsigned)(nu_n*sizeof(double))))==NULL) 
    {
      fprintf(stderr,"malloc error\n"); 
      return 0;
    }  
    if(MFAG_alpha_n(nu_n,mu_n,alpha_n)==0)
    {
      fprintf(stderr,"MFAG_alpha_n error\n"); 
      return 0;
    }
    if(t_kern==MFAM_INTEGRATED)
    {
      if(MFAG_fg_n_epsilon(nu_n,alpha_n,epsilon,alpha,t_norm,N,p_alpha,fg_alpha)==0)
      {
	fprintf(stderr,"MFAM_fg_n_epsilon error\n"); 
	return 0;
      }
    }
    else
    {
      if(MFAG_kfg_n_alpha(nu_n,alpha_n,epsilon,alpha,t_kern,t_width,t_norm,N,p_alpha,fg_alpha)==0)
      {
	fprintf(stderr,"MFAM_fg_n_epsilon error\n"); 
	return 0;
      }
    }
    free((char*)alpha_n);
    return 1;
  } 
  else
  {
    fprintf(stderr,"MFAG_mdfg1d arguments error\n");
    return 0;
  }
}
