/*------------------------------------------------------------------------
    Graphic library for 2D and 3D plotting 
    Copyright (C) 1998 Chancelier Jean-Philippe
    jpc@cergrene.enpc.fr 
 --------------------------------------------------------------------------*/

typedef  struct  
{
  double WW1Rect[4],WFRect1[4],Wxofset1,Wyofset1,Wscx1,Wscy1;
  char logflag1[2];
  integer WIRect1[4],Waaint1[4];
  double m[3][3];
  double bbox1[6];
  double alpha,theta;
  integer Win;
  struct WCScaleList *next;
} WCScaleList ;

extern WCScaleList Cscale;

extern void C2F(GetScaleWin)  _PARAMS((WCScaleList *, integer));
extern void C2F(SetScaleWin)  _PARAMS((WCScaleList **, integer, integer));


