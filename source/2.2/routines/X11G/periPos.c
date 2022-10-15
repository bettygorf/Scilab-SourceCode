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

/*----------------------BEGIN----------------------
\def\encadre#1{\paragraph{}\fbox{\begin{minipage}[t]{15cm}#1 \end{minipage}}}
\section{A Postscript Driver}
---------------------------------------------------*/

#include <stdio.h>
#include <math.h>
#include <string.h>
#include <malloc.h> /* in case od dbmalloc use */

#ifdef THINK_C
#define CoordModePrevious 0
#define CoordModeOrigin 1
#define GXclear 0
#define GXand 1
#define GXandReverse 2
#define GXcopy 3
#define GXandInverted 4
#define GXnoop 5
#define GXxor 6
#define GXor 7
#define GXnor 8
#define GXequiv 9
#define GXinvert 10
#define GXorReverse 11
#define GXcopyInverted 12
#define GXorInverted 13
#define GXnand 14
#define GXset 15
#else
#include <X11/Xlib.h>
#endif
#include "periPos.h"
#include "Math.h"

#define NUMCOLORS 17

typedef  struct {
  float  r,g,b;} TabC;

extern TabC tabc[NUMCOLORS];


#define Char2Int(x)   ( x & 0x000000ff )

static FILE *file=stdout ;

/** Structure to keep the graphic state  **/

struct BCG 
{ 
   int CurHardFontSize;
   int CurHardFont;
   int CurHardSymb;
   int CurHardSymbSize;
   int CurLineWidth;
   int CurPattern;
   int CurColor;
   int IDWhitePattern;
   int CurWindow;
   int CurVectorStyle;
   int CurDrawFunction;
   int ClipRegionSet;
   int CurClipRegion[4];
   int CurDashStyle;
  char CurNumberDispFormat[20];
   int CurColorStatus;
}  ScilabGC_pos_ ;


/*-----------------------------------------------------
\encadre{General routines}
-----------------------------------------------------*/

/** To select the graphic Window  **/

xselgraphic_pos_(v1,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{}

/** End of graphic (close the file) **/

xendgraphic_pos_()
{
  if (file != stdout) {
    fprintf(file,"\n showpage\n");
    fprintf(file,"\n end saved restore \n");
    fclose(file);
    file=stdout;}
}

xend_pos_(v1,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
 xendgraphic_pos_();
}


/** Clear the current graphic window     **/
/** In Postscript : nothing      **/

clearwindow_pos_(v1,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4) 
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  /* fprintf(file,"\n showpage"); */
  /** Sending the scale etc.. in case we want an other plot **/
  /* FileInit(file); */
}

/** To generate a pause : Empty here **/

xpause_pos_(str,sec_time,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *sec_time,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{}

/** Wait for mouse click in graphic window : Empty here **/

xclick_pos_(str,ibutton,xx1,yy1,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
  integer *ibutton,*xx1,*yy1,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ }

xclick_any_pos_(str,ibutton,xx1,yy1,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
  integer *ibutton,*xx1,*yy1,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ }

xgetmouse_pos_(str,ibutton,xx1,yy1,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *ibutton,*xx1,*yy1,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ }

/** Clear a rectangle **/

cleararea_pos_(str,x,y,w,h,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *x,*y,*w,*h,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  fprintf(file,"\n [ %d %d %d %d ] clearzone",(int)*x,(int)*y,(int)*w,(int)*h);
}



/*---------------------------------------------------------------------
\section{Function for graphic context modification}
------------------------------------------------------------------------*/

/** to get the window upper-left pointeger coordinates **/

getwindowpos_pos_(verbose,x,narg)
  integer *verbose,*x,*narg;
{
  *narg = 2;
  x[0]= x[1]=0;
  if (*verbose == 1) 
    sciprint("\n CWindow position :%d,%d\r\n",(int)x[0],(int)x[1]);
 }

/** to set the window upper-left pointeger position (Void) **/

setwindowpos_pos_(x,y,v3,v4)
     integer *x,*y,*v3,*v4;
{
}

/** To get the window size **/
/** In Postscript we choose (600,424) **/
/** This size was chosen to have good compatibility with X11 **/
/** for line thickness etc \ldots **/

static integer prec_fact =10;

getwindowdim_pos_(verbose,x,narg)
  integer *verbose,*x,*narg;
{     
  *narg = 2;
  x[0]= 600*prec_fact;
  x[1]= 424*prec_fact;
  if (*verbose == 1) 
    sciprint("\n CWindow dim :%d,%d\r\n",(int)x[0],(int)x[1]);
} 

/** To change the window dimensions : do Nothing in Postscript  **/

setwindowdim_pos_(x,y,v3,v4)
     integer *x,*y,*v3,*v4;
{
}


/** Select a graphic Window : Empty for Postscript **/

setcurwin_pos_(intnum,v2,v3,v4)
     integer *intnum,*v2,*v3,*v4;
{}

/** Get the id number of the Current Graphic Window **/

getcurwin_pos_(verbose,intnum,narg)
     integer *verbose,*intnum,*narg;
{
  *narg =1 ;
  *intnum = ScilabGC_pos_.CurWindow ;
  if (*verbose == 1) 
    Scistring("\nJust one graphic page at a time ");
}

/** Set a clip zone (rectangle ) **/

setclip_pos_(x,y,w,h)
     integer *x,*y,*w,*h;
{
  ScilabGC_pos_.ClipRegionSet = 1;
  ScilabGC_pos_.CurClipRegion[0]= *x;
  ScilabGC_pos_.CurClipRegion[1]= *y;
  ScilabGC_pos_.CurClipRegion[2]= *w;
  ScilabGC_pos_.CurClipRegion[3]= *h;
  fprintf(file,"\n%d %d %d %d setclipzone",(int)*x,(int)*y,(int)*w,(int)*h);
}

/** unset clip zone **/

unsetclip_pos_(v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{
  ScilabGC_pos_.ClipRegionSet = 0;
  ScilabGC_pos_.CurClipRegion[0]= -1;
  ScilabGC_pos_.CurClipRegion[1]= -1;
  ScilabGC_pos_.CurClipRegion[2]= 200000;
  ScilabGC_pos_.CurClipRegion[3]= 200000;
  fprintf(file,"\n%d %d %d %d setclipzone",-1,-1,200000,200000);
}

/** Get the boundaries of the current clip zone **/

getclip_pos_(verbose,x,narg)
     integer *verbose,*x,*narg;
{
  x[0] = ScilabGC_pos_.ClipRegionSet;
  if ( x[0] == 1)
    {
      *narg = 5;
      x[1] =ScilabGC_pos_.CurClipRegion[0];
      x[2] =ScilabGC_pos_.CurClipRegion[1];
      x[3] =ScilabGC_pos_.CurClipRegion[2];
      x[4] =ScilabGC_pos_.CurClipRegion[3];
    }
  else *narg = 1;
  if (*verbose == 1)
  if (ScilabGC_pos_.ClipRegionSet == 1)
    sciprint("\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d\r\n",
	      ScilabGC_pos_.CurClipRegion[0],
	      ScilabGC_pos_.CurClipRegion[1],
	      ScilabGC_pos_.CurClipRegion[2],
	      ScilabGC_pos_.CurClipRegion[3]);
  else 
    Scistring("\nNo Clip Region");
}

/*----------------------------------------------------------
\encadre{For the drawing functions dealing with vectors of 
 points, the following routine is used to select the mode 
 absolute or relative }
 Absolute mode if *num==0, relative mode if *num != 0
------------------------------------------------------------*/

setabsourel_pos_(num,v2,v3,v4)
     	integer *num,*v2,*v3,*v4;
{
  if (*num == 0 )
    ScilabGC_pos_.CurVectorStyle =  CoordModeOrigin;
  else 
    ScilabGC_pos_.CurVectorStyle =  CoordModePrevious ;
}

/** to get information on absolute or relative mode **/

getabsourel_pos_(verbose,num,narg)
     	integer *verbose,*num,*narg;
{
  *narg = 1;
    *num = ScilabGC_pos_.CurVectorStyle  ;
    if (*verbose == 1) 
  if (ScilabGC_pos_.CurVectorStyle == CoordModeOrigin)
    Scistring("\nTrace Absolu");
  else 
    Scistring("\nTrace Relatif");
  }


/** The alu function for drawing : Works only with X11 **/
/** Not in Postscript **/

setalufunction_pos_(string)
     char string[] ;
{    
  integer value;
  
  idfromname_pos_(string,&value);
  if ( value != -1)
    {ScilabGC_pos_.CurDrawFunction = value;
     fprintf(file,"\n%% %d setalufunction",(int)value);
      }
}

/** All the possibilities : Read The X11 manual to get more informations **/

struct alinfo { 
  char *name;
  char id;
  char *info;} AluStruc_pos_[] =
{ 
  "GXclear" ,GXclear," 0 ",
  "GXand" ,GXand," src AND dst ",
  "GXandReverse" ,GXandReverse," src AND NOT dst ",
  "GXcopy" ,GXcopy," src ",
  "GXandInverted" ,GXandInverted," NOT src AND dst ",
  "GXnoop" ,GXnoop," dst ",
  "GXxor" ,GXxor," src XOR dst ",
  "GXor" ,GXor," src OR dst ",
  "GXnor" ,GXnor," NOT src AND NOT dst ",
  "GXequiv" ,GXequiv," NOT src XOR dst ",
  "GXinvert" ,GXinvert," NOT dst ",
  "GXorReverse" ,GXorReverse," src OR NOT dst ",
  "GXcopyInverted" ,GXcopyInverted," NOT src ",
  "GXorInverted" ,GXorInverted," NOT src OR dst ",
  "GXnand" ,GXnand," NOT src OR NOT dst ",
  "GXset" ,GXset," 1 "};

idfromname_pos_(name1,num)
     char name1[];
     integer *num;
{integer i;
 *num = -1;
 for ( i =0 ; i < 16;i++)
   if (strcmp(AluStruc_pos_[i].name,name1)== 0) 
     *num=AluStruc_pos_[i].id;
 if (*num == -1 ) 
   {
     Scistring("\n Use the following keys :");
     for ( i=0 ; i < 16 ; i++)
       sciprint("\nkey %s -> %s\r\n",AluStruc_pos_[i].name,
	       AluStruc_pos_[i].info);
   }
}


setalufunction1_pos_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{     
  integer value;
  value=AluStruc_pos_[Min(16,Max(0,*num))].id;
  if ( value != -1)
    {
      ScilabGC_pos_.CurDrawFunction = value;
      /* to be done */
    }
}

/** To get the value of the alufunction **/

getalufunction_pos_(verbose,value,narg)
     integer *verbose , *value ,*narg;
{ 
  *narg =1 ;
  *value = ScilabGC_pos_.CurDrawFunction ;
   if (*verbose ==1 ) 
     { sciprint("\nThe Alufunction is %s -> <%s>\r\n",
	       AluStruc_pos_[*value].name,
	       AluStruc_pos_[*value].info);}
 }

/** to set the thickness of lines : 0 is a possible value **/
/** give the thinest line **/

setthickness_pos_(value,v2,v3,v4)
  integer *value,*v2,*v3,*v4 ;
{ 
  ScilabGC_pos_.CurLineWidth =Max(0, *value);
  fprintf(file,"\n%d Thickness",(int)Max(0,*value*prec_fact));
}

/** to get the thicknes value **/

getthickness_pos_(verbose,value,narg)
     integer *verbose,*value,*narg;
{
  *narg =1 ;
  *value = ScilabGC_pos_.CurLineWidth ;
  if (*verbose ==1 ) 
    sciprint("\nLine Width:%d\r\n",
	    ScilabGC_pos_.CurLineWidth ) ;
}
     

#define GREYNUMBER 17

/*-------------------------------------------------
\encadre{To set grey level for filing areas.
  from black (*num =0 ) to white 
  you must use the get function to get the id of 
  the white pattern }
----------------------------------------------------*/

setpattern_pos_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{
 integer i ; 
  if ( ScilabGC_pos_.CurColorStatus ==1) 
    {
      i= Max(0,Min(*num,NUMCOLORS-1));
      ScilabGC_pos_.CurColor = i ;
      set_c_pos_(i);
    }
  else 
    {
      i= Max(0,Min(*num,GREYNUMBER-1));
      ScilabGC_pos_.CurPattern = i;
      if (i ==0)
	fprintf(file,"\nfillsolid");
      else 
	fprintf(file,"\n%d Setgray",(int)i);
    }
}

/** To get the id of the current pattern  **/

getpattern_pos_(verbose,num,narg)
     integer *num,*verbose,*narg;
{ 
  *narg=1;
  if ( ScilabGC_pos_.CurColorStatus ==1) 
    {
      *num = ScilabGC_pos_.CurColor ;
      if (*verbose == 1) 
	sciprint("\n Color : %d\r\n",
		 ScilabGC_pos_.CurPattern);
    }
  else 
    {
      *num = ScilabGC_pos_.CurPattern ;
      if (*verbose == 1) 
	sciprint("\n Pattern : %d\r\n",
		 ScilabGC_pos_.CurPattern);
    }
}


/** To get the id of the white pattern **/

getwhite_pos_(verbose,num,narg)
     integer *num,*verbose,*narg;
{
  *num = ScilabGC_pos_.IDWhitePattern ;
  if (*verbose==1) 
    sciprint("\n Id of White Pattern %d\r\n",(int)*num);
  *narg=1;
}

/** To set dash-style : **/
/**  use a table of dashes and set default dashes to **/
/**  one of the possible value. value pointeger **/
/**  to a strictly positive integer **/

static integer DashTab_pos[6][4] = {
  {2,5,2,5}, {5,2,5,2},  {5,3,2,3}, {8,3,2,3},
  {11,3,2,3}, {11,3,5,3}};


setdash_pos_(value,v2,v3,v4)
     integer *value,*v2,*v3,*v4;
{
  static integer maxdash = 6, l2=4,l3 ;

  if ( ScilabGC_pos_.CurColorStatus ==1) 
    {
      int i;
      i= Max(0,Min(*value,NUMCOLORS-1));
      ScilabGC_pos_.CurColor =i;
      set_c_pos_(i);
    }
  else 
    {
      l3 = Min(maxdash-1,*value-1);
      ScilabGC_pos_.CurDashStyle= l3 + 1 ;
      setdashstyle_pos_(value,DashTab_pos[Max(0,l3)],&l2);
    }
}

/** To change The Pos-default dash style **/
/** if *value == 0, use a solid line, if *value != 0 **/
/** the dash style is specified by the xx vector of n values **/
/** xx[3]={5,3,7} and *n == 3 means :  5white 3 void 7 white \ldots **/
  
setdashstyle_pos_(value,xx,n)
     integer *value,xx[],*n;
{
  integer i ;
  if ( *value == 0) fprintf(file,"\n[] 0 setdash");
  else 
    {
      fprintf(file,"\n[");
      for (i=0;i<*n;i++)
	fprintf(file,"%d ",(int)xx[i]*prec_fact);
      fprintf(file,"] 0 setdash");
    }
}


/** to get the current dash-style **/

getdash_pos_(verbose,value,narg)
     integer *verbose,*value,*narg;
{integer i ;
 *narg =1 ;
 if ( ScilabGC_pos_.CurColorStatus ==1) 
   {
     *value=ScilabGC_pos_.CurColor;
     if (*verbose == 1) sciprint("Color %d",(int)*value);
     return;
   }
 *value=ScilabGC_pos_.CurDashStyle;
 if ( *value == 0) 
   { if (*verbose == 1) Scistring("\nLine style = Line Solid");}
 else 
   {
     value[1]=4;
     *narg = value[1]+2;
     for ( i =0 ; i < value[1]; i++) value[i+2]=DashTab_pos[*value-1][i];
     if (*verbose ==1 ) 
       {
	 sciprint("\nDash Style %d:<",(int)*value);
	 for ( i =0 ; i < value[1]; i++)
	   sciprint("%d ",(int)value[i+2]);
	 Scistring(">\n");
       }
   }
}



usecolor_pos_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{
  integer i;
  if ( ScilabGC_pos_.CurColorStatus != *num)
    {
      if (ScilabGC_pos_.CurColorStatus == 1) 
	{
	  /* je passe de Couleur a n&b */
	  /* remise des couleurs a vide */
	  ScilabGC_pos_.CurColorStatus = 1;
	  setpattern_pos_((i=0,&i),PI0,PI0,PI0);
	  /* passage en n&b */
	  ScilabGC_pos_.CurColorStatus = 0;
	  i= ScilabGC_pos_.CurPattern;
	  setpattern_pos_(&i,PI0,PI0,PI0);
	  i= ScilabGC_pos_.CurDashStyle;
	  setdash_pos_(&i,PI0,PI0,PI0);
	}
      else 
	{
	  /* je passe en couleur */
	  /* remise a zero des patterns et dash */
	  /* remise des couleurs a vide */
	  ScilabGC_pos_.CurColorStatus = 0;
	  setpattern_pos_((i=0,&i),PI0,PI0,PI0);
	  setdash_pos_((i=0,&i),PI0,PI0,PI0);
	  /* passage en couleur  */
	  ScilabGC_pos_.CurColorStatus = 1;
	  i= ScilabGC_pos_.CurColor;
	  setpattern_pos_(&i,PI0,PI0,PI0);
	}
    }
  if ( ScilabGC_pos_.CurColorStatus == 1) 
    {
      fprintf(file,"\n/Setgray {/i exch def ColorR i get ColorG i get ColorB i get setrgbcolor } def ");
      fprintf(file,"\n/Setcolor {/i exch def ColorR i get ColorG i get ColorB i get setrgbcolor } def ");
      /** Voir fichier color.c **/
      /** ColorInit(); **/
    }
  else {
      fprintf(file,"\n/Setgray { WhiteLev div setgray } def ");
      fprintf(file,"\n/Setcolor { WhiteLev div setgray } def ");
  }
}

ColorInit()
{
  integer i;
  fprintf(file,"\n/ColorR [");
  for ( i=0; i < NUMCOLORS; i++)
      fprintf(file,"%f ",tabc[i].r);
  fprintf(file,"] def");
  fprintf(file,"\n/ColorG [");
  for ( i=0; i < NUMCOLORS; i++)
      fprintf(file,"%f ",tabc[i].g);
  fprintf(file,"] def");
  fprintf(file,"\n/ColorB [");
  for ( i=0; i < NUMCOLORS; i++)
      fprintf(file,"%f ",tabc[i].b);
  fprintf(file,"] def");
}

set_c_pos_(i)
     integer i;
{
  integer j;
  j=Max(Min(i,NUMCOLORS-1),0);
  fprintf(file,"\n%d Setcolor",(int)j);
}
/*--------------------------------------------------------
\encadre{general routines accessing the  set<> or get<>
 routines } 
-------------------------------------------------------*/

int InitScilabGC_pos_();

sempty_pos_(verbose,v2,v3,v4)
     integer *verbose,*v2,*v3,*v4;
{
  if ( *verbose ==1 ) Scistring("\n No operation ");
}

gempty_pos_(verbose,v2,v3)
     integer *verbose,*v2,*v3;
{
  if ( *verbose ==1 ) Scistring("\n No operation ");
}

#define NUMSETFONC 18

/** Table in lexicographic order **/
int xsetfont_pos_(),xgetfont_pos_(),xsetmark_pos_(),xgetmark_pos_();

struct bgc { char *name ;
	     int  (*setfonc )() ;
	     int  (*getfonc )() ;}
  ScilabGCTab_pos_[] = {
   "alufunction",setalufunction1_pos_,getalufunction_pos_,
   "clipoff",unsetclip_pos_,getclip_pos_,
   "clipping",setclip_pos_,getclip_pos_,
   "dashes",setdash_pos_,getdash_pos_,
   "default",InitScilabGC_pos_, gempty_pos_,
   "font",xsetfont_pos_,xgetfont_pos_,
   "line mode",setabsourel_pos_,getabsourel_pos_,
   "mark",xsetmark_pos_,xgetmark_pos_,
   "pattern",setpattern_pos_,getpattern_pos_,
   "pixmap",sempty_pos_,gempty_pos_,
   "thickness",setthickness_pos_,getthickness_pos_,
   "use color",usecolor_pos_,gempty_pos_,
   "wdim",setwindowdim_pos_,getwindowdim_pos_,
   "white",sempty_pos_,getwhite_pos_,
   "window",setcurwin_pos_,getcurwin_pos_,
   "wpos",setwindowpos_pos_,getwindowpos_pos_,
   "wshow",sempty_pos_,gempty_pos_,
   "wwpc",sempty_pos_,gempty_pos_
 };

#ifdef linteger 

/* pour forcer linteger a verifier ca */

static 
test(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     integer flag ;
     integer  *verbose,*x1,*x2,*x3,*x4,*x5;
{ 
  setalufunction1_pos_(x1,x2,x3,x4);getalufunction_pos_(verbose,x1,x2);
  setclip_pos_(x1,x2,x3,x4);getclip_pos_(verbose,x1,x2);
  setdash_pos_(x1,x2,x3,x4);getdash_pos_(verbose,x1,x2);
  InitScilabGC_pos_(x1,x2,x3,x4); gempty_pos_(verbose,x1,x2);
  xsetfont_pos_(x1,x2,x3,x4);xgetfont_pos_(verbose,x1,x2);
  setabsourel_pos_(x1,x2,x3,x4);getabsourel_pos_(verbose,x1,x2);
  xsetmark_pos_(x1,x2,x3,x4);xgetmark_pos_(verbose,x1,x2);
  setpattern_pos_(x1,x2,x3,x4);getpattern_pos_(verbose,x1,x2);
  setthickness_pos_(x1,x2,x3,x4);getthickness_pos_(verbose,x1,x2);
  usecolor_pos_(x1,x2,x3,x4);gempty_pos_(verbose,x1,x2);
  setwindowdim_pos_(x1,x2,x3,x4);getwindowdim_pos_(verbose,x1,x2);
  sempty_pos_(x1,x2,x3,x4);getwhite_pos_(verbose,x1,x2);
  setcurwin_pos_(x1,x2,x3,x4);getcurwin_pos_(verbose,x1,x2);
  setwindowpos_pos_(x1,x2,x3,x4);getwindowpos_pos(verbose,x1,x2);
}

#endif 


scilabgcget_pos_(str,verbose,x1,x2,x3,x4,x5,dv1,dv2,dv3,dv4)
     double *dv1,*dv2,*dv3,*dv4;
     integer *verbose,*x1,*x2,*x3,*x4,*x5;
     char str[];
{
 ScilabGCGetorSet_pos_(str,1L,verbose,x1,x2,x3,x4,x5);
}

scilabgcset_pos_(str,x1,x2,x3,x4,x5,x6,dv1,dv2,dv3,dv4)
     double *dv1,*dv2,*dv3,*dv4;
     integer *x1,*x2,*x3,*x4,*x5,*x6;
     char str[];
{
 integer verbose ;
 verbose = 0 ;
 ScilabGCGetorSet_pos_(str,0L,&verbose,x1,x2,x3,x4,x5);}

ScilabGCGetorSet_pos_(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     integer flag ;
     integer  *verbose,*x1,*x2,*x3,*x4,*x5;
{ integer i ;
  for (i=0; i < NUMSETFONC ; i++)
     {
       integer j;
       j = strcmp(str,ScilabGCTab_pos_[i].name);
       if ( j == 0 ) 
	 { if (*verbose == 1)
	     sciprint("\nGettting Info on %s\r\n",str);
	   if (flag == 1)
	     (ScilabGCTab_pos_[i].getfonc)(verbose,x1,x2);
	   else 
	     (ScilabGCTab_pos_[i].setfonc)(x1,x2,x3,x4);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       sciprint("\nUnknow Postscript operator <%s>\r\n",str);
	       return;
	     }
	 }
     }
  sciprint("\n Unknow Postscript operator <%s>\r\n",str);
}

/*-----------------------------------------------------------
\encadre{Functions for drawing}
-----------------------------------------------------------*/



/*----------------------------------------------------
\encadre{display of a string
 at (x,y) position whith angle (alpha). Angles in degree
 positive when clockwise. If *flag ==1 a framed  box is added 
 around the string.}
-----------------------------------------------------*/
displaystring_pos_(string,x,y,v1,flag,v6,v7,angle,dv2,dv3,dv4)
     integer *x,*y ,*flag;
     double *angle;
     char string[] ;
     integer *v1,*v6,*v7;
     double *dv2,*dv3,*dv4;
{     
  integer i,rect[4] ;
  boundingbox_pos_(string,x,y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  fprintf(file,"\n(");
  for ( i=0; i < (int)strlen(string);i++)
    {
      if (string[i]== '(' || string[i] == ')' )
	fprintf(file,"%c%c",'\\',string[i]);
      else 
	fprintf(file,"%c",string[i]);
    }
  fprintf(file,") %d %d %d %5.2f [%d %d %d %d] Show",
	  (int)*x,(int)*y,(int)*flag,*angle,(int)rect[0],
	  (int)rect[1],(int)rect[2],(int)rect[3]);
 }


double bsize_pos_[6][4]= {{ 0.0,-7.0,4.63,9.0  },
		{ 0.0,-9.0,5.74,12.0 },
		{ 0.0,-11.0,6.74,14.0},
		{ 0.0,-12.0,7.79,15.0},
		{0.0, -15.0,9.72,19.0 },
		{0.0,-20.0,13.41,26.0}};

/** To get the bounding rectangle of a string **/
/** we can't ask Postscript directly so we have an **/
/** approximative result in Postscript : use the X11 driver **/
/** with the same current font to have a good result **/

boundingbox_pos_(string,x,y,rect,v5,v6,v7,dv1,dv2,dv3,dv4)
     integer *x,*y,*rect,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
     char string[];
{integer verbose,nargs,font[2];
 verbose=0;
 xgetfont_pos_(&verbose,font,&nargs);
 rect[0]= *x+bsize_pos_[font[1]][0]*((double) prec_fact);
 rect[1]= *y+bsize_pos_[font[1]][1]*((double) prec_fact);
 rect[2]= bsize_pos_[font[1]][2]*((double)prec_fact)*(int)strlen(string);
 rect[3]= bsize_pos_[font[1]][3]*((double)prec_fact);
}

/** Draw a single line in current style **/

drawline_pos_(xx1,yy1,x2,y2)
    integer *xx1, *x2, *yy1, *y2 ;
  {
    fprintf(file,"\n %d %d %d %d L",(int)*xx1,(int)*yy1,(int)*x2,(int)*y2);
  }

/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/

drawsegments_pos_(str,vx,vy,n,style,iflag,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n,vx[],vy[],*style,*iflag,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose=0,Dnarg,Dvalue[10];
  int i;
  integer fvect[1];
  fvect[0]= ScilabGC_pos_.CurPattern;
  /* store the current values */
  if ((int)  *iflag == 0 )
    WriteGeneric_pos_("drawsegs",1L,(*n)*2,vx,vy,*n,1L,fvect); 
  else
    {
      getdash_pos_(&verbose,Dvalue,&Dnarg);
      for ( i=0 ; i < *n/2 ; i++) 
	{
	  integer NDvalue;
	  if ( (int) *iflag == 1) 
	    NDvalue = style[i];
	  else 
	    NDvalue=(*style < 0) ? (integer) ScilabGC_pos_.CurDashStyle : *style;
	  setdash_pos_(&NDvalue,PI0,PI0,PI0);
	  WriteGeneric_pos_("drawsegs",1L,4L,&vx[2*i],&vy[2*i],2L,1L,fvect);
	}
      setdash_pos_( Dvalue,PI0,PI0,PI0);
    }
}

/** Draw a set of arrows **/

drawarrows_pos_(str,vx,vy,n,as,style,iflag,dv1,dv2,dv3,dv4)
     char str[];
     integer *as;
     integer *n,vx[],vy[],*style,*iflag;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose=0,Dnarg,Dvalue[10];
  int i;
  /* store the current values */
  if ((int)  *iflag == 0 )
    WriteGeneric_pos_("drawarrows",1L,(*n)*2,vx,vy,*n,1L,as); 
  else
    {
      getdash_pos_(&verbose,Dvalue,&Dnarg);
      for ( i=0 ; i < *n/2 ; i++) 
	{
	  integer NDvalue;
	  if ( (int) *iflag == 1) 
	    NDvalue = style[i];
	  else 
	    NDvalue=(*style < 0) ? (integer) ScilabGC_pos_.CurDashStyle : *style;
	  setdash_pos_(&NDvalue,PI0,PI0,PI0);
	  WriteGeneric_pos_("drawarrows",1L,4L,&vx[2*i],&vy[2*i],2L,1L,as);
	}
      setdash_pos_( Dvalue,PI0,PI0,PI0);
    }
}

/** Draw one rectangle **/

/** Draw or fill a set of rectangle **/
/** rectangles are defined by (vect[i],vect[i+1],vect[i+2],vect[i+3]) **/
/** for i=0 step 4 **/
/** (*n) : number of rectangles **/
/** fillvect[*n] : specify the action <?> **/

drawrectangles_pos_(str,vects,fillvect,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*fillvect,*n,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer cpat,verb=0,num;
  getpattern_pos_(&verb,&cpat,&num);
  WriteGeneric_pos_("drawbox",*n,4L,vects,vects,4*(*n),0L,fillvect);
  setpattern_pos_(&(cpat),PI0,PI0,PI0);
}

drawrectangle_pos_(str,x,y,width,height,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
    integer  *x, *y, *width, *height,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ 
  integer i = 1;
  integer fvect[1] ;
  integer vects[4];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;
  fvect[0] = ScilabGC_pos_.IDWhitePattern +1  ;
  drawrectangles_pos_(str,vects,fvect,&i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
}

/** Draw a filled rectangle **/

fillrectangle_pos_(str,x,y,width,height,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer  *x, *y, *width, *height,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ 
  integer i = 1;
  integer fvect[1] ;
  integer vects[4];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height ; 
  fvect[0] = ScilabGC_pos_.CurPattern ;
  drawrectangles_pos_(str,vects,fvect,&i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);    
}

/** Draw or fill a set of ellipsis or part of ellipsis **/
/** Each is defined by 6-parameters, **/
/** fillvect[*n] : specify the action <?> **/
/** caution angle=degreangle*64          **/

fillarcs_pos_(str,vects,fillvect,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*fillvect,*n,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer cpat,verb,num;
  verb=0;
  getpattern_pos_(&verb,&cpat,&num);
  WriteGeneric_pos_("fillarc",*n,6L,vects,vects,6*(*n),0L,fillvect);
  setpattern_pos_(&(cpat),PI0,PI0,PI0);
}

/** Draw a set of ellipsis or part of ellipsis **/
/** Each is defined by 6-parameters, **/
/** ellipsis i is specified by $vect[6*i+k]_{k=0,5}= x,y,width,height,angle1,angle2$ **/
/** <x,y,width,height> is the bounding box **/
/** angle1,angle2 specifies the portion of the ellipsis **/
/** caution : angle=degreangle*64          **/

drawarcs_pos_(str,vects,style,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*style,*n,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose=0,Dnarg,Dvalue[10];
  int i;
  /* store the current values */
  getdash_pos_(&verbose,Dvalue,&Dnarg);
  for ( i=0 ; i < *n ; i++) 
    {
      integer fvect,na=1;
      setdash_pos_(&style[i],PI0,PI0,PI0);
      fvect = ScilabGC_pos_.IDWhitePattern  +1;
      fillarcs_pos_(str,&vects[(6)*i],&fvect,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
    }
  setdash_pos_( Dvalue,PI0,PI0,PI0);
}


/** Draw a single ellipsis or part of it **/
/** caution angle=degreAngle*64          **/

drawarc_pos_(str,x,y,width,height,angle1,angle2,dv1,dv2,dv3,dv4)
     char str[];
     integer *angle1,*angle2, *x, *y, *width, *height;
     double *dv1,*dv2,*dv3,*dv4;
 { 
  integer i =1;
  integer fvect[1] ;
  integer vects[6];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;vects[4]= *angle1;vects[5]= *angle2;
  fvect[0] = ScilabGC_pos_.IDWhitePattern  +1;
  fillarcs_pos_(str,vects,fvect,&i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
}

/** Fill a single elipsis or part of it **/
/** with current pattern **/

fillarc_pos_(str,x,y,width,height,angle1,angle2,dv1,dv2,dv3,dv4)
     char str[];
     double *dv1,*dv2,*dv3,*dv4;
     integer *angle1,*angle2, *x, *y, *width, *height;
 { 
  integer i =1;
  integer fvect[1] ;
  integer vects[6];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;vects[4]= *angle1;vects[5]= *angle2;
  fvect[0] = ScilabGC_pos_.CurPattern ;
  fillarcs_pos_(str,vects,fvect,&i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
 }

/*--------------------------------------------------------------
\encadre{Filling or Drawing Polylines and Polygons}
---------------------------------------------------------------*/

/** Draw a set of *n polylines (each of which have (*p) points) **/
/** with lines or marks **/
/** drawvect[i] >= use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

drawpolylines_pos_(str,vectsx,vectsy,drawvect,n,p,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vectsx,*vectsy,*drawvect,*n,*p,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ integer verbose ,symb[2],Mnarg,Dnarg,Dvalue[10],NDvalue,i,close;
  verbose =0 ;
  /* store the current values */
  xgetmark_pos_(&verbose,symb,&Mnarg);
  getdash_pos_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i< *n ; i++)
    {
      if (drawvect[i] >= 0)
	{ /** on utilise la marque de numero associ\'ee **/
	  xsetmark_pos_(drawvect+i,symb+1,PI0,PI0);
	  /* if ajoute par s steer pour trace des marques en couleur */
	  if ( ScilabGC_pos_.CurColorStatus ==1) 
		  {
		      NDvalue=ScilabGC_pos_.CurDashStyle ;
		      set_c_pos_(NDvalue);
		  }
	  drawpolymark_pos_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
	}
      else
	{/** on utilise un style pointill\'e  **/
	  NDvalue = - drawvect[i] -1;
	  setdash_pos_(&NDvalue,PI0,PI0,PI0);
	  close = 0;
	  drawpolyline_pos_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,&close,PI0,PI0,PD0,PD0,PD0,PD0);
	}
    }
/** back to default values **/
setdash_pos_(Dvalue,PI0,PI0,PI0);
xsetmark_pos_(symb,symb+1,PI0,PI0);
}

/** fill a set of polygons each of which is defined by **/
/** (*p) points (*n) is the number of polygons **/
/** the polygon is closed by the routine **/
/** if fillvect <= whiteid-pattern the coresponding pattern is used 
/** if fillvect == whiteid-pattern +1 -> draw the boundaries 
/** if fillvect >= whiteid-pattern +2 -> fill with white and draw boundaries
/** fillvect[*n] :         **/

fillpolylines_pos_(str,vectsx,vectsy,fillvect,n,p,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vectsx,*vectsy,*fillvect,*n,*p,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer cpat,verb=0,num;
  if ( ScilabGC_pos_.CurVectorStyle !=  CoordModeOrigin)
    fprintf(file,"\n/absolu false def");
  getpattern_pos_(&verb,&cpat,&num);
  WriteGeneric_pos_("drawpoly",*n,(*p)*2,vectsx,vectsy,(*p)*(*n),1L,
			fillvect);
  setpattern_pos_(&(cpat),PI0,PI0,PI0);
  fprintf(file,"\n/absolu true def");
}

/** Only draw one polygon with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/

drawpolyline_pos_(str,n, vx, vy,closeflag,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n,*closeflag;
     integer vx[], vy[],*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ integer i =1;
  integer fvect[1] ;
  fvect[0] = ScilabGC_pos_.IDWhitePattern  +1;
  if (*closeflag == 1 )
    fprintf(file,"\n/closeflag true def");
  else 
    fprintf(file,"\n/closeflag false def");
  fillpolylines_pos_(str,vx,vy,fvect,&i,n,PI0,PD0,PD0,PD0,PD0);
}

/** Fill the polygon **/

fillpolyline_pos_(str,n, vx, vy,closeareaflag,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n,*closeareaflag;
     integer vx[], vy[],*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer i =1;
  integer fvect[1] ;
  fvect[0] = ScilabGC_pos_.CurPattern ;
  fillpolylines_pos_(str,vx,vy,fvect,&i,n,PI0,PD0,PD0,PD0,PD0);
}

/** Draw a set of  current mark centred at points defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_pos_(str,n, vx, vy,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *n ; 
     integer vx[], vy[],*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ integer keepid,keepsize,i=1,sz=ScilabGC_pos_.CurHardSymbSize;
  keepid =  ScilabGC_pos_.CurHardFont;
  keepsize= ScilabGC_pos_.CurHardFontSize;
  xsetfont_pos_(&i,&sz,PI0,PI0);
  displaysymbols_pos_(str,n,vx,vy);
  xsetfont_pos_(&keepid,&keepsize,PI0,PI0);
}

/*-----------------------------------------------------
\encadre{Routine for initialisation}
------------------------------------------------------*/

initgraphic_pos_(string,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char string[];
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{ 
  char string1[256];
  static integer EntryCounter = 0;
  integer fnum;
  if (EntryCounter >= 1) xendgraphic_pos_();
  strncpy(string1,string,256);
  /* Not so useful   
     sprintf(string2,"%d",(int)EntryCounter);
     strcat(string1,string2); */
  file=fopen(string1,"w");
  if (file == 0) 
    {
      sciprint("Can't open file %s, I'll use stdout\r\n",string1);
      file =stdout;
    }
  if (EntryCounter == 0)
    { 
      fnum=0;      loadfamily_pos_("Courier",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 
      fnum=1;      loadfamily_pos_("Symbol",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 
      fnum=2;      loadfamily_pos_("Times-Roman",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      fnum=3;      loadfamily_pos_("Times-Italic",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 
      fnum=4;      loadfamily_pos_("Times-Bold",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      fnum=5;      loadfamily_pos_("Times-BoldItalic",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 

    }
  FileInit(file);
  ScilabGC_pos_.CurWindow =EntryCounter;
  EntryCounter =EntryCounter +1;
}

FileInit(filen)
     FILE *filen;
{
  /** Just send Postscript commands to define scales etc....**/
  integer x[2],verbose,narg;
  verbose = 0; 
  getwindowdim_pos_(&verbose,x,&narg);
  fprintf(filen,"\n%% Dessin en bas a gauche de taille %d,%d",(int)x[0]/2,(int)x[1]/2);
  fprintf(filen,"\n[0.5 %d div 0 0 0.5 %d div neg  0 %d %d div] concat",
	  (int)prec_fact, (int)prec_fact,(int)x[1]/2,(int) prec_fact );
  InitScilabGC_pos_(PI0,PI0,PI0,PI0)	;
  fprintf(filen,"\n/WhiteLev %d def",ScilabGC_pos_.IDWhitePattern);
}

/*--------------------------------------------------------
\encadre{Initialisation of the graphic context. Used also 
to come back to the default graphic state}
---------------------------------------------------------*/


InitScilabGC_pos_(v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{ integer i,j,col;
  ScilabGC_pos_.IDWhitePattern = GREYNUMBER-1;
  ScilabGC_pos_.CurLineWidth=0 ;
  i=0;
  setthickness_pos_(&i,PI0,PI0,PI0);
  setalufunction_pos_("GXcopy");
  /** retirer le clipping **/
  i=j= -1;
  unsetclip_pos_(PI0,PI0,PI0,PI0);
  setdash_pos_((i=0,&i),PI0,PI0,PI0);
  xsetfont_pos_((i=2,&i),(j=1,&j),PI0,PI0);
  xsetmark_pos_((i=0,&i),(j=0,&j),PI0,PI0);
  /** trac\'e absolu **/
  ScilabGC_pos_.CurVectorStyle = CoordModeOrigin ;

  /* initialisation des pattern dash par defaut en n&b */
  ScilabGC_pos_.CurColorStatus =0;
  setpattern_pos_((i=0,&i),PI0,PI0,PI0);
  setdash_pos_((i=0,&i),PI0,PI0,PI0);
  /* initialisation de la couleur par defaut */ 
  ScilabGC_pos_.CurColorStatus = 1 ;
  setpattern_pos_((i=0,&i),PI0,PI0,PI0);
  /* Choix du mode par defaut (decide dans initgraphic_ */
  getcolordef(&col);
  usecolor_pos_(&col,PI0,PI0,PI0);
  strcpy(ScilabGC_pos_.CurNumberDispFormat,"%-5.2g");
}

/*-----------------------------------------------------
\encadre{Draw an axis whith a slope of alpha degree (clockwise)
 . Along the axis marks are set in the direction ( alpha + pi/2), in the 
  following way :
\begin{itemize}
\item   $n=<n1,n2>$,
\begin{verbatim}
     |            |           |
     |----|---|---|---|---|---|
     <-----n1---->                 
     <-------------n2-------->
\end{verbatim}
$n1$and $n2$ are integer numbers for interval numbers.
\item $size=<dl,r,coeff>$. $dl$ distance in points between 
     two marks, $r$ size in points of small mark, $r*coeff$ 
     size in points of big marks. (they are doubleing points numbers)
\item $init$. Initial pointeger $<x,y>$. 
\end{itemize}
}

-------------------------------------------------------------*/
drawaxis_pos_(str,alpha,nsteps,v2,initpoint,v6,v7,size,dx2,dx3,dx4)
     double *dx2,*dx3,*dx4;
     char str[];
     integer *alpha,*nsteps,*initpoint,*v2,*v6,*v7;
     double *size;
{
  fprintf(file,"\n %d [%d %d] [%f %f %f] [%d %d] drawaxis",
	  (int)*alpha,(int)nsteps[0],(int)nsteps[1],size[0],size[1],size[2],
	  (int)initpoint[0],(int)initpoint[1]);
}


/*-----------------------------------------------------
\encadre{Display numbers z[i] at location (x[i],y[i])
  with a slope alpha[i] (see displaystring_), if flag==1
  add a box around the string.
-----------------------------------------------------*/
displaynumbers_pos_(str,x,y,v1,v2,n,flag,z,alpha,dx3,dx4)
     double *dx3,*dx4;
     char str[];
     integer x[],y[],*n,*flag,*v1,*v2;
     double z[],alpha[];
{ integer i ;
  char buf[20];
  for (i=0 ; i< *n ; i++)
    { 
      sprintf(buf,ScilabGC_pos_.CurNumberDispFormat,z[i]);
      displaystring_pos_(buf,&(x[i]),&(y[i]),PI0,flag,PI0,PI0,&(alpha[i]),PD0,PD0,PD0) ;
    }
}

/*-------------------------------------------------------
\encadre{General routine for generating Postscript Code 
to deal with Vectors. The difficulty is that the size 
of vectors is limited by Postscript, so the routine 
must check size and cut into pieces big objects}
\begin{verbatim}
  clear (string) sizeobj [fvect[0],...,fvect[nobj]]
  (si flag=1)  [ vx[0] vy[0] vx[1] vy[1] ...... vx[sizev] vy[sizev]]
  (si flag=0)  [ vx[0] vx[1] ..... vx[sizev] ] dogrey 
\end{verbatim}
----------------------------------------------------------*/

/** Attention :: MAXSIZE doit etre divisible par 4  pour eviter des pbs **/
#define MAXSIZE 452
#define PERLINE 20
#define FORMATNUM "%d "

WriteGeneric_pos_(string,nobj,sizeobj,vx,vy,sizev,flag,fvect)
     integer nobj,sizeobj,vx[],vy[],sizev,flag,fvect[];
     char string[];
{   
  integer nobjpos,objbeg;
  objbeg= 0 ;
  /**-- si MAXSIZE/sizeobj vaut zero chaque objet est trop gros **/
  /** calcule le nombre d'object que l'on peut imprimer \`a la fois**/
  /** sans risquer un overflow dans un array postscript **/
  if (nobj ==0 || sizeobj ==0) return;
  nobjpos =Min( Max(1,MAXSIZE /sizeobj),nobj);
  while ( objbeg < nobj)
    {integer objres;
     objres= nobj-objbeg;
     WriteGeneric1_pos_(string,Min(nobjpos,objres),objbeg,sizeobj,vx,vy,flag,fvect);
     objbeg = objbeg+nobjpos;
   }
  
}

WriteGeneric1_pos_(string,nobjpos,objbeg,sizeobj,vx,vy,flag,fvect)
     integer nobjpos,sizeobj,vx[],vy[],objbeg,flag,fvect[];
     char string[];
{
  integer from,n,i;
  if (flag == 1) 
    {  from= (objbeg*sizeobj)/2;
       n= (nobjpos*sizeobj)/2;}
  else 
    {  from= (objbeg*sizeobj)/2;
       n= (nobjpos*sizeobj);}
  fprintf(file,"\n (%s) %d [",string,(int)Min(sizeobj,MAXSIZE));
  for ( i =objbeg  ; i < (nobjpos+objbeg) ; i++)
    fprintf(file," %d",(int)fvect[i]);
  fprintf(file,"]\n");
  /* Reste un probleme car si un unique objet doit etre dessine
     et qu'il est trop gros cet objet est decoupe en bout mais 
     il manque alors les raccords eventuels */
  Write2Vect_pos_(vx,vy,from,n,string,flag,fvect[objbeg]);
}

/*--------------------------------------------------
  [  perline*valeurs de vx et vy 
     ......
     .....
  ] string 
  [ 

  ] string 
  chaque zone entre [] ne doit pas contenir plus de 
  maxsize valeurs.
-------------------------------------------------------*/


Write2Vect_pos_(vx,vy,from,n,string,flag,fv)
     integer from,n,flag,fv;
     integer vx[],vy[];
     char string[];
{ integer i,j,k,co,nco;
  if ( flag == 1) nco=2*n;else nco=n;
  co = 1;
  i =0;
  while( i < n)
    {
      if ( i > 0) 
	fprintf(file,"\n (%s) %d [%d]\n",
		string,(int)Min(MAXSIZE,nco-(co-1)*MAXSIZE),(int)fv);
      co = co +1;
      j =0;
      fprintf(file,"[");
      while ( j < MAXSIZE && i <n )
	{
	  k=0;
	  while ( k < PERLINE && i < n && j < MAXSIZE)
	    {
	      fprintf(file,FORMATNUM,vx[i+from]);
	      if (flag == 1) 
		{ fprintf(file,FORMATNUM,vy[i+from]);
		  k=k+2;i=i+1;j=j+2;}
	      else 
		{k=k+1;i=i+1;j=j+1;}}
	  fprintf(file,"\n");
	}
      fprintf(file,"] dogrey ");
    }
}

/** Global variables to deal with fonts **/

#define FONTNUMBER 7
#define FONTMAXSIZE 6
#define SYMBOLNUMBER 10
integer FontsList_pos_[FONTNUMBER][FONTMAXSIZE];
struct FontInfo { integer ok;
		  char fname[20];} FontInfoTab_pos_[FONTNUMBER];

static char *size_pos_[] = { "08" ,"10","12","14","18","24"};
static int  isize_pos_[] = { 8 ,10,12,14,18,24};

/** To set the current font id of font and size **/

xsetfont_pos_(fontid,fontsize,v3,v4)
     integer *fontid , *fontsize,*v3,*v4 ;
{ integer i,fsiz;
  i = Min(FONTNUMBER-1,Max(*fontid,0));
  fsiz = Min(FONTMAXSIZE-1,Max(*fontsize,0));
  if ( FontInfoTab_pos_[i].ok !=1 )
    Scistring("\n Sorry This Font is Not available ");
  else 
   {
     ScilabGC_pos_.CurHardFont = i;
     ScilabGC_pos_.CurHardFontSize = fsiz;
     fprintf(file,"\n/%s findfont %d scalefont setfont",
	     FontInfoTab_pos_[i].fname,
	     isize_pos_[fsiz]*prec_fact);
   }
}

/** To get the values id and size of the current font **/

xgetfont_pos_(verbose,font,nargs)
     integer *verbose,*font,*nargs;
{
  *nargs=2;
  font[0]= ScilabGC_pos_.CurHardFont ;
  font[1] =ScilabGC_pos_.CurHardFontSize ;
  if (*verbose == 1) 
    {
      sciprint("\nFontId : %d ",	      ScilabGC_pos_.CurHardFont );
      sciprint("--> %s at size %s pts\r\n",
	     FontInfoTab_pos_[ScilabGC_pos_.CurHardFont].fname,
	     size_pos_[ScilabGC_pos_.CurHardFontSize]);
    }
}


/** To set the current mark : using the symbol font of adobe **/

xsetmark_pos_(number,size,v3,v4)
     integer *number ;
     integer *size  ,*v3,*v4 ;
{ 
  ScilabGC_pos_.CurHardSymb =
    Max(Min(SYMBOLNUMBER-1,*number),0);
  ScilabGC_pos_.CurHardSymbSize = 
    Max(Min(FONTMAXSIZE-1,*size),0);
;}

/** To get the current mark id **/

xgetmark_pos_(verbose,symb,narg)
     integer *verbose,*symb,*narg;
{
  *narg =2 ;
  symb[0] = ScilabGC_pos_.CurHardSymb ;
  symb[1] = ScilabGC_pos_.CurHardSymbSize ;
  if (*verbose == 1) 
  sciprint("\nMark : %d at size %d pts\r\n",
	  ScilabGC_pos_.CurHardSymb,
	  isize_pos_[ScilabGC_pos_.CurHardSymbSize]);
}

char symb_list_pos_[] = {
  /*
     0x2e : . alors que 0xb7 est un o plein trop gros 
     ., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle*/
  (char)0x2e,(char)0x2b,(char)0xb4,(char)0xc5,(char)0xa8,
  (char)0xe0,(char)0x44,(char)0xd1,(char)0xa7,(char)0x4f};

displaysymbols_pos_(str,n,vx,vy)
     char str[];
     integer *n,vx[],vy[];
{
  integer fvect[1];
  fvect[0] = 	  ScilabGC_pos_.CurPattern;
  if ( ScilabGC_pos_.CurVectorStyle !=  CoordModeOrigin)
    fprintf(file,"\n/absolu false def");
  fprintf(file,"\nHardMark 0 16#%x put",
      Char2Int( symb_list_pos_[ScilabGC_pos_.CurHardSymb]));
  WriteGeneric_pos_("drawpolymark",1L,(*n)*2,vx,vy,*n,1L,fvect);
  fprintf(file,"\n/absolu true def");
}



/*-------------------------------------------------------
\encadre{Check if a specified family of font exist in 
Postscript }
-------------------------------------------------------*/

loadfamily_pos_(name,j,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *name;
     integer *j,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  integer i ;
  for ( i = 0; i < FONTMAXSIZE ; i++)
    {
      FontsList_pos_[*j][i] = PosQueryFont_(name);
    }
  if  (FontsList_pos_[*j][0] == 0 )
	  sciprint("\n unknown font family : %s \r\n",name);
  else 
    {FontInfoTab_pos_[*j].ok = 1;
     strcpy(FontInfoTab_pos_[*j].fname,name) ;}
}

/*--------------------------------------------
\encadre{always answer ok. Must be Finished}
---------------------------------------------*/

int PosQueryFont_(name)
     char name[];
{ 
  return(1);
}


/*------------------------END--------------------*/
