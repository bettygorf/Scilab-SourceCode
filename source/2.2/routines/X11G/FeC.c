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

C2F(fec)(x,y,triangles,func,Nnode,Ntr,strflag,legend,brect,aaint,lstr1,lstr2)
     double x[],y[],triangles[],func[];
     integer *Nnode,*Ntr;
     double brect[];
     integer  aaint[];
     char legend[],strflag[];
     integer lstr1,lstr2;
{
  static char logflag[]="nn";
  double FRect[4],scx,scy,xofset,yofset;
  integer IRect[4],IRect1[4],i;
  integer Xdec[3],Ydec[3];
  integer err=0,*xm,*ym,job=1,n1=1,j,k;
  /* Storing values if using the Record driver */
  if (GetDriver_()=='R') 
    StoreFec("fec",x,y,triangles,func,Nnode,Ntr,strflag,legend,brect,aaint);
  /** Boundaries of the frame **/
  FrameBounds("gnn",x,y,&n1,Nnode,aaint,strflag,brect,FRect,Xdec,Ydec);
  if ( (int)strlen(strflag) >=2 && strflag[1]=='0') job=0;
  Scale2D(job,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,logflag,&xm,&ym,*Nnode,&err);
  if ( err == 0) return;
  
  C2F(echelle2d)(x,y,xm,ym,Nnode,&n1,IRect,"f2i",3L);
  /** Draw Axis or only rectangle **/
  if ((int)strlen(strflag) >= 3 && strflag[2] == '1')
    {
      if ( strflag[1] == '5' || strflag[1]=='6' )
	{
	  /* utilisation des bornes automatiques */
	  aplot1_(FRect,IRect,Xdec,Ydec,&(aaint[0]),&(aaint[2]),"nn",scx,scy,xofset,yofset);
	}
      else
	{
	  double xmin1,xmax1, ymin1,ymax1;
	  aplot_(IRect,(xmin1=FRect[0],&xmin1),(ymin1=FRect[1],&ymin1),
		 (xmax1=FRect[2],&xmax1),(ymax1=FRect[3],&ymax1),
		 &(aaint[0]),&(aaint[2]),"nn"); 
	}
    }
  else 
    {
      if ((int)strlen(strflag) >= 3 && strflag[2] == '2')
	C2F(dr)("xrect","v",&IRect[0],&IRect[1],&IRect[2],&IRect[3],
		PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  /* Fec code */
  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
	  ,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  {
    integer nz;
    integer verbose=0,whiteid,narg;
    double zmin,zmax;
    /** Filling the triangles **/
    zmin=(double) Mini(func,*Nnode); 
    zmax=(double) Maxi(func,*Nnode);
    C2F(dr)("xget","white",&verbose,&whiteid,&narg,
	    PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    nz=whiteid;
    for ( i =0 ; i < nz ; i++)
      {
	double vmin,vmax;
	vmin=zmin + i*(zmax-zmin)/(nz);
	vmax=zmin + (i+1)*(zmax-zmin)/(nz);
	for ( j = 0 ; j < *Ntr ; j++)
	  {
	    integer sx[3],sy[3];
	    integer resx[6],resy[6];
	    double fxy[3];
	    integer ncont,nr;
	    for ( k=0 ; k< 3 ; k++)
	      {
		integer ii=triangles[j+(*Ntr)*(k+1)];
		sx[k]= xm[ii-1];
		sy[k]= ym[ii-1];
		fxy[k]= func[ii-1];
	      }
	    triang_(sx,sy,fxy,&vmin,&vmax,resx,resy,&nr);
	    if ( nr != 0)
	      C2F(dr)("xliness","str",resx,resy,&i,
		      (ncont=1,&ncont),&nr, PI0,PD0,PD0,PD0,PD0,0L,0L);
	  }
      }
  }
  C2F(dr)("xset","clipoff",PI0,PI0,PI0,PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** Drawing the Legends **/
  if ((int)strlen(strflag) >=1  && strflag[0] == '1')
    {
      integer style = -1;
      n1=1;
      Legends(IRect,&style,&n1,legend);
    }
}


triang_(sx,sy,fxy,zmin,zmax,resx,resy,nx)
     integer sx[3],sy[3];
     integer resx[6],resy[6];
     double fxy[3],*zmin,*zmax;
     integer *nx;
{
  integer cot;
  int zcote_();
  /* Cherche le polygone inclus ds le triangle 
     defini par sx,sy 
     pour lequel la valeur de f est comprise entre zmin 
     et zmax f est lineaire sur le triangle 
     */
  *nx = -1;
  for (cot=0;cot<3;cot++)
    {
      integer cotn = (cot+1)%3;
      double alpha1,alpha2;
      if (zcote_(cot, cotn,fxy,zmin,zmax,&alpha1,&alpha2) != 0)
	{
	  (*nx)++;
	  resx[*nx]=inint(alpha1*sx[cotn]+(1.0-alpha1)*sx[cot]);
	  resy[*nx]=inint(alpha1*sy[cotn]+(1.0-alpha1)*sy[cot]);
	  (*nx)++;
	  resx[*nx]=inint(alpha2*sx[cotn]+(1.0-alpha2)*sx[cot]);
	  resy[*nx]=inint(alpha2*sy[cotn]+(1.0-alpha2)*sy[cot]);
	}
    }
  (*nx)++;
}

int zcote_(i,j,fxy,zmin,zmax,alpha1,alpha2)
     double fxy[3],*zmin,*zmax;
     double *alpha1,*alpha2;
     integer i,j;
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


