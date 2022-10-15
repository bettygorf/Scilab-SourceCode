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
  Iso contour with grey level or colors 
  for a function defined by finite elements 
  ( f is linear on triangles )
  we give two versions of the function : a 
  quick version wich only fill triangles according to the average 
  value of f on a triangle
  and a slow version but more sexy which use the fact that f is linear
  on each triangle.
  Nodes (x[no],y[no])
  Triangles (Matrix: [ numero, no1,no2,no3,iflag;...]
  func[no] : Function value on Nodes.
  Nnode : number of nodes 
  Ntr   : number of triangles 
  strflag,legend,brect,aint : see plot2d 
---------------------------------------------------------------*/

C2F(fec)(x,y,triangles,func,Nnode,Ntr,strflag,legend,brect,aaint,
	 lstr1,lstr2)
     double x[],y[],triangles[],func[];
     int *Nnode,*Ntr;
     double brect[];
     int  aaint[];
     char legend[],strflag[];
     long int lstr1,lstr2;
{
  static double xmax=10.0,xmin=0.0,ymin= -10.0,ymax=0.0;
  double FRect[4],scx,scy,xofset,yofset;
  int IRect[4],IRect1[4],err=0,*xm,*ym,job=1,n2=1,i,j,k;
  /* Storing values if using the Record driver */
  if (GetDriver_()=='R') 
    StoreFec("fec",x,y,triangles,func,Nnode,Ntr,strflag,legend,brect,aaint);
  /** Boundaries of the frame **/
  if ((int)strlen(strflag) >= 2)
    {
      int verbose=0,narg,xz[2],wmax,hmax;
      double hx,hy,hx1,hy1;
      switch ( strflag[1])
	{
	case '1' :
	case '3' :
	  xmin=brect[0];xmax=brect[2];ymin= -brect[3];ymax= -brect[1];
	  break;
	case '2' : 
	case '4' : 
	  xmax=  (double) Maxi(x,*Nnode);
	  xmin=  (double) Mini(x,*Nnode);
	  ymax=  (double) - Mini(y,*Nnode);
	  ymin=  (double) - Maxi(y,*Nnode);
	  break;
	}
      if ( strflag[1] == '3' || strflag[1] == '4')
	{
	  C2F(dr)("xget","wdim",&verbose,xz,&narg, IP0, IP0,IP0,0,0);
	  wmax=xz[0];hmax=xz[1];
	  hx=xmax-xmin;
	  hy=ymax-ymin;
	  if ( hx/(double)wmax  <hy/(double) hmax ) 
	    {
	      hx1=wmax*hy/hmax;
	      xmin=xmin-(hx1-hx)/2.0;
	      xmax=xmax+(hx1-hx)/2.0;
	    }
	  else 
	    {
	      hy1=hmax*hx/wmax;
	      ymin=ymin-(hy1-hy)/2.0;
	      ymax=ymax+(hy1-hy)/2.0;
	    }
	}
    }
  /* FRect gives the plotting boundaries xmin,ymin,xmax,ymax */
  
  FRect[0]=xmin;FRect[1]= -ymax;FRect[2]=xmax;FRect[3]= -ymin;
  if ( (int)strlen(strflag) >=2 && strflag[1]=='0') job=0;
  Scale2D(job,FRect,IRect,&scx,&scy,&xofset,&yofset,&xm,&ym,*Nnode,&err);
  if ( err == 0) return;
  
  C2F(echelle2d)(x,y,xm,ym,Nnode,&n2,IRect,"f2i",3L);
  /** Draw Axis or only rectangle **/
  
  if ((int)strlen(strflag) >= 3 && strflag[2] == '1')
    {
      double xmin1,xmax1, ymin1,ymax1;
      aplot_(IRect,(xmin1=FRect[0],&xmin1),(ymin1=FRect[1],&ymin1),
	     (xmax1=FRect[2],&xmax1),(ymax1=FRect[3],&ymax1),
	     &(aaint[0]),&(aaint[2]),"nn"); 
    }
  else 
    {
      if ((int)strlen(strflag) >= 3 && strflag[2] == '2')
	C2F(dr)("xrect","v",&IRect[0],&IRect[1],&IRect[2],&IRect[3],
		IP0,IP0,0,0);
    }

  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
	  ,IP0,IP0,0,0);
  {
    int fill,nz;
    int verbose=0,whiteid,narg;
    double zmin,zmax;
    /** Filling the triangles **/
    zmin=(double) Mini(func,*Nnode); 
    zmax=(double) Maxi(func,*Nnode);
    C2F(dr)("xget","white",&verbose,&whiteid,&narg,
	    IP0,IP0,IP0,0,0);
    nz=whiteid;
    for ( i =0 ; i < nz ; i++)
      {
	double vmin,vmax;
	vmin=zmin + i*(zmax-zmin)/(nz);
	vmax=zmin + (i+1)*(zmax-zmin)/(nz);
	for ( j = 0 ; j < *Ntr ; j++)
	  {
	    int sx[3],sy[3],resx[6],resy[6];
	    double fxy[3];
	    int ncont,nr;
	    for ( k=0 ; k< 3 ; k++)
	      {
		int ii=triangles[j+(*Ntr)*(k+1)];
		sx[k]= xm[ii-1];
		sy[k]= ym[ii-1];
		fxy[k]= func[ii-1];
	      }
	    triang_(sx,sy,fxy,&vmin,&vmax,resx,resy,&nr);
	    if ( nr != 0)
	      C2F(dr)("xliness","str",resx,resy,&i,
		      (ncont=1,&ncont),&nr, IP0,0,0);
	  }
      }
  }
  IRect1[0]=IRect1[1]= -1;IRect1[2]=IRect1[3]=200000;
  C2F(dr)("xset","clipping",&IRect1[0],&IRect1[1],&IRect1[2],&IRect1[3]
	  ,IP0,IP0,0,0);
  /** Drawing the Legends **/
  if ((int)strlen(strflag) >=1  && strflag[0] == '1')
    {
      int style = -1,n1=1;
      Legends(IRect,&style,&n1,legend);
    }
}


triang_(sx,sy,fxy,zmin,zmax,resx,resy,nx)
     int sx[3],sy[3],resx[6],resy[6];
     double fxy[3],*zmin,*zmax;
     int *nx;
{
  int cot,zcote_();
  /* Cherche le polygone inclus ds le triangle 
     defini par sx,sy 
     pour lequel la valeur de f est comprise entre zmin 
     et zmax f est lineaire sur le triangle 
     */
  *nx = -1;
  for (cot=0;cot<3;cot++)
    {
      int cotn = (cot+1)%3;
      double alpha1,alpha2;
      if (zcote_(cot, cotn,fxy,zmin,zmax,&alpha1,&alpha2) != 0)
	{
	  (*nx)++;
	  resx[*nx]=nint(alpha1*sx[cotn]+(1.0-alpha1)*sx[cot]);
	  resy[*nx]=nint(alpha1*sy[cotn]+(1.0-alpha1)*sy[cot]);
	  (*nx)++;
	  resx[*nx]=nint(alpha2*sx[cotn]+(1.0-alpha2)*sx[cot]);
	  resy[*nx]=nint(alpha2*sy[cotn]+(1.0-alpha2)*sy[cot]);
	}
    }
  (*nx)++;
}

int zcote_(i,j,fxy,zmin,zmax,alpha1,alpha2)
     double fxy[3],*zmin,*zmax;
     double *alpha1,*alpha2;
{
  if ( fxy[i] >= *zmin && fxy[i] <= *zmax )
    {
      *alpha1=0.0;
      if ( fxy[j] >= fxy[i]) 
	{
	  if ( fxy[j] > fxy[i])
	    *alpha2=Min((*zmax-fxy[i])/(fxy[j]-fxy[i]),1.0);
	  else
	    *alpha2=1.0;
	}
      else 
	{
	  *alpha2=Min((*zmin-fxy[i])/(fxy[j]-fxy[i]),1.0);
	}
    }
  else 
    {
      if ( fxy[i] < *zmin )
	{
	  if ( fxy[j] < *zmin) 
	    return(0);
	  else 
	    {
	      *alpha1=Min((*zmin-fxy[i])/(fxy[j]-fxy[i]),1.0);
	      if (fxy[j] <= *zmax)
		*alpha2=1;
	      else 
		*alpha2=Min((*zmax-fxy[i])/(fxy[j]-fxy[i]),1.0);
	    }
	}
      else
	if ( fxy[i] > *zmax )
	  {
	    if ( fxy[j] > *zmax) return(0);
	    else 
	      {
		*alpha1=Min((*zmax-fxy[i])/(fxy[j]-fxy[i]),1.0);
		if (fxy[j] > *zmin)
		  *alpha2=1;
		else 
		  *alpha2=Min((*zmin-fxy[i])/(fxy[j]-fxy[i]),1.0);
	      }
	  }
    }
  return(1);
}


