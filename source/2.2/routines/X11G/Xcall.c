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
#include <malloc.h> /* in case od dbmalloc use */
#include <stdio.h>


#ifndef THINK_C
#include "Math.h"
#include "periX11.h"
#else
#include "machine.h"
#include "periMac.h"
#endif

#include "periPos.h"
#include "periFig.h"

/*---------------------------------------------------------------
\encadre{ The objects stored in OpTab are stored according to 
lexicographic order (name)}
----------------------------------------------------------------*/

int SetDriver_();
int GetDriver1_();

typedef  struct  {
  char *name;
  int  (*fonc)();} OpTab ;

int vide_(v1,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char *v1;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{}

extern int Tape_Replay();
extern int Tape_ReplayNewAngle();
extern int Tape_ReplayNewScale();
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
  "xclickany",xclick_any_,
  "xend", xend_,
  "xfarc",fillarc_,
  "xfarcs", fillarcs_,
  "xfrect",fillrectangle_,
  "xget",MissileGCget_,
  "xgetdr",GetDriver1_,
  "xgetmouse",xgetmouse_,
  "xinfo",xinfo_,
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
  "xreplayna",Tape_ReplayNewAngle,
  "xreplaysc",Tape_ReplayNewScale,
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
  "xclickany",xclick_any_pos_,
  "xend", xend_pos_,
  "xfarc",fillarc_pos_,
  "xfarcs",fillarcs_pos_,
  "xfrect",fillrectangle_pos_,
  "xget",scilabgcget_pos_,
  "xgetdr",GetDriver1_,
  "xgetmouse",xgetmouse_pos_,
  "xinfo",vide_,
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
  "xreplayna",Tape_ReplayNewAngle,
  "xreplaysc",Tape_ReplayNewScale,
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
  "xclickany",xclick_any_xfig_,
  "xend", xend_xfig_,
  "xfarc",drawfilledarc_xfig_,
  "xfarcs", fillarcs_xfig_,
  "xfrect",drawfilledrect_xfig_,
  "xget",scilabgcget_xfig_,
  "xgetdr",GetDriver1_,
  "xgetmouse",xgetmouse_xfig_,
  "xinfo",vide_,
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
  "xreplayna",Tape_ReplayNewAngle,
  "xreplaysc",Tape_ReplayNewScale,
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


C2F(dr)(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1)
     char x0[],x1[];
     integer *x2,*x3,*x4,*x5,*x6,*x7;
     integer lx0,lx1;
     double *dx1,*dx2,*dx3,*dx4;
{ 
  switch (drname_[0])
    {
    case 'X':
      all_(keytab_x_,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
      break;
    case 'P'  :
      all_(keytab_pos_,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
      break;
    case 'F'  :
      all_(keytab_xfig_,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
      break;
    case 'R'  :
      all_(keytab_x_,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
      break;
    default:
      Scistring("\n Wrong driver name");
      break;
    }
}

SetDriver_(x0,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char x0[];
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  switch (x0[0])
    {
    case 'X':
      strcpy(drname_,"X11");
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
    case 'W'  :
      Scistring("\n Driver Wdp doesn't exists any more ");
      Scistring("   use xset('pixmap',0 or 1 ) to enable or disable ");
      Scistring("   a Wdp window ");
      strcpy(drname_,"Rec");
      break;
    default:
      Scistring("\n Wrong driver name I'll use X11");
      strcpy(drname_,"X11");
      break;
    }  
}

int GetDriver1_(str,v2,v3,v4,v5,v6,v7,dv1,dv2,dv3,dv4)
     char str[];
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  strcpy(str,drname_);
}

char GetDriver_() {return(drname_[0]);}

#ifdef lint 

test_all_(tab,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4)
     char x0[],x1[];
     integer *x2,*x3,*x4,*x5,*x6,*x7;
     double *dx1,*dx2,*dx3,*dx4;
     OpTab tab[];
{
  drawarc_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillarcs_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawarcs_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillpolyline_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawarrows_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawaxis_(x1,x2,x3, x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  cleararea_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  clearwindow_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xclick_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xend_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillarc_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillrectangle_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  MissileGCget_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  GetDriver1_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xgetmouse_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xinfo_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  initgraphic_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  loadfamily_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolyline_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillpolylines_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolymark_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  displaynumbers_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xpause_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolylines_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawrectangle_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawrectangles_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_Replay(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewAngle(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewScale(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawsegments_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xselgraphic_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  MissileGCset_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  SetDriver_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  CleanPlots(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  displaystring_(x1,x2,x3, x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  boundingbox_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);

  drawarc_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillarcs_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawarcs_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillpolyline_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawarrows_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawaxis_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  cleararea_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  clearwindow_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xclick_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xend_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillarc_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillrectangle_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  scilabgcget_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  GetDriver1_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xgetmouse_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  vide_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  initgraphic_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  loadfamily_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolyline_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillpolylines_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolymark_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  displaynumbers_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xpause_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolylines_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawrectangle_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawrectangles_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_Replay(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewAngle(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewScale(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawsegments_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xselgraphic_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  scilabgcset_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  SetDriver_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  CleanPlots(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  displaystring_pos_(x1,x2,x3, x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  boundingbox_pos_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);

  drawarc_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillarcs_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawarcs_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  fillarea_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawarrows_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawaxis_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  cleararea_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  clearwindow_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  waitforclick_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xend_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawfilledarc_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawfilledrect_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  scilabgcget_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  GetDriver1_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xgetmouse_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  vide_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  initgraphic_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  loadfamily_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolyline_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolylines_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawpolymark_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  displaynumbers_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xpause_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  morlpolylines_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawrectangle_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawrectangles_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_Replay(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewAngle(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewScale(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  drawsegments_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  xselgraphic_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  scilabgcset_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  SetDriver_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  CleanPlots(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  displaystring_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  boundingbox_xfig_(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
}

#endif 

all_(tab,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4)
     char x0[],x1[];
     integer *x2,*x3,*x4,*x5,*x6,*x7;
     double *dx1,*dx2,*dx3,*dx4;
     OpTab tab[];
{ int i=0;
  while ( tab[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(x0,tab[i].name);
       if ( j == 0 ) 
	 { 
	   (*(tab[i].fonc))(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
	   return;}
       else 
	 { if ( j <= 0)
	     {
	       sciprint("\nUnknow X operator <%s>\r\n",x0);
	       return;
	     }
	   else i++;
	 }
     }
  sciprint("\n Unknow X operator <%s>\r\n",x0);
}

C2F(inttest)(x1)
     int *x1;
{
  sciprint("Value  of x1 = <%d>\r\n",*x1);
}

/*----------------------------------END---------------------------*/

