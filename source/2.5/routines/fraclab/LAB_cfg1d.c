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
#include "MFAG_continuous.h"

/************  LAB_cfg1d  ***************************************************/

void LAB_cfg1d()
{ 
  /* input parameters */
  short J=1;
  int N_n=0,M=N_n,N=100;
  double a=1.,A=1.;
  MFAMt_prog t_prog=MFAM_LOG;
  MFAGt_cont t_cont=MFAG_HORIKERN;
  MFAGt_adap t_adap=MFAG_MAXDEV;
  MFAMt_kern t_kern=MFAM_GAUSSIAN; 
  MFAGt_norm t_norm=MFAG_SUPPDF;
  /* input coarse grain Hoelder exponents, scales & abscissa */
  double* alpha_eta_x=NULL;  
  double* eta=NULL; 
  double* x=NULL;
  /* input precisions */
  double* epsilon=NULL;
  /* output Hoelder exponents, pdfs & spectra */
  double* alpha=NULL;
  double* pc_alpha=NULL;
  double* fgc_alpha=NULL;  
  /* output optimal precisions */ 
  double* epsilon_star=NULL;
 
  /* Matrix */
  Matrix* Mx;
  Matrix* Meta;
  Matrix* Malpha_eta_x;
  Matrix* Mprogstr;
  Matrix* MJ;
  Matrix* Ma;
  Matrix* MA;
  Matrix* Mcontstr;
  Matrix* Madapstr;
  Matrix* Mepsilon;
  Matrix* Mkernstr;
  Matrix* Mnormstr;
  Matrix* MN;
  Matrix* Malpha;
  Matrix* Mpc_alpha;
  Matrix* Mfgc_alpha;
  Matrix* Mepsilon_star;

  /* Check the input arguments number */
  if(Interf.NbParamIn<2) 
  {
    InterfError("cfg1d: You must give at least 2 input arguments\n");
    return;
  }
  if(Interf.NbParamIn>9) 
  {
    InterfError("cfg1d: You must give at most 9 input arguments\n");
    return;
  }

  /* Check the output arguments number */ 
  if(Interf.NbParamOut<2) 
  {
    InterfError("cfg1d: You must give at least 2 output arguments\n");
    return;
  }
  if(Interf.NbParamOut>4) 
  {
    InterfError("cfg1d: You must give at most 4 output arguments\n");
    return;
  }
  
  /* Get the input coarse grain Hoelder exponents: alpha_eta_x and verify it */
  Malpha_eta_x=Interf.Param[0];
  if(!MatrixIsNumeric(Malpha_eta_x))
  {
    InterfError("cfg1d: The coarse grain Hoelder exponents: alpha_eta_x must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Malpha_eta_x))
  {
    InterfError("cfg1d: The coarse grain Hoelder exponents: alpha_eta_x must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  alpha_eta_x=(double*)MatrixGetPr(Malpha_eta_x);
  /* Get the size of the input argument */ 
  M=(int)MatrixGetWidth(Malpha_eta_x); 
  if(M<1)
  {
    InterfError("cfg1d: The width of coarse grain Hoelder exponents: alpha_eta_x must be >=1\n");
    return;
  }
  J=(int)MatrixGetHeight(Malpha_eta_x);
  if(J<1)
  {
    InterfError("cfg1d: The height of coarse grain Hoelder exponents: alpha_eta_x must be >=1\n");
    return;
  }

  /* Get the input scales: eta and verify it */
  Meta=Interf.Param[1];
  if(!MatrixIsNumeric(Meta))
  {
    InterfError("cfg1d: The scales: eta must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Meta))
  {
    InterfError("cfg1d: The scales: eta must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  eta=(double*)MatrixGetPr(Meta);
  /* Get the size of the input argument */ 
  if(((int)MAX(MatrixGetWidth(Meta),MatrixGetHeight(Meta)))!=J)
  {
    InterfError("cfg1d: The size of scales: eta & height of coarse grain Hoelder exponent: alpha_eta_x must be equal\n");
    return;
  } 

  /* Get the input abscissa: x and verify it */
  Mx=Interf.Param[2];
  if(!MatrixIsNumeric(Mx))
  {
    InterfError("cfg1d: The abscissa: x must be a numeric matrix\n");
    return;
  }
  if(!MatrixIsReal(Mx))
  {
    InterfError("cfg1d: The abscissa: x must be a real matrix\n");
    return;
  }
  /* Get the input argument */  
  x=(double*)MatrixGetPr(Mx);
  /* Get the size of the input argument */ 
  if((int)MatrixGetWidth(Mx)!=M)
  {
    InterfError("cfg1d: The width of abscissa: x & width of coarse grain Hoelder exponent: alpha_eta_x must be equal\n");
    return;
  }
  /* if((int)MatrixGetHeight(Mx)!=J) */
/*   { */
/*     InterfError("cfg1d: The height of abscissa: x & height of coarse grain Hoelder exponent: alpha_eta_x must be equal\n"); */
/*     return; */
/*   } */
 
  if(Interf.NbParamIn>3)
  { 
    /* Get the input # of Hoelder exponents: N and verify it */
    MN=Interf.Param[3];
    if(!MatrixIsNumeric(MN))
    {
      InterfError("cfg1d: The # of Hoelder exponents: N  must be a numeric matrix\n");
      return;
    }  
    if(!MatrixIsScalar(MN))
    {
      InterfError("cfg1d: The # of Hoelder exponents: N  must be a scalar\n");
      return;
    }
    /* Get the input argument */
    N=(short)MatrixGetScalar(MN);
    if(N<1)
    {
      InterfError("cfg1d: The # of Hoelder exponents: N must be >=1\n");
      return;
    }
  }

  if(Interf.NbParamIn>4)
  { 
    /* Get the input precision epsilon and verify it */
    Mepsilon=Interf.Param[4];
    if(!MatrixIsNumeric(Mepsilon))
    {
      InterfError("cfg1d: The precision: epsilon must be a numeric matrix\n");
      return;
    } 
    if(!MatrixIsReal(Mepsilon))
    {
      InterfError("cfg1d: The precision: epsilon must be a real matrix\n");
      return;
    }
    /* Get the input argument */  
    epsilon=(double*)MatrixGetPr(Mepsilon);
    /* Get the size of the input argument */ 
    if(((short)MAX(MatrixGetWidth(Mepsilon),MatrixGetHeight(Mepsilon)))!=N)
    {
      InterfError("cfg1d: The size of the precision: epsilon must be N\n");
      return;
    }  
  }
  else
  {
    /* dynamic memory allocation */
    if((epsilon=(double*)malloc((unsigned)(N*sizeof(double))))==NULL)
    {
      InterfError("cfg1d: malloc error\n"); 
      return;
    }
  }

  if(Interf.NbParamIn>5)
  { 
    /* Get the input string: contstr and verify it */
    Mcontstr=Interf.Param[5];
    if(!MatrixIsString(Mcontstr))
    {
      InterfError("cfg1d: The string: contstr must be a string\n");
      return;
    }
    /* Get the input argument */ 
    if(MFAG_contstr(MatrixReadString(Mcontstr),&t_cont)==0)
    {
      InterfError("cfg1d: The string: contstr is illegal\n");
      return;
    }
  }

  if(Interf.NbParamIn>6)
  { 
    /* Get the input string: adapstr and verify it */
    Madapstr=Interf.Param[6];
    if(!MatrixIsString(Madapstr))
    {
      InterfError("cfg1d: The string: adapstr must be a string\n");
      return;
    }
    /* Get the input argument */ 
    if(MFAG_adapstr(MatrixReadString(Madapstr),&t_adap)==0)
    {
      InterfError("cfg1d: The string: adapstr is illegal\n");
      return;
    }
  }

  if(Interf.NbParamIn>7)
  { 
    /* Get the input string: kernstr and verify it */
    Mkernstr=Interf.Param[7];
    if(!MatrixIsString(Mkernstr))
    {
      InterfError("cfg1d: The string: kernstr must be a string\n");
      return;
    }
    /* Get the input argument */
    if(MFAM_kernelstr(MatrixReadString(Mkernstr),&t_kern)==0)
    {
      InterfError("cfg1d: The string: kernstr is illegal\n");
      return;
    }
  }

  if(Interf.NbParamIn>8)
  { 
    /* Get the input string: normstr and verify it */
    Mnormstr=Interf.Param[8];
    if(!MatrixIsString(Mnormstr))
    {
      InterfError("cfg1d: The string: normstr must be a string\n");
      return;
    }
    /* Get the input argument */
    if(MFAG_normstr(MatrixReadString(Mnormstr),&t_norm)==0)
    {
      InterfError("cfg1d: The string: normstr is illegal\n");
      return;
    }
  }

  /* Create the output Matrix */ 
  Malpha=MatrixCreate(1,N,"real");
  Mfgc_alpha=MatrixCreate(N,J,"real"); 
  Mpc_alpha=MatrixCreate(N,J,"real");   
  Mepsilon_star=MatrixCreate(N,J,"real");
 
  /* Get the pointer on the output Matrix */  
  alpha=MatrixGetPr(Malpha);  
  fgc_alpha=MatrixGetPr(Mfgc_alpha);  
  pc_alpha=MatrixGetPr(Mpc_alpha);
  epsilon_star=MatrixGetPr(Mepsilon_star);

  /* Call of the C function */ 
  if(MFAG_cfg1d(J,eta,M,x,alpha_eta_x,N,epsilon,t_cont,t_adap,t_kern,t_norm,alpha,pc_alpha,fgc_alpha,epsilon_star)==0)
  {
    InterfError("cfg1d: Call of the C function MFAG_cfg1d failed\n");  
    return;
  }   

  /* Transpose output argument */
  MatrixTranspose(Mfgc_alpha); 
  MatrixTranspose(Mpc_alpha);
  MatrixTranspose(Mepsilon_star);

  /* Return the output */
  ReturnParam(Malpha);
  ReturnParam(Mfgc_alpha);
  if(Interf.NbParamOut>2) 
    ReturnParam(Mpc_alpha);
  else
    MatrixFree(Mpc_alpha);
  if(Interf.NbParamOut>3)
    ReturnParam(Mepsilon_star);
  else
    MatrixFree(Mepsilon_star);
}


