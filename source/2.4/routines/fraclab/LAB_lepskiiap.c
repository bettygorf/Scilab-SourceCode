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

/************  LAB_lepskiiap  ************************************************/

void LAB_lepskiiap()
{
  /* input parameters */ 
  int J=12;
  double K=1.;
  /* input sequence of estimators & variances */
  double* theta_hat_j=NULL;
  double* sigma2_j=NULL;
  /* output optimal confidence constant, optimal index, confidence intervals */
  double* K_star=NULL;
  double* j_hat=NULL;
  double* I_c_j_min=NULL;
  double* I_c_j_max=NULL;
  /* ouput intersection interval */
  double* E_c_j_hat_min=NULL;
  double* E_c_j_hat_max=NULL;

  /* Matrix */
  Matrix* Mtheta_hat_j; 
  Matrix* MK;
  Matrix* Msigma2_j;
  Matrix* MK_star;
  Matrix* Mj_hat;
  Matrix* MI_c_j_min;
  Matrix* MI_c_j_max; 
  Matrix* ME_c_j_hat_min;
  Matrix* ME_c_j_hat_max;
 
  /* Check the input arguments number */
  if(Interf.NbParamIn<1) 
  {
    InterfError("lepskiiap: You must give at least 1 input argument\n");
    return;
  }
  if(Interf.NbParamIn>5) 
  {
    InterfError("lepskiiap: You must give at most 3 input arguments\n");
    return;
  }

  /* Check the output arguments number */ 
  if(Interf.NbParamOut<2) 
  {
    InterfError("lepskiiap: You must give at least 2 output argument\n");
    return;
  }
  if(Interf.NbParamOut>6)
  {
    InterfError("lepskiiap: You must give at most 6 output arguments\n");
    return;
  }

  /* Get the input parameter: theta_hat_j and verify it */
  Mtheta_hat_j=Interf.Param[0];
  if(!MatrixIsNumeric(Mtheta_hat_j))
  {
    InterfError("lepskiiap: The parameter: theta_hat_j must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mtheta_hat_j))
  {
    InterfError("lepskiiap: The parameter: theta_hat_j must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  theta_hat_j=(double*)MatrixGetPr(Mtheta_hat_j);
  /* Get the size of the input argument */ 
  J=(int)MAX(MatrixGetWidth(Mtheta_hat_j),MatrixGetHeight(Mtheta_hat_j));

  if(Interf.NbParamIn>1)
  {
    /* Get the input variance: sigma2_j and verify it */
    Msigma2_j=Interf.Param[1];
    if(!MatrixIsNumeric(Msigma2_j))
    {
      InterfError("lepskiiap: The variance: sigma2_j must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Msigma2_j))
    {
      InterfError("lepskiiap: The variance: sigma2_j must be a real matrix\n");
      return;
    }
    /* Get the input argument */  
    sigma2_j=(double*)MatrixGetPr(Msigma2_j);
    /* Get the size of the input argument */ 
    if((int)(MAX(MatrixGetWidth(Msigma2_j),MatrixGetHeight(Msigma2_j)))!=J)
    {
      InterfError("lepskiiap: The parameter: theta_hat_j  & variance: sigma2_j must be of same size\n");
      return;
    }  
  }

  if(Interf.NbParamIn>2)
  { 
    /* Get the input confidence constant: K and verify it */
    MK=Interf.Param[2];
    if(!MatrixIsNumeric(MK))
    {
      InterfError("lepskiiap: The confidence constant: K must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsScalar(MK))
    {
      InterfError("lepskiiap: The confidence constant: K must be a scalar\n");
      return;
    }
    /* Get the input argument */
    K=(double)MatrixGetScalar(MK); 
    if(K<1.)
    {
      InterfError("lepskiiap: The confidence constant: K must be >=1.\n");
      return;
    }
  }
   
  /* Create the input Matrix */ 
  if(Interf.NbParamIn<2)
    Msigma2_j=MatrixCreate(1,J,"real");

  /* Get the pointer on the input Matrix */
  if(Interf.NbParamIn<2)
    sigma2_j=MatrixGetPr(Msigma2_j);

  /* Create the output Matrix */
  MK_star=MatrixCreate(1,1,"real");  
  Mj_hat=MatrixCreate(1,1,"real"); 
  MI_c_j_min=MatrixCreate(1,J,"real"); 
  MI_c_j_max=MatrixCreate(1,J,"real"); 
  ME_c_j_hat_min=MatrixCreate(1,1,"real");  
  ME_c_j_hat_max=MatrixCreate(1,1,"real");
 
  /* Get the pointer on the output Matrix */
  K_star=MatrixGetPr(MK_star);
  j_hat=MatrixGetPr(Mj_hat);  
  I_c_j_min=MatrixGetPr(MI_c_j_min);
  I_c_j_max=MatrixGetPr(MI_c_j_max); 
  E_c_j_hat_min=MatrixGetPr(ME_c_j_hat_min);  
  E_c_j_hat_max=MatrixGetPr(ME_c_j_hat_max);  

  /* Call of the C function */
  if(MFAM_lap(J,theta_hat_j,sigma2_j,K,K_star,j_hat,I_c_j_min,I_c_j_max,E_c_j_hat_min,E_c_j_hat_max)==0)
  {
    InterfError("lepskiiap: Call of the C function MFAM_lap failed\n");
    return;
  }
  
  /* Return the output */
  ReturnParam(MK_star);  
  (*j_hat)+=1;
  ReturnParam(Mj_hat);
  if(Interf.NbParamOut>2)
    ReturnParam(MI_c_j_min);
  else
    MatrixFree(MI_c_j_min);  
  if(Interf.NbParamOut>3)
    ReturnParam(MI_c_j_max);
  else
    MatrixFree(MI_c_j_max); 
  if(Interf.NbParamOut>4)
    ReturnParam(ME_c_j_hat_min);
  else
    MatrixFree(ME_c_j_hat_min); 
  if(Interf.NbParamOut>5)
    ReturnParam(ME_c_j_hat_max);
  else
    MatrixFree(ME_c_j_hat_max);
 
}


