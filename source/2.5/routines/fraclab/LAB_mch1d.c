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

/* Christophe Canus 1997 */

#include "C-LAB_Interf.h"
#include "MFAG_hoelder.h"

/************  LAB_mch1d  ***************************************************/

void LAB_mch1d()
{
  /* input parameters */
  short J=1;
  int N_n=0,M=0;
  double S_min=1.,S_max=1.;  
  MFAMt_prog t_prog=MFAM_LOG;
  MFAMt_ball t_ball=MFAM_ASYMMETRIC;
  /* input measure */
  double* mu_n=NULL;
  double* I_n=NULL; 
  /* output coarse Hoelder exponents, scales & abscissa */
  double* alpha_eta_x=NULL;
  double* eta=NULL;
  double* x=NULL;
 
  /* Matrix */
  Matrix* MI_n;
  Matrix* Mmu_n;
  Matrix* MS_min_S_max_J; 
  Matrix* Mprogstr;
  Matrix* Mballstr;
  Matrix* MM;
  Matrix* Mx;
  Matrix* Meta;
  Matrix* Malpha_eta_x;

  /* Check the input arguments number */
  if(Interf.NbParamIn<1) 
  {
    InterfError("mch1d: You must give at least 1 input argument\n");
    return;
  }  
  if(Interf.NbParamIn>6) 
  {
    InterfError("mch1d: You must give at most 6 input arguments\n");
    return;
  }

  /* Check the output arguments number */ 
  if(Interf.NbParamOut<1) 
  {
    InterfError("mch1d: You must give at least 1 output argument\n");
    return;
  }
  if(Interf.NbParamOut>3)
  {
    InterfError("mch1d: You must give at most 3 output arguments\n");
    return;
  }

  /* Get the input measure: mu_n and verify it */
  Mmu_n=Interf.Param[0];
  if(!MatrixIsNumeric(Mmu_n))
  {
    InterfError("mch1d: The measure: mu_n must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mmu_n))
  {
    InterfError("mch1d: The measure: mu_n must be a real matrix\n");
    return;
  }

  /* Get the input argument */  
  mu_n=(double*)MatrixGetPr(Mmu_n);

  /* Get the size of the input argument */ 
  M=N_n=(int)MAX(MatrixGetWidth(Mmu_n),MatrixGetHeight(Mmu_n));
  if(N_n<=0)
  {
    InterfError("mch1d: The size of measure: mu_n must be >0\n");
    return;
  }

  if(Interf.NbParamIn>1) 
  {
    /* Get the input minimal size: S_min, maximal size: S_max & # of scales: J and verify them */
    MS_min_S_max_J=Interf.Param[1];
    if(!MatrixIsNumeric(MS_min_S_max_J))
    {
      InterfError("mch1d: The vector: [S_min S_max J] must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(MS_min_S_max_J))
    {
      InterfError("mch1d: The vector: [S_min S_max J] must be a real matrix\n");
      return;
    }
    if(((int)MAX(MatrixGetWidth(MS_min_S_max_J),MatrixGetHeight(MS_min_S_max_J)))!=3)
    {
      InterfError("mch1d: The vector: [S_min S_max J] is illegal\n");
      return;
    } 
    /* Get the input argument */
    S_min=*(MatrixGetPr(MS_min_S_max_J));
    if(S_min<1.)
    {
      InterfError("mch1d: The minimum size: S_min must be >=1.\n");
      return;
    } 
    S_max=*(MatrixGetPr(MS_min_S_max_J)+1); 
    if(S_max<S_min)
    {
      InterfError("mch1d: The maximum size: S_max must be >=S_min\n");
      return;
    } 
    J=(short)*(MatrixGetPr(MS_min_S_max_J)+2); 
    if(J<1)
    {
      InterfError("mch1d: The # of scales: J must be >=1\n");
      return;
    } 
  }

  if(Interf.NbParamIn>2)
  {  
    /* Get the input string: progstr and verify it */
    Mprogstr=Interf.Param[2];
    if(!MatrixIsString(Mprogstr))
    {
      InterfError("mch1d: The string: progstr must be a string\n");
      return;
    }
    /* Get the input argument */ 
    if(MFAM_progstr(MatrixReadString(Mprogstr),&t_prog)==0)
    {
      InterfError("mch1d: The string: progstr is illegal\n");
      return;
    }
  }

  if(Interf.NbParamIn>3)
  {  
    /* Get the input string: ballstr and verify it */
    Mballstr=Interf.Param[3];
    if(!MatrixIsString(Mballstr))
    {
      InterfError("mch1d: The string: ballstr must be a string\n");
      return;
    }
    /* Get the input argument */
    if(MFAM_ballstr(MatrixReadString(Mballstr),&t_ball)==0)
    {
      InterfError("mch1d: The string: ballstr is illegal\n");
      return;
    }
  }
  
  if(Interf.NbParamIn>4) 
  {
    /* Get the input # of points: M and verify it */
    MM=Interf.Param[4];
    if(!MatrixIsNumeric(MM))
    {
      InterfError("mch1d: The # of points: M must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsScalar(MM))
    {
      InterfError("mch1d: The # of points: M must be a scalar\n");
      return;
    }
    /* Get the input argument */
    M=(int)MatrixGetScalar(MM);
  }
   
  if(Interf.NbParamIn>5) 
  {
    /* Get the input intervals and verify it */
    MI_n=Interf.Param[5];
    if(!MatrixIsNumeric(MI_n))
    {
      InterfError("mch1d: The intervals: I_n must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(MI_n))
    {
      InterfError("mch1d: The intervals: I_n must be a real matrix\n");
      return;
    }
    /* Get the input argument */  
    I_n=(double*)MatrixGetPr(MI_n); 
    
    /* Check the # of intervals */
    if(N_n!=(int)MatrixGetWidth(MI_n))
    {
      InterfError("mch1d: The # of intervals: I_n & measures must be equal\n");
      return;
    }  
  }

  /* Create the output Matrix */  
  Malpha_eta_x=MatrixCreate(M,J,"real");
  Meta=MatrixCreate(1,J,"real");
  Mx=MatrixCreate(M,J,"real");

  /* Get the pointer on the output Matrix */  
  alpha_eta_x=MatrixGetPr(Malpha_eta_x);
  eta=MatrixGetPr(Meta);
  x=MatrixGetPr(Mx);

  /* Call of the C function */
  if(MFAG_mch1d(N_n,I_n,mu_n,t_prog,t_ball,J,S_min,S_max,M,eta,x,alpha_eta_x)==0) 
  { 
    InterfError("mch1d: Call of the C function MFAG_mch1d failed\n"); 
    return;
  }
 
  /* Transpose output argument */
  MatrixTranspose(Malpha_eta_x); 
  MatrixTranspose(Mx);

  /* Return the output */
  ReturnParam(Malpha_eta_x);
  if(Interf.NbParamOut>1)
    ReturnParam(Meta);
  else
    MatrixFree(Meta);
  if(Interf.NbParamOut>2) 
    ReturnParam(Mx);
  else
    MatrixFree(Mx);

}


