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

/************  LAB_fch1d  ***************************************************/

void LAB_fch1d()
{
  /* input arguments */
  short J=1;
  int M=1024;
  double S_min=5.,S_max=5.,p=2.; 
  MFAMt_prog t_prog=MFAM_LOG;
  MFAMt_osc t_osc=MFAM_OSC;
  /* input function */
  double* x=NULL;
  double* f_x=NULL;
  /* output scales & Hoelder exponents */
  double* alpha_eta_x=NULL;
  double* eta=NULL;
  /* strings */
  char* oscstr=NULL;
  char* progstr=NULL;

  /* Matrix */  
  Matrix* Mx;
  Matrix* Mf_x; 
  Matrix* MS_min_S_max_J;
  Matrix* Mprogstr;
  Matrix* Moscstr;
  Matrix* Malpha_eta_x;
  Matrix* Meta;

  /* Check the input arguments number */
  if(Interf.NbParamIn<1) 
  {
    InterfError("fch1d: You must give at least 1 input argument\n");
    return;
  }
  if(Interf.NbParamIn>4) 
  {
    InterfError("fch1d: You must give at most 4 input arguments\n");
    return;
  }

  /* Check the output arguments number */ 
  if(Interf.NbParamOut<1) 
  {
    InterfError("fch1d: You must give at least 1 output argument\n");
    return;
  }
  if(Interf.NbParamOut>2)
  {
    InterfError("fch1d: You must give at most 2 output arguments\n");
    return;
  }

  /* Get the input function: f_x and verify it */
  Mf_x=Interf.Param[0];
  if(!MatrixIsNumeric(Mf_x))
  {
    InterfError("fch1d: The function: f_x must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mf_x))
  {
    InterfError("fch1d: The function: f_x must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  f_x=(double*)MatrixGetPr(Mf_x);
  /* Get the size of the input argument */ 
  M=(int)MAX(MatrixGetWidth(Mf_x),MatrixGetHeight(Mf_x));
  if(M<=0)
  {
    InterfError("fcfg1d: The size of function f_x: must be >0\n");
    return;
  }

  if(Interf.NbParamIn>1) 
  {
    /* Get the input minimal size: S_min, maximal size: S_max & # of scales: J and verify them */
    MS_min_S_max_J=Interf.Param[1];
    if(!MatrixIsNumeric(MS_min_S_max_J))
    {
      InterfError("fch1d: The vector: [S_min S_max J] must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(MS_min_S_max_J))
    {
      InterfError("fch1d: The vector: [S_min S_max J] must be a real matrix\n");
      return;
    }
    if(((int)MAX(MatrixGetWidth(MS_min_S_max_J),MatrixGetHeight(MS_min_S_max_J)))!=3)
    {
      InterfError("fch1d: The vector: [S_min S_max J] is illegal\n");
      return;
    } 
    /* Get the input argument */
    S_min=*(MatrixGetPr(MS_min_S_max_J));
    if(S_min<1.)
    {
      InterfError("fch1d: The minimum size: S_min must be >=1.\n");
      return;
    } 
    S_max=*(MatrixGetPr(MS_min_S_max_J)+1); 
    if(S_max<S_min)
    {
      InterfError("fch1d: The maximum size: S_max must be >=S_min\n");
      return;
    } 
    J=(short)*(MatrixGetPr(MS_min_S_max_J)+2); 
    if(J<1)
    {
      InterfError("fch1d: The # of scales: J must be >=1\n");
      return;
    } 
  }

  if(Interf.NbParamIn>2)
  { 
    /* Get the input string: progstr and verify it */
    Mprogstr=Interf.Param[2];
    if(!MatrixIsString(Mprogstr))
    {
      InterfError("fch1d: The string: progstr must be a string\n");
      return;
    }
    /* Get the input argument */
    progstr=MatrixReadString(Mprogstr); 
    if(MFAM_progstr(progstr,&t_prog)==0)
    {
      InterfError("fch1d: The string: progstr is illegal\n");
      return;
    }
  }

  if(Interf.NbParamIn>3)
  {
    /* Get the input string: oscstr and verify it */
    Moscstr=Interf.Param[3];
    if(!MatrixIsString(Moscstr))
    {
      InterfError("fch1d: The string: oscstr must be a string\n");
      return;
    }
    /* Get the input argument */
    oscstr=MatrixReadString(Moscstr); 
    if(MFAM_oscstr(oscstr,&t_osc,&p)==0)
    {
      InterfError("fch1d: The string: oscstr is illegal\n");
      return;
    }  
    if(p<1.)
    {
      InterfError("fch1d: The parameter: p must be >=1.\n");
      return;
    }
  }

  /* Create the output Matrix */  
  Malpha_eta_x=MatrixCreate(M,J,"real");
  Meta=MatrixCreate(1,J,"real");
  Mx=MatrixCreate(1,M,"real");

  /* Get the pointer on the output Matrix */  
  alpha_eta_x=MatrixGetPr(Malpha_eta_x);
  eta=MatrixGetPr(Meta);
  x=MatrixGetPr(Mx);

  /* Call of the C function */
  if(MFAG_fch1d(M,x,f_x,J,S_min,S_max,t_prog,t_osc,p,alpha_eta_x,eta)==0) 
  { 
    InterfError("fch1d: Call of the C function MFAG_fch1d failed\n");   
    MatrixFree(Mx);
    return;
  }

  /* Transpose output argument */
  MatrixTranspose(Malpha_eta_x);

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


