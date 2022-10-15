/*------------------------------------------------------------------------
    Graphic library for 2D and 3D plotting 
    Copyright (C) 1998 Chancelier Jean-Philippe
    jpc@cergrene.enpc.fr 
 --------------------------------------------------------------------------*/

#include <string.h>

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif


#include <stdio.h>

#ifdef MAC
#include "../machine.h"
#include "periMac.h"
#else 
#ifdef WIN32
#include "Math.h"
#include "periWin.h"
#else
#include "Math.h"
#include "periX11.h"
#endif
#endif 

#include "periPos.h"
#include "periFig.h"

/*---------------------------------------------------------------
 * The basic graphic driver is X11 
 *    The name is X11 due to historical reasons 
 *    but according to architecture X11 can be an Xwindow driver 
 *    a driver for Macintosh 
 *    or a Windows driver 
 * Other drivers are Postscript Fig ( xfig ) and Rec ( Rec= X11 + Recording capabilities) 
 *    xfig is only meaningfull when using Unix machine 
 * ----------------------------------------------------------------*/

typedef  struct  {
  char *name;
  void  (*fonc)();} OpTab ;


static void C2F(all)();

static void C2F(vide)(v1, v2, v3, v4, v5, v6, v7, dv1, dv2, dv3, dv4)
     char *v1;
     integer *v2;
     integer *v3;
     integer *v4;
     integer *v5;
     integer *v6;
     integer *v7;
     double *dv1;
     double *dv2;
     double *dv3;
     double *dv4;
{}

OpTab keytab_x_[] ={
  {"xarc",C2F(drawarc)},
  {"xarcs", C2F(drawarcs)},
  {"xarea",C2F(fillpolyline)},
  {"xarrow",C2F(drawarrows)},
  {"xaxis",C2F(drawaxis)},
  {"xclea", C2F(cleararea)},
  {"xclear",C2F(clearwindow)},
  {"xclick",C2F(xclick)},
  {"xclickany",C2F(xclick_any)},
  {"xend", C2F(xend)},
  {"xfarc",C2F(fillarc)},
  {"xfarcs", C2F(fillarcs)},
  {"xfrect",C2F(fillrectangle)},
  {"xget",C2F(MissileGCget)},
  {"xgetdr",GetDriver1},
  {"xgetmouse",C2F(xgetmouse)},
  {"xinfo",C2F(xinfo)},
  {"xinit",C2F(initgraphic)},
  {"xlfont",C2F(loadfamily)},
  {"xlines",C2F(drawpolyline)},
  {"xliness",C2F(fillpolylines)},
  {"xmarks",C2F(drawpolymark)},
  {"xnum",C2F(displaynumbers)},
  {"xpause", C2F(xpause)},
  {"xpolys", C2F(drawpolylines)},
  {"xrect",C2F(drawrectangle)},
  {"xrects",C2F(drawrectangles)},
  {"xreplay",Tape_Replay},
  {"xreplayna",Tape_ReplayNewAngle},
  {"xreplaysc",Tape_ReplayNewScale},
  {"xreplaysh",Tape_Replay_Show},
  {"xsegs",C2F(drawsegments)},
  {"xselect",C2F(xselgraphic)},
  {"xset",C2F(MissileGCset)},
  {"xsetdr",C2F(SetDriver)},
  {"xstart",CleanPlots},
  {"xstring",C2F(displaystring)},
  {"xstringl",C2F(boundingbox)},
  {(char *) NULL,C2F(vide)}
};

OpTab keytabPos[] ={
  {"xarc",C2F(drawarcPos)},
  {"xarcs", C2F(drawarcsPos)},
  {"xarea",C2F(fillpolylinePos)},
  {"xarrow",C2F(drawarrowsPos)},
  {"xaxis",C2F(drawaxisPos)},
  {"xclea", C2F(clearareaPos)},
  {"xclear",C2F(clearwindowPos)},
  {"xclick",C2F(xclickPos)},
  {"xclickany",C2F(xclick_anyPos)},
  {"xend", C2F(xendPos)},
  {"xfarc",C2F(fillarcPos)},
  {"xfarcs",C2F(fillarcsPos)},
  {"xfrect",C2F(fillrectanglePos)},
  {"xget",C2F(scilabgcgetPos)},
  {"xgetdr",GetDriver1},
  {"xgetmouse",C2F(xgetmousePos)},
  {"xinfo",C2F(vide)},
  {"xinit",C2F(initgraphicPos)},
  {"xlfont",C2F(loadfamilyPos)},
  {"xlines",C2F(drawpolylinePos)},
  {"xliness",C2F(fillpolylinesPos)},
  {"xmarks",C2F(drawpolymarkPos)},
  {"xnum",C2F(displaynumbersPos)},
  {"xpause", C2F(xpausePos)},
  {"xpolys" ,C2F(drawpolylinesPos)},
  {"xrect",C2F(drawrectanglePos)},
  {"xrects",C2F(drawrectanglesPos)},
  {"xreplay",Tape_Replay},
  {"xreplayna",Tape_ReplayNewAngle},
  {"xreplaysc",Tape_ReplayNewScale},
  {"xreplaysh",Tape_Replay_Show},
  {"xsegs",C2F(drawsegmentsPos)},
  {"xselect",C2F(xselgraphicPos)},
  {"xset",C2F(scilabgcsetPos)},
  {"xsetdr",C2F(SetDriver)},
  {"xstart",CleanPlots},
  {"xstring",C2F(displaystringPos)},
  {"xstringl",C2F(boundingboxPos)},
  {(char *) NULL,C2F(vide)}
};



OpTab keytabXfig_[] ={
  {"xarc",C2F(drawarcXfig)},
  {"xarcs", C2F(drawarcsXfig)},
  {"xarea",C2F(fillpolylineXfig)},
  {"xarrow",C2F(drawarrowsXfig)},
  {"xaxis",C2F(drawaxisXfig)},
  {"xclea", C2F(clearareaXfig)},
  {"xclear",C2F(clearwindowXfig)},
  {"xclick",C2F(xclickXfig)},
  {"xclickany",C2F(xclick_anyXfig)},
  {"xend", C2F(xendXfig)},
  {"xfarc",C2F(fillarcXfig)},
  {"xfarcs", C2F(fillarcsXfig)},
  {"xfrect",C2F(fillrectangleXfig)},
  {"xget",C2F(scilabgcgetXfig)},
  {"xgetdr",GetDriver1},
  {"xgetmouse",C2F(xgetmouseXfig)},
  {"xinfo",C2F(vide)},
  {"xinit",C2F(initgraphicXfig)},
  {"xlfont",C2F(loadfamilyXfig)},
  {"xlines",C2F(drawpolylineXfig)},
  {"xliness",C2F(fillpolylinesXfig)},
  {"xmarks",C2F(drawpolymarkXfig)},
  {"xnum",C2F(displaynumbersXfig)},
  {"xpause", C2F(xpauseXfig)},
  {"xpolys" ,C2F(drawpolylinesXfig)},
  {"xrect",C2F(drawrectangleXfig)},
  {"xrects",C2F(drawrectanglesXfig)},
  {"xreplay",Tape_Replay},
  {"xreplayna",Tape_ReplayNewAngle},
  {"xreplaysc",Tape_ReplayNewScale},
  {"xreplaysh",Tape_Replay_Show},
  {"xsegs",C2F(drawsegmentsXfig)},
  {"xselect",C2F(xselgraphicXfig)},
  {"xset",C2F(scilabgcsetXfig)},
  {"xsetdr",C2F(SetDriver)},
  {"xstart",CleanPlots},
  {"xstring",C2F(displaystringXfig)},
  {"xstringl",C2F(boundingboxXfig)},
  {(char *) NULL,C2F(vide)}
};



static char DriverName[]= "Rec";

/* The following function can be called by fortran so we 
   use the Sun C-fortran interface conventions 
   dr has 2 last extra parametres to deal with the size of
   x0 and x1 */

int C2F(dr)(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1)
     char x0[],x1[];
     integer *x2,*x3,*x4,*x5,*x6,*x7;
     integer lx0,lx1;
     double *dx1,*dx2,*dx3,*dx4;
{ 
  switch (DriverName[0])
    {
    case 'I':
      /** special driver for windows : used when hdc is fixed elsewhere */
      C2F(all)(keytab_x_,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
      break;
    case 'P':
      C2F(all)(keytabPos,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
      break;
    case 'F':
      C2F(all)(keytabXfig_,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
      break;
    case 'G':
    case 'X':
    case 'W':
    case 'R':
      /** G,X,W are synonyms (Graphics,XWindow,Windows) , R ( Record) 
	means usual graphics + recording mode **/
#ifdef WIN32
      SetWinhdc();
#endif
      C2F(all)(keytab_x_,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
#ifdef WIN32
      ReleaseWinHdc();
#endif
      break;
    default:
      Scistring("\n Wrong driver name");
      break;
    }
 return(0);
}

void C2F(SetDriver)(x0, v2, v3, v4, v5, v6, v7, dv1, dv2, dv3, dv4)
     char *x0;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  switch (x0[0])
    {
    case 'I':
      strcpy(DriverName,"Int"); /* internal : for Win32 */
      break;
    case 'G':
    case 'X':
    case 'W':
      strcpy(DriverName,"X11");
      break;
    case 'P'  :
      strcpy(DriverName,"Pos");
      break;
    case 'F'  :
      strcpy(DriverName,"Fig");
      break;
    case 'R'  :
      strcpy(DriverName,"Rec");
      break;
    default:
      Scistring("\n Wrong driver name I'll use X11");
      strcpy(DriverName,"X11");
      break;
    }  
}

void GetDriver1(str, v2, v3, v4, v5, v6, v7, dv1, dv2, dv3, dv4)
     char *str;
     integer *v2,*v3,*v4,*v5,*v6,*v7;
     double *dv1,*dv2,*dv3,*dv4;
{
  strcpy(str,DriverName);
}

char GetDriver() {return(DriverName[0]);}

#ifdef lint 

void C2F(test_all)(tab,x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4)
     char x0[],x1[];
     integer *x2,*x3,*x4,*x5,*x6,*x7;
     double *dx1,*dx2,*dx3,*dx4;
     OpTab tab[];
{
  C2F(drawarc)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillarcs)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawarcs)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillpolyline)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawarrows)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawaxis)(x1,x2,x3, x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(cleararea)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(clearwindow)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xclick)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xend)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillarc)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillrectangle)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(MissileGCget)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  GetDriver1(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xgetmouse)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xinfo)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(initgraphic)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(loadfamily)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolyline)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillpolylines)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolymark)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(displaynumbers)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xpause)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolylines)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawrectangle)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawrectangles)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_Replay(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewAngle(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewScale(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawsegments)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xselgraphic)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(MissileGCset)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(SetDriver)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  CleanPlots(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(displaystring)(x1,x2,x3, x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(boundingbox)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);

  C2F(drawarcPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillarcsPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawarcsPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillpolylinePos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawarrowsPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawaxisPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(clearareaPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(clearwindowPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xclickPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xendPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillarcPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillrectanglePos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(scilabgcgetPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  GetDriver1(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xgetmousePos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(vide)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(initgraphicPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(loadfamilyPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolylinePos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillpolylinesPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolymarkPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(displaynumbersPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xpausePos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolylinesPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawrectanglePos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawrectanglesPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_Replay(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewAngle(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewScale(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawsegmentsPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xselgraphicPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(scilabgcsetPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(SetDriver)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  CleanPlots(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(displaystringPos)(x1,x2,x3, x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(boundingboxPos)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);

  C2F(drawarcXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillarcsXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawarcsXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(fillareaXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawarrowsXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawaxisXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(clearareaXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(clearwindowXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(waitforclickXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xendXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawfilledarcXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawfilledrectXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(scilabgcgetXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  GetDriver1(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xgetmouseXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(vide)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(initgraphicXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(loadfamilyXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolylineXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolylinesXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawpolymarkXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(displaynumbersXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xpauseXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(morlpolylinesXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawrectangleXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawrectanglesXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_Replay(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewAngle(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  Tape_ReplayNewScale(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(drawsegmentsXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(xselgraphicXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(scilabgcsetXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(SetDriver)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  CleanPlots(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(displaystringXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
  C2F(boundingboxXfig)(x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4);
}

#endif 

static void C2F(all)(tab, x0, x1, x2, x3, x4, x5, x6, x7, dx1, dx2, dx3, dx4)
     OpTab *tab;
     char *x0;
     char *x1;
     integer *x2;
     integer *x3;
     integer *x4;
     integer *x5;
     integer *x6;
     integer *x7;
     double *dx1;
     double *dx2;
     double *dx3;
     double *dx4;
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

int C2F(inttest)(x1)
     int *x1;
{
  sciprint("Value  of x1 = <%d>\r\n",*x1);
  return(0);
}

/*----------------------------------END---------------------------*/

