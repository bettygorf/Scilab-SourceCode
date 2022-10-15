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

/*-------------BEGIN--------------------------------------------------------
\def\encadre#1{\paragraph{}\fbox{\begin{minipage}[t]{15cm}#1 \end{minipage}}}
\section{General routine for calling the X11 or Postscript Driver}
---------------------------------------------------------------------------*/
#include <string.h>
#include <stdio.h>
#include "../machine.h"

#ifndef THINK_C
#include "periX11.h"
#else
#include "periMac.h"
#endif

#include "periPos.h"
#include "periFig.h"

/*---------------------------------------------------------------
\encadre{ The objects stored in OpTab are stored according to 
lexicographic order (name)}
----------------------------------------------------------------*/

int SetDriver_();

typedef  struct  {
  char *name;
  int  (*fonc)();} OpTab ;

int vide_() {};
extern int Tape_Replay();
extern int CleanPlots();


OpTab keytab_x_[] ={
  "xarc",drawarc_,
  "xarcs", drawarcs_,
  "xarea",fillpolyline_,
  "xarrow",drawarrows_,
  "xaxis",drawaxis_,
  "xclea", cleararea_,
  "xclear",clearwindow_,
  "xclick",xclick_,
  "xend", xend_,
  "xfarc",fillarc_,
  "xfrect",fillrectangle_,
  "xget",MissileGCget_,
  "xinit",initgraphic_,
  "xlfont",loadfamily_,
  "xlines",drawpolyline_,
  "xliness",fillpolylines_,
  "xmarks",drawpolymark_,
  "xnum",displaynumbers_,
  "xpause", xpause_,
  "xpolys", drawpolylines_,
  "xrect",drawrectangle_,
  "xrects",drawrectangles_,
  "xreplay",Tape_Replay,
  "xsegs",drawsegments_,
  "xselect",xselgraphic_,
  "xset",MissileGCset_,
  "xsetdr",SetDriver_,
  "xstart",CleanPlots,
  "xstring",displaystring_,
  "xstringl",boundingbox_,
  (char *) NULL,vide_};

OpTab keytab_pos_[] ={
  "xarc",drawarc_pos_,
  "xarcs", drawarcs_pos_,
  "xarea",fillpolyline_pos_,
  "xarrow",drawarrows_pos_,
  "xaxis",drawaxis_pos_,
  "xclea", cleararea_pos_,
  "xclear",clearwindow_pos_,
  "xclick",xclick_pos_,
  "xend", xend_pos_,
  "xfarc",fillarc_pos_,
  "xfrect",fillrectangle_pos_,
  "xget",scilabgcget_pos_,
  "xinit",initgraphic_pos_,
  "xlfont",loadfamily_pos_,
  "xlines",drawpolyline_pos_,
  "xliness",fillpolylines_pos_,
  "xmarks",drawpolymark_pos_,
  "xnum",displaynumbers_pos_,
  "xpause", xpause_pos_,
  "xpolys" ,drawpolylines_pos_,
  "xrect",drawrectangle_pos_,
  "xrects",drawrectangles_pos_,
  "xreplay",Tape_Replay,
  "xsegs",drawsegments_pos_,
  "xselect",xselgraphic_pos_,
  "xset",scilabgcset_pos_,
  "xsetdr",SetDriver_,
  "xstart",CleanPlots,
  "xstring",displaystring_pos_,
  "xstringl",boundingbox_pos_,
  (char *) NULL,vide_};

OpTab keytab_xfig_[] ={
  "xarc",drawarc_xfig_,
  "xarcs", drawarcs_xfig_,
  "xarea",fillarea_xfig_,
  "xarrow",drawarrows_xfig_,
  "xaxis",drawaxis_xfig_,
  "xclea", cleararea_xfig_,
  "xclear",clearwindow_xfig_,
  "xclick",waitforclick_xfig_,
  "xend", xend_xfig_,
  "xfarc",drawfilledarc_xfig_,
  "xfrect",drawfilledrect_xfig_,
  "xget",scilabgcget_xfig_,
  "xinit",initgraphic_xfig_,
  "xlfont",loadfamily_xfig_,
  "xlines",drawpolyline_xfig_,
  "xliness",drawpolylines_xfig_,
  "xmarks",drawpolymark_xfig_,
  "xnum",displaynumbers_xfig_,
  "xpause", xpause_xfig_,
  "xpolys" ,morlpolylines_xfig_,
  "xrect",drawrectangle_xfig_,
  "xrects",drawrectangles_xfig_,
  "xreplay",Tape_Replay,
  "xsegs",drawsegments_xfig_,
  "xselect",xselgraphic_xfig_,
  "xset",scilabgcset_xfig_,
  "xsetdr",SetDriver_,
  "xstart",CleanPlots,
  "xstring",displaystring_xfig_,
  "xstringl",boundingbox_xfig_,
  (char *) NULL,vide_};

static char drname_[]= "Rec";

/* The following function can be called by fortran so we 
   use the Sun C-fortran interface conventions 
   dr has 2 last extra parametres to deal with the size of
   x0 and x1 */

 int  xint_type=0;

C2F(dr)(x0,x1,x2,x3,x4,x5,x6,x7,lx0,lx1)
     char x0[],x1[];
     int *x2,*x3,*x4,*x5,*x6,*x7;
     int lx0,lx1;
{ 
  switch (drname_[0])
    {
    case 'X':

      all_(keytab_x_,x0,x1,x2,x3,x4,x5,x6,x7);
      break;
    case 'I':
      xint_type=1;
      all_(keytab_x_,x0,x1,x2,x3,x4,x5,x6,x7);
      break;
    case 'P'  :
      all_(keytab_pos_,x0,x1,x2,x3,x4,x5,x6,x7);
      break;
    case 'F'  :
      all_(keytab_xfig_,x0,x1,x2,x3,x4,x5,x6,x7);
      break;
    case 'R'  :
      xint_type=1;
      all_(keytab_x_,x0,x1,x2,x3,x4,x5,x6,x7);
      break;
    default:
      fprintf(stderr,"\n Wrong driver name");
      break;
    };
};

SetDriver_(x0)
     char x0[];
{
  switch (x0[0])
    {
    case 'X':
      strcpy(drname_,"X11");
      break;
    case 'I':
      strcpy(drname_,"IX11");
      break;
    case 'P'  :
      strcpy(drname_,"Pos");
      break;
    case 'F'  :
      strcpy(drname_,"Fig");
      break;
    case 'R'  :
      strcpy(drname_,"Rec");
      break;
    default:
      fprintf(stderr,"\n Wrong driver name I'll use X11");
      strcpy(drname_,"X11");
      break;
    };  
};

char GetDriver_() {return(drname_[0]);};

all_(tab,x0,x1,x2,x3,x4,x5,x6,x7)
   char x0[],x1[];
   int *x2,*x3,*x4,*x5,*x6,*x7;
     OpTab tab[];
{ int i=0;
  while ( tab[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(x0,tab[i].name);
       if ( j == 0 ) 
	 { 
	   (*(tab[i].fonc))(x1,x2,x3,x4,x5,x6,x7);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       fprintf(stderr,"\nUnknow X operator <%s>",x0);
	       return;
	     }
	   else i++;
	 };
     };
  fprintf(stderr,"\n Unknow X operator <%s>",x0);
};

C2F(inttest)(x1)
     int *x1;
{
  fprintf(stderr,"Value  of x1 = <%d>\n",*x1);
}

/*----------------------------------END---------------------------*/

