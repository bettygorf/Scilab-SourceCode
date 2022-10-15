/*------------------------------------------------------------------------
    Graphic library for 2D and 3D plotting 
    Copyright (C) 1998 Chancelier Jean-Philippe
    jpc@cergrene.enpc.fr 
 --------------------------------------------------------------------------*/

#include <string.h> /* in case of dbmalloc use */

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#if defined(THINK_C)|| defined(WIN32)
#define M_PI	3.14159265358979323846
#else
#include <values.h>
#endif

#include <math.h>
#include <stdio.h>
#include "Math.h"
#include "PloEch.h"

extern double C2F(dsort)();


#define TRX(x1,y1,z1) ( Cscale.m[0][0]*(x1) +Cscale.m[0][1]*(y1) +Cscale.m[0][2]*(z1))
#define TRY(x1,y1,z1) ( Cscale.m[1][0]*(x1) +Cscale.m[1][1]*(y1) +Cscale.m[1][2]*(z1))
#define TRZ(x1,y1,z1) ( Cscale.m[2][0]*(x1) +Cscale.m[2][1]*(y1) +Cscale.m[2][2]*(z1))

static double xx1,yy1;

#define GEOX(x1,y1,z1) inint(xx1= Cscale.Wscx1*(TRX(x1,y1,z1)-Cscale.WFRect1[0])  +Cscale.Wxofset1);
#define GEOY(x1,y1,z1) inint(yy1= Cscale.Wscy1*(-TRY(x1,y1,z1)+Cscale.WFRect1[3]) + Cscale.Wyofset1);
#define GX(x1) inint( Cscale.Wscx1*(x1- Cscale.WFRect1[0])  + Cscale.Wxofset1);
#define GY(y1) inint( Cscale.Wscy1*(-y1+ Cscale.WFRect1[3]) + Cscale.Wyofset1);

static void C2F(plot3dg)();
static void C2F(fac3dg)();
static void dbox();

/*-------------------------------------------------------------------------

  3D Plotting of surfaces given by z=f(x,y)
  -->  Entry :
     x : vector of size *p
     y : vector of size *q
     z : vector of size (*p)*(*q) 
         z[i+(*p)j]=f(x[i],y[j])
     p,q 
     teta,alpha (spherical angle in degree of the observation point 
                 at infinity )
     flag[0]={ n1, n2 }
       n1 ==1  with hidden parts 
       n1 >=2 without hidden part, ( if flag > 2  the surface is grey )
       n1 <=0 only the shape of the surface is painted (with white if 0)
     flag[1]=0  ( the current scale are used, for superpose mode )
     flag[1]=1  ( bbox is used to fix the box of plot3d )
     flag[2]=0  ( No box around the plot3d )
     flag[2]=1  ( petit triedre ds un coin )
     flag[2]=2  ( juste triedre cache )
     flag[2]=3  ( toute la boite + legendes )
     flag[2]=4  ( toute la boite + legendes + axes )
     legend="x-legend@y-legend@z-legend"
     
  <-- The arguments are not modified 
-------------------------------------------------------------------------*/



extern char GetDriver();

/* 
 * Current geometric transformation and scales 
 * which are used or set according to the value of flag[1]
 *
 */

static void C2F(plot3dg)(name, func, x, y, z, p, q, teta, alpha, legend, flag, bbox)
     char *name;
     int (*func)();
     double *x;
     double *y;
     double *z;
     integer *p;
     integer *q;
     double *teta;
     double *alpha;
     char *legend;
     integer *flag;
     double *bbox;
{
  static integer InsideU[4],InsideD[4],fg,fg1,dc;
  /* solid = color of 3D frame */
  integer polysize,npoly,whiteid,verbose=0,narg,xz[10];
  integer *polyx,*polyy,*fill;
  double xbox[8],ybox[8],zbox[8];
  static integer cache,err;
  static double zmin,zmax;
  integer i,j;
  /** If Record is on **/
  if (GetDriver()=='R') 
    StorePlot3D(name,x,y,z,p,q,teta,alpha,legend,flag,bbox);
  C2F(dr)("xget","foreground",&verbose,&fg,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if (flag[1]!=1 && flag[1] != 0)
    {
      bbox[0]=x[0];bbox[1]=x[*p-1];
      bbox[2]=y[0];bbox[3]=y[*q-1];
      zmin=bbox[4]=(double) Mini(z,*p*(*q)); 
      zmax=bbox[5]=(double) Maxi(z,*p*(*q));
    }
  if ( flag[1]==1) 
    {
      zmin=bbox[4];
      zmax=bbox[5];
    }
  if ( flag[1] !=0)
    SetEch3d(xbox,ybox,zbox,bbox,teta,alpha);
  else
    SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,0L);
  /** Calcule l' Enveloppe Convex de la boite **/
  /** ainsi que les triedres caches ou non **/
  Convex_Box(xbox,ybox,InsideU,InsideD,legend,flag,bbox);
  /** Le triedre cach\'e **/
  C2F(dr)("xget","hidden3d",&verbose,&fg1,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if (zbox[InsideU[0]] > zbox[InsideD[0]])
    {
      cache=InsideD[0];
      if (flag[2] >=2 )DrawAxis(xbox,ybox,InsideD,fg1);
    }
  else 
    {
      cache=InsideU[0]-4;
      if (flag[2] >=2 )DrawAxis(xbox,ybox,InsideU,fg1);
    }
  Alloc(&polyx,&polyy,&fill,5*(*q),5*(*q),(*q),&err);
  if ( err == 0)
    {
      Scistring("plot3dg_ : malloc No more Place\n");
      return;
    }
  /** Le plot 3D **/

  C2F(dr)("xget","lastpattern",&verbose,&whiteid,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  dc =  flag[0];
  C2F(dr)("xget","hidden3d",&verbose,&fg1,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  for ( i =0 ; i < (*q)-1 ; i++)   fill[i]= dc ;
  polysize=5;
  npoly= (*q)-1; 
  /** Choix de l'ordre de parcourt **/
  switch (cache)
    {
    case 0 : 
      for ( i =0 ; i < (*p)-1 ; i++)
	{
	  int npolyok=0;
	  for ( j =0 ; j < (*q)-1 ; j++)
	    {
	     npolyok += (*func)(polyx,polyy,fill,whiteid,zmin,zmax,
				x,y,z,i,j,npolyok,p,dc,fg1);
	    }
	  if ( npolyok != 0) 
	    C2F(dr)("xliness","str",polyx,polyy,fill,&npolyok,&polysize
		    ,PI0,PD0,PD0,PD0,PD0,0L,0L);
	}
      break;
    case 1 : 
      for ( i =0 ; i < (*p)-1 ; i++)
	{
	  int npolyok=0;
	  for ( j =0  ; j < (*q)-1  ; j++)
	    {
	      npolyok += (*func)(polyx,polyy,fill,whiteid,zmin,zmax,
				 x,y,z,i,(*q)-2-j,npolyok,p,dc,fg1);
	   }
	  if ( npolyok != 0) 
	    C2F(dr)("xliness","str",polyx,polyy,fill,&npolyok,&polysize
		    ,PI0,PD0,PD0,PD0,PD0,0L,0L);
	}
      break;
    case 2 : 
      for ( i =(*p)-2 ; i >=0  ; i--)
	{
	  int npolyok=0;
	  for ( j = 0 ; j < (*q)-1 ; j++)
	    {
	     npolyok +=     (*func)(polyx,polyy,fill,whiteid,zmin,zmax,
				    x,y,z,i,(*q)-2-j,npolyok,p,dc,fg1);
	   }
	  if ( npolyok != 0) 
	    C2F(dr)("xliness","str",polyx,polyy,fill,&npolyok,&polysize
		    ,PI0,PD0,PD0,PD0,PD0,0L,0L);
	}
      break;
    case 3 : 
      for ( i =(*p)-2 ; i >=0  ; i--)
	{
	  int npolyok=0;
	  for ( j =0 ; j < (*q)-1 ; j++)
	    {
	     npolyok += (*func)(polyx,polyy,fill,whiteid,zmin,zmax,
				x,y,z,i,j,npolyok,p,dc,fg1);
	   }
	  if ( npolyok != 0) 
	    C2F(dr)("xliness","str",polyx,polyy,fill,&npolyok,&polysize
		    ,PI0,PD0,PD0,PD0,PD0,0L,0L);
	}
      break;
    }
  /* jpc   if (flag[1] != 0 && flag[2] >=3 ) */
  if ( flag[2] >=3 )
    {
      /** Le triedre que l'on doit voir **/
      if (zbox[InsideU[0]] > zbox[InsideD[0]])
	DrawAxis(xbox,ybox,InsideU,fg);
      else 
	DrawAxis(xbox,ybox,InsideD,fg);
    }
  C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}


static void C2F(fac3dg)(name, iflag, x, y, z, cvect, p, q, teta, alpha, legend, flag, bbox)
     char *name;
     int iflag;
     double *x;
     double *y;
     double *z;
     integer *cvect;
     integer *p;
     integer *q;
     double *teta;
     double *alpha;
     char *legend;
     integer *flag;
     double *bbox;
{
  static integer InsideU[4],InsideD[4],fg1;
  integer polysize,npoly,whiteid,verbose=0,narg,xz[10];
  integer *polyx,*polyy,*locindex,fill[1];
  double xbox[8],ybox[8],zbox[8],*polyz;
  static integer cache,err;
  static double zmin,zmax;
  integer i;
  /** If Record is on **/
  if (GetDriver()=='R') 
    StoreFac3D(name,x,y,z,cvect,p,q,teta,alpha,legend,flag,bbox);
  C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if (flag[1]!=1 && flag[1] != 0)
    {
      bbox[0]=(double) Mini(x,*p*(*q));
      bbox[1]=(double) Maxi(x,*p*(*q));
      bbox[2]=(double) Mini(y,*p*(*q)); 
      bbox[3]=(double) Maxi(y,*p*(*q));
      zmin=bbox[4]=(double) Mini(z,*p*(*q)); 
      zmax=bbox[5]=(double) Maxi(z,*p*(*q));
    }
  if ( flag[1]==1) 
    {
      zmin=bbox[4];
      zmax=bbox[5];
    }
  if ( flag[1] !=0)
    SetEch3d(xbox,ybox,zbox,bbox,teta,alpha);
  else
    SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,0L);
  /** Calcule l' Enveloppe Convex de la boite **/
  /** ainsi que les triedres caches ou non **/
  Convex_Box(xbox,ybox,InsideU,InsideD,legend,flag,bbox);
  /** Le triedre cach\'e **/
  C2F(dr)("xget","hidden3d",&verbose,&fg1,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if (zbox[InsideU[0]] > zbox[InsideD[0]])
    {
      cache=InsideD[0];
      if (flag[2] >=2 )DrawAxis(xbox,ybox,InsideD,fg1);
    }
  else 
    {
      cache=InsideU[0]-4;
      if (flag[2] >=2 )DrawAxis(xbox,ybox,InsideU,fg1);
    }
  AllocD(&polyz,(*q),&err);
  if ( err == 0)
    {
      Scistring("plot3dg_ : malloc No more Place\n");
      return;
    }
  Alloc(&polyx,&polyy,&locindex,(*p)+1L,(*p)+1L,(*q),&err);
  if ( err == 0)
    {
      Scistring("plot3dg_ : malloc No more Place\n");
      return;
    }

  C2F(dr)("xget","lastpattern",&verbose,&whiteid,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  fill[0]=  flag[0];
  C2F(dr)("xget","hidden3d",&verbose,&fg1,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** tri **/
  for ( i =0 ; i < *q ; i++)
    {
      double zdmin1, zdmin,xmoy=0.00,ymoy=0.00,zmoy=0.00;
      int j=0 ;
      zdmin1=  TRZ(x[ (*p)*i]  ,y[(*p)*i]  ,z[(*p)*i]);
      for ( j= 1 ; j < *p ; j++) 
	{
	  xmoy += x[ j +(*p)*i];  ymoy += y[ j +(*p)*i];  zmoy += z[ j +(*p)*i];
	  zdmin =  TRZ(x[ j +(*p)*i]  ,y[ j +(*p)*i]  ,z[ j +(*p)*i]);
	  if ( zdmin1 < zdmin ) zdmin1= zdmin;
	}
      /* polyz[i]= zdmin1 + TRZ(xmoy,ymoy,zmoy); */
      polyz[i]=  TRZ(xmoy,ymoy,zmoy);
    }
  C2F(dsort)(polyz,q,locindex); 
  for ( i =0 ; i < (*q) ; i++)
    {
      locindex[i] -= 1;  /* Fortran locindex -> C locindex */
      if ( locindex[i] >= *q) 
	sciprint (" index[%d]=%d\r\n",i,locindex[i]);
      locindex[i] = Min(Max(0,locindex[i]),*q-1);
    }
  polysize=5;
  npoly=1; 
  for ( i = (*q)-1 ; i>= 0 ; i--)
    {
      int j,nok=0;
      for ( j =0 ; j < (*p) ; j++)
	{
	  polyx[j]=GEOX(x[(*p)*locindex[i]+j]  ,y[(*p)*locindex[i]+j]  ,z[(*p)*locindex[i]+j]);
	  if ( finite(xx1) ==0 ) 
	    {
	      nok=1;break;
	    }
	  polyy[j]=GEOY(x[(*p)*locindex[i]+j]  ,y[(*p)*locindex[i]+j]  ,z[(*p)*locindex[i]+j]);
	  if ( finite(yy1)==0)
	    {
	      nok=1;break;
	    }
	}
      if ( nok == 0) 
	{
	  polyx[(*p)]=polyx[0];
	  polyy[(*p)]=polyy[0];
	  fill[0]=  flag[0];
	  if ( *p >= 2 && ((polyx[1]-polyx[0])*(polyy[2]-polyy[0])-
			   (polyy[1]-polyy[0])*(polyx[2]-polyx[0])) <  0) 
	    fill[0] = (flag[0] > 0 ) ? fg1 : -fg1 ;
	  else if ( iflag == 1) 
	    {
	      /* color according to z-level */
	      double zl=0;
	      int k;
	      for ( k= 0 ; k < *p ; k++) 
		zl+= z[(*p)*locindex[i]+k];
	      fill[0]=inint((whiteid-1)*((zl/(*p))-zmin)/(zmax-zmin))+1;
	      if ( flag[0] < 0 ) fill[0]=-fill[0];
	    }
	  else if ( iflag == 2) 
	    {
	      /* colors are given by cvect */
	      fill[0]= cvect[locindex[i]];
	      if ( flag[0] < 0 ) fill[0]=-fill[0];
	    }
	  C2F(dr)("xliness","str",polyx,polyy,fill,&npoly,&polysize ,PI0,PD0,PD0,PD0,PD0,0L,0L);
	}
    } 
  if ( flag[2] >=3 )
    {
      integer fg;
      C2F(dr)("xget","foreground",&verbose,&fg,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      /** Le triedre que l'on doit voir **/
      if (zbox[InsideU[0]] > zbox[InsideD[0]])
	DrawAxis(xbox,ybox,InsideU,fg);
      else 
	DrawAxis(xbox,ybox,InsideD,fg);
    }
  C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}

/*-------------------------------------------------------------------
   Renvoit dans polyx et polyy le polygone d'une facette 
  de la surface a tracer
--------------------------------------------------------------------*/

int DPoints1(polyx, polyy, fill, whiteid, zmin, zmax, x, y, z, i, j, jj1, p,dc,fg)
     integer *polyx;
     integer *polyy;
     integer *fill;
     integer whiteid;
     double zmin;
     double zmax;
     double *x;
     double *y;
     double *z;
     integer i;
     integer j;
     integer jj1;
     integer *p;
     integer dc,fg;
{
  polyx[  5*jj1] =GEOX(x[i]  ,y[j]  ,z[i+(*p)*j]);
  if ( finite(xx1)==0 )return(0);
  polyy[  5*jj1] =GEOY(x[i]  ,y[j]  ,z[i+(*p)*j]);
  if ( finite(yy1)==0)return(0);
  polyx[1 +5*jj1]=GEOX(x[i]  ,y[j+1],z[i+(*p)*(j+1)]);	
  if ( finite(xx1)==0 )return(0);
  polyy[1 +5*jj1]=GEOY(x[i]  ,y[j+1],z[i+(*p)*(j+1)]);
  if ( finite(yy1)==0)return(0);
  polyx[2 +5*jj1]=GEOX(x[i+1],y[j+1],z[(i+1)+(*p)*(j+1)]);
  if ( finite(xx1)==0 )return(0);
  polyy[2 +5*jj1]=GEOY(x[i+1],y[j+1],z[(i+1)+(*p)*(j+1)]);
  if ( finite(yy1)==0)return(0);
  polyx[3 +5*jj1]=GEOX(x[i+1],y[j]  ,z[(i+1)+(*p)*j]);
  if ( finite(xx1)==0 )return(0);
  polyy[3 +5*jj1]=GEOY(x[i+1],y[j]  ,z[(i+1)+(*p)*j]);
  if ( finite(yy1)==0)return(0);
  polyx[4 +5*jj1]=GEOX(x[i]  ,y[j]  ,z[i+(*p)*j]);
  if ( finite(xx1)==0 )return(0);
  polyy[4 +5*jj1]=GEOY(x[i]  ,y[j]  ,z[i+(*p)*j]);
  if ( finite(yy1)==0)return(0);
  if (((polyx[1+5*jj1]-polyx[0+5*jj1])*(polyy[2+5*jj1]-polyy[0+5*jj1])-
       (polyy[1+5*jj1]-polyy[0+5*jj1])*(polyx[2+5*jj1]-polyx[0+5*jj1])) <  0)
    fill[jj1]= (dc < 0 ) ? -fg : fg ;
  else
    {
    fill[jj1]=inint((whiteid-1)*((1/4.0*( z[i+(*p)*j]+ z[i+1+(*p)*j]+
				     z[i+(*p)*(j+1)]+ z[i+1+(*p)*(j+1)])-zmin)
			     /(zmax-zmin)))+1;
      if ( dc < 0 ) fill[jj1]= -fill[jj1];
    }
  return(1);
  
}

int DPoints(polyx, polyy, fill, whiteid, zmin, zmax, x, y, z, i, j, jj1, p,dc,fg)
     integer *polyx;
     integer *polyy;
     integer *fill;
     integer whiteid;
     double zmin;
     double zmax;
     double *x;
     double *y;
     double *z;
     integer i;
     integer j;
     integer jj1;
     integer *p;
     integer dc,fg;
{
#ifdef lint
  whiteid,fill[0],zmin,zmax;
#endif
  polyx[  5*jj1] =GEOX(x[i]  ,y[j]  ,z[i+(*p)*j]);
  if ( finite(xx1)==0 )return(0);
  polyy[  5*jj1] =GEOY(x[i]  ,y[j]  ,z[i+(*p)*j]);
  if ( finite(yy1)==0)return(0);
  polyx[1 +5*jj1]=GEOX(x[i]  ,y[j+1],z[i+(*p)*(j+1)]);
  if ( finite(xx1)==0 )return(0);
  polyy[1 +5*jj1]=GEOY(x[i]  ,y[j+1],z[i+(*p)*(j+1)]);
  if ( finite(yy1)==0)return(0);
  polyx[2 +5*jj1]=GEOX(x[i+1],y[j+1],z[(i+1)+(*p)*(j+1)]);
  if ( finite(xx1)==0 )return(0);
  polyy[2 +5*jj1]=GEOY(x[i+1],y[j+1],z[(i+1)+(*p)*(j+1)]);
  if ( finite(yy1)==0)return(0);
  polyx[3 +5*jj1]=GEOX(x[i+1],y[j]  ,z[(i+1)+(*p)*j]);
  if ( finite(xx1)==0 )return(0);
  polyy[3 +5*jj1]=GEOY(x[i+1],y[j]  ,z[(i+1)+(*p)*j]);
  if ( finite(yy1)==0)return(0);
  polyx[4 +5*jj1]=GEOX(x[i]  ,y[j]  ,z[i+(*p)*j]);
  if ( finite(xx1)==0 )return(0);
  polyy[4 +5*jj1]=GEOY(x[i]  ,y[j]  ,z[i+(*p)*j]);
  if ( finite(yy1)==0)return(0);
  if (((polyx[1+5*jj1]-polyx[0+5*jj1])*(polyy[2+5*jj1]-polyy[0+5*jj1])-
       (polyy[1+5*jj1]-polyy[0+5*jj1])*(polyx[2+5*jj1]-polyx[0+5*jj1])) <  0)
    fill[jj1]=  (dc != 0 ) ? fg : dc ;
  else
    fill[jj1]= dc;
  return(1);
}

int C2F(plot3d)(x,y,z,p,q,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     integer *p,*q;
     double *teta,*alpha;
     integer flag[];
     char legend[];
     integer lstr;
{
  C2F(plot3dg)("plot3d",DPoints,x,y,z,p,q,teta,alpha,legend,flag,bbox);
  return(0);
}

int C2F(plot3d1)(x,y,z,p,q,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     integer *p,*q;
     double *teta,*alpha;
     integer flag[];
     char legend[];
     integer lstr;
{
  C2F(plot3dg)("plot3d1",DPoints1,x,y,z,p,q,teta,alpha,legend,flag,bbox);
  return(0);
}


int C2F(fac3d)(x,y,z,cvect,p,q,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     integer *p,*q;
     double *teta,*alpha;
     integer flag[],*cvect;
     char legend[];
     integer lstr;
{
  C2F(fac3dg)("fac3d",0,x,y,z,cvect,p,q,teta,alpha,legend,flag,bbox);
  return(0);
}

int C2F(fac3d1)(x,y,z,cvect,p,q,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     integer *p,*q;
     double *teta,*alpha;
     integer flag[],*cvect;
     char legend[];
     integer lstr;
{
  C2F(fac3dg)("fac3d1",1,x,y,z,cvect,p,q,teta,alpha,legend,flag,bbox);
  return(0);
}

int C2F(fac3d2)(x,y,z,cvect,p,q,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     integer *p,*q;
     double *teta,*alpha;
     integer flag[],*cvect;
     char legend[];
     integer lstr;
{
  C2F(fac3dg)("fac3d2",2,x,y,z,cvect,p,q,teta,alpha,legend,flag,bbox);
  return(0);
}

/*---------------- Param3d.c  -----------*/

int C2F(param3d)(x,y,z,n,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     integer *n;
     double *teta,*alpha;
     integer *flag;
     char legend[];
     integer lstr;
{
  static integer InsideU[4],InsideD[4];
  static double xbox[8],ybox[8],zbox[8];
  integer style[1], npoly,j;
  static integer err,init;
  static integer *xm,*ym,*zm;
  integer verbose=0,xz[10],narg,fg1;
  /** If Record is on **/
  if (GetDriver()=='R') 
    StoreParam3D("param3d",x,y,z,n,teta,alpha,legend,flag,bbox);
  C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  style[0]= xz[0];
  if (flag[1] != 1 && flag[1] != 0)
    {
      bbox[0]=(double) Mini(x,*n);bbox[1]=(double) Maxi(x,*n);
      bbox[2]=(double) Mini(y,*n);bbox[3]=(double) Maxi(y,*n);
      bbox[4]=(double) Mini(z,*n);bbox[5]=(double) Maxi(z,*n);
    }
  if ( flag[1] !=0)
    SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,1L);
  else 
    SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,0L);
  /** Calcule l' Enveloppe Convexe de la boite **/
  /** ainsi que les triedres caches ou non **/
  Convex_Box(xbox,ybox,InsideU,InsideD,legend,flag,bbox);
  C2F(dr)("xget","hidden3d",&verbose,&fg1,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** Le triedre cache **/
  if (zbox[InsideU[0]] > zbox[InsideD[0]])
    {
      /* cache=InsideD[0];*/
      if (flag[2] >=2 ) DrawAxis(xbox,ybox,InsideD,fg1);
    }
  else 
    {
      /* cache=InsideU[0]-4; */
      if (flag[2] >=2 ) DrawAxis(xbox,ybox,InsideU,fg1);
    }
  C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  Alloc(&xm,&ym,&zm,(*n),(*n),0L,&err);
  if ( err == 0)
    {
      Scistring("Param3d : malloc  No more Place\n");
      return(0);
    }
  init = 0 ; 
  while (1) 
    {
      int nel = 0;
      for ( j =init ; j < (*n) ; j++)	 
	{
	  xm[  nel]=GEOX(x[j],y[j],z[j]);
	  if ( finite(xx1) ==0 ) 
	    {
	      break;
	    }
	  ym[  nel]=GEOY(x[j],y[j],z[j]);
	  if ( finite(yy1)==0)
	    {
	      break;
	    }
	  nel++;
	}
      if ( nel > 0 ) 
	C2F(dr)("xpolys","v",xm,ym,style,(npoly=1,&npoly),&nel,
		PI0,PD0,PD0,PD0,PD0,0L,0L);
      init = j+1;
      if ( init >= (*n)) break;
    }
  if (flag[2] >=3 ) 
    {
      integer fg;
      C2F(dr)("xget","foreground",&verbose,&fg,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      /** Le triedre que l'on doit voir **/
      if (zbox[InsideU[0]] > zbox[InsideD[0]])
	DrawAxis(xbox,ybox,InsideU,fg);
      else 
	DrawAxis(xbox,ybox,InsideD,fg);
    }
  C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  return(0);
}

int C2F(param3d1)(x,y,z,m,n,iflag,colors,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     integer *m,*n,*colors,*iflag;
     double *teta,*alpha;
     integer *flag;
     char legend[];
     integer lstr;
{
  static integer InsideU[4],InsideD[4];
  static double xbox[8],ybox[8],zbox[8];
  integer style[1], npoly,j;
  static integer err,init;
  static integer *xm,*ym,*zm;
  integer verbose=0,xz[10],narg,fg1,cur;
  /** If Record is on **/
  if (GetDriver()=='R') 
    StoreParam3D1("param3d1",x,y,z,m,n,iflag,colors,teta,alpha,legend,flag,bbox);
  C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  style[0]= xz[0];
  if (flag[1] != 1 && flag[1] != 0)
    {
      int mn=*n*(*m);
      bbox[0]=(double) Mini(x,mn);bbox[1]=(double) Maxi(x,mn);
      bbox[2]=(double) Mini(y,mn);bbox[3]=(double) Maxi(y,mn);
      bbox[4]=(double) Mini(z,mn);bbox[5]=(double) Maxi(z,mn);
    }
  if ( flag[1] !=0)
    SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,1L);
  else 
    SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,0L);
  /** Calcule l' Enveloppe Convexe de la boite **/
  /** ainsi que les triedres caches ou non **/
  Convex_Box(xbox,ybox,InsideU,InsideD,legend,flag,bbox);
  C2F(dr)("xget","hidden3d",&verbose,&fg1,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** Le triedre cache **/
  if (zbox[InsideU[0]] > zbox[InsideD[0]])
    {
      /* cache=InsideD[0];*/
      if (flag[2] >=2 ) DrawAxis(xbox,ybox,InsideD,fg1);
    }
  else 
    {
      /* cache=InsideU[0]-4; */
      if (flag[2] >=2 ) DrawAxis(xbox,ybox,InsideU,fg1);
    }
  C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  Alloc(&xm,&ym,&zm,(*m),(*m),0L,&err);
  if ( err == 0)
    {
      Scistring("Param3d : malloc  No more Place\n");
      return(0);
    }
  for ( cur=0 ; cur < *n ; cur++)
    {
      init = 0 ; 
      if ( *iflag != 0 ) style[0]=  colors[cur];
      while (1) 
	{
	  int nel = 0,j1;
	  j1= (*m)*cur;
	  for ( j =init ; j < (*m) ; j++)	 
	    {
	      xm[  nel]=GEOX(x[j+j1],y[j+j1],z[j+j1]);
	      if ( finite(xx1) ==0 ) 
		{
		  break;
		}
	      ym[  nel]=GEOY(x[j+j1],y[j+j1],z[j+j1]);
	      if ( finite(yy1)==0)
		{
		  break;
		}
	      nel++;
	    }
	  if ( nel > 0 ) 
	    C2F(dr)("xpolys","v",xm,ym,style,(npoly=1,&npoly),&nel,
		    PI0,PD0,PD0,PD0,PD0,0L,0L);
	  init = j+1;
	  if ( init >= (*m)) break;
	}
    }
  if (flag[2] >=3 ) 
    {
      integer fg;
      C2F(dr)("xget","foreground",&verbose,&fg,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      /** Le triedre que l'on doit voir **/
      if (zbox[InsideU[0]] > zbox[InsideD[0]])
	DrawAxis(xbox,ybox,InsideU,fg);
      else 
	DrawAxis(xbox,ybox,InsideD,fg);
    }
  C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  return(0);
}



int C2F(box3d)(xbox,ybox,zbox)
     double xbox[8],ybox[8],zbox[8];
{
  static integer InsideU[4],InsideD[4],flag[]={1,1,3},verbose=0,fg,narg,fg1;
  /** Calcule l' Enveloppe Convexe de la boite **/
  /** ainsi que les triedres caches ou non **/
  Convex_Box(xbox,ybox,InsideU,InsideD,"X@Y@Z",flag,Cscale.bbox1);
  /** le triedre vu **/
  C2F(dr)("xget","foreground",&verbose,&fg,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if (zbox[InsideU[0]] > zbox[InsideD[0]])
    DrawAxis(xbox,ybox,InsideU,fg);
  else 
    DrawAxis(xbox,ybox,InsideD,fg);
  C2F(dr)("xget","hidden3d",&verbose,&fg1,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** Le triedre cache **/
  if (zbox[InsideU[0]] > zbox[InsideD[0]])
      DrawAxis(xbox,ybox,InsideD,fg1);
  else 
      DrawAxis(xbox,ybox,InsideU,fg1);
  return(0);
}

/*-------------------fonction geom3d  */

int C2F(geom3d)(x,y,z,n)
     double x[],y[],z[];
     integer *n;
{
  integer j;
  GetEch3d();
  for ( j =0 ; j < (*n) ; j++)	 
    {
      double x1,y1;
      x1=TRX(x[j],y[j],z[j]);
      y1=TRY(x[j],y[j],z[j]);
      z[j]=TRZ(x[j],y[j],z[j]);
      x[j]=x1;
      y[j]=y1;
    }
  return(0);
}

/*---------------- Partie Commune -----------
 *  Gestion des echelles 
 */

void SetEch3d(xbox, ybox, zbox, bbox, teta, alpha)
     double *xbox;
     double *ybox;
     double *zbox;
     double *bbox;
     double *teta;
     double *alpha;
{
  SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,1L);
}

/* 
  Recupere les valeurs de l'echelle courante 
  Inutile dorenavant ...
 */

void GetEch3d()
{
  /**  char logflag[2];
  integer IRect[4],*xm,*ym,err=0,aaint[4];
  Scale2D(0L,FRect,IRect,aaint,&scx,&scy,&tr[0],&tr[1],logflag,&xm,&ym,0L,&err);
  **/
}

/* 
  si flag vaut 1 : on redefinit les echelles courantes + m + bbox 
  sinon on ne fait que prendre en compte les changements d'angles
  c'est a dire que l'on change m seulement 
  sans changer les echelles 
  */

void SetEch3d1(xbox, ybox, zbox, bbox, teta, alpha, flag)
     double *xbox;
     double *ybox;
     double *zbox;
     double *bbox;
     double *teta;
     double *alpha;
     integer flag;
{
  double xmmin,ymmax,xmmax,ymmin,FRect[4],tr[2],scx,scy;
  integer *xm,*ym,err=0,IRect[4],ib;
  static double cost=0.5,sint=0.5,cosa=0.5,sina=0.5;
  cost=cos((*teta)*M_PI/180.0);
  sint=sin((*teta)*M_PI/180.0);
  cosa=cos((*alpha)*M_PI/180.0);
  sina=sin((*alpha)*M_PI/180.0);
  Cscale.alpha = *alpha;
  Cscale.theta = *teta;
  Cscale.m[0][0]= -sint    ;    Cscale.m[0][1]= cost      ;    Cscale.m[0][2]= 0;
  Cscale.m[1][0]= -cost*cosa;   Cscale.m[1][1]= -sint*cosa;    Cscale.m[1][2]= sina;
  Cscale.m[2][0]=  cost*sina;   Cscale.m[2][1]= sint*sina;     Cscale.m[2][2]= cosa;
  /** Coordonn\'ees apr\`es transformation g\'eometrique de la **/
  /** boite qui entoure le plot3d                              **/
  /** le plan de projection est defini par x et y              **/
  for (ib=0;ib<6 ;ib++) 
    { 
      if (flag==0) 
	bbox[ib]=Cscale.bbox1[ib];
      else 
	Cscale.bbox1[ib]=bbox[ib];
    }
  xbox[0]=TRX(bbox[0],bbox[2],bbox[4]);
  ybox[0]=TRY(bbox[0],bbox[2],bbox[4]);
  zbox[0]=TRZ(bbox[0],bbox[2],bbox[4]);
  xbox[1]=TRX(bbox[0],bbox[3],bbox[4]);
  ybox[1]=TRY(bbox[0],bbox[3],bbox[4]);
  zbox[1]=TRZ(bbox[0],bbox[3],bbox[4]);
  xbox[2]=TRX(bbox[1],bbox[3],bbox[4]);
  ybox[2]=TRY(bbox[1],bbox[3],bbox[4]);
  zbox[2]=TRZ(bbox[1],bbox[3],bbox[4]);
  xbox[3]=TRX(bbox[1],bbox[2],bbox[4]);
  ybox[3]=TRY(bbox[1],bbox[2],bbox[4]);
  zbox[3]=TRZ(bbox[1],bbox[2],bbox[4]);
  xbox[4]=TRX(bbox[0],bbox[2],bbox[5]);
  ybox[4]=TRY(bbox[0],bbox[2],bbox[5]);
  zbox[4]=TRZ(bbox[0],bbox[2],bbox[5]);
  xbox[5]=TRX(bbox[0],bbox[3],bbox[5]);
  ybox[5]=TRY(bbox[0],bbox[3],bbox[5]);
  zbox[5]=TRZ(bbox[0],bbox[3],bbox[5]);
  xbox[6]=TRX(bbox[1],bbox[3],bbox[5]);
  ybox[6]=TRY(bbox[1],bbox[3],bbox[5]);
  zbox[6]=TRZ(bbox[1],bbox[3],bbox[5]);
  xbox[7]=TRX(bbox[1],bbox[2],bbox[5]);
  ybox[7]=TRY(bbox[1],bbox[2],bbox[5]);
  zbox[7]=TRZ(bbox[1],bbox[2],bbox[5]);
  /** Calcul des echelles en fonction de la taille du dessin **/
  if ( flag == 1)
    {
      static integer aaint[]={2,10,2,10};
      xmmin=  (double) Mini(xbox,8L);xmmax= (double) Maxi(xbox,8L);
      ymmax=  (double) - Mini(ybox,8L);
      ymmin=  (double) - Maxi(ybox,8L);
      FRect[0]=xmmin;FRect[1]= -ymmax;FRect[2]=xmmax;FRect[3]= -ymmin;
      Scale2D(1L,FRect,IRect,aaint,&scx,&scy,&tr[0],&tr[1],"nn",&xm,&ym,0L,&err);
      /** Soit  un point initial de coordonnees X=(x,y,z)' **/
      /** on calcule X1=m*X , puis X2=(scx*(x1-FRect[0])+tr[0],
	scy*(-y1+FRect[3])+tr[1],z1)**/
      /** et (x2,y2) est dessine a l'ecran **/
    }
}

/*
 * Recupere les transformations courantes 
 */

void GetEch3d1(m1, tr1, FRect1, scx1, scy1)
     double (*m1)[3];
     double *tr1;
     double *FRect1;
     double *scx1;
     double *scy1;
{
  char logflag[2];
  integer i,j,IRect[4],*xm,*ym,err=0,aaint[4];
  for (i=0 ; i < 3 ; i++)
    for (j=0 ; j < 3 ; j++)
      m1[i][j]=Cscale.m[i][j];
  Scale2D(0L,FRect1,IRect,aaint,scx1,scy1,&tr1[0],&tr1[1],logflag,&xm,&ym,0L,&err);
}

/*----------------------------------------------------------------
Trace un triedre : Indices[4] donne les indices des points qui 
  constituent le triedre dans les tableaux xbox et ybox 
-----------------------------------------------------------------*/ 

void DrawAxis(xbox, ybox, Indices, style)
     double *xbox;
     double *ybox;
     integer *Indices;
     integer style;
{
  integer ixbox[6],iybox[6],npoly=6;
  integer i,iflag=0;
  for ( i = 0 ; i <= 4 ; i=i+2)
    {
      ixbox[i]=GX(xbox[Indices[0]]);iybox[i]=GY(ybox[Indices[0]]);
    }
  ixbox[1]=GX(xbox[Indices[1]]);iybox[1]=GY(ybox[Indices[1]]);
  ixbox[3]=GX(xbox[Indices[2]]);iybox[3]=GY(ybox[Indices[2]]);
  ixbox[5]=GX(xbox[Indices[3]]);iybox[5]=GY(ybox[Indices[3]]);
  C2F(dr)("xsegs","v",ixbox,iybox,&npoly,&style,&iflag,PI0,PD0,PD0,PD0,PD0,0L,0L);
}

/*---------------------------------------------------------------------
Trace l'enveloppe convexe de la boite contenant le dessin 
et renvoit dans InsideU et InsideD les indices des points dans xbox et ybox
qui sont sur les 2 tri\`edres a l'interieur de l'enveloppe convexe
---------------------------------------------------------------------*/

void Convex_Box(xbox, ybox, InsideU, InsideD, legend, flag, bbox)
     double *xbox;
     double *ybox;
     integer *InsideU;
     integer *InsideD;
     char *legend;
     integer *flag;
     double *bbox;
{
  double xmaxi;
  integer ixbox[8],iybox[8];
  integer xind[8];
  integer ind2,ind3,ind;
  integer p,n,dvect[1];
  integer verbose=0,narg,pat;
  integer i;
  /** dans xbox[8] se trouve l'abscisse des points successifs   **/
  /** de la boite qui continent la surface                      **/
  /** on stocke dans xind[8] les indices des points de la boite **/
  /** qui sont sur l'enveloppe convexe en partant du pointeger en haut **/
  /** a droite et en tournant ds le sens trigonometrique           **/
  /** par exemple avec : **/
  /*      4 ----- 5        */
  /*       /    /|         */
  /*     7----6  |         */
  /*      | 0 | / 1        */
  /*     3----- 2          */
  /** on doit trouver xind={5,4,7,3,2,1}; **/
  /** on en profite pour stocker aussi les points des triedres **/

  xmaxi=((double) Maxi(xbox,8L));
  ind= -1;
  for (i =0 ; i < 8 ; i++)
    {
      MaxiInd(xbox,8L,&ind,xmaxi);
      if ( ind > 3)
	  {
	    xind[0]=ind;
	    break;
	  }
    }
  if (ind < 0 || ind > 8) 
    {
      Scistring("xind out of bounds");
      xind[0]=0;
    }
  UpNext(xind[0],&ind2,&ind3);
  if (ybox[ind2] > ybox[ind3]) 
    {
      xind[1]=ind2;InsideU[0]=ind3;
    }
  else 
    {
      xind[1]=ind3;InsideU[0]=ind2;
    }
  UpNext(ind2,&ind2,&ind3); InsideU[1]=xind[0];
  InsideU[2]=ind2; InsideU[3]=InsideU[0]-4;
  xind[2]=ind2;
  /* le pointeger en bas qui correspond */
  xind[3]=ind2-4;
  DownNext(xind[3],&ind2,&ind3);
  if (ybox[ind2] < ybox[ind3]) 
   {
     xind[4]=ind2;InsideD[0]=ind3;
   }
 else  
   {
     xind[4]=ind3;InsideD[0]=ind2;
   }
  DownNext(ind2,&ind2,&ind3);
  InsideD[1]=xind[3];
  InsideD[2]=ind2;
  InsideD[3]=InsideD[0]+4;
  xind[5]=ind2;
  for (i=0; i < 6 ; i++)
   {
     ixbox[i]=GX(xbox[xind[i]]);
     iybox[i]=GY(ybox[xind[i]]);
   }
  ixbox[6]=ixbox[0];iybox[6]=iybox[0];
  p=7,n=1;
  C2F(dr)("xget","foreground",&verbose,dvect,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** On trace l'enveloppe cvxe **/
  if (flag[2]>=3)C2F(dr)("xpolys","v",ixbox,iybox,dvect,&n,&p
		     ,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","pattern",&verbose,&pat,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","pattern",dvect,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

  if (flag[2]>=3)AxesStrings(flag[2],ixbox,iybox,xind,legend,bbox);
  C2F(dr)("xset","pattern",&pat,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}

/** rajoute des symboles x,y,z : sur les axes     **/
/** et une graduation sur les axes **/
/** (ixbox,iybox) : Coordonnees des points de l'envelloppe cvxe en pixel **/
/** xind : indices des points de l'enveloppe cvxe ds xbox et ybox **/

void AxesStrings(axflag, ixbox, iybox, xind, legend, bbox)
     integer axflag;
     integer *ixbox;
     integer *iybox;
     integer *xind;
     char *legend;
     double *bbox;
{
  integer verbose=0,narg,xz[2];
  integer iof;
  char *loc,*legx,*legy,*legz; 
  integer rect[4],flag=0,x,y;
  double ang=0.0;
  loc=(char *) MALLOC( (strlen(legend)+1)*sizeof(char));
  if ( loc == 0)    
    {
      Scistring("AxesString : No more Place to store Legends\n");
      return;
    }
  strcpy(loc,legend);
  legx=strtok(loc,"@");legy=strtok((char *)0,"@");legz=strtok((char *)0,"@");
  /** le cot\'e gauche ( c'est tjrs un axe des Z **/
  C2F(dr)("xget","wdim",&verbose,xz,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  iof = (xz[0]+xz[1])/50;
  x=ixbox[2]-iof ;y=iybox[2]-iof;
  if ( axflag>=4)
    {
      double fx,fy,fz,lx,ly,lz;
      integer LPoint[2],FPoint[2],Ticsdir[2],xnax[2];
      xnax[0]=5;xnax[1]=2;
      FPoint[0]=ixbox[2];FPoint[1]=iybox[2];
      LPoint[0]=ixbox[3];LPoint[1]=iybox[3];
      Ticsdir[0]= -1;
      Ticsdir[1]=0;
      BBoxToval(&fx,&fy,&fz,xind[2],bbox);
      BBoxToval(&lx,&ly,&lz,xind[3],bbox);
      TDAxis(1L,fz,lz,xnax,FPoint,LPoint,Ticsdir);
    }
  if (legz != 0)
    {
      C2F(dr)("xstringl",legz,&x,&y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xstring",legz,(x=x - rect[2],&x),&y,PI0,&flag
	  ,PI0,PI0,&ang,PD0,PD0,PD0,0L,0L);
    }
  /** le cot\^e en bas \`a gauche **/
  x=inint((ixbox[3]+ixbox[4])/2.0 -iof);
  y=inint((1/3.0)*iybox[3]+(2/3.0)*iybox[4]+iof);
  if ( xind[3]+xind[4] == 3)
    {
      if ( axflag>=4)
	{
	  double fx,fy,fz,lx,ly,lz;
	  integer LPoint[2],FPoint[2],Ticsdir[2],xnax[2];
	  xnax[0]=5;xnax[1]=2;
	  FPoint[0]=ixbox[3];FPoint[1]=iybox[3];
	  LPoint[0]=ixbox[4];LPoint[1]=iybox[4];
	  Ticsdir[0]=ixbox[4]-ixbox[5];
	  Ticsdir[1]=iybox[4]-iybox[5];
	  BBoxToval(&fx,&fy,&fz,xind[3],bbox);
	  BBoxToval(&lx,&ly,&lz,xind[4],bbox);
	  TDAxis(2L,fx,lx,xnax,FPoint,LPoint,Ticsdir);
	}
      if (legx != 0)
	{

	  C2F(dr)("xstringl",legx,&x,&y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xstring",legx,(x=x-rect[2],&x),&y,PI0,&flag
	      ,PI0,PI0,&ang,PD0,PD0,PD0,0L,0L);
	}
    }
  else 
    {
      if ( axflag>=4)
	{
	  double fx,fy,fz,lx,ly,lz;
	  integer LPoint[2],FPoint[2],Ticsdir[2],xnax[2];
	  xnax[0]=5;xnax[1]=2;
	  FPoint[0]=ixbox[3];FPoint[1]=iybox[3];
	  LPoint[0]=ixbox[4];LPoint[1]=iybox[4];
	  Ticsdir[0]=ixbox[4]-ixbox[5];
	  Ticsdir[1]=iybox[4]-iybox[5];
	  BBoxToval(&fx,&fy,&fz,xind[3],bbox);
	  BBoxToval(&lx,&ly,&lz,xind[4],bbox);
	  TDAxis(2L,fy,ly,xnax,FPoint,LPoint,Ticsdir);
	}
      if (legy != 0)
	{

	  C2F(dr)("xstringl",legy,&x,&y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xstring",legy,(x=x-rect[2],&x),&y,PI0,&flag
	      ,PI0,PI0,&ang,PD0,PD0,PD0,0L,0L);
	}
    }
  /** le cot\'e en bas a droite **/
  x=inint((ixbox[4]+ixbox[5])/2+iof);
  y=inint(((2/3.0)*iybox[4]+(1/3.0)*iybox[5])+iof);
  if ( xind[4]+xind[5] == 3)
    {
      if ( axflag>=4)
	{
	  double fx,fy,fz,lx,ly,lz;
	  integer LPoint[2],FPoint[2],Ticsdir[2],xnax[2];
	  xnax[0]=5;xnax[1]=2;
	  FPoint[0]=ixbox[4];FPoint[1]=iybox[4];
	  LPoint[0]=ixbox[5];LPoint[1]=iybox[5];
	  Ticsdir[0]=ixbox[4]-ixbox[3];
	  Ticsdir[1]=iybox[4]-iybox[3];
	  BBoxToval(&fx,&fy,&fz,xind[4],bbox);
	  BBoxToval(&lx,&ly,&lz,xind[5],bbox);
	  TDAxis(3L,fx,lx,xnax,FPoint,LPoint,Ticsdir); 
	}
      if (legx != 0) 
	{
	  C2F(dr)("xstring",legx,&x,&y,PI0,&flag,PI0,PI0,&ang,PD0,PD0,PD0,0L,0L);
	}
    }
  else 
    {
      if ( axflag>=4)
	{
	  double fx,fy,fz,lx,ly,lz;
	  integer LPoint[2],FPoint[2],Ticsdir[2],xnax[2];
	  xnax[0]=5;xnax[1]=2;
	  FPoint[0]=ixbox[4];FPoint[1]=iybox[4];
	  LPoint[0]=ixbox[5];LPoint[1]=iybox[5];
	  Ticsdir[0]=ixbox[4]-ixbox[3];
	  Ticsdir[1]=iybox[4]-iybox[3];
	  BBoxToval(&fx,&fy,&fz,xind[4],bbox);
	  BBoxToval(&lx,&ly,&lz,xind[5],bbox);
	  TDAxis(3L,fy,ly,xnax,FPoint,LPoint,Ticsdir); 
	}
      if (legy != 0) 
	{
	  C2F(dr)("xstring",legy,&x,&y,PI0,&flag,PI0,PI0,&ang,PD0,PD0,PD0,0L,0L);
	}
    }
  FREE(loc);
}

void MaxiInd(vect, n, ind, maxi)
     double *vect;
     integer n;
     integer *ind;
     double maxi;
{
  integer i ;
  if ( *ind+1 < n)
    for (i = *ind+1 ; i < n ; i++)
      if ( vect[i] >= maxi)
	{ *ind=i; break;}
}

/* renvoit les indices des points voisins de ind1 sur la face haute 
   de la boite  */

void UpNext(ind1, ind2, ind3)
     integer ind1;
     integer *ind2;
     integer *ind3;
{
  *ind2 = ind1+1;
  *ind3 = ind1-1;
  if (*ind2 == 8) *ind2 = 4;
  if (*ind3 == 3) *ind3 = 7;
}

void DownNext(ind1, ind2, ind3)
     integer ind1;
     integer *ind2;
     integer *ind3;
{
  *ind2 = ind1+1;
  *ind3 = ind1-1;
  if (*ind2 == 4) *ind2 = 0;
  if (*ind3 == -1) *ind3 = 3;
}


void TDAxis(flag, FPval, LPval, nax, FPoint, LPoint, Ticsdir)
     integer flag;
     double FPval;
     double LPval;
     integer *nax;
     integer *FPoint;
     integer *LPoint;
     integer *Ticsdir;
{
  char fornum[100];
  integer desres,i,barlength;
  double xp, dx,dy,ticsx,ticsy,size;
  integer verbose=0,narg,xz[2];
  C2F(dr)("xget","wdim",&verbose,xz,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  size = xz[0]>=xz[1] ? xz[1]/50.0 : xz[0]/50.0;
  C2F(TDdrawaxis)(size,FPval,LPval,nax,FPoint,LPoint,Ticsdir) ;
  ChoixFormatE(fornum,&desres,Min(FPval,LPval),Max(LPval,FPval),
	       Abs((LPval-FPval))/nax[1]);
  xp= FPval;
  barlength=inint(1.2*size);
  dx= ((double) LPoint[0]-FPoint[0])/((double)nax[1]);
  dy= ((double) LPoint[1]-FPoint[1])/((double)nax[1]);
  ticsx= barlength*( Ticsdir[0])/
    sqrt((double) Ticsdir[0]*Ticsdir[0]+Ticsdir[1]*Ticsdir[1]);
  ticsy= barlength*( Ticsdir[1])/
    sqrt((double) Ticsdir[0]*Ticsdir[0]+Ticsdir[1]*Ticsdir[1]);
  for (i=0; i <= nax[1];i++)
    { double angle=0.0;
      integer flag1=0;
      integer xx=0,yy=0, posi[2],rect[4];
      char foo[100];/*** JPC : must be cleared properly **/
      double lp;
      lp = xp + i*(LPval-FPval)/((double)nax[1]);
      sprintf(foo,fornum,desres,lp);
      C2F(dr)("xstringl",foo,&xx,&yy,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      posi[0]=inint(FPoint[0]+ i*dx + 2*ticsx );
      posi[1]=inint(FPoint[1]+ i*dy + 2*ticsy +rect[3]/2 );
      switch ( flag)
	{
	case 1: posi[0] -= rect[2];
	  /** pour separer ;e 1er arg de l'axe des z de l'axe voisin **/
	  if ( i== nax[1]) posi[1] -= rect[3]/2;
	  break;
	case 2: posi[0] -= rect[2];break;
	}
      C2F(dr)("xstring",foo,&(posi[0]),&(posi[1]),PI0,&flag1,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L);
    }
}


void C2F(TDdrawaxis)(size, FPval, LPval, nax, FPoint, LPoint, Ticsdir)
     double size;
     double FPval;
     double LPval;
     integer *nax;
     integer *FPoint;
     integer *LPoint;
     integer *Ticsdir;
{ 
  integer i;
  double dx,dy,ticsx,ticsy;
  dx= ((double) LPoint[0]-FPoint[0])/((double)nax[1]*nax[0]);
  dy= ((double) LPoint[1]-FPoint[1])/((double)nax[1]*nax[0]);
  ticsx= ( Ticsdir[0])/
    sqrt((double) Ticsdir[0]*Ticsdir[0]+Ticsdir[1]*Ticsdir[1]);
  ticsy= ( Ticsdir[1])/
    sqrt((double) Ticsdir[0]*Ticsdir[0]+Ticsdir[1]*Ticsdir[1]);
  for (i=0; i <= nax[1]*nax[0];i++)
    {       
      integer siz=2,x[2],y[2],iflag=0,style=0;
      x[0] =linint(FPoint[0]+ ((double)i)*dx );
      y[0] =linint(FPoint[1]+ ((double)i)*dy );
      x[1] =linint(x[0]+ ticsx*size);
      y[1] =linint(y[0]+ ticsy*size);
      C2F(dr)("xsegs","v",x,y,&siz,&style,&iflag,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
}


/** Returns the [x,y,z] values of a pointeger given its xbox or ybox indices **/

void BBoxToval(x, y, z, ind, bbox)
     double *x;
     double *y;
     double *z;
     integer ind;
     double *bbox;
{
  switch ( ind)
    {
    case 0:	*x=bbox[0],*y=bbox[2],*z=bbox[4];break;
    case 1:	*x=bbox[0],*y=bbox[3],*z=bbox[4];break;
    case 2:	*x=bbox[1],*y=bbox[3],*z=bbox[4];break;
    case 3:	*x=bbox[1],*y=bbox[2],*z=bbox[4];break;
    case 4:	*x=bbox[0],*y=bbox[2],*z=bbox[5];break;
    case 5:	*x=bbox[0],*y=bbox[3],*z=bbox[5];break;
    case 6:	*x=bbox[1],*y=bbox[3],*z=bbox[5];break;
    case 7:	*x=bbox[1],*y=bbox[2],*z=bbox[5];break;
    }
}

/*-------------------------------------
  interactive rotation of a 3d plot 
--------------------------------------*/

/** Changement interactif de 3d **/
static double theta,alpha;
extern int Check3DPlots();

void I3dRotation()
{
  char driver[4];
  integer flag[3],pixmode,alumode,verbose=0,narg,ww;
  static integer iflag[]={0,0,0,0};
  double xx,yy;
  double theta0,alpha0;
  C2F(dr1)("xget","window",&verbose,&ww,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if ( Check3DPlots("v",&ww) == 0) 
    {
      wininfo("No 3d recorded plots in your graphic window");
      return;
    }
  xx=1.0/Abs(Cscale.WFRect1[0]-Cscale.WFRect1[2]);
  yy=1.0/Abs(Cscale.WFRect1[1]-Cscale.WFRect1[3]);
  C2F(dr)("xget","pixmap",&verbose,&pixmode,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","alufunction",&verbose,&alumode,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  GetDriver1(driver,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if (strcmp("Rec",driver) != 0) 
    {
      Scistring("\n Use the Rec driver for 3f Rotation " );
      return;
    }
  else 
    {
      integer ibutton,in,iwait=0,istr=0;
      integer verbose=0,ww,narg;
      double x0,yy0,x,y,xl,yl,bbox[4];
#ifdef WIN32
      SetWinhdc();
      SciMouseCapture();
      C2F(SetDriver)("Int",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
#else
      C2F(SetDriver)("X11",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
#endif
      if ( pixmode == 0 ) C2F(dr1)("xset","alufunction",(in=6,&in),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xclick","one",&ibutton,&iwait,&istr,PI0,PI0,PI0,&x0,&yy0,PD0,PD0,0L,0L);
      C2F(dr1)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      theta=Cscale.theta ;
      alpha=Cscale.alpha ;

      x0=(x0-Cscale.WFRect1[0])*xx;
      yy0=(yy0-Cscale.WFRect1[1])*yy;
      x=x0;y=yy0;
      theta0=theta;
      alpha0=alpha;
      ibutton=-1;
      while ( ibutton == -1 ) 
	{
	  /* dessin d'un rectangle */
	  theta= theta0 - 180.0*(x-x0);alpha=alpha0 + 180.0*(y-yy0);
	  wininfo("alpha=%.1f,theta=%.1f",alpha,theta); 
	  if ( pixmode == 1) C2F(dr1)("xset","wwpc",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  dbox();
	  if ( pixmode == 1) C2F(dr1)("xset","wshow",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	    C2F(dr1)("xgetmouse","one",&ibutton,&iwait,PI0,PI0,PI0,PI0,&xl, &yl,PD0,PD0,0L,0L);
	    /* effacement du rectangle */
	    dbox();
	    xx=1.0/Abs(Cscale.WFRect1[0]-Cscale.WFRect1[2]);
	    yy=1.0/Abs(Cscale.WFRect1[1]-Cscale.WFRect1[3]);
	    x=(xl-Cscale.WFRect1[0])*xx;
	    y=(yl-Cscale.WFRect1[1])*yy;
	}
      if ( pixmode == 0) C2F(dr1)("xset","alufunction",(in=3,&in),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(SetDriver)(driver,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      C2F(dr1)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xget","window",&verbose,&ww,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xset","alufunction",&alumode,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
#ifdef WIN32
      ReleaseWinHdc();
      SciMouseRelease();
#endif
      Tape_ReplayNewAngle("v",&ww,PI0,PI0,iflag,flag,PI0,&theta,&alpha,bbox,PD0);
    }
}

/**
  Win32, warning when using xor mode
  colors are changed and black is turned to white
  so we must use an other pattern than the black one
  inside dbox
  **/

static void dbox()
{
  double xbox[8],ybox[8],zbox[8];
#ifdef WIN32
  integer verbose=0,pat,pat1=3,narg;
  C2F(dr)("xget","pattern",&verbose,&pat,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","pattern",&pat1,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
#endif
  SetEch3d1(xbox,ybox,zbox,Cscale.bbox1,&theta,&alpha,1L);
  C2F(box3d)(xbox,ybox,zbox);
#ifdef WIN32
  C2F(dr)("xset","pattern",&pat,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
#endif
}






