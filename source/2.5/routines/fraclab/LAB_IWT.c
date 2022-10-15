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


/************  LAB_IWT  ***************************************************/
/* Routinre to call to compute the inverse 1D Wavelet Transform of a 1D     */
/* signal.                                                                  */
/* Usage:                                                                   */
/*   S = IWT[WT {, QMF}]                                                    */
/* Where:                                                                   */
/*                                                                          */
/*  -WT is the result of a wavelet transform                                */
/*  -QMF is the reconstruction LowPass filter                               */
/*   if not specified, the QMF given at the time of the decompositon        */
/*   this option is mainly usefull for biorthogonal decomposition           */
/*  -S is the reconstructed signal                                          */
/*                                                                          */
/*               Bertrand Guiheneuf 1996                                    */
void LAB_IWT()

{
  
  double *Input; /* the input WT with the info. fields at the beginning */
  Matrix *MInput; /* ...the matrix */

  double *QMF; /* the QMF */
  Matrix *MQMF;
  int QMFSize;

  int OutputSize; /* the resulting signal size */
  Matrix *MOutput; /* The output Matrix */
  double *Output; /* ... and the output values */
  
  int OrigSignalSize;
  int IterNb; /* Number of levels in the decomposition */

  double *WT_DATA; /* a pointer to the coeff. of the decomposition  */

  t_filtre Filter; /* the LowPass filter of the decomposition */

  t_arbreWT *Tree; /* the coefficients tree */
 
  double *Tmp; /* The temp. array */
  int i; /* a counter */


  
  if (Interf.NbParamIn < 1) /* Verify the number of input parameters */ 
    {
      InterfError("IWT : You must give at least 1 input arguments\n");
      return;
    }

  if (Interf.NbParamIn > 2) /* Verify the number of input parameters */ 
    {
      InterfError("IWT : You must give at most 2 input arguments\n");
      return;
    }


 
  MInput = Interf.Param[0]; /* the Wavelet transform coeff + the infos */

  if (!MatrixIsNumeric(MInput) || !MatrixIsReal(MInput) )
    {
      InterfError("IWT: The input Wavelet transform must be a real matrix\n");
      return;
    }

  if ( MIN(MatrixGetWidth(MInput),MatrixGetHeight(MInput)) != 1 )
    {
      InterfError("IWT : The input Wavelet transform must be a (1xN) or (Nx1) matrix\n");
      return;
    }

  Input = MatrixGetPr( MInput); /* Pointer on the real part of the Matrix */

  
  OrigSignalSize = (int)floor(Input[0]); /* The Original Signal size  */
  IterNb = (int)floor(Input[1]); /* The Number of levels of the decomposition */

  /* Check that the input Wavelet Transform has been obtained with FWT */
  if ( (4 + (int)floor(Input[2]) + (int)floor(Input[3]) 
	+ 1 + siz_tab_sortie(OrigSignalSize, IterNb))
       != ( (int)MatrixGetHeight(MInput)*(int)MatrixGetWidth(MInput) ) )
    {
      InterfError("IWT : Input Wavelet Transform is not correct\n");
      return;
    }

  


  if (Interf.NbParamIn == 2 ) /* The QMF is given in the arguments */
    {
      MQMF = Interf.Param[1];
      
      if (!MatrixIsNumeric(MQMF) || !MatrixIsReal(MQMF) )
	{
	  InterfError("DWT: The QMF must be a real matrix\n");
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
      Filter.taille_neg = (int)floor(Input[2]); /* Gets the reconstruction QMF */
      Filter.taille_pos = (int)floor(Input[3]);/* and sets its parameters */
      Filter.taille = Filter.taille_neg + Filter.taille_pos +1; 
      /* the anti-causal + the causal + the present */
      
      for (i=0; i<Filter.taille; i++) /* Copies the filter values */
	Filter.valeur[i] = Input[i+4];
      
    }

  /* Calculate the pointer on the decomposition */
  WT_DATA = Input + 4 + (int)floor(Input[2]) + (int)floor(Input[3]) + 1 ; 
  
  /* Creation of the decomposition tree */
  Tree = (t_arbreWT *)malloc(IterNb*sizeof(t_arbreWT));  
  const_arbreWT(WT_DATA, Tree, OrigSignalSize, IterNb);

  /* Create the output buffer */
  MOutput = MatrixCreate(1,OrigSignalSize,"real"); 
  Output = MatrixGetPr(MOutput);
  /* The temporary memory for the Inverse transform calculation */
  Tmp = (double *)malloc(OrigSignalSize*sizeof(double));

  /* GO! */
  WT1DInverse(Tree, Output, Tmp, &Filter, IterNb, OrigSignalSize, WT_Periodisation);

  /* Return the unique result */
  ReturnParam( MOutput );
 
  free(Tmp);
  free(Tree);
 
}

