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
#include <malloc.h> /* in case od dbmalloc use */
#include <stdio.h>
#include <math.h>
#include "Math.h"


extern char GetDriver_();
/*--------------------------------------------------------------------
  plot2d4_(xf,x,y,n1,n2,style,strflag,legend,brect,aaint)
--------------------------------------------------------------------------*/
  
C2F(plot2d4)(xf,x,y,n1,n2,style,strflag,legend,brect,aaint,l1,l2,l3)
     double x[],y[],brect[];
     integer   *n1,*n2,style[],aaint[];
     char legend[],strflag[],xf[];
     integer l1,l2,l3;
{
  double FRect[4],scx,scy,xofset,yofset;
  integer IRect[4],IRect1[4],err=0,*xm,*ym,job=1,Xdec[3],Ydec[3];
  double arsize1=5.0,arsize2=5.0;
  /** Attention : 2*(*n2) **/
  integer nn2=2*(*n2);
  integer arsize,j,iflag=0;
  integer verbose=0,xz[10],narg;
  /* Storing values if using the Record driver */
  if (GetDriver_()=='R') 
    StorePlot("plot2d4",xf,x,y,n1,n2,style,strflag,legend,brect,aaint);
  /** Boundaries of the frame **/
  FrameBounds(xf,x,y,n1,n2,aaint,strflag,brect,FRect,Xdec,Ydec);
  /** Scales **/
  if ( (int)strlen(strflag) >=2 && strflag[1]=='0') job=0;
  Scale2D(job,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,&xf[1],&xm,&ym,(*n1)*nn2,&err);
  if ( err == 0) return;
  /** Real to Pixel values **/
  Plo2d4RealToPixel(n1,n2,x,y,xm,ym,xf,FRect,scx,scy,xofset,yofset);
  /** Draw Axis or only rectangle **/
  AxisDraw(FRect,IRect,Xdec,Ydec,aaint,scx,scy,xofset,yofset,strflag,&xf[1]);
  /** Drawing the curves **/

  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
	  ,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  nn2=2*(*n2)-1;
  /** to get the default dash **/
  C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  arsize1= IRect[2]/70.0;
  arsize2= IRect[3]/70.0;
  arsize=  (arsize1 < arsize2) ? inint(10*arsize1) : inint(10*arsize2) ;
  
  for ( j = 0 ; j < (*n1) ; j++)
    {
      integer lstyle ;
      lstyle = (style[j] < 0) ?  -style[j]-1 : style[j];
      /** C2F(dr)("xset","dashes",&lstyle
	      , PI0, PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	      **/
      C2F(dr)("xarrow","v",&xm[2*(*n2)*j],&ym[2*(*n2)*j],&nn2,&arsize
	      ,&lstyle,&iflag,PD0,PD0,PD0,PD0,0L,0L); 

    }
  C2F(dr)("xset","dashes",xz,PI0, PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","clipoff",PI0,PI0,PI0,PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  
  /** Drawing the Legends **/
  if ((int)strlen(strflag) >=1  && strflag[0] == '1')
    Legends(IRect,style,n1,legend);
}



Plo2d4RealToPixel(n1,n2,x,y,xm,ym,xf,FRect,scx,scy,xofset,yofset)
     integer   *n1,*n2,*xm,*ym;
     char xf[];
     double x[],y[],FRect[4],scx,scy,xofset,yofset;
{
  integer i,j;

/** Computing y-values **/
if ((int)strlen(xf) >= 3 && xf[2]=='l')	  
  {
    for ( i=0 ; i < (*n2) ; i++)
      for (j=0 ; j< (*n1) ; j++)
	  ym[2*i+2*(*n2)*j]=inint( scy*(-log10(y[i+(*n2)*j])+FRect[3])+yofset);
    for ( i=0 ; i < (*n2)-1 ; i++)
      for (j=0 ; j< (*n1) ; j++)
	  ym[2*i+1+2*(*n2)*j]=	  ym[2*i+2+2*(*n2)*j];
  }
else 
  {
    for ( i=0 ; i < (*n2) ; i++)
      for (j=0 ; j< (*n1) ; j++)
	  ym[2*i+2*(*n2)*j]=inint( scy*(-(y[i+(*n2)*j])+FRect[3])+yofset);
    for ( i=0 ; i < (*n2)-1 ; i++)
      for (j=0 ; j< (*n1) ; j++)
	  ym[2*i+1+2*(*n2)*j]=	  ym[2*i+2+2*(*n2)*j];

  }

/** Computing x-values **/
switch (xf[0])
  {
 case 'e' :
   /** No X-value given by the user **/
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     {
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2) ; i++)
	   xm[2*i+2*(*n2)*j]=inint(scx*(log10(i+1.0)-FRect[0])+
				  xofset);
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2)-1 ; i++)
	   xm[2*i+1+2*(*n2)*j]=	   xm[2*i+2+2*(*n2)*j];
     }
   else 
     {
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2) ; i++)
	     xm[2*i+2*(*n2)*j]=inint(scx*((i+1.0)-FRect[0])+xofset);	   
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2)-1 ; i++)
	   xm[2*i+1+2*(*n2)*j]=	   xm[2*i+2+2*(*n2)*j];
     }
   break ;
 case 'o' :
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     {
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2) ; i++)
	     xm[2*i+2*(*n2)*j]=inint(scx*(log10(x[i])-FRect[0]) + xofset);
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2)-1 ; i++)
	   xm[2*i+1+2*(*n2)*j]=	   xm[2*i+2+2*(*n2)*j];
     }
   else 
     
     {
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2) ; i++)
	     xm[2*i+2*(*n2)*j]=inint(scx*(x[i]-FRect[0]) + xofset);
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2)-1 ; i++)
	   xm[2*i+1+2*(*n2)*j]=	   xm[2*i+2+2*(*n2)*j];

     }
   break;
 case 'g' :
 default:
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     {
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2) ; i++)
	     xm[2*i+2*(*n2)*j]=inint( scx*(log10(x[i+(*n2)*j]) -FRect[0])+
			       xofset);
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2)-1 ; i++)
	   xm[2*i+1+2*(*n2)*j]=	   xm[2*i+2+2*(*n2)*j];

     }
   else 
     {
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2) ; i++)
	     xm[2*i+2*(*n2)*j]=inint( scx*(x[i+(*n2)*j] -FRect[0])+ xofset);
       for (j=0 ; j< (*n1) ; j++)
	 for ( i=0 ; i < (*n2)-1 ; i++)
	   xm[2*i+1+2*(*n2)*j]=	   xm[2*i+2+2*(*n2)*j];

     }
   break;
 }
}
