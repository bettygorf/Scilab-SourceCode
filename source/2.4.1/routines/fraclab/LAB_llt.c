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
#include "MFAM_concave_hull.h"
#include "MFAM_legendre.h"

/************  LAB_llt  **************************************************/

void LAB_llt()
{ 
  register k=0;                                                 /* index */
  int x_nb=0;                                             /* # of points */
  double *x=NULL;                            /* abscissa of the function */
  double *u_x=NULL;                                          /* function */
  int rx_nb=0;                /* # of points of the regularized function */  
  double *rx=NULL;               /* abscissa of the regularized function */
  double *ru_x=NULL;                             /* regularized function */  
  double *s=NULL;                  /* abscissa of the Legendre transform */
  double *u_star_s=NULL;                           /* Legendre transform */
  double *Prrx=NULL;
  double *Prru_x=NULL; 

  Matrix *Mx;       /* matrix pointing on the abscissa of the function   */
  Matrix *Mu_x;     /* matrix pointing on the function                   */
  Matrix *Mrx;      /* matrix pointing on the abscissa of the            */
                    /* regularized function                              */
  Matrix *Mru_x;    /* matrix pointing on the regularized function       */
  Matrix *Ms;       /* matrix pointing on the abscissa                   */
  Matrix *Mu_star_s;/* matrix pointing on the Legendre transform         */

  /* Check the input arguments number */
  if(Interf.NbParamIn!=2) 
  {
    InterfError("llt: You must give 2 input arguments\n");
    return;
  }
  
  /* Check the output arguments number */
  if((Interf.NbParamOut!=2)&&(Interf.NbParamOut!=4))
  {
    InterfError("llt: You must give 2 or 4 output arguments\n");
    return;
  }
   
  /* Get the input abscissa x and verify it */
  Mx=Interf.Param[0];
  if(!MatrixIsNumeric(Mx))
  {
    InterfError("llt: The abscissa x  must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mx))
  {
    InterfError("llt: The abscissa x must be a real matrix\n");
    return;
  } 
 
  /* Get the width of the input abscissa x */ 
  x_nb=(int)MatrixGetWidth(Mx);

  /* Get the pointer on the input abscissa x */ 
  x=MatrixGetPr(Mx);
 
  /* Get the input function u_x and verify it */
  Mu_x=Interf.Param[1];
  if(!MatrixIsNumeric(Mu_x))
  {
    InterfError("llt: The function u_x  must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mu_x))
  {
    InterfError("llt: The function u_x must be a real matrix\n");
    return;
  }
  
  /* Check the size of the input function u_x */
  if(x_nb!=(int)MatrixGetWidth(Mx))
  {
    InterfError("llt: The abscissa x and the function u_x must be of the same size\n");
    return;
  } 
 
  /* Get the pointer on the input function u_x */ 
  u_x=MatrixGetPr(Mu_x);

  /* dynamic memory allocation */            
  if((rx=(double*)malloc((unsigned)(x_nb*sizeof(double))))==NULL)
  {
    InterfError("llt: malloc error\n");
    return; 
  }               
  if((ru_x=(double*)malloc((unsigned)(x_nb*sizeof(double))))==NULL)
  {  
    InterfError("llt: malloc error\n");
    return; 
  }  

  /* Fill in the input vectors rx and ru_x */
  for(k=0;k<x_nb;k++)
  {
    *(rx+k)=*(x+k);
    *(ru_x+k)=*(u_x+k);
  }

  /* Call of the C function */  
  if(MFAM_bb_concave_hull(x_nb,rx,ru_x,&rx_nb)==0)
  {
    InterfError("llt: Call of the C function MFAM_bb_concave_hull failed\n");
    return; 
  }
      
  /* Create the output Matrix */  
  Ms=MatrixCreate(1,rx_nb,"real");
  Mu_star_s=MatrixCreate(1,rx_nb,"real");
 
  /* Get the pointer on the output Matrix */  
  s=MatrixGetPr(Ms);
  u_star_s=MatrixGetPr(Mu_star_s);
 
  /* Call of the C function */  
  if(MFAM_llt(rx_nb,rx,ru_x,s,u_star_s)==0) 
  { 
    InterfError("llt: Call of the C function MFAM_llt failed\n"); 
    return;
  }

  if(Interf.NbParamOut==4)
  { 
    /* Create the output Matrix */  
    Mrx=MatrixCreate(1,rx_nb,"real");
    Mru_x=MatrixCreate(1,rx_nb,"real");
 
    /* Get the pointer on the output Matrix */  
    Prrx=MatrixGetPr(Mx);
    Prru_x=MatrixGetPr(Mru_x); 
     
    /* Fill in the output vectors Prrx and Prru_x */
    for(k=0;k<rx_nb;k++)
    {  
      *(Prrx+k)=*(rx+k);
      *(Prru_x+k)=*(ru_x+k);
    }
  }

  /* dynamic memory desallocation */       
  free((char*)rx);
  free((char*)ru_x);

  /* Return the output */
  ReturnParam(Ms);
  ReturnParam(Mu_star_s);
  if(Interf.NbParamOut==4)
  { 
    ReturnParam(Mrx);
    ReturnParam(Mru_x);
  }
}


