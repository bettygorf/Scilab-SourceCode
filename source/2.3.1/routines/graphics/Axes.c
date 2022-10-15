/*------------------------------------------------------------------------
    Missile 
    XWindow and Postscript library for 2D and 3D plotting 
    Copyright (C) 1990 Chancelier Jean-Philippe

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 1, or (at your option)
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

    jpc@arletty.enpc.fr 
    Phone : 43.04.40.98 poste : 3327 

--------------------------------------------------------------------------*/
#include <math.h>
#include <string.h>
#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <stdio.h>
#include "Math.h"

static void Axis();
static void FormatPrec();
static void FormatPrec1();
static int Fsepare();
static int Fsepare1();

/*--------------------------------------------------------------
//  to draw 
//  A box + x and y axes + numbers along the axes
//  xmin,ymin,xmax,ymax : are the boundary values
//  xnax=[3,7];
//     on the x axis we'll have 7 big intervals with a number 
//     to describe them ans each of this big intervals will be 
//     divided in 3 intervals.
----------------------------------------------------------------*/

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
    /** left-down pointeger of the frame box **/
    LDPoint[0]=Box[0];LDPoint[1]=Box[1]+Box[3];
  }
  size[1]=Box[3]/100.0;size[2]=2.0;
  size[0]= ((double ) Box[2])/((double) xnax[0]*xnax[1]);
  Axis(size,0L,*xmin,*xmax,xnax,LDPoint,logflag[0]);
  size[1]= -Box[2]/150.0;size[2]=2.0;
  size[0]=((double) Box[3])/ ((double) ynax[0]*ynax[1]);
  Axis(size,-90L,*ymin,*ymax,ynax,LDPoint,logflag[1]);
}

static void Axis(size, axdir, min, max, nax, LDPoint, logflag)
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
    { double angle=0.0;
      char foo[100];/*** JPC : must be cleared properly **/
      double lp;
      lp = xp + i*(max-min)/((double)nax[1]);
      sprintf(foo,fornum,desres,lp);
      C2F(dr)("xstringl",foo,&xx,&yy,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if ( axdir == 0 ) 
	{
	  posi[0]=inint(LDPoint[0]+ i*nax[0]*size[0]-rect[2]/2.0);
	  posi[1]=inint(LDPoint[1]+ rect[3]+ barlength);
	}
      else 
	{
	  posi[0]=inint(LDPoint[0] - rect[2] +barlength);
	  posi[1]=inint(LDPoint[1] - i*nax[0]*size[0] + rect[3]/4.0);
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
  choix d'un format qui Fsepare les points 
  renvoit un format et un nombre qui est le nombre de d\'ecimales 
  associ\'ees au format 
  C'est le format que l'on va utiliser pour ecrire des nombres 
  le long des axes mais le nombre ecrit peut differer de 10% en valeurs 
  relative (cela depend du 0.1 plus bas ) 
  ce qui est peut etre trop gros ? 
------------------------------------------------*/

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
 *  regarde si le format qui separe les points est suffisant au niveau precision
 *  si non l'augmente.
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
  regarde si le format fmt qui utilise le nombre de 
  decimales dec permet de separer
   les nombres de xmin a xmax avec un pas xpas 
   le format utilise est du type 
   retourne aussi la longuer de chaine la plus grande avec 
   ce format dans l
------------------------------------------------------*/


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
  Meme Chose que ChoixFormatE mais quand les nombres sont donnes
  par un vecteur xx[0],...xx[N-1];
------------------------------------------------*/

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


