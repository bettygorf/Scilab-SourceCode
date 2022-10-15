#include <string.h> /* in case of dbmalloc use */

#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <stdio.h>
#include <math.h>
#include "Math.h"

char GetDriver_();

/* On veut avoir une echelle courante par fenetre graphique */

/*-----------------------------------------
 \encadre{List of Window Scale}
-----------------------------------------*/

#include "PloEch.h"

/* The scale List : on for ecah graphic window */

static WCScaleList *The_List_ = NULL;

/* Current Scale */

WCScaleList  Cscale = 
{ 
  {0.0,0.0,1.0,1.0},
  {0.0,0.0,1.0,1.0},
  75.0,53.0,450.0,318.0,
  "nn",
  {75,53,450,318},
  {2,10,2,10},
  {{1.0,0.0,0.0},{0.0,1.0,0.0},{0.0,0.0,1.0}},
  {0.0,1.0,0.0,1.0,0.0,1.0},
  35.0,45.0,
  0,/*unused */
  (struct WCScaleList *) 0 /*unused */
};

/*
  Current geometric transformation 
*/

#define XScale(x) ( Cscale.Wscx1*((x) -Cscale.WFRect1[0]) + Cscale.Wxofset1)
#define XLogScale(x) ( Cscale.Wscx1*(log10(x) -Cscale.WFRect1[0]) + Cscale.Wxofset1)
#define YScale(y) ( Cscale.Wscy1*(-(y)+Cscale.WFRect1[3]) + Cscale.Wyofset1)
#define YLogScale(y) ( Cscale.Wscy1*(-log10(y)+Cscale.WFRect1[3]) + Cscale.Wyofset1)

#define XPi2R(x)  Cscale.WFRect1[0] + (1.0/Cscale.Wscx1)*((x) - Cscale.Wxofset1)
#define YPi2R(y)  Cscale.WFRect1[3] - (1.0/Cscale.Wscy1)*((y) - Cscale.Wyofset1)


/* 
  Copy a WCscaleList into global values 
*/

WCScaleList2Global(listptr)
     WCScaleList *listptr;
{
  int i,j;
  for (i=0; i< 4; i++) 
    {
      Cscale.WW1Rect[i]=listptr->WW1Rect[i];
      Cscale.WFRect1[i]=listptr->WFRect1[i];
      Cscale.WIRect1[i]=listptr->WIRect1[i];
      Cscale.Waaint1[i]=listptr->Waaint1[i];
    }
  for (i=0; i< 3; i++) 
    for (j=0; i< 3; i++) 
      Cscale.m[i][j]=listptr->m[i][j];
  for (i=0; i< 6; i++) 
    Cscale.bbox1[i]=listptr->bbox1[i] ;
  Cscale.Wxofset1=listptr->Wxofset1;
  Cscale.Wyofset1=listptr->Wyofset1;
  Cscale.Wscx1=listptr->Wscx1;
  Cscale.Wscy1=listptr->Wscy1;
  Cscale.logflag1[0] = listptr->logflag1[0];
  Cscale.logflag1[1] = listptr->logflag1[1];
}

Global2WCScaleList(listptr)
     WCScaleList *listptr;
{
  int i,j;
  for (i=0; i< 4; i++) 
    {
      listptr->WW1Rect[i]= Cscale.WW1Rect[i];                               
      listptr->WFRect1[i]= Cscale.WFRect1[i];
      listptr->WIRect1[i]= Cscale.WIRect1[i];
      listptr->Waaint1[i]= Cscale.Waaint1[i];
    }
  for (i=0; i< 3; i++) 
    for (j=0; i< 3; i++) 
      listptr->m[i][j]=      Cscale.m[i][j];
  for (i=0; i< 6; i++) 
    listptr->bbox1[i] =    Cscale.bbox1[i];
  listptr->Wxofset1= Cscale.Wxofset1;
  listptr->Wyofset1= Cscale.Wyofset1;
  listptr->Wscx1=  Cscale.Wscx1;
  listptr->Wscy1=  Cscale.Wscy1;
  listptr->logflag1[0] = Cscale.logflag1[0] ; 
  listptr->logflag1[1] = Cscale.logflag1[1] ;
}

/* Fix the current scales as the current scales of window i */

GetScaleWindowNumber_(i)
     integer i ;
{ 
  GetScaleWin_(The_List_,Max(0L,i));
}

GetScaleWin_(listptr,wi)
     WCScaleList *listptr;
     integer wi; 
{
  if (listptr != (WCScaleList  *) NULL)
    { 
      if ((listptr->Win) == wi)
	WCScaleList2Global(listptr);
      else 
	GetScaleWin_((WCScaleList *) listptr->next,wi);
    }
}

/* stores the current scales as the current scales of window i */

SetScaleWindowNumber_(i)
     integer i ;
{ 
  SetScaleWin_(&The_List_,Max(0L,i),0L);
}

SetScaleWin_(listptr,i,lev)
     WCScaleList **listptr;
     integer i,lev; 
{
  if ( *listptr == (WCScaleList  *) NULL)
    {
      *listptr = (WCScaleList *) MALLOC( sizeof ( WCScaleList ));
      if ( listptr == 0) 
	{
	  Scistring("AddWindowScale_ No More Place ");
	  return;
	}
      else 
	{ 
	  (*listptr)->Win  = lev;
	  (*listptr)->next = (struct WCScaleList *) NULL ;
	  Global2WCScaleList(*listptr);
	}
    }
  if ( lev == i) 
    { 
      Global2WCScaleList(*listptr);
    }
  else 
    SetScaleWin_((WCScaleList **) &((*listptr)->next),i,lev+1);
}

/* return current window : ok if driver is Rec */

static integer curwin()
{
  integer verbose=0,narg,winnum;
  C2F(dr)("xget","window",&verbose,&winnum,&narg ,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  return(winnum);
}

/*-----------------------------------------------------------------------
  Scale2D  Cette fonction fait deux choses:
  
  1.Elle modifie FRect,IRect,scx,scy,xofset,yofset
  2.Elle alloue ou r\'ealloue deux vecteurs xm et ym de type entier
  et de taille n 

  Cette fonction permet de fixer les echelles 
  apres appel de cette fonction pour que les nombres r\'eel 
  (x,y) dans FRect1={xmin,ymin,xmax,ymax} soient dessin\'es sur les 
  points en pixel du Rectangle IRect={xupleft,yupleft,xlarge,yheight}

    xpixel=inint( scx*(x -FRect[0]) + xofset);
    ypixel=inint( scy*(-y+FRect[3]) + yofset);

  la fonction echelle2d plus bas permet d'effectuer cette op\'eration 

  Si on appelle cette fonction avec la valeur 

  job=0, l'appel modifie FRect et IRect qui recoivent les valeurs 
          courantes des echelles

  job=1  IRect recoit la valeur courante 
	 FRect transmis est utilise et non modifie et sert a etablir 
	 une nouvelle valeur courante 

  job=2, FRect et IRect  sont utilises pour fixer 
         de nouvelles valeurs courantes

---------------------------------------------------------------------------*/

Scale2D(job,FRect,IRect,aaint,scx,scy,xofset,yofset,logflag,xm,ym,n,err)
     double FRect[4],*scx,*scy,*xofset,*yofset;
     integer IRect[4],**xm,**ym,n,*err,job,aaint[4];
     char logflag[2];
{
  char c;
  integer verbose=0,narg,xz[2];
  integer  wmax,hmax,mfact, *zm;
  C2F(dr)("xget","wdim",&verbose,xz,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  wmax=xz[0];hmax=xz[1];
  mfact=4;
  switch (job)
    {
      integer i;
    case 0 :
      /** On utilise le scale de l'appel pr\'ec\'edent a Scale2D **/
      *scx = Cscale.Wscx1; *scy = Cscale.Wscy1; *xofset= Cscale.Wxofset1; *yofset= Cscale.Wyofset1;
      logflag[0]=Cscale.logflag1[0];logflag[1]=Cscale.logflag1[1];
      for (i=0; i < 4 ; i++) 
	{ IRect[i]=Cscale.WIRect1[i];FRect[i]=Cscale.WFRect1[i];aaint[i]=Cscale.Waaint1[i];}
      break;
    case 1 :
      /** Utilise FRect,et logflag et aaint Irect <- valeurs par defaut **/
      *scx =  ((double) wmax*Cscale.WW1Rect[2]-wmax*Cscale.WW1Rect[2]/((double) mfact));
      *scy =  ((double) hmax*Cscale.WW1Rect[3]-hmax*Cscale.WW1Rect[3]/((double) mfact));
      *xofset=Cscale.Wxofset1= ((double) wmax*Cscale.WW1Rect[2])/((double) 2.0*mfact);
      *yofset=Cscale.Wyofset1= ((double) hmax*Cscale.WW1Rect[3])/((double) 2.0*mfact);
      IRect[0] = inint(*xofset+Cscale.WW1Rect[0]*((double)wmax));
      IRect[1] = inint(*yofset+Cscale.WW1Rect[1]*((double)hmax));
      IRect[2] = inint(*scx);
      IRect[3] = inint(*scy);
      Cscale.Wscx1 =  IRect[2]; Cscale.Wscy1 = IRect[3];
      *xofset=Cscale.Wxofset1= IRect[0]; *yofset=Cscale.Wyofset1= IRect[1];
      for (i=0; i < 4 ; i++) { Cscale.WIRect1[i]=IRect[i];Cscale.WFRect1[i]=FRect[i];}
      *scx=Cscale.Wscx1 =(Abs(FRect[0]-FRect[2])<=SMDOUBLE) ?
	Cscale.Wscx1/SMDOUBLE:Cscale.Wscx1/Abs(FRect[0]-FRect[2]);
      *scy=Cscale.Wscy1 =(Abs(FRect[1]-FRect[3])<=SMDOUBLE)?
	Cscale.Wscy1/SMDOUBLE:Cscale.Wscy1/Abs(FRect[1]-FRect[3]);
      Cscale.logflag1[0]=logflag[0];      Cscale.logflag1[1]=logflag[1];
      for (i=0; i < 4 ; i++) { Cscale.Waaint1[i]=aaint[i];}
      if ( (c=GetDriver_()) == 'X' ||  c == 'R') 
	{
	  SetScaleWindowNumber_(curwin());
	}
      break;
    case 2:
      Cscale.Wscx1 =  IRect[2]; Cscale.Wscy1 = IRect[3];
      *xofset=Cscale.Wxofset1= IRect[0]; *yofset=Cscale.Wyofset1= IRect[1];
      for (i=0; i < 4 ; i++) { Cscale.WIRect1[i]=IRect[i];Cscale.WFRect1[i]=FRect[i];}
      *scx=Cscale.Wscx1 =(Abs(FRect[0]-FRect[2])<=SMDOUBLE) ?
	Cscale.Wscx1/SMDOUBLE:Cscale.Wscx1/Abs(FRect[0]-FRect[2]);
      *scy=Cscale.Wscy1 =(Abs(FRect[1]-FRect[3])<=SMDOUBLE)?
	Cscale.Wscy1/SMDOUBLE:Cscale.Wscy1/Abs(FRect[1]-FRect[3]);
      Cscale.logflag1[0]=logflag[0];Cscale.logflag1[1]=logflag[1];
      for (i=0; i < 4 ; i++) { Cscale.Waaint1[i]=aaint[i];}
      /* stores the current scales as the current scales of window i */
      if ( (c=GetDriver_()) == 'X' || c == 'R' ) 
	{
	  SetScaleWindowNumber_(curwin());
	}
      break;
    }
  /** Allocation  **/
  Alloc(xm,ym,&zm,n,n,0L,err);
  if ( *err == 0)
    {
      Scistring("Scale2D : No more Place\n");
      return;
    }
}

/**
  setscale2d_(WRect,FRect) 
  fixe une echelle pour les appels suivants 
  FRect est le rectangle reels que l'on veut voir {xmin,ymin,xmax,ymax}
  sur le dessin 
  WRect indique la sous fenetre a choisir dans la fenetre graphique
  pour faire le dessin 
  WRect=[<x-upperleft>,<y-upperleft>,largeur,hauteur]
  ou ces valeurs reelles sont des proportions de la largeur et hauteur de la 
  fenetre graphique
  par exemple WRect=[0,0,1.0,1.0] indique que l'on utilise toute la fenetre
  WRect=[0.5,0.5,0.5,0.5] indique que l'on utilise le quart gauche en bas 
  de la fenetre coupee en 4
**/


C2F(setscale2d)(WRect,FRect,logscale,l1)
     double FRect[4], WRect[4];
     char *logscale;
     integer l1;
{
  double scx,scy,xofset,yofset;
  integer *xm,*ym,err=0,i,IRect[4];
  static integer aaint[]={2,10,2,10};
  if (GetDriver_()=='R') StoreEch("scale",WRect,FRect,logscale);
  for ( i=0; i < 4 ; i++) 
    {
        Cscale.WW1Rect[i]=WRect[i];
    }
  if (logscale[0]=='l') 
    {
      FRect[0]=log10(FRect[0]);
      FRect[2]=log10(FRect[2]);
    }
  if (logscale[1]=='l') 
    {
      FRect[1]=log10(FRect[1]);
      FRect[3]=log10(FRect[3]);
    }
  Scale2D(1L,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,logscale,&xm,&ym,0L,&err);
}

C2F(getscale2d)(WRect,FRect,logscale,l1)
     double FRect[4],WRect[4];
     char *logscale;
     integer l1;
{
  double F1Rect[4],scx,scy,xofset,yofset;
  integer *xm,*ym,err=0,i,IRect[4],aaint[4];
  Scale2D(0L,F1Rect,IRect,aaint,&scx,&scy,&xofset,&yofset,logscale,&xm,&ym,0L,&err);
  for ( i=0; i < 4 ; i++) 
    {
      FRect[i]=F1Rect[i];
      WRect[i]=Cscale.WW1Rect[i];
    }
  if (logscale[0]=='l') 
    {
      FRect[0]=exp10(FRect[0]);
      FRect[2]=exp10(FRect[2]);
    }
  if (logscale[1]=='l') 
    {
      FRect[1]=exp10(FRect[1]);
      FRect[3]=exp10(FRect[3]);
    }
}

/*--------------------------------------------------------------------
  Les fonction qui suivent sont utilisess dans Xcall1 pour que les 
  primitives graphiques utilisent l'echelle fix\'ess par Store2D
    
    echelle2d_(x,y,x1,y1,n1,n2,rect,dir)

    Cette fonction permet de convertir des valeurs absolues en valeurs 
    pixel et reciproquement la transformation utilisee etant la 
    trasformation courante qui a \'et\'e mise en place par l'appel a Scale2D

   
    if dir="f2i" -> double to integer (you give x and y and get x1,y1)
    if dir="i2f" -> integer to double (you give x1 and y1 and get x,y)

    rect is also a return value it's the rectangle in pixel 
    <x,y,width,height> set in Scale2D in which a plot such as plot2d 
    would take place
    
-> memory space for the vectors x[],y[],x1[],y1[] must be 
   allocated before the call to echelle2d_
   
 lstr : unused ( but used by Fortran ) 
--------------------------------------------------------------------------*/

C2F(echelle2d)(x,y,x1,yy1,n1,n2,rect,dir,lstr)
     double x[],y[];
     integer x1[],yy1[],*n1,*n2,rect[];
     char dir[];
     integer lstr;
{
  integer i;
  if (strcmp("f2i",dir)==0) 
    {
      /** double to integer (pixel) direction **/
      for ( i=0 ; i < (*n1)*(*n2) ; i++)
	{
	  if (Cscale.logflag1[0] == 'n') 
	    x1[i]=inint( XScale(x[i]));
	  else 
	    x1[i]=inint( XLogScale(x[i])) ;
	  if (Cscale.logflag1[1] == 'n') 
	    yy1[i]=inint( YScale(y[i]));
	  else 
	    yy1[i]=inint( YLogScale(y[i]));
	}
    }
  else 
    {
      if (strcmp("i2f",dir)==0) 
	{
	  for ( i=0 ; i < (*n1)*(*n2) ; i++)
	    {
	      x[i]= XPi2R( x1[i] );
	      y[i]= YPi2R( yy1[i] );
	      if (Cscale.logflag1[0] == 'l') x[i]=exp10(x[i]);
	      if (Cscale.logflag1[1] == 'l') y[i]=exp10(y[i]);
	    }
	}
      else 
	sciprint(" Wrong dir %s argument in echelle2d\r\n",dir);
    }
  for (i=0;i<4;i++) rect[i]=Cscale.WIRect1[i];
}

/** meme chose mais pour transformer des longueurs **/
/** Attention ce qui suit ne marche pas dans le cas d'echelle logarithmiques **/
/** on ne peut pas transformer les longueurs, il faut transformer les deux points **/

echelle2dl_(x,y,x1,yy1,n1,n2,rect,dir)
     double x[],y[];
     integer x1[],yy1[],*n1,*n2,rect[];
     char dir[];
{
  integer i;
  if (strcmp("f2i",dir)==0) 
    {
      /** double to integer (pixel) direction **/
      for ( i=0 ; i < (*n1)*(*n2) ; i++)
	{
	  x1[i]=inint( Cscale.Wscx1*( x[i]));
	  yy1[i]=inint( Cscale.Wscy1*( y[i]));
	}
    }
  else 
    {
      if (strcmp("i2f",dir)==0) 
	{
	  for ( i=0 ; i < (*n1)*(*n2) ; i++)
	    {
	      x[i]=x1[i]/Cscale.Wscx1;
	      y[i]=yy1[i]/Cscale.Wscy1;
	    }
	}
      else 
	sciprint(" Wrong dir %s argument in echelle2d\r\n",dir);
    }
  for (i=0;i<4;i++) rect[i]=Cscale.WIRect1[i];
}


/** meme chose mais pour transformer des ellipses **/

ellipse2d_(x,x1,n,dir)
     double x[];
     integer x1[],*n;
     char dir[];
{
  integer i;
  if (strcmp("f2i",dir)==0) 
    {
      /** double to integer (pixel) direction **/
      for ( i=0 ; i < (*n) ; i=i+6)
	{
	  x1[i  ]=inint(XScale(x[i]));
	  x1[i+1]=inint(YScale(x[i+1]));
	  x1[i+2]=inint( Cscale.Wscx1*( x[i+2]));
	  x1[i+3]=inint( Cscale.Wscy1*( x[i+3]));
	  x1[i+4]=inint( x[i+4]);
	  x1[i+5]=inint( x[i+5]);
	}
    }
  else 
    {
      if (strcmp("i2f",dir)==0) 
	{
	  for ( i=0 ; i < (*n) ; i=i+6)
	    {
	      x[i]= XPi2R(x1[i]); 
	      x[i+1]= YPi2R( x1[i+1] ); 
	      x[i+2]=x1[i+2]/Cscale.Wscx1;
	      x[i+3]=x1[i+3]/Cscale.Wscy1;
	      x[i+4]=x1[i+4];
	      x[i+5]=x1[i+5];
	    }
	}
      else 
	sciprint(" Wrong dir %s argument in echelle2d\r\n",dir);
    }
}


/** meme chose mais pour transformer des rectangles **/
/** marche en echelle log **/

rect2d_(x,x1,n,dir)
     double x[];
     integer x1[],*n;
     char dir[];
{
  integer i;
  if (strcmp("f2i",dir)==0) 
    {
      /** double to integer (pixel) direction **/
      for ( i=0 ; i < (*n) ; i= i+4)
	{
	  if ( Cscale.logflag1[0] == 'n' ) 
	    {
	      x1[i]=inint(XScale(x[i]));
	      x1[i+2]=inint( Cscale.Wscx1*( x[i+2]));
	    }
	  else 
	    {
	      x1[i]=inint(XLogScale(x[i]));
	      x1[i+2]=inint( Cscale.Wscx1*(log10((x[i]+x[i+2])/x[i])));
	    } 
	  if ( Cscale.logflag1[1] == 'n' ) 
	    {
	      x1[i+1]=inint(YScale(x[i+1]));
	      x1[i+3]=inint( Cscale.Wscy1*( x[i+3]));
	    }
	  else 
	    {
	      x1[i+1]=inint(YLogScale(x[i+1]));
	      x1[i+3]=inint( Cscale.Wscy1*(log10(x[i+1]/(x[i+1]-x[i+3]))));
	    }
	}
    } 
  else 
    {
      if (strcmp("i2f",dir)==0) 
	{
	  for ( i=0 ; i < (*n) ; i=i+4)
	    {
	      if ( Cscale.logflag1[0] == 'n' ) 
		{
		  x[i]= XPi2R(x1[i] );
		  x[i+2]=x1[i+2]/Cscale.Wscx1;
		}
	      else
		{
		  x[i]=exp10( XPi2R(x1[i]));
		  x[i+2]=exp10(XPi2R( x1[i]+x1[i+2] ));
		  x[i+2] -= x[i];
		}
	      if ( Cscale.logflag1[1] == 'n' ) 
		{
		  x[i+1]= YPi2R( x1[i+1]);
		  x[i+3]=x1[i+3]/Cscale.Wscy1;
		}
	      else
		{
		  x[i+1]=exp10( YPi2R( x1[i+1]));
		  x[i+3]=exp10( YPi2R( x1[i+3]+x1[i+1])); 
		  x[i+2] -= x[i+1];
		}
	    }
	}
      else 
	sciprint(" Wrong dir %s argument in echelle2d\r\n",dir);
    }
}

 
/** meme chose mais pour axis **/

axis2d_(alpha,initpoint,size,initpoint1,size1)
     double initpoint[2],size[3],size1[3], *alpha;
     integer initpoint1[2];
{
  double sina ,cosa;
  double xx,yy,scl;
  /* pour eviter des problemes numerique quand Cscale.scx1 ou Cscale.scy1 sont 
     tres petits et cosal ou sinal aussi 
     */
  if ( Abs(*alpha) == 90 ) 
    {
      scl=Cscale.Wscy1;
    }
  else 
    {
      if (Abs(*alpha) == 0) 
	{
	  scl=Cscale.Wscx1;
	}
      else 
	{
	  sina= sin(*alpha * M_PI/180.0);
	  cosa= cos(*alpha * M_PI/180.0);
	  xx= cosa*Cscale.Wscx1; xx *= xx;
	  yy= sina*Cscale.Wscy1; yy *= yy;
	  scl= sqrt(xx+yy);
	}
    }
  size1[0] = size[0]*scl;
  size1[1]=  size[1]*scl;
  size1[2]=  size[2];
  initpoint1[0]=inint(XScale(initpoint[0]));
  initpoint1[1]=inint(YScale(initpoint[1]));
}

/** Changement interactif d'echelle **/

extern int EchCheckSCPlots();

zoom() 
{
  char driver[4];
  integer aaint[4],flag[2];
  integer pixmode,alumode,verbose=0,narg,ww;
  C2F(dr1)("xget","window",&verbose,&ww,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if ( EchCheckSCPlots("v",&ww) >= 2) 
    {
      sciprint("Can't zoom on graphics with subwindows\r\n");
      return;
    }
  C2F(dr)("xget","pixmap",&verbose,&pixmode,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","alufunction",&verbose,&alumode,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  GetDriver1_(driver,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if (strcmp("Rec",driver) != 0) 
    {
      Scistring("\n Use the Rec driver to zoom " );
      return;
    }
  else 
    {
      /* Using the mouse to get the new rectangle to fix boundaries */
      integer ibutton,in;
      double x0,yy0,x,y,xl,yl,bbox[4];
      SetDriver_("X11",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      C2F(dr1)("xset","alufunction",(in=6,&in),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xclick","one",&ibutton,PI0,PI0,PI0,PI0,PI0,&x0,&yy0,PD0,PD0,0L,0L);
      x=x0;y=yy0;
      ibutton=-1;
      while ( ibutton == -1 ) 
	{
	  /* dessin d'un rectangle */
	  zoom_rect(x0,yy0,x,y);
	  if ( pixmode == 1) C2F(dr1)("xset","wshow",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  C2F(dr1)("xgetmouse","one",&ibutton,PI0,PI0,PI0,PI0,PI0,&xl, &yl,PD0,PD0,0L,0L);
	  /* effacement du rectangle */
	  zoom_rect(x0,yy0,x,y);
	  if ( pixmode == 1) C2F(dr1)("xset","wshow",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  x=xl;y=yl;
	}
      C2F(dr1)("xset","alufunction",(in=3,&in),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      /* Back to the default driver which must be Rec and redraw of the recorded
	 graphics with the new scales 
	 we should add something to ``smooth'' the selected boundaries 
	 */
      SetDriver_(driver,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      bbox[0]=Min(x0,x);
      bbox[1]=Min(yy0,y);
      bbox[2]=Max(x0,x);
      bbox[3]=Max(yy0,y);
      /** c'est Tape_ReplayNewscale qui fait ca maintenant
      C2F(graduate)(&bbox[0],&bbox[2],&bboxg[0],&bboxg[2],&aaint[0],&aaint[1],
		    &kminr,&kmaxr,&ar) ;
      C2F(graduate)(&bbox[1],&bbox[3],&bboxg[1],&bboxg[3],&aaint[2],&aaint[3],
		    &kminr,&kmaxr,&ar) ;
		    **/
      C2F(dr1)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xset","alufunction",&alumode,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xget","window",&verbose,&ww,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      flag[0]=1;
      flag[1]=0;
      Tape_ReplayNewScale(" ",&ww,flag,PI0,aaint,PI0,PI0,bbox,PD0,PD0,PD0);
    }
}


unzoom() 
{
  char driver[4];
  integer ww,verbose=0,narg;
  GetDriver1_(driver,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if (strcmp("Rec",driver) != 0) 
    {
      Scistring("\n Use the Rec driver to unzoom " );
      return;
    }
  else 
    {
      C2F(dr1)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      C2F(dr1)("xget","window",&verbose,&ww,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      Tape_ReplayUndoScale("v",&ww);
    }
}


zoom_rect(x0,yy0,x,y)
     double x0,yy0,x,y;
{
  double xi,yi,w,h;
  xi=Min(x0,x);
  w=Abs(x0-x);
  yi=Max(yy0,y);
  h=Abs(yy0-y);
  C2F(dr1)("xrect","v",PI0,PI0,PI0,PI0,PI0,PI0,&xi,&yi,&w,&h,0L,0L);
}



/* 
  FRectI=[xmin,ymin,xmax,ymax] est transforme de 
  facon a avoir une graduation simple et reguliere 
  Xdec,Ydec,xnax,ynax
  caracterisant cette graduation 
  (voir les fonctions qui suivent )
*/

Gr_Rescale(logf,FRectI,Xdec,Ydec,xnax,ynax)
     double FRectI[4];
     integer xnax[],ynax[],Xdec[3],Ydec[3];
     char logf[];
{
  double FRectO[4];
  if (logf[0] == 'n') 
    {
      C2F(graduate)(FRectI,FRectI+2,FRectO,FRectO+2,xnax,xnax+1,Xdec,Xdec+1,Xdec+2);
      FRectI[0]=FRectO[0];FRectI[2]=FRectO[2];
    }
  else
    {
      Xdec[0]=FRectI[0];Xdec[1]=FRectI[2];Xdec[2]=0;
    }
  if (logf[1] == 'n') 
    {
      C2F(graduate)(FRectI+1,FRectI+3,FRectO+1,FRectO+3,ynax,ynax+1,Ydec,Ydec+1,Ydec+2);
      FRectI[1]=FRectO[1];FRectI[3]=FRectO[3];
    }
  else
    {
      Ydec[0]=FRectI[1];Ydec[1]=FRectI[3];Ydec[2]=0;
    }

}

/* 
  cadre + graduation 
*/

aplot1_(FRect,IRect,Xdec,Ydec,npx,npy,logflag,scx,scy,xofset,yofset)
     integer IRect[4],Xdec[3],Ydec[3],npx[2],npy[2];
     double FRect[4],scx,scy,xofset,yofset;  
     char logflag[2];
{
  C2F(dr)("xrect","v",&IRect[0],&IRect[1],&IRect[2],&IRect[3], PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  Axis1(0L,npx,Xdec[0],Xdec[1],Xdec[2],logflag[0],FRect,scx,scy,xofset,yofset);
  Axis1(-90L,npy,Ydec[0],Ydec[1],Ydec[2],logflag[1],FRect,scx,scy,xofset,yofset);
}

#define YMTrans(y) ( scy*(-(y)+FRect[3]) +yofset)
#define XMTrans(x) ( scx*((x) -FRect[0]) + xofset)

/* 
  trace un axe gradue en nax[1] grand intervalles avec les nombres 
  x_i= (kminr + i*(kmaxr-kminr)/*np2)*10^ar 
  ecrits pour chaque intervalles chacun des np2 intervalles etant 
  recoupe en np1 intervalles.
  FRect,scx,scy,xofset,yofset : donnent les parametres de changement 
  d'echelle entre coordonnees reelles et coordonnnees pixels.
*/


Axis1(axdir,nax,kminr,kmaxr,ar,logflag,FRect,scx,scy,xofset,yofset)
     double FRect[4],scx,scy,xofset,yofset;
     integer axdir,nax[2],kminr,kmaxr,ar;
     char logflag;
{
  integer LDPoint1[2];
  integer rect[4],ipas;
  double size1[3];
  integer flag=0,xx=0,yy=0,posi[2],smallersize;
  integer i,barlength,logrect[4],fontid[2],narg,verbose=0;
  if ( axdir == 0 ) 
    {
      size1[1]= scx*(FRect[2]-FRect[0])/150.0;
      size1[2]=2.0;
      size1[0]= scx*( (FRect[2]-FRect[0])/((double) nax[0]*nax[1]));
    }
  else 
    {
      size1[1]= scy*((FRect[1]-FRect[3])/100.0);
      size1[2]=2.0;
      size1[0]= scy*( (FRect[3]-FRect[1])/((double) nax[0]*nax[1]));
    }
  LDPoint1[0] = inint(XMTrans(FRect[0]));
  LDPoint1[1] = inint(YMTrans(FRect[1]));
  C2F(dr)("xaxis","void",&axdir,nax,PI0,LDPoint1,PI0,PI0, size1,PD0,PD0,PD0,0L,0L);
  barlength=inint(1.2*(size1[1]*size1[2]));
  if (logflag == 'l' )
    {
      C2F(dr)("xstringl","10",&xx,&yy,logrect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);	
      C2F(dr)("xget","font",&verbose,fontid,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      smallersize=fontid[1]-2;
      C2F(dr)("xset","font",fontid,&smallersize,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  /* c'est dividible par construction de nax[1] */
  ipas =(kmaxr-kminr)/nax[1] ;
  for (i=kminr ; i <= kmaxr ; i+= ipas )
    { 
      double angle=0.0;
      char foo[100];
      NumberFormat(foo,i,ar);
      C2F(dr)("xstringl",foo,&xx,&yy,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if ( axdir == 0 ) 
	{
	  integer iz1;
	  iz1= inint(XMTrans(((double) i)* exp10((double) ar)));
	  posi[0]=iz1 -rect[2]/2;
	  posi[1]=LDPoint1[1] + rect[3]+ barlength;
	}
      else 
	{
	  integer iz2;
	  iz2= inint(YMTrans(((double) i)* exp10((double) ar)));
	  posi[0]=LDPoint1[0] - rect[2] +barlength;
	  posi[1]=iz2 + rect[3]/4;
	}
      C2F(dr)("xstring",foo,&(posi[0]),&(posi[1]),PI0,&flag,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L); 
      if ( logflag == 'l' )
	{
	  C2F(dr)("xset","font",fontid,fontid+1,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xstring","10",(posi[0] -= logrect[2],&posi[0]),
		  (posi[1] += logrect[3],&posi[1]),
		  PI0,&flag,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L);
	  C2F(dr)("xset","font",fontid,&smallersize,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	}
    }
  if ( logflag == 'l' ) C2F(dr)("xset","font",fontid,fontid+1,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}

/* Format pour imprimer un nombre de la forme k10^a */

NumberFormat(str,k,a) 
     integer k,a;
     char str[];
{
  if ( k==0) 
    {
      sprintf(str,"0");
    }
  else
    {
      switch (a) 
	{
	case -1: sprintf(str,"%.1f",(double)k/10.0);break;
	case -2: sprintf(str,"%.2f",(double)k/100.0);break;
	case 0 : sprintf(str,"%d",k);break;
	case 1 : sprintf(str,"%d0",k);break;
	case 2 : sprintf(str,"%d00",k);break;
	default: sprintf(str,"%de%d",k,a) ;break;
	}
    }
}

/* 
  La routine qui suit : pour [ xmi,xma] donn\'e
  cherche a trouver (xi,xa,np1,np2) tels que
  xi <= xmi <= xmax <= xa ou l'intervalle [xi,xa] 
  ou xi et xa sont de la forme kminr 10^ar et kmaxr 10^ar.
  l'intervalle [xi,xa] se gradue de facon simple en *np2 intervalles
  ( kminr-kmaxr est divisible par *np2 ) 
  x_i= (kminr + i*(kmaxr-kminr)/*np2)*10^ar;
  i=0:(*np2)
  chacun des np2 intervalles peut-etre a son tour coupe 
  en np1 intervalles sans graduation.
  [np1,np2] sont comme les parametres nax de plot2d.
  
  on ne veut pas un nombre d'intervalle trop grand ( *np2 <=10 ) 
  et on veut que [xi,xa] soit aussi voisin que possible de l'intervalle 
  d'origine [xmi,xma]
  Attention il faut que xmi <= xma 
*/

C2F(graduate)(xmi,xma,xi,xa,np1,np2,kminr,kmaxr,ar)
     double *xmi,*xma,*xi,*xa;
     integer *np1,*np2,*kminr,*kmaxr,*ar;
{
  if ( *xmi > *xma) 
    {
      double xma1=*xmi, xmi1=*xma;
      graduate1(&xmi1,&xma1,xi,xa,np1,np2,kminr,kmaxr,ar);
    }
  else 
    graduate1(xmi,xma,xi,xa,np1,np2,kminr,kmaxr,ar);
}

graduate1(xmi,xma,xi,xa,np1,np2,kminr,kmaxr,ar)
     double *xmi,*xma,*xi,*xa;
     integer *np1,*np2,*kminr,*kmaxr,*ar;
{
  integer npr,b,i,dx,dxmi,dxma;
  /* fprintf(stderr,"[%20.10f,%20.10f]\n",*xmi,*xma); */
  /* 
    Recherche de la precision a laquelle il faut chercher 
   */
  dx   = ( (*xma) != (*xmi) ) ? (int) ceil(log10(Abs((*xma)-(*xmi)))) :0;
  dxmi = (*xmi != 0 ) ? (int) ceil(log10(Abs((*xmi)))) : 0;
  dxma = (*xma != 0 ) ? (int) ceil(log10(Abs((*xma)))) : 0;
  dx=Max(dx-dxmi,dx-dxma);
  /* il faut limiter b de sorte que dans la decomposition */
  /* avec b les nombres entiers manipules ne deviennent pas */
  /* on choisit donc b < 10 en considerant que le plus grand entier est */
  /* 0x7FFFFFFF */
  b=Max(-dx+2,1);
  /* fprintf(stderr,"choix de b=%d",b); */
  if ( b >= 10 )
    {
      double xmi1,xma1;
      /* fprintf(stderr,"je ne peux decomposer les 2 nombres sont identiques\n"); */
      /* 
	a la precision donnee les deux nombre ne peuvent etre decomposer 
	kmin,kmax devrait sinon depasser maxint
	on les ecarte de ce qu'il faut pour pouvoir 
	les separer. ( 7 = 8-1 ) 
	*/
      xmi1 = *xmi-exp10((double) -7);
      xma1 = *xmi+exp10((double) -7);
      graduate1(&xmi1,&xma1,xi,xa,np1,np2,kminr,kmaxr,ar);
      return;
    }
  while ( b >= 1 ) 
    {
      /* fprintf(stderr,"\tAppel avec %d\n",b); */
      C2F(gradua)(xmi,xma,kminr,kmaxr,ar,&npr,&b) ;
      *xi= (*kminr)*exp10((double) *ar);
      *xa= (*kmaxr)*exp10((double) *ar);
      /* fprintf(stderr,"\tRes=[%20.10f,%20.10f]\n",*xi,*xa); */
      *np2= npr;
      if ( *np2 <= 20 ) 
	break;
      else
	b--;
    }
  /* 
    on veut essayer de ne pas depasser 10 intervalles ( *np2 <= 10) 
    pour les intervalle ou on ecrit un nombre,
    or on peut en avoir jusqu'a 20. On regarde si le nombre d'intervalle 
    est divisible. on aura alors une graduation en np2 pour l'ecriture 
    des nombres et une sous graduation np1 juste avec des tirets.
    */
  *np1= 2 ;
  if ( *np2 <= 10 ) return ;
  for ( i=2 ; i <=10 ; i++)
    {
      if ( *np2 % i == 0)       
	{
	  *np1=i,*np2 /= i;
	  return;
	}
    }
  *np1=*np2;*np2=1;
}


/*
  renvoit kminr,kmaxr et ar tels que 
  [kminr*10^ar,kmaxr*10^ar] contient [xmi,xma] 
  b est un parametre de decompSup,decompInf 
  on doit avoir a l'appel xmi < xma.
  le choix se fait entre deux intervalles possibles 
  on choisit celui qui est le plus proche de [xmi,xma] 
  a condition que (kmaxr-kminr) <= 20 
  pour b=1 on sait que (kmaxr-kminr ) <= 20 
  20 intervalles au plus ( que l'on obtient si xmin et xmax sont 
  de signe opposes sinon c'est 10 )
*/

C2F(gradua)(xmi,xma,kminr,kmaxr,ar,npr,b) 
     double *xmi,*xma;
     integer *kminr,*kmaxr,*ar,*b,*npr;
{
  double x0=*xmi,x1=*xma;
  integer x0k,x0a;
  integer x1k,x1a;
  integer kmin1,kmax1,a1,np1,kmin2,kmax2,a2,np2,kmin,kmax,a,np;
  decompInf(x0,&x0k,&x0a,*b);
  decompSup(x1,&x1k,&x1a,*b);
  kmin1=(int) floor(x0*exp10((double) -x1a));
  kmax1=x1k;
  np1= Abs(kmax1-kmin1);
  if ( np1 > 10 && ( (np1 % 2) == 0)) np1 /=2;
  a1=x1a;
  /* fprintf(stderr,"\t\tsols : [%d,%d].10^%d,n=%d\t",kmin1,kmax1,a1,np1);  */
  kmin2=x0k;
  kmax2=(int) ceil( x1*exp10((double) -x0a));
  np2 = Abs(kmax2-kmin2);
  if ( np2 > 10 && ( np2 % 2 == 0)) np2 /=2;
  a2=x0a;
  /* fprintf(stderr,"[%d,%d].10^%d=%d\n",kmin2,kmax2,a2,np2);  */
  if ( np1*exp10((double)a1) < np2*exp10((double) a2) )
    {
      if ( np1 <= 20 ) 
	{
	  kmin=kmin1;	  kmax=kmax1;	  np=np1;	  a=a1;
	}
      else 
	{
	  kmin=kmin2;	  kmax=kmax2;	  np=np2;	  a=a2;
	}
    }
  else 
    {
      if ( np2 <= 20 ) 
	{
	  kmin=kmin2;	  kmax=kmax2;	  np=np2;	  a=a2;
	}
      else 
	{
	  kmin=kmin1;	  kmax=kmax1;	  np=np1;	  a=a1;
	}
    }
  *kminr=kmin;
  *kmaxr=kmax;
  *ar=a;
  *npr=np;
  if ( kmin==kmax ) 
    {
      /* 
       * a la precision demandee les deux [xi,xa] est reduit a un point
       * on elargit l'intervalle
       */
      /* fprintf(stderr,"Arg : kmin=kmax=%d",kmin) ; */
      /* fprintf(stderr," a=%d, x0=%f,x1=%f\n",a,x0,x1); */
      (*kminr)-- ; (*kmaxr)++;*npr=2;
    };
}

/*
 * soit x > 0 reel fixe et b entier fixe : alors il existe un unique couple 
 * (k,a) dans NxZ avec k dans [10^(b-1)+1,10^b] tel que 
 * (k-1)*10^a < x <= k 10^a 
 * donne par  a = ceil(log10(x))-b et k=ceil(x/10^a) 
 * decompSup renvoit xk=k et xa=a
 * si x < 0 alors decompSup(x,xk,xa,b) 
 *    s'obtient par decompInf(-x,xk,xa,b) et xk=-xk 
 * Remarque : la taille de l'entier k obtenu est controle par b 
 * il faut choisir b < 10 pour ne pas depasser dans k l'entier maximum
 */

decompSup(x,xk,xa,b)
     double x;
     integer *xk,*xa,b;
{
  if ( x == 0.0 ) 
    { 
      *xk=0 ; *xa= 1;
    }
  else 
    {
      if ( x > 0 ) 
	{
	  *xa = (int) ceil(log10(x)) - b ;
	  *xk = (int) ceil(x/exp10((double) *xa));
	}
      else 
	{
	  decompInf(-x,xk,xa,b);
	  *xk = -(*xk);
	}
    }
}
 

/*
 * soit x > 0 alors il exsite un unique couple 
 * (k,a) dans NxZ avec k in [10^(b-1),10^b-1] tel que 
 * (k)*10^a <= x < k+1 10^a 
 * donne par 

 * a = floor(log10(x))-b+1 et k = floor(x/10^a) 
 * decompInf renvoit xk=k et xa=a
 * si x < 0 alors decompInf(x,xk,xa,b) 
 *    s'obtient par decompSup(-x,xk,xa,b) et xk=-xk 
 */

decompInf(x,xk,xa,b)
     double x;
     integer *xk,*xa,b;
{
  if ( x == 0.0 ) 
    { 
      *xk=0 ; *xa= 1;
    }
  else 
    {
      if ( x > 0 ) 
	{
	  *xa = (int) floor(log10(x)) -b +1 ;
	  *xk = (int) floor(x/exp10((double) *xa));
	}
      else 
	{
	  decompSup(-x,xk,xa,b);
	  *xk = -(*xk);
	}
    }
}
 

#ifdef TEST 


main() 
{
  double xmin=1.0,xmax=1.0,eps=1.e-10,xi,xa;
  integer n1,n2,n,i;
  int kminr,kmaxr,ar;
  xmin=1.0;
  xmax=1.0+eps;
  C2F(graduate)(&xmin,&xmax,&xi,&xa,&n1,&n2,&kminr,&kmaxr,&ar) ;
  fprintf(stderr,"test, [%f,%f,%d,%d]\n",xi,xa,n1,n2); 
}

C2F(dr)() {} ;

#endif

    









