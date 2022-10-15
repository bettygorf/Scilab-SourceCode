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

/*
  Alpha Grain base sur des valeurs statistiquement robuste au bruit

  Avec reduction de l'image finale.

  Les arguments sont:
     - la taille du voisinage (N)
     - le tableau pour la regression (X,Y)
	  - unite de distance en X et Y : Ux,Uy

	  - sx/ux,sy/uy est la vrai taille de l'image de SORTIE
*/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>



#include "HOLDER2D_const.h"
#include "HOLDER2D_meascalc.h"






#define IN0  ((TYPIN )0.0)
#define OUT0 ((TYPOUT)0.0)

#define SX (sx)
#define SY (sy)

static TYPOUT  *win=NULL;

#ifndef __STDC__
void InitWin(N, Ux, Uy)
     int N;
     int Ux;
     int Uy;
 {
#else /* __STDC__ */
void InitWin(int N, int Ux, int Uy) {
#endif /* __STDC__ */
		  win = (TYPOUT *)malloc(sizeof(TYPOUT)*(2*N+1)*Ux*(2*N+1)*Uy);
}


/* #define FillWin { for(u=-N*Uy, k=0; u<=N*Uy; u++) for(v=-N*Ux, pos=cur+sx*u; v<=N*Ux; v++,k++) win[k]=(TYPOUT)in[pos+v]; fprintf(stderr,"%d ",k); } */

#define FillWin { for(u=-N*Uy, k=0; u<(N+1)*Uy; u++) for(v=-N*Ux, pos=cur+sx*u; v<(N+1)*Ux; v++,k++) win[k]=(TYPOUT)in[pos+v]; }

#define FillWinG { for(u=-N*Uy, k=0; u<0   ; u++) for(v=-N*Ux, pos=cur+sx*u; v<N*Ux; v++,k++) win[k]=(TYPOUT)in[pos+v]; }
#define FillWinD { for(u=0    , k=0; u<N*Uy; u++) for(v=-N*Ux, pos=cur+sx*u; v<N*Ux; v++,k++) win[k]=(TYPOUT)in[pos+v]; }
#define FillWinH { for(u=-N*Uy, k=0; u<N*Uy; u++) for(v=-N*Ux, pos=cur+sx*u; v<0   ; v++,k++) win[k]=(TYPOUT)in[pos+v]; }
#define FillWinB { for(u=-N*Uy, k=0; u<N*Uy; u++) for(v=0    , pos=cur+sx*u; v<N*Ux; v++,k++) win[k]=(TYPOUT)in[pos+v]; }

#define CalcM1    { m1 =OUT0;   for(u=0;u<size;u++) m1  += win[u];                                                        m1 /=(TYPOUT)size; }
#define CalcM2    { m2 =OUT0;   for(u=0;u<size;u++) m2  += win[u]*win[u];                                                 m2 /=(TYPOUT)size; }
#define CalcM2c   { m2c=OUT0;   for(u=0;u<size;u++) m2c += (win[u] - m1)*(win[u] - m1);                                   m2c/=(TYPOUT)size; }
#define CalcM3    { m3 =OUT0;   for(u=0;u<size;u++) m3  += win[u]*win[u]*win[u];                                          m3 /=(TYPOUT)size; }
#define CalcM3c   { m3c=OUT0;   for(u=0;u<size;u++) m3c += (win[u] - m1)*(win[u] - m1)*(win[u] - m1);                     m3c/=(TYPOUT)size; }
#define CalcM4    { m4 =OUT0;   for(u=0;u<size;u++) m4  += win[u]*win[u]*win[u]*win[u];                                   m4 /=(TYPOUT)size; }
#define CalcM4c   { m4c=OUT0;   for(u=0;u<size;u++) m4c += (win[u] - m1)*(win[u] - m1)*(win[u] - m1)*(win[u] - m1);       m4c/=(TYPOUT)size; }
#define CalcMnp   { mnp=OUT0;   for(u=0;u<size;u++) mnp += (TYPOUT)pow( (double)win[u] , (double)p );                     mnp/=(TYPOUT)size; }
#define CalcTMnp  { mnp=OUT0;   for(u=0;u<size;u++) if (win[u] > OUT0) mnp += (TYPOUT)pow( (double)win[u] , (double)p );  mnp/=(TYPOUT)size; }

#define CalcLM1   { lm1=OUT0;   for(u=0;u<size;u++) if (win[u] > OUT0) lm1  += (TYPOUT)log( (double)win[u] );                         lm1 /=(TYPOUT)size; }
#define CalcLM2   { lm2=OUT0;   for(u=0;u<size;u++) if (win[u] > OUT0) lm2  += (TYPOUT)(log((double)win[u]) * log((double)win[u]));   lm2 /=(TYPOUT)size; }
#define CalcLMp   { lmp=OUT0;   for(u=0;u<size;u++) if (win[u] > OUT0) lmp  += (TYPOUT)pow( log((double)win[u]), (double)p);          lmp /=(TYPOUT)size; }

#define CalcEc    { ec =OUT0;   for(u=0;u<size;u++) ec  += ABS(win[u] - m1);                                              ec /=(TYPOUT)size; }
#define CalcMin   { min=win[0]; for(u=0;u<size;u++) if (win[u]>NEARLYZERO && win[u]<min) min=win[u];                      }
#define CalcMax   { max=win[0]; for(u=0;u<size;u++) if (win[u]>max) max=win[u];                                           } 
#define CalcIso   { count=0;    for(u=0;u<size;u++) if ( ABS(win[u]-m1) < param ) count++;                                   }
#define CalcRIso  { count=0;    for(u=0;u<size;u++) if ( ABS(win[u]-m1) < ect*param ) count++;                               }

#define LOOP1     for (z=((N*Uy)/Py)*sx + (N*Ux)/Px, j=N*Uy; j<= sy - Uy - N*Uy; j+=Py, z+=2*N*Ux/Px )
#define LOOP2     for (i=N*Ux; i<= sx - Ux - N*Ux; i+=Px, z++)

/*----------------------------------------------------------------------
  Alpha Moyenne
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaMoyGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaMoyGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,m1;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
				LOOP2 {
					 cur = i + j*sx;
					 FillWin;
					 CalcM1;
					 out[z] = m1;
				}
		  }
}

/*----------------------------------------------------------------------
  Alpha Variance
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaVarGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaVarGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,m1,m2;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								CalcM2;
								out[z] = m2;
					 }
		  }
}


/*----------------------------------------------------------------------
  Alpha Ecart
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaEcartGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaEcartGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,m1,ec;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								CalcEc;
								out[z] = ec;
					 }
		  }
}




/*----------------------------------------------------------------------
  Alpha Min
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaMinGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaMinGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,min;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcMin;
								out[z] = min;
					 }
		  }
}


/*----------------------------------------------------------------------
  Alpha Max
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaMaxGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaMaxGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,max;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcMax;
								out[z] = max;
					 }
		  }
}


/*----------------------------------------------------------------------
  Alpha Iso
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaIsoGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py, param)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py;
     double param; 
#else /* __STDC__ */
void AlphaIsoGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py, TYPOUT param) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy,count;
		  TYPOUT        mes,m1;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								CalcIso;
								out[z] = (TYPOUT)count / (TYPOUT)size;
					 }
		  }
}

/*----------------------------------------------------------------------
  Alpha Relative Iso
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaRIsoGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py, param)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py;
     double param; 
#else /* __STDC__ */
void AlphaRIsoGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py, TYPOUT param) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy,count;
		  TYPOUT        mes,m1,m2c,ect;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								CalcM2c;
								ect=(TYPOUT)sqrt((double)m2c);
								CalcRIso;
								out[z] = (TYPOUT)count / (TYPOUT)size;
					 }
		  }
}

/*----------------------------------------------------------------------
  Alpha Asymetrie
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaAsymGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaAsymGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,m1,m2,m3;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								CalcM2;
								CalcM3;								
								out[z] = m3 / (TYPOUT)pow( (double)m2 , (double)1.5 );
					 }
		  }
}


/*----------------------------------------------------------------------
  Alpha Aplatissement
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaAplaGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaAplaGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,m1,m2,m4;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								CalcM2;
								CalcM4;								
								out[z] = m4 / (m2*m2) - (TYPOUT)3;
					 }
		  }
}


/*----------------------------------------------------------------------
  Alpha Contrast
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaContGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaContGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,m1,m2;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								CalcM2;
								out[z] = m2/(m1*m1);
					 }
		  }
}

/*----------------------------------------------------------------------
  Alpha LogNorm
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaLognormGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaLognormGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,lm1,m1;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								if (m1 > OUT0) {
										  CalcLM1;
										  out[z] = lm1 - (TYPOUT)log( (double)m1 );
								} else out[z] = OUT0;
					 }
		  }
}

/*----------------------------------------------------------------------
  Alpha VarLog
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaVarlogGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaVarlogGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,lm1,lm2;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
							   CalcLM1;
								CalcLM2;
								out[z] = lm2 - lm1*lm1;
					 }
		  }
}

/*----------------------------------------------------------------------
  Alpha Rho
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaRhoGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaRhoGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,m1,lm1,mg;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								CalcLM1;
								out[z] = m1 / (TYPOUT)exp( (double)lm1 );
					 }
		  }
}

/*----------------------------------------------------------------------
  Alpha Power
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaPowGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py, p)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py;
     double p; 
#else /* __STDC__ */
void AlphaPowGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py, TYPOUT p) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,m1,mnp;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcM1;
								if (m1 > OUT0) {
										  CalcTMnp;
										  out[z] = mnp / (TYPOUT)pow(m1,p);
								} else out[z] = (TYPOUT)1.0;
					 }
		  }
}

/*----------------------------------------------------------------------
  Alpha Log Power
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaLogpowGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py, p)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py;
     double p; 
#else /* __STDC__ */
void AlphaLogpowGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py, TYPOUT p) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(2*N+1)*Ux*(2*N+1)*Uy;
		  TYPOUT        mes,lm1,lmp;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWin;
								CalcLM1;
								CalcLMp;
								out[z] = lmp - (TYPOUT)pow( lm1 , (double)p );
					 }
		  }
}

#ifdef EXEMPLE
/*----------------------------------------------------------------------
  Alpha 
----------------------------------------------------------------------*/
void AlphaGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
{
		  int           i,j,z,pos,cur,
		                size = (2*N+1)*Ux*(2*N+1)*Uy,
		                y0 = N*Uy - Py*(N*Uy/Py),
		                y1 = sy - y0,
		                x0 = N*Ux - Px*(N*Ux/Px),
		                x1 = sx - x0;
		  TYPOUT        mes;
		  register int  u,v,k;
		  
		  /* calcul de l'image des alpha-haut */
		  for (z=y0/Px, j=y0; j<y1; j+=Py, z+=2*y0/Px) {
					 for (i=N; i<SX-N; i+=Px, z++) {
								cur = i + j*sx;
								FillWin;
								out[z] = ;
					 }
		  }
}
#endif


/*----------------------------------------------------------------------
  Alpha de grain frontiere
----------------------------------------------------------------------*/
#ifndef __STDC__
void AlphaFrontMaxGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaFrontMaxGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(N+1)*Ux*2*(N+1)*Uy;
		  TYPOUT        mes,vg,vd,vb,vh,m1;
		  register int  u,v,k;

		  N++;
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWinG; CalcM1; vg = m1;
								FillWinD; CalcM1; vd = m1;
								FillWinH; CalcM1; vh = m1;
								FillWinB; CalcM1; vb = m1;
								out[z] = MAX( MAX( vg/vd, vd/vg) , MAX( vh/vb, vb/vh ) );
					 }
		  }
}

#ifndef __STDC__
void AlphaFrontMinGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaFrontMinGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{
		  int           i,j,z,pos,cur,size=(N+1)*Ux*2*(N+1)*Uy;
		  TYPOUT        mes,vg,vd,vb,vh,m1;
		  register int  u,v,k;

		  N++;
		  /* calcul de l'image des alpha-haut */
		  LOOP1 {
					 LOOP2 {
								cur = i + j*sx;
								FillWinG; CalcM1; vg = m1;
								FillWinD; CalcM1; vd = m1;
								FillWinH; CalcM1; vh = m1;
								FillWinB; CalcM1; vb = m1;
								out[z] = MIN( MIN( vg/vd, vd/vg) , MIN( vh/vb, vb/vh ) );
					 }
		  }
}

/* normalized difference measure */
/* horizontal */
#ifndef __STDC__
void AlphaNormDiffHoriGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaNormDiffHoriGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{		  
	 int           i,j,z,pos,cur,size=(N+1)*Ux*2*(N+1)*Uy;
	 TYPOUT        mes,vg,vd,vb,vh,m1;
	 register int  u,v,k;
	 
	 N++;
	 LOOP1 {
		  LOOP2 {
				cur = i + j*sx;
				FillWinH; CalcM1; vh = m1;
				FillWinB; CalcM1; vb = m1;
				out[z] = ABS( vh - vb ) / ( vh + vb );
		  }
	 }
}

/* vertical */
#ifndef __STDC__
void AlphaNormDiffVertGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaNormDiffVertGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{		  
	 int           i,j,z,pos,cur,size=(N+1)*Ux*2*(N+1)*Uy;
	 TYPOUT        mes,vg,vd,vb,vh,m1;
	 register int  u,v,k;
	 
	 N++;
	 LOOP1 {
		  LOOP2 {
				cur = i + j*sx;
				FillWinG; CalcM1; vg = m1;
				FillWinD; CalcM1; vd = m1;
				out[z] = ABS( vg - vd ) / ( vg + vd );
		  }
	 }
}

/* max */
#ifndef __STDC__
void AlphaNormDiffMaxGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaNormDiffMaxGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{		  
	 int           i,j,z,pos,cur,size=(N+1)*Ux*2*(N+1)*Uy;
	 TYPOUT        mes,vg,vd,vb,vh,m1;
	 register int  u,v,k;
	 
	 N++;
	 LOOP1 {
		  LOOP2 {
				cur = i + j*sx;
				FillWinG; CalcM1; vg = m1;
				FillWinD; CalcM1; vd = m1;
				FillWinH; CalcM1; vh = m1;
				FillWinB; CalcM1; vb = m1;
				out[z] = MAX( ABS( vg - vd ) / ( vg + vd ), ABS( vh - vb ) / ( vh + vb ) );
		  }
	 }
}

/* min */
#ifndef __STDC__
void AlphaNormDiffMinGrain(in, out, sx, sy, res, N, Ux, Uy, Px, Py)
     double *in;
     double *out;
     int sx;
     int sy;
     int res;
     int N;
     int Ux;
     int Uy;
     int Px;
     int Py; 
#else /* __STDC__ */
void AlphaNormDiffMinGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py) 
#endif /* __STDC__ */
{		  
	 int           i,j,z,pos,cur,size=(N+1)*Ux*2*(N+1)*Uy;
	 TYPOUT        mes,vg,vd,vb,vh,m1;
	 register int  u,v,k;
	 
	 N++;
	 LOOP1 {
		  LOOP2 {
				cur = i + j*sx;
				FillWinG; CalcM1; vg = m1;
				FillWinD; CalcM1; vd = m1;
				FillWinH; CalcM1; vh = m1;
				FillWinB; CalcM1; vb = m1;
				out[z] = MIN( ABS( vg - vd ) / ( vg + vd ), ABS( vh - vb ) / ( vh + vb ) );
		  }
	 }
}





