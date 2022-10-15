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

/* Christophe Canus 1998 */

#include "C-LAB_Interf.h"
#include "MFAM_lepskii.h"

/************  LAB_lap  ***************************************************/

void LAB_lap()
{
  /* input parameters */ 
  int J=12;
  double K=0.;
  /* input sequence of estimators & variances */
  double* theta=NULL;
  double* sigma2=NULL;
  /* output optimal confidence constant, optimal index, confidence intervals */
  double* K_star=NULL;
  double* j_hat=NULL;
  double* I_c_min=NULL;
  double* I_c_max=NULL;
  /* ouput minimal & maximal estimates */
  double* theta_j_hat_min=NULL;
  double* theta_j_hat_max=NULL;

  /* Matrix */
  Matrix* Mtheta; 
  Matrix* MK;
  Matrix* Msigma2;
  Matrix* MK_star;
  Matrix* Mj_hat;
  Matrix* MI_c_min;
  Matrix* MI_c_max; 
  Matrix* Mtheta_j_hat_min;
  Matrix* Mtheta_j_hat_max;
 
  /* Check the input arguments number */
  if(Interf.NbParamIn<2) 
  {
    InterfError("lap: You must give at least 2 input argument\n");
    return;
  }
  if(Interf.NbParamIn>5) 
  {
    InterfError("lap: You must give at most 3 input arguments\n");
    return;
  }

  /* Check the output arguments number */ 
  if(Interf.NbParamOut<2) 
  {
    InterfError("lap: You must give at least 2 output argument\n");
    return;
  }
  if(Interf.NbParamOut>6)
  {
    InterfError("lap: You must give at most 6 output arguments\n");
    return;
  }

  /* Get the input parameter: theta and verify it */
  Mtheta=Interf.Param[0];
  if(!MatrixIsNumeric(Mtheta))
  {
    InterfError("lap: The parameter: theta must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mtheta))
  {
    InterfError("lap: The parameter: theta must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  theta=(double*)MatrixGetPr(Mtheta);
  /* Get the size of the input argument */ 
  J=(int)MAX(MatrixGetWidth(Mtheta),MatrixGetHeight(Mtheta));

  /* Get the input variance: sigma2 and verify it */
  Msigma2=Interf.Param[1];
  if(!MatrixIsNumeric(Msigma2))
  {
    InterfError("lap: The variance: sigma2 must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Msigma2))
  {
    InterfError("lap: The variance: sigma2 must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  sigma2=(double*)MatrixGetPr(Msigma2);
  /* Get the size of the input argument */ 
  if((int)(MAX(MatrixGetWidth(Msigma2),MatrixGetHeight(Msigma2)))!=J)
  {
    InterfError("lap: The parameter: theta  & variance: sigma2 must be of same size\n");
    return;
  }  

  if(Interf.NbParamIn>2)
  { 
    /* Get the input confidence constant: K and verify it */
    MK=Interf.Param[2];
    if(!MatrixIsNumeric(MK))
    {
      InterfError("lr: The confidence constant: K must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsScalar(MK))
    {
      InterfError("lr: The confidence constant: K must be a scalar\n");
      return;
    }
    /* Get the input argument */
    K=(double)MatrixGetScalar(MK); 
    if(K<0.)
    {
      InterfError("lr: The confidence constant: K must be >=0.\n");
      return;
    }
  }
  
  /* Create the output Matrix */
  MK_star=MatrixCreate(1,1,"real");  
  Mj_hat=MatrixCreate(1,1,"real"); 
  MI_c_min=MatrixCreate(1,J,"real"); 
  MI_c_max=MatrixCreate(1,J,"real"); 
  Mtheta_j_hat_min=MatrixCreate(1,1,"real");  
  Mtheta_j_hat_max=MatrixCreate(1,1,"real");
 
  /* Get the pointer on the output Matrix */
  K_star=MatrixGetPr(MK_star);
  j_hat=MatrixGetPr(Mj_hat);  
  I_c_min=MatrixGetPr(MI_c_min);
  I_c_max=MatrixGetPr(MI_c_max); 
  theta_j_hat_min=MatrixGetPr(Mtheta_j_hat_min);  
  theta_j_hat_max=MatrixGetPr(Mtheta_j_hat_max);  

  /* Call of the C function */
  if(MFAM_lap(J,theta,K,sigma2,I_c_min,I_c_max,K_star,j_hat,theta_j_hat_min,theta_j_hat_max)==0)
  {
    InterfError("lap: Call of the C function MFAM_lap failed\n");
    return;
  }

  /* Return the output */
  ReturnParam(MK_star);
  ReturnParam(Mj_hat);
  if(Interf.NbParamOut>2)
    ReturnParam(MI_c_min);
  else
    MatrixFree(MI_c_min);  
  if(Interf.NbParamOut>3)
    ReturnParam(MI_c_max);
  else
    MatrixFree(MI_c_max); 
  if(Interf.NbParamOut>4)
    ReturnParam(Mtheta_j_hat_min);
  else
    MatrixFree(Mtheta_j_hat_min); 
  if(Interf.NbParamOut>5)
    ReturnParam(Mtheta_j_hat_max);
  else
    MatrixFree(Mtheta_j_hat_max);
 
}


