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
#ifdef THINK_C
#define  CoordModePrevious 0
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

#define Char2Int(x)   ( x & 0x000000ff )

/** Global variables to deal with fonts **/
static int use_color=0;

#define FONTNUMBER 7
#define FONTMAXSIZE 6
#define SYMBOLNUMBER 10
int FontsList_xfig_[FONTNUMBER][FONTMAXSIZE];
struct FontInfo { int ok;
		  char fname[20];} FontInfoTab_xfig_[FONTNUMBER];
/** xfig code for our fonts **/
static int  xfig_font[]= { 12,32,0,1,2,3,0};
static char *size_xfig_[] = { "08" ,"10","12","14","18","24"};
static int  isize_xfig_[] = { 8,10,12,14,18,24};

static FILE *file=stdout ;

/** Structure to keep the graphic state  **/

struct BCG 
{ 
  int CurHardFontSize;
  int CurColor;
  int CurHardFont;
  int CurHardSymb;
  int CurHardSymbSize;
  int CurLineWidth;
  int CurPattern;
  int IDWhitePattern;
  int CurWindow;
  int CurVectorStyle;
  int CurDrawFunction;
  int ClipRegionSet;
  int CurClipRegion[4];
  int CurDashStyle;
  char CurNumberDispFormat[20];
}  ScilabGC_xfig_ ;


/*-----------------------------------------------------
\encadre{General routines}
-----------------------------------------------------*/

/** To select the graphic Window  **/

xselgraphic_xfig_(){};

/** End of graphic (close the file)  **/

xendgraphic_xfig_()
{
  if (file != stdout) fclose(file);
}

xend_xfig_()
{
  if (file != stdout) fclose(file);
}


/** Clear the current graphic window     **/
/** In Fig : nothing      **/

clearwindow_xfig_() 
{
};

/** Flush out the X11-buffer  **/

viderbuff_xfig_(){}

/** To get the window size **/
/** The default fig box    **/
/** for line thickness etc \ldots **/
static int prec_fact =8;

getwindowdim_xfig_(verbose,x,narg)
  int *verbose,*x,*narg;
{     
  *narg = 2;
  x[0]= 600*prec_fact;
  x[1]= 424*prec_fact;
  if (*verbose == 1) 
    SciF2d("\n CWindow dim :%d,%d\r\n",x[0],x[1]);
}; 

/** To change the window dimensions : do Nothing in Postscript  **/

setwindowdim_xfig_(x,y)
     int *x,*y;
{
};

/** to get the window upper-left point coordinates return 0,0 **/

getwindowpos_xfig_(verbose,x,narg)
  int *verbose,*x,*narg;
{
  *narg = 2;
  x[0]= x[1]=0;
  if (*verbose == 1) 
    SciF2d("\n CWindow position :%d,%d\r\n",x[0],x[1]);
 };

/** to set the window upper-left point position (Void) **/

setwindowpos_xfig_(x,y)
     int *x,*y;
{
};


/** To generate a pause : Empty here **/

xpause_xfig_(str,sec_time)
     char str[];
     int *sec_time;
{};

/** Wait for mouse click in graphic window : Empty here **/

waitforclick_xfig_(str,ibutton,xx1,yy1)
     char str[];
  int *ibutton,*xx1,*yy1 ;
{ };

xgetmouse_xfig_(str,ibutton,xx1,yy1)
     char str[];
  int *ibutton,*xx1,*yy1 ;
{ };

/** Clear a rectangle **/

cleararea_xfig_(str,x,y,w,h)
     char str[];
     int *x,*y,*w,*h;
{
  fprintf(file,"# %d %d %d %d clearzone\n");
};

/*------------------------------------------------
\encadre{Functions to modify the graphic state}
-------------------------------------------------*/

/** Select a graphic Window : Empty for Postscript **/

setcurwin_xfig_(intnum)
     int *intnum;
{};

/** Get the id number of the Current Graphic Window **/

getcurwin_xfig_(verbose,intnum,narg)
     int *verbose,*intnum,*narg;
{
  *narg =1 ;
  *intnum = ScilabGC_xfig_.CurWindow ;
  if (*verbose == 1) 
    Scistring("\nJust one graphic page at a time ");
};

/** Set a clip zone (rectangle ) **/

setclip_xfig_(x,y,w,h)
     int *x,*y,*w,*h;
{
  ScilabGC_xfig_.ClipRegionSet = 1;
  ScilabGC_xfig_.CurClipRegion[0]= *x;
  ScilabGC_xfig_.CurClipRegion[1]= *y;
  ScilabGC_xfig_.CurClipRegion[2]= *w;
  ScilabGC_xfig_.CurClipRegion[3]= *h;
  fprintf(file,"# %d %d %d %d setclipzone\n",*x,*y,*w,*h);
};

/** Get the boundaries of the current clip zone **/

getclip_xfig_(verbose,x,narg)
     int *verbose,*x,*narg;
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
    SciF4d("\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d\r\n",
	      ScilabGC_xfig_.CurClipRegion[0],
	      ScilabGC_xfig_.CurClipRegion[1],
	      ScilabGC_xfig_.CurClipRegion[2],
	      ScilabGC_xfig_.CurClipRegion[3]);
  else 
    Scistring("\nNo Clip Region");
};

/*----------------------------------------------------------
\encadre{For the drawing functions dealing with vectors of 
 points, the following routine is used to select the mode 
 absolute or relative }
 Absolute mode if *num==0, relative mode if *num != 0
------------------------------------------------------------*/

absourel_xfig_(num)
     	int *num;
{
  if (*num == 0 )
    ScilabGC_xfig_.CurVectorStyle =  CoordModeOrigin;
  else 
    ScilabGC_xfig_.CurVectorStyle =  CoordModePrevious ;
};

/** to get information on absolute or relative mode **/

getabsourel_xfig_(verbose,num,narg)
     	int *verbose,*num,*narg;
{
  *narg = 1;
    *num = ScilabGC_xfig_.CurVectorStyle  ;
    if (*verbose == 1) 
  if (ScilabGC_xfig_.CurVectorStyle == CoordModeOrigin)
    Scistring("\nTrace Absolu");
  else 
    Scistring("\nTrace Relatif");
  };


/** The alu function for drawing : Works only with X11 **/
/** Not in Postscript **/

setalufunction_xfig_(string)
 char string[];
{     
  int value;
  
  idfromname_xfig_(string,&value);
  if ( value != -1)
    {ScilabGC_xfig_.CurDrawFunction = value;
     fprintf(file,"# %d setalufunction\n",value);
      };
};

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
     int *num;
{int i;
 *num = -1;
 for ( i =0 ; i < 16;i++)
   if (strcmp(AluStruc_xfig_[i].name,name1)== 0) 
     *num=AluStruc_xfig_[i].id;
 if (*num == -1 ) 
   {
     Scistring("\n Use the following keys :");
     for ( i=0 ; i < 16 ; i++)
       {
	 SciF1s("\nkey %s ",AluStruc_xfig_[i].name);
	 SciF1s("-> %s\r\n",AluStruc_xfig_[i].info);
       };
   };
};
/** To get the value of the alufunction **/

getalufunction_xfig_(verbose,value,narg)
     int *verbose , *value ,*narg;
{ 
  *narg =1 ;
  *value = ScilabGC_xfig_.CurDrawFunction ;
   if (*verbose ==1 ) 
     { 
       SciF1s("\nThe Alufunction is %s",AluStruc_xfig_[*value].name);
       SciF1s("-> <%s>\r\n", AluStruc_xfig_[*value].info);
     };
};

/** to set the thickness of lines :min is 1 is a possible value **/
/** give the thinest line **/

setthickness_xfig_(value)
  int *value ;
{ 
  ScilabGC_xfig_.CurLineWidth =Max(1, *value);
  fprintf(file,"# %d Thickness\r\n",Max(1,*value));
};

/** to get the thicknes value **/

getthickness_xfig_(verbose,value,narg)
     int *verbose,*value,*narg;
{
  *narg =1 ;
  *value = ScilabGC_xfig_.CurLineWidth ;
  if (*verbose ==1 ) 
    SciF1d("\nLine Width:%d\r\n", ScilabGC_xfig_.CurLineWidth ) ;
};
     

#define GREYNUMBER 17
/*-------------------------------------------------
\encadre{To set grey level for filing areas.
  from black (*num =0 ) to white 
  you must use the get function to get the id of 
  the white pattern }
----------------------------------------------------*/

setpattern_xfig_(num)
     int *num;
{ int i ; 
  i= Max(0,Min(*num,GREYNUMBER-1));
  if ( use_color ==1) set_c_xfig_(i);
  ScilabGC_xfig_.CurPattern = i;
  if (i ==0)
    fprintf(file,"# fillsolid\n");
  else 
    fprintf(file,"# %d Setgray\n",i);
};

/** To get the id of the current pattern  **/

getpattern_xfig_(verbose,num,narg)
     int *num,*verbose,*narg;
{ 
  *narg=1;
  *num = ScilabGC_xfig_.CurPattern ;
  if (*verbose == 1) 
      SciF1d("\n Pattern : %d\r\n",ScilabGC_xfig_.CurPattern);
};

/** To set the current font id of font and size **/

xsetfont_xfig_(fontid,fontsize)
     int *fontid , *fontsize ;
{ int i,fsiz;
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
	     isize_xfig_[fsiz]*prec_fact);
   };
};

/** To get the values id and size of the current font **/

xgetfont_xfig_(verbose,font,nargs)
     int *verbose,*font,*nargs;
{
  *nargs=2;
  font[0]= ScilabGC_xfig_.CurHardFont ;
  font[1] =ScilabGC_xfig_.CurHardFontSize ;
  if (*verbose == 1) 
    {
      SciF1d("\nFontId : %d ",ScilabGC_xfig_.CurHardFont );
      SciF1s("--> %s at size",
	     FontInfoTab_xfig_[ScilabGC_xfig_.CurHardFont].fname);
      SciF1s("%s pts\r\n",size_xfig_[ScilabGC_xfig_.CurHardFontSize]);
    };
};

/** To set dash-style : **/
/**  use a table of dashes and set default dashes to **/
/**  one of the possible value. value point **/
/**  to a strictly positive integer **/

static int DashTab_fig[6][4] = {
  {2,5,2,5}, {5,2,5,2},  {5,3,2,3}, {8,3,2,3},
  {11,3,2,3}, {11,3,5,3}};


setdash_xfig_(value)
     int *value;
{
  static int maxdash = 6, l2=4,l3 ;
  l3 = Min(maxdash-1,*value-1);
  if ( use_color ==1) 
    {
      set_c_xfig_(*value);
      ScilabGC_xfig_.CurDashStyle= *value;
    }
  else
    {
      setdashstyle_fig_(value,DashTab_fig[Max(0,l3)],&l2);
      ScilabGC_xfig_.CurDashStyle= l3 + 1 ;
    };
}

/** To change The Pos-default dash style **/
/** if *value == 0, use a solid line, if *value != 0 **/
/** the dash style is specified by the xx vector of n values **/
/** xx[3]={5,3,7} and *n == 3 means :  5white 3 void 7 white \ldots **/
  
setdashstyle_fig_(value,xx,n)
     int *value,xx[],*n;
{
  int i ;
  if ( *value == 0) fprintf(file,"#[] 0 setdash\n");
  else 
    {
      fprintf(file,"#[");
      for (i=0;i<*n;i++)
	fprintf(file,"%d ",xx[i]*prec_fact);
      fprintf(file,"] 0 setdash\n");
    };
};

/** to get the current dash-style **/

getdash_xfig_(verbose,value,narg)
     int *verbose,*value,*narg;
{int i ;
 *value=ScilabGC_xfig_.CurDashStyle;
 *narg =1 ;
 if ( use_color ==1) 
   {
     if (*verbose == 1) SciF1d("Color %d",*value);
     return;
   };
 if ( *value == 0) 
   { if (*verbose == 1) Scistring("\nLine style = Line Solid");}
 else 
   {
     value[1]=4;
     *narg = value[1]+2;
     for ( i =0 ; i < value[1]; i++) value[i+2]=DashTab_fig[*value-1][i];
     if (*verbose ==1 ) 
       {
	 SciF1d("\nDash Style %d:<",*value);
	 for ( i =0 ; i < value[1]; i++)
	   SciF1d("%d ",value[i+2]);
	 Scistring(">\n");
       }
   }
};


/** To set the current mark : using the symbol font of adobe **/

setcursymbol_xfig_(number,size)
     int *number ;
     int *size   ;
{ 
  ScilabGC_xfig_.CurHardSymb =
    Max(Min(SYMBOLNUMBER-1,*number),0);
  ScilabGC_xfig_.CurHardSymbSize = 
    Max(Min(FONTMAXSIZE-1,*size),0);
;}

/** To get the current mark id **/

getcursymbol_xfig_(verbose,symb,narg)
     int *verbose,*symb,*narg;
{
  *narg =2 ;
  symb[0] = ScilabGC_xfig_.CurHardSymb ;
  symb[1] = ScilabGC_xfig_.CurHardSymbSize ;
  if (*verbose == 1) 
  {
    SciF1d("\nMark : %d",ScilabGC_xfig_.CurHardSymb);
    SciF1s("at size %s pts\r\n",
	  size_xfig_[ScilabGC_xfig_.CurHardSymbSize]);
  };
};

/** To get the id of the white pattern **/

getwhite_xfig_(verbose,num,narg)
     int *num,*verbose,*narg;
{
  *num = ScilabGC_xfig_.IDWhitePattern ;
  if (*verbose==1) 
    SciF1d("\n Id of White Pattern %d \r\n",*num);
  *narg=1;
};


#define NUMCOLORS 17

usecolor_xfig_(num)
     int *num;
{
  if ( use_color != *num)
    {
      int i=0;
      use_color= *num;
      setdash_xfig_(&i);
      setpattern_xfig_(&i);
    };
};

set_c_xfig_(i)
     int i;
{
  int j;
  j=Max(Min(i,NUMCOLORS-1),0);
  ScilabGC_xfig_.CurColor=j;
  fprintf(file,"\n# %d Setcolor\n",i);
} ;


/*--------------------------------------------------------
\encadre{general routines accessing the  set<> or get<>
 routines } 
-------------------------------------------------------*/

int InitScilabGC_xfig_();

empty_xfig_(verbose)
     int *verbose;
{
  if ( *verbose ==1 ) Scistring("\n No operation ");
};

#define NUMSETFONC 14

struct bgc { char *name ;
	     int  (*setfonc )() ;
	     int  (*getfonc )() ;}
  ScilabGCTab_xfig_[] = {
   "alufunction",setalufunction_xfig_,getalufunction_xfig_,
   "clipping",setclip_xfig_,getclip_xfig_,
   "dashes",setdash_xfig_,getdash_xfig_,
   "default",InitScilabGC_xfig_, empty_xfig_,
   "font",xsetfont_xfig_,xgetfont_xfig_,
   "line mode",absourel_xfig_,getabsourel_xfig_,
   "mark",setcursymbol_xfig_,getcursymbol_xfig_,
   "pattern",setpattern_xfig_,getpattern_xfig_,
   "thickness",setthickness_xfig_,getthickness_xfig_,
   "use color",usecolor_xfig_,empty_xfig_,
   "wdim",setwindowdim_xfig_,getwindowdim_xfig_,
   "white",empty_xfig_,getwhite_xfig_,
   "window",setcurwin_xfig_,getcurwin_xfig_,
   "wpos",setwindowpos_xfig_,getwindowpos_xfig_
 };

scilabgcget_xfig_(str,verbose,x1,x2,x3,x4,x5)
     int *verbose,*x1,*x2,*x3,*x4,*x5;
     char str[];
{
 ScilabGCGetorSet_xfig_(str,1,verbose,x1,x2,x3,x4,x5);
};

scilabgcset_xfig_(str,x1,x2,x3,x4,x5)
     int *x1,*x2,*x3,*x4,*x5;
     char str[];
{
 int verbose ;
 verbose = 0 ;
 ScilabGCGetorSet_xfig_(str,0,&verbose,x1,x2,x3,x4,x5);}

ScilabGCGetorSet_xfig_(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     int flag ;
     int  *verbose,*x1,*x2,*x3,*x4,*x5;
{ int i ;
  for (i=0; i < NUMSETFONC ; i++)
     {
       int j;
       j = strcmp(str,ScilabGCTab_xfig_[i].name);
       if ( j == 0 ) 
	 { if (*verbose == 1)
	     SciF1s("\nGettting Info on %s\r\n",str);
	   if (flag == 1)
	     (ScilabGCTab_xfig_[i].getfonc)(verbose,x1,x2,x3,x4,x5);
	   else 
	     (ScilabGCTab_xfig_[i].setfonc)(x1,x2,x3,x4,x5);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       SciF1s("\nUnknow Postscript operator <%s>\r\n",str);
	       return;
	     };
	 };
     };
  SciF1s("\n Unknow Postscript operator <%s>\r\n",str);
};

/*-----------------------------------------------------------
\encadre{Functions for drawing}
-----------------------------------------------------------*/



/*----------------------------------------------------
\encadre{display of a string
 at (x,y) position whith angle (alpha). Angles in degree
 positive when clockwise. If *flag ==1 a framed  box is added 
 around the string.}
-----------------------------------------------------*/

displaystring_xfig_(string,x,y,angle,flag)
  int *x,*y ,*flag;
     double *angle;
  char string[] ;
{     int rect[4] ;
      boundingbox_xfig_(string,x,y,rect);
      if (string[0]== '$') 
	fprintf(file,"4 0 %d %d 0 %d 0 %5.2f 2 %d %d %d %d %s\1\n",
		0,
		isize_xfig_[ScilabGC_xfig_.CurHardFontSize]*prec_fact,
		ScilabGC_xfig_.CurColor,
		(M_PI/180.0)*(*angle),rect[3],rect[2],*x,*y,string);
      else 
	fprintf(file,"4 0 %d %d 0 %d 0 %5.2f 4 %d %d %d %d %s\1\n",
	     xfig_font[ScilabGC_xfig_.CurHardFont],
	     isize_xfig_[ScilabGC_xfig_.CurHardFontSize]*prec_fact,
		ScilabGC_xfig_.CurColor,
	     (M_PI/180.0)*(*angle),rect[3],rect[2],*x,*y,string);
}

int bsize_xfig_[6][4]= {{ 0,-7,4.63,9  },
		{ 0,-9,5.74,12 },
		{ 0,-11,6.74,14},
		{ 0,-12,7.79,15},
		{0, -15,9.72,19 },
		{0,-20,13.41,26}};

/** To get the bounding rectangle of a string **/

boundingbox_xfig_(string,x,y,rect)
     int *x,*y,*rect;
     char string[];
{int verbose,nargs,font[2];
 verbose=0;
 xgetfont_xfig_(&verbose,font,&nargs);
 rect[0]= *x+bsize_xfig_[font[1]][0]*((double) prec_fact);
 rect[1]= *y+bsize_xfig_[font[1]][1]*((double) prec_fact);
 rect[2]= bsize_xfig_[font[1]][2]*strlen(string)*((double) prec_fact);
 rect[3]= bsize_xfig_[font[1]][3]*((double) prec_fact);
};

/** Draw a single line in current style **/
/** Unused in fact **/ 

drawline_xfig_(x1,yy1,x2,y2)
    int *x1, *x2, *yy1, *y2 ;
  {
    fprintf(file,"# %d %d %d %d L\n",*x1,*yy1,*x2,*y2);
  };

/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/

drawsegments_xfig_(str,vx,vy,n)
     char str[];
     int *n,vx[],vy[];
{
  int fvect[1];
  fvect[0]= ScilabGC_xfig_.CurPattern;
  WriteGeneric_xfig_("drawsegs",1,(*n)*2,vx,vy,*n,1,fvect);
};

/** Draw a set of arrows **/

drawarrows_xfig_(str,vx,vy,n,as)
     int *as;
     char str[];
     int *n,vx[],vy[];
{
  int fvect[1];
  fvect[0]= ScilabGC_xfig_.CurPattern;
  WriteGeneric_xfig_("drawarrows",1,(*n)*2,vx,vy,*n,1,fvect);
};

/** Draw one rectangle **/

drawrectangle_xfig_(str,x,y,width,height)
     char str[];
    int  *x, *y, *width, *height;
  { 
  int i = 1;
  int fvect[1] ;
  int vects[4];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;
  fvect[0] = ScilabGC_xfig_.IDWhitePattern +1  ;
  drawrectangles_xfig_(str,vects,fvect,&i);
  };

/** Draw a filled rectangle **/

drawfilledrect_xfig_(str,x,y,width,height)
     char str[];
    int  *x, *y, *width, *height;
{ 
  int i = 1;
  int fvect[1] ;
  int vects[4];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height ; 
  fvect[0] = ScilabGC_xfig_.CurPattern ;
  drawrectangles_xfig_(str,vects,fvect,&i);    
};

/** Draw or fill a set of rectangle **/
/** rectangles are defined by (vect[i],vect[i+1],vect[i+2],vect[i+3]) **/
/** for i=0 step 4 **/
/** (*n) : number of rectangles **/
/** fillvect[*n] : specify the action <?> **/
/** if (fillvect[i] >= ScilabGC_.IDWhitePattern+1 then draw **/
/** else fille with id fillvect[i] **/

drawrectangles_xfig_(str,vects,fillvect,n)
     char str[];
     int *vects,*fillvect,*n;
{
  int cpat,verb,num;
  verb=0;
  getpattern_xfig_(&verb,&cpat,&num);
  WriteGeneric_xfig_("drawbox",*n,4,vects,vects,4*(*n),0,fillvect);
  setpattern_xfig_(&(cpat));
};

/** Draw or fill a set of ellipsis or part of ellipsis **/
/** Each is defined by 6-parameters, **/
/** fillvect[*n] : specify the action <?> **/
/** caution angle=degreangle*64          **/

drawarcs_xfig_(str,vects,fillvect,n)
     char str[];
     int *vects,*fillvect,*n;
{
  int cpat,verb,num;
  verb=0;
  getpattern_xfig_(&verb,&cpat,&num);
  WriteGeneric_xfig_("drawarc",*n,6,vects,vects,6*(*n),0,fillvect);
  setpattern_xfig_(&(cpat));
};

/** Draw a single ellipsis or part of it **/
/** caution angle=degreAngle*64          **/

drawarc_xfig_(str,x,y,width,height,angle1,angle2)
     char str[];
    int *angle1,*angle2, *x, *y, *width, *height;
 { 
  int i =1;
  int fvect[1] ;
  int vects[6];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;vects[4]= *angle1;vects[5]= *angle2;
  fvect[0] = ScilabGC_xfig_.IDWhitePattern  +1;
  drawarcs_xfig_(str,vects,fvect,&i);
};

/** Fill a single elipsis or part of it **/
/** with current pattern **/

drawfilledarc_xfig_(str,x,y,width,height,angle1,angle2)
     char str[];
     int *angle1,*angle2, *x, *y, *width, *height;
 { 
  int i =1;
  int fvect[1] ;
  int vects[6];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;vects[4]= *angle1;vects[5]= *angle2;
  fvect[0] = ScilabGC_xfig_.CurPattern ;
  drawarcs_xfig_(str,vects,fvect,&i);
 };

/** Draw a set of  current mark centred at points defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_xfig_(str,n, vx, vy)
     char str[];
     int *n ; 
     int vx[], vy[];
{ int keepid,keepsize,i;
  keepid =  ScilabGC_xfig_.CurHardFont;
  keepsize= ScilabGC_xfig_.CurHardFontSize;
  i=1;
  xsetfont_xfig_(&i,&(ScilabGC_xfig_.CurHardSymbSize));
  displaysymbols_xfig_(str,n,vx,vy);
  xsetfont_xfig_(&keepid,&keepsize);
};

char symb_list_xfig_[] = {
 /*., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle*/
  0xb7,0x2b,0xb4,0xc5,0xa8,0xe0,0x44,0xd1,0xa7,0x4f};

displaysymbols_xfig_(str,n,vx,vy)
     char str[];
     int *n,vx[],vy[];
{
  int fvect[1];
  fvect[0] = 	  ScilabGC_xfig_.CurPattern;
  if ( ScilabGC_xfig_.CurVectorStyle !=  CoordModeOrigin)
    fprintf(file,"#/absolu false def\n");
  fprintf(file,"#HardMark 0 16#%x put\n",
      Char2Int( symb_list_xfig_[ScilabGC_xfig_.CurHardSymb]));
  WriteGeneric_xfig_("drawpolymark",1,(*n)*2,vx,vy,*n,1,fvect);
  fprintf(file,"#/absolu true def\n");
};

/** Draw a set of *n polylines (each of which have (*p) points) **/
/** with lines or marks **/
/** drawvect[i] >= use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

morlpolylines_xfig_(str,vectsx,vectsy,drawvect,n,p)
     char str[];
     int *vectsx,*vectsy,*drawvect,*n,*p;
{ int verbose ,symb[2],Mnarg,Dnarg,Dvalue[10],NDvalue,i,close;
  verbose =0 ;
  /* store the current values */
  getcursymbol_xfig_(&verbose,symb,&Mnarg);
  getdash_xfig_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i< *n ; i++)
    {
      if (drawvect[i] >= 0)
	{ /** on utilise la marque de numero associ\'ee **/
	  setcursymbol_xfig_(drawvect+i,symb+1);
	  drawpolymark_xfig_(str,p,vectsx+(*p)*i,vectsy+(*p)*i);
	}
      else
	{/** on utilise un style pointill\'e  **/
	  NDvalue = - drawvect[i] -1;
	  setdash_xfig_(&NDvalue);
	  close = 0;
	  drawpolyline_xfig_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,&close);
	};
    };
/** back to default values **/
  setdash_xfig_(Dvalue);
  setcursymbol_xfig_(symb,symb+1);
};

/** fill a set of polygons each of which is defined by **/
/** (*p) points (*n) is the number of polygons **/
/** the polygon is closed by the routine **/
/** if fillvect <= whiteid-pattern the coresponding pattern is used  **/
/** if fillvect == whiteid-pattern +1 -> draw the boundaries  **/
/** if fillvect >= whiteid-pattern +2 -> fill with white and draw boundaries **/
/** fillvect[*n] :         **/

drawpolylines_xfig_(str,vectsx,vectsy,fillvect,n,p)
     char str[];
     int *vectsx,*vectsy,*fillvect,*n,*p;
{
  int cpat,verb,num;
  verb=0;
  if ( ScilabGC_xfig_.CurVectorStyle !=  CoordModeOrigin)
    fprintf(file,"#/absolu false def\n");
  getpattern_xfig_(&verb,&cpat,&num);
  WriteGeneric_xfig_("drawpoly",*n,(*p)*2,vectsx,vectsy,(*p)*(*n),1,
			fillvect);
  setpattern_xfig_(&(cpat));
  fprintf(file,"#/absolu true def\n");
};

/** Only draw one polygon with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/

drawpolyline_xfig_(str,n, vx, vy,closeflag)
     char str[];
     int *n,*closeflag;
     int vx[], vy[];
{ int i =1;
  int fvect[1] ;
  fvect[0] = ScilabGC_xfig_.IDWhitePattern  +1;
  if (*closeflag == 1 )
    fprintf(file,"#/closeflag true def\n");
  else 
    fprintf(file,"#/closeflag false def\n");
  drawpolylines_xfig_(str,vx,vy,fvect,&i,n);
};

/** Fill the polygon **/

fillarea_xfig_(str,n, vx, vy,closeareaflag)
     char str[];
     int *n,*closeareaflag;
     int vx[], vy[];
{
  int i =1;
  int fvect[1] ;
  fvect[0] = ScilabGC_xfig_.CurPattern ;
  drawpolylines_xfig_(str,vx,vy,fvect,&i,n);
}


 
/*-----------------------------------------------------
\encadre{Routine for initialisation}
------------------------------------------------------*/


initgraphic_xfig_(string)
     char string[];
{ char string1[50],string2[2];
  static int EntryCounter = 0;
  int fnum;
  if (EntryCounter >= 1) xendgraphic_xfig_();
  strcpy(string1,string);
  /* Not so useful   
  sprintf(string2,"%d",EntryCounter);
  strcat(string1,string2); */
  file=fopen(string1,"w");
  if (file == 0) 
    {
      SciF1s("Can't open file %s, I'll use stdout\r\n",string1);
      file =stdout;
    };
  if (EntryCounter == 0)
    { 
      fnum=0;      loadfamily_xfig_("Courier",&fnum); 
      fnum=1;      loadfamily_xfig_("Symbol",&fnum); 
      fnum=2;      loadfamily_xfig_("Times-Roman",&fnum);
      fnum=3;      loadfamily_xfig_("Times-Italic",&fnum); 
      fnum=4;      loadfamily_xfig_("Times-Bold",&fnum);
      fnum=5;      loadfamily_xfig_("Times-BoldItalic",&fnum); 

    };
  FileInit_xfig_(file);
  ScilabGC_xfig_.CurWindow =EntryCounter;
  EntryCounter =EntryCounter +1;
};

FileInit_xfig_(filen)
     FILE *filen;
{
  /** Just send Postscript commands to define scales etc....**/
  int x[2],verbose,narg;
  verbose = 0; 
  getwindowdim_xfig_(&verbose,x,&narg);
  fprintf(filen,"#FIG 2.1\n");
  fprintf(filen,"80 2\n");
  fprintf(filen,"2 2 0 0 -1 0 0 0 0.000 0 0 0\n");
  fprintf(filen," %d %d %d %d %d %d %d %d %d %d  9999 9999",
	  0,0,x[0],0,x[0],x[1],0,x[1],0,0);

  InitScilabGC_xfig_()	;
};

/*--------------------------------------------------------
\encadre{Initialisation of the graphic context. Used also 
to come back to the default graphic state}
---------------------------------------------------------*/

InitScilabGC_xfig_()
{ int i,j,k[2] ;
  ScilabGC_xfig_.IDWhitePattern = GREYNUMBER-2; /** bug ?? **/
  ScilabGC_xfig_.CurLineWidth=1 ;
  ScilabGC_xfig_.CurColor=0 ;
  i=0;
  setthickness_xfig_(&i);
  setalufunction_xfig_("GXcopy");
  /** retirer le clipping **/
  i=j= -1;
  k[0]=200000,k[1]=200000;
  setclip_xfig_(&i,&j,k,k+1);
  ScilabGC_xfig_.ClipRegionSet= 0;
  i=0;setdash_xfig_(&i);
  i=2;j=1;
  xsetfont_xfig_(&i,&j);
  i=j=0;
  setcursymbol_xfig_(&i,&j);
  /** trac\'e absolu **/
  ScilabGC_xfig_.CurVectorStyle = CoordModeOrigin ;
  setpattern_xfig_(&i);
  setthickness_xfig_(&i);
  strcpy(ScilabGC_xfig_.CurNumberDispFormat,"%-5.2g");
};


/*-------------------------------------------------------
\encadre{Check if a specified family of font exist in 
Postscript }
-------------------------------------------------------*/

loadfamily_xfig_(name,j)
     char *name;
     int *j;
{ 
  int i ;
  for ( i = 0; i < FONTMAXSIZE ; i++)
    {
      FontsList_xfig_[*j][i] = FigQueryFont_(name);
    };
  if  (FontsList_xfig_[*j][0] == 0 )
	  SciF1s("\n unknown font family : %s\r\n",name);
  else 
    {FontInfoTab_xfig_[*j].ok = 1;
     strcpy(FontInfoTab_xfig_[*j].fname,name) ;}
};

/*--------------------------------------------
\encadre{always answer ok. Must be Finished}
---------------------------------------------*/

int FigQueryFont_(name)
     char name[];
{ return(1);};


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
  \item $init$. Initial point $<x,y>$. 
  \end{itemize}
  }
  -------------------------------------------------------------*/

drawaxis_xfig_(str,alpha,nsteps,size,initpoint)
     char str[];
     int *alpha,*nsteps,*initpoint;
     double *size;
{ int i;
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
   };
  for (i=0; i <= nsteps[0]*nsteps[1]; i++)
    { xi = initpoint[0]+i*size[0]*cosal;
      yi = initpoint[1]+i*size[0]*sinal;
      xf = xi - ( size[1]*sinal);
      yf = yi + ( size[1]*cosal);
      fprintf(file,"2 1 0 %d %d 0 0 0 0.000 0 0 0\n",
	        ScilabGC_xfig_.CurLineWidth*prec_fact/2,
	      ScilabGC_xfig_.CurColor);
      fprintf(file," %d %d %d %d ",(int) xi,(int) yi,(int) xf,(int)yf);
      fprintf(file," 9999 9999\n");	  
    };
  for (i=0; i <= nsteps[1]; i++)
    { xi = initpoint[0]+i*nsteps[0]*size[0]*cosal;
      yi = initpoint[1]+i*nsteps[0]*size[0]*sinal;
      xf = xi - ( size[1]*size[2]*sinal);
      yf = yi + ( size[1]*size[2]*cosal);
      fprintf(file,"2 1 0 %d %d 0 0 0 0.000 0 0 0\n",
	        ScilabGC_xfig_.CurLineWidth*prec_fact/2,
	      ScilabGC_xfig_.CurColor);
      fprintf(file," %d %d %d %d ",(int) xi,(int) yi,(int) xf,(int)yf);
      fprintf(file," 9999 9999\n");	  
    };
  xi = initpoint[0]; yi= initpoint[1];
  xf = initpoint[0]+ nsteps[0]*nsteps[1]*size[0]*cosal;
  yf = initpoint[1]+ nsteps[0]*nsteps[1]*size[0]*sinal;
  fprintf(file,"2 1 0 %d %d 0 0 0 0.000 0 0 0\n",
	        ScilabGC_xfig_.CurLineWidth*prec_fact/2,
	  ScilabGC_xfig_.CurColor);
  fprintf(file," %d %d %d %d ",(int) xi,(int) yi,(int) xf,(int)yf);
  fprintf(file," 9999 9999\n");	  
  fprintf(file,"# End Of Axis \n");
};


/*-----------------------------------------------------
\encadre{Display numbers z[i] at location (x[i],y[i])
  with a slope alpha[i] (see displaystring_), if flag==1
  add a box around the string.
-----------------------------------------------------*/
displaynumbers_xfig_(str,x,y,z,alpha,n,flag)     
     char str[];
     int x[],y[],*n,*flag;
     double z[],alpha[];
{ int i ;
  char buf[20];
  for (i=0 ; i< *n ; i++)
    { sprintf(buf,ScilabGC_xfig_.CurNumberDispFormat,z[i]);
      displaystring_xfig_(buf,&(x[i]),&(y[i]),&(alpha[i]),flag)      ;
    };
};

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
     int nobj,sizeobj,vx[],vy[],flag,fvect[],sizev;
     char string[];
{ 
  int i;
  if ( nobj==0|| sizeobj==0) return;
  if ( strcmp(string,"drawpoly")==0)
    {
      for ( i =0 ; i < nobj ; i++)
	{
	  int lg,type=1 ;
	  int areafill;
	  if (fvect[i] <= ScilabGC_xfig_.IDWhitePattern )
	    /** use pattern **/
	   {
	     areafill = Max(Min(21, (-10*fvect[i]+157)/7),1);
	     if ( use_color ==1) 
	       {
		 set_c_xfig_(areafill);areafill=21;
	       };
	     type = 3;
	   }
	  else 
	    {
	      if (fvect[i] == ScilabGC_xfig_.IDWhitePattern+1 )
		  /** only draws **/
		  areafill=0;
	      else 
		/** fill with pattern  and draw **/
		{ 
		  areafill = Max(Min(21,(-10*(fvect[i]-(ScilabGC_xfig_.IDWhitePattern+1))+157)/7),1);
		  if ( use_color ==1) 
		    {
		      set_c_xfig_(areafill);areafill=21;
		    };
		  type=3;}
	    };
	  lg=sizeobj/2;
	  fprintf(file,"# Object : %d %s -<%d>- \n",i,string,fvect[i]);
	  fprintf(file,"2 %d %d %d %d 0 0 %d %d.00 -1 0 0\n",
		  type,Min( ScilabGC_xfig_.CurDashStyle,1),
		  ScilabGC_xfig_.CurLineWidth*prec_fact/2,
		  ScilabGC_xfig_.CurColor,areafill,
		  8* ScilabGC_xfig_.CurDashStyle);
	  Write2Vect_xfig_(&vx[i*lg],&vy[i*lg],lg,flag);
	  fprintf(file," 9999 9999\n");
	};
    }
  else 
  if ( strcmp(string,"drawbox")==0)
    {
      for ( i =0 ; i < nobj ; i++)
	{
	  int deb,areafill;
	  if (fvect[i] >= ScilabGC_xfig_.IDWhitePattern+1 )
	    areafill = 0;
	  else 
	    areafill = Max(Min(21, (-10*fvect[i]+157)/7),1);
	  fprintf(file,"# Object : %d %s -<%d>- \n",i,string,fvect[i]);
	  fprintf(file,"2 2 0 %d %d 0 0 %d 0.000 0 0 0\n",
		  ScilabGC_xfig_.CurLineWidth*prec_fact/2,
		    ScilabGC_xfig_.CurColor,areafill);
	  deb=i*sizeobj;
	  fprintf(file," %d %d %d %d %d %d %d %d %d %d \n",
		  vx[deb],vx[1+deb],
		  vx[deb]+vx[2+deb],vx[1+deb],
		  vx[deb]+vx[2+deb],vx[1+deb]+vx[3+deb],
		  vx[deb]           ,vx[1+deb]+vx[3+deb],
		  vx[deb],vx[1+deb]);
	  fprintf(file," 9999 9999\n");
	};
    }
  else if ( strcmp(string,"drawsegs")==0)      
    {
      for ( i =0 ; i < sizev/2 ; i++)
	{
	  fprintf(file,"# Object : %d %s -<%d>- \n",i,string,fvect[0]);
	  fprintf(file,"2 1 0 %d %d 0 0 0 0.000 0 0 0\n",
	        ScilabGC_xfig_.CurLineWidth*prec_fact/2,
		    ScilabGC_xfig_.CurColor);
	  fprintf(file," %d %d %d %d ",
		  vx[2*i],vy[2*i],vx[2*i+1],vy[2*i+1]);
	  fprintf(file," 9999 9999\n");	  
	};
    }
  else if ( strcmp(string,"drawarrows")==0)      
    {
      for ( i = 0 ; i < sizev/2 ; i++)
	{
	  fprintf(file,"# Object : %d %s -<%d>-\n",i,string,fvect[0]);
	  fprintf(file,"2 1 0 %d %d 0 0 0 0.000 0 1 0\n",
	        ScilabGC_xfig_.CurLineWidth*prec_fact/2,
		    ScilabGC_xfig_.CurColor);
	  fprintf(file,"    0 0 %d %d %d\n",
		  1*prec_fact,3*prec_fact,6*prec_fact);
	  fprintf(file," %d %d %d %d ",
		  vx[2*i],vy[2*i],vx[2*i+1],vy[2*i+1]);
	  fprintf(file," 9999 9999\n");	  
	};
    }
  else if ( strcmp(string,"drawarc")==0)      
    {
      for ( i = 0 ; i < nobj ; i++)
	{
	  int areafill;
	  if (fvect[i] >= ScilabGC_xfig_.IDWhitePattern+1 )
	    areafill = 0;
	  else 
	    areafill = Max(Min(21, (-10*fvect[i]+157)/7),1);
	  fprintf(file,"# Object : %d %s -<%d>-\n",i,string,fvect[0]);
	  fprintf(file,
		  "1 2 0 %d %d 0 0 %d 0.000 1 0.00 %d %d %d %d %d %d %d %d \n",
		  ScilabGC_xfig_.CurLineWidth*prec_fact/2,
		  ScilabGC_xfig_.CurColor,
		  areafill,vx[6*i]+vx[6*i+2]/2,vx[6*i+1]+vx[6*i+3]/2,
		  vx[6*i+2]/2,vx[6*i+3]/2,
		  vx[6*i]+vx[6*i+2]/2,vx[6*i+1],
		  vx[6*i]+vx[6*i+2]/2,vx[6*i+1]);
	};
    }
  else if ( strcmp(string,"drawpolymark")==0)      
    {
      int rect[4],x=0,y=0;
      boundingbox_xfig_("x",&x,&y,rect);
      fprintf(file,"# Object : %d %s -<%d>- \n",0,string,fvect[0]);
      for ( i =0 ; i < sizev ; i++)
	{
	  fprintf(file,"4 0 %d %d 0 %d 0 %5.2f 4 %d %d %d %d %c\1\n",
		  32,
		  isize_xfig_[ScilabGC_xfig_.CurHardSymbSize]*prec_fact,
		  ScilabGC_xfig_.CurColor,
		  0.0,rect[3],rect[2],vx[i],vy[i],
		  Char2Int( symb_list_xfig_[ScilabGC_xfig_.CurHardSymb]));

	}
    }
  else
    SciF1s("Can't translate %s\r\n",string);
};


Write2Vect_xfig_(vx,vy,n,flag)
     int n,flag;
     int vx[],vy[];
{
  int i,k;
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
	};
      fprintf(file,"\n");
    };
};

/*------------------------END--------------------*/
