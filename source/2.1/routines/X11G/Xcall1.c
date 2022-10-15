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
#include "../machine.h"

#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <math.h>
#include "Math.h"


extern char GetDriver_();

#define STOREXCALL1(fname,string,x1,n1,c1,x2,n2,c2,x3,n3,c3,x4,n4,c4,x5,n5,c5,x6,n6,c6) StoreXcall1(fname,string,(char *) x1,n1,c1,(char *) x2,n2,c2,(char *) x3,n3,c3,(char *) x4,n4,c4,(char *) x5,n5,c5,(char *) x6,n6,c6)

typedef  struct  {
  char *name;
  int  (*fonc)();} OpTab ;

int drawarc_1();
int drawarcs_1();
int fillpolyline_1();
int drawaxis_1();
int cleararea_1();
int xclick_1();
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
  "xend", C2F(dr),
  "xfarc",fillarc_1,
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
  "xstringl",boundingbox_1,
  (char *)NULL,(int (*)()) 0};

C2F(dr1)(x0,x1,x2,x3,x4,x5,x6,x7,lx0,lx1)
     char x0[],x1[];
     int *x2,*x3,*x4,*x5,*x6,*x7;
     int lx0,lx1;
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
	   (*(keytab_1[i].fonc))(x0,x1,x2,x3,x4,x5,x6,x7,lx0,lx1);
	   return;
	 }
       else 
	 { if ( j <= 0)
	     {
	       SciF1s("\nUnknow X operator <%s>\r\n",x0);
	       return;
	     }
	   else i++;
	 }
     }
  SciF1s("\n Unknow X operator <%s>\r\n",x0);
}

static int Ivide=0;

/** a verifier ds le futur : les arguments de xset_1 
  sont supposes int* et donc stockes en tant que int 
  sauf pour "clipping" ou se sont des flottants 
  ca pose un pb avec STOREXCALL1 sur dec:alpha 
  c'est pour quoi une chose particuliere est faite 
  verifier ds xset qu'il n'y a pas de gags du meme genre 
**/


xset_1(fname,str,x1,x2,x3,x4,x5,x6,lx0,lx1)
     char str[],fname[];
     int *x1,*x2,*x3,*x4,*x5,*x6;
     int lx0,lx1;
{

  if (strcmp(str,"clipping")==0)
    {

      int xx1,yy1,w1,h1,n=1,rect[4];
      /** we must not record wdim and wpos **/
      /** and clipping is special its args are floats **/
      if (GetDriver_()=='R' && strcmp(str,"wdim")!=0 && strcmp(str,"wpos")!=0)
	STOREXCALL1(fname,str,x1,1,'f',x2,1,'f',x3,1,'f',x4,1,'f',&Ivide,1,'i',
		    &Ivide,1,'i');
      C2F(echelle2d)((double *)x1,(double *)x2,&xx1,&yy1,&n,&n,rect,"f2i",3L);
      echelle2dl_((double *) x3,(double *) x4,&w1,&h1,&n,&n,rect,"f2i");
      C2F(dr)(fname,str,&xx1,&yy1,&w1,&h1,x5,x6,lx0,lx1);
    }
  else
    {
      /** we must not record wdim and wpos **/
      if (GetDriver_()=='R' && strcmp(str,"wdim")!=0 && strcmp(str,"wpos")!=0)
	STOREXCALL1(fname,str,x1,1,'i',x2,1,'i',x3,1,'i',x4,1,'i',x5,1,'i',
		    &Ivide,1,'i');
      if (strcmp(str,"clipping-p")==0) 
	/* clip given in pixel */
	C2F(dr)(fname,"clipping",x1,x2,x3,x4,x5,x6,lx0,lx1);
      else
	C2F(dr)(fname,str,x1,x2,x3,x4,x5,x6,lx0,lx1);
    }
}

drawarc_1(fname,str,x,y,width,height,angle1,angle2,lx0,lx1)
     char fname[],str[];
     int *angle1,*angle2;
     double*x, *y, *width, *height;
     int lx0,lx1;
{ 
  int x1,y1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(width,height,&w1,&h1,&n,&n,rect,"f2i"); 
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,x,1,'f',y,1,'f',width,1,'f',height,1,'f',
	angle1,1,'i',angle2,1,'i');
  C2F(dr)(fname,str,&x1,&y1,&w1,&h1,angle1,angle2,lx0,lx1);
}

drawarcs_1(fname,str,vects,fillvect,n,x6,x7,x8,lx0,lx1)
     char fname[],str[];
     double *vects;
     int *fillvect, *n,*x6,*x7,*x8;
     int lx0,lx1;
{
  int *xm,err=0,n2;
  Myalloc1(&xm,6*(*n),&err);
  if (err ==  1) return;
  ellipse2d_(vects,xm,(n2=6*(*n),&n2),"f2i");
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,vects,6*(*n),'f',fillvect,*n,'i',n,1,'i',
		&Ivide,1,'i',&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,xm,fillvect,n,x6,x7,x8,lx0,lx1);


}

fillpolyline_1(fname,str,n, vx, vy,closeflag,x7,x8,lx0,lx1)
     int lx0,lx1,*x7,*x8;
     char fname[],str[];
     int *n,*closeflag;
     double *vx,*vy;
{
  int *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,n,1,'i',vx,*n,'f',vy,*n,'f',closeflag,1,'i',
		&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,n,xm,ym,closeflag,x7,x8,lx0,lx1);
}



drawarrows_1(fname,str,vx,vy,n,as,x7,x8,lx0,lx1)
     int lx0,lx1,*x7,*x8;
     char fname[], str[];
     int *n;
     double vx[],vy[];
     double *as;
{ 
  int *xm,*ym,err=0,n2=1,rect[4],n1=1,ias,ias1;
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
	STOREXCALL1(fname,str,vx,*n,'f',vy,*n,'f',n,1,'i',as,1,'f',
		&Ivide,1,'i',&Ivide,1,'i');
  ias=10*ias;
  C2F(dr)(fname,str,xm,ym,n,&ias,x7,x8,lx0,lx1);
};



drawaxis_1(fname,str,alpha,nsteps,size,initpoint,x7,x8,lx0,lx1)
     int lx0,lx1,*x7,*x8;
     char fname[],str[];
     int *alpha,*nsteps,*initpoint;
     double *size;
{
  Scistring("To be done ...\n");
}

cleararea_1(fname,str,x,y,w,h,x7,x8,lx0,lx1)
     int lx0,lx1,*x7,*x8;
     char fname[],str[];
     double *x,*y,*w,*h;
{
  int x1,y1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(w,h,&w1,&h1,&n,&n,rect,"f2i"); 
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,x,1,'f',y,1,'f',w,1,'f',h,1,'f',
				&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,&x1,&y1,&w1,&h1,x7,x8,lx0,lx1);
}

xclick_1(fname,str,ibutton,x,y,x5,x6,x7,lx0,lx1)
     int lx0,lx1,*x5,*x6,*x7;
     char str[],fname[];
     int *ibutton;
     double *x,*y ;
{ 
  int x1,y1,n=1,rect[4];
  C2F(dr)(fname,str,ibutton,&x1,&y1,x5,x6,x7,lx0,lx1);
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"i2f",3L);
}
xgetmouse_1(fname,str,ibutton,x,y,x5,x6,x7,lx0,lx1)
     int lx0,lx1,*x5,*x6,*x7;
     char str[],fname[];
     int *ibutton;
     double *x,*y ;
{ 
  int x1,y1,n=1,rect[4];
  C2F(dr)(fname,str,ibutton,&x1,&y1,x5,x6,x7,lx0,lx1);
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"i2f",3L);
}


fillarc_1(fname,str,x,y,width,height,angle1,angle2,lx0,lx1)
     int lx0,lx1;
     char fname[],str[];
     int *angle1,*angle2;
     double*x, *y, *width, *height;
{ 
  int x1,y1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(width,height,&w1,&h1,&n,&n,rect,"f2i"); 
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,x,1,'f',y,1,'f',width,1,'f',height,1,'f',
	angle1,1,'i',angle2,1,'i');
  C2F(dr)(fname,str,&x1,&y1,&w1,&h1,angle1,angle2,lx0,lx1);
}

fillrectangle_1(fname,str,x,y,width,height,x7,x8,lx0,lx1)
     int lx0,lx1,*x7,*x8;
     char str[],fname[];
     double  *x, *y, *width, *height;
{ 
  int x1,y1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(width,height,&w1,&h1,&n,&n,rect,"f2i"); 
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,x,1,'f',y,1,'f',width,1,'f',height,1,'f',
				&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,&x1,&y1,&w1,&h1,x7,x8,lx0,lx1);
}



drawpolyline_1(fname,str,n, vx, vy,closeflag,x7,x8,lx0,lx1)
     int lx0,lx1,*x7,*x8;
     char fname[],str[];
     int *n,*closeflag;
     double *vx,*vy;
{
  int *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,n,1,'i',vx,*n,'f',vy,*n,'f',closeflag,1,'i',
				&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,n,xm,ym,closeflag,x7,x8,lx0,lx1);
}


fillpolylines_1(fname,str,vx,vy,fillvect,n,p,x8,lx0,lx1)
     int lx0,lx1,*x8;
     char fname[],str[];
     int *n,*p,fillvect[];
     double *vx,*vy;
{
  int *xm,*ym,err=0,rect[4];
  Myalloc(&xm,&ym,(*n)*(*p),&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,p,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,vx,(*n)*(*p),'f',vy,(*n)*(*p),'f',fillvect,*n,'i',
	n,1,'i',p,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,xm,ym,fillvect,n,p,x8,lx0,lx1);
}

drawpolymark_1(fname,str,n, vx, vy,x6,x7,x8,lx0,lx1)
     int lx0,lx1,*x6,*x7,*x8;
     char fname[],str[];
     int *n;
     double *vx,*vy;
{
  int *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,n,1,'i',vx,(*n),'f',vy,(*n),'f',
		&Ivide,1,'i',&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,n,xm,ym,x6,x7,x8,lx0,lx1);

}

displaynumbers_1(fname,str,x,y,z,alpha,n,flag,lx0,lx1)
     int lx0,lx1;
     char fname[],str[];
     int *flag,*n;
     double x[],y[],z[],alpha[];
{
  int *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(x,y,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,x,(*n),'f',y,(*n),'f',z,*n,'f',
		alpha,*n,'f',n,1,'i',flag,1,'i');
  C2F(dr)(fname,str,xm,ym,(int *) z,(int *)alpha,n,flag,lx0,lx1);
}

drawpolylines_1(fname,str,vx,vy,drawvect,n,p,x8,lx0,lx1)
     int lx0,lx1,*x8;
     char fname[],str[];
     int *n,*p,drawvect[];
     double *vx,*vy;
{
  int *xm,*ym,err=0,rect[4];
  Myalloc(&xm,&ym,(*n)*(*p),&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,p,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,vx,(*n)*(*p),'f',vy,(*n)*(*p),'f',
		drawvect,*n,'i',n,1,'i',p,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,xm,ym,drawvect,n,p,x8,lx0,lx1);
}

drawrectangle_1(fname,str,x,y,w,h,x7,x8,lx0,lx1)
     int lx0,lx1,*x7,*x8;
     char fname[],str[];
     double *x,*y,*w,*h;
{
  int x1,y1,w1,h1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"f2i",3L);  
  echelle2dl_(w,h,&w1,&h1,&n,&n,rect,"f2i");
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,x,1,'f',y,1,'f',w,1,'f',h,1,'f'
		,&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,&x1,&y1,&w1,&h1,x7,x8,lx0,lx1);
}

drawrectangles_1(fname,str,vects,fillvect,n,x6,x7,x8,lx0,lx1)
     int lx0,lx1,*x6,*x7,*x8;
     char fname[],str[];
     double *vects;
     int fillvect[],*n;
{
  int *xm,err=0,n2;
  Myalloc1(&xm,4*(*n),&err);
  if (err ==  1) return;
  rect2d_(vects,xm,(n2=4*(*n),&n2),"f2i");
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,vects,4*(*n),'f',fillvect,*n,'i',n,1,'i',
		&Ivide,1,'i',&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,xm,fillvect,n,x6,x7,x8,lx0,lx1);
}

drawsegments_1(fname,str,vx,vy,n,x6,x7,x8,lx0,lx1)
     int lx0,lx1,*x6,*x7,*x8;
     char fname[], str[];
     int  *n;
     double vx[],vy[];
{ 
  int *xm,*ym,err=0,n2=1,rect[4];
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,rect,"f2i",3L);
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,str,vx,(*n),'f',vy,*n,'f',n,1,'i',
		&Ivide,1,'i',&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,str,xm,ym,n,x6,x7,x8,lx0,lx1);
}

displaystring_1(fname,string,x,y,angle,flag,x7,x8,lx0,lx1)
     int lx0,lx1,*x7,*x8;
     int *flag;
     double *angle,*x,*y;
     char string[],fname[] ;
{
  int x1,y1,n=1,rect[4];
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect,"f2i",3L);  
  if (GetDriver_()=='R') 
	STOREXCALL1(fname,string,x,1,'f',y,1,'f',angle,1,'f',flag,1,'i',
		&Ivide,1,'i',&Ivide,1,'i');
  C2F(dr)(fname,string,&x1,&y1,(int *)angle,flag,x7,x8,lx0,lx1);
}

/** To get the bounding rectangle of a string **/

boundingbox_1(fname,string,x,y,rect,x6,x7,x8,lx0,lx1)
     int lx0,lx1,*x6,*x7,*x8;
     double *x,*y,*rect;
     char string[],fname[];
{ 
  int x1,y1,n=1,rect1[4],rect2[4];
  C2F(echelle2d)(x,y,&x1,&y1,&n,&n,rect2,"f2i",3L);  
  C2F(dr)(fname,string,&x1,&y1,rect1,x6,x7,x8,lx0,lx1);
  C2F(echelle2d)(rect,rect+1,rect1,rect1+1,&n,&n,rect2,"i2f",3L);
  echelle2dl_(rect+2,rect+3,rect1+2,rect1+3,&n,&n,rect2,"i2f");
}

Myalloc(xm,ym,n,err)
     int **xm,**ym,n,*err;
{
  static int firstentry=1,*xm1,*ym1;
  if ( n != 0) 
    {
      if ( firstentry )
	{
	  *xm=xm1= (int *) malloc ((unsigned) n*sizeof(int));
	  *ym=ym1= (int *) malloc ((unsigned) n*sizeof(int));
	  firstentry=0;
	}
      else 
	{
	  *xm=xm1= (int *) realloc((char *)xm1,(unsigned) n*sizeof(int));
	  *ym=ym1= (int *) realloc((char *)ym1,(unsigned) n*sizeof(int));
	}
      
      if ( xm1 == 0 || ym1 == 0 )
	{
	  Scistring("malloc : No more Place\n");
	  *err=1;
	}
    }
}


Myalloc1(xm,n,err)
     int **xm,n,*err;
{
  static int firstentry=1,*xm1;
  if ( n != 0) 
    {
      if ( firstentry )
	{
	  *xm=xm1= (int *) malloc ((unsigned) n*sizeof(int));
	  firstentry=0;
	}
      else 
	{
	  *xm=xm1= (int *) realloc((char *)xm1,(unsigned) n*sizeof(int));
	}
      
      if ( xm1 == 0  )
	{
	  Scistring("malloc : No more Place\n");
	  *err=1;
	}
    }
}


/*----------------------------------END---------------------------*/











