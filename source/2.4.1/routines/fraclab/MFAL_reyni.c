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

#include "MFAL_reyni.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAL_dtq(J, a, Q, q, Z_a_q, t_lr, t_q)
     short int J;
     double *a;
     int Q;
     double *q;
     double *Z_a_q;
     MFAMt_lr t_lr;
     double *t_q;
#else /* __STDC__ */
#ifndef __STDC__
int MFAL_dtq(J, a, Q, q, Z_a_q, t_lr, t_q)
     short int J;
     double *a;
     int Q;
     double *q;
     double *Z_a_q;
     MFAMt_lr t_lr;
     double *t_q;
#else /* __STDC__ */
int MFAL_dtq(short J,double* a,int Q,double* q,double* Z_a_q,MFAMt_lr t_lr,double* t_q)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((J>0)&&(a!=NULL)&&(Q>0)&&(q!=NULL)&&(Z_a_q!=NULL)&&(t_q!=NULL))
  {
    register int j=0,k=0;
    double* loga=NULL;
    double* logZ_a_q=NULL;
    double* y_hat=NULL;  
    double* e_hat=NULL;
    double b_hat=0.,sigma2_e_hat=0.;
    if((loga=(double*)malloc((unsigned)(J*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n"); 
      return 0;
    }
    for(j=0;j<J;j++)
      *(loga+j)=log(*(a+j)); 
    if((logZ_a_q=(double*)malloc((unsigned)(J*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n"); 
      return 0;
    }
    if((y_hat=(double*)malloc((unsigned)(J*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n"); 
      return 0;
    } 
    if((e_hat=(double*)malloc((unsigned)(J*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n"); 
      return 0;
    }
    for(k=0;k<Q;k++)
    {
      for(j=0;j<J;j++)
	*(logZ_a_q+j)=log(*(Z_a_q+Q*j+k));
      if(MFAM_lslr(J,loga,logZ_a_q,t_q+k,&b_hat,y_hat,e_hat,&sigma2_e_hat)==0)
      {
	fprintf(stderr,"MFAM_lslr error\n");   
	free((char*)logZ_a_q);
	free((char*)loga); 
	free((char*)y_hat);
	free((char*)e_hat);
	return 0;
      }
    }
    free((char*)logZ_a_q);
    free((char*)loga); 
    free((char*)y_hat);
    free((char*)e_hat);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAL_dtq arguments error\n");
    return 0;
  }
}
