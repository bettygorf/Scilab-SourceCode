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

#include <string.h> /* in case of dbmalloc use */
#include <stdio.h>
#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <math.h>
#include "Math.h"

extern char GetDriver_();
/*-----------------------------------------------------------------------
  Level curves 
  The computer journal vol 15 nul 4 p 382 (1972)
  from the Lisp Macsyma source (M.I.T)
 -------------------------------------------------------------------------*/

/*------------------------
General functions 
Could be changed in #define to increase speed
------------------------*/

static double *GX,*GY,*GZ;
static integer Gn1,Gn2;

InitValues(x,y,z,n1,n2)
     double x[],y[],z[];
     integer n1,n2;
{
  Gn1=n1;  Gn2=n2;  GX = x;  GY = y;  GZ = z;
}

/*--------return the  value of f for a pointeger on the grid-----*/
double phi_cont(i,j)
     integer i,j;
{
  return(GZ[i+Gn1*j]);
  }


/*---------return the coordinates between  [xi,xj] along one axis 
  for which the value of f is zCont */ 

double f_intercept(zCont,fi,xi,fj,xj)
     double zCont,fi,xi,fj,xj;
{
  return( xi+ (zCont-fi)*(xj-xi)/ (fj-fi));
}

/* check for boundary points */

 integer  bdyp( i,j)
	integer i,j;
{
  return (  j == 0 || i == 0 || j == Gn2-1 || i == Gn1-1 );
}

/* store or get flag values */

static  integer *itg_cont, *xbd_cont,*ybd_cont;

integer get_itg_cont(i,j)
     integer i,j;
{
  return( itg_cont[i+Gn1*j]);
}


inc_itg_cont(i,j,val)
     integer i,j,val ;
{
  itg_cont[i+Gn1*j] += val;
}


integer not_same_sign(val1,val2)
     double val1,val2;
{
  /** 0.0 est consid\'er\'e comme positif **/
  if ( val1 >= 0.0) 
    {
      if (val2 < 0.0) return(1) ; else return(0);}
  else 
    {
      if ( val2 >= 0.0) return(1) ; else return(0);}
}

integer oddp(i)
     integer i;
{ if ( i == 1 || i ==3 ) return(1); else return(0);}

/*------------------------------------------------------------
 Draw level curves for a function f(x,y) which values 
 at points x(i),y(j) are given by z(i,j)
 - z is a (n1,n2) matrix 
 - x is a (1,n1) matrix 
 - y is a (1,n2) matrix 
 - x,y,z are stored as one dimensionnal array in C 
 - if *flagnz =0 
 -   then  nz is an integer pointer to the number of level curves. 
     else  zz is an array which gives th requested level values.
            (and nz is the size of thos array)
 Computed from min and max of z
 Exemple Contour(1:5,1:10,rand(5,10),5);
---------------------------------------------------------------*/

static double m[3][3],tr[2];
static double FRect[4],scx,scy;
static double ZC=0.0;
static double xofset,yofset;
static char   ContNumFormat[100];
static integer    ContNumPrec=2;
#define TRX(x1,y1,z1) ( m[0][0]*(x1) +m[0][1]*(y1) +m[0][2]*(z1))
#define TRY(x1,y1,z1) ( m[1][0]*(x1) +m[1][1]*(y1) +m[1][2]*(z1))
#define TRZ(x1,y1,z1) ( m[2][0]*(x1) +m[2][1]*(y1) +m[2][2]*(z1))
#define GEOX(x1,y1,z1) inint( scx*(TRX(x1,y1,z1)-FRect[0])  +tr[0]);
#define GEOY(x1,y1,z1) inint( scy*(-TRY(x1,y1,z1)+FRect[3]) +tr[1]);

#define GXX(x1) inint( scx*(x1-FRect[0])  +tr[0]);
#define GYY(y1) inint( scy*(-y1+FRect[3]) +tr[1]);

static double FRect2d[4],scx2d,scy2d;
#define GX2D(j) ( scx2d*(GX[j]-FRect2d[0])  +xofset)
#define GY2D(j) ( scy2d*(-GY[j]+FRect2d[3]) +yofset)
/*---------return the x-value of a grid pointeger --------*/
double x_cont(i)  integer i;{  return(GX2D(i));}
/*---------return the y-value of a grid pointeger --------*/
double y_cont(i)   integer i;{return(GY2D(i));}

/*  lstr : unused ( but used by Fortran )  */

C2F(contour)(x,y,z,n1,n2,flagnz,nz,zz,teta,alpha,legend,flag,bbox,zlev,lstr)
     double *teta,*alpha;
     integer flag[3];
     char legend[];
     double x[],y[],z[],zz[],bbox[6],*zlev;
     integer *n1,*n2,*nz,*flagnz;
     integer lstr;
{
  static char logflag[]="nn";
  integer InsideU[4],InsideD[4],cache;
  void (*func)(), ContStore(),ContStore1(),ContStore2();
  integer IRect[4];
  static double *zconst;
  static integer firstentry=1;
  double zmin,zmax,xmin,xmax,ymin,ymax;
  integer *xm,*ym,err=0;
  integer N[3],i,aaint[4];
  double xbox[8],ybox[8],zbox[8];
  /** If Record is on **/
  if (GetDriver_()=='R') 
    StoreContour("contour",x,y,z,n1,n2,flagnz,nz,zz,teta,alpha,
		 legend,flag,bbox,zlev);
  switch (flag[0])
    {
    case 0:   func=ContStore; break;
    case 1:   func=ContStore1;ZC= *zlev; break;
    case 2:   func=ContStore2; break;
    }
  zmin=(double) Mini(z,*n1*(*n2)); 
  zmax=(double) Maxi(z,*n1*(*n2));
  if (flag[0] == 2)
    {
      /* Contour on a 2D plot */
      aaint[0]=aaint[2]=2;aaint[1]=aaint[3]=10;
      xmin=x[0];ymin= -y[*n2-1],xmax=x[*n1-1],ymax= -y[0];
      FRect2d[0]=xmin;FRect2d[1]= -ymax;FRect2d[2]=xmax;FRect2d[3]= -ymin;
      Scale2D(1L,FRect2d,IRect,aaint,&scx2d,&scy2d,&xofset,&yofset,logflag,&xm,&ym,0L,&err);
      if ( err == 0) return;
      aplot_(IRect,(xmin=FRect2d[0],&xmin),(ymin=FRect2d[1],&ymin),
	     (xmax=FRect2d[2],&xmax),(ymax=FRect2d[3],&ymax),
	     &(aaint[0]),&(aaint[2]),"nn"); 
      C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
	  ,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  else
    {
       scx2d= 1.00 ;FRect2d[0]=0.0;xofset=0.0;
       scy2d= -1.00 ;FRect2d[3]=0.0;yofset=0.0;
       /* Contour on a 3D plot */
       if (flag[1]!=1 && flag[1] != 0)
	 {
	   bbox[0]=x[0];bbox[1]=x[*n1-1];
	   bbox[2]=y[0];bbox[3]=y[*n2-1];
	   bbox[4]=zmin;bbox[5]=zmax;
	 }
       if ( flag[1] !=0)
	 SetEch3d(xbox,ybox,zbox,bbox,teta,alpha);
       else
	 SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,0L);
       /** Calcule l' Enveloppe Convexe de la boite **/
       /** ainsi que les triedres caches ou non **/
       Convex(xbox,ybox,InsideU,InsideD,legend,flag,bbox);
       /** Le triedre cach\'e **/
       if (zbox[InsideU[0]] > zbox[InsideD[0]])
	 {
	   /* cache=InsideD[0]; */
	   if (flag[2] >=2 )DrawAxis(xbox,ybox,InsideD,1L);
	 }
       else 
	 {
	   /* cache=InsideU[0]-4; */
	   if (flag[2] >=2 )DrawAxis(xbox,ybox,InsideU,1L);
	 }
       GetEch3d1(m,tr,FRect,&scx,&scy);
     }
  if (*flagnz==0)
    {
      if (firstentry)
	{
	  zconst=(double *) MALLOC( (*nz)* sizeof(double));
	  firstentry=0;
	}
      else 
	{
	  zconst =(double *) REALLOC(zconst,
				     ( (*nz)*sizeof(double)));
	}
      for ( i =0 ; i < *nz ; i++)
	zconst[i]=zmin + i*(zmax-zmin)/(*nz);
      N[0]= *n1;N[1]= *n2;N[2]= *nz;
      contourI_(func,x,y,z,zconst,N,&err);
    }
  else
    {
      N[0]= *n1;N[1]= *n2;N[2]= *nz;
      contourI_(func,x,y,z,zz,N,&err);
    }
  if (flag[0]!=2 &&  flag[2] >=3 )
    {
      /** Le triedre que l'on doit voir **/
      if (zbox[InsideU[0]] > zbox[InsideD[0]])
	DrawAxis(xbox,ybox,InsideU,0L);
      else 
	DrawAxis(xbox,ybox,InsideD,0L);
    }
  C2F(dr)("xset","clipoff",PI0,PI0,PI0,PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

}

/*-------------------------------------------------------
  The function f is given on a grid and we want the level curves 
  for the zCont[N[2]] values 
  x : of size N[0] gives the x-values of the grid 
  y : of size N[1] gives the y-values of the grid 
  z : of size N[0]*N[1]  gives the f-values on the grid 

  
-------------------------------------------------------*/

contourI_(func,x,y,z,zCont,N,err)
     double x[],y[],z[],zCont[];
     integer N[];
     integer *err;
     void (*func)();
{
  integer n1,n2,ncont,i,c,j,k,n5;
  integer AllocContour();
  n1=N[0];n2=N[1];ncont=N[2];
  ChoixFormatE1(ContNumFormat,&ContNumPrec,zCont,N[2]);
  if (AllocContour()==0) return;
  InitValues(x,y,z,n1,n2);
  n5 =  2*(n1)+2*(n2)-3;
  /* deux tableaux pour stocker les points du bord **/
  Alloc(&xbd_cont,&ybd_cont,&itg_cont,n5,n5,n1*n2,err);
  if ( *err == 0)
    {
      Scistring("contourI_ : No more Place\n");
      return;
    }
  /* just a parametrization of the boundary points */
  for ( i = 0 ; i <  n2 ; i++)
	{
		ybd_cont[i] = i ;
		xbd_cont[i] = 0 ;
		}
  for ( i = 1 ; i <  n1 ; i++)
	{
		ybd_cont[n2+i-1] = n2-1 ;
		xbd_cont[n2+i-1] = i  ;
		}
  for ( i = n2-2;  i >= 0  ; i--)
	{
		ybd_cont[2*n2 +n1-3-i] = i ;
		xbd_cont[2*n2 +n1-3-i] = n1-1  ;
		}
  for ( i = n1-2 ; i >= 0 ; i--)
	{
		ybd_cont[2*n2 +2*n1-4-i] = 0 ;
		xbd_cont[2*n2 +2*n1-4-i] = i  ;
		}
 for ( c= 0 ; c < ncont ; c++)
   {
     /** itg-cont is a flag array to memorize checked parts of the grid **/
     for ( i = 0 ; i < n1; i++)
       for ( j =0 ; j < n2 ; j++)
	 itg_cont[i+n1*j]=0 ;
     /** all the boundary segments **/
     for ( k = 1 ; k < n5 ; k++)
       { integer ib,jb;
	 i = xbd_cont[k] ; j = ybd_cont[k];
	 ib = xbd_cont[k-1] ; jb= ybd_cont[k-1];
	 if  (not_same_sign (phi_cont(i,j)-zCont[c] , 
			     phi_cont(ib,jb)-zCont[c]))
	   look(func,i,j,ib,jb,1L,zCont[c]);
       }
     /** inside segments **/
     for ( i = 1 ; i < n1-1; i++)
       for ( j = 1 ; j < n2-1 ; j++)
	 if  (not_same_sign ( phi_cont(i,j)-zCont[c] , 
			    phi_cont(i, j-1)-zCont[c]))
	   look(func,i,j,i,j-1,2L,zCont[c]);
     
   }
}

/*--------------------------------------------------------------------
  the level curve is crossing the segment (i,j) (ib,jb)
  look store the level curve pointeger and try to find the next segment to look at
  Cont: value of f along the contour 
  ncont: number of contour 
  c: indice of the contour Cont 
---------------------------------------------------------------------*/

look(func,i,j,ib,jb,qq,Cont)
     integer i,j,ib,jb,qq;
     double  Cont ;
     void (*func)();
{
  integer ffnd();
  integer ip,jp,im,jm,zds,ent,flag,wflag;
  jp= j+1; ip= i+1; jm=j-1;im=i-1;
  /*  on regarde comment est le segment de depart */
  if  ( jb == jm)  flag = 1; 
  else  { 
    if ( ib == im ) flag = 2 ;
    else  {
      if ( jb == jp ) flag = 3 ;
      else  if ( ib == ip ) flag = 4;}}
  switch  (  flag)
    {
    case  1 :
      if  (get_itg_cont(i,jm) > 1) return;
      ent=1 ; /* le segment est vertical vers le bas */
      /* on stocke le pointeger d'intersection */
      (*func)(0,Cont, x_cont(i), 
		f_intercept(Cont,phi_cont(i,jm),
			    y_cont(jm),phi_cont(i,j),y_cont(j)));
      break;
    case 2 : 
      if  (get_itg_cont(im,j) == 1 || get_itg_cont(im,j)==3 ) return;
      ent=2 ; /* le segment est horizontal gauche */
      /* on stocke le pointeger d'intersection */
      (*func)( 0,Cont,
		f_intercept(Cont,phi_cont(im,j),
			    x_cont(im),phi_cont(i,j),x_cont(i)), y_cont(j));
      break ; 
    case 3 :
      if  (get_itg_cont(i,j) > 1 ) return;
      ent=3 ; /* le segment est vertical haut */
      /* on stocke le pointeger d'intersection */
      (*func)(0,Cont,x_cont(i), f_intercept(Cont,phi_cont(i,j),
					 y_cont(j),phi_cont(i,jp),y_cont(jp)));
      break ;
    case 4 :
      if  (get_itg_cont(i,j) == 1 || get_itg_cont(i,j)==3 ) return;
      ent=4 ; /* le segment est horizontal droit */
      /* on stocke le pointeger d'intersection */
      (*func)(0,Cont,f_intercept(Cont,phi_cont(i,j),
			      x_cont(i),phi_cont(ip,j),x_cont(ip)),
		y_cont(j));
      break;
      default :
	Scistring(" Error in case wrong value ");
      break;
    }
  wflag=1;
  while ( wflag) 
    { 
      jp= j+1; ip= i+1; jm=j-1;im=i-1;
      switch  ( ent) 
	{case 1 :
	  inc_itg_cont(i,jm,2L);
	  ent = ffnd(func,i,ip,ip,i,j,j,jm,jm,ent,qq,Cont,&zds);
	  /* on calcule le nouveau point, ent donne la 
	     direction du segment a explorer */
	  switch ( ent)
	    {
	    case 1 : i=ip ; break ;
	    case 2 : i=ip;j=jm; break ;
	    }
	  break ;
	case 2  :
	  inc_itg_cont(im,j,1L);
	  ent = ffnd(func,i,i,im,im,j,jm,jm,j,ent,qq,Cont,&zds);
	  switch ( ent)
	    { case 2 : j = jm ;break ;
	    case  3  : i=im;j=jm; break ;
	    }
	  break ;
	case 3 :
	  inc_itg_cont(i,j,2L);
	  ent = ffnd(func,i,im,im,i,j,j,jp,jp,ent,qq,Cont,&zds);
	  switch ( ent)
	    { case 3 : i=im; break ;
	    case 4 : i=im;j=jp; break ;
	    }
	  break ;
	case 4 :
	  inc_itg_cont(i,j,1L);
	  ent = ffnd(func,i,i,ip,ip,j,jp,jp,j,ent,qq,Cont,&zds);
	  switch ( ent)
	    {case 4 :j=jp;break ;
	    case 1 :i=ip;j=jp;break ;
	    }
	  break ;
	}
      /** le nouveau segment  est au bord du domaine **/
      if ( zds == 1) 
	{
	  switch ( ent) 
	    {
	    case 1 : inc_itg_cont(i,(j-1),2L); break ; 
	    case 2 : inc_itg_cont(i-1,j,1L);  break ; 
	    case 3 : inc_itg_cont(i,j,2L); break ; 
	    case 4 : inc_itg_cont(i,j,1L); break ; 
	    }
	  /* il faut sortir du while */
	  wflag = 0 ;
	  }
      /**  le pointeger de depart etait a l'interieur du domaine **/
      if ( qq == 2) 
	{
	  switch ( ent) 
	    {
	    case 1 : if  ( get_itg_cont (i,j-1)  > 1) wflag = 0 ; break ; 
	    case 2 : if  ( oddp(get_itg_cont(i-1,j))) wflag = 0 ; break ; 
	    case 3 : if  ( get_itg_cont(i,j) > 1)     wflag = 0 ; break ; 
	    case 4 : if  ( oddp(get_itg_cont(i,j)))   wflag = 0 ; break ; 
	    }
	}
    }
  ContourTrace(Cont);
}


/*-----------------------------------------------------------------------
   ffnd : cette fonction  recoit en entree quatre points 
       on sait que la courbe de niveau passe entre le pointeger 1 et le quatre 
       on cherche a savoir ou elle resort, 
       et on fixe une nouvelle valeur de ent aui indiquera le segment suivant a explorer 
-----------------------------------------------------------------------*/

integer ffnd (func, i1,i2,i3,i4,jj1,jj2,jj3,jj4,ent,qq,Cont,zds)
     integer  i1,i2,i3,i4,jj1,jj2,jj3,jj4,ent,qq, *zds;
     double Cont ;
     void (*func)();
{
  double phi1,phi2,phi3,phi4,xav,yav,phiav;
  integer revflag,i;
  phi1=phi_cont(i1,jj1)-Cont;
  phi2=phi_cont(i2,jj2)-Cont;
  phi3=phi_cont(i3,jj3)-Cont;
  phi4=phi_cont(i4,jj4)-Cont;
  revflag = 0;
  *zds = 0;
  /* le pointeger au centre du rectangle */
  xav = ( x_cont(i1)+ x_cont(i3))/2.0 ; 
  yav = ( y_cont(jj1)+ y_cont(jj3))/2.0 ; 
  phiav = ( phi1+phi2+phi3+phi4) / 4.0;
  if (  not_same_sign( phiav,phi4)) 
    {
      integer l1, k1; 
      double phi;
      revflag = 1 ; 
      l1= i4; k1= jj4;
      i4=i1; jj4 = jj1; i1= l1; jj1= k1;
      l1= i3; k1= jj3;
      i3=i2; jj3= jj2; i2=l1; jj2= k1;
      phi = phi1; phi1 = phi4; phi4= phi;
      phi = phi3; phi3 = phi2; phi2= phi;
    }
  /* on stocke un nouveau pointeger  */
  (*func)(1,Cont,f_intercept(0.0,phi1,x_cont(i1),phiav,xav),
	    f_intercept(0.0,phi1,y_cont(jj1),phiav,yav));
  /* on parcourt les segments du rectangle pour voir sur quelle face
     on sort **/
  for  ( i = 0 ;  ; i++)
    { integer l1,k1;
      double phi;
      if ( not_same_sign ( phi1,phi2))   /** sortir du for **/ break ; 
      if  ( phiav != 0.0 ) 
	{
	  (*func)(1,Cont,f_intercept(0.0,phi2,x_cont(i2),phiav,xav),
		    f_intercept(0.0,phi2,y_cont(jj2),phiav,yav));
	} 
      /** on permutte les points du rectangle **/
      l1=i1; k1= jj1;
      i1=i2;jj1=jj2;i2=i3;jj2=jj3;i3=i4;jj3=jj4;i4=l1;jj4=k1;
      phi=phi1; phi1=phi2;phi2=phi3;phi3=phi4;phi4=phi;
    }
  (*func)(1,Cont,f_intercept(0.0,phi1,x_cont(i1),phi2,x_cont(i2)),
	    f_intercept(0.0,phi1,y_cont(jj1),phi2,y_cont(jj2)));
  if ( qq==1 && bdyp(i1,jj1) && bdyp(i2,jj2)) *zds = 1 ;
  if ( revflag == 1  &&  ! oddp (i) )  i = i+2;
  return ( 1 + (  ( i + ent + 2) % 4));
}

/*--------------------------------------------------------------
Storing and tracing level curves 
----------------------------------------------------------------*/

integer *xcont,*ycont;
unsigned ContMaxPoints;
#define NBPOINTS 256;

integer ReallocContour(n)
     integer n  ;
{
  while (n > ContMaxPoints)
    {
      ContMaxPoints += NBPOINTS;
      xcont = (integer *) REALLOC( xcont,
				  ContMaxPoints * sizeof (integer));
      ycont = (integer *) REALLOC( ycont,
				  ContMaxPoints * sizeof (integer));
      if (ycont == 0 || xcont == 0 ) 
	{ perror("ReallocContour : No more place \n:" );
	  return (0);
	}
    }
  return(1);
}
static first = 0 ;

integer AllocContour()
{
  if (first == 0)
    {
      ContMaxPoints = NBPOINTS;
      xcont = (integer *) MALLOC(ContMaxPoints * sizeof (int)); 
      ycont = (integer *) MALLOC(ContMaxPoints * sizeof (int)); 
      if ( ycont == 0 || xcont == 0 )
	{ perror("AllocContour : No more place\n");return(0);}
      else 
	{
	  first =1 ;
	  return(1);
	}
    }
  return(1);
}

static integer cont_size ;

/* Calcul d'un contour ds une geometrie 3d */
void
ContStore(ival,Cont,xncont,yncont)
     integer ival;
     double xncont,yncont;
     double Cont;
{
  /* nouveau contour */
  if ( ival == 0) cont_size =0 ;
  if ( cont_size <  ContMaxPoints || ReallocContour(cont_size+1))
    {
      xcont[cont_size]=GEOX(xncont,yncont,Cont);
      ycont[cont_size++]=GEOY(xncont,yncont,Cont);
    }
}

/* Calcul d'un contour ds une geometrie 3d projete sur une hauteur ZC */
void
ContStore1(ival,Cont,xncont,yncont)
     integer ival;
     double xncont,yncont;
     double Cont;
{
#ifdef lint
  Cont,ival;
#endif
  /* nouveau contour */
  if ( ival == 0) cont_size =0 ;
  if ( cont_size <  ContMaxPoints || ReallocContour(cont_size+1))
    {
      xcont[cont_size]=GEOX(xncont,yncont,ZC);
      ycont[cont_size++]=GEOY(xncont,yncont,ZC);
    }
}
/* Calcul d'un contour ds une geometrie 2d */
void
ContStore2(ival,Cont,xncont,yncont)
     integer ival;
     double xncont,yncont;
     double Cont;
{
#ifdef lint
  Cont,ival;
#endif
  /* nouveau contour */
  if ( ival == 0) cont_size =0 ;
  if ( cont_size <  ContMaxPoints || ReallocContour(cont_size+1))
    {
      xcont[cont_size]=inint(xncont);
      ycont[cont_size++]=inint(yncont);
    }
}

/** Trace le contour de valeur Cont, c est l'indice de la courbe de niveau 
  dans les ncont que l'on doit tracer **/

ContourTrace(Cont)
     double Cont;
{ integer close;
  integer flag=0;
  double angle=0.0;
  char str[100];
  /*  Just the lines **/
  C2F(dr)("xlines","void",&cont_size,xcont,ycont,&close,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  sprintf(str,ContNumFormat,ContNumPrec,Cont);
  C2F(dr)("xstring",str, &xcont[cont_size / 2],&ycont[cont_size /2],
      PI0,&flag,PI0,PI0, &angle,PD0,PD0,PD0,0L,0L);
}




