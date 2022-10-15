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

extern char GetDriver_();
/*--------------------------------------------------------------------
  plot2d2_(xf,x,y,n1,n2,style,strflag,legend,brect,aint)

  Same as plot2dn_ but the curves are plotted in a piece-wise linear 
  style 
--------------------------------------------------------------------------*/
  
C2F(plot2d2)(xf,x,y,n1,n2,style,strflag,legend,brect,aint,l1,l2,l3)
     double x[],y[],brect[];
     int   *n1,*n2,style[],aint[];
     char legend[],strflag[],xf[];
     long int l1,l2,l3;
{
static double xmax=10.0,xmin=0.0,ymin= -10.0,ymax=0.0;
double FRect[4],scx,scy,xofset,yofset;
int IRect[4],IRect1[4],err=0,*xm,*ym,i,j,job=1,nn2;
/* Storing values if using the Record driver */
if (GetDriver_()=='R') 
StorePlot("plot2d2",xf,x,y,n1,n2,style,strflag,legend,brect,aint);
/** Boundaries of the frame **/
if ((int)strlen(strflag) >= 2)
  {
    switch ( strflag[1])
      {char c;
      case '1' : xmin=brect[0];xmax=brect[2];ymin= -brect[3];ymax= -brect[1];
	break;
      case '2' : 
	if ( (int)strlen(xf) < 1) c='g' ; else c=xf[0];
	switch ( c )
	  {
	  case 'e' : xmin= 1.0 ; xmax = (*n2);break;
	  case 'o' : 
	    xmax=  (double) Maxi(x,(*n2));
	    xmin=  (double) Mini(x,(*n2)); break;
	  case 'g' :
	  default: 
	    xmax=  (double) Maxi(x,(*n1)*(*n2));
	    xmin=  (double) Mini(x,(*n1)*(*n2)); break;
	  }
	ymax=  (double) - Mini(y,(*n1)*(*n2));
	ymin=  (double) - Maxi(y,(*n1)*(*n2));
	break;
      }
  }
/** Log Axes : must add tests **/
/* Log axis  */
if ((int)strlen(xf) >= 2 && xf[1]=='l' && (int)strlen(strflag) >= 2 && strflag[1] != '0')
  {
    if ( xmin >  0)
      {
	xmax=(double) ceil(log10(xmax));
	xmin=(double) floor(log10(xmin));
	aint[0]=1;aint[1]=nint(xmax-xmin);
      }
    else 
      {
	Scistring(" Can't use Log on X-axis xmin is negative \n");
	return;}
  }
if ((int)strlen(xf) >=3  && xf[2]=='l' && (int)strlen(strflag) >= 2 && strflag[1] != '0')
  {
    if ( (- ymin ) > 0 && (-ymax > 0) )
      {
	ymax=  (double) ceil(-log10(-ymax));
	ymin=  (double) floor(-log10(-ymin));
	aint[2]=1;aint[3]=nint(ymax-ymin);
      }
    else 
      {
	Scistring(" Can't use Log on y-axis ymin is negative \n");
	return;
      }
  }

/** Scaling **/
/* FRect gives the plotting boundaries xmin,ymin,xmax,ymax */

FRect[0]=xmin;FRect[1]= -ymax;FRect[2]=xmax;FRect[3]= -ymin;
if ( (int)strlen(strflag) >=2 && strflag[1]=='0') job=0;
/** Attention : 2*(*n1)*(*n2) **/
Scale2D(job,FRect,IRect,&scx,&scy,&xofset,&yofset,&xm,&ym,2*(*n1)*(*n2),&err);
if ( err == 0) return;

/** Computing y-values **/
if ((int)strlen(xf) >= 3 && xf[2]=='l')	  
  {
    for ( i=0 ; i < (*n2) ; i++)
      for (j=0 ; j< (*n1) ; j++)
	ym[2*i+1+2*(*n2)*j]=
	  ym[2*i+2*(*n2)*j]=nint( scy*(-log10(y[i+(*n2)*j])+FRect[3])+yofset);
  }
else 
  {
    for ( i=0 ; i < (*n2) ; i++)
      for (j=0 ; j< (*n1) ; j++)
	  ym[2*i+1+2*(*n2)*j]=
	  ym[2*i+2*(*n2)*j]=nint( scy*(-(y[i+(*n2)*j])+FRect[3])+yofset);
  }

/** Computing x-values **/
switch (xf[0])
  {
 case 'e' :
   /** No X-value given by the user **/
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=1 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=nint(scx*(log10(i+1.0)-FRect[0])+xofset);
	     xm[2*i-1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];

	   }
	 xm[2*(*n2)*j]=nint(scx*(-FRect[0])+  xofset);
	 xm[2*(*n2)-1+ 2*(*n2)*j]=	 xm[2*(*n2-1)+ 2*(*n2)*j];
       }
   else 
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=1 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=nint(scx*((i+1.0)-FRect[0])+xofset);	   
	     xm[2*i-1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];

	   }
	 xm[2*(*n2)*j]=nint(scx*((1.0)-FRect[0])+xofset);	   
	 xm[2*(*n2)-1+ 2*(*n2)*j]=	 xm[2*(*n2-1)+ 2*(*n2)*j];
       }
   break ;
 case 'o' :
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=1 ; i < (*n2) ; i++)
	   {

	     xm[2*i+2*(*n2)*j]=nint(scx*(log10(x[i])-FRect[0]) + xofset);
	     xm[2*i-1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];
	   }
	 xm[2*(*n2)*j]=nint(scx*(log10(x[0])-FRect[0]) + xofset);
	 xm[2*(*n2)-1+ 2*(*n2)*j]=	 xm[2*(*n2-1)+ 2*(*n2)*j];
       }
   else 
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=1 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=nint(scx*(x[i]-FRect[0]) + xofset);
	     xm[2*i-1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];
	     
	   }
	 xm[2*(*n2)*j]=nint(scx*(x[0]-FRect[0]) + xofset);
	 xm[2*(*n2)-1+ 2*(*n2)*j]=	 xm[2*(*n2-1)+ 2*(*n2)*j];
       }
   break;
 case 'g' :
 default:
   if ((int)strlen(xf) >= 2 && xf[1]=='l')
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=1 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=nint( scx*(log10(x[i+(*n2)*j]) -FRect[0])+xofset);
	     xm[2*i-1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];

	   }
	 xm[2*(*n2)*j]=nint( scx*(log10(x[(*n2)*j]) -FRect[0])+xofset);
	 xm[2*(*n2)-1+ 2*(*n2)*j]=	 xm[2*(*n2-1)+ 2*(*n2)*j];
       }
   else 
     for (j=0 ; j< (*n1) ; j++)
       {
	 for ( i=1 ; i < (*n2) ; i++)
	   {
	     xm[2*i+2*(*n2)*j]=nint( scx*(x[i+(*n2)*j] -FRect[0])+xofset);
	     xm[2*i-1+2*(*n2)*j]=xm[2*i+2*(*n2)*j];

	   }
	 xm[2*(*n2)*j]=nint( scx*(x[(*n2)*j] -FRect[0])+xofset);
	 xm[2*(*n2)-1+ 2*(*n2)*j]=	 xm[2*(*n2-1)+ 2*(*n2)*j];
       }
   break;
 }


/** Draw Axis or only rectangle **/

if ((int)strlen(strflag) >= 3 && strflag[2] == '1')
    {
      double xmin1,xmax1, ymin1,ymax1;
      aplot_(IRect,(xmin1=FRect[0],&xmin1),(ymin1=FRect[1],&ymin1),
	     (xmax1=FRect[2],&xmax1),(ymax1=FRect[3],&ymax1),
	     &(aint[0]),&(aint[2]),&xf[1]); 
    }
else
  {
    if ((int)strlen(strflag) >= 3 && strflag[2] == '2')
      C2F(dr)("xrect","v",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
		     ,IP0,IP0,0,0);
  }

/** Drawing the curves **/

C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
		     ,IP0,IP0,0,0);
nn2=2*(*n2);
C2F(dr)("xpolys","v",xm,ym,style,n1,&nn2
		     ,IP0,0,0);
IRect1[0]=IRect1[1]= -1;IRect1[2]=IRect1[3]=200000;
C2F(dr)("xset","clipping",&IRect1[0],&IRect1[1],&IRect1[2],&IRect1[3]
		     ,IP0,IP0,0,0);

/** Drawing the Legends **/
if ((int)strlen(strflag) >=1  && strflag[0] == '1')
    Legends(IRect,style,n1,legend);
}

