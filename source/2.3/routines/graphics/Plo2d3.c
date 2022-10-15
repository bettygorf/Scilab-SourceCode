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

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <stdio.h>
#include <math.h>
#include "Math.h"

static void Plo2d3RealToPixel();

/*--------------------------------------------------------------------
  C2F(plot2d3)(xf,x,y,n1,n2,style,strflag,legend,brect,aaint)

  used to plot only vertical bars form (x_i,0) to (x_i,y_i)
  the arguments are similar to those of plot2d 
  the only difference is that style must have positive values 
  which are considered as dash-styles 
--------------------------------------------------------------------------*/
  
int C2F(plot2d3)(xf,x,y,n1,n2,style,strflag,legend,brect,aaint,l1,l2,l3)
     double x[],y[],brect[];
     integer   *n1,*n2,style[],aaint[];
     char legend[],strflag[],xf[];
     integer l1,l2,l3;
{
  double FRect[4],scx,scy,xofset,yofset;
  integer IRect[4],err=0,*xm,*ym,job=1,Xdec[3],Ydec[3];
  integer verbose1=0,xz1[10],narg1,j;
  /** Attention : 2*(*n2) **/
  integer nn2=2*(*n2);
  if ( CheckxfParam(xf)== 1) return(0);
  /* Storing values if using the Record driver */
  if (GetDriver()=='R') 
    StorePlot("plot2d3",xf,x,y,n1,n2,style,strflag,legend,brect,aaint);
  /** Boundaries of the frame **/
  /** Boundaries of the frame **/
  FrameBounds(xf,x,y,n1,n2,aaint,strflag,brect,FRect,Xdec,Ydec);
  /** Scales **/
  if ( (int)strlen(strflag) >=2 && strflag[1]=='0') job=0;
  Scale2D(job,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,&xf[1],&xm,&ym,(*n1)*nn2,&err);
  if ( err == 0) return(0);
  /** Real to Pixel values **/
  Plo2d3RealToPixel(n1,n2,x,y,xm,ym,xf,FRect,scx,scy,xofset,yofset);

  /** Draw Axis or only rectangle **/
  AxisDraw(FRect,IRect,Xdec,Ydec,aaint,scx,scy,xofset,yofset,strflag,&xf[1]);

  /** Drawing the curves **/

  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
    		     ,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  
  /** to get the default dash **/
  C2F(dr)("xget","dashes",&verbose1,xz1,&narg1
	  ,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  for ( j = 0 ; j < (*n1) ; j++)
    {
      integer lstyle,iflag=0;
      /** style must be negative **/
      lstyle = (style[j] < 0) ?  -style[j] : style[j];
      /** C2F(dr)("xset","dashes",&lstyle
	      ,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L); **/
      C2F(dr)("xsegs","v",&xm[2*(*n2)*j],&ym[2*(*n2)*j],&nn2
	      ,&lstyle,&iflag,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  C2F(dr)("xset","dashes",xz1
	  ,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","clipoff",PI0,PI0,PI0,PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** Drawing the Legends **/
  if ((int)strlen(strflag) >=1  && strflag[0] == '1')
    Legends(IRect,style,n1,legend);
  return(0);
}


static void Plo2d3RealToPixel(n1, n2, x, y, xm, ym, xf, FRect, scx, scy, xofset, yofset)
     integer *n1;
     integer *n2;
     double *x;
     double *y;
     integer *xm;
     integer *ym;
     char *xf;
     double *FRect;
     double scx;
     double scy;
     double xofset;
     double yofset;
{
  integer i,j;
  /** Computing y-values **/
  if ((int)strlen(xf) >= 3 && xf[2]=='l')	  
    {
      for ( i=0 ; i < (*n2) ; i++)
	for (j=0 ; j< (*n1) ; j++)
	  {
	    ym[2*i+1+2*(*n2)*j]=inint( scy*(FRect[3])+yofset);
	    ym[2*i+2*(*n2)*j]=inint( scy*(-log10(y[i+(*n2)*j])+FRect[3])+yofset);
	  }
    }
  else 
    {
      for ( i=0 ; i < (*n2) ; i++)
	for (j=0 ; j< (*n1) ; j++)
	  {
	    ym[2*i+1+2*(*n2)*j]=inint(scy*(FRect[3])+yofset);
	    ym[2*i+2*(*n2)*j]=inint( scy*(-(y[i+(*n2)*j])+FRect[3])+yofset);
	  }
    }

  /** Computing x-values **/
  switch (xf[0])
  {
  case 'e' :
   /** No X-value given by the user **/
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=0 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=inint(scx*(log10(i+1.0)-FRect[0])+
				      xofset);
	     xm[2*i+1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];

	   }
       }
   else 
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=0 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=inint(scx*((i+1.0)-FRect[0])+xofset);	   
	     xm[2*i+1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];

	   }
       }
   break ;
 case 'o' :
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=0 ; i < (*n2) ; i++)
	   {

	     xm[2*i+2*(*n2)*j]=inint(scx*(log10(x[i])-FRect[0]) + xofset);
	     xm[2*i+1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];
	   }
       }
   else 
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=0 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=inint(scx*(x[i]-FRect[0]) + xofset);
	     xm[2*i+1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];
	     
	   }
       }
   break;
 case 'g' :
 default:
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=0 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=inint( scx*(log10(x[i+(*n2)*j]) -FRect[0])+
			       xofset);
	     xm[2*i+1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];

	   }
       }
   else 
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=0 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=inint( scx*(x[i+(*n2)*j] -FRect[0])+
			       xofset);
	     xm[2*i+1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];

	   }
       }
   break;
 }
}
