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
#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif



#include <string.h>
#include <stdio.h>
#include <math.h>
#include "Math.h"
#include "../machine.h"

/*--------------------------------------------------------------------
  plot2d_(x,y,n1,n2,style,strflag,legend,brect,aaint,lstr1,lstr2)
  
  Draw *n1 curves of *n2 points each
  (x[i+(*n2)*j] ,y[i+(*n2)*j]) Double values giving the point
  position of point i of curve j (i=0,*n2-1 j=0,*n1-1)

  style[*n1]-> give the style to use for each curve 
     if style is positive --> a mark is used (mark id = style[i])
     if style is strictly negative --> a dashed line is used 
        (dash id = abs(style[i])
     if there's only one curve, style can be of type style[0]=style,
     style[1]=pos ( pos in [1,6]) 
     pos give the legend position (1 to 6) (this can be iteresting
     if you want to superpose curves with different legends by 
     calling plot2d more than one time.

  strflag[3] is a string
  
     if strflag[0] == '1' then legends are added 
        legend = "leg1@leg2@....@legn"; gives the legend for each curve
	else no legend

     if strflag[1] == '1' then  the values of brect are used to fix 
        the drawing boundaries :  brect[]= <xmin,ymin,xmax,ymax>;
	if strflag[1] == '2' then the values  are computed from data
	else if strflag[1]=='0' the previous values 
                (previous call or defaut values) are used 

     if  strflag[2] == '1' ->then an axis is added
        the number of intervals 
        is specified by the vector aaint[4] of integers 
	   <aaint[0],aaint[1]> specifies the x-axis number of  points 
	   <aaint[2],aaint[3]> same for y-axis
     if  strflag[2] == '2' -> no axis, only a box around the curves
     else no box and no axis 

 lstr : unused ( but used by Fortran ) 
--------------------------------------------------------------------------*/
extern char GetDriver_();
  
C2F(plot2d)(x,y,n1,n2,style,strflag,legend,brect,aaint,lstr1,lstr2)
     double x[],y[],brect[];
     int   *n1,*n2,style[],aaint[];
     char legend[],strflag[];
     long int lstr1,lstr2;
{
  static double xmax=10.0,xmin=0.0,ymin= -10.0,ymax=0.0;
  double FRect[4],scx,scy,xofset,yofset;
  int IRect[4],IRect1[4],err=0,*xm,*ym,job=1;

  /* Storing values if using the Record driver */
  if (GetDriver_()=='R') 
    StorePlot("plot2d1","gnn",x,y,n1,n2,style,strflag,legend,brect,aaint);
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
	  xmax=  (double) Maxi(x,(*n1)*(*n2));
	  xmin=  (double) Mini(x,(*n1)*(*n2));
	  ymax=  (double) - Mini(y,(*n1)*(*n2));
	  ymin=  (double) - Maxi(y,(*n1)*(*n2));
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
Scale2D(job,FRect,IRect,&scx,&scy,&xofset,&yofset,&xm,&ym,(*n1)*(*n2),&err);
  if ( err == 0) return;

C2F(echelle2d)(x,y,xm,ym,n1,n2,IRect,"f2i",3L);
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

/** Drawing the curves **/

C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
    ,IP0,IP0,0,0);
C2F(dr)("xpolys","v",xm,ym,style,n1,n2,
    IP0,0,0);
IRect1[0]=IRect1[1]= -1;IRect1[2]=IRect1[3]=200000;
C2F(dr)("xset","clipping",&IRect1[0],&IRect1[1],&IRect1[2],&IRect1[3]
    ,IP0,IP0,0,0);

/** Drawing the Legends **/
if ((int)strlen(strflag) >=1  && strflag[0] == '1')
    Legends(IRect,style,n1,legend);
}

/*----------------------------------------------------
  legend="leg1@leg2@leg3@...."             
  legend contain legends separated by '@'
  if nlegend is the number of legends stored in legend
  then the function Legends draw  Min(*n1,6,nlegends) legends
-----------------------------------------------------*/

Legends(IRect,style,n1,legend)
     int style[],*n1,IRect[4];
     char legend[];
{
char *leg,*loc;
double xi,yi,xoffset,yoffset;  
int i;
loc=(char *) malloc((unsigned) (strlen(legend)+1)*sizeof(char));
if ( loc != 0)
  {
    strcpy(loc,legend);
    xoffset= IRect[2]/12.0;
    yoffset= IRect[3]/40.0;
    xi= IRect[0];
    for ( i = 0 ; i < *n1 && i < 6 ; i++)
      {  int xs,ys,flag,polyx[2],polyy[2],lstyle[1],ni;
	 double angle;
	 if (*n1 == 1) ni=Max(Min(5,style[1]-1),0);else ni=i;
	 if (ni >= 3)
	   { xi=IRect[0]+IRect[2]/2;
	     yi=IRect[1]+IRect[3]+(ni-3)*yoffset+4*yoffset;}
	 else
	   { yi=IRect[1]+IRect[3]+(ni)*yoffset+4*yoffset;
	   }
	 xs=nint(xi+1.2*xoffset),ys=yi+yoffset/4,angle=0.0;flag=0;
	 if ( i==0) leg=strtok(loc,"@"); else leg=strtok((char *)0,"@");
	 if (leg != 0) 
	   {
	     C2F(dr)("xstring",leg,&xs,&ys,(int *)&angle,&flag
		     ,IP0,IP0,0,0);
	     if (style[i] < 0)
	       { int n,p;
		 polyx[0]=nint(xi);polyx[1]=nint(xi+xoffset);
		 polyy[0]=yi;polyy[1]=yi;
		 lstyle[0]=style[i];
		 p=2;n=1;
		 C2F(dr)("xpolys","v",polyx,polyy,lstyle,&n,&p
		     ,IP0,0,0);
	       }
	     else
	       { int n,p;
		 polyx[0]=nint(xi+xoffset);
		 polyy[0]=yi;
		 lstyle[0]=style[i];
		 p=1;n=1;
		 C2F(dr)("xpolys","v",polyx,polyy,lstyle,&n,&p
		     		     ,IP0,0,0);
	       }
	   }
       }
    free(loc);
  }
else
  {
    Scistring("Legends : No more Place to store Legends\n");
  }
}
