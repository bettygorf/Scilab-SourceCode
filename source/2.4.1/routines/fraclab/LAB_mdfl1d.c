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
#include "MFAL_discrete.h"

/************  LAB_mdfl1d  ***************************************************/

void LAB_mdfl1d()
{ 
  /* input parameters */
  short J=10,N=300;
  int N_n=1024,Q=N; 
  double S_min=1;
  /* modif bertrand */
  double S_max=512;
  double P_min=2;
  double P_max=1024;
  double q_min=-10.;
  double q_max=10.; 
  MFAMt_part t_part=MFAM_LOGPART;
  MFAMt_lr t_lr=MFAM_LSLR;
  /* input measure */
  double* I_n=NULL;
  double* mu_n=NULL;
  /* output powers, partition sum & mass exponents functions */ 
  double* q=NULL;
  double* a=NULL;
  double* Z_a_q=NULL;
  double* t_q=NULL;
  /* output spectrum */
  double* alpha=NULL;
  double* fl_alpha=NULL;

  double* Pralpha=NULL;
  double* Prfl_alpha=NULL;
  Matrix* Mmu_n;
  Matrix* Mq;
  Matrix* Mmin_max_J; 
  Matrix* Mpartstr;
  Matrix* MZ_a_q;  
  Matrix* Ma;  
  Matrix* Mlrstr;
  Matrix* Mt_q;
  Matrix* Malpha; 
  Matrix* Mfl_alpha;

  /* Check the input arguments number */
  if(Interf.NbParamIn<2) 
  {
    InterfError("mdfl1d: You must give at least 2 input arguments\n");
    return;
  }
  if(Interf.NbParamIn>5) 
  {
    InterfError("mdzq1d: You must give at most 5 input arguments\n");
    return;
  }

  /* Check the output arguments number */
  if(Interf.NbParamOut<2)
  {
    InterfError("mdfl1d: You must give at least 2 output arguments\n");
    return;
  }
  if(Interf.NbParamOut>5)
  {
    InterfError("mdfl1d: You must give at most 5 output arguments\n");
    return;
  }
 
  /* Get the input measure mu_n and verify it */
  Mmu_n=Interf.Param[0];
  if(!MatrixIsNumeric(Mmu_n))
  {
    InterfError("mdfl1d: The measure: mu_n must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mmu_n))
  {
    InterfError("mdfl1d: The measure: mu_n must be a real matrix\n");
    return;
  }
  N_n=(int)MAX(MatrixGetWidth(Mmu_n),MatrixGetHeight(Mmu_n));
  /* Get the input argument */ 
  mu_n=MatrixGetPr(Mmu_n);

  /* Get the input exponents q and verify it */
  Mq=Interf.Param[1];
  if(!MatrixIsNumeric(Mq))
  {
    InterfError("mdzq1d: The exponents: q must be a numeric matrix\n");
    return;
  }

  if(!MatrixIsReal(Mq))
  {
    InterfError("mdzq1d: The exponents: q must be a real matrix\n");
    return;
  } 
  Q=(short)MAX(MatrixGetWidth(Mq),MatrixGetHeight(Mq));
  /* Get the input argument */ 
  q=MatrixGetPr(Mq);
  
  if(Interf.NbParamIn>2)
  {  
    /* Get the input vector: [min max J] and verify it */
    Mmin_max_J=Interf.Param[2];
    if(!MatrixIsNumeric(Mmin_max_J))
    {
      InterfError("mdzq1d: The vector: [min max J] must be a numeric matrix\n");
      return;
    }
    if(!MatrixIsReal(Mmin_max_J))
    {
      InterfError("mdzq1d: The vector: [min max J] must be a real matrix\n");
      return;
    }
    if(((int)MAX(MatrixGetWidth(Mmin_max_J),MatrixGetHeight(Mmin_max_J)))!=3)
    {
      InterfError("mdzq1d: The vector: [min max J] is illegal\n");
      return;
    }
    /* Get the input argument */ 
    if(t_part==MFAM_DECSIZE)
    {
      S_min=*(MatrixGetPr(Mmin_max_J));
      S_max=*(MatrixGetPr(Mmin_max_J)+1);
    }
    else
    { 
      P_min=*(MatrixGetPr(Mmin_max_J));
      P_max=*(MatrixGetPr(Mmin_max_J)+1);
    } 
    J=(short)*(MatrixGetPr(Mmin_max_J)+2); 
  }
  else
  {
    short b=0;
    if(MFAM_base(N_n,&b)==0)
    {
      J=floor(log(N_n)/log(2.));
      S_min=1;
      S_max=floor(N_n/2.);
    }
    else
    {
      J=floor(log(N_n)/log((double)b));
      S_min=1;
      S_max=floor(N_n/(double)b);
      P_min=1;
      P_max=floor(N_n/(double)b);
    }
  }
 
  if(Interf.NbParamIn>3)
  {  
    /* Get the input string: partstr and verify it */
    Mpartstr=Interf.Param[3];
    if(!MatrixIsString(Mpartstr))
    {
      InterfError("mcfg1d: The string: partstr must be a string\n");
      return;
    }
    /* Get the input argument */
    if(MFAM_partstr(MatrixReadString(Mpartstr),&t_part)==0)
    {
      InterfError("mcfg1d: The string: partstr is illegal\n");
      return;
    }
  }

  if(Interf.NbParamIn>4)
  {
    /* Get the input string: lrstr and verify it */
    Mlrstr=Interf.Param[4];
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

  N=Q;
 
  /* dynamic memory allocation */
  if((alpha=(double*)malloc((unsigned)(N*sizeof(double))))==NULL) 
  { 
    InterfError("mdfl1d: malloc error\n");
    return;
  }     
  if((fl_alpha=(double*)malloc((unsigned)(N*sizeof(double))))==NULL) 
  { 
    InterfError("mdfl1d: malloc error\n");
    return;
  } 
 
  /* Create the output Matrix */
  Ma=MatrixCreate(1,J,"real");
  MZ_a_q=MatrixCreate(Q,J,"real");
  Mt_q=MatrixCreate(1,Q,"real");

  /* Get the pointer on the output Matrix */  
  a=MatrixGetPr(Ma);
  Z_a_q=MatrixGetPr(MZ_a_q);
  t_q=MatrixGetPr(Mt_q);
  
  /* Call of the C function */
  if(MFAL_mdfl1d(N_n,mu_n,t_part,J,S_min,S_max,P_min,P_max,a,Q,q,Z_a_q,t_lr,t_q,&N,alpha,fl_alpha)==0) 
  { 
    InterfError("mdfl1d: Call of the C function MFAL_mdfl1d failed\n"); 
    free((char*)alpha);
    free((char*)fl_alpha);
    return;
  }
 
  /* Create the output Matrix */  
  Malpha=MatrixCreate(1,N,"real");
  Mfl_alpha=MatrixCreate(1,N,"real");
 
  /* Get the pointer on the output Matrix */  
  Pralpha=MatrixGetPr(Malpha);
  Prfl_alpha=MatrixGetPr(Mfl_alpha);
  { 
    register n=0;
    for(n=0;n<N;n++)
    {   
      *(Pralpha+n)=*(alpha+n);
      *(Prfl_alpha+n)=*(fl_alpha+n);
    }
  }

  /* dynamic memory desallocation */
  free((char*)alpha);
  free((char*)fl_alpha);

  /* Transpose the output */
  MatrixTranspose(MZ_a_q);

  /* Return the output */
  ReturnParam(Malpha);
  ReturnParam(Mfl_alpha);
  if(Interf.NbParamOut>2)
    ReturnParam(MZ_a_q);
  else
    MatrixFree(MZ_a_q);
  if(Interf.NbParamOut>3)
    ReturnParam(Ma);
  else
    MatrixFree(Ma); 
  if(Interf.NbParamOut>4)
    ReturnParam(Mt_q);
  else
    MatrixFree(Mt_q);
}


