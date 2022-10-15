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
#include "MFAM_concave_hull.h"

/************  LAB_bbch  ***************************************************/

void LAB_bbch()
{ 
  register k=0;   
  /* # of points of the input function */       
  int N=20;
  /* input abscissa & function */ 
  double* x=NULL;
  double* u_x=NULL;
  /* # of points of the regularized function */ 
  int M=0;
  /* regularized function & abscissa */  
  double* rx=NULL;
  double* ru_x=NULL; 
  /* temporay pointers */             
  double* tmprx=NULL;              
  double* tmpru_x=NULL;

  Matrix* Mx;
  Matrix* Mu_x;
  Matrix* Mrx;
  Matrix* Mru_x;

  /* Check the input arguments number */
  if(Interf.NbParamIn!=2) 
  {
    InterfError("bbch: You must give 2 input arguments\n");
    return;
  }
  
  /* Check the output arguments number */
  if(Interf.NbParamOut!=2)
  {
    InterfError("bbch: You must give 2 output arguments\n");
    return;
  }
   
  /* Get the input abscissa x and verify it */
  Mx=Interf.Param[0];
  if(!MatrixIsNumeric(Mx))
  {
    InterfError("bbch: The abscissa: x  must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mx))
  {
    InterfError("bbch: The abscissa: x must be a real matrix\n");
    return;
  } 
  /* Get the width of the input abscissa x */ 
  N=(int)MAX(MatrixGetWidth(Mx),MatrixGetHeight(Mx));
  /* Get the pointer on the input abscissa x */ 
  x=MatrixGetPr(Mx);
 
  /* Get the input function u_x and verify it */
  Mu_x=Interf.Param[1];
  if(!MatrixIsNumeric(Mu_x))
  {
    InterfError("bbch: The function: u_x  must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mu_x))
  {
    InterfError("bbch: The function: u_x must be a real matrix\n");
    return;
  } 
  /* Check the size of the input function u_x */
  if(N!=(int)MAX(MatrixGetWidth(Mu_x),MatrixGetHeight(Mu_x)))
  {
    InterfError("bbch: The abscissa: x and the function: u_x must be of the same size\n");
    return;
  }
  /* Get the pointer on the input function u_x */ 
  u_x=MatrixGetPr(Mu_x);

  /* dynamic memory allocation */            
  if((tmprx=(double*)malloc((unsigned)(N*sizeof(double))))==NULL)
  {
    InterfError("bbch: malloc error\n");
    return; 
  }               
  if((tmpru_x=(double*)malloc((unsigned)(N*sizeof(double))))==NULL)
  {  
    InterfError("bbch: malloc error\n");
    return; 
  }  

  /* Fill in the input vectors rx and ru_x */
  for(k=0;k<N;k++)
  {
    *(tmprx+k)=*(x+k);
    *(tmpru_x+k)=*(u_x+k);
  }

  /* Call of the C function */  
  if(MFAM_bb_concave_hull(N,tmprx,tmpru_x,&M)==0)
  {
    InterfError("bbch: Call of the C function MFAM_bb_concave_hull failed\n");
    return; 
  }

  /* Create the output Matrix */  
  Mrx=MatrixCreate(1,M,"real");
  Mru_x=MatrixCreate(1,M,"real");
 
  /* Get the pointer on the output Matrix */  
  rx=MatrixGetPr(Mrx);
  ru_x=MatrixGetPr(Mru_x);
  
  /* Fill in the output vectors rx and rru_x */
  for(k=0;k<M;k++)
  {   
    *(rx+k)=*(tmprx+k);
    *(ru_x+k)=*(tmpru_x+k);
  }
 
  /* dynamic memory desallocation */   
  free((char*)tmprx);
  free((char*)tmpru_x);

  /* Return the output */
  ReturnParam(Mrx);
  ReturnParam(Mru_x);

}


