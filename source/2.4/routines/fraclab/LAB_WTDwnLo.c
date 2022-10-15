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

/* Bertrand Guiheneuf  1996 */

#include "C-LAB_Interf.h"
#include "WT_filters.h"
#include "WT_arbre.h"
#include "WT_mem.h"
#include "WT_wavelet_transform.h"
#include <math.h>


/************  LAB_WTDwnLo **************************************************/
/* routine to call to compute the convolution of signal by a low pass       */
/* filter followed by a downsampling                                        */
/* Usage [Out] = WTDwnLo(In, QMF)                                           */
/* Where :                                                                  */
/*                                                                          */
/*  -Out is the downsampled output of the filter                            */
/*  -In is the signal to analyse. It must be a (1xN) or (Nx1) real matrix   */
/*  -QMF is a LowPass filter, for example a QMF or a CQF                    */ 
/*                                                                          */
/* See also WTDwnHi, FWT, IWT                                               */
/*                                                                          */
/*               Bertrand Guiheneuf 1996                                    */
/*                                                                          */
void LAB_WTDwnLo()

{

  Matrix *MInput; /* The input matrix */
  double *Input;  /* .. and the pointer on its elements */
  int InputSize;  /* its size ! */

  Matrix *MQMF; /* The input QMF */
  double *QMF;  /* .. */
  int QMFSize;

  Matrix *MOutput; /* The output Matrix */
  double  *Output; /* .... */
  int OutputSize;

  t_filtre Filter; /* the Lowpass filter */
  int i; /* a counter */


  if (Interf.NbParamIn != 2) /* Verify the number of input parameters */ 
    {
      InterfError("WTUpLow : You must give 2 input arguments\n");
      return;
    }

  /* Get the input signal and verify it */
  MInput = Interf.Param[0];

  if (!MatrixIsNumeric(MInput) || !MatrixIsReal(MInput) )
    {
      InterfError("WTUpLow : The input signal must be a real matrix\n");
      return;
    }

  if ( MIN(MatrixGetWidth(MInput),MatrixGetHeight(MInput)) != 1 )
    {
      InterfError("WTUpLow : The input signal must be a (1xN) or (Nx1) matrix\n");
      return;
    }
    
  InputSize = MAX(MatrixGetWidth(MInput),MatrixGetHeight(MInput));
  Input = MatrixGetPr(MInput);


 
  /* Get the QMF and verify it */
  MQMF = Interf.Param[1];

  if (!MatrixIsNumeric(MQMF) || !MatrixIsReal(MQMF) )
    {
      InterfError("WTUpLow : The QMF must be a real matrix\n");
      return;
    }

  if ( MIN(MatrixGetWidth(MQMF),MatrixGetHeight(MQMF)) != 1 )
    {
      InterfError("WTUpLow : The QMF must be a (1xN) or (Nx1) matrix\n");
      return;
    }
  
  QMFSize = MAX(MatrixGetWidth(MQMF),MatrixGetHeight(MQMF));
  QMF = MatrixGetPr(MQMF);
 

  /* Now, let's copy the QMF in Filter */
  Filter.taille_neg = (int)floor(QMF[0]); /* Filter left size */
  Filter.taille_pos = (int)floor(QMF[1]); /* Filter right size */
  Filter.taille = 1+ Filter.taille_pos + Filter.taille_neg; /* Filter size */

  if (Filter.taille != (QMFSize-2)) 
    {
      InterfError("The QMF is not defined correctly. Its size doesn't fit the first two parameters.");
      return;
    }
	

  for (i=0; i<Filter.taille; i++)
    Filter.valeur[i]=QMF[i+2]; /* copies the QMF coeff. in Filter */

  /* get the memory for the outuput */
  OutputSize = (InputSize + 1)/2;

  MOutput = MatrixCreate(1,OutputSize,"real"); /* get the output matrix */
  Output = MatrixGetPr(MOutput);

  /* And now, the filtering */
  Filtrage(Input, Output, InputSize, &Filter, WT_Periodisation); 

  ReturnParam(MOutput);



}
  

