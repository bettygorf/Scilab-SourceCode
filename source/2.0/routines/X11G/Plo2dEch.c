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


#include <string.h>
#include <stdio.h>
#include <math.h>
#include "Math.h"
#include "../machine.h"
char GetDriver_();
static double W1Rect[]={0.0,0.0,1.0,1.0};
static double FRect1[]={0.0,0.0,1.0,1.0},xofset1=75.0,yofset1=53.0;
static double scx1=450.0,scy1=318.0;
static int    IRect1[4]={75,53,450,318};

/*-----------------------------------------------------------------------
  Scale2D  Cette fonction fait deux choses:
  
  1.Elle modifie FRect,IRect,scx,scy,xofset,yofset
  2.Elle alloue ou r\'ealloue deux vecteurs xm et ym de type entier
  et de taille n 

  Cette fonction permet de fixer les echelles 
  apres appel de cette fonction pour que les nombres r\'eel 
  (x,y) dans FRect1={xmin,ymin,xmax,ymax} soient dessin\'es sur les 
  points en pixel du Rectangle IRect={xupleft,yupleft,xlarge,yheight}

    xpixel=nint( scx*(x -FRect[0]) + xofset);
    ypixel=nint( scy*(-y+FRect[3]) + yofset);

  la fonction echelle2d plus bas permet d'effectuer cette op\'eration 

  Si on appelle cette fonction avec la valeur 

  job=0, l'appel modifie FRect et IRect qui recoivent les valeurs 
          courantes des echelles

  job=1  IRect recoit la valeur courante 
	 FRect transmis est utilise et non modifie et sert a etablir 
	 une nouvelle valeur courante 

  job=2, FRect et IRect  sont utilises pour fixer 
         de nouvelles valeurs courantes

---------------------------------------------------------------------------*/

Scale2D(job,FRect,IRect,scx,scy,xofset,yofset,xm,ym,n,err)
     double FRect[4],*scx,*scy,*xofset,*yofset;
     int IRect[4],**xm,**ym,n,*err,job;
{
  int verbose=0,narg,xz[2],wmax,hmax,mfact;
  int *zm;
  C2F(dr)("xget","wdim",&verbose,xz,&narg, IP0, IP0,IP0,0,0);
  wmax=xz[0];hmax=xz[1];
  mfact=4;
  switch (job)
    {
      int i;
    case 0 :
      /** On utilise le scale de l'appel pr\'ec\'edent a Scale2D **/
      *scx = scx1; *scy = scy1; *xofset= xofset1; *yofset= yofset1;
      for (i=0; i < 4 ; i++) { IRect[i]=IRect1[i];FRect[i]=FRect1[i];};
      break;
    case 1 :
      /** Utilise FRect,  Irect <- valeurs par defaut **/
      *scx =  ((double) wmax*W1Rect[2]-wmax*W1Rect[2]/((double) mfact));
      *scy =  ((double) hmax*W1Rect[3]-hmax*W1Rect[3]/((double) mfact));
      *xofset=xofset1= ((double) wmax*W1Rect[2])/((double) 2.0*mfact);
      *yofset=yofset1= ((double) hmax*W1Rect[3])/((double) 2.0*mfact);
      IRect[0] = nint(*xofset+W1Rect[0]*((double)wmax));
      IRect[1] = nint(*yofset+W1Rect[1]*((double)hmax));
      IRect[2] = nint(*scx);
      IRect[3] = nint(*scy);
      scx1 =  IRect[2]; scy1 = IRect[3];
      *xofset=xofset1= IRect[0]; *yofset=yofset1= IRect[1];
      for (i=0; i < 4 ; i++) { IRect1[i]=IRect[i];FRect1[i]=FRect[i];};
      *scx=scx1 =(Abs(FRect[0]-FRect[2])<=SMDOUBLE) ?
	scx1/SMDOUBLE:scx1/Abs(FRect[0]-FRect[2]);
      *scy=scy1 =(Abs(FRect[1]-FRect[3])<=SMDOUBLE)?
	scy1/SMDOUBLE:scy1/Abs(FRect[1]-FRect[3]);
      break;
    case 2:
      scx1 =  IRect[2]; scy1 = IRect[3];
      *xofset=xofset1= IRect[0]; *yofset=yofset1= IRect[1];
      for (i=0; i < 4 ; i++) { IRect1[i]=IRect[i];FRect1[i]=FRect[i];};
      *scx=scx1 =(Abs(FRect[0]-FRect[2])<=SMDOUBLE) ?
	scx1/SMDOUBLE:scx1/Abs(FRect[0]-FRect[2]);
      *scy=scy1 =(Abs(FRect[1]-FRect[3])<=SMDOUBLE)?
	scy1/SMDOUBLE:scy1/Abs(FRect[1]-FRect[3]);
      break;
    };
  /** Allocation  **/
  Alloc(xm,ym,&zm,n,n,0,err);
  if ( *err == 0)
    {
      Scistring("Scale2D : No more Place\n");
      return;
    };
};

/**
  setscale2d_(WRect,FRect) 
  fixe une echelle pour les appels suivants 
  FRect est le rectangle reels que l'on veut voir {xmin,ymin,xmax,ymax}
  sur le dessin 
  WRect indique la sous fenetre a choisir dans la fenetre graphique
  pour faire le dessin 
  WRect=[<x-upperleft>,<y-upperleft>,largeur,hauteur]
  ou ces valeurs reelles sont des proportions de la largeur et hauteur de la 
  fenetre graphique
  par exemple WRect=[0,0,1.0,1.0] indique que l'on utilise toute la fenetre
  WRect=[0.5,0.5,0.5,0.5] indique que l'on utilise le quart gauche en bas 
  de la fenetre coupee en 4
**/


C2F(setscale2d)(WRect,FRect)
     double FRect[4], WRect[4];
{
  double scx,scy,xofset,yofset;
  int *xm,*ym,err=0,i,IRect[4];
  if (GetDriver_()=='R') StoreEch("scale",WRect,FRect);
  for ( i=0; i < 4 ; i++) 
    {
        W1Rect[i]=WRect[i];
    };
  Scale2D(1,FRect,IRect,&scx,&scy,&xofset,&yofset,&xm,&ym,0,&err);
};

C2F(getscale2d)(WRect,FRect)
     double FRect[4],WRect[4];
{
  double F1Rect[4],scx,scy,xofset,yofset;
  int *xm,*ym,err=0,i,IRect[4];
  Scale2D(0,F1Rect,IRect,&scx,&scy,&xofset,&yofset,&xm,&ym,0,&err);
  for ( i=0; i < 4 ; i++) 
    {
      FRect[i]=F1Rect[i];
      WRect[i]=W1Rect[i];
    };
};


/*--------------------------------------------------------------------
  Les fonction qui suivent sont utilisess dans Xcall1 pour que les 
  primitives graphiques utilisent l'echelle fix\'ess par Store2D
    
    echelle2d_(x,y,x1,y1,n1,n2,rect,dir)

    Cette fonction permet de convertir des valeurs absolues en valeurs 
    pixel et reciproquement la transformation utilisee etant la 
    trasformation courante qui a \'et\'e mise en place par l'appel a Scale2D

   
    if dir="f2i" -> double to int (you give x and y and get x1,y1)
    if dir="i2f" -> int to double (you give x1 and y1 and get x,y)

    rect is also a return value it's the rectangle in pixel 
    <x,y,width,height> set in Scale2D in which a plot such as plot2d 
    would take place
    
-> memory space for the vectors x[],y[],x1[],y1[] must be 
   allocated before the call to echelle2d_
   
 lstr : unused ( but used by Fortran ) 
--------------------------------------------------------------------------*/
  
C2F(echelle2d)(x,y,x1,yy1,n1,n2,rect,dir,lstr)
     double x[],y[];
     int x1[],yy1[],*n1,*n2,rect[];
     char dir[];
     long int lstr;
{
  int i;
  if (strcmp("f2i",dir)==0) 
    {
      /** double to int (pixel) direction **/
      for ( i=0 ; i < (*n1)*(*n2) ; i++)
	{
	  x1[i]=nint( scx1*( x[i]-FRect1[0]) + xofset1);
	  yy1[i]=nint( scy1*(-y[i]+FRect1[3]) + yofset1);
	};
    }
  else 
    {
      if (strcmp("i2f",dir)==0) 
	{
	  for ( i=0 ; i < (*n1)*(*n2) ; i++)
	    {
	      x[i]=FRect1[0] + (1.0/scx1)*( x1[i]- xofset1);
	      y[i]=FRect1[3] - (1.0/scy1)*( yy1[i]- yofset1);
	    };
	}
      else 
	SciF1s(" Wrong dir %s argument in echelle2d\r\n",dir);
    };
  for (i=0;i<4;i++) rect[i]=IRect1[i];
};

/** meme chose mais pour transformer des longueurs **/

echelle2dl_(x,y,x1,yy1,n1,n2,rect,dir)
     double x[],y[];
     int x1[],yy1[],*n1,*n2,rect[];
     char dir[];
{
  int i;
  if (strcmp("f2i",dir)==0) 
    {
      /** double to int (pixel) direction **/
      for ( i=0 ; i < (*n1)*(*n2) ; i++)
	{
	  x1[i]=nint( scx1*( x[i]));
	  yy1[i]=nint( scy1*( y[i]));
	};
    }
  else 
    {
      if (strcmp("i2f",dir)==0) 
	{
	  for ( i=0 ; i < (*n1)*(*n2) ; i++)
	    {
	      x[i]=x1[i]/scx1;
	      y[i]=yy1[i]/scy1;
	    };
	}
      else 
	SciF1s(" Wrong dir %s argument in echelle2d\r\n",dir);
    };
  for (i=0;i<4;i++) rect[i]=IRect1[i];
};


/** meme chose mais pour transformer des ellipses **/

ellipse2d_(x,x1,n,dir)
     double x[];
     int x1[],*n;
     char dir[];
{
  int i;
  if (strcmp("f2i",dir)==0) 
    {
      /** double to int (pixel) direction **/
      for ( i=0 ; i < (*n) ; i=i+6)
	{
	  x1[i]=nint( scx1*( x[i]-FRect1[0]) + xofset1);
	  x1[i+1]=nint( scy1*(-x[i+1]+FRect1[3]) + yofset1);
	  x1[i+2]=nint( scx1*( x[i+2]));
	  x1[i+3]=nint( scy1*( x[i+3]));
	  x1[i+4]=nint( x[i+4]);
	  x1[i+5]=nint( x[i+5]);
	};
    }
  else 
    {
      if (strcmp("i2f",dir)==0) 
	{
	  for ( i=0 ; i < (*n) ; i=i+6)
	    {
	      x[i]=FRect1[0] + (1.0/scx1)*( x1[i]- xofset1);
	      x[i+1]=FRect1[3] - (1.0/scy1)*( x1[i+1]- yofset1);
	      x[i+2]=x1[i+2]/scx1;
	      x[i+3]=x1[i+3]/scy1;
	      x[i+4]=x1[i+4];
	      x[i+5]=x1[i+5];
	    };
	}
      else 
	SciF1s(" Wrong dir %s argument in echelle2d\r\n",dir);
    };
};


/** meme chose mais pour transformer des rectangles **/

rect2d_(x,x1,n,dir)
     double x[];
     int x1[],*n;
     char dir[];
{
  int i;
  if (strcmp("f2i",dir)==0) 
    {
      /** double to int (pixel) direction **/
      for ( i=0 ; i < (*n) ; i= i+4)
	{
	  x1[i]=nint( scx1*( x[i]-FRect1[0]) + xofset1);
	  x1[i+1]=nint( scy1*(-x[i+1]+FRect1[3]) + yofset1);
	  x1[i+2]=nint( scx1*( x[i+2]));
	  x1[i+3]=nint( scy1*( x[i+3]));
	};
    }
  else 
    {
      if (strcmp("i2f",dir)==0) 
	{
	  for ( i=0 ; i < (*n) ; i=i+4)
	    {
	      x[i]=FRect1[0] + (1.0/scx1)*( x1[i]- xofset1);
	      x[i+1]=FRect1[3] - (1.0/scy1)*( x1[i+1]- yofset1);
	      x[i+2]=x1[i+2]/scx1;
	      x[i+3]=x1[i+3]/scy1;
	    };
	}
      else 
	SciF1s(" Wrong dir %s argument in echelle2d\r\n",dir);
    };
};
 
