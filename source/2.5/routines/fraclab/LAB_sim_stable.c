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

/* sim_stable : stable law simulation */
/* Lotfi Belkacem 1997 */
#include "C-LAB_Interf.h"
#include <math.h>
#include <stdio.h>
#include "sim_stable.h"

#include "FRACLAB_compat.h"
void LAB_sim_stable()
{
   /* Input */
 
 Matrix *Mn;
 int    n;
 
 
 Matrix *Malpha, *Mbeta, *Mmu, *Mgamma;
 double alpha, beta, mu, gamma;
 
  /* Output */

  Matrix *MINC, *MPRO;
  double *INC,  *PRO;

  /* Work */

  double  unif;
  int i;
  long int firstvalue;

  Malpha = (Matrix *)(Interf.Param[0]);
  Mbeta = (Matrix *)(Interf.Param[1]);
  Mmu = (Matrix *)(Interf.Param[2]);
  Mgamma = (Matrix *)(Interf.Param[3]);
  Mn = (Matrix *)(Interf.Param[4]);
  

  /* get and verify the input parameters */

  if (Interf.NbParamIn != 5)
    {
      InterfError("sim_stable : you must give 5 input parameters\n");
      return;
    }
  
  alpha = MatrixGetScalar(Malpha);
  beta = MatrixGetScalar(Mbeta);
  mu = MatrixGetScalar(Mmu);
  gamma = MatrixGetScalar(Mgamma);
  n = (int)MatrixGetScalar(Mn);
  
  
  MPRO = MatrixCreate(n+1,1,"real");
  PRO = MatrixGetPr(MPRO);

  MINC = MatrixCreate(n,1,"real");
  INC = MatrixGetPr(MINC);

 
  time(&firstvalue);
  srand48(firstvalue);

	
  PRO[0]=0.0;
    
  for(i=0;i<n;i++){
    INC[i]=gamma*stable_s(alpha,beta,n)+mu;
    PRO[i+1]=PRO[i]+INC[i];
    }
  
  ReturnParam(MPRO);
  ReturnParam(MINC);
    
}
