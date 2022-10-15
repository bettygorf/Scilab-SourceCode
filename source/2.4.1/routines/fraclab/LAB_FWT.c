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





/************  LAB_FWT  ***************************************************/
/* routine to call to compute the Forward 1D Discrete Wavelet               */
/* transform of a 1D signal                                                 */
/* Usage [Dwt, DwtScale, DwtScLgth] =                                       */
/*    FWT(Input, J, LowFilter {, 2LowFilter})                               */
/* Where :                                                                  */
/*                                                                          */
/*  -Dwt is the variable that will contain the coefficients                 */
/*    of the decomposition plus other informations                          */
/*  -DwtScale is the Index of the first element of each scale               */
/*  -DwtScLgth is the length of the decomposition at each scale             */
/*                                                                          */
/*  -Input is the signal to decompose. It's a 1xN or Nx1 real               */
/*    numeric matrix                                                        */
/*  -J is the number of scales to compute                                   */
/*  -LowFilter is the Low-Pass filter of the pyramidal decomposition        */
/*  -2LowFilter is the reconstruction Low-Pass filter. It's used only for   */
/*    biotrhogonal transform. If not precised, the LowFilter is used        */
/*    as the reconstruction filter                                          */
/*                                                                          */
/*               Bertrand Guiheneuf 1996                                    */
void LAB_FWT()

{
  
  double *Input; /* the input signal */
  Matrix *MInput; /* the matrix of the input signal */
  int InputSize;

  int IterNb; /* Number of levels in the decomposition */
  double *MIterNb; /* and the matrix pointing on it */
  
  double *QMF; /* the QMF */
  double *MQMF; /* and the matrix on it */
  int QMFSize;
  
  double *QMF2; /* the reconstruction QMF */
  double *MQMF2; /* and the matrix on it */
  int QMF2Size;



  t_filtre Filter; /* the LowPass filter of the decomposition */

  t_arbreWT *Tree; /* the coefficients tree */

  int WTOutputSize; /* the number of coeff. */
  Matrix *MWT; /* the matrix for the WT coeff. */
  double *WT; /* The whole WT output data */
  double *WT_DATA; /* .. and a pointer to the coeff. */
  
  double *Tmp; /* The temp. array */

  Matrix *MScIndex; /* The matrix to return the scale indexes */
  double *ScIndex; /* and the indexes */

  Matrix *MScLength; /* The matrix to return the scales arrays lengths */
  double *ScLength;  /* .. ad the lengths */
    


  char retour[100];
  int i; /* counter */
  double CurrIndex; /* to store rhe current coeff. index */






  if (Interf.NbParamIn < 3) /* Verify the number of input parameters */ 
    {
      InterfError("DWT : You must give at least 3 input arguments\n");
      return;
    }

  if (Interf.NbParamIn > 4) /* Verify the number of input parameters */ 
    {
      InterfError("DWT : You must give at most 4 input arguments\n");
      return;
    }
  
  
  

  
  

  /* Get the input signal and verify it */
  MInput = Interf.Param[0];

  if (!MatrixIsNumeric(MInput) || !MatrixIsReal(MInput) )
    {
      InterfError("DWT: The input signal must be a real matrix\n");
      return;
    }

  if ( MIN(MatrixGetWidth(MInput),MatrixGetHeight(MInput)) != 1 )
    {
      InterfError("DWT : The input signal must be a (1xN) or (Nx1) matrix\n");
      return;
    }
    
  InputSize = MAX(MatrixGetWidth(MInput),MatrixGetHeight(MInput));
  Input = MatrixGetPr(MInput);


  /* Get the decomposition level and verify it */
  MIterNb = Interf.Param[1];
  if (!MatrixIsScalar(MIterNb))
    {
      InterfError("DWT : The Number of decomposition levels must be a real scalar\n");
      return;
    }
  IterNb = (int)floor(MatrixGetScalar(MIterNb));
  
  if (IterNb<1)
    {
      InterfError("DWT : The Number of decomposition mevels must be >=1\n");
      return;
    }


  /* Get the QMF and verify it */
  MQMF = Interf.Param[2];

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


  /* if it exists GetWT = FWT(y,n,qmf); the second QMF and verify it */
  if (Interf.NbParamIn == 4 )
    {
      MQMF2 = Interf.Param[3];
      
      if (!MatrixIsNumeric(MQMF2) || !MatrixIsReal(MQMF2) )
	{
	  InterfError("DWT: The 2nd QMF must be a real matrix\n");
	  return;
	}
      
      if ( MIN(MatrixGetWidth(MQMF2),MatrixGetHeight(MQMF2)) != 1 )
	{
	  InterfError("DWT : The 2nd QMF must be a (1xN) or (Nx1) matrix\n");
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
      InterfError("The QMF is not defined correctly. Its size doesn't fit the first two parameters.");
      return;
    }
	


  for (i=0; i<Filter.taille; i++)
    Filter.valeur[i]=QMF[i+2]; /* copies the QMF coeff. in Filter */

 

  /* And let's prepare the output */
  /* Tree = (t_arbreWT *) malloc( IterNb * sizeof(t_arbreWT) ); */
   Tree = (t_arbreWT *) malloc( IterNb * sizeof(t_arbreWT) );
  /* We just have the memory for the tree structure, not for the coeff. */

  WTOutputSize = siz_tab_sortie(InputSize, IterNb);

  /* we will return the WT but also th signal size, the number of levels */
  /* and the reconstruction filter */
  MWT = MatrixCreate(1,WTOutputSize + 2 + QMF2Size  ,"real");

  WT = MatrixGetPr( MWT ); 
  
  /* printf("-> InputSize=%d | QMF2SIZE=%d | WTOutputSize=%d \n",InputSize, QMF2Size,WTOutputSize); */
  WT_DATA = WT + 2 + QMF2Size; /* Pointer on the coeff begining */
  /*printf("Debut WT=%p, Fin WT=%p, Debut WT_DATA=%p\n",WT, WT+WTOutputSize + 2 + QMF2Size, WT_DATA);*/
  /* Prepare the output */
  WT[0] = (double)InputSize;
  WT[1] = (double)IterNb;
  for (i=0; i<QMF2Size; i++)
    WT[i+2] = QMF2[i];

  /* Tmp = (double *)malloc( InputSize * sizeof(double) );  */
  /* Tmp = (double *)malloc( (2 * WTOutputSize  )* sizeof(double) );*/
  Tmp = (double *)malloc( (2 * WTOutputSize  )* sizeof(double) );
  /* printf("Debut TMP:%p, Fin TMP:%p\n", Tmp, Tmp+(2 * WTOutputSize  )); */
  
  
  WT1D(Tree, Input, WT_DATA, Tmp, &Filter, IterNb, InputSize,WT_Periodisation);
 
  /*printf("TMP: %p\n",Tmp);*/
  free(Tmp);
  
  /* OK, now let's return the main thing : The Wavelet Transform */
  ReturnParam(MWT);

  /* create the other return parameters */
  MScIndex = MatrixCreate(1,IterNb+1,"real"); /* the index of the first */
  ScIndex = MatrixGetPr( MScIndex ); /* elements of each scale */

  MScLength = MatrixCreate(1,IterNb+1,"real"); /* The length of each scale */
  ScLength = MatrixGetPr( MScLength );

  CurrIndex = 3 + QMF2Size;
  /* the Wj projections */
  for (i=0; i<IterNb; i++)
    {
      ScIndex[i] = CurrIndex;
      CurrIndex += (double)( Tree[i].taille );
      ScLength[i] = (double)( Tree[i].taille );
    }
  
  /* the last Vj projection */
  ScIndex[i] = CurrIndex;
  ScLength[i] = (double)( Tree[i-1].taille );

  ReturnParam(MScIndex);
  ReturnParam(MScLength);

  free(Tree);
  


}


