
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

/*-------------BEGIN--------------------------------------------------------
\section{ Partie generale : permettant d'appeller les primitives de dessin 
 qui travaillent en coordonnees relatives}
---------------------------------------------------------------------------*/
#include <string.h>
#include <stdio.h>

#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "Math.h"
#include <math.h>

extern char GetDriver_();

typedef  struct  {
  char *name;
  int  (*fonc)();} OpTab ;

int drawarc_1();
int fillarcs_1();
int drawarcs_1();
int fillpolyline_1();
int drawaxis_1();
int cleararea_1();
int xclick_1();
int xclick_any_1();
int fillarc_1();
int fillrectangle_1();
int drawpolyline_1();
int fillpolylines_1();
int drawpolylines_1();
int drawpolymark_1();
int displaynumbers_1();
int drawrectangle_1();
int drawrectangles_1();
int drawsegments_1();
int displaystring_1();
int displaystringa_1();
int boundingbox_1();
int drawarrows_1();
int xset_1();
int xgetmouse_1();

extern int C2F(dr)();

OpTab keytab_1[] ={
  "xarc",drawarc_1,
  "xarcs", drawarcs_1,
  "xarea",fillpolyline_1,
  "xarrow",drawarrows_1,
  "xaxis",drawaxis_1,
  "xclea", cleararea_1,
  "xclear",C2F(dr),
  "xclick",xclick_1,
  "xclickany",xclick_any_1,
  "xend", C2F(dr),
  "xfarc",fillarc_1,
  "xfarcs",fillarcs_1,
  "xfrect",fillrectangle_1,
  "xget",C2F(dr),
  "xgetdr",C2F(dr),
  "xgetmouse",xgetmouse_1,
  "xinit",C2F(dr),
  "xlfont",C2F(dr),
  "xlines",drawpolyline_1,
  "xliness",fillpolylines_1,
  "xmarks",drawpolymark_1,
  "xnum",displaynumbers_1,
  "xpause", C2F(dr),
  "xpolys", drawpolylines_1,
  "xrect",drawrectangle_1,
  "xrects",drawrectangles_1,
  "xreplay",C2F(dr),
  "xsegs",drawsegments_1,
  "xselect",C2F(dr),
  "xset",xset_1,
  "xsetdr",C2F(dr),
  "xstart",C2F(dr),
  "xstring",displaystring_1,
  "xstringa",displaystringa_1,
  "xstringl",boundingbox_1,
  (char *)NULL,(int (*)()) 0};

#ifdef lint 

test_dr1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1)
     char x0[],x1[];
     integer *x2,*x3,*x4,*x5,*x6,*x7;
     integer lx0,lx1;
     double *dx1,*dx2,*dx3,*dx4;
{
  C2F(dr)(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawarc_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  fillarcs_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  fillpolyline_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawarrows_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawaxis_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  cleararea_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  xclick_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  xclick_any_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  fillarc_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  fillrectangle_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  xgetmouse_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawpolyline_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  fillpolylines_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawpolymark_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  displaynumbers_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawpolylines_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawrectangle_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawrectangles_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  drawsegments_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  xset_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  displaystring_1(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
  boundingbox_1(x0,x1, x2, x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
}

#endif 



C2F(dr1)(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1)
     char x0[],x1[];
     integer *x2,*x3,*x4,*x5,*x6,*x7;
     integer lx0,lx1;
     double *dx1,*dx2,*dx3,*dx4;
{ 
  int i=0;
/*  fprintf(stderr,"\ndr1 [%s,%s] [%d,%d,%d,%d,%d,%d],[%d,%d]",
	  x0,x1,*x2,*x3,*x4,*x5,*x6,*x7,lx0,lx1); */
  while ( keytab_1[i].name != (char *) 0)
     {
       int j;
       j = strcmp(x0,keytab_1[i].name);
       if ( j == 0 ) 
	 { 
	   (*(keytab_1[i].fonc))(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
	   return;
	 }
       else 
	 { if ( j <= 0)
	     {
	       sciprint("\nUnknow X operator <%s>\r\n",x0);
	       return;
	     }
	   else i++;
	 }
     }
  sciprint("\n Unknow X operator <%s>\r\n",x0);
}

static integer Ivide=0;
static double   Dvide=0;

/** a verifier ds le futur : les arguments de xset_1 
  sont supposes int* et donc stockes en tant que int 
  sauf pour "clipping" ou se sont des flottants 
  ca pose un pb avec StoreXcall1 sur dec:alpha 
  c'est pour quoi une chose particuliere est faite 
  verifier ds xset qu'il n'y a pas de gags du meme genre 
**/

xset_1(fname,str,x1,x2,x3,x4,x5,x6,dx1,dx2,dx3,dx4,lx0,lx1)
     double *dx1,*dx2,*dx3,*dx4;
     char str[],fname[];
     integer *x1,*x2,*x3,*x4,*x5,*x6;
     integer lx0,lx1;
{
  /** we must not record wdim and wpos **/
  if (GetDriver_()=='R' && strcmp(str,"wdim")!=0 && strcmp(str,"wpos")!=0)
    StoreXcall1(fname,str,x1,1L,x2,1L,x3,1L,x4,1L,x5,1L,x6,1L,dx1,1L,dx2,1L,dx3,1L,dx4,1L);
  if (strcmp(str,"clipping")==0)
    {
      /** and clipping is special its args are floats **/
      integer xx1,yy1,w1,h1,n=1,rect[4];
      C2F(echelle2d)(dx1,dx2,&xx1,&yy1,&n,&n,rect,"f2i",3L);
      echelle2dl_(dx3,dx4,&w1,&h1,&n,&n,rect,"f2i");
      C2F(dr)(fname,str,&xx1,&yy1,&w1,&h1,x5,x6,dx1,dx2,dx3,dx4,lx0,lx1);
    }
  else
    {
      if (strcmp(str,"clipping-p")==0) 
	{
	  /* clip given in pixel */
	  C2F(dr)(fname,"clipping",x1,x2,x3,x4,x5,x6,dx1,dx2,dx3,dx4,lx0,lx1);
	}
      else
	{
	  if (strcmp(str,"clipgrf")==0)
	    {
	      /** getting clip rect **/
	      integer n=0,rect[4];
	      C2F(echelle2d)(dx1,dx2,x1,x2,&n,&n,rect,"f2i",3L);
	      C2F(dr)("xset","clipping",&rect[0],&rect[1],&rect[2],&rect[3]
		      ,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	    }
	  else
	    C2F(dr)(fname,str,x1,x2,x3,x4,x5,x6,dx1,dx2,dx3,dx4,lx0,lx1);
	}
    }
}

drawarc_1(fname,str,v1,v2,v3,v4,angle1,angle2,x,y,width,height,lx0,lx1)
     integer *v1,*v2,*v3,*v4;
     char fname[],str[];
     integer *angle1,*angle2;
     double *x, *y, *width, *height;
     integer lx0,lx1;
{ 
  integer x1,yy1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(width,height,&w1,&h1,&n,&n,rect,"f2i"); 
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,angle1,1L,angle2,1L,x,1L,y,1L,width,1L,height,1L);
  C2F(dr)(fname,str,&x1,&yy1,&w1,&h1,angle1,angle2,PD0,PD0,PD0,PD0,lx0,lx1);
}

fillarcs_1(fname,str,v1,fillvect,n,x6,x7,x8,vects,dx2,dx3,dx4,lx0,lx1)
     double *dx2,*dx3,*dx4;
     char fname[],str[];
     double *vects;
     integer *fillvect, *n,*x6,*x7,*x8,*v1;
     integer lx0,lx1;
{
  integer *xm,err=0,n2;
  Myalloc1(&xm,6*(*n),&err);
  if (err ==  1) return;
  ellipse2d_(vects,xm,(n2=6*(*n),&n2),"f2i");
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,fillvect,*n,n,1L,&Ivide,1L,&Ivide,1L,&Ivide,1L,vects,6*(*n),dx2,1L,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,fillvect,n,x6,x7,x8,PD0,dx2,dx3,dx4,lx0,lx1);
}

drawarcs_1(fname,str,v1,style,n,x6,x7,x8,vects,dx2,dx3,dx4,lx0,lx1)
     double *dx2,*dx3,*dx4;
     char fname[],str[];
     double *vects;
     integer *style, *n,*x6,*x7,*x8,*v1;
     integer lx0,lx1;
{
  integer *xm,err=0,n2;
  Myalloc1(&xm,6*(*n),&err);
  if (err ==  1) return;
  ellipse2d_(vects,xm,(n2=6*(*n),&n2),"f2i");
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,style,*n,n,1L,&Ivide,1L,&Ivide,1L,&Ivide,1L,vects,6*(*n),dx2,1L,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,style,n,x6,x7,x8,PD0,dx2,dx3,dx4,lx0,lx1);
}

fillpolyline_1(fname,str,n, v1, v2,closeflag,x7,x8,vx,vy,dx3,dx4,lx0,lx1)
     double *dx3,*dx4;
     integer lx0,lx1;
     integer *x7,*x8,*v1,*v2;
     char fname[],str[];
     integer *n,*closeflag;
     double *vx,*vy;
{
  integer *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,n,1L,v1,1L,v2,1L,closeflag,1L,&Ivide,1L,&Ivide,1L,vx,*n,vy,*n,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,n,xm,ym,closeflag,x7,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}


drawarrows_1(fname,str,style,iflag,n,v3,x7,x8,vx,vy,as,dx4,lx0,lx1)
     double *dx4;
     integer *style,*iflag,*v3;
     integer lx0,lx1;
     integer *x7,*x8;
     char fname[], str[];
     integer *n;
     double vx[],vy[];
     double *as;
{ 
  integer *xm,*ym,err=0,n2=1,rect[4],n1=1,ias,ias1;
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  /* is as < 0 --> not set */
  if ( *as < 0.0 ) 
    {
      int i;
      double Mnorm=0.0;
      for (i=0 ; i < *n/2 ; i++)
	{ 
	  double dx,dy;
	  dx=( vx[2*i+1]-vx[2*i]);
	  dy=( vy[2*i+1]-vy[2*i]);
	  Mnorm += sqrt(dx*dx+dy*dy);
	}
      if ( *n != 0) 
	Mnorm /= (*n/2);
      *as = Mnorm/5.0;
    }
  echelle2dl_(as,as,&ias,&ias1,&n1,&n1,rect,"f2i"); 
  if (GetDriver_()=='R') 
    {
      if ( (int) *iflag== 1) 
	StoreXcall1(fname,str,style,*n,iflag,1L,n,1L,v3,1L,&Ivide,1L,&Ivide,1L,vx,*n,vy,*n,as,1L,dx4,1L);
      else 
	StoreXcall1(fname,str,style,1L,iflag,1L,n,1L,v3,1L,&Ivide,1L,&Ivide,1L,vx,*n,vy,*n,as,1L,dx4,1L);
    }
  ias=10*ias;
  C2F(dr)(fname,str,xm,ym,n,&ias,style,iflag,PD0,PD0,PD0,dx4,lx0,lx1);
}



drawaxis_1(fname,str,v1,nsteps,v2,v3,x7,x8,alpha,size,initpoint,dx4,lx0,lx1)
     integer lx0,lx1;
     integer *x7,*x8,*v1,*v2,*v3;
     char fname[],str[];
     double *alpha,*initpoint,*dx4;
     integer *nsteps;
     double *size;
{
  integer initpoint1[2],alpha1;
  double size1[3];
  alpha1=inint( *alpha);
  axis2d_(alpha,initpoint,size,initpoint1,size1);  
  if (GetDriver_()=='R') 
    Scistring("Store To be done ...\n");	
  C2F(dr)(fname,str,&alpha1,nsteps,PI0,initpoint1,x7,x8,size1,PD0,PD0,PD0,lx0,lx1);
}


cleararea_1(fname,str,v1,v2,v3,v4,x7,x8,x,y,w,h,lx0,lx1)
     integer *v1,*v2,*v3,*v4;
     integer lx0,lx1;
     integer *x7,*x8;
     char fname[],str[];
     double *x,*y,*w,*h;
{
  integer x1,yy1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(w,h,&w1,&h1,&n,&n,rect,"f2i"); 
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,&Ivide,1L,&Ivide,1L,x,1L,y,1L,w,1L,h,1L);
  C2F(dr)(fname,str,&x1,&yy1,&w1,&h1,x7,x8,PD0,PD0,PD0,PD0,lx0,lx1);
}

xclick_1(fname,str,ibutton,v1,v2,x5,x6,x7,x,y,dx3,dx4,lx0,lx1)
     double *dx3,*dx4;
     integer lx0,lx1;
     integer *v1,*v2,*x5,*x6,*x7;
     char str[],fname[];
     integer *ibutton;
     double *x,*y ;
{ 
  integer x1,yy1,n=1,rect[4];
  C2F(dr)(fname,str,ibutton,&x1,&yy1,x5,x6,x7,PD0,PD0,dx3,dx4,lx0,lx1);
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,rect,"i2f",3L);
}

xclick_any_1(fname,str,ibutton,iwin,v2,x5,x6,x7,x,y,dx3,dx4,lx0,lx1)
     double *dx3,*dx4;
     integer lx0,lx1;
     integer *v2,*x5,*x6,*x7;
     char str[],fname[];
     integer *ibutton,*iwin;
     double *x,*y ;
{ 
  integer x1,y1,n=1,rect[4];
  integer verb=0,cur,na;
  C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)(fname,str,ibutton,&x1,&y1,iwin,x6,x7,PD0,PD0,PD0,PD0,lx0,lx1);
  C2F(dr)("xset","window",iwin,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"i2f",3L);
  C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}


xgetmouse_1(fname,str,ibutton,v1,v2,x5,x6,x7,x,y,dx3,dx4,lx0,lx1)
     double *dx3,*dx4;
     integer lx0,lx1;
     integer *v1,*v2,*x5,*x6,*x7;
     char str[],fname[];
     integer *ibutton;
     double *x,*y ;
{ 
  integer x1,yy1,n=1,rect[4];
  C2F(dr)(fname,str,ibutton,&x1,&yy1,x5,x6,x7,PD0,PD0,dx3,dx4,lx0,lx1);
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,rect,"i2f",3L);
}


fillarc_1(fname,str,v1,v2,v3,v4,angle1,angle2,x,y,width,height,lx0,lx1)
     integer *v1,*v2,*v3,*v4;
     integer lx0,lx1;
     char fname[],str[];
     integer *angle1,*angle2;
     double *x, *y, *width, *height;
{ 
  integer x1,yy1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(width,height,&w1,&h1,&n,&n,rect,"f2i"); 
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,
	angle1,1L,angle2,1L,x,1L,y,1L,width,1L,height,1L);
  C2F(dr)(fname,str,&x1,&yy1,&w1,&h1,angle1,angle2,PD0,PD0,PD0,PD0,lx0,lx1);
}

fillrectangle_1(fname,str,v1,v2,v3,v4,x7,x8,x,y,width,height,lx0,lx1)
     integer *v1,*v2,*v3,*v4;
     integer lx0,lx1;
     integer* x7,*x8;
     char str[],fname[];
     double  *x, *y, *width, *height;
{ 
  integer x1,yy1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(width,height,&w1,&h1,&n,&n,rect,"f2i"); 
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,
				&Ivide,1L,&Ivide,1L,x,1L,y,1L,width,1L,height,1L);
  C2F(dr)(fname,str,&x1,&yy1,&w1,&h1,x7,x8,PD0,PD0,PD0,PD0,lx0,lx1);
}



drawpolyline_1(fname,str,n,v1,v2,closeflag,x7,x8,vx,vy,dx3,dx4,lx0,lx1)
     double *dx3,*dx4;
     integer lx0,lx1;
     integer *v1,*v2,*x7,*x8;
     char fname[],str[];
     integer *n,*closeflag;
     double *vx,*vy;
{
  integer *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,n,1L,v1,1L,v2,1L,closeflag,1L,
				&Ivide,1L,&Ivide,1L,vx,*n,vy,*n,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,n,xm,ym,closeflag,x7,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}


fillpolylines_1(fname,str,v1,v2,fillvect,n,p,x8,vx,vy,dx3,dx4,lx0,lx1)
     double *dx3,*dx4;
     integer lx0,lx1;
     integer *v1,*v2,*x8;
     char fname[],str[];
     integer *n,*p,fillvect[];
     double *vx,*vy;
{
  integer *xm,*ym,err=0,rect[4];
  Myalloc(&xm,&ym,(*n)*(*p),&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,p,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,fillvect,*n,
	n,1L,p,1L,&Ivide,1L,vx,(*n)*(*p),vy,(*n)*(*p),dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,ym,fillvect,n,p,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}

drawpolymark_1(fname,str,n, v1, v2,x6,x7,x8,vx,vy,dx3,dx4,lx0,lx1)
     double *dx3,*dx4;
     integer lx0,lx1;
     integer *v1,*v2,*x6,*x7,*x8;
     char fname[],str[];
     integer *n;
     double *vx,*vy;
{
  integer *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,n,1L,v1,1L,v2,1L,
		&Ivide,1L,&Ivide,1L,&Ivide,1L,vx,(*n),vy,(*n),dx3,1L,dx4,1L);
  C2F(dr)(fname,str,n,xm,ym,x6,x7,x8,PD0,PD0,dx3,dx4,lx0,lx1);

}

displaynumbers_1(fname,str,v1,v2,v3,v4,n,flag,x,y,z,alpha,lx0,lx1)
     integer *v1,*v2,*v3,*v4;
     integer lx0,lx1;
     char fname[],str[];
     integer *flag,*n;
     double x[],y[],z[],alpha[];
{
  integer *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(x,y,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,n,1L,flag,1L,x,(*n),y,(*n),z,*n,alpha,*n);
  C2F(dr)(fname,str,xm,ym,PI0,PI0,n,flag,z,alpha,PD0,PD0,lx0,lx1);
}

drawpolylines_1(fname,str,v1,v2,drawvect,n,p,x8,vx,vy,dx3,dx4,lx0,lx1)
     integer lx0,lx1;
     integer *x8;
     char fname[],str[];
     integer *n,*p,drawvect[];
     integer *v1,*v2;
     double vx[],vy[],*dx3,*dx4;
{
  integer *xm,*ym,err=0,rect[4];
  Myalloc(&xm,&ym,(*n)*(*p),&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,p,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,drawvect,*n,n,1L,p,1L,&Ivide,1L,vx,(*n)*(*p),vy,(*n)*(*p),dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,ym,drawvect,n,p,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}

drawrectangle_1(fname,str,v1,v2,v3,v4,x7,x8,x,y,w,h,lx0,lx1)
     integer *v1,*v2,*v3,*v4;
     integer lx0,lx1;
     integer *x7,*x8;
     char fname[],str[];
     double *x,*y,*w,*h;
{
  integer xm[4],n2=4;
  double vect[4];
  vect[0]=*x;vect[1]=*y;vect[2]=*w;vect[3]=*h;
  rect2d_(vect,xm,&n2,"f2i");
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,&Ivide,1L,&Ivide,1L,x,1L,y,1L,w,1L,h,1L);
  C2F(dr)(fname,str,xm,xm+1,xm+2,xm+3,x7,x8,PD0,PD0,PD0,PD0,lx0,lx1);
}

drawrectangles_1(fname,str,v1,fillvect,n,x6,x7,x8,vects,dx2,dx3,dx4,lx0,lx1)
     double *dx2,*dx3,*dx4;
     integer lx0,lx1;
     integer *v1,*x6,*x7,*x8;
     char fname[],str[];
     double *vects;
     integer fillvect[],*n;
{
  integer *xm,err=0,n2;
  Myalloc1(&xm,4*(*n),&err);
  if (err ==  1) return;
  rect2d_(vects,xm,(n2=4*(*n),&n2),"f2i");
  if (GetDriver_()=='R') 
	StoreXcall1(fname,str,v1,1L,fillvect,*n,n,1L,
		&Ivide,1L,&Ivide,1L,&Ivide,1L,vects,4*(*n),dx2,1L,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,fillvect,n,x6,x7,x8,PD0,dx2,dx3,dx4,lx0,lx1);
}

drawsegments_1(fname,str,style,iflag,n,x6,x7,x8,vx,vy,dx3,dx4,lx0,lx1)
     double *dx3,*dx4;
     integer lx0,lx1;
     integer *style,*iflag, *x6,*x7,*x8;
     char fname[], str[];
     integer  *n;
     double vx[],vy[];
{ 
  integer *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
    {
      if ( (int) *iflag== 1) 
	StoreXcall1(fname,str,style,*n,iflag,1L,n,1L,
		    &Ivide,1L,&Ivide,1L,&Ivide,1L,vx,(*n),vy,*n,dx3,1L,dx4,1L);
      else 
	StoreXcall1(fname,str,style,1L,iflag,1L,n,1L,
		    &Ivide,1L,&Ivide,1L,&Ivide,1L,vx,(*n),vy,*n,dx3,1L,dx4,1L);
    }
  C2F(dr)(fname,str,xm,ym,n,style,iflag,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}

displaystring_1(fname,string,v1,v2,v3,flag,x7,x8,x,y,angle,dx4,lx0,lx1)
     double *dx4;
     integer lx0,lx1;
     integer *v1,*v2,*v3,*x7,*x8;
     integer *flag;
     double *angle,*x,*y;
     char string[],fname[] ;
{
  integer x1,yy1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,rect,"f2i",3L);  
  if (GetDriver_()=='R') 
	StoreXcall1(fname,string,v1,1L,v2,1L,v3,1L,flag,1L,&Ivide,1L,&Ivide,1L,x,1L,y,1L,angle,1L,dx4,1L);
  C2F(dr)(fname,string,&x1,&yy1,PI0,flag,x7,x8,angle,PD0,PD0,dx4,lx0,lx1);
}

displaystringa_1(fname,string,ipos,v2,v3,v4,x7,x8,dx1,dx2,dx3,dx4,lx0,lx1)
     double *dx1,*dx2,*dx3,*dx4;
     integer lx0,lx1;
     integer *ipos,*v2,*v3,*v4,*x7,*x8;
     char string[],fname[] ;
{
  integer n=0,rect[4];
  if (GetDriver_()=='R') 
	StoreXcall1(fname,string,ipos,1L,v2,1L,v3,1L,v4,1L,&Ivide,1L,&Ivide,1L,dx1,1L,dx2,1L,dx3,1L,dx4,1L);
  C2F(echelle2d)(PD0,PD0,PI0,PI0,&n,&n,rect,"f2i",3L);  
  switch ( *ipos )
    {
    case 1:
      xstringb(string,rect[0],rect[1],rect[2],rect[3]/6);
      break;
    case 2:
      xstringb(string,rect[0]+rect[2],rect[1]+rect[3],rect[2]/6,rect[3]/6);
      break;
    case 3:
      xstringb(string,rect[0],rect[1],rect[2]/6,rect[3]/12);
      break;
    }
}

/* display a set of lines coded with 'line1@line2@.....@'
   centred in the rectangle [x,y,w=wide,h=height] 
*/

xstringb(string,x,y,w,h)
     char string[];
     integer x,y,w,h;
{
  char *loc,*loc1;
  loc= (char *) MALLOC( (strlen(string)+1)*sizeof(char));
  if ( loc != 0)
    {
      integer wmax=0,htot=0,x1=0,yy1=0,rect[4];
      strcpy(loc,string);
      loc1=strtok(loc,"@");
      while ( loc1 != ( char * ) 0) 
	{  
	  C2F(dr)("xstringl",loc1,&x1,&yy1,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  if ( rect[2] >= wmax ) wmax=rect[2];
	  htot += 1.2*rect[3];
	  loc1=strtok((char *) 0,"@");
	}
      x1=x+ (w- wmax)/2;
      yy1=y - h + ( h - htot)/2 + rect[3];
      strcpy(loc,string);
      loc1=strtok(loc,"@");
      while ( loc1 != ( char * ) 0) 
	{  
	  double angle=0.0;
	  integer flag=0;
	  C2F(dr)("xstring",loc1,&x1,&yy1,PI0,&flag,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L);
	  yy1=yy1+ 1.2*rect[3];
	  loc1=strtok((char *) 0,"@");
	}
      FREE(loc);
    }
  else
    {
      Scistring("xstring : No more Place  \n");
    }
}


/** To get the bounding rectangle of a string **/

boundingbox_1(fname,string,v1,v2,v3,x6,x7,x8,x,y,rect,dx4,lx0,lx1)
     double *dx4;
     integer lx0,lx1;
     integer *v1,*v2,*v3,*x6,*x7,*x8;
     double *x,*y,*rect;
     char string[],fname[];
{ 
  integer x1,yy1,n=1,rect1[4],rect2[4];
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,rect2,"f2i",3L);  
  C2F(dr)(fname,string,&x1,&yy1,rect1,x6,x7,x8,PD0,PD0,PD0,dx4,lx0,lx1);
  C2F(echelle2d)(rect,rect+1,rect1,rect1+1,&n,&n,rect2,"i2f",3L);
  echelle2dl_(rect+2,rect+3,rect1+2,rect1+3,&n,&n,rect2,"i2f");
}

Myalloc(xm,ym,n,err)
     integer **xm,**ym,n,*err;
{
  static integer firstentry=1,*xm1,*ym1;
  if ( n != 0) 
    {
      if ( firstentry )
	{
	  *xm=xm1= (integer *) MALLOC( n*sizeof(integer));
	  *ym=ym1= (integer *) MALLOC( n*sizeof(integer));
	  firstentry=0;
	}
      else 
	{
	  *xm=xm1= (integer *) REALLOC(xm1, n*sizeof(integer));
	  *ym=ym1= (integer *) REALLOC(ym1, n*sizeof(integer));
	}
      
      if ( xm1 == 0 || ym1 == 0 )
	{
	  Scistring("malloc : No more Place\n");
	  *err=1;
	}
    }
}


Myalloc1(xm,n,err)
     integer **xm,n,*err;
{
  static integer firstentry=1,*xm1;
  if ( n != 0) 
    {
      if ( firstentry )
	{
	  *xm=xm1= (integer *) MALLOC( n*sizeof(integer));
	  firstentry=0;
	}
      else 
	{
	  *xm=xm1= (integer *) REALLOC(xm1, n*sizeof(integer));
	}
      
      if ( xm1 == 0  )
	{
	  Scistring("malloc : No more Place\n");
	  *err=1;
	}
    }
}








