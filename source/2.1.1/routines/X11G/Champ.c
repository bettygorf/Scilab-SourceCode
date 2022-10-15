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
#include "Math.h"
#include <stdio.h>
#include <string.h>
#include "../machine.h"

extern char GetDriver_();

/*-----------------------------------------------------------------
   champ_(fx,fy,strflag,vrect,arfact)

 Draw a vector field of dimension 2
 (fx[i+(*n1)*j], fy[i+(*n1)*j]) is the value of the vector field 
 at point X=(i,j);
 fx and fy are (*n1)*(*n2) matrix of double values.
 arfact : a factor by which to multiply the default arrow size 
          usr 1.0 by defaut 
 
 strflag : a string of length 1 
 
     if strflag[0] == '0' No axis drawn around the field

     if strflag[0] == '1' then an axis is draw the value of vrect is used
        to get the values to put on the axis 

     if strflag[0] == '2' Then an axis is draw and the values of previous 
        call to a drawing routine are used to get the values and the 
	rectangle to use 

 vrect=[xmin,ymin,xmax,ymax]

 lstr : unused ( but used by Fortran ) 
-------------------------------------------------------------------*/

C2F(champ)(fx,fy,n1,n2,strflag,vrect,arfact,lstr)
     double fx[],fy[],vrect[],*arfact;
     int *n1,*n2;
     char strflag[];
     long int lstr;
{
  double FRect[4],scx,scy,xofset,yofset;
  int IRect[4],IRect1[4],err=0,*xm,*ym,i,j,job=1,n;
  double nx,ny;
  double sc;
  double arsize1=0.5,arsize2=0.5;
  int arsize;
  /* Storing values if using the Record driver */
  if (GetDriver_()=='R') 
    StoreChamp("champ",fx,fy,n1,n2,strflag,vrect,arfact);
  /** The arrowsize acording to the windowsize **/
  n=2*(*n1)*(*n2);
  FRect[0]=vrect[0];FRect[1]=vrect[1];FRect[2]=vrect[2];FRect[3]=vrect[3];
  if ( (int)strlen(strflag) >=1 && strflag[0]=='2') job=0;
  Scale2D(job,FRect,IRect,&scx,&scy,&xofset,&yofset,&xm,&ym,n,&err);
  if ( err == 0) return;
  nx=((double) IRect[2])/((double)(*n1)-1);
  ny=((double) IRect[3])/((double)(*n2)-1);
  for ( i = 0 ; i < *n1 ; i++)
    for ( j =0 ; j < *n2 ; j++)
    {
      xm[2*(i +(*n1)*j)]= nint(nx*i + xofset);
      ym[2*(i +(*n1)*j)]= nint(ny*(*n2-j-1) + yofset);
    
    }
  /** Scaling **/

  for (i = 0 ; i < (*n1)*(*n2) ; i++)
    {
      fx[i] = IRect[2]*fx[i]/Abs(FRect[2]-FRect[0]);
      fy[i] = IRect[3]*fy[i]/Abs(-FRect[1]+FRect[3]);;
    }
  sc= fx[0]*fx[0]+fy[0]*fy[0];
  for (i = 1;  i < (*n1)*(*n2) ; i++)
    {
      double maxx;
      maxx =  fx[i]*fx[i]+fy[i]*fy[i];
      if ( maxx > sc) sc=maxx;
    }
  sc = ( sc < SMDOUBLE) ? SMDOUBLE : sqrt(sc) ;

  for (i = 0 ; i < (*n1)*(*n2) ; i++)
    {
      int nn;
      nn=sqrt(nx*nx+ny*ny);
      fx[i] = nn*fx[i]/sc;
      fy[i] = nn*fy[i]/sc; 
    }
  /** size of arrow **/
  arsize1= ((double) IRect[2])/(5*(*n1));
  arsize2= ((double) IRect[3])/(5*(*n2));
  arsize=  (arsize1 < arsize2) ? nint(arsize1*10.0) : nint(arsize2*10.0) ;
  arsize = arsize*(*arfact);
  for ( i = 0 ; i < (*n1)*(*n2) ; i++)
    {
      xm[1+2*i]=fx[i]/2+xm[2*i];
      xm[2*i]  = -fx[i]/2+xm[2*i];
      ym[1+2*i]= -fy[i]/2+ym[2*i];
      ym[2*i]  =fy[i]/2+ym[2*i];
    }
  if ( strflag[0] != '0' ) 
    { 
      double xmin1,xmax1, ymin1,ymax1;
      int xnax[2],ynax[2];
      xnax[0]=ynax[0]=1;
      xnax[1]= ((*n1) > 11) ? 10 : *n1-1;
      ynax[1]= ((*n2) > 11) ? 10 : *n2-1;
      aplot_(IRect,(xmin1=FRect[0],&xmin1),(ymin1=FRect[1],&ymin1),
	     (xmax1=FRect[2],&xmax1),(ymax1=FRect[3],&ymax1),
	     xnax,ynax,"nn");
    }
  else 
    {
      C2F(dr)("xrect","v",&IRect[0],&IRect[1],&IRect[2],&IRect[3],IP0,IP0,0,0);
    }
  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3],IP0,IP0,0,0);
  n=2*(*n1)*(*n2);
  C2F(dr)("xarrow","v",xm,ym,&n,&arsize,IP0,IP0,0,0);
  IRect1[0]=IRect1[1]= -1;IRect1[2]=IRect1[3]=200000;
  C2F(dr)("xset","clipping",&IRect1[0],&IRect1[1],&IRect1[2],&IRect1[3],
      IP0,IP0,0,0);
    
}


