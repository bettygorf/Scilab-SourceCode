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


#include <stdio.h>
#include <math.h>
#include "Math.h"
#include "../machine.h"

extern char GetDriver_();
/*------------------------------------------------------------
 - z is a (n1,n2) matrix 
 - x is a (1,n1) matrix 
 - y is a (1,n2) matrix 
 - x,y,z are stored as one dimensionnal array in C 
---------------------------------------------------------------*/

C2F(xgray)(x,y,z,n1,n2)
     double x[],y[],z[];
     int *n1,*n2;
{
  int IRect[4];
  double xmin,xmax,ymin,ymax;
  double FRect[4],scx,scy,xofset,yofset;
  static int *xm,*ym,err=0;
  int j,aaint[4];
  int x1,yy1,w1,h1;
  /** If Record is on **/
  if (GetDriver_()=='R') 
    StoreGray("gray",x,y,z,n1,n2); 
  aaint[0]=aaint[2]=2;aaint[1]=aaint[3]=10;
  xmin=x[0];ymin= -y[*n2-1],xmax=x[*n1-1],ymax= -y[0];
  FRect[0]=xmin;FRect[1]= -ymax;FRect[2]=xmax;FRect[3]= -ymin;
  Scale2D(1,FRect,IRect,&scx,&scy,&xofset,&yofset,&xm,&ym,Max((*n1),(*n2)),&err);
  if ( err == 0) return;
  aplot_(IRect,(xmin=FRect[0],&xmin),(ymin=FRect[1],&ymin),
	 (xmax=FRect[2],&xmax),(ymax=FRect[3],&ymax),
	 &(aaint[0]),&(aaint[2]),"nn"); 
  /** Drawing the curves **/
  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3],IP0,IP0,0,0);
  for ( j =0 ; j < (*n1) ; j++)	 
    xm[j]= scx*(x[j]-FRect[0])  +xofset;
  for ( j =0 ; j < (*n2) ; j++)	 
    ym[j]= scy*(-y[j]+FRect[3]) +yofset;
  GraySquare_(xm,ym,z,*n1,*n2);
  x1=yy1= -1;w1=h1=200000;
  C2F(dr)("xset","clipping",&x1,&yy1,&w1,&h1,IP0,IP0,0,0);
  C2F(dr)("xrect","v",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
      ,IP0,IP0,0,0);
};

/*-------------------------------------------------------
  x : of size n1 gives the x-values of the grid 
  y : of size n2 gives the y-values of the grid 
  z : of size n1*n2  gives the f-values on the grid 
-------------------------------------------------------*/

GraySquare_(x,y,z,n1,n2)
     int x[],y[];
     double z[];
     int n1,n2;
{
  double zmoy,zmax,zmin,zmaxmin;
  int i,j,verbose=0,whiteid,narg,fill[1],ncont;
  int xcont[4],ycont[4],cont_size=4;
  zmin=Mini(z,(n1)*(n2));
  zmax=Maxi(z,(n1)*(n2));
  zmaxmin=zmax-zmin;
  if (zmaxmin <= SMDOUBLE) zmaxmin=SMDOUBLE;
  C2F(dr)("xget","white",&verbose,&whiteid,&narg,
      IP0,IP0,IP0,0,0);
  
  for (i = 0 ; i < (n1)-1; i++)
  for (j=0 ; j < (n2)-1 ; j++)
    {
      xcont[0]=x[i];ycont[0]=y[j];
      xcont[1]=x[i+1];ycont[1]=y[j];
      xcont[2]=x[i+1];ycont[2]=y[j+1];
      xcont[3]=x[i];ycont[3]=y[j+1];
      zmoy=1/4.0*(z[i+n1*j]+z[i+n1*(j+1)]+z[i+1+n1*j]+z[i+1+n1*(j+1)]);
      fill[0]=nint(whiteid*(zmoy-zmin)/(zmaxmin));
      C2F(dr)("xliness","str",xcont,ycont,fill,(ncont=1,&ncont),&cont_size,
	  IP0,0,0);
    };
};

