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

#include "C-LAB_Interf.h"
#include "CWT1D_Convol.h"
#include "CWT1D_DefWavelet.h"
#include "CWT1D_WTransform.h"
#include "CWT1D_Wavelet.h"
#include <math.h>
#include <stdio.h>

#ifndef PI
#define PI 3.1415926515
#endif
#ifndef NULL
#define NULL 0
#endif 

void LAB_cwt()

{
  /* Input */
  Matrix *MSignal;
  double *Signal;
  int TSignal;

  Matrix *MFmin, *MFmax;
  double Fmin, Fmax;

  Matrix *MNscales;
  int Nscales;

  Matrix *MSize;
  double Size;

  /* Output */
  int WTSize;
  
  Matrix *MWT;
  double *WTr;
  double *WTi;

  Matrix *MFreq;
  double *Freq;

  Matrix *MS;
  double *S;

  
  /* Work */
 
  CWT1D_t_Filtre
      *MexHatFilter,
      *MorletFilter;


  CWT1D_t_Ondelette 
      *MexHatWavelet,
      *MorletWavelet;
 
  
  double Smin, 
    Smax;
  
  int i;
  double f,
    f_inc;

  int ech;
  double lSmin,
    lSmax,
    Sinc,
    lS;
 
  
  
  if (Interf.NbParamIn < 4)
    {
      InterfError("cwt : you must give at least 4 input parameters\n");
      return;
    }
 
  if (Interf.NbParamOut > 3)
    {
      InterfError("cwt : you must give at most 3 output parameter\n");
      return;
    }
  

  MSignal = (Matrix *)(Interf.Param[0]);
  MFmin = (Matrix *)(Interf.Param[1]);
  MFmax = (Matrix *)(Interf.Param[2]);
  MNscales = (Matrix *)(Interf.Param[3]);
  
  /* MSize = (Matrix *)(Interf.Param[4]);
     this must not be here: bug correction */
  /* get and verify the input parameters */
  

  /* Signal type */
  if (!(MatrixIsNumeric(MSignal) && MatrixIsReal(MSignal)))
    {
      InterfError("cwt : Input signal must be a real matrix\n");
      return;
    }
  /* Signal dimension */
  TSignal = MAX(MatrixGetWidth(MSignal),MatrixGetHeight(MSignal));
  Signal = MatrixGetPr(MSignal);
  if (MIN(MatrixGetWidth(MSignal),MatrixGetHeight(MSignal)) !=1)
    {
      InterfError("cwt : Input signal must be a one_dimensional matrix\n");
      return;
    }
  
  /* FMin and FMax type */
  if (!(MatrixIsScalar(MFmin) && MatrixIsScalar(MFmax)))
    {
      InterfError("cwt : Fmin and Fmax must be real scalars\n");
      return;
    }
  Fmin = MatrixGetScalar(MFmin);
  Fmax = MatrixGetScalar(MFmax);
  if (!((Fmin>0) && (Fmax>0)))
    {
      InterfError("cwt : Fmin and Fmax must be positive\n");
      return;
    }
  
  if (Fmin>=Fmax) 
    {
      InterfError("cwt : Fmax must be strictly bigger than Fmin\n");
      return;
    }



  
  if (!(MatrixIsScalar(MNscales)))
    {
      InterfError("cwt : Nscales must be a real scalar\n");
      return;
    }
  Nscales = (int)floor(MatrixGetScalar(MNscales));
  if (!(Nscales>0))
    {
      InterfError("cwt : Nscales must be positive\n");
      return;
    }

  if (Interf.NbParamIn>4)
    {
      MSize = (Matrix *)(Interf.Param[4]);
      if (!(MatrixIsScalar(MSize)))
	{
	  InterfError("cwt : Size must be a real scalar\n");
	  return;
	} 
      Size = (double)(MatrixGetScalar(MSize));
      
    }
   else
     {
        Size = 0; 
     }


  


  if (Size == 0) /* The Mex Hat wavelet has been choosen */
    {

      WTSize = CWT1D_Taille_WT(TSignal,Nscales);
      MWT = MatrixCreate(TSignal, Nscales, "real");
      WTr = MatrixGetPr(MWT);

      MexHatFilter = (CWT1D_t_Filtre *)malloc ( sizeof( CWT1D_t_Filtre ) );
      MexHatWavelet = (CWT1D_t_Ondelette *)malloc ( sizeof( CWT1D_t_Ondelette ) );
      
      
      Smin = 1.0;
      Smax = Fmax/Fmin;
      G_sigma = 1/(sqrt(2.0) * PI * Fmax);
      Size = G_sigma*sqrt(2.5*log(300.0));

#undef TEST_SIZE
#ifdef TEST_SIZE
      if ( (Size*Smax>TSignal) || (Size*Smax>LONG_FILTRE) )
	{
	  InterfError("cwt: The maximum scale is too big. Decrease the larger frequency\n");
	  return;
	}
#endif
      
      MexHatWavelet->ValeurReelle = CWT1D_MexHat;
      MexHatWavelet->ValeurComplexe = NULL;
      

      
      MexHatWavelet->xmin = -Size;
      MexHatWavelet->xmax = Size;
      
      
      
      
      CWT1D_WT(
	       Signal,
	       TSignal,
	       WTr,
	       NULL,
	       MexHatWavelet,
	       MexHatFilter,
	       Smin,
	       Smax,
	       Nscales
	       );
      
      free(MexHatWavelet);
      free(MexHatFilter);
      
    }

  else /* Morlet wavelet */
    {

      
      Smin = 1.0;
      Smax = Fmax/Fmin;
      
      if ( (Size*Smax>TSignal) || (Size*Smax>LONG_FILTRE) )
	{
	  InterfError("cwt: The maximum scale is too big. Decrease the wavelet size or the lower frequency.\n");
	  return;
	}
      WTSize = CWT1D_Taille_WT(TSignal,Nscales);
      MWT = MatrixCreate(TSignal, Nscales, "complex");
      WTr = MatrixGetPr(MWT);
      WTi = MatrixGetPi(MWT);
      

      
      
      MorletFilter = (CWT1D_t_Filtre *)malloc ( sizeof( CWT1D_t_Filtre ) );
      MorletWavelet = (CWT1D_t_Ondelette *)malloc ( sizeof( CWT1D_t_Ondelette ) );

      MorletWavelet->ValeurReelle = CWT1D_MorletReel;
      MorletWavelet->ValeurComplexe = CWT1D_MorletComplexe;
      G_sigma = Size/( sqrt(2.0*log(1000.0)) );
      G_Xi0 = Fmax;

      
      MorletWavelet->xmin = -Size;
      MorletWavelet->xmax = Size;
      
      
      
      CWT1D_WT(
	       Signal,
	       TSignal,
	       WTr,
	       WTi,
	       MorletWavelet,
	       MorletFilter,
	       Smin,
	       Smax,
	       Nscales
	       );
      
      free(MorletWavelet);
      free(MorletFilter);
      
    }

   MatrixTranspose(MWT); 
  MFreq = MatrixCreate(1,Nscales,"real");
  Freq = MatrixGetPr(MFreq);

  f_inc = (log(Fmin)-log(Fmax))/(double)(Nscales-1);
  f = log(Fmax);
      
  for (i=0; i<Nscales; i++)
    {
      Freq[i] = exp(f);
      f+=f_inc;
    }
  
  
  MS = MatrixCreate(1,Nscales,"real");
  S = MatrixGetPr(MS);
  
  
  lSmin = log(Smin);
  lSmax = log(Smax);
  Sinc = (lSmax-lSmin)/(double)(Nscales-1);
  lS = lSmin;
  
  for (ech=0; ech<Nscales; ech++)
    {
      S[ech] = exp(lS);
      lS += Sinc;
    }
  
  
  ReturnParam(MWT);
  ReturnParam(MS);
  ReturnParam(MFreq);
}







