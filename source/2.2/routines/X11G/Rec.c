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

/*----------------------BEGIN-----------------------------------------------
  \def\encadre#1{\paragraph{}\fbox{\begin{minipage}[t]{15cm}#1 \end{minipage}}}
  \section{Graphic High Level Recording function}
---------------------------------------------------------------------------*/
#include <string.h> /* in case of dbmalloc use */
#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <stdio.h>
#include "Math.h"

#include "Rec.h"

static int curwin()
{
  integer verbose=0,narg,winnum;
  C2F(dr)("xget","window",&verbose,&winnum,&narg ,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  return(winnum);
}

/*---------------------------------------------------------------------
\encadre{Le cas des xcall1}
---------------------------------------------------------------------------*/


StoreXcall1(fname,string,x1,n1,x2,n2,x3,n3,x4,n4,x5,n5,x6,n6,dx1,ndx1,dx2,ndx2,dx3,ndx3,dx4,ndx4)
     char fname[],string[];
     integer n1,n2,n3,n4,n5,n6,ndx1,ndx2,ndx3,ndx4;
     integer *x1,*x2,*x3,*x4,*x5,*x6;
     double *dx1,*dx2,*dx3,*dx4;
{
  int debug=0;
  int CopyVect(),CopyVectC(),CopyVectG();
  struct xcall1_rec *lplot;
  if (debug)
    {
      fprintf(stderr,"Inside StoreXcall1 [%s],[%s]\n",fname,string);
      if ( (x1) != (integer *) 0){
	fprintf(stderr,"Argument-1, taille %ld \n",n1);
	if ( (x2) != (integer *) 0){
	  fprintf(stderr,"Argument-2, taille %ld \n",n2);
	  if ( (x3) != (integer *) 0){
	    fprintf(stderr,"Argument-3, taille %ld \n",n3);
	    if ( (x4) != (integer *) 0){
	      fprintf(stderr,"Argument-4, taille %ld \n",n4);
	      if ( (x5) != (integer *) 0){
		fprintf(stderr,"Argument-5, taille %ld \n",n5);
		if ( (x6) != (integer *) 0){
		  fprintf(stderr,"Argument-6, taille %ld \n",n6);
		}
	      }
	    }
	  }
	}
      }
      fprintf(stderr,"That's over\n");
    }
  lplot= ((struct xcall1_rec *) MALLOC(sizeof(struct xcall1_rec)));
  if (lplot != NULL)
    {
      /** On initialise les champs a zero car CopyVect peut ne rien faire 
	si certains champs sont vides **/
      lplot->x1=(integer *) 0;
      lplot->x2=(integer *) 0;
      lplot->x3=(integer *) 0;
      lplot->x4=(integer *) 0;
      lplot->x5=(integer *) 0;
      lplot->x6=(integer *) 0;
      lplot->dx1=(double *) 0;
      lplot->dx2=(double *) 0;
      lplot->dx3=(double *) 0;
      lplot->dx4=(double *) 0;

      lplot->fname=(char *) 0;
      lplot->string=(char *) 0;
      lplot->n1 = n1;
      lplot->n2 = n2;
      lplot->n3 = n3;
      lplot->n4 = n4;
      lplot->n5 = n5;
      lplot->n6 = n6;
      lplot->ndx1 = ndx1;
      lplot->ndx2 = ndx2;
      lplot->ndx3 = ndx3;
      lplot->ndx4 = ndx4;
      if (
	  CopyVectC(&(lplot->fname),fname,((int)strlen(fname))+1) &&
	  CopyVectC(&(lplot->string),string,((int)strlen(string))+1) &&
	  CopyVectLI(&(lplot->x1),x1,(int) n1) &&
	  CopyVectLI(&(lplot->x2),x2,(int) n2) &&
	  CopyVectLI(&(lplot->x3),x3,(int) n3) &&
	  CopyVectLI(&(lplot->x4),x4,(int) n4) &&
	  CopyVectLI(&(lplot->x5),x5,(int) n5) &&
	  CopyVectLI(&(lplot->x6),x6,(int) n6) &&
	  CopyVectF(&(lplot->dx1),dx1,ndx1) &&
	  CopyVectF(&(lplot->dx2),dx2,ndx2) &&
	  CopyVectF(&(lplot->dx3),dx3,ndx3) &&
	  CopyVectF(&(lplot->dx4),dx4,ndx4) 
	  ) 
	{
	  Store("xcall1",(char *) lplot);
	  return;}
    }
  Scistring("\nStore Plot (xcall1): No more place \n");
}

int CopyVectG(pstr,str,n,type)
     char **pstr;
     char *str;
     char type;
     integer n;
{
  if ( str != (char *) 0)
    {
      switch ( type)
	{
	case 'f' : return(CopyVectF((double **) pstr,(double *)str,n));
	case 'i' : return(CopyVectI((int **) pstr,(int *)str,n));
	}
    }
  return(1);
}

  
/*---------------------------------------------------------------------
\encadre{Le cas des changement d'echelle}
---------------------------------------------------------------------------*/



/* Store the scale */

StoreEch(name,WRect,FRect,logflag)
     double WRect[4],FRect[4];
     char name[],logflag[];
{
  int CopyVect();
  struct scale_rec *lplot;
  lplot= ((struct scale_rec *) MALLOC(sizeof(struct scale_rec)));
  if (lplot != NULL)
    {
      lplot->logflag[0]=logflag[0];
      lplot->logflag[1]=logflag[1];
      if ( 
	  CopyVectC(&(lplot->name),name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->Wrect),WRect,4L) &&
	  CopyVectF(&(lplot->Frect),FRect,4L) &&
	  CopyVectF(&(lplot->Frect_kp),FRect,4L) 
	  ) 
	{
	  Store("scale",(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storeEch): No more place \n");
}

  
/*---------------------------------------------------------------------
\encadre{Le cas des plot2d}
---------------------------------------------------------------------------*/



/* Store the plot2d  in the plot list 
   same arguments as plot2d */

StorePlot(name,xf,x,y,n1,n2,style,strflag,legend,brect,aint)
     double x[],y[],brect[];
     integer   *n1,*n2,style[],aint[];
     char legend[],strflag[],xf[],name[];
{
  int CopyVect(),nstyle;
  struct plot2d_rec *lplot;
  lplot= ((struct plot2d_rec *) MALLOC(sizeof(struct plot2d_rec)));
  if ( *n1==1) nstyle= *n1+1;else nstyle= *n1;
  if (lplot != NULL)
    {
      integer n=0;
      switch (xf[0])
	{
	case 'g': n=(*n1)*(*n2);break;
	case 'e': n=0;break;
	case 'o': n=(*n2);break;
	}
      lplot->n1= *n1;
      lplot->n2= *n2;
      if ( 
	  CopyVectC(&(lplot->name),name,((int)strlen(name))+1) &&
	  CopyVectC(&(lplot->xf),xf,((int)strlen(xf))+1) &&
	  ((n == 0) ? 1 : CopyVectF(&(lplot->x),x,n)) &&
	  CopyVectF(&(lplot->y),y,(*n1)*(*n2)) &&
	  CopyVectLI(&(lplot->style),style,nstyle) &&
	  CopyVectC(&(lplot->strflag),strflag,((int)strlen(strflag))+1) &&
	  CopyVectC(&(lplot->strflag_kp),strflag,((int)strlen(strflag))+1) &&
	  CopyVectC(&(lplot->legend),legend,((int)strlen(legend))+1) && 
	  CopyVectF(&(lplot->brect),brect,4L) &&
	  CopyVectF(&(lplot->brect_kp),brect,4L) &&
	  CopyVectLI(&(lplot->aint),aint,4) &&
	  CopyVectLI(&(lplot->aint_kp),aint,4) 
	  ) 
	{
	  Store("plot2d",(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storeplot): No more place \n");
}

  
/*---------------------------------------------------------------------
\encadre{Le cas de xgrid}
---------------------------------------------------------------------------*/

StoreGrid(name,style)
     char name[];
     integer *style ;
{
  int CopyVect();
  struct xgrid_rec *lplot;
  lplot= ((struct xgrid_rec *) MALLOC(sizeof(struct xgrid_rec)));
  if (lplot != NULL)
    {
      lplot->style = *style;
      if ( CopyVectC(&(lplot->name),name,((int)strlen(name))+1) )
	{
	  Store("xgrid",(char *) lplot);
	  return;
	}
    }
  Scistring("\n Store (storegrid): No more place \n");
}


/*---------------------------------------------------------------------
\encadre{Le cas du param3d}
---------------------------------------------------------------------------*/


/* Store the plot in the plot list 
   same arguments as param3d */

StoreParam3D(name,x,y,z,n,teta,alpha,legend,flag,bbox)
     char name[];
     double x[],y[],z[],bbox[];
     integer *n;
     double *teta,*alpha;
     integer flag[];
     char legend[];
{
  int CopyVect();
  struct param3d_rec *lplot;
  lplot= ((struct param3d_rec *) MALLOC(sizeof(struct param3d_rec)));
  if (lplot != NULL)
    {
      lplot->n= *n;
      lplot->teta= *teta;
      lplot->alpha= *alpha;
      if ( 
	  CopyVectC(&(lplot->name), name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->x), x,*n) &&
	  CopyVectF(&(lplot->y), y,*n) &&
	  CopyVectF(&(lplot->z), z,*n) &&
	  CopyVectC(&(lplot->legend), legend, ((int)strlen(legend))+1) && 
	  CopyVectLI(&(lplot->flag), flag,3) &&
	  CopyVectF(&(lplot->bbox), bbox,6L)
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storeparam3d): No more place \n");
}


/*---------------------------------------------------------------------
\encadre{Le cas des plot3d}
---------------------------------------------------------------------------*/


/* Store the plot in the plot list 
   same arguments as plot3d */

StorePlot3D(name,x,y,z,p,q,teta,alpha,legend,flag,bbox)
     char name[];
     double x[],y[],z[],bbox[];
     integer *p,*q;
     double *teta,*alpha;
     integer flag[];
     char legend[];
{
  int CopyVect();
  struct plot3d_rec *lplot;
  lplot= ((struct plot3d_rec *) MALLOC(sizeof(struct plot3d_rec)));
  if (lplot != NULL)
    {
      lplot->p= *p;
      lplot->q= *q;
      lplot->teta= *teta;
      lplot->alpha= *alpha;
      if ( 
	  CopyVectC(&(lplot->name), name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->x), x,*p) &&
	  CopyVectF(&(lplot->y), y,*q) &&
	  CopyVectF(&(lplot->z), z,(*p)*(*q)) &&
	  CopyVectC(&(lplot->legend), legend, ((int)strlen(legend))+1) && 
	  CopyVectLI(&(lplot->flag), flag,3) &&
	  CopyVectF(&(lplot->bbox), bbox,6L)
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storeplot3d): No more place \n");
}


/*---------------------------------------------------------------------
\encadre{Le cas des fac3d}
---------------------------------------------------------------------------*/


/* Store the plot in the plot list 
   same arguments as fac3d */

StoreFac3D(name,x,y,z,p,q,teta,alpha,legend,flag,bbox)
     char name[];
     double x[],y[],z[],bbox[];
     integer *p,*q;
     double *teta,*alpha;
     integer flag[];
     char legend[];
{
  int CopyVect();
  struct fac3d_rec *lplot;
  lplot= ((struct fac3d_rec *) MALLOC(sizeof(struct fac3d_rec)));
  if (lplot != NULL)
    {
      lplot->p= *p;
      lplot->q= *q;
      lplot->teta= *teta;
      lplot->alpha= *alpha;
      if ( 
	  CopyVectC(&(lplot->name), name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->x), x,(*p)*(*q)) &&
	  CopyVectF(&(lplot->y), y,(*p)*(*q)) &&
	  CopyVectF(&(lplot->z), z,(*p)*(*q)) &&
	  CopyVectC(&(lplot->legend), legend, ((int)strlen(legend))+1) && 
	  CopyVectLI(&(lplot->flag), flag,3) &&
	  CopyVectF(&(lplot->bbox), bbox,6L)
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storefac3d): No more place \n");
}

/*---------------------------------------------------------------------
\encadre{Le cas des fec}
---------------------------------------------------------------------------*/



/* Store the plot in the plot list 
   same arguments as fec */

StoreFec(name,x,y,triangles,func,Nnode,Ntr,strflag,legend,brect,aaint)
     double x[],y[],triangles[],func[];
     integer *Nnode,*Ntr;
     double brect[];
     integer  aaint[];
     char legend[],strflag[],name[];
{
  int CopyVect();
  struct fec_rec *lplot;
  lplot= ((struct fec_rec *) MALLOC(sizeof(struct fec_rec)));
  if (lplot != NULL)
    {
      lplot->Nnode= *Nnode;
      lplot->Ntr= *Ntr;
      if ( 
	  CopyVectC(&(lplot->name), name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->x), x,*Nnode) &&
	  CopyVectF(&(lplot->y), y,*Nnode) &&
	  CopyVectF(&(lplot->triangles), triangles,(*Ntr)*5) &&
	  CopyVectF(&(lplot->func), func,*Nnode ) && 
	  CopyVectF(&(lplot->brect), brect,4L) &&
	  CopyVectF(&(lplot->brect_kp), brect,4L) &&
	  CopyVectLI(&(lplot->aaint), aaint,4) &&
	  CopyVectLI(&(lplot->aaint_kp), aaint,4) &&
	  CopyVectC(&(lplot->strflag),strflag,((int)strlen(strflag))+1) &&
	  CopyVectC(&(lplot->strflag_kp),strflag,((int)strlen(strflag))+1) &&
	  CopyVectC(&(lplot->legend),legend,((int)strlen(legend))+1)  
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storefec): No more place \n");
}


/*---------------------------------------------------------------------
\encadre{Le cas des contours}
---------------------------------------------------------------------------*/


/* Store the plot in the plot list 
   same arguments as contour */

StoreContour(name,x,y,z,n1,n2,flagnz,nz,zz,teta,alpha,legend,flag,bbox,zlev)
     char name[];
     double x[],y[],z[],zz[],bbox[6],*zlev;
     integer *n1,*n2,*nz,*flagnz;
     double *teta,*alpha;
     integer flag[3];
     char legend[];
{
  int CopyVect();
  struct contour_rec *lplot;
  lplot= ((struct contour_rec *) MALLOC(sizeof(struct contour_rec)));
  if (lplot != NULL)
    { int res=1;
      lplot->n1= *n1;
      lplot->n2= *n2;
      lplot->nz= *nz;
      lplot->flagnz= *flagnz;
      if (*flagnz != 0)
	res= CopyVectF(&(lplot->zz), zz,*nz);
      else
	lplot->zz= (double *) 0;
      lplot->teta= *teta;
      lplot->alpha= *alpha;
      lplot->zlev= *zlev;
      if ( 
	  res &&
	  CopyVectC(&(lplot->name), name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->x), x,*n1) &&
	  CopyVectF(&(lplot->y), y,*n2) &&
	  CopyVectF(&(lplot->z), z,(*n1)*(*n2)) &&
	  CopyVectC(&(lplot->legend), legend, ((int)strlen(legend))+1) && 
	  CopyVectLI(&(lplot->flag), flag,3) &&
	  CopyVectF(&(lplot->bbox), bbox,6L) 
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storecontour): No more place \n");
}


/*---------------------------------------------------------------------
\encadre{Le cas des niveaux de gris }
---------------------------------------------------------------------------*/


/* Store the plot in the plot list 
   same arguments as gray */

StoreGray(name,x,y,z,n1,n2,strflag,brect,aaint)
     double x[],y[],z[],brect[];
     integer *n1,*n2,aaint[];
     char name[],strflag[];
{
  int CopyVect();
  struct gray_rec *lplot;
  lplot= ((struct gray_rec *) MALLOC(sizeof(struct gray_rec)));
  if (lplot != NULL)
    {
      lplot->n1= *n1;
      lplot->n2= *n2;
      if ( 
	  CopyVectC(&(lplot->name), name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->x), x,*n1) &&
	  CopyVectF(&(lplot->y), y,*n2) &&
	  CopyVectF(&(lplot->z), z,(*n1)*(*n2)) &&
	  CopyVectC(&(lplot->strflag),strflag,((int)strlen(strflag))+1) &&
	  CopyVectC(&(lplot->strflag_kp),strflag,((int)strlen(strflag))+1) &&
	  CopyVectF(&(lplot->brect),brect,4L) &&
	  CopyVectF(&(lplot->brect_kp),brect,4L) &&
	  CopyVectLI(&(lplot->aaint),aaint,4)  &&
	  CopyVectLI(&(lplot->aaint_kp),aaint,4) 
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storegray): No more place \n");
}


/*---------------------------------------------------------------------
\encadre{Le cas des champs de vecteurs}
---------------------------------------------------------------------------*/


StoreChamp(name,x,y,fx,fy,n1,n2,strflag,vrect,arfact)
	double x[],y[],fx[],fy[],vrect[],*arfact;
	integer *n1,*n2;
        char strflag[],name[];
{
  int CopyVect();
  struct champ_rec *lplot;
  lplot= ((struct champ_rec *) MALLOC(sizeof(struct champ_rec)));
  if (lplot != NULL)
    {
      lplot->n1= *n1;
      lplot->n2= *n2;
      lplot->arfact= *arfact;
      if ( 
	  CopyVectC(&(lplot->name),name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->x),x,(*n1)) &&
	  CopyVectF(&(lplot->y),y,(*n2)) &&
	  CopyVectF(&(lplot->fx),fx,(*n1)*(*n2)) &&
	  CopyVectF(&(lplot->fy),fy,(*n1)*(*n2)) &&
	  CopyVectC(&(lplot->strflag),strflag,((int)strlen(strflag))+1) &&
	  CopyVectC(&(lplot->strflag_kp),strflag,((int)strlen(strflag))+1) &&
	  CopyVectF(&(lplot->vrect),vrect,4L) &&
	  CopyVectF(&(lplot->vrect_kp),vrect,4L)
	  ) 
	{
	  Store("champ",(char *) lplot);
	  return;}
    }
  Scistring("\n Store Plot (storechamp): No more place \n");
}

/*---------------------------------------------------------------------
\encadre{Routines de recopie de Vecteurs avec alocation dynamique}
  a appeller avec l > 0 
---------------------------------------------------------------------------*/

int CopyVectI(nx,x,l)
     int **nx,*x;
     integer l;
{ 
  int i;
  if ( x != ( int *) 0) 
    {
      *nx = (int *)  MALLOC(l*sizeof(int));
      if ( *nx == NULL) return(0);
      for ( i=0 ; i < l ; i++) (*nx)[i]= x[i];
    }
  return(1);
}


int CopyVectLI(nx,x,l)
     integer **nx,*x;
     int l;
{ 
  int i;
  if ( x != (integer *) 0) 
    {
      *nx = (integer *)  MALLOC(l*sizeof(integer));
      if ( *nx == NULL) return(0);
      for ( i=0 ; i < l ; i++) (*nx)[i]= x[i];
    }
  return(1);
}

int CopyVectF(nx,x,l)
     double **nx,*x;
     integer l;
{
  int i;
  if ( x != (double *) 0) 
    {
      *nx = (double *)  MALLOC(l*sizeof(double));
      if ( *nx == NULL) return(0);
      for ( i=0 ; i < l ; i++) (*nx)[i]= x[i];
    }
  return(1);
}

int CopyVectC(nx,x,l)
     char **nx,*x;
     int l;
{
  int i;
  if ( x != (char *) 0) 
    {
      *nx = (char *)  MALLOC(l*sizeof(char));
      if ( *nx == NULL) return(0);
      for ( i=0 ; i < l ; i++) (*nx)[i]= x[i];
    }
  return(1);
}

/*---------------------------------------------------------------------
\encadre{Gestion d'une liste de graphiques}
C'est un liste doublement chain\'ee. (pout faciliter la destruction d'un elemnet dans la chaine.
---------------------------------------------------------------------------*/


struct listplot *ListPFirst = NULL ;

/*-------------------------------------------------------------------------
  Fonction a utiliser apres CleanPlots 
  cette fonction remet dans la liste de l'enregstreur les 
  elements du contexte graphique.
---------------------------------------------------------------------------*/

StoreXgc(winnumber)
     integer winnumber;
{
  integer i,win,col;
  integer fontid[2],narg,verbose=0;

  C2F(dr)("xget","window",&verbose,&win,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if ( win != winnumber) 
      C2F(dr)("xset","window",&verbose,&winnumber,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

  C2F(dr)("xget","font",&verbose,fontid,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr1)("xset","font",fontid,fontid+1,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","mark",&verbose,fontid,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr1)("xset","mark",fontid,fontid+1,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  
  C2F(dr)("xget","thickness",&verbose,&i,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr1)("xset","thickness",&i,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  
  C2F(dr)("xget","line mode",&verbose,&i,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr1)("xset","line mode",&i,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  
  C2F(dr)("xget","alufunction",&verbose,&i,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr1)("xset","alufunction",&i,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

  /* pour le clipping on l'enleve */

  C2F(dr1)("xset","clipoff",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

  C2F(dr)("xget","use color",&verbose,&col,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

  C2F(dr1)("xset","use color",&col,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

  if (col == 0) 
    {
      integer xz[10];
      C2F(dr)("xget","pattern",&verbose,&i,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xset","pattern",&i,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

      C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  else 
    {
      C2F(dr)("xget","pattern",&verbose,&i,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xset","pattern",&i,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  if ( win != winnumber) 
      C2F(dr)("xset","window",&win,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

}


/*-------------------------------------------------------------------------
\encadre{Detruit les plots qui sont dans la fenetre winnumber de la liste}
---------------------------------------------------------------------------*/

CleanPlots(unused,winnumber ,v3,v4,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char *unused;
     integer *winnumber,*v3,*v4,*v5,*v6,*v7;

{
  struct listplot *list,*list1;     
  list=ListPFirst;
  while (list)
    {
      if (list->window == *winnumber)
	{
	  if (list->theplot != NULL) {
	    CleanPlot(list->type,list->theplot);
	    FREE(list->theplot);}
	  FREE(list->type);
	  if (list->previous != NULL)
	    (list->previous)->ptrplot=list->ptrplot;
	  else
	    ListPFirst=list->ptrplot;
	  if (list->ptrplot != NULL) 
	    (list->ptrplot)->previous=list->previous;
	  list1=list;
	  list =list->ptrplot;
	  FREE((char *) list1);
	}
      else 
	list=list->ptrplot;
    }
  /* on remet dans la liste le contexte graphique courant */
  StoreXgc(*winnumber);
}



Clean3D(plot)
     char *plot;
{
  struct plot3d_rec *theplot;
  theplot=(struct plot3d_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);FREE(theplot->legend);FREE(theplot->flag);
  FREE(theplot->bbox);
}


CleanFac3D(plot)
     char *plot;
{
  struct fac3d_rec *theplot;
  theplot=(struct fac3d_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);FREE(theplot->legend);FREE(theplot->flag);
  FREE(theplot->bbox);
}


CleanFec(plot)
     char *plot;
{
  struct fec_rec *theplot;
  theplot=(struct fec_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->triangles);  FREE(theplot->func);
  FREE(theplot->legend);
  FREE(theplot->strflag);  FREE(theplot->strflag_kp);
  FREE(theplot->brect);   FREE(theplot->brect_kp); 
  FREE(theplot->aaint);  FREE(theplot->aaint_kp);

}

CleanContour(plot)
     char *plot;
{
  struct contour_rec *theplot;
  theplot=(struct contour_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);FREE(theplot->zz);FREE(theplot->legend);FREE(theplot->flag);
  FREE(theplot->bbox);
}

CleanGray(plot)
     char *plot;
{
  struct gray_rec *theplot;
  theplot=(struct gray_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);
  FREE(theplot->strflag);
  FREE(theplot->brect);FREE(theplot->aaint);   
  FREE(theplot->strflag_kp);
  FREE(theplot->brect_kp);FREE(theplot->aaint_kp);   
}

CleanParam3D(plot)
     char *plot;
{
  struct param3d_rec *theplot;
  theplot=(struct param3d_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);FREE(theplot->legend);FREE(theplot->flag);
  FREE(theplot->bbox);
}

Clean2D(plot)
     char *plot;
{
  struct plot2d_rec *theplot;
  theplot=(struct plot2d_rec *) plot;
  FREE(theplot->name);    
  if ( theplot->xf[0] != 'e') FREE(theplot->x);
  FREE(theplot->xf);FREE(theplot->y);     
  FREE(theplot->style);FREE(theplot->strflag);
  FREE(theplot->legend);FREE(theplot->brect);FREE(theplot->aint);   
  FREE(theplot->strflag_kp);
  FREE(theplot->brect_kp);FREE(theplot->aint_kp);   
}


CleanGrid(plot)
     char *plot;
{
  struct xgrid_rec *theplot;
  theplot=(struct xgrid_rec *) plot;
  FREE(theplot->name);    
}

CleanEch(plot)
     char *plot;
{
  struct scale_rec *theplot;
  theplot=(struct scale_rec *) plot;
  FREE(theplot->name);    
  FREE(theplot->Wrect);
  FREE(theplot->Frect);     
  FREE(theplot->Frect_kp);     
}


CleanX1(plot)
     char *plot;
{
  struct xcall1_rec *theplot;
  theplot=(struct xcall1_rec *) plot;
  FREE(theplot->fname);    
  FREE(theplot->string);
  FREE(theplot->x1);
  FREE(theplot->x2);
  FREE(theplot->x3);
  FREE(theplot->x4);
  FREE(theplot->x5);
  FREE(theplot->x6);
  FREE(theplot->dx1);
  FREE(theplot->dx2);
  FREE(theplot->dx3);
  FREE(theplot->dx4);
}

CleanChamp(plot)
     char *plot;
{
  struct champ_rec *theplot;
  theplot=(struct champ_rec *) plot;
  FREE(theplot->name);    
  FREE(theplot->x);FREE(theplot->y);     
  FREE(theplot->fx);FREE(theplot->fy);     
  FREE(theplot->strflag);FREE(theplot->vrect);
  FREE(theplot->strflag_kp);FREE(theplot->vrect_kp);
}

typedef  struct  {
  char *name;
  int  (*clean)();} CleanTable;

static CleanTable CTable[] ={
    "champ",CleanChamp,
    "contour",CleanContour,
    "fac3d",CleanFac3D,
    "fac3d1",CleanFac3D,
    "fec",CleanFec,
    "gray",CleanGray,
    "param3d",CleanParam3D,
    "plot2d",Clean2D,
    "plot3d",Clean3D,
    "plot3d1",Clean3D,
    "scale",CleanEch,
    "xcall1",CleanX1,
    "xgrid",CleanGrid,
    (char *)NULL,NULL};

CleanPlot(type,plot)
     char type[];
     char *plot;
{
  int i=0;
  while ( CTable[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(type,CTable[i].name);
       if ( j == 0 ) 
	 { 
	   (*(CTable[i].clean))(plot);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       sciprint("Unknown Plot type <%s>\r\n",type);
	       return;
	     }
	   else i++;
	 }
     }
  sciprint("Unknown Plot type <%s>\r\n",type);
}


/*-------------------------------------------------------------------------
Change les angles alpha theta dans tous les plot3d stockes 
change  aussi flag et box suivant la valeur de iflag.
iflag est de longueur [4] si iflag[i] != 0 cela veut dire qu'il faut changer le 
flag[i] en utilisant celui de l'argument flag.
iflag[4] sert a dire s'il faut ou pas changer bbox 
---------------------------------------------------------------------------*/


NAPlots(unused,winnumber,theta,alpha,iflag,flag,bbox)
     char *unused;
     integer *winnumber,*iflag,*flag;
     double *bbox;
     double *theta,*alpha;
{
  struct listplot *list;
#ifdef lint 
  *unused;
#endif
  list=ListPFirst;
  while (list)
    {
      if (list->window == *winnumber && list->theplot != NULL) 
	    NAPlot(list->type,list->theplot,theta,alpha,iflag,flag,bbox);
      list =list->ptrplot;
    }
}

NA3D(plot,theta,alpha,iflag,flag,bbox)
     integer *iflag,*flag;
     char *plot;
     double *theta,*alpha;
     double *bbox;
{
  int i;
  struct plot3d_rec *theplot;
  theplot=(struct plot3d_rec *) plot;
  theplot->teta=*theta;
  theplot->alpha=*alpha;
  for (i=0 ; i< 3 ; i++) 
      if (iflag[i]!=0) theplot->flag[i] = flag[i];
  if ( iflag[3] != 0) 
    for ( i= 0 ; i < 6 ; i++ ) 
            theplot->bbox[i] = bbox[i];
}

NAFac3D(plot,theta,alpha,iflag,flag,bbox)
     integer *iflag,*flag;
     char *plot;
     double *theta,*alpha;
     double *bbox;
{
  int i;
  struct fac3d_rec *theplot;
  theplot=(struct fac3d_rec *) plot;
  theplot->teta=*theta;
  theplot->alpha=*alpha;
  for (i=0 ; i< 3 ; i++) 
      if (iflag[i]!=0) theplot->flag[i] = flag[i];
  if ( iflag[3] != 0) 
    for ( i= 0 ; i < 6 ; i++ ) 
            theplot->bbox[i] = bbox[i];
}

NAContour(plot,theta,alpha,iflag,flag,bbox)
     integer *iflag,*flag;
     char *plot;
     double *bbox;
     double *theta,*alpha;
{
  int i;
  struct contour_rec *theplot;
  theplot=(struct contour_rec *) plot;
  theplot->teta=*theta;
  theplot->alpha=*alpha;
  for (i=0 ; i< 3 ; i++) 
      if (iflag[i]!=0) theplot->flag[i] = flag[i];
  if ( iflag[3] != 0) 
    for ( i= 0 ; i < 6 ; i++ ) 
            theplot->bbox[i] = bbox[i];
}

NAParam3D(plot,theta,alpha,iflag,flag,bbox)
     char *plot;
     integer *iflag,*flag;
     double *bbox;
     double *theta,*alpha;
{
  int i;
  struct param3d_rec *theplot;
  theplot=(struct param3d_rec *) plot;
  theplot->teta=*theta;
  theplot->alpha=*alpha;
  for (i=0 ; i< 3 ; i++) 
      if (iflag[i]!=0) theplot->flag[i] = flag[i];
  if ( iflag[3] != 0) 
    for ( i= 0 ; i < 6 ; i++ ) 
            theplot->bbox[i] = bbox[i];
}


typedef  struct  {
  char *name;
  int  (*NA)();} NATable;

static NATable NACTable[] ={
    "contour",NAContour,
    "fac3d",NAFac3D,
    "fac3d1",NAFac3D,
    "param3d",NAParam3D,
    "plot3d",NA3D,
    "plot3d1",NA3D,
    (char *)NULL,NULL};

NAPlot(type,plot,alpha,theta,iflag,flag,bbox)
     char type[];
     integer *iflag,*flag;
     char *plot;
     double *alpha,*theta;
     double *bbox;
{
  int i=0;
  while ( NACTable[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(type,NACTable[i].name);
       if ( j == 0 ) 
	 { 
	   (*(NACTable[i].NA))(plot,alpha,theta,iflag,flag,bbox);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       /** sciprint("Unknown Plot type <%s>\r\n",type); **/
	       return;
	     }
	   else i++;
	 }
     }
}

/* 
  Change l'echelle ds tous les plots 2D stockes 
  suivant flag[0] 1 change bbox 
  si flag[1]==1 change aaint 
*/

SCPlots(unused,winnumber,flag,bbox,aaint)
     char *unused;
     integer *winnumber;
     integer flag[2];
     double *bbox;
     integer *aaint;
{
  struct listplot *list;
#ifdef lint 
  *unused;
#endif
  list=ListPFirst;
  while (list)
    {
      if (list->window == *winnumber && list->theplot != NULL) 
	    SCPlot(list->type,list->theplot,flag,bbox,aaint);
      list =list->ptrplot;
    }
}


SC2D(plot,flag,bbox,aaint)
     char *plot;
     double *bbox;
     integer *aaint;
     integer flag[2];
{
  int i;
  struct plot2d_rec *theplot;
  theplot=(struct plot2d_rec *) plot;
  /* on passe en mode autoscale 5= on utilise bbox et on `regradue' dessus */
  if ( theplot->strflag[1] == '2' ||  theplot->strflag[1] == '1' )
    theplot->strflag[1] = '5';
  for ( i = 0 ; i < 4 ; i++)
    {
      if (flag[0]==1)  theplot->brect[i]=bbox[i];
      if (flag[1]==1)  theplot->aint[i]=aaint[i];
    }
}

SCgray(plot,flag,bbox,aaint)
     char *plot;
     double *bbox;
     integer *aaint;
     integer flag[2];
{
  int i;
  struct gray_rec *theplot;
  theplot=(struct gray_rec *) plot;
  /* on passe en mode autoscale 5= on utilise bbox et on `regradue' dessus */
  if ( theplot->strflag[1] == '2' ||  theplot->strflag[1] == '1' )
    theplot->strflag[1] = '5';
  for ( i = 0 ; i < 4 ; i++)
    {
      if (flag[0]==1)  theplot->brect[i]=bbox[i];
      if (flag[1]==1)  theplot->aaint[i]=aaint[i];
    }
}

SCchamp(plot,flag,bbox,aaint)
     char *plot;
     double *bbox;
     integer *aaint;
     integer flag[2];
{
  int i;
  struct champ_rec *theplot;
  theplot=(struct champ_rec *) plot;
  /* on passe en mode autoscale 5= on utilise bbox et on `regradue' dessus */
  if ( theplot->strflag[1] == '2' ||  theplot->strflag[1] == '1' )
    theplot->strflag[1] = '5';
  for ( i = 0 ; i < 4 ; i++)
    {
      if (flag[0]==1)  theplot->vrect[i]=bbox[i];
    }
}

SCfec(plot,flag,bbox,aaint)
     char *plot;
     double *bbox;
     integer *aaint;
     integer flag[2];
{
  int i;
  struct fec_rec *theplot;
  theplot=(struct fec_rec *) plot;
  /* on passe en mode autoscale 5= on utilise bbox et on `regradue' dessus */
  if ( theplot->strflag[1] == '2' ||  theplot->strflag[1] == '1' )
    theplot->strflag[1] = '5';
  for ( i = 0 ; i < 4 ; i++)
    {
      if (flag[0]==1)  theplot->brect[i]=bbox[i];
      if (flag[1]==1)  theplot->aaint[i]=aaint[i];
    }
}

SCEch(plot,flag,bbox,aaint)
     char *plot;
     double *bbox;
     integer *aaint;
     integer flag[2];
{
  int i;
  struct scale_rec *theplot;
  theplot =   (struct scale_rec *) plot;
  for ( i = 0 ; i < 4 ; i++)
    {
      if (flag[0]==1)  theplot->Frect[i]=bbox[i];
    }
}

SCvoid(plot,flag,bbox,aaint)
     char *plot;
     double *bbox;
     integer *aaint;
     integer flag[2];
{}

typedef  struct  {
  char *name;
  int  (*SC)();} SCTable;

static SCTable SCCTable[] ={
  "champ", SCchamp,
  "contour",SCvoid,
  "fac3d",SCvoid,
  "fac3d1",SCvoid,
  "fec", SCfec,
  "gray", SCgray,
  "param3d",SCvoid,
  "plot2d",SC2D,
  "plot3d",SCvoid,
  "plot3d1",SCvoid,
  "scale",SCEch,
  "xcall1",SCvoid,
  "xgrid",SCvoid,
  (char *)NULL,NULL};

SCPlot(type,plot,flag,bbox,aaint)
     char type[];
     char *plot;
     double *bbox;
     integer *aaint;
     integer flag[2];

{
  int i=0;
  while ( SCCTable[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(type,SCCTable[i].name);
       if ( j == 0 ) 
	 { 
	   (*(SCCTable[i].SC))(plot,flag,bbox,aaint);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       sciprint("Unknow Plot type <%s>\r\n",type);
	       return;
	     }
	   else i++;
	 }
     }
  sciprint("Unknow Plot type <%s>\r\n",type);
}


/* 
  Le Undo de SC.
*/

UnSCPlots(unused,winnumber)
     char *unused;
     integer *winnumber;
{
  struct listplot *list;
#ifdef lint 
  *unused;
#endif
  list=ListPFirst;
  while (list)
    {
      if (list->window == *winnumber && list->theplot != NULL) 
	    UnSCPlot(list->type,list->theplot);
      list =list->ptrplot;
    }
}

UnSC2D(plot)
     char *plot;
{
  int i;
  struct plot2d_rec *theplot;
  theplot=(struct plot2d_rec *) plot;
  strcpy( theplot->strflag,theplot->strflag_kp);
  for ( i = 0 ; i < 4 ; i++)
    {
      theplot->brect[i]=theplot->brect_kp[i];
      theplot->aint[i]=theplot->aint_kp[i];
    }
}

UnSCgray(plot)
     char *plot;
{
  int i;
  struct gray_rec *theplot;
  theplot=(struct gray_rec *) plot;
  strcpy( theplot->strflag,theplot->strflag_kp);
  for ( i = 0 ; i < 4 ; i++)
    {
      theplot->brect[i]=theplot->brect_kp[i];
      theplot->aaint[i]=theplot->aaint_kp[i];
    }
}

UnSCchamp(plot)
     char *plot;
{
  int i;
  struct champ_rec *theplot;
  theplot=(struct champ_rec *) plot;
  strcpy( theplot->strflag,theplot->strflag_kp);
  for ( i = 0 ; i < 4 ; i++)
    {
      theplot->vrect[i]=theplot->vrect_kp[i];
    }
}

UnSCfec(plot)
     char *plot;
{
  int i;
  struct fec_rec *theplot;
  theplot=(struct fec_rec *) plot;
  strcpy( theplot->strflag,theplot->strflag_kp);
  for ( i = 0 ; i < 4 ; i++)
    {
      theplot->brect[i]=theplot->brect_kp[i];
      theplot->aaint[i]=theplot->aaint_kp[i];
    }
}

UnSCEch(plot)
     char *plot;
{
  int i;
  struct scale_rec *theplot;
  theplot =   (struct scale_rec *) plot;
  for ( i = 0 ; i < 4 ; i++)
    {
      theplot->Frect[i]=theplot->Frect_kp[i];
    }
}

UnSCvoid(plot)
     char *plot;
{}

typedef  struct  {
  char *name;
  int  (*UnSC)();} UnSCTable;

static UnSCTable UnSCCTable[] ={
  "champ", UnSCchamp,
  "contour",UnSCvoid,
  "fac3d",UnSCvoid,
  "fac3d1",UnSCvoid,
  "fec", UnSCfec,
  "gray", UnSCgray,
  "param3d",UnSCvoid,
  "plot2d",UnSC2D,
  "plot3d",UnSCvoid,
  "plot3d1",UnSCvoid,
  "scale",UnSCEch,
  "xcall1",UnSCvoid,
  "xgrid",UnSCvoid,
  (char *)NULL,NULL};

UnSCPlot(type,plot)
     char type[];
     char *plot;
{
  int i=0;
  while ( UnSCCTable[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(type,UnSCCTable[i].name);
       if ( j == 0 ) 
	 { 
	   (*(UnSCCTable[i].UnSC))(plot);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       sciprint("Unknow Plot type <%s>\r\n",type);
	       return;
	     }
	   else i++;
	 }
     }
  sciprint("Unknow Plot type <%s>\r\n",type);
}

/***************************************************
  Recherche si l'on a fait du 3d 
****************************************************/

int Check3DPlots(unused,winnumber)
     char *unused;
     integer *winnumber;
{
  struct listplot *list;
#ifdef lint 
  *unused;
#endif
  list=ListPFirst;
  while (list)
    {
      if (list->window == *winnumber && list->theplot != NULL) 
	{
	  if ( strcmp(list->type,"fac3d") == 0 || strcmp(list->type,"fac3d1")==0 
	      || strcmp(list->type,"contour")==0 || strcmp(list->type,"param3d")==0
	      || strcmp(list->type,"plot3d")==0 || strcmp(list->type,"plot3d1")==0 ) 
	    return(1);
	}
      list =list->ptrplot;
    }
  return(0);
}


/***************************************************
  Recherche si l'on a fait des des xsetech 
  pour voir s'il faut interdire les zooms 
****************************************************/

int EchCheckSCPlots(unused,winnumber)
     char *unused;
     integer *winnumber;
{
  struct listplot *list;
  int res = 0;
#ifdef lint 
  *unused;
#endif
  list=ListPFirst;
  while (list)
    {
      if (list->window == *winnumber && list->theplot != NULL) 
	{
	  if ( strcmp(list->type,"scale") == 0 ) 
	    res++;
	}
      list =list->ptrplot;
    }
  return(res);
}

/*---------------------------------------------------------------------
\encadre{Redessine \`a nouveau les dessin stock\'es en changeant 
   l'echelle 2D }
---------------------------------------------------------------------------*/

Tape_ReplayUndoScale(unused,winnumber)
     char *unused;
     integer *winnumber;
{ 
  UnSCPlots(unused,winnumber);
  Tape_Replay("v",winnumber,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
}


/*---------------------------------------------------------------------
\encadre{Redessine \`a nouveau les dessin stock\'es en changeant 
   l'echelle 2D }
---------------------------------------------------------------------------*/

Tape_ReplayNewScale(unused,winnumber,flag,v1,aaint,v6,v7,bbox,dx2,dx3,dx4)
     double *dx2,*dx3,*dx4;
     char *unused;
     integer *winnumber;
     double *bbox;
     integer *aaint,flag[2],*v6,*v7,*v1;
{ 
  SCPlots(unused,winnumber,flag,bbox,aaint);
  Tape_Replay("v",winnumber,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
}

/*---------------------------------------------------------------------
  Change les theta, alpha dans la structure de donnee 
  plus flag et bbox ( voir NAPlots )
  puis redessine ce qui est enregistre 
---------------------------------------------------------------------------*/
extern char GetDriver_();

Tape_ReplayNewAngle(unused,winnumber,v1,v2,iflag,flag,v3,theta,alpha,bbox,dx4)
     double *dx4;
     char *unused;
     integer *winnumber,*iflag,*flag,*v1,*v2,*v3;
     double *bbox;
     double *theta,*alpha;
{ 
  NAPlots(unused,winnumber,theta,alpha,iflag,flag,bbox);
  Tape_Replay("v",winnumber,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
}

/*---------------------------------------------------------------------
  Redessine \`a nouveau les dessin stock\'es
---------------------------------------------------------------------------*/

Tape_Replay(unused,winnumber,v3,v4,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char *unused;
     integer *winnumber,*v3,*v4,*v5,*v6,*v7;
{ 
  char name[4];
  GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if (ListPFirst != NULL)
    {
      if ( name[0] =='R' )
	C2F(dr)("xsetdr","X11",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      Tape_Replay1(ListPFirst,*winnumber);
      C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
}

Tape_Replay1(list,winnumber)
     struct listplot *list;
     integer winnumber;
{
  if (list->window == winnumber) GReplay(list->type,list->theplot);
  if (list->ptrplot != NULL) Tape_Replay1(list->ptrplot,winnumber);
}

Replay3D(theplot)
     char *theplot;

{
  struct plot3d_rec *pl3d;
  pl3d= (struct plot3d_rec *)theplot;
  C2F(plot3d)(pl3d->x,pl3d->y,pl3d->z,&pl3d->p,&pl3d->q,&pl3d->teta,
	  &pl3d->alpha,pl3d->legend,pl3d->flag,pl3d->bbox,0L);
}

ReplayFac3D(theplot)
     char *theplot;

{
  struct fac3d_rec *pl3d;
  pl3d= (struct fac3d_rec *)theplot;
  C2F(fac3d)(pl3d->x,pl3d->y,pl3d->z,&pl3d->p,&pl3d->q,&pl3d->teta,
	  &pl3d->alpha,pl3d->legend,pl3d->flag,pl3d->bbox,0L);
}

ReplayFac3D1(theplot)
     char *theplot;

{
  struct fac3d_rec *pl3d;
  pl3d= (struct fac3d_rec *)theplot;
  C2F(fac3d1)(pl3d->x,pl3d->y,pl3d->z,&pl3d->p,&pl3d->q,&pl3d->teta,
	  &pl3d->alpha,pl3d->legend,pl3d->flag,pl3d->bbox,0L);
}

ReplayFec(theplot)
     char *theplot;

{
  struct fec_rec *plfec;
  plfec= (struct fec_rec *)theplot;
  C2F(fec)(plfec->x,plfec->y,plfec->triangles,plfec->func,
	   &plfec->Nnode,&plfec->Ntr,
	   plfec->strflag,plfec->legend,plfec->brect,plfec->aaint,0L,0L);
}

ReplayContour(theplot)
     char *theplot;
{
  struct contour_rec *pl3d;
  pl3d= (struct contour_rec *)theplot;
  C2F(contour)(pl3d->x,pl3d->y,pl3d->z,&pl3d->n1,&pl3d->n2,&pl3d->flagnz,&pl3d->nz,
	   pl3d->zz,&pl3d->teta,
	  &pl3d->alpha,pl3d->legend,pl3d->flag,pl3d->bbox,&pl3d->zlev,0L);
}


ReplayGray(theplot)
     char *theplot;
{
  struct gray_rec *pl3d;
  pl3d= (struct gray_rec *)theplot;
  C2F(xgray)(pl3d->x,pl3d->y,pl3d->z,&pl3d->n1,&pl3d->n2,
	     pl3d->strflag,pl3d->brect,pl3d->aaint,0L);
}


ReplayParam3D(theplot)
     char *theplot;
{
  struct param3d_rec *pl3d;
  pl3d= (struct param3d_rec *)theplot;
  C2F(param3d)(pl3d->x,pl3d->y,pl3d->z,&pl3d->n,&pl3d->teta,
	  &pl3d->alpha,pl3d->legend,pl3d->flag,pl3d->bbox,0L);
}

Replay3D1(theplot)
     char *theplot;
{
  struct plot3d_rec *pl3d;
  pl3d= (struct plot3d_rec *)theplot;
  C2F(plot3d1)(pl3d->x,pl3d->y,pl3d->z,&pl3d->p,&pl3d->q,&pl3d->teta,
	  &pl3d->alpha,pl3d->legend,pl3d->flag,pl3d->bbox,0L);
}


typedef  struct  {
  char *name;
  int  (*fonc)();} OpTab ;

static int fnvide_() {}
extern int C2F(plot2d1)(),C2F(plot2d2)(),C2F(plot2d3)(),C2F(plot2d4)();

OpTab plottab[] ={
  "plot2d1",C2F(plot2d1),
  "plot2d2",C2F(plot2d2),
  "plot2d3",C2F(plot2d3),
  "plot2d4",C2F(plot2d4),
  (char *) NULL,fnvide_};


Replay2D(theplot)
     char *theplot;
{
  int i=0;
  struct plot2d_rec *pl2d;
  pl2d= (struct plot2d_rec *)theplot;
      while ( plottab[i].name != (char *) NULL)
      {
       int j;
       j = strcmp(pl2d->name,plottab[i].name);
       if ( j == 0 ) 
	 { 
	   (*(plottab[i].fonc))(pl2d->xf,
		    pl2d->x,pl2d->y,&(pl2d->n1),&(pl2d->n2),
		    pl2d->style,pl2d->strflag,pl2d->legend,
		    pl2d->brect,pl2d->aint,0L,0L,0L);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       sciprint("\nUnknow operator <%s>\r\n",pl2d->name);
	       return;
	     }
	   else i++;
	 }
     }
      sciprint("\n Unknow  operator <%s>\r\n",pl2d->name);
}

ReplayGrid(theplot)
     char *theplot;
{
  struct xgrid_rec *plch;
  plch= (struct xgrid_rec *)theplot;
  C2F(xgrid)(&(plch->style));
}

ReplayEch(theplot)
     char *theplot;
{
  struct scale_rec *plch;
  plch= (struct scale_rec *)theplot;
  C2F(setscale2d)(plch->Wrect,plch->Frect,plch->logflag,0L);
}

ReplayChamp(theplot)
     char *theplot;
{
  struct champ_rec *plch;
  plch= (struct champ_rec *)theplot;
  if ( strcmp(plch->name,"champ")==0)
    C2F(champ)(plch->x,plch->y,plch->fx,plch->fy,&(plch->n1),&(plch->n2),
	       plch->strflag,plch->vrect,&(plch->arfact),0L);
  else 
    C2F(champ1)(plch->x,plch->y,plch->fx,plch->fy,&(plch->n1),&(plch->n2),
	       plch->strflag,plch->vrect,&(plch->arfact),0L);
}

ReplayX1(theplot)
     char *theplot;
{
  struct xcall1_rec *plch;
  plch= (struct xcall1_rec *)theplot;
  C2F(dr1)(plch->fname,plch->string,plch->x1,plch->x2,
	   plch->x3,plch->x4,plch->x5,plch->x6,
	   plch->dx1,plch->dx2,plch->dx3,plch->dx4,0L,0L);
}


typedef  struct  {
  char *name;
  int  (*replay)();
} ReplayTable;

static ReplayTable RTable[] ={
    "champ",ReplayChamp,
    "contour",ReplayContour,
    "fac3d",ReplayFac3D,
    "fac3d1",ReplayFac3D1,
    "fec",ReplayFec,
    "gray",ReplayGray,
    "param3d",ReplayParam3D,
    "plot2d",Replay2D,
    "plot3d",Replay3D,
    "plot3d1",Replay3D1,
    "scale" ,ReplayEch,
    "xcall1",ReplayX1,
    "xgrid",ReplayGrid,
    (char *) NULL,NULL};

GReplay(type,plot)
     char type[];
     char *plot;
{
  int i=0;
  while ( RTable[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(type,RTable[i].name);
       if ( j == 0 ) 
	 { 
	   (*(RTable[i].replay))(plot);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       sciprint("\nUnknow Plot type <%s>\r\n",type);
	       return;
	     }
	   else i++;
	 }
     }
  sciprint("\n Unknow Plot type <%s>\r\n",type);
}


/*---------------------------------------------------------------------
\encadre{Stocke un dessin dans la pile}
---------------------------------------------------------------------------*/

int
Store(type,plot)
     char type[];
     char *plot;
{
  if (ListPFirst == NULL)
      {
	ListPFirst = (struct listplot *)MALLOC(sizeof(struct listplot));
	if (ListPFirst != NULL)
	  {
	    if (CopyVectC(&(ListPFirst->type),type,((int)strlen(type))+1)==0)
	      { ListPFirst=NULL;
		Scistring("Store : No more Place \n");
		return(0);
	      }
	    ListPFirst->theplot=plot;
	    ListPFirst->window=curwin();
	    ListPFirst->ptrplot=NULL;
	    ListPFirst->previous=NULL;
	  }
	else
	  {
	    Scistring("Store (store-1): malloc No more Place");
	    return(0);
	  }
      }
  else 
    {
      struct listplot *list;
      list=ListPFirst;
      while (list->ptrplot != NULL) 
	list=list->ptrplot;
      list->ptrplot=(struct listplot *)
	MALLOC(sizeof(struct listplot));
      if (list->ptrplot != NULL)
	{
	  if (CopyVectC(&(list->ptrplot->type),type,((int)strlen(type))+1)==0)
	    { list=NULL;
	      Scistring("Store (store-2): No more Place \n");
	      return(0);}
	  list->ptrplot->theplot=plot;
	  list->ptrplot->previous=list;
	  list->ptrplot->window=curwin();
	  list->ptrplot->ptrplot=NULL;
	}
      else 
	{
	  Scistring("Store (store-3):No more Place\n");
	  return(0);
	}
    }
  return(1);
}


/*------------------------END--------------------*/






