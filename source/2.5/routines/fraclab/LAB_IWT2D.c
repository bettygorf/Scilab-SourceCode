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

/* Bertrand Guiheneuf  1997 */

#include "C-LAB_Interf.h"
#include "WT2D_filters.h"
#include "WT2D_arbre.h"
#include "WT2D_mem.h"
#include "WT2D_wavelet_transform.h"
#include "WT2D_const.h"
#include <math.h>

void LAB_IWT2D()

{
  
  double *Input; /* the input WT with the info. fields at the beginning */
  Matrix *MInput; /* ...the matrix */

  double *QMF; /* the QMF */
  Matrix *MQMF;
  int QMFSize;

  int OutputSize; /* the resulting signal size */
  int OutputHeight;
  int OutputWidth;
  Matrix *MOutput; /* The output Matrix */
  double *Output; /* ... and the output values */
  
  int IterNb; /* Number of levels in the decomposition */

  double *WT_DATA; /* a pointer to the coeff. of the decomposition  */

  t_filtre_WT2D Filter; /* the LowPass filter of the decomposition */

  t_arbreWT2D *Tree; /* the coefficients tree */
 
  int OrigSignalSize;
  double *Tmp; /* The temp. array */
  int i; /* a counter */


  
  if (Interf.NbParamIn < 1) /* Verify the number of input parameters */ 
    {
      InterfError("IWT2D : You must give at least 1 input arguments\n");
      return;
    }

  if (Interf.NbParamIn > 2) /* Verify the number of input parameters */ 
    {
      InterfError("IWT2D : You must give at most 2 input arguments\n");
      return;
    }


 
  MInput = Interf.Param[0]; /* the Wavelet transform coeff + the infos */

  if (!MatrixIsNumeric(MInput) || !MatrixIsReal(MInput) )
    {
      InterfError("IWT2D: The input Wavelet transform must be a real matrix\n");
      return;
    }

  if ( MIN(MatrixGetWidth(MInput),MatrixGetHeight(MInput)) != 1 )
    {
      InterfError("IWT2D : The input Wavelet transform must be a (1xN) or (Nx1) matrix\n");
      return;
    }

  Input = MatrixGetPr( MInput); /* Pointer on the real part of the Matrix */

  
  OutputHeight = (int)floor(Input[0]); /* The Original Signal size  */
  OutputWidth = (int)floor(Input[1]); 
  OutputSize = OutputHeight * OutputWidth;
  OrigSignalSize = OutputSize;
  
  IterNb = (int)floor(Input[2]); /* The Number of levels of the decomposition */
  
  if ( (siz_tab_sortieWT2D(OutputWidth, OutputHeight, IterNb) + 5 + 
	(int)floor(Input[3]) + (int)floor(Input[4]) +1)
       != ( (int)MatrixGetHeight(MInput)*(int)MatrixGetWidth(MInput) ) )
    {
      InterfError("IWT2D : Input Wavelet Transform is not correct\n");
      return;
    }

  if (Interf.NbParamIn == 2 ) /* The QMF is given in the arguments */
    {
      MQMF = Interf.Param[1];
      
      if (!MatrixIsNumeric(MQMF) || !MatrixIsReal(MQMF) )
	{
	  InterfError("IWT2D : The QMF must be a real matrix\n");
	  return;
	}
      
      if ( MIN(MatrixGetWidth(MQMF),MatrixGetHeight(MQMF)) != 1 )
	{
	  InterfError("DWT : The QMF must be a (1xN) or (Nx1) matrix\n");
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
       
    }

  else /* The QMF is not given, take in in the input matrix */

    {
      Filter.taille_neg = (int)floor(Input[3]); /* Gets the reconstruction QMF */
      Filter.taille_pos = (int)floor(Input[4]);/* and sets its parameters */
      Filter.taille = Filter.taille_neg + Filter.taille_pos +1; 
      /* the anti-causal + the causal + the present */
      
      for (i=0; i<Filter.taille; i++) /* Copies the filter values */
	Filter.valeur[i] = Input[i+5];
      
    }

  /* Calculate the pointer on the decomposition */
  WT_DATA = Input + 5 + (int)floor(Input[3]) + (int)floor(Input[4]) + 1 ; 
 
  /* Creation of the decomposition tree */
  Tree = (t_arbreWT2D *)malloc(IterNb*sizeof(t_arbreWT2D));  
  /*const_arbreWT2D(WT_DATA, Tree, OutputWidth, OutputHeight, IterNb);*/
  const_arbreWT2D(WT_DATA, Tree, OutputHeight, OutputWidth, IterNb);

  /* Create the output buffer */
  MOutput = MatrixCreate(OutputHeight, OutputWidth,  "real"); 
  Output = MatrixGetPr(MOutput);
  /* The temporary memory for the Inverse transform calculation */
  Tmp = (double *)malloc( (OutputHeight+1)*(OutputWidth+1) * sizeof(double));
 
  /* GO! */

  /* WT2DInverse(Tree, Output, Tmp, &Filter, IterNb,  OutputWidth, OutputHeight, &WT2D_Periodisation); */
  /* to avoid transposition */
  WT2DInverse(Tree, Output, Tmp, &Filter, IterNb, OutputHeight,  OutputWidth, WT2D_Periodisation);
  /* Return the unique result */
  ReturnParam( MOutput );
 
  free(Tmp);
  free(Tree);
 

}

