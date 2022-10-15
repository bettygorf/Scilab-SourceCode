/*------------------------------------------------------------------------
 *    Graphic library for 2D and 3D plotting 
 *   Copyright (C) 1998 Chancelier Jean-Philippe
 *   jpc@cergrene.enpc.fr 
 * Axis drawing for 2d plots 
 *--------------------------------------------------------------------------*/

#include <math.h>
#include <string.h>
#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <stdio.h>
#include "Math.h"


static void Axis  _PARAMS((char pos, double *size, integer axdir, double min, 
			   double max, integer *nax, integer *LDPoint, char logflag));
static void FormatPrec _PARAMS((char *fmt, integer *desres, double xmin, double xmax, 
				double xpas));
static void FormatPrec1 _PARAMS((char *fmt, integer *desres, double *xx, integer nx));
static int Fsepare _PARAMS((char *fmt, integer dec, integer *l, double xmin, double xmax, 
			    double xpas));
static int Fsepare1 _PARAMS((char *fmt, integer dec, integer *l, double *xx, integer nx));

/*--------------------------------------------------------------
 *  aplot: used to draw a box + x and y ticks and scales 
 *  xmin,ymin,xmax,ymax : are the boundary values
 *  xnax and ynax gives the ticks numbers ex: nax=[3,7];
 *  will give 8 big ticks (7 intervals) with numbers and 
 *  each big interval will be divided in 3 small intervals.
 *----------------------------------------------------------------*/

void C2F(aplot)(Box, xmin, ymin, xmax, ymax, xnax, ynax, logflag)
     integer *Box;
     double *xmin;
     double *ymin;
     double *xmax;
     double *ymax;
     integer *xnax;
     integer *ynax;
     char *logflag;
{
  double size[3];
  integer LDPoint[2];
  { 
    C2F(dr)("xrect","v",&Box[0],&Box[1],&Box[2],&Box[3], PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    /** left-down point of the frame box **/
    LDPoint[0]=Box[0];LDPoint[1]=Box[1]+Box[3];
  }
  size[1]=Box[3]/100.0;size[2]=2.0;
  size[0]= ((double ) Box[2])/((double) xnax[0]*xnax[1]);
  Axis('x',size,0L,*xmin,*xmax,xnax,LDPoint,logflag[0]);

  size[1]= -Box[2]/150.0;size[2]=2.0;
  size[0]=((double) Box[3])/ ((double) ynax[0]*ynax[1]);
  Axis('l',size,-90L,*ymin,*ymax,ynax,LDPoint,logflag[1]);
  /** XXX an y right axis **/
  /** LDPoint[0]=Box[0]+Box[2];
      LDPoint[1]=Box[1];
      Axis('r',size,90L,*ymin,*ymax,ynax,LDPoint,logflag[1]);
  **/
}


static void Axis(pos,size, axdir, min, max, nax, LDPoint, logflag)
     char pos;
     double *size;
     integer axdir;
     double min;
     double max;
     integer *nax;
     integer *LDPoint;
     char logflag;
{
  char fornum[100];
  integer flag=0,xx=0,yy=0,posi[2],rect[4],smallersize;
  integer desres,i,barlength,logrect[4];
  integer fontid[2],narg,verbose=0;
  double xp;
  C2F(dr)("xaxis","void",&axdir,nax,PI0,LDPoint, PI0,PI0,size,PD0,PD0,PD0,0L,0L);
  ChoixFormatE(fornum,&desres,min,max,(max-min)/nax[1]);
  xp= min;
  barlength=inint(1.2*(size[1]*size[2]));
  if (logflag == 'l' )
    {
      C2F(dr)("xstringl","10",&xx,&yy,logrect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);	
      C2F(dr)("xget","font",&verbose,fontid,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      smallersize=fontid[1]-2;
      C2F(dr)("xset","font",fontid,&smallersize,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  for (i=0; i <= nax[1];i++)
    { 
      double angle=0.0;
      char foo[100];/*** JPC : must be cleared properly **/
      double lp;
      lp = xp + i*(max-min)/((double)nax[1]);
      sprintf(foo,fornum,desres,lp);
      C2F(dr)("xstringl",foo,&xx,&yy,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if ( axdir == 0 ) 
	{
	  /** xaxis **/
	  posi[0]=inint(LDPoint[0]+ i*nax[0]*size[0]-rect[2]/2.0);
	  posi[1]=inint(LDPoint[1]+ rect[3]+ barlength);
	}
      else if ( axdir == -90 )
	{
	  /** yaxis on the left **/
	  posi[0]=inint(LDPoint[0] - rect[2] +barlength);
	  posi[1]=inint(LDPoint[1] - i*nax[0]*size[0] + rect[3]/4.0);
	}
      else 
	{
	  /** y axis on the right **/
	  posi[0]=inint(LDPoint[0] - barlength);
	  posi[1]=inint(LDPoint[1] - (i-nax[1])*nax[0]*size[0] + rect[3]/4.0);
	}
      C2F(dr)("xstring",foo,&(posi[0]),&(posi[1]),PI0,&flag,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L);
      if ( logflag == 'l' )
	{
	  C2F(dr)("xset","font",fontid,fontid+1,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xstring","10",(posi[0] -= logrect[2],&posi[0]),
		  (posi[1] += logrect[3],&posi[1]),
		  PI0,&flag,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xset","font",fontid,&smallersize,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	}
    }
  if ( logflag == 'l' ) C2F(dr)("xset","font",fontid,fontid+1,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}


/*--------------------------------------------
 * choose a format (fmt) with precision given in desres. 
 * The format is searched so as to give distinct values 
 * for the numeric values xmin + k*xpas in [xmin,xmax] 
 * and give enough precision. 
 *------------------------------------------------*/

void ChoixFormatE(fmt, desres, xmin, xmax, xpas)
     char *fmt;
     integer *desres;
     double xmin;
     double xmax;
     double xpas;
{
  char buf[100];
  integer des,len;
  /* format f minimal  */
  for ( des = 0 ; des < 5 ; des++)
    {
      if (Fsepare("%.*f",des,&len,xmin,xmax,xpas)) break;
    }
  if ( des < 5 && len <= 6)
    {
      strcpy(fmt,"%.*f"); 
      *desres= des;
    }
  else 
    {
      for ( des = 0 ; des < 5 ; des++)
	{
	  sprintf(buf,".%de",(int) des);
	  if (Fsepare("%.*e",des,&len,xmin,xmax,xpas)) break;
	}
      strcpy(fmt,"%.*e"); 
      *desres= des;
    }
  FormatPrec(fmt,desres,xmin,xmax,xpas);
}

/* 
 *  checks if given format gives enough precision 
 *  if not increase it 
 */

static void FormatPrec(fmt, desres, xmin, xmax, xpas)
     char *fmt;
     integer *desres;
     double xmin;
     double xmax;
     double xpas;
{
  char buf1[100],buf2[100];
  integer i=0;
  while ( xmin+((double)i)*xpas < xmax && *desres  < 10 )
    {
      double x1,x2,yy1;
      yy1=xmin+((double) i)*xpas;
      sprintf(buf1,fmt,*desres,yy1);
      sprintf(buf2,fmt,*desres,yy1+xpas );
      sscanf(buf1,"%lf",&x1);
      sscanf(buf2,"%lf",&x2);
      if (  Abs((x2-x1 -xpas) /xpas) >= 0.1)  *desres += 1;
      if (  Abs((x1- yy1)/xpas) >= 0.01) *desres +=1;
      i++;
    }
}

/*----------------------------------------------------------
 *  checks if format fmt gives different values for numbers 
 *  from xmin to xmax with step xpas 
 *  also returns the string length that will result in using the 
 *  format in l 
 *------------------------------------------------------*/

static int Fsepare(fmt, dec, l, xmin, xmax, xpas)
     char *fmt;
     integer dec;
     integer *l;
     double xmin;
     double xmax;
     double xpas;
{
  double x=xmin;
  char buf1[100],buf2[100];
  *l = 0;
  /**  Take care of : sprintf(buf1,"%.*f",0,1.d230) which overflow in buf1 **/
  /**  we don't use %.*f format if numbers are two big **/
  if (strcmp("%.*f",fmt)==0 && (Abs(xmax)> 1.e+10 || Abs(xmin) > 1.e+10))
    return(0);
  sprintf(buf1,fmt,dec,xmin);
  while ( x < xmax ) 
    { x += xpas;
      strcpy(buf2,buf1);
      sprintf(buf1,fmt,dec,x);
      *l = (((int)strlen(buf1) >= *l) ? strlen(buf1) : *l) ;
      if ( strcmp(buf1,buf2) == 0) return(0);
    }
  return(1);
}


/*--------------------------------------------
 * same as ChoixFormatE when numbers are given through an 
 * array xx[0:nx-1];
 *------------------------------------------------*/

void ChoixFormatE1(fmt, desres, xx, nx)
     char *fmt;
     integer *desres;
     double *xx;
     integer nx;
{
  char buf[100];
  integer des,len;
  /* format f minimal  */
  for ( des = 0 ; des < 5 ; des++)
    {
      if (Fsepare1("%.*f",des,&len,xx,nx)) break;
    }
  if ( des < 5 && len <= 6)
    {
      strcpy(fmt,"%.*f"); 
      *desres= des;
    }
  else 
    {
      for ( des = 0 ; des < 5 ; des++)
	{
	  sprintf(buf,".%de",(int) des);
	  if (Fsepare1("%.*e",des,&len,xx,nx)) break;
	}
      strcpy(fmt,"%.*e"); 
      *desres= des;
    }
  FormatPrec1(fmt,desres,xx,nx);
}

static void FormatPrec1(fmt, desres, xx, nx)
     char *fmt;
     integer *desres;
     double *xx;
     integer nx;
{
  char buf1[100],buf2[100];
  double xpas;
  integer i=0;
  while ( i < nx-1 && *desres  < 10 )
    {
      double x1,x2;
      sprintf(buf1,fmt,*desres,xx[i]);
      sprintf(buf2,fmt,*desres,xx[i+1]);
      sscanf(buf1,"%lf",&x1);
      sscanf(buf2,"%lf",&x2);
      xpas = xx[i+1]-xx[i];
      if ( xpas != 0.0)
	{
	  if (Abs((x2-x1 - xpas) /xpas) >= 0.1)  *desres += 1;
	  if (Abs((x1-xx[i])/xpas) >= 0.1) *desres +=1;
	}
      i++;
    }
}

static int Fsepare1(fmt, dec, l, xx, nx)
     char *fmt;
     integer dec;
     integer *l;
     double *xx;
     integer nx;
{
  char buf1[100],buf2[100];
  integer i=0;
  *l = 0;
  /**  Take care of : sprintf(buf1,"%.*f",0,1.d230) which overflow in buf1 **/
  /**  we don't use %.*f format if numbers are two big **/
  if (strcmp("%.*f",fmt)==0 && (Abs(xx[nx-1])> 1.e+10 || Abs(xx[0]) > 1.e+10))
    return(0);
  sprintf(buf1,fmt,dec,xx[0]);
  for ( i=1 ; i < nx ; i++)
    { strcpy(buf2,buf1);
      sprintf(buf1,fmt,dec,xx[i]);
      *l = (((int)strlen(buf1) >= *l) ? strlen(buf1) : *l) ;
      if ( strcmp(buf1,buf2) == 0) return(0);
    }
  return(1);
}










