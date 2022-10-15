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
#include <math.h>
#ifdef THINK_C
#define M_PI	3.14159265358979323846
#else
#include <values.h>
#endif
#include <stdio.h>
#include <string.h>
#include "../machine.h"
#include "Math.h"

#define TRX(x1,y1,z1) ( m[0][0]*(x1) +m[0][1]*(y1) +m[0][2]*(z1))
#define TRY(x1,y1,z1) ( m[1][0]*(x1) +m[1][1]*(y1) +m[1][2]*(z1))
#define TRZ(x1,y1,z1) ( m[2][0]*(x1) +m[2][1]*(y1) +m[2][2]*(z1))
#define GEOX(x1,y1,z1) nint( scx*(TRX(x1,y1,z1)-FRect[0])  +tr[0]);
#define GEOY(x1,y1,z1) nint( scy*(-TRY(x1,y1,z1)+FRect[3]) +tr[1]);
#define GX(x1) nint( scx*(x1-FRect[0])  +tr[0]);
#define GY(y1) nint( scy*(-y1+FRect[3]) +tr[1]);


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

extern char GetDriver_();
static double scx=1,scy=1,FRect[4];
static double m[3][3],tr[2];
/* The current bounding box */
static double bbox1[6]={0.0,1.0,0.0,1.0,0.0,1.0};


plot3dg_(name,func,x,y,z,p,q,teta,alpha,legend,flag,bbox)
     double x[],y[],z[],bbox[];
     int *p,*q;
     double *teta,*alpha;
     int flag[];
     char legend[],name[];
     int (*func)();
{
  double cost=0.5,sint=0.5,cosa=0.5,sina=0.5;
  static int InsideU[4],InsideD[4];
  int polysize,npoly,whiteid,verbose=0,narg;
  int *polyx,*polyy,*fill;
  double xbox[8],ybox[8],zbox[8];
  static int cache,err;
  static double zmin,zmax;
  int i,j;
  /** If Record is on **/
  if (GetDriver_()=='R') 
    StorePlot3D(name,x,y,z,p,q,teta,alpha,legend,flag,bbox);
  /** if flag[1] ==0 then superpose mode **/
  if (flag[1]!=1 && flag[1] != 0)
    {
      bbox[0]=x[0];bbox[1]=x[*p-1];
      bbox[2]=y[0];bbox[3]=y[*q-1];
      zmin=bbox[4]=(double) Mini(z,*p*(*q)); 
      zmax=bbox[5]=(double) Maxi(z,*p*(*q));
    }
  if ( flag[1] !=0)
    SetEch3d(xbox,ybox,zbox,bbox,teta,alpha);
  else
    SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,0);
  /** Calcule l' Enveloppe Convexe de la boite **/
  /** ainsi que les triedres caches ou non **/
  Convex(xbox,ybox,InsideU,InsideD,legend,flag,bbox);
  /** Le triedre cach\'e **/
  if (zbox[InsideU[0]] > zbox[InsideD[0]])
    {
      cache=InsideD[0];
      if (flag[2] >=2 )DrawAxis(xbox,ybox,InsideD);
    }
  else 
    {
      cache=InsideU[0]-4;
      if (flag[2] >=2 )DrawAxis(xbox,ybox,InsideU);
    }
  Alloc(&polyx,&polyy,&fill,5*(*q),5*(*q),(*q),&err);
  if ( err == 0)
    {
      Scistring("plot3dg_ : malloc No more Place\n");
      return;
    };
/** Le plot 3D **/

  C2F(dr)("xget","white",&verbose,&whiteid,&narg,IP0,IP0,IP0,0,0);
  for ( i =0 ; i < (*q)-1 ; i++)
    fill[i]= whiteid+ flag[0];
  polysize=5;
  npoly= (*q)-1;
/** Choix de l'ordre de parcourt **/
  switch (cache)
    {
    case 0 : 
      for ( i =0 ; i < (*p)-1 ; i++)
	{
	  for ( j =0 ; j < (*q)-1 ; j++)	 
	    (*func)(polyx,polyy,fill,whiteid,zmin,zmax,x,y,z,i,j,j,p);
	  C2F(dr)("xliness","str",polyx,polyy,fill,&npoly,&polysize
	      ,IP0,0,0);
	};
      break;
    case 1 : 
      for ( i =0 ; i < (*p)-1 ; i++)
	{for ( j =0  ; j < (*q)-1  ; j++)
	    (*func)(polyx,polyy,fill,whiteid,zmin,zmax,x,y,z,i,j,(*q)-2-j,p);
	 C2F(dr)("xliness","str",polyx,polyy,fill,&npoly,&polysize
	     ,IP0,0,0);
	  };
      break;
    case 2 : 
      for ( i =(*p)-2 ; i >=0  ; i--)
	{for ( j =0 ; j < (*q)-1 ; j++)
	  
	    (*func)(polyx,polyy,fill,whiteid,zmin,zmax,x,y,z,i,j,(*q)-2-j,p);
	    C2F(dr)("xliness","str",polyx,polyy,fill,&npoly,&polysize
		,IP0,0,0);
	  };
      break;
    case 3 : 
      for ( i =(*p)-2 ; i >=0  ; i--)
	{
	  for ( j =0 ; j < (*q)-1 ; j++)
	    (*func)(polyx,polyy,fill,whiteid,zmin,zmax,x,y,z,i,j,j,p);
	  C2F(dr)("xliness","str",polyx,polyy,fill,&npoly,&polysize
	      ,IP0,0,0);
	};
      break;
    }
  /* jpc   if (flag[1] != 0 && flag[2] >=3 ) */
  if ( flag[2] >=3 )
    {
      /** Le triedre que l'on doit voir **/
      if (zbox[InsideU[0]] > zbox[InsideD[0]])
	DrawAxis(xbox,ybox,InsideU);
      else 
	DrawAxis(xbox,ybox,InsideD);
    };
};

/*-------------------------------------------------------------------
   Renvoit dans polyx et polyy le polygone d'une facette 
  de la surface a tracer
--------------------------------------------------------------------*/

DPoints1(polyx,polyy,fill,whiteid,zmin,zmax,x,y,z,i,j,jj1,p)
     int polyx[],polyy[],fill[],i,j,jj1,*p;
     int whiteid;
     double x[],y[],z[],zmin,zmax;
{
  polyx[  5*jj1] =GEOX(x[i]  ,y[j]  ,z[i+(*p)*j]);
  polyy[  5*jj1] =GEOY(x[i]  ,y[j]  ,z[i+(*p)*j]);
  polyx[1 +5*jj1]=GEOX(x[i]  ,y[j+1],z[i+(*p)*(j+1)]);	
  polyy[1 +5*jj1]=GEOY(x[i]  ,y[j+1],z[i+(*p)*(j+1)]);
  polyx[2 +5*jj1]=GEOX(x[i+1],y[j+1],z[(i+1)+(*p)*(j+1)]);
  polyy[2 +5*jj1]=GEOY(x[i+1],y[j+1],z[(i+1)+(*p)*(j+1)]);
  polyx[3 +5*jj1]=GEOX(x[i+1],y[j]  ,z[(i+1)+(*p)*j]);
  polyy[3 +5*jj1]=GEOY(x[i+1],y[j]  ,z[(i+1)+(*p)*j]);
  polyx[4 +5*jj1]=GEOX(x[i]  ,y[j]  ,z[i+(*p)*j]);
  polyy[4 +5*jj1]=GEOY(x[i]  ,y[j]  ,z[i+(*p)*j]);
  fill[jj1]=nint(whiteid*((1/4.0*( z[i+(*p)*j]+ z[i+1+(*p)*j]+
				 z[i+(*p)*(j+1)]+ z[i+1+(*p)*(j+1)])-zmin)
			 /(zmax-zmin)))+whiteid+2;
  
};

DPoints(polyx,polyy,fill,whiteid,zmin,zmax,x,y,z,i,j,jj1,p)
     int polyx[],polyy[],fill[],i,j,jj1,*p;
     int whiteid;
     double x[],y[],z[],zmin,zmax;
{
#ifdef lint 
  whiteid,fill[0],zmin,zmax;
#endif
  polyx[  5*jj1] =GEOX(x[i]  ,y[j]  ,z[i+(*p)*j]);
  polyy[  5*jj1] =GEOY(x[i]  ,y[j]  ,z[i+(*p)*j]);
  polyx[1 +5*jj1]=GEOX(x[i]  ,y[j+1],z[i+(*p)*(j+1)]);
  polyy[1 +5*jj1]=GEOY(x[i]  ,y[j+1],z[i+(*p)*(j+1)]);
  polyx[2 +5*jj1]=GEOX(x[i+1],y[j+1],z[(i+1)+(*p)*(j+1)]);
  polyy[2 +5*jj1]=GEOY(x[i+1],y[j+1],z[(i+1)+(*p)*(j+1)]);
  polyx[3 +5*jj1]=GEOX(x[i+1],y[j]  ,z[(i+1)+(*p)*j]);
  polyy[3 +5*jj1]=GEOY(x[i+1],y[j]  ,z[(i+1)+(*p)*j]);
  polyx[4 +5*jj1]=GEOX(x[i]  ,y[j]  ,z[i+(*p)*j]);
  polyy[4 +5*jj1]=GEOY(x[i]  ,y[j]  ,z[i+(*p)*j]);
};

C2F(plot3d)(x,y,z,p,q,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     int *p,*q;
     double *teta,*alpha;
     int flag[];
     char legend[];
     long int lstr;
{
  plot3dg_("plot3d",DPoints,x,y,z,p,q,teta,alpha,legend,flag,bbox);
};

C2F(plot3d1)(x,y,z,p,q,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     int *p,*q;
     double *teta,*alpha;
     int flag[];
     char legend[];
     long int lstr;
{
  plot3dg_("plot3d1",DPoints1,x,y,z,p,q,teta,alpha,legend,flag,bbox);
};

/*---------------- Param3d.c  -----------*/

C2F(param3d)(x,y,z,n,teta,alpha,legend,flag,bbox,lstr)
     double x[],y[],z[],bbox[];
     int *n;
     double *teta,*alpha;
     int *flag;
     char legend[];
     long int lstr;
{
  double cost=0.5,sint=0.5,cosa=0.5,sina=0.5;
  static int InsideU[4],InsideD[4];
  static double xbox[8],ybox[8],zbox[8];
  int style[1], npoly,j;
  static int cache,err;
  static int *xm,*ym,*zm;
  int verbose=0,xz[10],narg;
  /** If Record is on **/
  if (GetDriver_()=='R') 
    StoreParam3D("param3d",x,y,z,n,teta,alpha,legend,flag,bbox);
  C2F(dr)("xget","dashes",&verbose,xz,&narg,IP0,IP0,IP0,0,0);
  style[0]= -xz[0]-1;
  if (flag[1] != 1 && flag[1] != 0)
    {
      bbox[0]=(double) Mini(x,*n);bbox[1]=(double) Maxi(x,*n);
      bbox[2]=(double) Mini(y,*n);bbox[3]=(double) Maxi(y,*n);
      bbox[4]=(double) Mini(z,*n);bbox[5]=(double) Maxi(z,*n);
    };
  if ( flag[1] !=0)
    SetEch3d(xbox,ybox,zbox,bbox,teta,alpha);
  else 
    SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,0);
  /** Calcule l' Enveloppe Convexe de la boite **/
  /** ainsi que les triedres caches ou non **/
  Convex(xbox,ybox,InsideU,InsideD,legend,flag,bbox);
  /** Le triedre cache **/
  if (zbox[InsideU[0]] > zbox[InsideD[0]])
    {
      cache=InsideD[0];
      if (flag[2] >=2 ) DrawAxis(xbox,ybox,InsideD);
    }
  else 
    {
      cache=InsideU[0]-4;
      if (flag[2] >=2 ) DrawAxis(xbox,ybox,InsideU);
    }
  Alloc(&xm,&ym,&zm,(*n),(*n),0,&err);
  if ( err == 0)
    {
      Scistring("Param3d : malloc  No more Place\n");
      return;
    };
  for ( j =0 ; j < (*n) ; j++)	 
    {
      xm[  j]=GEOX(x[j],y[j],z[j]);
      ym[  j]=GEOY(x[j],y[j],z[j]);
    }
  C2F(dr)("xpolys","v",xm,ym,style,(npoly=1,&npoly),n,
      IP0,0,0);
/*  if (flag[1] != 0 && flag[2] >=3 ) */
  if (flag[2] >=3 ) 
    {
      /** Le triedre que l'on doit voir **/
      if (zbox[InsideU[0]] > zbox[InsideD[0]])
	DrawAxis(xbox,ybox,InsideU);
      else 
	DrawAxis(xbox,ybox,InsideD);
    };
  C2F(dr)("xset","dashes",xz,IP0,IP0,IP0,IP0,IP0,0,0);
};

/*-------------------fonction geom3d  */

C2F(geom3d)(x,y,z,n)
     double x[],y[],z[];
     int *n;
{
  int j;
  GetEch3d();
  for ( j =0 ; j < (*n) ; j++)	 
    {
      double x1;
      x1=TRX(x[j],y[j],z[j]);
      y[j]=TRY(x[j],y[j],z[j]);
      x[j]=x1;
    }
};

/*---------------- Partie Commune -----------
 Gestion des echelles */

SetEch3d(xbox,ybox,zbox,bbox,teta,alpha)
     double *teta,*alpha;
     double xbox[8],ybox[8],zbox[8],bbox[6];
{
  SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,1);
};

GetEch3d()
{
  int IRect[4],*xm,*ym,err=0;
  Scale2D(0,FRect,IRect,&scx,&scy,&tr[0],&tr[1],&xm,&ym,0,&err);
};

/* si flag vaut 1 : on fixe les scale 
   sinon on ne fait que prendre en compte les changements d'angles
   sans changer les echelles 
   */

SetEch3d1(xbox,ybox,zbox,bbox,teta,alpha,flag)
     double *teta,*alpha;
     double xbox[8],ybox[8],zbox[8],bbox[6];
     int flag ;
{
  double xmmin,ymmax,xmmax,ymmin;
  int *xm,*ym,err=0,IRect[4],ib;
  static double cost=0.5,sint=0.5,cosa=0.5,sina=0.5;
  cost=cos((*teta)*M_PI/180.0);
  sint=sin((*teta)*M_PI/180.0);
  cosa=cos((*alpha)*M_PI/180.0);
  sina=sin((*alpha)*M_PI/180.0);
  m[0][0]= -sint    ;    m[0][1]= cost      ;    m[0][2]= 0;
  m[1][0]= -cost*cosa;   m[1][1]= -sint*cosa;    m[1][2]= sina;
  m[2][0]=  cost*sina;   m[2][1]= sint*sina;     m[2][2]= cosa;
  /** Coordonn\'ees apr\`es transformation g\'eometrique de la **/
  /** boite qui entoure le plot3d                              **/
  /** le plan de projection est defini par x et y              **/
  for (ib=0;ib<6 ;ib++) bbox1[ib]=bbox[ib];
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
      xmmin=  (double) Mini(xbox,8);xmmax= (double) Maxi(xbox,8);
      ymmax=  (double) - Mini(ybox,8);
      ymmin=  (double) - Maxi(ybox,8);
      FRect[0]=xmmin;FRect[1]= -ymmax;FRect[2]=xmmax;FRect[3]= -ymmin;
      Scale2D(1,FRect,IRect,&scx,&scy,&tr[0],&tr[1],&xm,&ym,0,&err);
      /** Soit  un point initial de coordonnees X=(x,y,z)' **/
      /** on calcule X1=m*X , puis X2=(scx*(x1-FRect[0])+tr[0],
	scy*(-y1+FRect[3])+tr[1],z1)**/
      /** et (x2,y2) est dessine a l'ecran **/
    };
};

GetEch3d1(m1,tr1,FRect1,scx1,scy1)
     double *scx1,*scy1,FRect1[4];
     double m1[3][3],tr1[2];
{
  int i,j,IRect[4],*xm,*ym,err=0;
  for (i=0 ; i < 3 ; i++)
    for (j=0 ; j < 3 ; j++)
      m1[i][j]=m[i][j];
  Scale2D(0,FRect1,IRect,scx1,scy1,&tr1[0],&tr1[1],&xm,&ym,0,&err);
};

/*----------------------------------------------------------------
Trace un triedre : Indices[4] donne les indices des points qui 
  constituent le triedre dans les tableaux xbox et ybox 
-----------------------------------------------------------------*/ 

DrawAxis(xbox,ybox,Indices)
     double xbox[8],ybox[8];
     int Indices[4];
{
  int ixbox[6],iybox[6];
  int npoly=6;
  int i ;
  for ( i = 0 ; i <= 4 ; i=i+2)
    {
      ixbox[i]=GX(xbox[Indices[0]]);iybox[i]=GY(ybox[Indices[0]]);
    }
  ixbox[1]=GX(xbox[Indices[1]]);iybox[1]=GY(ybox[Indices[1]]);
  ixbox[3]=GX(xbox[Indices[2]]);iybox[3]=GY(ybox[Indices[2]]);
  ixbox[5]=GX(xbox[Indices[3]]);iybox[5]=GY(ybox[Indices[3]]);
  C2F(dr)("xsegs","v",ixbox,iybox,&npoly,IP0, IP0,IP0,0,0);
};

/*---------------------------------------------------------------------
Trace l'enveloppe convexe de la boite contenant le dessin 
et renvoit dans InsideU et InsideD les indices des points dans xbox et ybox
qui sont sur les 2 tri\`edres a l'interieur de l'enveloppe convexe
---------------------------------------------------------------------*/

Convex(xbox,ybox,InsideU,InsideD,legend,flag,bbox)
     double xbox[8],ybox[8],bbox[];
     int InsideU[4],InsideD[4],flag[];
     char legend[];
{
  double xmaxi;
  int ixbox[8],iybox[8],xind[8];
  int ind2,ind3,ind;
  int p,n,dvect[1];
  int i;
  /** dans xbox[8] se trouve l'abscisse des points successifs   **/
  /** de la boite qui continent la surface                      **/
  /** on stocke dans xind[8] les indices des points de la boite **/
  /** qui sont sur l'enveloppe convexe en partant du point en haut **/
  /** a droite et en tournant ds le sens trigonometrique           **/
  /** par exemple avec : **/
  /*      4 ----- 5        */
  /*       /    /|         */
  /*     7----6  |         */
  /*      | 0 | / 1        */
  /*     3----- 2          */
  /** on doit trouver xind={5,4,7,3,2,1}; **/
  /** on en profite pour stocker aussi les points des triedres **/

  xmaxi=((double) Maxi(xbox,8));
  ind= -1;
  for (i =0 ; i < 8 ; i++)
    {
      MaxiInd(xbox,8,&ind,xmaxi);
      if ( ind > 3)
	  {
	    xind[0]=ind;
	    break;
	  };
    };
  if (ind < 0 || ind > 8) 
    {
      Scistring("xind out of bounds");
      xind[0]=0;
    };
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
  /* le point en bas qui correspond */
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
  p=7,n=1;dvect[0]= -1;
  /** On trace l'enveloppe cvxe **/
  if (flag[2]>=3)C2F(dr)("xpolys","v",ixbox,iybox,dvect,&n,&p
		     ,IP0,0,0);
  if (flag[2]>=3)AxesStrings(flag[2],ixbox,iybox,xind,legend,bbox);
}

/** rajoute des symboles x,y,z : sur les axes     **/
/** et une graduation sur les axes **/
/** (ixbox,iybox) : Coordonnees des points de l'envelloppe cvxe en pixel **/
/** xind : indices des points de l'enveloppe cvxe ds xbox et ybox **/

AxesStrings(axflag,ixbox,iybox,xind,legend,bbox)
     char legend[];
     double bbox[];
     int ixbox[],iybox[],xind[],axflag;
{
  int verbose=0,narg,xz[2],iof;
  char *loc,*legx,*legy,*legz; 
  int rect[4],flag=0,x,y;
  double ang=0.0;
  loc=(char *) malloc((unsigned) (strlen(legend)+1)*sizeof(char));
  if ( loc == 0)    
    {
      Scistring("AxesString : No more Place to store Legends\n");
      return;
    };
  strcpy(loc,legend);
  legx=strtok(loc,"@");legy=strtok((char *)0,"@");legz=strtok((char *)0,"@");
  /** le cot\'e gauche ( c'est tjrs un axe des Z **/
  C2F(dr)("xget","wdim",&verbose,xz,&narg, IP0, IP0,IP0,0,0);
  iof = (xz[0]+xz[1])/50;
  x=ixbox[2]-iof ;y=iybox[2]-iof;
  if ( axflag>=4)
    {
      double fx,fy,fz,lx,ly,lz;
      int LPoint[2],FPoint[2],Ticsdir[2],xnax[2],angle;
      xnax[0]=5;xnax[1]=2;
      FPoint[0]=ixbox[2];FPoint[1]=iybox[2];
      LPoint[0]=ixbox[3];LPoint[1]=iybox[3];
      Ticsdir[0]= -1;
      Ticsdir[1]=0;
      BBoxToval(&fx,&fy,&fz,xind[2],bbox);
      BBoxToval(&lx,&ly,&lz,xind[3],bbox);
      TDAxis(1,fz,lz,xnax,FPoint,LPoint,Ticsdir);
    };
  if (legz != 0)
    {
      C2F(dr)("xstringl",legz,&x,&y,rect,IP0,IP0,IP0,0,0);
      C2F(dr)("xstring",legz,(x=x - rect[2],&x),&y,(int *)&ang,&flag
	  ,IP0,IP0,0,0);
    }
  /** le cot\^e en bas \`a gauche **/
  x=(ixbox[3]+ixbox[4])/2-iof;y=((1/3.0)*iybox[3]+(2/3.0)*iybox[4])+iof;
  if ( xind[3]+xind[4] == 3)
    {
      if ( axflag>=4)
	{
	  double fx,fy,fz,lx,ly,lz;
	  int LPoint[2],FPoint[2],Ticsdir[2],xnax[2],angle;
	  xnax[0]=5;xnax[1]=2;
	  FPoint[0]=ixbox[3];FPoint[1]=iybox[3];
	  LPoint[0]=ixbox[4];LPoint[1]=iybox[4];
	  Ticsdir[0]=ixbox[4]-ixbox[5];
	  Ticsdir[1]=iybox[4]-iybox[5];
	  BBoxToval(&fx,&fy,&fz,xind[3],bbox);
	  BBoxToval(&lx,&ly,&lz,xind[4],bbox);
	  TDAxis(2,fx,lx,xnax,FPoint,LPoint,Ticsdir);
	};
      if (legx != 0)
	{

	  C2F(dr)("xstringl",legx,&x,&y,rect,IP0,IP0,IP0,0,0);
	  C2F(dr)("xstring",legx,(x=x-rect[2],&x),&y,(int *)&ang,&flag
	      ,IP0,IP0,0,0);
	}
    }
  else 
    {
      if ( axflag>=4)
	{
	  double fx,fy,fz,lx,ly,lz;
	  int LPoint[2],FPoint[2],Ticsdir[2],xnax[2],angle;
	  xnax[0]=5;xnax[1]=2;
	  FPoint[0]=ixbox[3];FPoint[1]=iybox[3];
	  LPoint[0]=ixbox[4];LPoint[1]=iybox[4];
	  Ticsdir[0]=ixbox[4]-ixbox[5];
	  Ticsdir[1]=iybox[4]-iybox[5];
	  BBoxToval(&fx,&fy,&fz,xind[3],bbox);
	  BBoxToval(&lx,&ly,&lz,xind[4],bbox);
	  TDAxis(2,fy,ly,xnax,FPoint,LPoint,Ticsdir);
	};
      if (legy != 0)
	{

	  C2F(dr)("xstringl",legy,&x,&y,rect,IP0,IP0,IP0,0,0);
	  C2F(dr)("xstring",legy,(x=x-rect[2],&x),&y,(int *) &ang,&flag
	      ,IP0,IP0,0,0);
	}
    };
  /** le cot\'e en bas a droite **/
  x=(ixbox[4]+ixbox[5])/2+iof;y=((2/3.0)*iybox[4]+(1/3.0)*iybox[5])+iof;
  if ( xind[4]+xind[5] == 3)
    {
      if ( axflag>=4)
	{
	  double fx,fy,fz,lx,ly,lz;
	  int LPoint[2],FPoint[2],Ticsdir[2],xnax[2],angle;
	  xnax[0]=5;xnax[1]=2;
	  FPoint[0]=ixbox[4];FPoint[1]=iybox[4];
	  LPoint[0]=ixbox[5];LPoint[1]=iybox[5];
	  Ticsdir[0]=ixbox[4]-ixbox[3];
	  Ticsdir[1]=iybox[4]-iybox[3];
	  BBoxToval(&fx,&fy,&fz,xind[4],bbox);
	  BBoxToval(&lx,&ly,&lz,xind[5],bbox);
	  TDAxis(3,fx,lx,xnax,FPoint,LPoint,Ticsdir); 
	};
      if (legx != 0) 
	{
	  C2F(dr)("xstring",legx,&x,&y,(int *)&ang,&flag,IP0,IP0,0,0);
	}
    }
  else 
    {
      if ( axflag>=4)
	{
	  double fx,fy,fz,lx,ly,lz;
	  int LPoint[2],FPoint[2],Ticsdir[2],xnax[2],angle;
	  xnax[0]=5;xnax[1]=2;
	  FPoint[0]=ixbox[4];FPoint[1]=iybox[4];
	  LPoint[0]=ixbox[5];LPoint[1]=iybox[5];
	  Ticsdir[0]=ixbox[4]-ixbox[3];
	  Ticsdir[1]=iybox[4]-iybox[3];
	  BBoxToval(&fx,&fy,&fz,xind[4],bbox);
	  BBoxToval(&lx,&ly,&lz,xind[5],bbox);
	  TDAxis(3,fy,ly,xnax,FPoint,LPoint,Ticsdir); 
	};
      if (legy != 0) 
	{
	  C2F(dr)("xstring",legy,&x,&y,(int *)&ang,&flag,IP0,IP0,0,0);
	}
    };
  free(loc);
};

MaxiInd(vect,n,ind,maxi)
     double vect[],maxi;
     int n,*ind;
{
  int i ;
  if ( *ind+1 < n)
    for (i = *ind+1 ; i < n ; i++)
      if ( vect[i] >= maxi)
	{ *ind=i; break;};
};

/* renvoit les indices des points voisins de ind1 sur la face haute 
   de la boite  */

UpNext(ind1,ind2,ind3)
     int ind1,*ind2,*ind3;
{
  *ind2 = ind1+1;
  *ind3 = ind1-1;
  if (*ind2 == 8) *ind2 = 4;
  if (*ind3 == 3) *ind3 = 7;
};

DownNext(ind1,ind2,ind3)
     int ind1,*ind2,*ind3;
{
  *ind2 = ind1+1;
  *ind3 = ind1-1;
  if (*ind2 == 4) *ind2 = 0;
  if (*ind3 == -1) *ind3 = 3;
};


TDAxis(flag,FPval,LPval,nax,FPoint,LPoint,Ticsdir)
     double FPval,LPval;
     int flag,nax[2],FPoint[2],LPoint[2],Ticsdir[2];
{
  char fornum[100];
  int desres,i,barlength;
  double xp, dx,dy,ticsx,ticsy,size;
  int verbose=0,narg,xz[2],iof;
  C2F(dr)("xget","wdim",&verbose,xz,&narg, IP0, IP0,IP0,0,0);
  size = xz[0]>=xz[1] ? xz[1]/50.0 : xz[0]/50.0;
  TDdrawaxis_(size,FPval,LPval,nax,FPoint,LPoint,Ticsdir) ;
  ChoixFormatE(fornum,&desres,Min(FPval,LPval),Max(LPval,FPval),
	       Abs((LPval-FPval))/nax[1]);
  xp= FPval;
  barlength=nint(1.2*size);
  dx= ((double) LPoint[0]-FPoint[0])/((double)nax[1]);
  dy= ((double) LPoint[1]-FPoint[1])/((double)nax[1]);
  ticsx= barlength*( Ticsdir[0])/
    sqrt((double) Ticsdir[0]*Ticsdir[0]+Ticsdir[1]*Ticsdir[1]);
  ticsy= barlength*( Ticsdir[1])/
    sqrt((double) Ticsdir[0]*Ticsdir[0]+Ticsdir[1]*Ticsdir[1]);
  for (i=0; i <= nax[1];i++)
    { double angle=0.0;
      int flag1=0;
      int xx=0,yy=0,posi[2],rect[4];
      char foo[100];/*** JPC : must be cleared properly **/
      double lp;
      lp = xp + i*(LPval-FPval)/((double)nax[1]);
      sprintf(foo,fornum,desres,lp);
      C2F(dr)("xstringl",foo,&xx,&yy,rect,IP0,IP0,IP0,0,0);
      posi[0]=FPoint[0]+ i*dx + 2*ticsx ;
      posi[1]=FPoint[1]+ i*dy + 2*ticsy +rect[3]/2 ;
      switch ( flag)
	{
	case 1: posi[0] -= rect[2];
	  /** pour separer ;e 1er arg de l'axe des z de l'axe voisin **/
	  if ( i== nax[1]) posi[1] -= rect[3]/2;
	  break;
	case 2: posi[0] -= rect[2];break;
	};
      C2F(dr)("xstring",foo,&(posi[0]),&(posi[1]),(int *)&angle,&flag1,IP0,IP0,0,0);
    };
}


TDdrawaxis_(size,FPval,LPval,nax,FPoint,LPoint,Ticsdir)
     double size,FPval,LPval;
     int nax[2],FPoint[2],LPoint[2],Ticsdir[2];
{ 
  int i;
  double dx,dy,ticsx,ticsy;
  dx= ((double) LPoint[0]-FPoint[0])/((double)nax[1]*nax[0]);
  dy= ((double) LPoint[1]-FPoint[1])/((double)nax[1]*nax[0]);
  ticsx= ( Ticsdir[0])/
    sqrt((double) Ticsdir[0]*Ticsdir[0]+Ticsdir[1]*Ticsdir[1]);
  ticsy= ( Ticsdir[1])/
    sqrt((double) Ticsdir[0]*Ticsdir[0]+Ticsdir[1]*Ticsdir[1]);
  for (i=0; i <= nax[1]*nax[0];i++)
    {       
      int siz=2,x[2],y[2];
      x[0] =nint(FPoint[0]+ ((double)i)*dx );
      y[0] =nint(FPoint[1]+ ((double)i)*dy );
      x[1] =nint(x[0]+ ticsx*size);
      y[1] =nint(y[0]+ ticsy*size);
      C2F(dr)("xsegs","v",x,y,&siz,IP0, IP0,IP0,0,0);
    };
};


/** Returns the [x,y,z] values of a point given its xbox or ybox indices **/

BBoxToval(x,y,z,ind,bbox)
     int ind;
     double *x,*y,*z,bbox[];
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
    };
};

/*---------------------
  intercative rotation of a 3d plot 
----------------------*/

void loc3DRsci(str,xi,yyi,xf,yyf)
     char *str;
     int *xi,*yyi,*xf,*yyf;
{
  static int i=0;
  double x=0,y=0,z=0,theta=35.0,alpha=45.0;
  int p=1,q=1,flag[3];
  flag[0]=0;flag[1]=1;flag[2]=4;
  theta=theta+5.0*i;i++;
  C2F(plot3d)(&x,&y,&z,&p,&q,&theta,&alpha,"X@Y@Z", flag,bbox1,0L);
};


#define XN3D 21
#define YN3D 21
#define VX3D 10

static int test3D()
{
  double z[XN3D*YN3D],x[XN3D],y[YN3D],bbox[6];
  int flag[3],p,q;
  double teta,alpha;
  int i ,j ;
  for ( i=0 ; i < XN3D ; i++) x[i]=10*i;
  for ( j=0 ; j < YN3D ; j++) y[j]=10*j;
  for ( i=0 ; i < XN3D ; i++)
    for ( j=0 ; j < YN3D ; j++) z[i+XN3D*j]= (i-VX3D)*(i-VX3D)+(j-VX3D)*(j-VX3D);
  p= XN3D ; q= YN3D;  teta=alpha=35;
  flag[0]=2;flag[1]=2,flag[2]=4;
  p= XN3D ; q= YN3D;  teta=alpha=35;
  C2F(plot3d)(x,y,z,&p,&q,&teta,&alpha,"X@Y@Z",flag,bbox,0L);
}


I3dRotation() 
{
  double x1,yy1,xf,yyf;
  int i,ibutton;
  test3D();
   C2F(dr1)("xclick","one",&ibutton,&x1,&yy1,&xf,&yyf,IP0,0,0);
  /* A mettre mieux  */
  /* x2click_("v",&ibutton,&x1,&yy1,&xf,&yyf,loc3DRsci,&i); */
}

