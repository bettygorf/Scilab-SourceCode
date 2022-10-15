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

#include "MFAM_lepskii.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAM_lap(J, theta_hat_j, sigma2_j, K, K_star, j_hat, I_c_j_min, I_c_j_max, E_c_j_hat_min, E_c_j_hat_max)
     int J;
     double *theta_hat_j;
     double *sigma2_j;
     double K;
     double *K_star;
     double *j_hat;
     double *I_c_j_min;
     double *I_c_j_max;
     double *E_c_j_hat_min;
     double *E_c_j_hat_max;
#else /* __STDC__ */
int MFAM_lap(int J,double* theta_hat_j,double* sigma2_j,double K,double* K_star,double* j_hat,double* I_c_j_min,double* I_c_j_max,double* E_c_j_hat_min,double* E_c_j_hat_max)
#endif /* __STDC__ */
{      
  if((J>1)&&(theta_hat_j!=NULL)&&(sigma2_j!=NULL)&&(K>=1.)&&(K_star!=NULL)&&(j_hat!=NULL)&&(I_c_j_min!=NULL)&&(I_c_j_max!=NULL)&&(E_c_j_hat_min!=NULL)&&(E_c_j_hat_max!=NULL))
  { 
    register int j=0;
    int boolean=1;
    double min=0.,max=0.;
    if(MFAM_iszeros(J,sigma2_j)==1)
    {
      *sigma2_j=1;
      for(j=1;j<J;j++)
	*(sigma2_j+j)=1./(j+1);
    }   
    *K_star=1+pow(-2*log(*(sigma2_j+J-1)/(J**sigma2_j)),.5);  
    if(K==0.)
      K=*K_star;
    j=0;
    *E_c_j_hat_min=*(theta_hat_j+j)-K*pow(*(sigma2_j+j),.5);
    *E_c_j_hat_max=*(theta_hat_j+j)+K*pow(*(sigma2_j+j),.5);
    while(boolean)
    {
      *(I_c_j_min+j)=*(theta_hat_j+j)-K*pow(*(sigma2_j+j),.5);
      *(I_c_j_max+j)=*(theta_hat_j+j)+K*pow(*(sigma2_j+j),.5);
      min=(*E_c_j_hat_min>*(I_c_j_min+j)?*E_c_j_hat_min:*(I_c_j_min+j));
      max=(*E_c_j_hat_max<*(I_c_j_max+j)?*E_c_j_hat_max:*(I_c_j_max+j));
      if(min>max)
      {
	*j_hat=j-1;
	*(I_c_j_min+j)=0.;
	*(I_c_j_max+j)=0.;
	boolean=0;
      }
      else
      {
	*E_c_j_hat_min=min;
	*E_c_j_hat_max=max;
	j++;
	boolean=(j<J);
      }  
    }
    if(j==J)
      *j_hat=J-1;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_lap arguments error\n");
    return 0;
  }
}
