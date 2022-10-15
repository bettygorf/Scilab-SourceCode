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

#include "C-LAB_Interf.h"
#include "MFAM_regression.h"

/************  LAB_monolr  ***************************************************/

void LAB_monolr()
{
  /* input parameters */ 
  short I=20;
  int J=256;
  double K=1.,m=0.,s=1.;
  MFAMt_lr t_lr=MFAM_LSLR;
  /* input abscissa & ordinates */
  double* x=NULL;
  double* y=NULL; 
  /* input weights & variance */
  double* w=NULL;
  double* sigma2_j=NULL;
  /* output slopes & ordinates at the origin estimates*/
  double* a_hat=NULL; 
  double* b_hat=NULL;
  /* output regressed ordinate, errors & mean square error estimates */
  double* y_hat=NULL;
  double* e_hat=NULL;
  double* sigma2_e_hat=NULL;
  /* output optimal confidence constant & index, confidence intervals */
  double* K_star=NULL;
  double* j_hat=NULL;
  double* I_c_min=NULL; 
  double* I_c_max=NULL;
  /* ouput intersection interval */
  double* E_c_j_hat_min=NULL;
  double* E_c_j_hat_max=NULL;
  
  /* Matrix */
  Matrix* Mx; 
  Matrix* My;
  Matrix* Mlrstr;   
  Matrix* Mw;
  Matrix* MI; 
  Matrix* Msigma2_j;
  Matrix* Mm;
  Matrix* MK;
  Matrix* Ms;
  Matrix* Ma_hat;
  Matrix* Mb_hat;
  Matrix* My_hat;
  Matrix* Me_hat;
  Matrix* Msigma2_e_hat; 
  Matrix* MK_star;
  Matrix* Mj_hat;
  Matrix* MI_c_min;
  Matrix* MI_c_max; 
  Matrix* ME_c_j_hat_min;
  Matrix* ME_c_j_hat_max;
 
  /* Check the input arguments number */
  if(Interf.NbParamIn<2) 
  {
    InterfError("monolr: You must give at least 2 input arguments\n");
    return;
  }
  if(Interf.NbParamIn>6) 
  {
    InterfError("monolr: You must give at most 6 input arguments\n");
    return;
  }

  /* Check the output arguments number */ 
  if(Interf.NbParamOut<1) 
  {
    InterfError("monolr: You must give at least 1 output argument\n");
    return;
  }
  if(Interf.NbParamOut>11)
  {
    InterfError("monolr: You must give at most 11 output arguments\n");
    return;
  }

  /* Get the input abscissa: x and verify it */
  Mx=Interf.Param[0];
  if(!MatrixIsNumeric(Mx))
  {
    InterfError("monolr: The abscissa: x must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mx))
  {
    InterfError("monolr: The abscissa: x must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  x=(double*)MatrixGetPr(Mx);
  /* Get the size of the input argument */ 
  J=(int)MAX(MatrixGetWidth(Mx),MatrixGetHeight(Mx));

  /* Get the input ordinates: y and verify it */
  My=Interf.Param[1];
  if(!MatrixIsNumeric(My))
  {
    InterfError("monolr: The ordinates: y must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(My))
  {
    InterfError("monolr: The ordinates: y must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  y=(double*)MatrixGetPr(My);
  /* Get the size of the input argument */ 
  if((int)(MAX(MatrixGetWidth(My),MatrixGetHeight(My)))!=J)
  {
    InterfError("monolr: The abscissa: x & ordinates: y must be of same size\n");
    return;
  }  

  if(Interf.NbParamIn>2)
  { 
    /* Get the input string: lrstr and verify it */
    Mlrstr=Interf.Param[2];
    if(!MatrixIsString(Mlrstr))
    {
      InterfError("monolr: The string: lrstr must be a string\n");
      return;
    }
    /* Get the input argument */
    if(MFAM_lrstr(MatrixReadString(Mlrstr),&t_lr)==0)
    {
      InterfError("monolr: The string: lrstr is illegal\n");
      return;
    }
  }

  if(Interf.NbParamIn>3)
  {  
    if(t_lr==MFAM_WLSLR)
    { 
      /* Get the weights: w and verify it */
      Mw=Interf.Param[3];
      if(!MatrixIsNumeric(Mw))
      {
	InterfError("monolr: The weights: w must be a numeric matrix\n");
	return;
      }
      /* Get the input argument */
      w=(double*)MatrixGetPr(Mw);
      /* Get the size of the input argument */ 
      if((int)(MAX(MatrixGetWidth(Mw),MatrixGetHeight(Mw)))!=J)
      {
	InterfError("monolr: The weights: w & abscissa: x must be of same size\n");
	return;
      }
    } 
    else if(t_lr==MFAM_PLSLR) 
    {
      /* Get the # of iterations: I and verify it */
      MI=Interf.Param[3];
      if(!MatrixIsNumeric(MI))
      {
	InterfError("monolr: The # of iterations: I must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsScalar(MI))
      {
	InterfError("monolr: The # of iterations: I must be a scalar\n");
	return;
      }
      /* Get the input argument */
      I=(double)MatrixGetScalar(MI); 
      if(I<2)
      {
	InterfError("monolr: The # of iterations: I must be >=2\n");
	return;
      }
    } 
    else if(t_lr==MFAM_LAPLSLR)
    {
      /* Get the variance: sigma2_j and verify it */
      Msigma2_j=Interf.Param[3];
      if(!MatrixIsNumeric(Msigma2_j))
      {
	InterfError("monolr: The variance: sigma2_j must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsReal(Msigma2_j))
      {
	InterfError("monolr: The variance: sigma2_j must be a real matrix\n");
	return;
      }
      /* Get the input argument */  
      sigma2_j=(double*)MatrixGetPr(Msigma2_j);
      /* Get the size of the input argument */ 
      if((int)(MAX(MatrixGetWidth(Msigma2_j),MatrixGetHeight(Msigma2_j)))!=J)
      {
	InterfError("monolr: The variance: sigma2_j & ordinates: y must be of same size\n");
	return;
      }      
    }
    else
    {
      InterfError("monolr: illegal fourth optional argument.\n");
      return;
    }
  }
  
  if(Interf.NbParamIn>4)
  { 
    if(t_lr==MFAM_PLSLR)
    { 
      /* Get the mean of the normal weights: m  and verify it */
      Mm=Interf.Param[4];
      if(!MatrixIsNumeric(Mm))
      {
	InterfError("monolr: The mean of the normal weights: m  must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsScalar(Mm))
      {
	InterfError("monolr: The mean of the normal weights: m must be a scalar\n");
	return;
      }
      /* Get the input argument */
      m=(double)MatrixGetScalar(Mm);
    }
    else if(t_lr==MFAM_LAPLSLR)
    {
      /* Get the confidence constant: K and verify it */
      MK=Interf.Param[4];
      if(!MatrixIsNumeric(MK))
      {
	InterfError("monolr: The confidence constant: K must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsScalar(MK))
      {
	InterfError("monolr: The confidence constant: K must be a scalar\n");
	return;
      }
      /* Get the input argument */
      K=(double)MatrixGetScalar(MK); 
      if(K<0.)
      {
	InterfError("monolr: The confidence constant: K must be >=0.\n");
	return;
      }
    }
    else
    {
      InterfError("monolr: illegal fifth optional argument.\n");
      return;
    }
  }
 
  if(Interf.NbParamIn>5)
  { 
    if(t_lr==MFAM_PLSLR)
    { 
      /* Get the variance of the normal weights: s and verify it */
      Ms=Interf.Param[5];
      if(!MatrixIsNumeric(Ms))
      {
	InterfError("monolr: The variance  of the normal weights: s must be a numeric matrix\n");
	return;
      }
      if(!MatrixIsScalar(Ms))
      {
	InterfError("monolr: The variance of the normal weights: s must be a scalar\n");
	return;
      }
      /* Get the input argument */
      s=(double)MatrixGetScalar(Ms);
      if(s<=0.)
      {
	InterfError("monolr: The variance of the normal weights: s must be >0.\n");
	return;
      }
    }  
    else
    {
      InterfError("monolr: illegal sixth optional argument.\n");
      return;
    }
  }

  /* Create the input Matrix */
  if(((t_lr==MFAM_WLSLR)&&(Interf.NbParamIn<4))||(t_lr==MFAM_MLLR)||(t_lr==MFAM_PLSLR)) 
    Mw=MatrixCreate(1,J,"real"); 
  if((t_lr==MFAM_MLLR)||((t_lr==MFAM_LAPLSLR)&&(Interf.NbParamIn<4)))
    Msigma2_j=MatrixCreate(1,J,"real");

  /* Get the pointer on the input Matrix */
  if(((t_lr==MFAM_WLSLR)&&(Interf.NbParamIn<4))||(t_lr==MFAM_MLLR)||(t_lr==MFAM_PLSLR)) 
    w=MatrixGetPr(Mw); 

  if((t_lr==MFAM_MLLR)||((t_lr==MFAM_LAPLSLR)&&(Interf.NbParamIn<4)))
    sigma2_j=MatrixGetPr(Msigma2_j);

  /* Create the output Matrix */
  if((t_lr==MFAM_MLSLR)||(t_lr==MFAM_MLLR)||(t_lr==MFAM_LAPLSLR))
  {
    Ma_hat=MatrixCreate(1,J,"real");   
    Mb_hat=MatrixCreate(1,J,"real");
    My_hat=MatrixCreate(1,(J+2)*(J-1)/2,"real");
    Me_hat=MatrixCreate(1,(J+2)*(J-1)/2,"real");
    Msigma2_e_hat=MatrixCreate(1,J,"real");
  }
  else
  {
    if(t_lr!=MFAM_PLSLR)
      I=1;
    Ma_hat=MatrixCreate(1,I,"real");
    Mb_hat=MatrixCreate(1,I,"real");
    My_hat=MatrixCreate(J,I,"real");
    Me_hat=MatrixCreate(1,J,"real");
    Msigma2_e_hat=MatrixCreate(1,1,"real"); 
  }
  if(t_lr==MFAM_LAPLSLR) 
  { 
    MK_star=MatrixCreate(1,1,"real");  
    Mj_hat=MatrixCreate(1,1,"real"); 
    MI_c_min=MatrixCreate(1,J,"real"); 
    MI_c_max=MatrixCreate(1,J,"real"); 
    ME_c_j_hat_min=MatrixCreate(1,1,"real");  
    ME_c_j_hat_max=MatrixCreate(1,1,"real");  
  } 

  /* Get the pointer on the output Matrix */
  a_hat=MatrixGetPr(Ma_hat);
  b_hat=MatrixGetPr(Mb_hat);
  y_hat=MatrixGetPr(My_hat);
  e_hat=MatrixGetPr(Me_hat); 
  sigma2_e_hat=MatrixGetPr(Msigma2_e_hat); 
  if(t_lr==MFAM_LAPLSLR) 
  { 
    K_star=MatrixGetPr(MK_star);
    j_hat=MatrixGetPr(Mj_hat);  
    I_c_min=MatrixGetPr(MI_c_min);
    I_c_max=MatrixGetPr(MI_c_max); 
    E_c_j_hat_min=MatrixGetPr(ME_c_j_hat_min);  
    E_c_j_hat_max=MatrixGetPr(ME_c_j_hat_max);  
  } 

  /* Call of the C function */
  if(MFAM_lr(J,x,y,t_lr,K,sigma2_j,w,I,m,s,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat,K_star,j_hat,I_c_min,I_c_max,E_c_j_hat_min,E_c_j_hat_max)==0)
  {
    InterfError("monolr: Call of the C function MFAM_lr failed\n");
    return;
  }

  /* Return the output */
  ReturnParam(Ma_hat);
  if(Interf.NbParamOut>1)
    ReturnParam(Mb_hat);
  else
    MatrixFree(Mb_hat);
  if(Interf.NbParamOut>2)
    ReturnParam(My_hat);
  else
    MatrixFree(My_hat);
  if(Interf.NbParamOut>3)
    ReturnParam(Me_hat);
  else
    MatrixFree(Me_hat);
  if(Interf.NbParamOut>4)
    ReturnParam(Msigma2_e_hat);
  else
    MatrixFree(Msigma2_e_hat);
  if(t_lr==MFAM_LAPLSLR)
  {
    if(Interf.NbParamOut>5)
      ReturnParam(MK_star);
    else
      MatrixFree(MK_star);
    (*j_hat)+=1;
    if(Interf.NbParamOut>6)
      ReturnParam(Mj_hat);
    else
      MatrixFree(Mj_hat);
    if(Interf.NbParamOut>7)
      ReturnParam(MI_c_min);
    else
      MatrixFree(MI_c_min);  
    if(Interf.NbParamOut>8)
      ReturnParam(MI_c_max);
    else
      MatrixFree(MI_c_max); 
    if(Interf.NbParamOut>9)
      ReturnParam(ME_c_j_hat_min);
    else
      MatrixFree(ME_c_j_hat_min); 
    if(Interf.NbParamOut>10)
      ReturnParam(ME_c_j_hat_max);
    else
      MatrixFree(ME_c_j_hat_max);
  }

}


