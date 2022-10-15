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

#define Char2Int(x)   ( x & 0x000000ff )


static int use_color=0;

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
  int IDWhitePattern;
  int CurWindow;
  int CurVectorStyle;
  int CurDrawFunction;
  int ClipRegionSet;
  int CurClipRegion[4];
  int CurDashStyle;
  char CurNumberDispFormat[20];
}  ScilabGC_pos_ ;


/*-----------------------------------------------------
\encadre{General routines}
-----------------------------------------------------*/

/** To select the graphic Window  **/

xselgraphic_pos_(){};

/** End of graphic (close the file) **/

xendgraphic_pos_()
{
  if (file != stdout) {
    fprintf(file,"\n showpage\n");
    fprintf(file,"\n clear end saved restore \n");
    fclose(file);
    file=stdout;}
}

xend_pos_()
{
 xendgraphic_pos_();
}


/** Clear the current graphic window     **/
/** In Postscript : nothing      **/

clearwindow_pos_() 
{
  /* fprintf(file,"\n showpage"); */
  /** Sending the scale etc.. in case we want an other plot **/
  /* FileInit(file); */
};

/** To generate a pause : Empty here **/

xpause_pos_(str,sec_time)
     char str[];
     int *sec_time;
{};

/** Wait for mouse click in graphic window : Empty here **/

xclick_pos_(str,ibutton,xx1,yy1)
     char str[];
  int *ibutton,*xx1,*yy1 ;
{ };

/** Clear a rectangle **/

cleararea_pos_(str,x,y,w,h)
     char str[];
     int *x,*y,*w,*h;
{
  fprintf(stderr,"Attention clearzone n'est pas traduit en Postscript\n");
  fprintf(file,"%%A Faire %d %d %d %d clearzone",*x,*y,*w,*h);
};


/*---------------------------------------------------------------------
\section{Function for graphic context modification}
------------------------------------------------------------------------*/

/** to get the window upper-left point coordinates **/

getwindowpos_pos_(verbose,x,narg)
  int *verbose,*x,*narg;
{
  *narg = 2;
  x[0]= x[1]=0;
  if (*verbose == 1) 
    fprintf(stderr,"\n CWindow position :%d,%d",x[0],x[1]);
 };

/** to set the window upper-left point position (Void) **/

setwindowpos_pos_(x,y)
     int *x,*y;
{
};

/** To get the window size **/
/** In Postscript we choose (600,424) **/
/** This size was chosen to have good compatibility with X11 **/
/** for line thickness etc \ldots **/

static int prec_fact =10;

getwindowdim_pos_(verbose,x,narg)
  int *verbose,*x,*narg;
{     
  *narg = 2;
  x[0]= 600*prec_fact;
  x[1]= 424*prec_fact;
  if (*verbose == 1) 
    fprintf(stderr,"\n CWindow dim :%d,%d",x[0],x[1]);
}; 

/** To change the window dimensions : do Nothing in Postscript  **/

setwindowdim_pos_(x,y)
     int *x,*y;
{
};


/** Select a graphic Window : Empty for Postscript **/

setcurwin_pos_(intnum)
     int *intnum;
{};

/** Get the id number of the Current Graphic Window **/

getcurwin_pos_(verbose,intnum,narg)
     int *verbose,*intnum,*narg;
{
  *narg =1 ;
  *intnum = ScilabGC_pos_.CurWindow ;
  if (*verbose == 1) 
    fprintf(stderr,"\nJust one graphic page at a time ");
};

/** Set a clip zone (rectangle ) **/

setclip_pos_(x,y,w,h)
     int *x,*y,*w,*h;
{
  ScilabGC_pos_.ClipRegionSet = 1;
  ScilabGC_pos_.CurClipRegion[0]= *x;
  ScilabGC_pos_.CurClipRegion[1]= *y;
  ScilabGC_pos_.CurClipRegion[2]= *w;
  ScilabGC_pos_.CurClipRegion[3]= *h;
  fprintf(file,"\n%d %d %d %d setclipzone",*x,*y,*w,*h);
};

/** Get the boundaries of the current clip zone **/

getclip_pos_(verbose,x,narg)
     int *verbose,*x,*narg;
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
    fprintf(stderr,"\nThere's a Clip Region :x:%d,y:%d,w:%d,h:%d",
	      ScilabGC_pos_.CurClipRegion[0],
	      ScilabGC_pos_.CurClipRegion[1],
	      ScilabGC_pos_.CurClipRegion[2],
	      ScilabGC_pos_.CurClipRegion[3]);
  else 
    fprintf(stderr,"\nNo Clip Region");
};

/*----------------------------------------------------------
\encadre{For the drawing functions dealing with vectors of 
 points, the following routine is used to select the mode 
 absolute or relative }
 Absolute mode if *num==0, relative mode if *num != 0
------------------------------------------------------------*/

setabsourel_pos_(num)
     	int *num;
{
  if (*num == 0 )
    ScilabGC_pos_.CurVectorStyle =  CoordModeOrigin;
  else 
    ScilabGC_pos_.CurVectorStyle =  CoordModePrevious ;
};

/** to get information on absolute or relative mode **/

getabsourel_pos_(verbose,num,narg)
     	int *verbose,*num,*narg;
{
  *narg = 1;
    *num = ScilabGC_pos_.CurVectorStyle  ;
    if (*verbose == 1) 
  if (ScilabGC_pos_.CurVectorStyle == CoordModeOrigin)
    fprintf(stderr,"\nTrace Absolu");
  else 
    fprintf(stderr,"\nTrace Relatif");
  };


/** The alu function for drawing : Works only with X11 **/
/** Not in Postscript **/

setalufunction_pos_(string)
 char string[];
{     
  int value;
  
  idfromname_pos_(string,&value);
  if ( value != -1)
    {ScilabGC_pos_.CurDrawFunction = value;
     fprintf(file,"\n%% %d setalufunction",value);
      };
};

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
     int *num;
{int i;
 *num = -1;
 for ( i =0 ; i < 16;i++)
   if (strcmp(AluStruc_pos_[i].name,name1)== 0) 
     *num=AluStruc_pos_[i].id;
 if (*num == -1 ) 
   {
     fprintf(stderr,"\n Use the following keys :");
     for ( i=0 ; i < 16 ; i++)
       fprintf(stderr,"\nkey %s -> %s",AluStruc_pos_[i].name,
	       AluStruc_pos_[i].info);
   };
};
/** To get the value of the alufunction **/

getalufunction_pos_(verbose,value,narg)
     int *verbose , *value ,*narg;
{ 
  *narg =1 ;
  *value = ScilabGC_pos_.CurDrawFunction ;
   if (*verbose ==1 ) 
     { fprintf(stderr,"\nThe Alufunction is %s -> <%s>\n",
	       AluStruc_pos_[*value].name,
	       AluStruc_pos_[*value].info);}
 };

/** to set the thickness of lines : 0 is a possible value **/
/** give the thinest line **/

setthickness_pos_(value)
  int *value ;
{ 
  ScilabGC_pos_.CurLineWidth =Max(0, *value);
  fprintf(file,"\n%d Thickness",Max(0,*value));
};

/** to get the thicknes value **/

getthickness_pos_(verbose,value,narg)
     int *verbose,*value,*narg;
{
  *narg =1 ;
  *value = ScilabGC_pos_.CurLineWidth ;
  if (*verbose ==1 ) 
    fprintf(stderr,"\nLine Width:%d",
	    ScilabGC_pos_.CurLineWidth ) ;
};
     

#define GREYNUMBER 17

/*-------------------------------------------------
\encadre{To set grey level for filing areas.
  from black (*num =0 ) to white 
  you must use the get function to get the id of 
  the white pattern }
----------------------------------------------------*/

setpattern_pos_(num)
     int *num;
{ int i ; 
  i= Max(0,Min(*num,GREYNUMBER-1));
  ScilabGC_pos_.CurPattern = i;
  if ( use_color ==1) set_c_pos_(i);
  else {
    if (i ==0)
      fprintf(file,"\nfillsolid");
    else 
      fprintf(file,"\n%d Setgray",i);
  };
};

/** To get the id of the current pattern  **/

getpattern_pos_(verbose,num,narg)
     int *num,*verbose,*narg;
{ 
  *narg=1;
  *num = ScilabGC_pos_.CurPattern ;
  if (*verbose == 1) 
      fprintf(stderr,"\n Pattern : %d",
	  ScilabGC_pos_.CurPattern);
};


/** To get the id of the white pattern **/

getwhite_pos_(verbose,num,narg)
     int *num,*verbose,*narg;
{
  *num = ScilabGC_pos_.IDWhitePattern ;
  if (*verbose==1) 
    fprintf(stderr,"\n Id of White Pattern %d :",*num);
  *narg=1;
};

/** To set dash-style : **/
/**  use a table of dashes and set default dashes to **/
/**  one of the possible value. value point **/
/**  to a strictly positive integer **/

static int DashTab_pos[6][4] = {
  {2,5,2,5}, {5,2,5,2},  {5,3,2,3}, {8,3,2,3},
  {11,3,2,3}, {11,3,5,3}};


setdash_pos_(value)
     int *value;
{
  static int maxdash = 6, l2=4,l3 ;
  l3 = Min(maxdash-1,*value-1);
  ScilabGC_pos_.CurDashStyle= l3 + 1 ;
  if ( use_color ==1) set_c_pos_(*value-1);
  else 
    setdashstyle_pos_(value,DashTab_pos[Max(0,l3)],&l2);
}

/** To change The Pos-default dash style **/
/** if *value == 0, use a solid line, if *value != 0 **/
/** the dash style is specified by the xx vector of n values **/
/** xx[3]={5,3,7} and *n == 3 means :  5white 3 void 7 white \ldots **/
  
setdashstyle_pos_(value,xx,n)
     int *value,xx[],*n;
{
  int i ;
  if ( *value == 0) fprintf(file,"\n[] 0 setdash");
  else 
    {
      fprintf(file,"\n[");
      for (i=0;i<*n;i++)
	fprintf(file,"%d ",xx[i]*prec_fact);
      fprintf(file,"] 0 setdash");
    };
};

/** to get the current dash-style **/

getdash_pos_(verbose,value,narg)
     int *verbose,*value,*narg;
{int i ;
 *value=ScilabGC_pos_.CurDashStyle;
 *narg =1 ;
 if ( *value == 0) 
   { if (*verbose == 1) fprintf(stderr,"\nLine style = Line Solid");}
 else 
   {
     value[1]=4;
     *narg = value[1]+2;
     for ( i =0 ; i < value[1]; i++) value[i+2]=DashTab_pos[*value-1][i];
     if (*verbose ==1 ) 
       {
	 fprintf(stderr,"\nDash Style %d:<",*value);
	 for ( i =0 ; i < value[1]; i++)
	   fprintf(stderr,"%d ",value[i+2]);
	 fprintf(stderr,">\n");
       }
   }
};


#define NUMCOLORS 17

typedef  struct {
  float  r,g,b;} TabC;

extern TabC tabc[NUMCOLORS];

usecolor_pos_(num)
     int *num;
{
  use_color= *num; 
  if ( use_color == 1) 
    {
      fprintf(file,"\n/Setgray {/i exch def ColorR i get ColorG i get ColorB i get setrgbcolor } def ");
      fprintf(file,"\n/Setcolor {/i exch def ColorR i get ColorG i get ColorB i get setrgbcolor } def ");
      /** Voir fichier color.c **/
      /** ColorInit(); **/
    }
  else 
    fprintf(file,"\n/Setgray { WhiteLev div setgray } def ");
};

ColorInit()
{
  int i;
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
};

set_c_pos_(i)
     int i;
{
  int j;
  j=Max(Min(i,NUMCOLORS-1),0);
  fprintf(file,"\n%d Setcolor",j);
} ;
/*--------------------------------------------------------
\encadre{general routines accessing the  set<> or get<>
 routines } 
-------------------------------------------------------*/

int InitScilabGC_pos_();

empty_pos_(verbose)
     int *verbose;
{
  if ( *verbose ==1 ) fprintf(stderr,"\n No operation ");
};

#define NUMSETFONC 14

/** Table in lexicographic order **/
int xsetfont_pos_(),xgetfont_pos_(),xsetmark_pos_(),xgetmark_pos_();

struct bgc { char *name ;
	     int  (*setfonc )() ;
	     int  (*getfonc )() ;}
  ScilabGCTab_pos_[] = {
   "alufunction",setalufunction_pos_,getalufunction_pos_,
   "clipping",setclip_pos_,getclip_pos_,
   "dashes",setdash_pos_,getdash_pos_,
   "default",InitScilabGC_pos_, empty_pos_,
   "font",xsetfont_pos_,xgetfont_pos_,
   "line mode",setabsourel_pos_,getabsourel_pos_,
   "mark",xsetmark_pos_,xgetmark_pos_,
   "pattern",setpattern_pos_,getpattern_pos_,
   "thickness",setthickness_pos_,getthickness_pos_,
   "use color",usecolor_pos_,empty_pos_,
   "wdim",setwindowdim_pos_,getwindowdim_pos_,
   "white",empty_pos_,getwhite_pos_,
   "window",setcurwin_pos_,getcurwin_pos_,
   "wpos",setwindowpos_pos_,getwindowpos_pos_
 };

scilabgcget_pos_(str,verbose,x1,x2,x3,x4,x5)
     int *verbose,*x1,*x2,*x3,*x4,*x5;
     char str[];
{
 ScilabGCGetorSet_pos_(str,1,verbose,x1,x2,x3,x4,x5);
};

scilabgcset_pos_(str,x1,x2,x3,x4,x5)
     int *x1,*x2,*x3,*x4,*x5;
     char str[];
{
 int verbose ;
 verbose = 0 ;
 ScilabGCGetorSet_pos_(str,0,&verbose,x1,x2,x3,x4,x5);}

ScilabGCGetorSet_pos_(str,flag,verbose,x1,x2,x3,x4,x5)
     char str[];
     int flag ;
     int  *verbose,*x1,*x2,*x3,*x4,*x5;
{ int i ;
  for (i=0; i < NUMSETFONC ; i++)
     {
       int j;
       j = strcmp(str,ScilabGCTab_pos_[i].name);
       if ( j == 0 ) 
	 { if (*verbose == 1)
	     fprintf(stderr,"\nGettting Info on %s",str);
	   if (flag == 1)
	     (ScilabGCTab_pos_[i].getfonc)(verbose,x1,x2,x3,x4,x5);
	   else 
	     (ScilabGCTab_pos_[i].setfonc)(x1,x2,x3,x4,x5);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       fprintf(stderr,"\nUnknow Postscript operator <%s>",str);
	       return;
	     };
	 };
     };
  fprintf(stderr,"\n Unknow Postscript operator <%s>",str);
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

displaystring_pos_(string,x,y,angle,flag)
  int *x,*y ,*flag;
     double *angle;
  char string[] ;
{     int i,rect[4] ;
      boundingbox_pos_(string,x,y,rect);
      fprintf(file,"\n(");
      for ( i=0; i < strlen(string);i++)
	{ if (string[i]== '(' || string[i] == ')' )
	    fprintf(file,"%c%c",'\\',string[i]);
	  else fprintf(file,"%c",string[i]);};
      fprintf(file,") %d %d %d %5.2f [%d %d %d %d] Show",
	      *x,*y,*flag,*angle,rect[0],rect[1],rect[2],rect[3]);
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

boundingbox_pos_(string,x,y,rect)
     int *x,*y,*rect;
     char string[];
{int verbose,nargs,font[2];
 verbose=0;
 xgetfont_pos_(&verbose,font,&nargs);
 rect[0]= *x+bsize_pos_[font[1]][0]*((double) prec_fact);
 rect[1]= *y+bsize_pos_[font[1]][1]*((double) prec_fact);
 rect[2]= bsize_pos_[font[1]][2]*((double)prec_fact)*strlen(string);
 rect[3]= bsize_pos_[font[1]][3]*((double)prec_fact);
};

/** Draw a single line in current style **/

drawline_pos_(xx1,yy1,x2,y2)
    int *xx1, *x2, *yy1, *y2 ;
  {
    fprintf(file,"\n %d %d %d %d L",*xx1,*yy1,*x2,*y2);
  };

/** Draw a set of segments **/
/** segments are defined by (vx[i],vy[i])->(vx[i+1],vy[i+1]) **/
/** for i=0 step 2 **/

drawsegments_pos_(str,vx,vy,n)
     char str[];
     int *n,vx[],vy[];
{
  int fvect[1];
  fvect[0]= ScilabGC_pos_.CurPattern;
  WriteGeneric_pos_("drawsegs",1,(*n)*2,vx,vy,*n,1,fvect);
};

/** Draw a set of arrows **/

drawarrows_pos_(str,vx,vy,n,as)
     char str[];
     int *as;
     int *n,vx[],vy[];
{
  WriteGeneric_pos_("drawarrows",1,(*n)*2,vx,vy,*n,1,as);
  /** set the pattern back to current value **/
  setpattern_pos_(&ScilabGC_pos_.CurPattern);
};

/** Draw one rectangle **/

/** Draw or fill a set of rectangle **/
/** rectangles are defined by (vect[i],vect[i+1],vect[i+2],vect[i+3]) **/
/** for i=0 step 4 **/
/** (*n) : number of rectangles **/
/** fillvect[*n] : specify the action <?> **/

drawrectangles_pos_(str,vects,fillvect,n)
     char str[];
     int *vects,*fillvect,*n;
{
  int cpat,verb=0,num;
  getpattern_pos_(&verb,&cpat,&num);
  WriteGeneric_pos_("drawbox",*n,4,vects,vects,4*(*n),0,fillvect);
  setpattern_pos_(&(cpat));
};

drawrectangle_pos_(str,x,y,width,height)
     char str[];
    int  *x, *y, *width, *height;
  { 
  int i = 1;
  int fvect[1] ;
  int vects[4];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;
  fvect[0] = ScilabGC_pos_.IDWhitePattern +1  ;
  drawrectangles_pos_(str,vects,fvect,&i);
  };

/** Draw a filled rectangle **/

fillrectangle_pos_(str,x,y,width,height)
     char str[];
    int  *x, *y, *width, *height;
{ 
  int i = 1;
  int fvect[1] ;
  int vects[4];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height ; 
  fvect[0] = ScilabGC_pos_.CurPattern ;
  drawrectangles_pos_(str,vects,fvect,&i);    
};

/** Draw or fill a set of ellipsis or part of ellipsis **/
/** Each is defined by 6-parameters, **/
/** fillvect[*n] : specify the action <?> **/
/** caution angle=degreangle*64          **/

drawarcs_pos_(str,vects,fillvect,n)
     char str[];
     int *vects,*fillvect,*n;
{
  int cpat,verb,num;
  verb=0;
  getpattern_pos_(&verb,&cpat,&num);
  WriteGeneric_pos_("drawarc",*n,6,vects,vects,6*(*n),0,fillvect);
  setpattern_pos_(&(cpat));
};

/** Draw a single ellipsis or part of it **/
/** caution angle=degreAngle*64          **/

drawarc_pos_(str,x,y,width,height,angle1,angle2)
     char str[];
    int *angle1,*angle2, *x, *y, *width, *height;
 { 
  int i =1;
  int fvect[1] ;
  int vects[6];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;vects[4]= *angle1;vects[5]= *angle2;
  fvect[0] = ScilabGC_pos_.IDWhitePattern  +1;
  drawarcs_pos_(str,vects,fvect,&i);
};

/** Fill a single elipsis or part of it **/
/** with current pattern **/

fillarc_pos_(str,x,y,width,height,angle1,angle2)
     char str[];
     int *angle1,*angle2, *x, *y, *width, *height;
 { 
  int i =1;
  int fvect[1] ;
  int vects[6];
  vects[0]= *x;vects[1]= *y;vects[2]= *width;
  vects[3]= *height;vects[4]= *angle1;vects[5]= *angle2;
  fvect[0] = ScilabGC_pos_.CurPattern ;
  drawarcs_pos_(str,vects,fvect,&i);
 };

/*--------------------------------------------------------------
\encadre{Filling or Drawing Polylines and Polygons}
---------------------------------------------------------------*/

/** Draw a set of *n polylines (each of which have (*p) points) **/
/** with lines or marks **/
/** drawvect[i] >= use a mark for polyline i **/
/** drawvect[i] < 0 use a line style for polyline i **/

drawpolylines_pos_(str,vectsx,vectsy,drawvect,n,p)
     char str[];
     int *vectsx,*vectsy,*drawvect,*n,*p;
{ int verbose ,symb[2],Mnarg,Dnarg,Dvalue[10],NDvalue,i,close;
  verbose =0 ;
  /* store the current values */
  xgetmark_pos_(&verbose,symb,&Mnarg);
  getdash_pos_(&verbose,Dvalue,&Dnarg);
  for (i=0 ; i< *n ; i++)
    {
      if (drawvect[i] >= 0)
	{ /** on utilise la marque de numero associ\'ee **/
	  xsetmark_pos_(drawvect+i,symb+1);
	  drawpolymark_pos_(str,p,vectsx+(*p)*i,vectsy+(*p)*i);
	}
      else
	{/** on utilise un style pointill\'e  **/
	  NDvalue = - drawvect[i] -1;
	  setdash_pos_(&NDvalue);
	  close = 0;
	  drawpolyline_pos_(str,p,vectsx+(*p)*i,vectsy+(*p)*i,&close);
	};
    };
/** back to default values **/
setdash_pos_(Dvalue);
xsetmark_pos_(symb,symb+1);
};

/** fill a set of polygons each of which is defined by **/
/** (*p) points (*n) is the number of polygons **/
/** the polygon is closed by the routine **/
/** if fillvect <= whiteid-pattern the coresponding pattern is used 
/** if fillvect == whiteid-pattern +1 -> draw the boundaries 
/** if fillvect >= whiteid-pattern +2 -> fill with white and draw boundaries
/** fillvect[*n] :         **/

fillpolylines_pos_(str,vectsx,vectsy,fillvect,n,p)
     char str[];
     int *vectsx,*vectsy,*fillvect,*n,*p;
{
  int cpat,verb=0,num;
  if ( ScilabGC_pos_.CurVectorStyle !=  CoordModeOrigin)
    fprintf(file,"\n/absolu false def");
  getpattern_pos_(&verb,&cpat,&num);
  WriteGeneric_pos_("drawpoly",*n,(*p)*2,vectsx,vectsy,(*p)*(*n),1,
			fillvect);
  setpattern_pos_(&(cpat));
  fprintf(file,"\n/absolu true def");
};

/** Only draw one polygon with current line style **/
/** according to *closeflag : it's a polyline or a polygon **/

drawpolyline_pos_(str,n, vx, vy,closeflag)
     char str[];
     int *n,*closeflag;
     int vx[], vy[];
{ int i =1;
  int fvect[1] ;
  fvect[0] = ScilabGC_pos_.IDWhitePattern  +1;
  if (*closeflag == 1 )
    fprintf(file,"\n/closeflag true def");
  else 
    fprintf(file,"\n/closeflag false def");
  fillpolylines_pos_(str,vx,vy,fvect,&i,n);
};

/** Fill the polygon **/

fillpolyline_pos_(str,n, vx, vy,closeareaflag)
     char str[];
     int *n,*closeareaflag;
     int vx[], vy[];
{
  int i =1;
  int fvect[1] ;
  fvect[0] = ScilabGC_pos_.CurPattern ;
  fillpolylines_pos_(str,vx,vy,fvect,&i,n);
}

/** Draw a set of  current mark centred at points defined **/
/** by vx and vy (vx[i],vy[i]) **/

drawpolymark_pos_(str,n, vx, vy)
     char str[];
     int *n ; 
     int vx[], vy[];
{ int keepid,keepsize,i;
  keepid =  ScilabGC_pos_.CurHardFont;
  keepsize= ScilabGC_pos_.CurHardFontSize;
  i=1;
  xsetfont_pos_(&i,&(ScilabGC_pos_.CurHardSymbSize));
  displaysymbols_pos_(str,n,vx,vy);
  xsetfont_pos_(&keepid,&keepsize);
};

/*-----------------------------------------------------
\encadre{Routine for initialisation}
------------------------------------------------------*/

initgraphic_pos_(string)
     char string[];
{ char string1[50];
  static int EntryCounter = 0;
  int fnum;
  if (EntryCounter >= 1) xendgraphic_pos_();
  strcpy(string1,string);
  /* Not so useful   
     sprintf(string2,"%d",EntryCounter);
     strcat(string1,string2); */
  file=fopen(string1,"w");
  if (file == 0) 
    {
      fprintf(stderr,"Can't open file %s, I'll use stdout\n",string1);
      file =stdout;
    };
  if (EntryCounter == 0)
    { 
      fnum=0;      loadfamily_pos_("Courier",&fnum); 
      fnum=1;      loadfamily_pos_("Symbol",&fnum); 
      fnum=2;      loadfamily_pos_("Times-Roman",&fnum);
      fnum=3;      loadfamily_pos_("Times-Italic",&fnum); 
      fnum=4;      loadfamily_pos_("Times-Bold",&fnum);
      fnum=5;      loadfamily_pos_("Times-BoldItalic",&fnum); 

    };
  FileInit(file);
  ScilabGC_pos_.CurWindow =EntryCounter;
  EntryCounter =EntryCounter +1;
};

FileInit(filen)
     FILE *filen;
{
  /** Just send Postscript commands to define scales etc....**/
  int x[2],verbose,narg;
  verbose = 0; 
  getwindowdim_pos_(&verbose,x,&narg);
  fprintf(filen,"\n%% Dessin en bas a gauche de taille %d,%d",x[0]/2,x[1]/2);
  fprintf(filen,"\n[0.5 %d div 0 0 0.5 %d div neg  0 %d %d div] concat",
	  prec_fact, prec_fact,x[1]/2, prec_fact );
  InitScilabGC_pos_()	;
  fprintf(filen,"\n/WhiteLev %d def",ScilabGC_pos_.IDWhitePattern);
};

/*--------------------------------------------------------
\encadre{Initialisation of the graphic context. Used also 
to come back to the default graphic state}
---------------------------------------------------------*/


InitScilabGC_pos_()
{ int i,j,k[2] ;
  ScilabGC_pos_.IDWhitePattern = GREYNUMBER-1;
  ScilabGC_pos_.CurLineWidth=0 ;
  i=0;
  setthickness_pos_(&i);
  setalufunction_pos_("GXcopy");
  /** retirer le clipping **/
  i=j= -1;
  k[0]=200000,k[1]=200000;
  setclip_pos_(&i,&j,k,k+1);
  ScilabGC_pos_.ClipRegionSet= 0;
  setdash_pos_((i=0,&i));
  xsetfont_pos_((i=2,&i),(j=1,&j));
  xsetmark_pos_((i=0,&i),(j=0,&j));
  /** trac\'e absolu **/
  ScilabGC_pos_.CurVectorStyle = CoordModeOrigin ;
  setpattern_pos_((i=0,&i));
  strcpy(ScilabGC_pos_.CurNumberDispFormat,"%-5.2g");
};

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
\item $init$. Initial point $<x,y>$. 
\end{itemize}
}

-------------------------------------------------------------*/

drawaxis_pos_(str,alpha,nsteps,size,initpoint)
     char str[];
     int *alpha,*nsteps,*initpoint;
     double *size;
{
  fprintf(file,"\n %d [%d %d] [%f %f %f] [%d %d] drawaxis",
	  *alpha,nsteps[0],nsteps[1],size[0],size[1],size[2],
	  initpoint[0],initpoint[1]);
};


/*-----------------------------------------------------
\encadre{Display numbers z[i] at location (x[i],y[i])
  with a slope alpha[i] (see displaystring_), if flag==1
  add a box around the string.
-----------------------------------------------------*/
displaynumbers_pos_(str,x,y,z,alpha,n,flag)     
     char str[];
     int x[],y[],*n,*flag;
     double z[],alpha[];
{ int i ;
  char buf[20];
  for (i=0 ; i< *n ; i++)
    { sprintf(buf,ScilabGC_pos_.CurNumberDispFormat,z[i]);
      displaystring_pos_(buf,&(x[i]),&(y[i]),&(alpha[i]),flag)      ;
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

/** Attention :: MAXSIZE doit etre divisible par 4  pour eviter des pbs **/
#define MAXSIZE 452
#define PERLINE 20
#define FORMATNUM "%d "

WriteGeneric_pos_(string,nobj,sizeobj,vx,vy,sizev,flag,fvect)
     int nobj,sizeobj,vx[],vy[],sizev,flag,fvect[];
     char string[];
{   
  int nobjpos,objbeg;
  objbeg= 0 ;
  /**-- si MAXSIZE/sizeobj vaut zero chaque objet est trop gros **/
  /** calcule le nombre d'object que l'on peut imprimer \`a la fois**/
  /** sans risquer un overflow dans un array postscript **/
  if (nobj ==0 || sizeobj ==0) return;
  nobjpos =Min( Max(1,MAXSIZE /sizeobj),nobj);
  while ( objbeg < nobj)
    {int objres;
     objres= nobj-objbeg;
     WriteGeneric1_pos_(string,Min(nobjpos,objres),objbeg,sizeobj,vx,vy,flag,fvect);
     objbeg = objbeg+nobjpos;
   };
  
};

WriteGeneric1_pos_(string,nobjpos,objbeg,sizeobj,vx,vy,flag,fvect)
     int nobjpos,sizeobj,vx[],vy[],objbeg,flag,fvect[];
     char string[];
{
  int from,n,i;
  if (flag == 1) 
    {  from= (objbeg*sizeobj)/2;
       n= (nobjpos*sizeobj)/2;}
  else 
    {  from= (objbeg*sizeobj)/2;
       n= (nobjpos*sizeobj);}
  fprintf(file,"\n/localsave save def ");
  fprintf(file,"\nclear (%s) %d [",string,Min(sizeobj,MAXSIZE));
  for ( i =objbeg  ; i < (nobjpos+objbeg) ; i++)
    fprintf(file," %d",fvect[i]);
  fprintf(file,"]\n");
  /* Reste un probleme car si un unique objet doit etre dessine
     et qu'il est trop gros cet objet est decoupe en bout mais 
     il manque alors les raccords eventuels */
  Write2Vect_pos_(vx,vy,from,n,string,flag,fvect[objbeg]);
};

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
     int from,n,flag,fv;
     int vx[],vy[];
     char string[];
{ int i,j,k,co,nco;
  if ( flag == 1) nco=2*n;else nco=n;
  co = 1;
  i =0;
  while( i < n)
    {
      if ( i > 0) 
	fprintf(file,"\n/localsave save def \nclear (%s) %d [%d]\n",
		string,Min(MAXSIZE,nco-(co-1)*MAXSIZE),fv);
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
		{k=k+1;i=i+1;j=j+1;};};
	  fprintf(file,"\n");
	};
      fprintf(file,"] dogrey localsave restore");
    };
};

/** Global variables to deal with fonts **/

#define FONTNUMBER 7
#define FONTMAXSIZE 6
#define SYMBOLNUMBER 10
int FontsList_pos_[FONTNUMBER][FONTMAXSIZE];
struct FontInfo { int ok;
		  char fname[20];} FontInfoTab_pos_[FONTNUMBER];

static char *size_pos_[] = { "08" ,"10","12","14","18","24"};
static int  isize_pos_[] = { 8 ,10,12,14,18,24};

/** To set the current font id of font and size **/

xsetfont_pos_(fontid,fontsize)
     int *fontid , *fontsize ;
{ int i,fsiz;
  i = Min(FONTNUMBER-1,Max(*fontid,0));
  fsiz = Min(FONTMAXSIZE-1,Max(*fontsize,0));
  if ( FontInfoTab_pos_[i].ok !=1 )
    fprintf(stderr,"\n Sorry This Font is Not available ");
  else 
   {
     ScilabGC_pos_.CurHardFont = i;
     ScilabGC_pos_.CurHardFontSize = fsiz;
     fprintf(file,"\n/%s findfont %d scalefont setfont",
	     FontInfoTab_pos_[i].fname,
	     isize_pos_[fsiz]*prec_fact);
   };
};

/** To get the values id and size of the current font **/

xgetfont_pos_(verbose,font,nargs)
     int *verbose,*font,*nargs;
{
  *nargs=2;
  font[0]= ScilabGC_pos_.CurHardFont ;
  font[1] =ScilabGC_pos_.CurHardFontSize ;
  if (*verbose == 1) 
    {
      fprintf(stderr,"\nFontId : %d --> %s at size %s pts",
	      ScilabGC_pos_.CurHardFont ,
	      FontInfoTab_pos_[ScilabGC_pos_.CurHardFont].fname,
	      size_pos_[ScilabGC_pos_.CurHardFontSize]);
    };
};


/** To set the current mark : using the symbol font of adobe **/

xsetmark_pos_(number,size)
     int *number ;
     int *size   ;
{ 
  ScilabGC_pos_.CurHardSymb =
    Max(Min(SYMBOLNUMBER-1,*number),0);
  ScilabGC_pos_.CurHardSymbSize = 
    Max(Min(FONTMAXSIZE-1,*size),0);
;}

/** To get the current mark id **/

xgetmark_pos_(verbose,symb,narg)
     int *verbose,*symb,*narg;
{
  *narg =2 ;
  symb[0] = ScilabGC_pos_.CurHardSymb ;
  symb[1] = ScilabGC_pos_.CurHardSymbSize ;
  if (*verbose == 1) 
  fprintf(stderr,"\nMark : %d at size %d pts",
	  ScilabGC_pos_.CurHardSymb,
	  isize_pos_[ScilabGC_pos_.CurHardSymbSize]);
};

char symb_list_pos_[] = {
 /*., +,X,*,diamond(filled),diamond,triangle up,triangle down,trefle,circle*/
  0xb7,0x2b,0xb4,0xc5,0xa8,0xe0,0x44,0xd1,0xa7,0x4f};


displaysymbols_pos_(str,n,vx,vy)
     char str[];
     int *n,vx[],vy[];
{
  int fvect[1];
  fvect[0] = 	  ScilabGC_pos_.CurPattern;
  if ( ScilabGC_pos_.CurVectorStyle !=  CoordModeOrigin)
    fprintf(file,"\n/absolu false def");
  fprintf(file,"\nHardMark 0 16#%x put",
      Char2Int( symb_list_pos_[ScilabGC_pos_.CurHardSymb]));
  WriteGeneric_pos_("drawpolymark",1,(*n)*2,vx,vy,*n,1,fvect);
  fprintf(file,"\n/absolu true def");
};



/*-------------------------------------------------------
\encadre{Check if a specified family of font exist in 
Postscript }
-------------------------------------------------------*/

loadfamily_pos_(name,j)
     char *name;
     int *j;
{
  int i ;
  for ( i = 0; i < FONTMAXSIZE ; i++)
    {
      FontsList_pos_[*j][i] = PosQueryFont_(name);
    };
  if  (FontsList_pos_[*j][0] == 0 )
	  fprintf(stderr,"\n unknown font family : %s ",name);
  else 
    {FontInfoTab_pos_[*j].ok = 1;
     strcpy(FontInfoTab_pos_[*j].fname,name) ;}
};

/*--------------------------------------------
\encadre{always answer ok. Must be Finished}
---------------------------------------------*/

int PosQueryFont_(name)
     char name[];
{ 
  return(1);
};


/*------------------------END--------------------*/
