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

#include "MFAL_discrete.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAL_mdfl1d(N_n, mu_n, t_part, J, S_min, S_max, P_min, P_max, a, Q, q, Z_a_q, t_lr, t_q, N, alpha, fl_alpha)
     int N_n;
     double *mu_n;
     MFAMt_part t_part;
     short int J;
     double S_min;
     double S_max;
     double P_min;
     double P_max;
     double *a;
     short int Q;
     double *q;
     double *Z_a_q;
     MFAMt_lr t_lr;
     double *t_q;
     short int *N;
     double *alpha;
     double *fl_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAL_mdfl1d(N_n, mu_n, t_part, J, S_min, S_max, P_min, P_max, a, Q, q, Z_a_q, t_lr, t_q, N, alpha, fl_alpha)
     int N_n;
     double *mu_n;
     MFAMt_part t_part;
     short int J;
     double S_min;
     double S_max;
     double P_min;
     double P_max;
     double *a;
     short int Q;
     double *q;
     double *Z_a_q;
     MFAMt_lr t_lr;
     double *t_q;
     short int *N;
     double *alpha;
     double *fl_alpha;
#else /* __STDC__ */
int MFAL_mdfl1d(int N_n,double* mu_n,MFAMt_part t_part,short J,double S_min,double S_max,double P_min,double P_max,double* a,short Q,double* q,double* Z_a_q,MFAMt_lr t_lr,double* t_q,short* N,double* alpha,double* fl_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((N_n>0)&&(mu_n!=NULL)&&(J>0)&&(S_min>=1.)&&(S_min<=S_max)&&(S_max<=N_n/2.)&&(P_min>=1.)&&(P_min<=P_max)&&(P_max<=N_n/2.)&&(Q>0)&&(q!=NULL)&&(Z_a_q!=NULL)&&(t_q!=NULL)&&(N!=NULL)&&(alpha!=NULL)&&(fl_alpha!=NULL))
  {
    register int k=0;
    int N_tmp=0;
    double* t_q_tmp=NULL;
    if(MFAL_mdZq1d(N_n,mu_n,t_part,J,S_min,S_max,P_min,P_max,a,Q,q,Z_a_q)==0) 
    {
      fprintf(stderr,"MFAL_mdZq1d error\n");
      return 0;
    }
    if(MFAL_dtq(J,a,Q,q,Z_a_q,t_lr,t_q)==0)
    {
      fprintf(stderr,"MFAL_dtq error\n");
      return 0;
    }
    if((t_q_tmp=(double*)malloc((unsigned)Q*sizeof(double)))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      return 0;
    } 
    for(k=0;k<Q;k++)
      *(t_q_tmp+k)=*(t_q+k);
    if(MFAM_bb_concave_hull(Q,q,t_q_tmp,&N_tmp)==0)
    {
      fprintf(stderr,"MFAM_bb_concave_hull error\n");
      free((char*)t_q_tmp);
      return 0;
    } 
    if(MFAM_llt(N_tmp,q,t_q_tmp,alpha,fl_alpha)==0)
    {
      fprintf(stderr,"MFAS_llt error\n");
      return 0;
    }
    free((char*)t_q_tmp);
    *N=N_tmp;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_mdfl1d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAL_mdfl2d(Nx_n, Ny_n, mu_n, t_part, J, S_min, S_max, P_min, P_max, a, Q, q, Z_a_q, t_lr, t_q, N, alpha, fl_alpha)
     int Nx_n;
     int Ny_n;
     double *mu_n;
     MFAMt_part t_part;
     short int J;
     double S_min;
     double S_max;
     double P_min;
     double P_max;
     double *a;
     short int Q;
     double *q;
     double *Z_a_q;
     MFAMt_lr t_lr;
     double *t_q;
     short int *N;
     double *alpha;
     double *fl_alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAL_mdfl2d(Nx_n, Ny_n, mu_n, t_part, J, S_min, S_max, P_min, P_max, a, Q, q, Z_a_q, t_lr, t_q, N, alpha, fl_alpha)
     int Nx_n;
     int Ny_n;
     double *mu_n;
     MFAMt_part t_part;
     short int J;
     double S_min;
     double S_max;
     double P_min;
     double P_max;
     double *a;
     short int Q;
     double *q;
     double *Z_a_q;
     MFAMt_lr t_lr;
     double *t_q;
     short int *N;
     double *alpha;
     double *fl_alpha;
#else /* __STDC__ */
int MFAL_mdfl2d(int Nx_n,int Ny_n,double* mu_n,MFAMt_part t_part,short J,double S_min,double S_max,double P_min,double P_max,double* a,short Q,double* q,double* Z_a_q,MFAMt_lr t_lr,double* t_q,short* N,double* alpha,double* fl_alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((Nx_n>0)&&(Ny_n>0)&&(J>0)&&(S_min>=1.)&&(S_min<=S_max)&&(S_max<=Nx_n/2.)&&(P_min>=1.)&&(P_min<=P_max)&&(P_max<=Nx_n/2.)&&(Q>0)&&(q!=NULL)&&(Z_a_q!=NULL)&&(t_q!=NULL)&&(N!=NULL)&&(alpha!=NULL)&&(fl_alpha!=NULL))
  {
    register int k=0; 
    int N_tmp=0;
    double* t_q_tmp=NULL;
    if(MFAL_mdZq2d(Nx_n,Ny_n,mu_n,t_part,J,S_min,S_max,P_min,P_max,a,Q,q,Z_a_q)==0) 
    {
      fprintf(stderr,"MFAL_mdZq2d error\n");
      return 0;
    }
    if(MFAL_dtq(J,a,Q,q,Z_a_q,t_lr,t_q)==0)
    {
      fprintf(stderr,"MFAL_dtq error\n");
      return 0;
    }
    if((t_q_tmp=(double*)malloc((unsigned)Q*sizeof(double)))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      return 0;
    } 
    for(k=0;k<Q;k++)
      *(t_q_tmp+k)=*(t_q+k);
    if(MFAM_bb_concave_hull(Q,q,t_q_tmp,&N_tmp)==0)
    {
      fprintf(stderr,"MFAM_bb_concave_hull error\n");
      free((char*)t_q_tmp);
      return 0;
    } 
    if(MFAM_llt(N_tmp,q,t_q_tmp,alpha,fl_alpha)==0)
    {
      fprintf(stderr,"MFAS_llt error\n");
      return 0;
    }
    free((char*)t_q_tmp);
    *N=N_tmp;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_mdfl2d arguments error\n");
    return 0;
  }
}
