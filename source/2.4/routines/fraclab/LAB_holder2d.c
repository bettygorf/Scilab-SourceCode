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

/* Holder Exponent on 2D matrix (images) */
/* Original code by Pascal Mignot        */
/* Modified and adapted to FracLab       */
/* by Bertrand Guiheneuf (1997)          */

#include "C-LAB_Interf.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
/* #include <strings.h> */
#include "HOLDER2D_const.h"

#define LOG
#undef WITHREF
#define NEAR0 ((double)1e-10)


#include "HOLDER2D_meascalc.h"


#ifndef __STDC__
int GetMes(nmes)
     char *nmes;
 {
#else /* __STDC__ */
int GetMes(char *nmes) {
#endif /* __STDC__ */
	     if (! strcmp(nmes,"sum"     )) return 0;
	else if (! strcmp(nmes,"var"     )) return 1;
	else if (! strcmp(nmes,"ecart"   )) return 2;
	else if (! strcmp(nmes,"min"     )) return 3;
	else if (! strcmp(nmes,"max"     )) return 4;
	else if (! strcmp(nmes,"iso"     )) return 5;
	else if (! strcmp(nmes,"riso"    )) return 6;
	else if (! strcmp(nmes,"asym"    )) return 7;
	else if (! strcmp(nmes,"aplat"   )) return 8;
	else if (! strcmp(nmes,"contrast")) return 9;
	else if (! strcmp(nmes,"lognorm" )) return 10;
	else if (! strcmp(nmes,"varlog"  )) return 11;
	else if (! strcmp(nmes,"rho"     )) return 12;
	else if (! strcmp(nmes,"pow"     )) return 13;
	else if (! strcmp(nmes,"logpow"  )) return 14;
	else if (! strcmp(nmes,"frontmax")) return 15;
	else if (! strcmp(nmes,"frontmin")) return 16;
	else if (! strcmp(nmes,"diffh"   )) return 17;
	else if (! strcmp(nmes,"diffv"   )) return 18;
	else if (! strcmp(nmes,"diffmin" )) return 19;
	else if (! strcmp(nmes,"diffmax" )) return 20;
	else return -1;
}

void LAB_holder2d()
{


  Matrix *Min; /* Input Image */
  double *in;

  Matrix *MMeas; /* Measure */
  char *MeasName;
  int MeasNum;

  Matrix *Mres; /* number of resolutions */
  int res;

  Matrix *Mref; /* Input reference Image */
  double *ref; 

  Matrix *MMeasRef; /* reference Measure */
  char *MeasRefName;
  int MeasRefNum;


  Matrix *MHolderOut; /* Holder exponents output image */
  double *HolderOut;

  /* images */

  double       **out,**outr;
  int         sx,sy,i,sxr,syr;
  
  /* argument */
  int    ux,uy,mes,mref,px,py;
  double  param;

  char WithRef;







/* "in" is the array containing the input image 
   "ref" is the array containing the reference image 
   
   the inpput image and the reference image must be the 
   same size 

   "mes" is a integer containing the measure number 
   */


  /* default values for the parameters */

  ux=1; /* scale unit in x */
  uy=1; /* scale unit in y */
  px=1; /* sampling step of the output in x */
  py=1; /* sampling step of the output in y */
  param=(double)2.0;
  /* param is necessary for certain measures, not implemented
     yet */
  
  
  if (Interf.NbParamIn < 1)
    {
      InterfError("holder2d : You must at least specify a matrix to analyse\n");
      return;
    }
    
  /****************************************************************/
  /* first parameter : Input matrix */
  Min=(Matrix *)(Interf.Param[0]);
  
  if (!(MatrixIsNumeric(Min) && MatrixIsReal(Min)))
    {
      InterfError("holder2d : Input signal must be a real matrix\n");
      return;
    }
  in=MatrixGetPr(Min);
  sx=(int)MatrixGetWidth(Min);
  sy=(int)MatrixGetHeight(Min);
  /* We have to take the matrix dimensions before
     the transposition, because transpostion is here
     only to store the matrix in a C-style fashion */ 
  MatrixTranspose(Min);
  /* this is only cause we use C-routines 
     we will transpose the return matrix back */




  /****************************************************************/
  if (Interf.NbParamIn > 1)
    {
      /**********************************/
      /* second parameter : measure     */
      MMeas=(Matrix *)(Interf.Param[1]);
      
      if (!(MatrixIsString(MMeas)) )
	{
	  InterfError("holder2d : The second parameter is the measure, it must be a string\n");
	  return;
	}
      MeasName = (char *)MatrixReadString(MMeas);
      /* the memory for the string is allocated in MatrixreadString */
      MeasNum = GetMes( MeasName );
      free(MeasName);
      /* we don't need trhe measure name anymore, so let's free it */
      
      if (MeasNum==-1)
	{
	  InterfError("holder2d : The measure name is not valid\n");
	  return;
	}

      mes=MeasNum;
    }
  else 
    mes=0; /* default measure : sum */




  /****************************************************************/
  if (Interf.NbParamIn > 2)
    {
      Mres =  (Matrix *)(Interf.Param[2]);
      if (!(MatrixIsScalar(Mres)) )
	{
	  InterfError("holder2d : The third parameter is the number of resolutions. It must be a real scalar\n");
	  return;
	}
      res = (int)MatrixGetScalar(Mres);
    }
  else
    res=1;

  /****************************************************************/
  if (Interf.NbParamIn > 3)
    {
      WithRef = 1;
      Mref=(Matrix *)(Interf.Param[3]);
  
  if (!(MatrixIsNumeric(Mref) && MatrixIsReal(Mref)))
    {
      InterfError("holder2d : Input Reference image  must be a real matrix\n");
      return;
    }
  ref=MatrixGetPr(Mref);

  if ( ( sx!=(int)MatrixGetWidth(Mref)) || ( sy!=(int)MatrixGetHeight(Mref)) )
    {
      InterfError("holder2d : Input Reference image and input image must have the same dimensions\n");
      return;
    }

  
  MatrixTranspose(Mref);
  /* this is only cause we use C-routines 
     we will transpose the return matrix back */
  
  
    }
  else
    WithRef = 0; /* no reference image */
  



  /****************************************************************/
  if (Interf.NbParamIn > 4)
    {
      /**********************************/
      /* second parameter : measure     */
      MMeasRef=(Matrix *)(Interf.Param[4]);
      
      if (!(MatrixIsString(MMeasRef)) )
	{
	  InterfError("holder2d : The fifth parameter is the ref.measure, it must be a string\n");
	  return;
	}
      MeasRefName = (char *)MatrixReadString(MMeasRef);
      /* the memory for the string is allocated in MatrixreadString */
      MeasRefNum = GetMes( MeasRefName );
      free(MeasRefName);
      /* we don't need trhe measure name anymore, so let's free it */
      
      if (MeasRefNum==-1)
	{
	  InterfError("holder2d : The reference measure name is not valid\n");
	  return;
	}

      mref=MeasRefNum;
    }
  else 
    mref=0; /* default reference measure: sum */





  /********************************************************/
  /*     This is the real computation routine             */
  /********************************************************/

#define SX (sx/px)
#define SY (sy/py)



  /* used pointer:
     "out" is an array on the different resolution
     its last element poins on the Holder exponent
     after the regression
     
     "outr" in the case of a specified reference image, 
     outr is the same as "out", but on the ref. image
     it has one resolution less as the holder exp.
     are stored only in "out".

     "win" is a global (!) variable which memory
     is allocated by InitWin

     "x" is used in the regression routines.
     */

  /* reservation memoire */
  out = (double **)calloc(res+2         ,sizeof(double *));
  out[0]=(double *)calloc(SX*SY*(res+2) ,sizeof(double));

  for(i=1;i<res+2;i++) out[i] = out[i-1] + SX*SY;

  if (WithRef==1)
    {
      /* seulement res+1 car une seule image de resultat dans out[res+1] */
      outr = (double **)calloc(res+1        , sizeof(double *));
      outr[0]=(double *)calloc(SX*SY*(res+1), sizeof(double));
      /* memset(outr[0],0,SX*SY*(res+1)*sizeof(double)); */
      for(i=1;i<res+1;i++) outr[i] = outr[i-1] + SX*SY;
  }


  InitWin(res,ux,uy); /* initialisation de la taille locale */

  /* on calcule a toutes les resolutions */
  for(i=0;i<=res;i++) {
	  
	  switch(mes) {
	  case 0:   AlphaMoyGrain    (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 1:   AlphaVarGrain    (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 2:   AlphaEcartGrain  (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 3:   AlphaMinGrain    (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 4:   AlphaMaxGrain    (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 5:   AlphaIsoGrain    (in,out[i],sx,sy,res,i,ux,uy,px,py,param);   break;
	  case 6:   AlphaRIsoGrain   (in,out[i],sx,sy,res,i,ux,uy,px,py,param);   break;
	  case 7:   AlphaAsymGrain   (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 8:   AlphaAplaGrain   (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 9:   AlphaContGrain   (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 10:  AlphaLognormGrain(in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 11:  AlphaVarlogGrain (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 12:  AlphaRhoGrain    (in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 13:  AlphaPowGrain    (in,out[i],sx,sy,res,i,ux,uy,px,py,param);   break;
	  case 14:  AlphaLogpowGrain (in,out[i],sx,sy,res,i,ux,uy,px,py,param);   break;
	  case 15: AlphaFrontMaxGrain(in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 16: AlphaFrontMinGrain(in,out[i],sx,sy,res,i,ux,uy,px,py);         break;
	  case 17: AlphaNormDiffHoriGrain(in,out[i],sx,sy,res,i,ux,uy,px,py);     break;
	  case 18: AlphaNormDiffVertGrain(in,out[i],sx,sy,res,i,ux,uy,px,py);     break;
	  case 19: AlphaNormDiffMinGrain(in,out[i],sx,sy,res,i,ux,uy,px,py);      break;
	  case 20: AlphaNormDiffMaxGrain(in,out[i],sx,sy,res,i,ux,uy,px,py);      break;
	  }
  }


  if (WithRef==1)
    {
	  
	  for(i=0;i<=res;i++) {
		  
		  switch(mref) {
		  case 0:   AlphaMoyGrain    (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 1:   AlphaVarGrain    (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 2:   AlphaEcartGrain  (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 3:   AlphaMinGrain    (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 4:   AlphaMaxGrain    (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 5:   AlphaIsoGrain    (ref,outr[i],sx,sy,res,i,ux,uy,px,py,param);   break;
		  case 6:   AlphaRIsoGrain   (ref,outr[i],sx,sy,res,i,ux,uy,px,py,param);   break;
		  case 7:   AlphaAsymGrain   (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 8:   AlphaAplaGrain   (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 9:   AlphaContGrain   (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 10:  AlphaLognormGrain(ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 11:  AlphaVarlogGrain (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 12:  AlphaRhoGrain    (ref,outr[i],sx,sy,res,i,ux,uy,px,py);         break;
		  case 13:  AlphaPowGrain    (ref,outr[i],sx,sy,res,i,ux,uy,px,py,param);   break;
		  case 14:  AlphaLogpowGrain (ref,outr[i],sx,sy,res,i,ux,uy,px,py,param);   break;
		  case 15:  AlphaFrontMaxGrain(ref,outr[i],sx,sy,res,i,ux,uy,px,py);        break;
		  case 16:  AlphaFrontMinGrain(ref,outr[i],sx,sy,res,i,ux,uy,px,py);        break;
		  case 17:  AlphaNormDiffHoriGrain(ref,outr[i],sx,sy,res,i,ux,uy,px,py);    break;
		  case 18:  AlphaNormDiffVertGrain(ref,outr[i],sx,sy,res,i,ux,uy,px,py);    break;
		  case 19:  AlphaNormDiffMinGrain(ref,outr[i],sx,sy,res,i,ux,uy,px,py);     break;
		  case 20:  AlphaNormDiffMaxGrain(ref,outr[i],sx,sy,res,i,ux,uy,px,py);     break;

		  }
	  }
	  
    }





  /* estimation de l'exposant de Holder 
     (moindre carre)
   */
  
  {
    double mx,my,var,cov,*x;
    int   i,u,v,k;
    
    if (WithRef==0)
      {
	
#ifdef LOG
	x = (double *)malloc( sizeof(double) * (res+1) );
	mx=(double)0.0;
	for(i=0;i<=res;i++) {
	  x[i]=(double)log( (double)(2*i*MIN(ux,uy)+1) );
	  mx+=x[i];
	}
	mx /= (double)(res+1);
	var=(double)0.0;
	for(i=0;i<=res;i++)
		    var += (x[i]-mx)*(x[i]-mx);
	var /= (double)(res+1);
	
	/* le reste change en chaque point de l'image */
	for(k=0;k<SX*SY;k++) {
	  if (out[0][k] > NEAR0 && out[res][k] > NEAR0) {
	    my=(double)0.0;
	    for(i=0;i<=res;i++) {
	      /* my+=(double)log( (double)out[i][k] ); */
	      my += (double)log( (double)out[i][k] );
	    }
	    my /= (double)(res+1);
	    cov=(double)0.0;
	    for(i=0;i<=res;i++) {
	      cov += (x[i]-mx)*((double)log( (double)out[i][k] ) - my);
	    }
	    cov/=(double)(res+1);
	    out[res+1][k]=cov/var;	  
	  } else out[res+1][k]=(double)0.0;
	}
#else
	x = (double *)malloc( sizeof(double) * (res+1) );
	mx=(double)0.0;
	for(i=0;i<=res;i++) {
	  x[i]=2*i*MIN(ux,uy)+1;
	  mx+=x[i];
	}
	mx /= (double)(res+1);
	var=(double)0.0;
	for(i=0;i<=res;i++)
		    var += (x[i]-mx)*(x[i]-mx);
	var /= (double)(res+1);
	
	/* le reste change en chaque point de l'image */
	for(k=0;k<SX*SY;k++) {
	  /* calcul de la variance et de la covariance */
	  my=(double)0.0;
	  for(i=0;i<=res;i++) my += out[i][k];
	  my /= (double)(res+1);
	  cov=(double)0.0;
	  for(i=0;i<=res;i++) cov += (x[i]-mx)*(out[i][k]-my);
	  cov/=(double)(res+1);
	  /* pente */
	  out[res+1][k]=cov/var;
	}
#endif
      }
    else
      { /* there is a reference image */

#ifdef LOG
	for(k=0;k<SX*SY;k++) {
	  if (out[0][k]>NEAR0 && outr[0][k]>NEAR0) { 
	    mx=(double)0.0;
	    my=(double)0.0;
	    for(i=0;i<=res;i++) {
	      mx += (double)log( (double)outr[i][k] );
	      my += (double)log( (double)out[i][k] );
	    }
	    mx /= (double)(res+1);
	    my /= (double)(res+1);
	    var=(double)0.0;
	    cov=(double)0.0;
	    for(i=0;i<=res;i++) {
	      var += ((double)log( (double)outr[i][k] ) - mx)*((double)log( (double)outr[i][k] ) - mx);
	      cov += ((double)log( (double)outr[i][k] ) - mx)*((double)log( (double)out[i][k] ) - my);
	    }
	    var/=(double)(res+1);
	    cov/=(double)(res+1);
	    if (var>NEAR0) out[res+1][k]=cov/var;
	    else out[res+1][k]=(double)0.0;
	  } else out[res+1][k]=(double)0.0;
	    }
#else
	for(k=0;k<SX*SY;k++) {
	  mx=(double)0.0;
	  my=(double)0.0;
	  for(i=0;i<=res;i++) {
	    mx += (double)outr[i][k];
	    my += (double)out[i][k];
	  }
	  mx /= (double)(res+1);
	  my /= (double)(res+1);
	  var=(double)0.0;
	  cov=(double)0.0;
	  for(i=0;i<=res;i++) {
	    var += (outr[i][k] - mx)*(outr[i][k] - mx);
	    cov += (outr[i][k] - mx)*(out[i][k]  - my);
	  }
	  var/=(double)(res+1);
	  cov/=(double)(res+1);
	  if (var>NEAR0) out[res+1][k]=cov/var;
	  else out[res+1][k]=(double)0.0;
	}
#endif /* LOG */
      }

    free(x);
  }
  
  
  /**************************************************/
  /*      End of the computation routine            */
  /**************************************************/









  MHolderOut = MatrixCreate(SX,SY,"real");
  /* BE CAREFUL, the dimension are given here
     in the wrong order, but it anticipates
     the transposition below */

  HolderOut = MatrixGetPr(MHolderOut);

  memcpy(HolderOut, out[res+1], (SX)*(SY)*sizeof(double));

  MatrixTranspose(MHolderOut);
  MatrixTranspose(Min);
  /* now the matrix dimensions are correct */

  ReturnParam(MHolderOut);


  if (WithRef==1)
    {
      free(outr[0]);
      free(outr);
    }
  free(out[0]);
  free(out);


}







