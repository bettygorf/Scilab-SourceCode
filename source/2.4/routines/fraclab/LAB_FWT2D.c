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
#include "WT2D_filters.h"
#include "WT2D_arbre.h"
#include "WT2D_mem.h"
#include "WT2D_wavelet_transform.h"
#include "WT2D_const.h"
#include <math.h>


void LAB_FWT2D()

{
  
  double *Input; /* the input signal */
  Matrix *MInput; /* the matrix of the input signal */
  int InputSize;
  int InputWidth;
  int InputHeight;

  int IterNb; /* Number of levels in the decomposition */
  double *MIterNb; /* and the matrix pointing on it */
  
  double *QMF; /* the QMF */
  double *MQMF; /* and the matrix on it */
  int QMFSize;
  
  double *QMF2; /* the reconstruction QMF */
  double *MQMF2; /* and the matrix on it */
  int QMF2Size;



  t_filtre_WT2D Filter; /* the LowPass filter of the decomposition */

  t_arbreWT2D *Tree; /* the coefficients tree */

  int WTOutputSize; /* the number of coeff. */
  Matrix *MWT; /* the matrix for the WT coeff. */
  double *WT; /* The whole WT output data */
  double *WT_DATA; /* .. and a pointer to the coeff. */
  
  double *Tmp1; /* The temp. arrays */
  double *Tmp2; 

  Matrix *MScIndex; /* The matrix to return the scale indexes */
  double *ScIndex; /* and the indexes */

  Matrix *MScLength; /* The matrix to return the scales arrays lengths */
  double *ScLength;  /* .. ad the lengths */
    


  char retour[100];
  int i; /* counters */
  int j;
  double CurrIndex; /* to store rhe current coeff. index */






  if (Interf.NbParamIn < 3) /* Verify the number of input parameters */ 
    {
      InterfError("FWT2D : You must give at least 3 input arguments\n");
      return;
    }

  if (Interf.NbParamIn > 4) /* Verify the number of input parameters */ 
    {
      InterfError("FWT2D : You must give at most 4 input arguments\n");
      return;
    }
  
  if (Interf.NbParamOut > 3) /* Verify the number of output parameters */ 
    {
      InterfError("FWT2D : You must give at most 4 output arguments\n");
      return;
    }
  
  
  

  
  

  /* Get the input signal and verify it */
  MInput = Interf.Param[0];

  if (!MatrixIsNumeric(MInput) || !MatrixIsReal(MInput) )
    {
      InterfError("FWT2D: The input signal must be a real matrix\n");
      return;
    }


    
  InputWidth = MatrixGetWidth(MInput);
  InputHeight = MatrixGetHeight(MInput);
  

  InputSize = InputWidth * InputHeight;
  Input = MatrixGetPr(MInput);


  /* Get the decomposition level and verify it */
  MIterNb = Interf.Param[1];
  if (!MatrixIsScalar(MIterNb))
    {
      InterfError("FWT2D : The Number of decomposition levels must be a real scalar\n");
      return;
    }
  IterNb = (int)floor(MatrixGetScalar(MIterNb));
  
  if (IterNb<1)
    {
      InterfError("FWT2D : The Number of decomposition mevels must be >=1\n");
      return;
    }


  /* Get the QMF and verify it */
  MQMF = Interf.Param[2];

  if (!MatrixIsNumeric(MQMF) || !MatrixIsReal(MQMF) )
    {
      InterfError("FWT2D : The QMF must be a real matrix\n");
      return;
    }

  if ( MIN(MatrixGetWidth(MQMF),MatrixGetHeight(MQMF)) != 1 )
    {
      InterfError("FWT2D : The QMF must be a (1xN) or (Nx1) matrix\n");
      return;
    }
  
  QMFSize = MAX(MatrixGetWidth(MQMF),MatrixGetHeight(MQMF));
  QMF = MatrixGetPr(MQMF);


  /* if it exists GetWT = FWT(y,n,qmf); the second QMF and verify it */
  if (Interf.NbParamIn == 4 )
    {
      MQMF2 = Interf.Param[3];
      
      if (!MatrixIsNumeric(MQMF2) || !MatrixIsReal(MQMF2) )
	{
	  InterfError("FWT2D : The 2nd QMF must be a real matrix\n");
	  return;
	}
      
      if ( MIN(MatrixGetWidth(MQMF2),MatrixGetHeight(MQMF2)) != 1 )
	{
	  InterfError("FWT2D  : The 2nd QMF must be a (1xN) or (Nx1) matrix\n");
	  return;
	}
      
      QMF2Size = MAX(MatrixGetWidth(MQMF2),MatrixGetHeight(MQMF2));
      QMF2 = MatrixGetPr(MQMF2);
    }
  else
    {
      MQMF2 = MQMF;
      QMF2 = QMF;
      QMF2Size = QMFSize;
    }

  /* Now, let's copy the QMF in Filter */
  Filter.taille_neg = (int)floor(QMF[0]); /* Filter left size */
  Filter.taille_pos = (int)floor(QMF[1]); /* Filter right size */
  Filter.taille = 1+ Filter.taille_pos + Filter.taille_neg; /* Filter size */

  if (Filter.taille != (QMFSize-2)) 
    {
      InterfError("FWT2D : The QMF is not defined correctly. \nIts size doesn't fit the first two parameters.");
      return;
    }
	


  for (i=0; i<Filter.taille; i++)
    Filter.valeur[i]=QMF[i+2]; /* copies the QMF coeff. in Filter */

 



  /* And let's prepare the output */
  Tree = (t_arbreWT2D *) malloc( IterNb * sizeof(t_arbreWT2D) );
  /* We just have the memory for the tree structure, not for the coeff. */

  WTOutputSize = siz_tab_sortieWT2D(InputWidth, InputHeight, IterNb);

  /* we will return the WT but also th signal size, the number of levels */
  /* and the reconstruction filter */
  MWT = MatrixCreate(1,WTOutputSize + 3 + QMF2Size  ,"real");

  WT = MatrixGetPr( MWT ); 
  
  /* printf("-> InputSize=%d | QMF2SIZE=%d | WTOutputSize=%d \n",InputSize, QMF2Size,WTOutputSize); */
  WT_DATA = WT + 3 + QMF2Size; /* Pointer on the coeff begining */
  /*printf("Debut WT=%p, Fin WT=%p, Debut WT_DATA=%p\n",WT, WT+WTOutputSize + 2 + QMF2Size, WT_DATA);*/
  /* Prepare the output */
  WT[0] = (double)InputHeight;
  WT[1] = (double)InputWidth;
  WT[2] = (double)IterNb;
  for (i=0; i<QMF2Size; i++)
    WT[i+3] = QMF2[i];

  Tmp1 = (double *)malloc( InputSize* sizeof(double) );
  Tmp2 = (double *)malloc( InputSize* sizeof(double) );
  
  /* WT2D(Tree, Input, WT_DATA, Tmp1, Tmp2, &Filter, IterNb, InputWidth, InputHeight, &WT2D_Periodisation); */
  /* to avoid transposition */
  WT2D(Tree, Input, WT_DATA, Tmp1, Tmp2, &Filter, IterNb, InputHeight, InputWidth, WT2D_Periodisation);

  free(Tmp2);
  free(Tmp1);
  
  /* OK, now let's return the main thing : The Wavelet Transform */
  ReturnParam(MWT);

  /* create the other return parameters */
  MScIndex = MatrixCreate(IterNb,4,"real"); /* the index of the first */
  ScIndex = MatrixGetPr( MScIndex ); /* elements of each scale */

  MScLength = MatrixCreate(IterNb,2,"real"); /* The length of each scale */
  ScLength = MatrixGetPr( MScLength );

  CurrIndex = 4 + QMF2Size;
  /* the Wj projections */
  for (i=0; i<IterNb; i++)
    {
      for (j=0; j<3; j++)
	{
	  ScIndex[j*IterNb+i] =  CurrIndex ; /* HG GG GH (HH) */
	  CurrIndex += (double)( Tree[i].taille );
	  
	}
      ScIndex[j*IterNb+i] = 0;
      /*
      ScLength[0*IterNb+i] = (double)( Tree[i].tailleY );
      ScLength[1*IterNb+i] = (double)( Tree[i].tailleX );*/
      /* to avoid transpose */
      ScLength[0*IterNb+i] = (double)( Tree[i].tailleX );
      ScLength[1*IterNb+i] = (double)( Tree[i].tailleY );
      
      
    }
  
  /* Last HH is non-void */
  ScIndex[3*IterNb+i-1] = CurrIndex; /* HG GG GH (HH) */
  
  ReturnParam(MScIndex);
  ReturnParam(MScLength);

  free(Tree);
  


}


