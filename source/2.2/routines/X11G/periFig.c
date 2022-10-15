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
\section{A Fig Driver}
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
#ifdef THINK_C
#define M_PI	3.14159265358979323846
#else
#include <values.h>
#endif

#include "periFig.h"
#include "Math.h"

#define NUMCOLORS 17

#define Char2Int(x)   ( x & 0x000000ff )

/** Global variables to deal with fonts **/

#define FONTNUMBER 7
#define FONTMAXSIZE 6
#define SYMBOLNUMBER 10
integer FontsList_xfig_[FONTNUMBER][FONTMAXSIZE];
struct FontInfo { integer ok;
		  char fname[20];} FontInfoTab_xfig_[FONTNUMBER];
/** xfig code for our fonts **/
static integer  xfig_font[]= { 12,32,0,1,2,3,0};
static char *size_xfig_[] = { "08" ,"10","12","14","18","24"};
static integer  isize_xfig_[] = { 8,10,12,14,18,24};

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
}  ScilabGC_xfig_ ;


/*-----------------------------------------------------
\encadre{General routines}
-----------------------------------------------------*/

/** To select the graphic Window  **/

xselgraphic_xfig_(v1,v2,v3,v4,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
{}

/** End of graphic (close the file)  **/

xendgraphic_xfig_()
{
  if (file != stdout) fclose(file);
}

xend_xfig_(v1,v2,v3,v4,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
{
  if (file != stdout) fclose(file);
}


/** Clear the current graphic window     **/
/** In Fig : nothing      **/

clearwindow_xfig_(v1,v2,v3,v4,v5,v6,v7,dx1,dx2,dx3,dx4) 
     double *dx1,*dx2,*dx3,*dx4;
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
{
}

/** Flush out the X11-buffer  **/

viderbuff_xfig_(){}

/** To get the window size **/
/** The default fig box    **/
/** for line thickness etc \ldots **/
static integer prec_fact =16;

getwindowdim_xfig_(verbose,x,narg)
  integer *verbose,*x,*narg;
{     
  *narg = 2;
  x[0]= 600*prec_fact;
  x[1]= 424*prec_fact;
  if (*verbose == 1) 
    sciprint("\n CWindow dim :%d,%d\r\n",(int)x[0],(int)x[1]);
} 

/** To change the window dimensions : do Nothing in Postscript  **/

setwindowdim_xfig_(x,y,v3,v4)
     integer *x,*y,*v3,*v4;
{
}

/** to get the window upper-left pointeger coordinates return 0,0 **/

getwindowpos_xfig_(verbose,x,narg)
  integer *verbose,*x,*narg;
{
  *narg = 2;
  x[0]= x[1]=0;
  if (*verbose == 1) 
    sciprint("\n CWindow position :%d,%d\r\n",(int)x[0],(int)x[1]);
 }

/** to set the window upper-left pointeger position (Void) **/

setwindowpos_xfig_(x,y,v3,v4)
     integer *x,*y,*v3,*v4;
{
}


/** To generate a pause : Empty here **/

xpause_xfig_(str,sec_time,v3,v4,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *sec_time,*v3,*v4,*v5,*v6,*v7;
{}

/** Wait for mouse click in graphic window : Empty here **/

waitforclick_xfig_(str,ibutton,xx1,yy1,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *ibutton,*xx1,*yy1,*v5,*v6,*v7 ;
{ }

/** Wait for mouse click in any graphic window : Empty here **/
xclick_any_xfig_(str,ibutton,xx1,yy1,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *ibutton,*xx1,*yy1,*v5,*v6,*v7 ;
{ }

xgetmouse_xfig_(str,ibutton,xx1,yy1,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *ibutton,*xx1,*yy1 ,*v5,*v6,*v7;
{ }

/** Clear a rectangle **/

cleararea_xfig_(str,x,y,w,h,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *x,*y,*w,*h,*v6,*v7;
{
  fprintf(file,"# %d %d %d %d clearzone\n",(int)*x,(int)*y,(int)*w,(int)*h);
}

/*------------------------------------------------
\encadre{Functions to modify the graphic state}
-------------------------------------------------*/

/** Select a graphic Window : Empty for Postscript **/

setcurwin_xfig_(intnum,v2,v3,v4)
     integer *intnum,*v2,*v3,*v4;
{}

/** Get the id number of the Current Graphic Window **/

getcurwin_xfig_(verbose,intnum,narg)
     integer *verbose,*intnum,*narg;
{
  *narg =1 ;
  *intnum = ScilabGC_xfig_.CurWindow ;
  if (*verbose == 1) 
    Scistring("\nJust one graphic page at a time ");
}

/** Set a clip zone (rectangle ) **/

setclip_xfig_(x,y,w,h)
     integer *x,*y,*w,*h;
{
  ScilabGC_xfig_.ClipRegionSet = 1;
  ScilabGC_xfig_.CurClipRegion[0]= *x;
  ScilabGC_xfig_.CurClipRegion[1]= *y;
  ScilabGC_xfig_.CurClipRegion[2]= *w;
  ScilabGC_xfig_.CurClipRegion[3]= *h;
  fprintf(file,"# %d %d %d %d setclipzone\n",(int)*x,(int)*y,(int)*w,(int)*h);
}


/** unset clip zone **/

unsetclip_xfig_(v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{
  ScilabGC_xfig_.ClipRegionSet = 0;
  ScilabGC_xfig_.CurClipRegion[0]= -1;
  ScilabGC_xfig_.CurClipRegion[1]= -1;
  ScilabGC_xfig_.CurClipRegion[2]= 200000;
  ScilabGC_xfig_.CurClipRegion[3]= 200000;
  fprintf(file,"# %d %d %d %d setclipzone\n",-1,-1,200000,200000);
}

/** Get the boundaries of the current clip zone **/

getclip_xfig_(verbose,x,narg)
     integer *verbose,*x,*narg;
{
  x[0] = ScilabGC_xfig_.ClipRegionSet;
  if ( x[0] == 1)
    {
      *narg = 5;
      x[1] =ScilabGC_xfig_.CurClipRegion[0];
      x[2] =ScilabGC_xfig_.CurClipRegion[1];
      x[3] =ScilabGC_xfig_.CurClipRegion[2];
      x[4] =ScilabGC_xfig_.CurClipRegion[3];
    }
  else *narg = 1;
  if (*verbose == 1)
  if (ScilabGC_xfig_.ClipRegionSet == 1)
    sciprint("\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d\r\n",
	      ScilabGC_xfig_.CurClipRegion[0],
	      ScilabGC_xfig_.CurClipRegion[1],
	      ScilabGC_xfig_.CurClipRegion[2],
	      ScilabGC_xfig_.CurClipRegion[3]);
  else 
    Scistring("\nNo Clip Region");
}

/*----------------------------------------------------------
\encadre{For the drawing functions dealing with vectors of 
 points, the following routine is used to select the mode 
 absolute or relative }
 Absolute mode if *num==0, relative mode if *num != 0
------------------------------------------------------------*/

absourel_xfig_(num,v2,v3,v4)
     	integer *num,*v2,*v3,*v4;
{
  if (*num == 0 )
    ScilabGC_xfig_.CurVectorStyle =  CoordModeOrigin;
  else 
    ScilabGC_xfig_.CurVectorStyle =  CoordModePrevious ;
}

/** to get information on absolute or relative mode **/

getabsourel_xfig_(verbose,num,narg)
     	integer *verbose,*num,*narg;
{
  *narg = 1;
    *num = ScilabGC_xfig_.CurVectorStyle  ;
    if (*verbose == 1) 
  if (ScilabGC_xfig_.CurVectorStyle == CoordModeOrigin)
    Scistring("\nTrace Absolu");
  else 
    Scistring("\nTrace Relatif");
  }


/** The alu function for drawing : Works only with X11 **/
/** Not in Postscript **/

setalufunction_xfig_(string)
 char string[];
{     
  integer value;
  
  idfromname_xfig_(string,&value);
  if ( value != -1)
    {ScilabGC_xfig_.CurDrawFunction = value;
     fprintf(file,"# %d setalufunction\n",(int)value);
      }
}

/** All the possibilities : Read The X11 manual to get more informations **/

struct alinfo { 
  char *name;
  char id;
  char *info;} AluStruc_xfig_[] =
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

idfromname_xfig_(name1,num)
     char name1[];
     integer *num;
{integer i;
 *num = -1;
 for ( i =0 ; i < 16;i++)
   if (strcmp(AluStruc_xfig_[i].name,name1)== 0) 
     *num=AluStruc_xfig_[i].id;
 if (*num == -1 ) 
   {
     Scistring("\n Use the following keys :");
     for ( i=0 ; i < 16 ; i++)
       {
	 sciprint("\nkey %s ",AluStruc_xfig_[i].name);
	 sciprint("-> %s\r\n",AluStruc_xfig_[i].info);
       }
   }
}


setalufunction1_xfig_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{     
  integer value;
  value=AluStruc_xfig_[Min(16,Max(0,*num))].id;
  if ( value != -1)
    {
      ScilabGC_xfig_.CurDrawFunction = value;
      /* to be done */
    }
}

/** To get the value of the alufunction **/

getalufunction_xfig_(verbose,value,narg)
     integer *verbose , *value ,*narg;
{ 
  *narg =1 ;
  *value = ScilabGC_xfig_.CurDrawFunction ;
   if (*verbose ==1 ) 
     { 
       sciprint("\nThe Alufunction is %s",AluStruc_xfig_[*value].name);
       sciprint("-> <%s>\r\n", AluStruc_xfig_[*value].info);
     }
}

/** to set the thickness of lines :min is 1 is a possible value **/
/** give the thinest line **/

setthickness_xfig_(value,v2,v3,v4)
  integer *value,*v2,*v3,*v4 ;
{ 
  ScilabGC_xfig_.CurLineWidth =Max(1, *value);
  fprintf(file,"# %d Thickness\n",(int)Max(1L,*value));
}

/** to get the thicknes value **/

getthickness_xfig_(verbose,value,narg)
     integer *verbose,*value,*narg;
{
  *narg =1 ;
  *value = ScilabGC_xfig_.CurLineWidth ;
  if (*verbose ==1 ) 
    sciprint("\nLine Width:%d\r\n", ScilabGC_xfig_.CurLineWidth ) ;
}
     

#define GREYNUMBER 17

/* give the correct pattern for xfig 0=white-> 20=black 
   from our pattern coding 0=black    ScilabGC_xfig_.IDWhitePattern=white */

#define AREAF(x) Max(0,Min(20, 20 - (20*10*x)/(ScilabGC_xfig_.IDWhitePattern*10)))


/*-------------------------------------------------
\encadre{To set grey level for filing areas.
  from black (*num =0 ) to white 
  you must use the get function to get the id of 
  the white pattern }
----------------------------------------------------*/

setpattern_xfig_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{ integer i ; 
  if (  ScilabGC_xfig_.CurColorStatus ==1) 
    {
      i= Max(0,Min(*num,NUMCOLORS-1));
      ScilabGC_xfig_.CurColor = i ;
      set_c_xfig_(i);
    }
  else 
    {
      i= Max(0,Min(*num,GREYNUMBER-1));
      ScilabGC_xfig_.CurPattern = i;
      if (i ==0)
	fprintf(file,"# fillsolid\n");
      else 
	fprintf(file,"# %d Setgray\n",(int)i);
    }
}

/** To get the id of the current pattern  **/

getpattern_xfig_(verbose,num,narg)
     integer *num,*verbose,*narg;
{ 
  *narg=1;
  if ( ScilabGC_xfig_.CurColorStatus ==1) 
    {
      *num = ScilabGC_xfig_.CurColor ;
      if (*verbose == 1) 
	sciprint("\n Color : %d\r\n",
		 ScilabGC_xfig_.CurPattern);
    }
  else 
    {
      *num = ScilabGC_xfig_.CurPattern ;
      if (*verbose == 1) 
	sciprint("\n Pattern : %d\r\n",
		 ScilabGC_xfig_.CurPattern);
    }
}

/** To set the current font id of font and size **/

xsetfont_xfig_(fontid,fontsize,v3,v4)
     integer *fontid , *fontsize,*v3,*v4 ;
{ integer i,fsiz;
  i = Min(FONTNUMBER-1,Max(*fontid,0));
  fsiz = Min(FONTMAXSIZE-1,Max(*fontsize,0));
  if ( FontInfoTab_xfig_[i].ok !=1 )
    Scistring("\n Sorry This Font is Not available\n");
  else 
   {
     ScilabGC_xfig_.CurHardFont = i;
     ScilabGC_xfig_.CurHardFontSize = fsiz;
     fprintf(file,"#/%s findfont %d scalefont setfont\n",
     	     FontInfoTab_xfig_[i].fname,
	     (int)isize_xfig_[fsiz]*prec_fact);
   }
}

/** To get the values id and size of the current font **/

xgetfont_xfig_(verbose,font,nargs)
     integer *verbose,*font,*nargs;
{
  *nargs=2;
  font[0]= ScilabGC_xfig_.CurHardFont ;
  font[1] =ScilabGC_xfig_.CurHardFontSize ;
  if (*verbose == 1) 
    {
      sciprint("\nFontId : %d ",ScilabGC_xfig_.CurHardFont );
      sciprint("--> %s at size",
	     FontInfoTab_xfig_[ScilabGC_xfig_.CurHardFont].fname);
      sciprint("%s pts\r\n",size_xfig_[ScilabGC_xfig_.CurHardFontSize]);
    }
}

/** To set dash-style : **/
/**  use a table of dashes and set default dashes to **/
/**  one of the possible value. value pointeger **/
/**  to a strictly positive integer **/

static integer DashTab_fig[6][4] = {
  {2,5,2,5}, {5,2,5,2},  {5,3,2,3}, {8,3,2,3},
  {11,3,2,3}, {11,3,5,3}};


setdash_xfig_(value,v2,v3,v4)
     integer *value,*v2,*v3,*v4;
{
  static integer maxdash = 6, l2=4,l3 ;
  if ( ScilabGC_xfig_.CurColorStatus ==1) 
    {
      int i;
      i= Max(0,Min(*value,NUMCOLORS-1));
      ScilabGC_xfig_.CurColor =i;
      set_c_xfig_(i);
    }
  else
    {
      l3 = Min(maxdash-1,*value-1);
      setdashstyle_fig_(value,DashTab_fig[Max(0,l3)],&l2);
      ScilabGC_xfig_.CurDashStyle= l3 + 1 ;
    }
}

/** To change The Pos-default dash style **/
/** if *value == 0, use a solid line, if *value != 0 **/
/** the dash style is specified by the xx vector of n values **/
/** xx[3]={5,3,7} and *n == 3 means :  5white 3 void 7 white \ldots **/
  
setdashstyle_fig_(value,xx,n)
     integer *value,xx[],*n;
{
  integer i ;
  if ( *value == 0) fprintf(file,"#[] 0 setdash\n");
  else 
    {
      fprintf(file,"#[");
      for (i=0;i<*n;i++)
	fprintf(file,"%d ",(int)xx[i]*prec_fact);
      fprintf(file,"] 0 setdash\n");
    }
}

/** to get the current dash-style **/

getdash_xfig_(verbose,value,narg)
     integer *verbose,*value,*narg;
{integer i ;
 *narg =1 ;
 if ( ScilabGC_xfig_.CurColorStatus ==1) 
   {
     *value=ScilabGC_xfig_.CurColor;
     if (*verbose == 1) sciprint("Color %d",(int)*value);
     return;
   }
 *value=ScilabGC_xfig_.CurDashStyle;
 if ( *value == 0) 
   { if (*verbose == 1) Scistring("\nLine style = Line Solid");}
 else 
   {
     value[1]=4;
     *narg = value[1]+2;
     for ( i =0 ; i < value[1]; i++) value[i+2]=DashTab_fig[*value-1][i];
     if (*verbose ==1 ) 
       {
	 sciprint("\nDash Style %d:<",(int) *value);
	 for ( i =0 ; i < value[1]; i++)
	   sciprint("%d ",(int)value[i+2]);
	 Scistring(">\n");
       }
   }
}


/** To set the current mark : using the symbol font of adobe **/

setcursymbol_xfig_(number,size,v3,v4)
     integer *number ;
     integer *size ,*v3,*v4  ;
{ 
  ScilabGC_xfig_.CurHardSymb =
    Max(Min(SYMBOLNUMBER-1,*number),0);
  ScilabGC_xfig_.CurHardSymbSize = 
    Max(Min(FONTMAXSIZE-1,*size),0);
;}

/** To get the current mark id **/

getcursymbol_xfig_(verbose,symb,narg)
     integer *verbose,*symb,*narg;
{
  *narg =2 ;
  symb[0] = ScilabGC_xfig_.CurHardSymb ;
  symb[1] = ScilabGC_xfig_.CurHardSymbSize ;
  if (*verbose == 1) 
  {
    sciprint("\nMark : %d",ScilabGC_xfig_.CurHardSymb);
    sciprint("at size %s pts\r\n",
	  size_xfig_[ScilabGC_xfig_.CurHardSymbSize]);
  }
}

/** To get the id of the white pattern **/

getwhite_xfig_(verbose,num,narg)
     integer *num,*verbose,*narg;
{
  *num = ScilabGC_xfig_.IDWhitePattern ;
  if (*verbose==1) 
    sciprint("\n Id of White Pattern %d \r\n",(int)*num);
  *narg=1;
}


usecolor_xfig_(num,v2,v3,v4)
     integer *num,*v2,*v3,*v4;
{
  integer i;
  if (  ScilabGC_xfig_.CurColorStatus != *num)
    {
      if (ScilabGC_xfig_.CurColorStatus == 1) 
	{
	  /* je passe de Couleur a n&b */
	  /* remise des couleurs a vide */
	  ScilabGC_xfig_.CurColorStatus = 1;
	  setpattern_xfig_((i=0,&i),PI0,PI0,PI0);
	  /* passage en n&b */
	  ScilabGC_xfig_.CurColorStatus = 0;
	  i= ScilabGC_xfig_.CurPattern;
	  setpattern_xfig_(&i,PI0,PI0,PI0);
	  i= ScilabGC_xfig_.CurDashStyle;
	  setdash_xfig_(&i,PI0,PI0,PI0);
	}
      else 
	{
	  /* je passe en couleur */
	  /* remise a zero des patterns et dash */
	  /* remise des couleurs a vide */
	  ScilabGC_xfig_.CurColorStatus = 0;
	  setpattern_xfig_((i=0,&i),PI0,PI0,PI0);
	  setdash_xfig_((i=0,&i),PI0,PI0,PI0);
	  /* passage en couleur  */
	  ScilabGC_xfig_.CurColorStatus = 1;
	  i= ScilabGC_xfig_.CurColor;
	  setpattern_xfig_(&i,PI0,PI0,PI0);
	}
    }
}

set_c_xfig_(i)
     integer i;
{
  integer j;
  j=Max(Min(i,NUMCOLORS-1),0);
  ScilabGC_xfig_.CurColor=j;
  fprintf(file,"\n# %d Setcolor\n",(int)i);
}


/*--------------------------------------------------------
\encadre{general routines accessing the  set<> or get<>
 routines } 
-------------------------------------------------------*/

int InitScilabGC_xfig_();


sempty_xfig_(verbose,v2,v3,v4)
     integer *verbose,*v2,*v3,*v4;
{
  if ( *verbose ==1 ) Scistring("\n No operation ");
}

gempty_xfig_(verbose,v2,v3)
     integer *verbose,*v2,*v3;
{
  if ( *verbose ==1 ) Scistring("\n No operation ");
}



#define NUMSETFONC 18

struct bgc { char *name ;
	     int  (*setfonc )() ;
	     int  (*getfonc )() ;}
  ScilabGCTab_xfig_[] = {
   "alufunction",setalufunction1_xfig_,getalufunction_xfig_,
   "clipoff",unsetclip_xfig_,getclip_xfig_,
   "clipping",setclip_xfig_,getclip_xfig_,
   "dashes",setdash_xfig_,getdash_xfig_,
   "default",InitScilabGC_xfig_, gempty_xfig_,
   "font",xsetfont_xfig_,xgetfont_xfig_,
   "line mode",absourel_xfig_,getabsourel_xfig_,
   "mark",setcursymbol_xfig_,getcursymbol_xfig_,
   "pattern",setpattern_xfig_,getpattern_xfig_,
   "pixmap",sempty_xfig_,gempty_xfig_,
   "thickness",setthickness_xfig_,getthickness_xfig_,
   "use color",usecolor_xfig_,gempty_xfig_,
   "wdim",setwindowdim_xfig_,getwindowdim_xfig_,
   "white",sempty_xfig_,getwhite_xfig_,
   "window",setcurwin_xfig_,getcurwin_xfig_,
   "wpos",setwindowpos_xfig_,getwindowpos_xfig_,
   "wshow",sempty_xfig_,gempty_xfig_,
   "wwpc",sempty_xfig_,gempty_xfig_
 };



#ifdef linteger 

/* pour forcer linteger a verifier ca */

static
test(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     integer flag ;
     integer  *verbose,*x1,*x2,*x3,*x4,*x5;
{ 
  setalufunction1_xfig_(x1,x2,x3,x4);getalufunction_xfig_(verbose,x1,x2);
  setclip_xfig_(x1,x2,x3,x4);getclip_xfig_(verbose,x1,x2);
  setdash_xfig_(x1,x2,x3,x4);getdash_xfig_(verbose,x1,x2);
  InitScilabGC_xfig_(x1,x2,x3,x4); gempty_xfig_(verbose,x1,x2);
  xsetfont_xfig_(x1,x2,x3,x4);xgetfont_xfig_(verbose,x1,x2);
  absourel_xfig_(x1,x2,x3,x4);getabsourel_xfig_(verbose,x1,x2);
  setcursymbol_xfig_(x1,x2,x3,x4);getcursymbol_xfig_(verbose,x1,x2);
  setpattern_xfig_(x1,x2,x3,x4);getpattern_xfig_(verbose,x1,x2);
  setthickness_xfig_(x1,x2,x3,x4);getthickness_xfig_(verbose,x1,x2);
  usecolor_xfig_(x1,x2,x3,x4);gempty_xfig_(verbose,x1,x2);
  setwindowdim_xfig_(x1,x2,x3,x4);getwindowdim_xfig_(verbose,x1,x2);
  sempty_xfig_(x1,x2,x3,x4);getwhite_xfig_(verbose,x1,x2);
  setcurwin_xfig_(x1,x2,x3,x4);getcurwin_xfig_(verbose,x1,x2);
  setwindowpos_xfig_(x1,x2,x3,x4);getwindowpos_xfig(verbose,x1,x2);
  
}

#endif 


scilabgcget_xfig_(str,verbose,x1,x2,x3,x4,x5,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     integer *verbose,*x1,*x2,*x3,*x4,*x5;
     char str[];
{
 ScilabGCGetorSet_xfig_(str,1L,verbose,x1,x2,x3,x4,x5);
}

scilabgcset_xfig_(str,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     integer *x2,*x3,*x4,*x5,*x6,*x7;
     char str[];
{
 integer verbose ;
 verbose = 0 ;
 ScilabGCGetorSet_xfig_(str,0L,&verbose,x2,x3,x4,x5,x6);
}

ScilabGCGetorSet_xfig_(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     integer flag ;
     integer  *verbose,*x1,*x2,*x3,*x4,*x5;
{ integer i ;
  for (i=0; i < NUMSETFONC ; i++)
     {
       integer j;
       j = strcmp(str,ScilabGCTab_xfig_[i].name);
       if ( j == 0 ) 
	 { if (*verbose == 1)
	     sciprint("\nGettting Info on %s\r\n",str);
	   if (flag == 1)
	     (ScilabGCTab_xfig_[i].getfonc)(verbose,x1,x2);
	   else 
	     (ScilabGCTab_xfig_[i].setfonc)(x1,x2,x3,x4);
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
displaystring_xfig_(string,x,y,v1,flag,v6,v7,angle,dv2,dv3,dv4)
     integer *x,*y ,*flag;
     double *angle;
     char string[] ;
     integer *v1,*v6,*v7;
     double *dv2,*dv3,*dv4;
{     integer rect[4], font=-1,font_flag=2;
      boundingbox_xfig_(string,x,y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      if (string[0]== '$') 
	{
	  font=-1;
	  font_flag=2;
	}
      else 
	{
	  font =  xfig_font[ScilabGC_xfig_.CurHardFont],
	  font_flag= 4; 
	};
      fprintf(file,"4 0 %d 0 0 %d %d %5.2f %d %5.2f %5.2f %d %d %s\\001\n",
	      ScilabGC_xfig_.CurColor,
	      (int)font,
	      (int)isize_xfig_[ScilabGC_xfig_.CurHardFontSize],/**prec_fact,*/
	      (M_PI/180.0)*(*angle),
	      (int)font_flag,
	      (double) rect[3],
	      (double) rect[2],
	      (int)*x,
	      (int)*y,
	      string);
      if ( *flag == 1) 
	{
	  rect[0]=rect[0]-4;rect[2]=rect[2]+6;
	  drawrectangle_xfig_(string,rect,rect+1,rect+2,rect+3,PI0,PI0,PD0,PD0,PD0,PD0);
	}
}

integer bsize_xfig_[6][4]= {{ 0,-7,4.63,9  },
		{ 0,-9,5.74,12 },
		{ 0,-11,6.74,14},
		{ 0,-12,7.79,15},
		{0, -15,9.72,19 },
		{0,-20,13.41,26}};

/** To get the bounding rectangle of a string **/

boundingbox_xfig_(string,x,y,rect,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     integer *x,*y,*rect,*v5,*v6,*v7;
     char string[];
{integer verbose,nargs,font[2];
 verbose=0;
 xgetfont_xfig_(&verbose,font,&nargs);
 rect[0]= *x+bsize_xfig_[font[1]][0]*((double) prec_fact);
 rect[1]= *y+bsize_xfig_[font[1]][1]*((double) prec_fact);
 rect[2]= bsize_xfig_[font[1]][2]*(int)strlen(string)*((double) prec_fact);
 rect[3]= bsize_xfig_[font[1]][3]*((double) prec_fact);
}

/** Draw a single line in current style **/
/** Unused in fact **/ 

drawline_xfig_(x1,yy1,x2,y2)
    integer *x1, *x2, *yy1, *y2 ;
  {
    fprintf(file,"# %d %d %d %d L\n",(int)*x1,(int)*yy1,(int)*x2,(int)*y2);
  }

/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/
/**   if iflag == 1 style[i] gives the style for each segment
      if iflag == 0 (if *style >0 ) it   gives the style for all the  segment 
                    (if *style <0 ) The default style is used for all the  segment 
**/

drawsegments_xfig_(str,vx,vy,n,style,iflag,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *n,vx[],vy[],*style,*iflag,*v7;
{
  integer NDvalue,i;
  integer verbose=0,Dnarg,Dvalue[10];
  /* store the current values */
  getdash_xfig_(&verbose,Dvalue,&Dnarg);
  for ( i =0 ; i < *n/2 ; i++)
    {
      if ( (int) *iflag == 0) 
	NDvalue=(*style < 0) ? (integer) ScilabGC_xfig_.CurDashStyle : *style;
      else
	NDvalue=(int) style[i];
      setdash_xfig_(&NDvalue,PI0,PI0,PI0);
      fprintf(file,"# Object : %d %s -<%d>- \n", (int)i,str, ScilabGC_xfig_.CurPattern);
      fprintf(file,"2 1 %d%d %d %d 0 0 -1 %d.000 0 0 0 0 0 2\n",
	      ScilabGC_xfig_.CurDashStyle,
	      ScilabGC_xfig_.CurLineWidth*prec_fact/16,
	      ScilabGC_xfig_.CurColor,
	      ScilabGC_xfig_.CurColor,
	      8*ScilabGC_xfig_.CurDashStyle
	      );
      fprintf(file," %d %d %d %d \n",
	      (int)vx[2*i], (int)vy[2*i], (int)vx[2*i+1], (int)vy[2*i+1]);
    }
  setdash_xfig_( Dvalue,PI0,PI0,PI0);
}

/** Draw a set of arrows 
  if iflag == 1 style[i] gives the style for each arrow 
  if iflag == 0 *style   gives the style for all the arrows
**/

drawarrows_xfig_(str,vx,vy,n,as,style,iflag,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     integer *as;
     char str[];
     integer *n,vx[],vy[],*style,*iflag;
{
  int i;
  integer verbose=0,Dnarg,Dvalue[10],NDvalue;
  /* store the current values */
  getdash_xfig_(&verbose,Dvalue,&Dnarg);
  for ( i = 0 ; i < *n/2 ; i++)
    {
      if ( (int) *iflag == 0) 
	NDvalue=(*style < 0) ? (integer) ScilabGC_xfig_.CurDashStyle : *style;
      else
	NDvalue=(int) style[i];
      setdash_xfig_(&NDvalue,PI0,PI0,PI0);
      fprintf(file,"# Object : %d %s -<%d>-\n", (int)i,str, ScilabGC_xfig_.CurPattern);
      fprintf(file,"2 1 %d %d %d %d 0 0 -1 %d.000 0 0 0 1 0 2\n",
	      ScilabGC_xfig_.CurDashStyle,
	      ScilabGC_xfig_.CurLineWidth*prec_fact/16,
	      ScilabGC_xfig_.CurColor,
	      ScilabGC_xfig_.CurColor,
	      8*ScilabGC_xfig_.CurDashStyle
	      );
      fprintf(file,"    0 0 %d %d %d\n",
	      (int)(1*prec_fact/16), (int)(3*prec_fact), (int) (6*prec_fact));
      fprintf(file," %d %d %d %d \n",
	      (int)vx[2*i], (int)vy[2*i], (int)vx[2*i+1], (int)vy[2*i+1]);
    }
  setdash_xfig_( Dvalue,PI0,PI0,PI0);
}

/** Draw one rectangle **/

drawrectangle_xfig_(str,x,y,width,height,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer  *x, *y, *width, *height,*v6,*v7;
  { 
  integer i = 1;
  integer fvect[1] ;
  integer vects[4];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;
  fvect[0] = ScilabGC_xfig_.IDWhitePattern +1  ;
  drawrectangles_xfig_(str,vects,fvect,&i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  }

/** Draw a filled rectangle **/

drawfilledrect_xfig_(str,x,y,width,height,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer  *x, *y, *width, *height,*v6,*v7;
{ 
  integer i = 1;
  integer fvect[1] ;
  integer vects[4];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height ; 
  fvect[0] = ScilabGC_xfig_.CurPattern ;
  drawrectangles_xfig_(str,vects,fvect,&i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);    
}

/** Draw or fill a set of rectangle **/
/** rectangles are defined by (vect[i],vect[i+1],vect[i+2],vect[i+3]) **/
/** for i=0 step 4 **/
/** (*n) : number of rectangles **/
/** fillvect[*n] : specify the action <?> **/
/** if (fillvect[i] >= ScilabGC_.IDWhitePattern+1 then draw **/
/** else fille with id fillvect[i] **/

drawrectangles_xfig_(str,vects,fillvect,n,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *vects,*fillvect,*n,*v5,*v6,*v7;
{
  integer cpat,verb,num;
  verb=0;
  getpattern_xfig_(&verb,&cpat,&num);
  WriteGeneric_xfig_("drawbox",*n,4L,vects,vects,4*(*n),0L,fillvect);
  setpattern_xfig_(&(cpat),PI0,PI0,PI0);
}


/** Draw or fill a set of ellipsis or part of ellipsis **/
/** Each is defined by 6-parameters, **/
/** fillvect[*n] : specify the action <?> **/
/** caution angle=degreangle*64          **/

fillarcs_xfig_(str,vects,fillvect,n,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *vects,*fillvect,*n,*v5,*v6,*v7;
{
  integer cpat,verb,num;
  verb=0;
  getpattern_xfig_(&verb,&cpat,&num);
  WriteGeneric_xfig_("drawarc",*n,6L,vects,vects,6*(*n),0L,fillvect);
  setpattern_xfig_(&(cpat),PI0,PI0,PI0);
}


/** Draw a set of ellipsis or part of ellipsis **/
/** Each is defined by 6-parameters, **/
/** ellipsis i is specified by $vect[6*i+k]_{k=0,5}= x,y,width,height,angle1,angle2$ **/
/** <x,y,width,height> is the bounding box **/
/** angle1,angle2 specifies the portion of the ellipsis **/
/** caution : angle=degreangle*64          **/

drawarcs_xfig_(str,vects,style,n,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *vects,*style,*n,*v5,*v6,*v7;
	double *dv1,*dv2,*dv3,*dv4;
{
  integer verbose=0,Dnarg,Dvalue[10];
  /* store the current values */
  getdash_xfig_(&verbose,Dvalue,&Dnarg);
  WriteGeneric_xfig_("Rdrawarc",*n,6L,vects,vects,6*(*n),0L,style);
  setdash_xfig_( Dvalue,PI0,PI0,PI0);
}


/** Draw a single ellipsis or part of it **/
/** caution angle=degreAngle*64          **/

drawarc_xfig_(str,x,y,width,height,angle1,angle2,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
    integer *angle1,*angle2, *x, *y, *width, *height;
 { 
  integer i =1;
  integer fvect[1] ;
  integer vects[6];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;vects[4]= *angle1;vects[5]= *angle2;
  fvect[0] = ScilabGC_xfig_.IDWhitePattern  +1;
  fillarcs_xfig_(str,vects,fvect,&i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
}

/** Fill a single elipsis or part of it **/
/** with current pattern **/

drawfilledarc_xfig_(str,x,y,width,height,angle1,angle2,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *angle1,*angle2, *x, *y, *width, *height;
 { 
  integer i =1;
  integer fvect[1] ;
  integer vects[6];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;vects[4]= *angle1;vects[5]= *angle2;
  fvect[0] = ScilabGC_xfig_.CurPattern ;
  fillarcs_xfig_(str,vects,fvect,&i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
 }

/** Draw a set of  current mark centred at points defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_xfig_(str,n, vx, vy,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *n ; 
     integer vx[], vy[],*v5,*v6,*v7;
{ integer keepid,keepsize,  i=1, sz=ScilabGC_xfig_.CurHardSymbSize;
  keepid =  ScilabGC_xfig_.CurHardFont;
  keepsize= ScilabGC_xfig_.CurHardFontSize;
  xsetfont_xfig_(&i,&sz,PI0,PI0);
  displaysymbols_xfig_(str,n,vx,vy);
  xsetfont_xfig_(&keepid,&keepsize,PI0,PI0);
}

char symb_list_xfig_[] = {
  /*
     0x2e : . alors que 0xb7 est un o plein trop gros 
     ., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle*/
  (char)0x2e,(char)0x2b,(char)0xb4,(char)0xc5,(char)0xa8,
  (char)0xe0,(char)0x44,(char)0xd1,(char)0xa7,(char)0x4f};

displaysymbols_xfig_(str,n,vx,vy)
     char str[];
     integer *n,vx[],vy[];
{
  integer fvect[1];
  fvect[0] = 	  ScilabGC_xfig_.CurPattern;
  if ( ScilabGC_xfig_.CurVectorStyle !=  CoordModeOrigin)
    fprintf(file,"#/absolu false def\n");
  fprintf(file,"#HardMark 0 16#%x put\n",
      Char2Int( symb_list_xfig_[ScilabGC_xfig_.CurHardSymb]));
  WriteGeneric_xfig_("drawpolymark",1L,(*n)*2,vx,vy,*n,1L,fvect);
  fprintf(file,"#/absolu true def\n");
}

/** Draw a set of *n polylines (each of which have (*p) points) **/
/** with lines or marks **/
/** drawvect[i] >= use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

morlpolylines_xfig_(str,vectsx,vectsy,drawvect,n,p,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *vectsx,*vectsy,*drawvect,*n,*p,*v7;
{ integer verbose ,symb[2],Mnarg,Dnarg,Dvalue[10],NDvalue,i,close;
  verbose =0 ;
  /* store the current values */
  getcursymbol_xfig_(&verbose,symb,&Mnarg);
  getdash_xfig_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i< *n ; i++)
    {
      if (drawvect[i] >= 0)
	{ /** on utilise la marque de numero associ\'ee **/
	  setcursymbol_xfig_(drawvect+i,symb+1,PI0,PI0);
	  drawpolymark_xfig_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
	}
      else
	{/** on utilise un style pointill\'e  **/
	  NDvalue = - drawvect[i] -1;
	  setdash_xfig_(&NDvalue,PI0,PI0,PI0);
	  close = 0;
	  drawpolyline_xfig_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,&close,PI0,PI0,PD0,PD0,PD0,PD0);
	}
    }
/** back to default values **/
  setdash_xfig_(Dvalue,PI0,PI0,PI0);
  setcursymbol_xfig_(symb,symb+1,PI0,PI0);
}

/** fill a set of polygons each of which is defined by **/
/** (*p) points (*n) is the number of polygons **/
/** the polygon is closed by the routine **/
/** if fillvect <= whiteid-pattern the coresponding pattern is used  **/
/** if fillvect == whiteid-pattern +1 -> draw the boundaries  **/
/** if fillvect >= whiteid-pattern +2 -> fill with white and draw boundaries **/
/** fillvect[*n] :         **/

drawpolylines_xfig_(str,vectsx,vectsy,fillvect,n,p,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *vectsx,*vectsy,*fillvect,*n,*p,*v7;
{
  integer cpat,verb,num;
  verb=0;
  if ( ScilabGC_xfig_.CurVectorStyle !=  CoordModeOrigin)
    fprintf(file,"#/absolu false def\n");
  getpattern_xfig_(&verb,&cpat,&num);
  WriteGeneric_xfig_("drawpoly",*n,(*p)*2,vectsx,vectsy,(*p)*(*n),1L,
			fillvect);
  setpattern_xfig_(&(cpat),PI0,PI0,PI0);
  fprintf(file,"#/absolu true def\n");
}

/** Only draw one polygon with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/

drawpolyline_xfig_(str,n, vx, vy,closeflag,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *n,*closeflag;
     integer vx[], vy[],*v6,*v7;
{ integer i =1;
  integer fvect[1] ;
  fvect[0] = ScilabGC_xfig_.IDWhitePattern  +1;
  if (*closeflag == 1 )
    fprintf(file,"#/closeflag true def\n");
  else 
    fprintf(file,"#/closeflag false def\n");
  drawpolylines_xfig_(str,vx,vy,fvect,&i,n,PI0,PD0,PD0,PD0,PD0);
}

/** Fill the polygon **/

fillarea_xfig_(str,n, vx, vy,closeareaflag,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char str[];
     integer *n,*closeareaflag;
     integer vx[], vy[],*v6,*v7;
{
  integer i =1;
  integer fvect[1] ;
  fvect[0] = ScilabGC_xfig_.CurPattern ;
  drawpolylines_xfig_(str,vx,vy,fvect,&i,n,PI0,PD0,PD0,PD0,PD0);
}


 
/*-----------------------------------------------------
\encadre{Routine for initialisation}
------------------------------------------------------*/


initgraphic_xfig_(string,v2,v3,v4,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char string[];
     integer *v2,*v3,*v4,*v5,*v6,*v7;
{ 
  char string1[50];
  static integer EntryCounter = 0;
  integer fnum;
  if (EntryCounter >= 1) xendgraphic_xfig_();
  strcpy(string1,string);
  file=fopen(string1,"w");
  if (file == 0) 
    {
      sciprint("Can't open file %s, I'll use stdout\r\n",string1);
      file =stdout;
    }
  if (EntryCounter == 0)
    { 
      fnum=0;      loadfamily_xfig_("Courier",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 
      fnum=1;      loadfamily_xfig_("Symbol",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 
      fnum=2;      loadfamily_xfig_("Times-Roman",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      fnum=3;      loadfamily_xfig_("Times-Italic",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 
      fnum=4;      loadfamily_xfig_("Times-Bold",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      fnum=5;      loadfamily_xfig_("Times-BoldItalic",&fnum,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0); 

    }
  FileInit_xfig_(file);
  ScilabGC_xfig_.CurWindow =EntryCounter;
  EntryCounter =EntryCounter +1;
}

FileInit_xfig_(filen)
     FILE *filen;
{
  integer x[2],verbose,narg;
  verbose = 0; 
  getwindowdim_xfig_(&verbose,x,&narg);
  fprintf(filen,"#FIG 3.0\nPortrait\nCenter\nInches\n1200 2\n");
  fprintf(filen,"2 2 0 0 -1 -1 0 0 -1 0.000 0 0 0 0 0 5\n");
  fprintf(filen," %d %d %d %d %d %d %d %d %d %d \n",
	  0,0,(int)x[0],0,(int)x[0],(int)x[1],0,(int)x[1],0,0);
  InitScilabGC_xfig_(PI0,PI0,PI0,PI0)	;
}

/*--------------------------------------------------------
\encadre{Initialisation of the graphic context. Used also 
to come back to the default graphic state}
---------------------------------------------------------*/

InitScilabGC_xfig_(v1,v2,v3,v4)
     integer *v1,*v2,*v3,*v4;
{ integer i,j,k[2],col;
  ScilabGC_xfig_.IDWhitePattern = GREYNUMBER-1; /** bug ?? **/
  ScilabGC_xfig_.CurLineWidth=1 ;
  ScilabGC_xfig_.CurColor=0 ;
  i=0;
  setthickness_xfig_(&i,PI0,PI0,PI0);
  setalufunction_xfig_("GXcopy");
  /** retirer le clipping **/
  i=j= -1;
  unsetclip_xfig_(PI0,PI0,PI0,PI0);
  i=0;setdash_xfig_(&i,PI0,PI0,PI0);
  i=2;j=1;
  xsetfont_xfig_(&i,&j,PI0,PI0);
  i=j=0;
  setcursymbol_xfig_(&i,&j,PI0,PI0);
  /** trac\'e absolu **/
  ScilabGC_xfig_.CurVectorStyle = CoordModeOrigin ;


  /* initialisation des pattern dash par defaut en n&b */
  ScilabGC_xfig_.CurColorStatus =0;
  setpattern_xfig_((i=0,&i),PI0,PI0,PI0);
  setdash_xfig_((i=0,&i),PI0,PI0,PI0);
  /* initialisation de la couleur par defaut */ 
  ScilabGC_xfig_.CurColorStatus = 1 ;
  setpattern_xfig_((i=0,&i),PI0,PI0,PI0);
  /* Choix du mode par defaut (decide dans initgraphic_ */
  getcolordef(&col);
  usecolor_xfig_(&col,PI0,PI0,PI0);
  strcpy(ScilabGC_xfig_.CurNumberDispFormat,"%-5.2g");
}

/*-------------------------------------------------------
\encadre{Check if a specified family of font exist in 
Postscript }
-------------------------------------------------------*/

loadfamily_xfig_(name,j,v3,v4,v5,v6,v7,dx1,dx2,dx3,dx4)
     double *dx1,*dx2,*dx3,*dx4;
     char *name;
     integer *j,*v3,*v4,*v5,*v6,*v7;
{ 
  integer i ;
  for ( i = 0; i < FONTMAXSIZE ; i++)
    {
      FontsList_xfig_[*j][i] = FigQueryFont_(name);
    }
  if  (FontsList_xfig_[*j][0] == 0 )
	  sciprint("\n unknown font family : %s\r\n",name);
  else 
    {FontInfoTab_xfig_[*j].ok = 1;
     strcpy(FontInfoTab_xfig_[*j].fname,name) ;}
}

/*--------------------------------------------
\encadre{always answer ok. Must be Finished}
---------------------------------------------*/

int FigQueryFont_(name)
     char name[];
{ return(1);}


/*------------------------------------------------------
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

drawaxis_xfig_(str,alpha,nsteps,v2,initpoint,v6,v7,size,dx2,dx3,dx4)
     double *dx2,*dx3,*dx4;
     char str[];
     integer *alpha,*nsteps,*initpoint,*v2,*v6,*v7;
     double *size;
{ integer i;
  double xi,yi,xf,yf;
  double cosal,sinal;
  fprintf(file,"# Begin Axis \n");
  if ( *alpha == 90 )
    {cosal = 0.0 ; sinal =1.0 ;}
  else 
   {
     if ( *alpha == -90 )
       {cosal = 0.0 ; sinal = -1.0 ;}
     else 
       {
	 cosal= cos( M_PI * (*alpha)/180.0);
	 sinal= sin( M_PI * (*alpha)/180.0);
       }
   }
  for (i=0; i <= nsteps[0]*nsteps[1]; i++)
    { xi = initpoint[0]+i*size[0]*cosal;
      yi = initpoint[1]+i*size[0]*sinal;
      xf = xi - ( size[1]*sinal);
      yf = yi + ( size[1]*cosal);
      fprintf(file,"2 1 0 %d %d %d 0 0 -1 0.000 0 0 0 0 0 2\n",
	      ScilabGC_xfig_.CurLineWidth*prec_fact/16,
	      ScilabGC_xfig_.CurColor,
	      ScilabGC_xfig_.CurColor
	      );
      fprintf(file," %d %d %d %d \n",(int)xi, (int)yi,  (int)  xf, (int)yf);
    }
  for (i=0; i <= nsteps[1]; i++)
    { xi = initpoint[0]+i*nsteps[0]*size[0]*cosal;
      yi = initpoint[1]+i*nsteps[0]*size[0]*sinal;
      xf = xi - ( size[1]*size[2]*sinal);
      yf = yi + ( size[1]*size[2]*cosal);
      fprintf(file,"2 1 0 %d %d %d 0 0 -1 0.000 0 0 0 0 0 2\n",
	      ScilabGC_xfig_.CurLineWidth*prec_fact/16,
	      ScilabGC_xfig_.CurColor,
	      ScilabGC_xfig_.CurColor
	      );
      fprintf(file," %d %d %d %d \n", (int)xi, (int) yi, (int)xf, (int)yf);
    }
  xi = initpoint[0]; yi= initpoint[1];
  xf = initpoint[0]+ nsteps[0]*nsteps[1]*size[0]*cosal;
  yf = initpoint[1]+ nsteps[0]*nsteps[1]*size[0]*sinal;
  fprintf(file,"2 1 0 %d %d %d 0 0 -1 0.000 0 0 0 0 0 2\n",
	  ScilabGC_xfig_.CurLineWidth*prec_fact/16,
	  ScilabGC_xfig_.CurColor,
	  ScilabGC_xfig_.CurColor);
  fprintf(file," %d %d %d %d \n",  (int)xi,  (int)yi, (int) xf, (int)yf);
  fprintf(file,"# End Of Axis \n");
}


/*-----------------------------------------------------
\encadre{Display numbers z[i] at location (x[i],y[i])
  with a slope alpha[i] (see displaystring_), if flag==1
  add a box around the string.
-----------------------------------------------------*/
displaynumbers_xfig_(str,x,y,v1,v2,n,flag,z,alpha,dx3,dx4)
     double *dx3,*dx4;
     char str[];
     integer x[],y[],*n,*flag,*v1,*v2;
     double z[],alpha[];
{ integer i ;
  char buf[20];
  for (i=0 ; i< *n ; i++)
    { 
      sprintf(buf,ScilabGC_xfig_.CurNumberDispFormat,z[i]);
      displaystring_xfig_(buf,&(x[i]),&(y[i]),PI0,flag,PI0,PI0,&(alpha[i]),PD0,PD0,PD0);
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



#define PERLINE 15
/** ne pas oublier le blanc aprse %d **/
#define FORMATNUM "%d "

WriteGeneric_xfig_(string,nobj,sizeobj,vx,vy,sizev,flag,fvect)
     integer nobj,sizeobj,vx[],vy[],flag,fvect[],sizev;
     char string[];
{ 
  integer i;
  if ( nobj==0|| sizeobj==0) return;
  if ( strcmp(string,"drawpoly")==0)
    {
      for ( i =0 ; i < nobj ; i++)
	{
	  integer lg,type=1 ;
	  integer areafill;
	  if (fvect[i] <= ScilabGC_xfig_.IDWhitePattern )
	    /** use pattern **/
	   {
	     areafill = AREAF(fvect[i]);/* Max(Min(20, (-10*fvect[i]+157)/7),0);*/
	     if (  ScilabGC_xfig_.CurColorStatus ==1) 
	       {
		 set_c_xfig_(areafill);areafill=20;
	       }
	     type = 3;
	   }
	  else 
	    {
	      if (fvect[i] == ScilabGC_xfig_.IDWhitePattern+1 )
		  /** only draws **/
		  areafill=-1;
	      else 
		/** fill with pattern  and draw **/
		{ 
		  integer nfill= 2*ScilabGC_xfig_.IDWhitePattern+2-fvect[i];
		  areafill = AREAF(nfill); /* Max(Min(20,(-10*nfill+157)/7),0);*/
		  if (  ScilabGC_xfig_.CurColorStatus ==1) 
		    {
		      set_c_xfig_(areafill);areafill=20;
		    }
		  type=3;}
	    }
	  lg=sizeobj/2;
	  fprintf(file,"# Object : %d %s -<pat:%d,areafill=%d,white=%d>- \n", (int)i,string,
		  (int)fvect[i],
		  (int)areafill,
		  ScilabGC_xfig_.IDWhitePattern);
	  fprintf(file,"2 %d %d %d %d %d 0 0 %d %d.00 0 0 -1 0 0 %d\n",
		   (int)type,
		  Min( ScilabGC_xfig_.CurDashStyle,1),
		  ScilabGC_xfig_.CurLineWidth*prec_fact/16,
		  ScilabGC_xfig_.CurColor,
		  ScilabGC_xfig_.CurColor,
		   (int)areafill,
		  8* ScilabGC_xfig_.CurDashStyle,
		  (int)lg
		  );
	  Write2Vect_xfig_(&vx[i*lg],&vy[i*lg],lg,flag);
	}
    }
  else 
  if ( strcmp(string,"drawbox")==0)
    {
      for ( i =0 ; i < nobj ; i++)
	{
	  integer deb,areafill;
	  if (fvect[i] >= ScilabGC_xfig_.IDWhitePattern+1 )
	    areafill = -1;
	  else 
	    areafill =AREAF(fvect[i]);/* Max(Min(20, (-10*fvect[i]+157)/7),0);*/
	  fprintf(file,"# Object : %d %s -<%d>- \n", (int)i,string, (int)fvect[i]);
	  fprintf(file,"2 2 0 %d %d %d 0 0 %d 0.000 0 0 0 0 0 5\n",
		  ScilabGC_xfig_.CurLineWidth*prec_fact/16,
		  ScilabGC_xfig_.CurColor,
		  ScilabGC_xfig_.CurColor,
		   (int)areafill);
	  deb=i*sizeobj;
	  fprintf(file," %d %d %d %d %d %d %d %d %d %d \n",
		  (int)vx[deb]                , (int)vx[1+deb],
		  (int)vx[deb]+ (int)vx[2+deb], (int)vx[1+deb],
		  (int)vx[deb]+ (int)vx[2+deb], (int)vx[1+deb]+ (int)vx[3+deb],
		  (int)vx[deb]                , (int)vx[1+deb]+ (int)vx[3+deb],
		  (int)vx[deb]                , (int)vx[1+deb]);
	}
    }
  else if ( strcmp(string,"drawsegs")==0)      
    {
      for ( i =0 ; i < sizev/2 ; i++)
	{
	  fprintf(file,"# Object : %d %s -<%d>- \n", (int)i,string, (int)fvect[0]);
	  fprintf(file,"2 1 0 %d %d %d 0 0 -1 0.000 0 0 0 0 0 2\n",
		  ScilabGC_xfig_.CurLineWidth*prec_fact/16,
		  ScilabGC_xfig_.CurColor,
		  ScilabGC_xfig_.CurColor
		  );
	  fprintf(file," %d %d %d %d \n",
		   (int)vx[2*i], (int)vy[2*i], (int)vx[2*i+1], (int)vy[2*i+1]);
	}
    }
  else if ( strcmp(string,"drawarrows")==0)      
    {
      integer verbose=0,Dnarg,Dvalue[10];
      /* store the current values */
      getdash_xfig_(&verbose,Dvalue,&Dnarg);
      for ( i = 0 ; i < sizev/2 ; i++)
	{
  	  fprintf(file,"# Object : %d %s -<%d>-\n", (int)i,string, 
		  ScilabGC_xfig_.CurPattern);
	  fprintf(file,"2 1 %d %d %d %d 0 0 -1 %d.000 0 0 0 1 0 2\n",
		  (int)fvect[i],
		  ScilabGC_xfig_.CurLineWidth*prec_fact/16,
		  ScilabGC_xfig_.CurColor,
		  ScilabGC_xfig_.CurColor,
		  (int) 8*fvect[i]
		  );
	  fprintf(file,"    0 0 %d %d %d\n",
		  (int)(1*prec_fact/16), (int)(3*prec_fact), 
		  (int) (6*prec_fact));
	  fprintf(file," %d %d %d %d \n",
		   (int)vx[2*i], (int)vy[2*i], (int)vx[2*i+1], (int)vy[2*i+1]);
	}
      setdash_xfig_( Dvalue,PI0,PI0,PI0);
    }
  else if ( strcmp(string,"drawarc")==0)      
    {
      for ( i = 0 ; i < nobj ; i++)
	{
	  integer areafill;
	  if (fvect[i] >= ScilabGC_xfig_.IDWhitePattern+1 )
	    areafill = -1;
	  else 
	    areafill = AREAF(fvect[i]);/* Max(Min(20, (-10*fvect[i]+157)/7),0);*/
	  fprintf(file,"# Object : %d %s -<%d>-\n", (int)i,string, (int)fvect[0]);
	  fprintf(file,
		  "1 2 0 %d %d %d 0 0 %d 0.000 1 0.00 %d %d %d %d %d %d %d %d \n",
		  ScilabGC_xfig_.CurLineWidth*prec_fact/16,
		  ScilabGC_xfig_.CurColor,
		  ScilabGC_xfig_.CurColor,
		   (int)areafill, (int)vx[6*i]+ (int)vx[6*i+2]/2, (int)vx[6*i+1]+ (int)vx[6*i+3]/2,
		   (int)vx[6*i+2]/2, (int)vx[6*i+3]/2,
		   (int)vx[6*i]+ (int)vx[6*i+2]/2, (int)vx[6*i+1],
		   (int)vx[6*i]+ (int)vx[6*i+2]/2, (int)vx[6*i+1]);
	}
    }
  else if ( strcmp(string,"Rdrawarc")==0)      
    {
      integer verbose=0,Dnarg,Dvalue[10];
      /* store the current values */
      getdash_xfig_(&verbose,Dvalue,&Dnarg);
      for ( i = 0 ; i < nobj ; i++)
	{
	  integer areafill=-1;
	  setdash_xfig_(&fvect[i],PI0,PI0,PI0);
	  fprintf(file,"# Object : %d %s -<%d>-\n", (int)i,string, (int)fvect[0]);
	  fprintf(file,
		  "1 2 %d %d %d %d 0 0 %d %d.000 1 0.00 %d %d %d %d %d %d %d %d \n",
		  ScilabGC_xfig_.CurDashStyle,
		  ScilabGC_xfig_.CurLineWidth*prec_fact/16,
		  ScilabGC_xfig_.CurColor,
		  ScilabGC_xfig_.CurColor,
		  (int)areafill, 
		  8*ScilabGC_xfig_.CurDashStyle,
		  (int)vx[6*i]+ (int)vx[6*i+2]/2, 
		  (int)vx[6*i+1]+ (int)vx[6*i+3]/2,
		  (int)vx[6*i+2]/2, (int)vx[6*i+3]/2,
		  (int)vx[6*i]+ (int)vx[6*i+2]/2, (int)vx[6*i+1],
		  (int)vx[6*i]+ (int)vx[6*i+2]/2, (int)vx[6*i+1]);
	}
      setdash_xfig_( Dvalue,PI0,PI0,PI0);
    }
  else if ( strcmp(string,"drawpolymark")==0)      
    {
      integer rect[4],x=0,y=0;
      boundingbox_xfig_("x",&x,&y,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      fprintf(file,"# Object : %d %s -<%d>- \n", (int)0,string, (int)fvect[0]);
      for ( i =0 ; i < sizev ; i++)
	{
	  fprintf(file,"4 0 %d 0 0 %d %d %5.2f %d %5.2f %5.2f %d %d \\%o\\001\n",
		  ScilabGC_xfig_.CurColor,
		  32, /* Postscript font */
		  (int)isize_xfig_[ScilabGC_xfig_.CurHardFontSize], /**prec_fact,*/
		  0.0,
		  4,  
		  (double) rect[3],
		  (double) rect[2],
		  (int)vx[i],
		  (int)vy[i],
		  Char2Int( symb_list_xfig_[ScilabGC_xfig_.CurHardSymb])
		  );
	}
    }
  else
    sciprint("Can't translate %s\r\n",string);
}


Write2Vect_xfig_(vx,vy,n,flag)
     integer n,flag;
     integer vx[],vy[];
{
  integer i,k;
  i=0;
  while( i < n)
    {
      k=0;
      while ( k < PERLINE && i < n )
	{
	  fprintf(file,FORMATNUM,vx[i]);
	  if (flag == 1) 
	    {fprintf(file,FORMATNUM,vy[i]);
	      k += 2;i++;}
	  else 
	    {k++;i++;}
	}
      fprintf(file,"\n");
    }
}

/*------------------------END--------------------*/
