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
 - z is a (n1,n2) matrix 
 - x is a (1,n1) matrix 
 - y is a (1,n2) matrix 
 - x,y,z are stored as one dimensionnal array in C 
---------------------------------------------------------------*/
extern char GetDriver_();
  

C2F(xgray)(x,y,z,n1,n2,strflag,brect,aaint,l1)
     double x[],y[],z[],brect[];
     integer *n1,*n2,aaint[];
     long int l1;
     char strflag[];
{
  double FRect[4],scx,scy,xofset,yofset;
  static char logflag[]="nn";
  integer IRect[4],Xdec[3],Ydec[3];
  double xx[2],yy[2];
  static integer *xm,*ym,err=0;
  integer j,job=1;
  integer x1,yy1,w1,h1,nn1=1,nn2=2;
  /** If Record is on **/
  if (GetDriver_()=='R') 
    StoreGray("gray",x,y,z,n1,n2,strflag,brect,aaint);
  xx[0]=Mini(x,*n1);xx[1]=Maxi(x,*n1);
  yy[0]=Mini(y,*n2);yy[1]=Maxi(y,*n2);
  /** Boundaries of the frame **/
  FrameBounds("gnn",xx,yy,&nn1,&nn2,aaint,strflag,brect,FRect,Xdec,Ydec);
  if ( (int)strlen(strflag) >=2 && strflag[1]=='0') job=0;
  Scale2D(job,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,logflag,&xm,&ym,Max((*n1),(*n2)),&err);
  if ( err == 0) return;
  /** Draw Axis or only rectangle **/
  AxisDraw(FRect,IRect,Xdec,Ydec,aaint,scx,scy,xofset,yofset,strflag,logflag);
  /** Drawing the curves **/
  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3],PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  for ( j =0 ; j < (*n1) ; j++)	 
    xm[j]= scx*(x[j]-FRect[0])  +xofset;
  for ( j =0 ; j < (*n2) ; j++)	 
    ym[j]= scy*(-y[j]+FRect[3]) +yofset;
  GraySquare_(xm,ym,z,*n1,*n2);
  C2F(dr)("xset","clipoff",PI0,PI0,PI0,PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xrect","v",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
      ,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}

/*-------------------------------------------------------
  x : of size n1 gives the x-values of the grid 
  y : of size n2 gives the y-values of the grid 
  z : of size n1*n2  gives the f-values on the grid 
-------------------------------------------------------*/

GraySquare_(x,y,z,n1,n2)
     integer x[],y[];
     double z[];
     integer n1,n2;
{
  double zmoy,zmax,zmin,zmaxmin;
  integer i,j,verbose=0,whiteid,narg,fill[1],cpat,xz[2];
  zmin=Mini(z,(n1)*(n2));
  zmax=Maxi(z,(n1)*(n2));
  zmaxmin=zmax-zmin;
  if (zmaxmin <= SMDOUBLE) zmaxmin=SMDOUBLE;
  C2F(dr)("xget","white",&verbose,&whiteid,&narg,
      PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","pattern",&verbose,&cpat,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","wdim",&verbose,xz,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  for (i = 0 ; i < (n1)-1 ; i++)
  for (j = 0 ; j < (n2)-1 ; j++)
    {
      integer w,h;
      zmoy=1/4.0*(z[i+n1*j]+z[i+n1*(j+1)]+z[i+1+n1*j]+z[i+1+n1*(j+1)]);
      fill[0]=inint(whiteid*(zmoy-zmin)/(zmaxmin));
      C2F(dr)("xset","pattern",&(fill[0]),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      w=Abs(x[i+1]-x[i]);h=Abs(y[j+1]-y[j]);
      /* We don't trace rectangle which are totally out **/
      if ( w != 0 && h != 0 && x[i] < xz[0] && y[j+1] < xz[1] && x[i]+w > 0 && y[j+1]+h > 0 )
	{
	  if ( Abs(x[i]) < int16max && Abs(y[j+1]) < int16max && w < uns16max && h < uns16max)
	    {
	      /* fprintf(stderr,"Rectangle %d,%d : %d,%d,%d,%d\n",i,j,x[i],y[j+1],w,h); */
	      C2F(dr)("xfrect","v",&x[i],&y[j+1],&w,&h,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	    }
	  else 
	    {
	      /* fprintf(stderr,"Rectangle too large \n"); */
	    }
	}
    }
  C2F(dr)("xset","pattern",&cpat,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}


