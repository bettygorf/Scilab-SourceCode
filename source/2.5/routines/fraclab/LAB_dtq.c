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
#include "MFAL_reyni.h"

/************  LAB_dtq  ******************************************************/

void LAB_dtq()
{ 
  /* input parameters */
  short J=10,Q=20;
  MFAMt_lr t_lr=MFAM_LSLR;
  /* input partition function, powers & scales */
  double* Z_a_q=NULL; 
  double* q=NULL;
  double* a=NULL;
  /* output Reyni exponents function */
  double* t_q=NULL;
 
  Matrix* MZ_a_q;
  Matrix* Mq;  
  Matrix* Ma;  
  Matrix* Mt_q;
  Matrix* Mlrstr;

  /* Check the input arguments number */
  if(Interf.NbParamIn<3) 
  {
    InterfError("dtq: You must give at least 3 input arguments\n");
    return;
  }
  if(Interf.NbParamIn>4) 
  {
    InterfError("dtq: You must give at most 4 input arguments\n");
    return;
  }

  /* Check the output arguments number */
  if(Interf.NbParamOut<1)
  {
    InterfError("dtq: You must give at least 1 output argument\n");
    return;
  }
  if(Interf.NbParamOut>2)
  {
    InterfError("dtq: You must give at most 2 output arguments\n");
    return;
  }
   
  /* Get the input Partition function Z_a_q and verify it */
  MZ_a_q=Interf.Param[0];
  if(!MatrixIsNumeric(MZ_a_q))
  {
    InterfError("dtq: The Partition function: Z_a_q must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(MZ_a_q))
  {
    InterfError("dtq: The input Partition function Z_a_q must be a real matrix\n");
    return;
  } 
  /* Transpose Matrix */
  MatrixTranspose(MZ_a_q);
  /* Get the input argument */ 
  Z_a_q=MatrixGetPr(MZ_a_q);
  
  /* Get the input exponents q and verify it */
  Mq=Interf.Param[1];
  if(!MatrixIsNumeric(Mq))
  {
    InterfError("dtq: The exponents: q must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mq))
  {
    InterfError("dtq: The exponents: q must be a real matrix\n");
    return;
  } 
  /* Get the input argument */ 
  q=MatrixGetPr(Mq);
  /* Get the size of the input argument */ 
  Q=(int)MAX(MatrixGetWidth(Mq),MatrixGetHeight(Mq)); 
  if(Q!=MatrixGetHeight(MZ_a_q))
  {
    InterfError("dtq: The Partition function: Z_a_q must be of height equal to the size of exponents vector: q\n");
    return;
  } 

  /* Get the input scale a and verify it */
  Ma=Interf.Param[2];
  if(!MatrixIsNumeric(Ma))
  {
    InterfError("dtq: The scales: a  must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Ma))
  {
    InterfError("dtq: The scales: a must be a real matrix\n");
    return;
  }
  /* Get the input argument */ 
  a=MatrixGetPr(Ma);
  /* Get the size of the input argument */
  J=(int)MAX(MatrixGetWidth(Ma),MatrixGetHeight(Ma));
  if(J!=MatrixGetWidth(MZ_a_q))
  {
    InterfError("dtq: The Partition function: Z_a_q must be of width equal to the size of scale vector: a\n");
    return;
  }
 
  if(Interf.NbParamIn>3)
  {
    /* Get the input string: lrstr and verify it */
    Mlrstr=Interf.Param[3];
    if(!MatrixIsString(Mlrstr))
    {
      InterfError("dtq: The string: lrstr must be a string\n");
      return;
    }
    /* Get the input argument */
    if(MFAM_lrstr(MatrixReadString(Mlrstr),&t_lr)==0)
    {
      InterfError("dtq: The string: lrstr is illegal\n");
      return;
    }
  }

  /* Create the output Matrix */  
  Mt_q=MatrixCreate(1,Q,"real");

  /* Get the pointer on the output Matrix */  
  t_q=MatrixGetPr(Mt_q);
 
  /* Call of the C function */
  if(MFAL_dtq(J,a,Q,q,Z_a_q,t_lr,t_q)==0) 
  { 
    InterfError("dtq: Call of the C function MFAL_dtq failed\n"); 
    return;
  }
  /* Return the output */
  ReturnParam(Mt_q);
  if(Interf.NbParamOut>1)
  { 
    register k=0; 
    double* D_q=NULL;
    Matrix* MD_q; 

    /* Create the output Matrix */  
    MD_q=MatrixCreate(1,Q,"real");
 
    /* Get the pointer on the output Matrix */  
    D_q=MatrixGetPr(MD_q);

    for(k=0;k<Q;k++)
      if(*(q+k)!=1.)
	*(D_q+k)=*(t_q+k)/(*(q+k)-1.);

    ReturnParam(MD_q);
  } 

  /* Transpose Matrix */
  MatrixTranspose(MZ_a_q);
}


