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
#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <stdio.h>
#include <string.h>
#include "../machine.h"
#include "Math.h"

static int curwin()
{
  int verbose=0,narg,winnum;
  C2F(dr)("xget","window",&verbose,&winnum,&narg
      ,IP0,IP0,IP0,0,0);
  return(winnum);
}



/*---------------------------------------------------------------------
\encadre{Le cas des xcall1}
---------------------------------------------------------------------------*/

struct xcall1_rec {char *fname,*string;
		   char *x1,*x2,*x3,*x4,*x5,*x6;
		   char c1,c2,c3,c4,c5,c6;
		 } ;

StoreXcall1(fname,string,x1,n1,c1,x2,n2,c2,x3,n3,c3,x4,n4,c4,x5,n5,c5,x6,n6,c6)
     char fname[],string[];
     int n1,n2,n3,n4,n5,n6;
     char *x1,*x2,*x3,*x4,*x5,*x6;
     char c1,c2,c3,c4,c5,c6;
{
  int debug=0;
  int CopyVect(),CopyVectC(),CopyVectG();
  struct xcall1_rec *lplot;
  if (debug)
    {
      fprintf(stderr,"Inside StoreXcall1 [%s],[%s]\n",fname,string);
      if ( (x1) != (char *) 0){
	fprintf(stderr,"Argument-1, taille %d type %c\n",n1,c1);
	if ( (x2) != (char *) 0){
	  fprintf(stderr,"Argument-2, taille %d type %c\n",n2,c2);
	  if ( (x3) != (char *) 0){
	    fprintf(stderr,"Argument-3, taille %d type %c\n",n3,c3);
	    if ( (x4) != (char *) 0){
	      fprintf(stderr,"Argument-4, taille %d type %c\n",n4,c4);
	      if ( (x5) != (char *) 0){
		fprintf(stderr,"Argument-5, taille %d type %c\n",n5,c5);
		if ( (x6) != (char *) 0){
		  fprintf(stderr,"Argument-6, taille %d type %c\n",n6,c6);
		};
	      };
	    };
	  };
	};
      };
      fprintf(stderr,"That's over\n");
    };
  lplot= ((struct xcall1_rec *) malloc((unsigned) sizeof(struct xcall1_rec)));
  if (lplot != NULL)
    {
      /** On initialise les champs a zero car CopyVect peut ne rien faire 
	si certains champs sont vides **/
      lplot->x1=(char *) 0;
      lplot->x2=(char *) 0;
      lplot->x3=(char *) 0;
      lplot->x4=(char *) 0;
      lplot->x5=(char *) 0;
      lplot->x6=(char *) 0;
      lplot->fname=(char *) 0;
      lplot->string=(char *) 0;
      lplot->c1=c1;      lplot->c2=c2;      lplot->c3=c3;
      lplot->c4=c4;      lplot->c5=c5;      lplot->c6=c6;
      if (
	  CopyVectC(&(lplot->fname),fname,((int)strlen(fname))+1) &&
	  CopyVectC(&(lplot->string),string,((int)strlen(string))+1) &&
	  CopyVectG(&(lplot->x1),x1,n1,c1) &&
	  CopyVectG(&(lplot->x2),x2,n2,c2) &&
	  CopyVectG(&(lplot->x3),x3,n3,c3) &&
	  CopyVectG(&(lplot->x4),x4,n4,c4) &&
	  CopyVectG(&(lplot->x5),x5,n5,c5) &&
	  CopyVectG(&(lplot->x6),x6,n6,c6) 
	  ) 
	{
	  Store("xcall1",(char *) lplot);
	  return;};
    };
  Scistring("\nStore Plot : No more place \n");
};

int CopyVectG(pstr,str,n,type)
     char **pstr;
     char *str;
     char type;
     int n;
{
  if ( str != (char *) 0)
    {
      switch ( type)
	{
	case 'f' : return(CopyVectF((double **) pstr,(double *)str,n));
	case 'i' : return(CopyVectI((int **) pstr,(int *)str,n));
	};
    };
  return(1);
}

  
/*---------------------------------------------------------------------
\encadre{Le cas des changement d'echelle}
---------------------------------------------------------------------------*/


struct scale_rec { char *name; double *Wrect,*Frect; } ;

/* Store the plot2d  in the plot list 
   same arguments as plot2d */

StoreEch(name,WRect,FRect)
     double WRect[4],FRect[4];
     char name[];
{
  int CopyVect(),nstyle;
  struct scale_rec *lplot;
  lplot= ((struct scale_rec *) malloc((unsigned) sizeof(struct scale_rec)));
  if (lplot != NULL)
    {
      if ( 
	  CopyVectC(&(lplot->name),name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->Wrect),WRect,4) &&
	  CopyVectF(&(lplot->Frect),FRect,4) 
	  ) 
	{
	  Store("scale",(char *) lplot);
	  return;};
    };
  Scistring("\n Store Plot : No more place \n");
};

  
/*---------------------------------------------------------------------
\encadre{Le cas des plot2d}
---------------------------------------------------------------------------*/

struct plot2d_rec {char *name,*xf;
		   double *x,*y,*brect;
		   int   n1,n2,*style,*aint;
		   char *legend,*strflag;
		 } ;

/* Store the plot2d  in the plot list 
   same arguments as plot2d */

StorePlot(name,xf,x,y,n1,n2,style,strflag,legend,brect,aint)
     double x[],y[],brect[];
     int   *n1,*n2,style[],aint[];
     char legend[],strflag[],xf[],name[];
{
  int CopyVect(),nstyle;
  struct plot2d_rec *lplot;
  lplot= ((struct plot2d_rec *) malloc((unsigned) sizeof(struct plot2d_rec)));
  if ( *n1==1) nstyle= *n1+1;else nstyle= *n1;
  if (lplot != NULL)
    {
      int n=0;
      switch (xf[0])
	{
	case 'g': n=(*n1)*(*n2);break;
	case 'e': n=0;break;
	case 'o': n=(*n2);break;
	};
      lplot->n1= *n1;
      lplot->n2= *n2;
      if ( 
	  CopyVectC(&(lplot->name),name,((int)strlen(name))+1) &&
	  CopyVectC(&(lplot->xf),xf,((int)strlen(xf))+1) &&
	  ((n == 0) ? 1 : CopyVectF(&(lplot->x),x,n)) &&
	  CopyVectF(&(lplot->y),y,(*n1)*(*n2)) &&
	  CopyVectI(&(lplot->style),style,nstyle) &&
	  CopyVectC(&(lplot->strflag),strflag,((int)strlen(strflag))+1) &&
	  CopyVectC(&(lplot->legend),legend,((int)strlen(legend))+1) && 
	  CopyVectF(&(lplot->brect),brect,4) &&
	  CopyVectI(&(lplot->aint),aint,4) 
	  ) 
	{
	  Store("plot2d",(char *) lplot);
	  return;};
    };
  Scistring("\n Store Plot : No more place \n");
};


/*---------------------------------------------------------------------
\encadre{Le cas du param3d}
---------------------------------------------------------------------------*/

struct param3d_rec {char *name;
		   double *x,*y,*z,*bbox;
		   int   n,*flag;
		    double teta,alpha;
		   char  *legend;
		 } ;
/* Store the plot in the plot list 
   same arguments as param3d */

StoreParam3D(name,x,y,z,n,teta,alpha,legend,flag,bbox)
     char name[];
     double x[],y[],z[],bbox[];
     int *n;
     double *teta,*alpha;
     int flag[];
     char legend[];
{
  int CopyVect();
  struct param3d_rec *lplot;
  lplot= ((struct param3d_rec *) malloc((unsigned) sizeof(struct param3d_rec)));
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
	  CopyVectI(&(lplot->flag), flag,3) &&
	  CopyVectF(&(lplot->bbox), bbox,6)
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;};
    };
  Scistring("\n Store Plot : No more place \n");
};


/*---------------------------------------------------------------------
\encadre{Le cas des plot3d}
---------------------------------------------------------------------------*/

struct plot3d_rec {char *name;
		   double *x,*y,*z,*bbox;
		   int   p,q,*flag;
		   double teta,alpha;
		   char  *legend;
		 } ;
/* Store the plot in the plot list 
   same arguments as plot3d */

StorePlot3D(name,x,y,z,p,q,teta,alpha,legend,flag,bbox)
     char name[];
     double x[],y[],z[],bbox[];
     int *p,*q;
     double *teta,*alpha;
     int flag[];
     char legend[];
{
  int CopyVect();
  struct plot3d_rec *lplot;
  lplot= ((struct plot3d_rec *) malloc((unsigned) sizeof(struct plot3d_rec)));
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
	  CopyVectI(&(lplot->flag), flag,3) &&
	  CopyVectF(&(lplot->bbox), bbox,6)
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;};
    };
  Scistring("\n Store Plot : No more place \n");
};


/*---------------------------------------------------------------------
\encadre{Le cas des contours}
---------------------------------------------------------------------------*/

struct contour_rec {char *name;
		    double *x,*y,*z,*zz,zlev;
		    int   n1,n2,nz,flagnz;
		    double *bbox;
		    double teta,alpha;
		    int *flag;
		   char  *legend;
		 } ;
/* Store the plot in the plot list 
   same arguments as contour */

StoreContour(name,x,y,z,n1,n2,flagnz,nz,zz,teta,alpha,legend,flag,bbox,zlev)
     char name[];
     double x[],y[],z[],zz[],bbox[6],*zlev;
     int *n1,*n2,*nz,*flagnz;
     double *teta,*alpha;
     int flag[3];
     char legend[];
{
  int CopyVect();
  struct contour_rec *lplot;
  lplot= ((struct contour_rec *) malloc((unsigned) sizeof(struct contour_rec)));
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
	  CopyVectI(&(lplot->flag), flag,3) &&
	  CopyVectF(&(lplot->bbox), bbox,6) 
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;};
    };
  Scistring("\n Store Plot : No more place \n");
};


/*---------------------------------------------------------------------
\encadre{Le cas des niveaux de gris }
---------------------------------------------------------------------------*/

struct gray_rec {char *name;
		   double *x,*y,*z;
		   int   n1,n2,nz;
		 } ;
/* Store the plot in the plot list 
   same arguments as gray */

StoreGray(name,x,y,z,n1,n2)
     char name[];
     double x[],y[],z[];
     int *n1,*n2;
{
  int CopyVect();
  struct gray_rec *lplot;
  lplot= ((struct gray_rec *) malloc((unsigned) sizeof(struct gray_rec)));
  if (lplot != NULL)
    {
      lplot->n1= *n1;
      lplot->n2= *n2;
      if ( 
	  CopyVectC(&(lplot->name), name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->x), x,*n1) &&
	  CopyVectF(&(lplot->y), y,*n2) &&
	  CopyVectF(&(lplot->z), z,(*n1)*(*n2)) 
	  ) 
	{
	  Store(name,(char *) lplot);
	  return;};
    };
  Scistring("\n Store Plot : No more place \n");
};


/*---------------------------------------------------------------------
\encadre{Le cas des champs de vecteurs}
---------------------------------------------------------------------------*/

struct champ_rec {char *name;
		  double *fx,*fy,*vrect,arfact;
		  int   n1,n2,*style,*aint;
		  char *strflag;
		} ;

StoreChamp(name,fx,fy,n1,n2,strflag,vrect,arfact)
	double fx[],fy[],vrect[],*arfact;
	int *n1,*n2;
        char strflag[],name[];
{
  int CopyVect();
  struct champ_rec *lplot;
  lplot= ((struct champ_rec *) malloc((unsigned) sizeof(struct champ_rec)));
  if (lplot != NULL)
    {
      lplot->n1= *n1;
      lplot->n2= *n2;
      lplot->arfact= *arfact;
      if ( 
	  CopyVectC(&(lplot->name),name,((int)strlen(name))+1) &&
	  CopyVectF(&(lplot->fx),fx,(*n1)*(*n2)) &&
	  CopyVectF(&(lplot->fy),fy,(*n1)*(*n2)) &&
	  CopyVectC(&(lplot->strflag),strflag,((int)strlen(strflag))+1) &&
	  CopyVectF(&(lplot->vrect),vrect,4)
	  ) 
	{
	  Store("champ",(char *) lplot);
	  return;};
    };
  Scistring("\n Store Plot : No more place \n");
};

/*---------------------------------------------------------------------
\encadre{Routines de recopie de Vecteurs avec alocation dynamique}
  a appeller avec l > 0 
---------------------------------------------------------------------------*/

int CopyVectI(nx,x,l)
     int **nx,*x;
     int l;
{ 
  int i;
  *nx = (int *)  malloc ((unsigned ) l*sizeof(int));
  if ( *nx == NULL) return(0);
  for ( i=0 ; i < l ; i++) (*nx)[i]= x[i];
  return(1);
};

int CopyVectF(nx,x,l)
     double **nx,*x;
     int l;
{
  int i;
  *nx = (double *)  malloc ((unsigned ) l*sizeof(double));
  if ( *nx == NULL) return(0);
  for ( i=0 ; i < l ; i++) (*nx)[i]= x[i];
  return(1);
};

int CopyVectC(nx,x,l)
     char **nx,*x;
     int l;
{
  int i;
  *nx = (char *)  malloc ((unsigned ) l*sizeof(char));
  if ( *nx == NULL) return(0);
  for ( i=0 ; i < l ; i++) (*nx)[i]= x[i];
  return(1);
};

/*---------------------------------------------------------------------
\encadre{Gestion d'une liste de graphiques}
C'est un liste doublement chain\'ee. (pout faciliter la destruction d'un elemnet dans la chaine.
---------------------------------------------------------------------------*/

struct listplot {
            char *type;
	    int  window;
            char *theplot; 
	    struct listplot   *ptrplot;
	    struct listplot   *previous;
	  } ;

static struct listplot *first = NULL ;


/*-------------------------------------------------------------------------
\encadre{Detruit les plots qui sont dans la fenetre winnumber de la liste}
---------------------------------------------------------------------------*/

CleanPlots(unused,winnumber)
     char *unused;
     int *winnumber;
{
  struct listplot *list,*list1;     
#ifdef lint 
  *unused;
#endif

  list=first;
  while (list)
    {
      if (list->window == *winnumber)
	{
	  if (list->theplot != NULL) {
	    CleanPlot(list->type,list->theplot);
	    free(list->theplot);}
	  free(list->type);
	  if (list->previous != NULL)
	    (list->previous)->ptrplot=list->ptrplot;
	  else
	    first=list->ptrplot;
	  if (list->ptrplot != NULL) 
	    (list->ptrplot)->previous=list->previous;
	  list1=list;
	  list =list->ptrplot;
	  free((char *) list1);
	}
      else 
	list=list->ptrplot;
    };
};

#define FREE(x) if (x  != NULL) free((char *) x);

Clean3D(plot)
     char *plot;
{
  struct plot3d_rec *theplot;
  theplot=(struct plot3d_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);FREE(theplot->legend);FREE(theplot->flag);
  FREE(theplot->bbox);
};

CleanContour(plot)
     char *plot;
{
  struct contour_rec *theplot;
  theplot=(struct contour_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);FREE(theplot->zz);FREE(theplot->legend);FREE(theplot->flag);
  FREE(theplot->bbox);
};

CleanGray(plot)
     char *plot;
{
  struct gray_rec *theplot;
  theplot=(struct gray_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);
};

CleanParam3D(plot)
     char *plot;
{
  struct param3d_rec *theplot;
  theplot=(struct param3d_rec *) plot;
  FREE(theplot->name);FREE(theplot->x);FREE(theplot->y);
  FREE(theplot->z);FREE(theplot->legend);FREE(theplot->flag);
  FREE(theplot->bbox);
};

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
};

CleanEch(plot)
     char *plot;
{
  struct scale_rec *theplot;
  theplot=(struct scale_rec *) plot;
  FREE(theplot->name);    
  FREE(theplot->Wrect);
  FREE(theplot->Frect);     
};


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
};

CleanChamp(plot)
     char *plot;
{
  struct champ_rec *theplot;
  theplot=(struct champ_rec *) plot;
  FREE(theplot->name);    
  FREE(theplot->fx);FREE(theplot->fy);     
  FREE(theplot->strflag);FREE(theplot->vrect);
};

typedef  struct  {
  char *name;
  int  (*clean)();} CleanTable;

static CleanTable CTable[] ={
    "champ",CleanChamp,
    "contour",CleanContour,
    "gray",CleanGray,
    "param3d",CleanParam3D,
    "plot2d",Clean2D,
    "plot3d",Clean3D,
    "plot3d1",Clean3D,
    "scale",CleanEch,
    "xcall1",CleanX1,
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
	       SciF1s("Unknow Plot type <%s>\r\n",type);
	       return;
	     }
	   else i++;
	 };
     };
  SciF1s("Unknow Plot type <%s>\r\n",type);
};


/*-------------------------------------------------------------------------
\encadre{Change les angles alpha theta }
---------------------------------------------------------------------------*/

NAPlots(unused,winnumber,theta,alpha)
     char *unused;
     int *winnumber;
     double *theta,*alpha;
{
  struct listplot *list,*list1;     
#ifdef lint 
  *unused;
#endif
  list=first;
  while (list)
    {
      if (list->window == *winnumber && list->theplot != NULL) 
	    NAPlot(list->type,list->theplot,theta,alpha);
      list =list->ptrplot;
    };
};

NA3D(plot,theta,alpha)
     char *plot;
     double *theta,*alpha;
{
  struct plot3d_rec *theplot;
  theplot=(struct plot3d_rec *) plot;
  theplot->teta=*theta;
  theplot->alpha=*alpha;
};

NAContour(plot,theta,alpha)
     char *plot;
     double *theta,*alpha;
{
  struct contour_rec *theplot;
  theplot=(struct contour_rec *) plot;
  theplot->teta=*theta;
  theplot->alpha=*alpha;
};

NAGray(plot,theta,alpha)
     char *plot;
     double *theta,*alpha;
{
};

NAParam3D(plot,theta,alpha)
     char *plot;
     double *theta,*alpha;
{
  struct param3d_rec *theplot;
  theplot=(struct param3d_rec *) plot;
  theplot->teta=*theta;
  theplot->alpha=*alpha;
};

NA2D(plot,theta,alpha)
     char *plot;
     double *theta,*alpha;
{};

NAEch(plot,theta,alpha)
     char *plot;
     double *theta,*alpha;
{};


NAX1(plot,theta,alpha)
     char *plot;
     double *theta,*alpha;
{};

NAChamp(plot,theta,alpha)
     char *plot;
     double *theta,*alpha;
{};

typedef  struct  {
  char *name;
  int  (*NA)();} NATable;

static NATable NACTable[] ={
    "champ",NAChamp,
    "contour",NAContour,
    "gray",NAGray,
    "param3d",NAParam3D,
    "plot2d",NA2D,
    "plot3d",NA3D,
    "plot3d1",NA3D,
    "scale",NAEch,
    "xcall1",NAX1,
    (char *)NULL,NULL};

NAPlot(type,plot,alpha,theta)
     char type[];
     char *plot;
     double *alpha,*theta;
{
  int i=0;
  while ( NACTable[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(type,NACTable[i].name);
       if ( j == 0 ) 
	 { 
	   (*(NACTable[i].NA))(plot,alpha,theta);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       SciF1s("Unknow Plot type <%s>\r\n",type);
	       return;
	     }
	   else i++;
	 };
     };
  SciF1s("Unknow Plot type <%s>\r\n",type);
};


/*---------------------------------------------------------------------
\encadre{Redessine \`a nouveau les dessin stock\'es en changeant les theta alpha 
   des plots 3d}
---------------------------------------------------------------------------*/
extern char GetDriver_();

Tape_ReplayNewAngle(unused,winnumber,theta,alpha)
     char *unused;
     int *winnumber;
     double *theta,*alpha;
{ 
  NAPlots(unused,winnumber,theta,alpha);
  Tape_Replay(first,winnumber);
};

/*---------------------------------------------------------------------
\encadre{Redessine \`a nouveau les dessin stock\'es}
---------------------------------------------------------------------------*/


Tape_Replay(unused,winnumber)
     char *unused;
     int *winnumber;
{ 
  char c,name[4];
  GetDriver1_(name);
  if (first != NULL)
    {
      if ( (c=GetDriver_())=='R' )
	  C2F(dr)("xsetdr","X11",IP0,IP0,IP0,IP0,IP0,IP0,0,0);
      Tape_Replay1(first,*winnumber);
      C2F(dr)("xsetdr",name, IP0, IP0,IP0,IP0,IP0,IP0,0,0);
    };
};

Tape_Replay1(list,winnumber)
     struct listplot *list;
     int winnumber;
{
  if (list->window == winnumber) GReplay(list->type,list->theplot);
  if (list->ptrplot != NULL) Tape_Replay1(list->ptrplot,winnumber);
};

Replay3D(theplot)
     char *theplot;

{
  struct plot3d_rec *pl3d;
  pl3d= (struct plot3d_rec *)theplot;
  C2F(plot3d)(pl3d->x,pl3d->y,pl3d->z,&pl3d->p,&pl3d->q,&pl3d->teta,
	  &pl3d->alpha,pl3d->legend,pl3d->flag,pl3d->bbox,0L);
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
  C2F(xgray)(pl3d->x,pl3d->y,pl3d->z,&pl3d->n1,&pl3d->n2);
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

static int fnvide_() {};
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
	       SciF1s("\nUnknow operator <%s>\r\n",pl2d->name);
	       return;
	     }
	   else i++;
	 };
     };
      SciF1s("\n Unknow  operator <%s>\r\n",pl2d->name);
};

ReplayEch(theplot)
     char *theplot;
{
  struct scale_rec *plch;
  plch= (struct scale_rec *)theplot;
  C2F(setscale2d)(plch->Wrect,plch->Frect);
};

ReplayChamp(theplot)
     char *theplot;
{
  struct champ_rec *plch;
  plch= (struct champ_rec *)theplot;
  C2F(champ)(plch->fx,plch->fy,&(plch->n1),&(plch->n2),
	   plch->strflag,plch->vrect,&(plch->arfact),0L);
};


ReplayX1(theplot)
     char *theplot;
{
  struct xcall1_rec *plch;
  plch= (struct xcall1_rec *)theplot;
  C2F(dr1)(plch->fname,plch->string,(int *) plch->x1,(int *) plch->x2,
       (int *) plch->x3,(int *) plch->x4,(int *) plch->x5,
       (int *) plch->x6,0,0);
};


typedef  struct  {
  char *name;
  int  (*replay)();
} ReplayTable;

static ReplayTable RTable[] ={
    "champ",ReplayChamp,
    "contour",ReplayContour,
    "gray",ReplayGray,
    "param3d",ReplayParam3D,
    "plot2d",Replay2D,
    "plot3d",Replay3D,
    "plot3d1",Replay3D1,
    "scale" ,ReplayEch,
    "xcall1",ReplayX1,
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
	       SciF1s("\nUnknow Plot type <%s>\r\n",type);
	       return;
	     }
	   else i++;
	 };
     };
  SciF1s("\n Unknow Plot type <%s>\r\n",type);
};


/*---------------------------------------------------------------------
\encadre{Stocke un dessin dans la pile}
---------------------------------------------------------------------------*/

Store(type,plot)
     char type[];
     char *plot;
{
  if (first == NULL)
      {
	first = (struct listplot *)malloc((unsigned)sizeof(struct listplot));
	if (first != NULL)
	  {
	    if (CopyVectC(&(first->type),type,((int)strlen(type))+1)==0)
	      { first=NULL;
		Scistring("Store : No more Place \n");
		return;}
	    first->theplot=plot;
	    first->window=curwin();
	    first->ptrplot=NULL;
	    first->previous=NULL;
	  }
	else
	  Scistring("Store : malloc No more Place");
      }
  else 
    {
      struct listplot *list;
      list=first;
      while (list->ptrplot != NULL) 
	list=list->ptrplot;
      list->ptrplot=(struct listplot *)
	malloc((unsigned)sizeof(struct listplot));
      if (list->ptrplot != NULL)
	{
	  if (CopyVectC(&(list->ptrplot->type),type,((int)strlen(type))+1)==0)
	    { list=NULL;
	      Scistring("Store : No more Place \n");
	      return;}
	  list->ptrplot->theplot=plot;
	  list->ptrplot->previous=list;
	  list->ptrplot->window=curwin();
	  list->ptrplot->ptrplot=NULL;
	}
      else 
	Scistring("Store No more Place\n");
    };
} ;

/*------------------------END--------------------*/
