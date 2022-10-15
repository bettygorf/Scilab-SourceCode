#include "../machine.h"
#include "Math.h"

#include <stdio.h>
#include <math.h>

#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>

#include <X11/Xaw/AsciiText.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Dialog.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/List.h>
/* #include <X11/Xaw/Logo.h> */
#include <X11/Xaw/MenuButton.h>
#include <X11/Xaw/Scrollbar.h>
#include <X11/Xaw/SimpleMenu.h>
#include <X11/Xaw/SmeBSB.h>
#include <X11/Xaw/SmeLine.h>
#include <X11/Xaw/Paned.h>
#include <X11/Xaw/Toggle.h>
#include <X11/Xaw/Viewport.h>
#include <X11/Xaw/Cardinals.h>


#define PI0 (int *) 0
#define DR1(x0,x1,x2,x3,x4,x5,x6,x7,lx0,lx1)  \
  C2F(dr1)(x0,x1,(int *)(x2),(int *)(x3),(int *) (x4),(int *) (x5),(int *) (x6),(int *) (x7),lx0,lx1)

#define XN2D 63
#define NCURVES2D  3

static int 
test2DD()
{
  int sec=10,v=0;
  int style[NCURVES2D],aint[4],n1,n2;
  double x[NCURVES2D*XN2D],y[NCURVES2D*XN2D],brect[4],Wrect[4],Frect[4];
  int i,j,num,k;
  /* clearwindow_();*/
  for ( k= 0 ; k < 50 ; k++)
    {

      for ( j =0 ; j < NCURVES2D ; j++)
	for ( i=0 ; i < XN2D ; i++)
	  {
	    x[i+ XN2D*j]= ((double) i)/10.0;
	    y[i+ XN2D*j]= (double) sin((j+1)*x[i+XN2D*j]);
	  }
      for ( i=0 ; i < NCURVES2D ; i++)
	style[i]= -NCURVES2D+i;
      n1=NCURVES2D;n2=XN2D;
      aint[0]=aint[2]=2;aint[1]=aint[3]=10;
      num=0;
      C2F(dr1)("xpause","v",&sec,&v,&v,&v,&v,&v,0,0);
      
      Wrect[0]=Wrect[1]=0.5;Wrect[2]=Wrect[3]=0.5;
      for ( i=0 ; i < 4 ; i++)
	{
	  Frect[i]=Wrect[i];
	}
      C2F(setscale2d)(Wrect,Frect);
      C2F(plot2d)(x,y,&n1,&n2,style,"021"," ",brect,aint,0L,0L);
    }
}


#define XN2DD 2
#define NCURVES2DD  1

static int test2D()
{
  int sec=10,v=0;
  int style[NCURVES2DD],aint[4],n1,n2;
  double x[NCURVES2DD*XN2DD],y[NCURVES2DD*XN2DD],brect[4],Wrect[4],Frect[4];
  int i,j,num,k;
  for ( j =0 ; j < NCURVES2DD ; j++)
    {
      i=0;
      x[i+ XN2DD*j]= ((double) i)/10.0;
      y[i+ XN2DD*j]= -9.75;
      i=1;
      x[i+ XN2DD*j]= ((double) i)/10.0;
      y[i+ XN2DD*j]= 1.10;
      }
  for ( i=0 ; i < NCURVES2DD ; i++)
    style[i]= -NCURVES2DD+i;
  n1=NCURVES2DD;n2=XN2DD;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  num=0;
  C2F(dr1)("xpause","v",&sec,&v,&v,&v,&v,&v,0,0);
  C2F(plot2d)(x,y,&n1,&n2,style,"021"," ",brect,aint,0L,0L);
  C2F(dr1)("xset","wshow",&v,&v,&v,&v,&v,&v,0,0);
}

#define XN2D2 200
#define NCURVES2D2 1

static int test2D2()
{
  int style[NCURVES2D2],aint[4],n1,n2;
  double x[NCURVES2D2*XN2D2],y[NCURVES2D2*XN2D2],brect[4];
  int i,j,k;
  for ( k=0 ; k < 50 ; k++) 
    {
      for ( j =0 ; j < NCURVES2D2 ; j++)
	for ( i=0 ; i < XN2D2 ; i++)
	  {
	    x[i+ XN2D2*j]= 6*((double) i)/((double) XN2D2);
	    y[i+ XN2D2*j]= (double) sin(k/10.0 +(j+1)*3.14*x[i+XN2D2*j]);
	  }
      n1=NCURVES2D2;n2=XN2D2;
      brect[0]=0;brect[1]= -1.2;brect[2]=7.0;brect[3]=1.2;
      aint[0]=aint[2]=2;aint[1]=aint[3]=10;
      for ( i=0 ; i < NCURVES2D2 ; i++)
	style[i]= -i-1;
      C2F(plot2d2)("gnn",x,y,&n1,&n2,style,"111",
		   " y=sin(x/10)@y=sin(2*x/10)",brect,aint,0L,0L,0L);
      C2F(dr1)("xset","wshow",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
      C2F(dr1)("xset","wwpc",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
    }
}


#define XN2D3 3
#define NCURVES2D3 2

static int test2D3()
{
  int style[NCURVES2D3],aint[4],n1,n2;
  double x[NCURVES2D3*XN2D3],y[NCURVES2D3*XN2D3],brect[4];
  int i,j;
  for ( j =0 ; j < NCURVES2D3 ; j++)
    for ( i=0 ; i < XN2D3 ; i++)
      {
	x[i+ XN2D3*j]= ((double) i)/10.0;
	y[i+ XN2D3*j]= (double) sin((j+1)*x[i+XN2D3*j]);
      }
  n1=NCURVES2D3;n2=XN2D3;
  brect[0]=0;brect[1]= -1.2;brect[2]=7.0;brect[3]=1.2;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  for ( i=0 ; i < NCURVES2D3 ; i++)
    style[i]= -i-1;
  C2F(plot2d3)("gnn",x,y,&n1,&n2,style,"111",
	   " y=sin(x/10)@y=sin(2*x/10)",brect,aint,0L,0L,0L);

}


#define XN2D4 63
#define NCURVES2D4 2

static int test2D4()
{
  int style[NCURVES2D4],aint[4],n1,n2;
  double x[NCURVES2D4*XN2D4],y[NCURVES2D4*XN2D4],brect[4];
  int i,j;
  for ( j =0 ; j < NCURVES2D4 ; j++)
    for ( i=0 ; i < XN2D4 ; i++)
      {
	x[i+ XN2D4*j]= ((double) i)/10.0;
	y[i+ XN2D4*j]= (double) sin((j+1)*x[i+XN2D4*j]);
      }
  n1=NCURVES2D4;n2=XN2D4;
  brect[0]=0;brect[1]= -1.2;brect[2]=7.0;brect[3]=1.2;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  for ( i=0 ; i < NCURVES2D4 ; i++)
    style[i]= -i-1;
  C2F(plot2d4)("gnn",x,y,&n1,&n2,style,"111",
	   " y=sin(x/10)@y=sin(2*x/10)",brect,aint,0L,0L,0L);
}


#define XNN1 200
#define NCURVESN1 2

static int test2DN1()
{
  int style[NCURVESN1],aint[4],n1,n2;
  double x[NCURVESN1*XNN1],y[NCURVESN1*XNN1],brect[4];
  int i,j;
  for ( j =0 ; j < NCURVESN1 ; j++)
    for ( i=0 ; i < XNN1 ; i++)
      {
	double xx;
	x[i+ XNN1*j]= xx=10.3+i;
	if ( j ==0) 
	  y[i+ XNN1*j]= (double) log10((double) xx);
	else 
	  y[i+ XNN1*j]= (double) exp10((double) xx/2000);

      }
  for ( i=0 ; i < NCURVESN1 ; i++)
    style[i]= -NCURVESN1+i;
  n1=NCURVESN1;n2=XNN1;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  C2F(plot2d1)("gnn",x,y,&n1,&n2,style,"121",
	   "C1:y=log10(x)@C2:y=exp10(x/2.e3) ",brect,aint,0L,0L,0L);

}

static int test2DN2()
{
  int style[NCURVESN1],aint[4],n1,n2;
  double x[NCURVESN1*XNN1],y[NCURVESN1*XNN1],brect[4];
  int i,j;
  for ( j =0 ; j < NCURVESN1 ; j++)
    for ( i=0 ; i < XNN1 ; i++)
      {
	double xx;
	x[i+ XNN1*j]= xx=10.3+i;
	if ( j ==0) 
	  y[i+ XNN1*j]= (double) log10((double) xx);
	else 
	  y[i+ XNN1*j]= (double) exp10((double) xx/2000);

      }
  for ( i=0 ; i < NCURVESN1 ; i++)
    style[i]= -NCURVESN1+i;
  n1=NCURVESN1;n2=XNN1;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  C2F(plot2d1)("gln",x,y,&n1,&n2,style,"121",
	   "C1:y=log10(x)@C2:y=exp10(x/2.e3) ",brect,aint,0L,0L,0L);
}

static int test2DN3()
{
  int style[NCURVESN1],aint[4],n1,n2;
  double x[NCURVESN1*XNN1],y[NCURVESN1*XNN1],brect[4];
  int i,j;
  for ( j =0 ; j < NCURVESN1 ; j++)
    for ( i=0 ; i < XNN1 ; i++)
      {
	double xx;
	x[i+ XNN1*j]= xx=10.3+i;
	if ( j ==0) 
	  y[i+ XNN1*j]= (double) log10((double) xx);
	else 
	  y[i+ XNN1*j]= (double) exp10((double) xx/2000);

      }
  for ( i=0 ; i < NCURVESN1 ; i++)
    style[i]= -NCURVESN1+i;
  n1=NCURVESN1;n2=XNN1;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  C2F(plot2d1)("gnl",x,y,&n1,&n2,style,"121",
	   "C1:y=log10(x)@C2:y=exp10(x/2.e3) ",brect,aint,0L,0L,0L);
}




#define XN3D 21
#define YN3D 21
#define VX3D 10

static int test3D()
{
  double z[XN3D*YN3D],x[XN3D],y[YN3D],bbox[6];
  int flag[3],p,q;
  double teta,alpha;
  int i ,j ;
  for ( i=0 ; i < XN3D ; i++) x[i]=10*i;
  for ( j=0 ; j < YN3D ; j++) y[j]=10*j;
  for ( i=0 ; i < XN3D ; i++)
    for ( j=0 ; j < YN3D ; j++) z[i+XN3D*j]= (i-VX3D)*(i-VX3D)+(j-VX3D)*(j-VX3D);
  p= XN3D ; q= YN3D;  teta=alpha=35;
  flag[0]=2;flag[1]=2,flag[2]=4;
  p= XN3D ; q= YN3D;  teta=alpha=35;
  C2F(plot3d)(x,y,z,&p,&q,&teta,&alpha,"X@Y@Z",flag,bbox,0L);
}


#define XN3DA 21
#define YN3DA 21
#define VX3DA 10

static int test3DA()
{
  double z[XN3DA*YN3DA],x[XN3DA],y[YN3DA],bbox[6];
  int flag[3],p,q,k,c=1;
  double teta,alpha;
  int i ,j ;
  C2F(dr)("xsetdr","X11",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
  C2F(dr1)("xset","use color",(c=1,&c),PI0,PI0,PI0,PI0,PI0,0,0);
  for ( i=0 ; i < XN3DA ; i++) x[i]=i/((double) XN3DA) - 2.0;
  for ( j=0 ; j < YN3DA ; j++) y[j]=j/((double) YN3DA) - 2.0;
  for ( k = 0 ; k < 20 ; k++)
    {
      for ( i=0 ; i < XN3DA ; i++)
	for ( j=0 ; j < YN3DA ; j++) z[i+XN3DA*j]= cos( 2*3.14*x[i])*sin(3.14*2*y[j]*(k/40.0+1));
      p= XN3DA ; q= YN3DA;  teta=alpha=35;
      flag[0]=2;flag[1]=(k== 0)? 2:0,flag[2]=0;
      p= XN3DA ; q= YN3DA;  teta=alpha=35;
      C2F(plot3d1)(x,y,z,&p,&q,&teta,&alpha,"X@Y@Z",flag,bbox,0L);
      C2F(dr1)("xset","wshow",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
      C2F(dr1)("xset","wwpc",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
    }
  C2F(dr)("xsetdr","Rec",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
}


#define XN3D1 21
#define YN3D1 21
#define VX 10

static int test3D1()
{
  double z[XN3D1*YN3D1],x[XN3D1],y[YN3D1],bbox[6];
  int flag[3],p,q;
  double teta,alpha;
  int i ,j ;
  for ( i=0 ; i < XN3D1 ; i++) x[i]=10*i;
  for ( j=0 ; j < YN3D1 ; j++) y[j]=10*j;
  for ( i=0 ; i < XN3D1 ; i++)
    for ( j=0 ; j < YN3D1 ; j++) z[i+XN3D1*j]= (i-VX)*(i-VX)+(j-VX)*(j-VX);
  p= XN3D1 ; q= YN3D1;  teta=alpha=35;
  flag[0]=2;flag[1]=2,flag[2]=3;
  C2F(plot3d1)(x,y,z,&p,&q,&teta,&alpha,"X@Y@Z",flag,bbox,0L);
}


#define XN3D2 21
#define YN3D2 21
#define VX3D2 5

static int test3D2()
{
  double z[XN3D2*YN3D2],x[XN3D2],y[YN3D2],bbox[6];
  int flag[3],p,q;
  double teta,alpha;
  int i ,j ;
  for ( i=0 ; i < XN3D2 ; i++) x[i]=10*i;
  for ( j=0 ; j < YN3D2 ; j++) y[j]=10*j;
  for ( i=0 ; i < XN3D2 ; i++)
    for ( j=0 ; j < YN3D2 ; j++) z[i+XN3D2*j]= (i-VX3D2)*(i-VX3D2);
  p= XN3D2 ; q= YN3D2;  teta=alpha=35;
  flag[0]=2;flag[1]=2,flag[2]=3;
  C2F(plot3d1)(x,y,z,&p,&q,&teta,&alpha,"X@Y@Z",flag,bbox,0L);
}



static int testArrows()
{
  int narrowx2=20,arsizex10=300,j;
  double polyx[20],polyy[20];
  double dx=100,dy=0;
  fixbounds(0.0,500.0,0.0,500.0);
  for ( j =0 ; j < 10 ; j++)
    {polyx[2*j]=250;polyy[2*j]=250;}
  for ( j =0 ; j < 10 ; j++)
    {
      int alpha;
      alpha=36*j;
      polyx[2*j+1]=250+ cos(3.14116*alpha/180.0)*dx;
      polyy[2*j+1]=250 -sin(3.14116*alpha/180.0)*dx;
    }
  DR1("xarrow","str",polyx,polyy,&narrowx2,&arsizex10,PI0,PI0,0,0);
}

#define XNC 21
#define YNC 21
#define VXC 10

static int TestC(ii)
     int ii;
{
  double z[XNC*YNC],x[XNC],y[YNC];
  double zz,bbox[6],zlev=10.0;
  int p,q,i,j,nz,flagnz=0,teta=35,alpha=45,flag[3];
  zz=1;
  for ( i=0 ; i < XNC ; i++) x[i]=10*i;
  for ( j=0 ; j < YNC ; j++) y[j]=10*j;
  for ( i=0 ; i < XNC ; i++)
    for ( j=0 ; j < YNC ; j++) 
      z[i+XNC*j]= (i-VXC)*(i-VXC)-(j-VXC)*(j-VXC);
  p= XNC ; q= YNC; nz= 10;
  flag[0]=ii;
  flag[1]=2;
  flag[2]=3;
  C2F(contour)(x,y,z,&p,&q,&flagnz,&nz,&zz,&teta,&alpha, "X@Y@Z",
	   flag,bbox,&zlev);
}

static int testC1() { TestC(2);}
static int testC2() { TestC(0);}
static int testC3() { TestC(1);}


#define XNCh 21
#define YNCh 21

static int testCh()
{
  double fx[XNCh*YNCh], fy[XNCh*YNCh], vrect[4],arfact;
  int i ,j;
  char fax='1' ;
  for ( i=0 ; i < XNCh ; i++)
    for ( j=0 ; j < YNCh ; j++)
      { double x,y;
	x= -1+2*((double) i)/XNCh;
	y= -1+2*((double) j)/YNCh;
	fx[i+XNCh*j]= y;
	fy[i+XNCh*j]= -x +(1-x*x)*y;
	
      }
  vrect[0]=vrect[1]= -1 ,vrect[2]=vrect[3]=1;
  arfact=1.0;
  C2F(champ)(fx,fy,(i=XNCh,&i),(j=YNCh,&j),&fax,vrect,&arfact);
}


#define XNG 21
#define YNG 21
#define VXG 10

static int testG()
{
  double z[XNG*YNG],x[XNG],y[YNG];
  int p,q,i,j,nz ;
  for ( i=0 ; i < XNG ; i++) x[i]=10*i;
  for ( j=0 ; j < YNG ; j++) y[j]=10*j;
  for ( i=0 ; i < XNG ; i++)
    for ( j=0 ; j < YNG ; j++) 
      z[i+XNG*j]= (i-VXG)*(i-VXG)-(j-VXG)*(j-VXG);
  p= XNG ; q= YNG; nz= 5;
  C2F(xgray)(x,y,z,&p,&q);
}


#define XNP3D 201

static int testP3D()
{
  double z[XNP3D],x[XNP3D],y[XNP3D],bbox[6];
  int n,flag[3],i,j;
  double theta,alpha;
  for ( i=0 ; i < XNP3D ; i++)
    {
      x[i]=10.0*sin(i/10.0);
      y[i]=10.0*cos(i/10.0)+i/10.0;
      z[i]= i*i/1000.0;
    }
  theta=alpha=35;
  flag[0]=0;
  flag[1]=2;
  flag[2]=2;
  C2F(param3d)(x,y,z,(n=XNP3D,&n),&theta,&alpha,"X@Y@Z",flag,bbox,0L);
}



static int testPattern()
{
  double x=10,y=10,w=50,h=50;
  int i=0,j,k,num=0;
  fixbounds(-0.0,500.0,-50.0,200.0);
  for ( k =0 ; k < 4 ; k++)
    {
      for ( j =0 ; j < 5 ; j++)
	{ int pat;
	  pat=j+5*k;
	  DR1("xset","pattern",&pat,PI0,PI0,PI0,PI0,PI0,0,0);
	  DR1("xfrect","v",&x,&y,&w,&h,PI0,PI0,0,0);
	  DR1("xset","pattern",&i,PI0,PI0,PI0,PI0,PI0,0,0);
	  DR1("xrect","v",&x,&y,&w,&h,PI0,PI0,0,0);
	  x=x+w+5.0;
	}
      y=y+h+5.0;
      x=10.0;
    }
}

static int testColor()
{
  double x=10,y=10,w=50,h=50;
  int i=0,j,k,num=0;
  fixbounds(-0.0,500.0,-50.0,200.0);
  for ( k =0 ; k < 4 ; k++)
    {
      for ( j =0 ; j < 5 ; j++)
	{ int pat;
	  pat=j+5*k;
	  set_c(pat);
	  DR1("xrect","v",&x,&y,&w,&h,PI0,PI0,0,0);
	  DR1("xfrect","v",&x,&y,&w,&h,PI0,PI0,0,0);
	  x=x+w+5.0;
	}
      y=y+h+5.0;
      x=10.0;
    }
  set_c(0);
}


#define XMP 1
#define NCURVESP  2
  
static int testPrim()
{
  int style[NCURVESP],aint[4],n1,n2;
  double x[NCURVESP*XMP],y[NCURVESP*XMP],brect[4];
  int i,j,num;
  x[0]= -100.0;x[1]=500.0;
  y[0]= -100.0;y[1]=600.0;
  style[0]= -1;
  n1=NCURVESP;n2=XMP;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  num=0;
  C2F(plot2d)(x,y,&n1,&n2,style,"022"," ",brect,aint,0L,0L);
  corps();
}

transl(x,n,val)
     double x[];
     int n,val;
{
  int i;
  for (i=0 ; i < n ; i++)    x[i]=x[i]+val;
}


corps()
{
  double x[7],y[7],boxes[7*4],arcs[7*6],xpols[7*7],ypols[7*7];
  int pats[7],n,i,j,iflag,arsize;
  int verbose=0,narg,whiteid;
  C2F(dr)("xset","default",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
  n=7;
  C2F(dr)("xget","white",&verbose,&whiteid,&narg,PI0,PI0,PI0,0,0);
  for (i=0; i < 7; i++) x[i]=i*40.00;
  for (i=0; i < 7; i++)
    {
      boxes[4*i]=x[i];
      boxes[4*i+1]=10.000;
      boxes[4*i+2]=30.000;
      boxes[4*i+3]=30.000;
      pats[i]=whiteid+1;
    }
  DR1("xrects","v",boxes,pats,&n,PI0,PI0,PI0,0,0);
  for (i=0; i < 7; i++) boxes[4*i+1]=45.000;
  pats[0]=0;pats[1]=4;pats[2]=8;pats[3]=12;
  pats[4]=15;pats[5]=whiteid;pats[6]=0;
  DR1("xrects","v",boxes,pats,&n,PI0,PI0,PI0,0,0);
  for (i=0; i < 7; i++)
    {
      arcs[6*i]=x[i];
      arcs[6*i+1]=90.000;
      arcs[6*i+2]=30.000;
      arcs[6*i+3]=30.000;
      arcs[6*i+4]=0.000;
      arcs[6*i+5]=64.0*180.000;
    }
  DR1("xarcs","v",arcs,pats,&n,PI0,PI0,PI0,0,0);
  for (i=0; i < 7; i++)
    {
      arcs[6*i+1]=135.000;
      arcs[6*i+5]=64*360.000;
      pats[i]=whiteid+1;
    }
  DR1("xarcs","v",arcs,pats,&n,PI0,PI0,PI0,0,0);
  x[0]=x[6]=0.0;x[5]=x[1]=10.0,x[4]=x[2]=20.0;x[3]=30.0;
  y[0]=15.0;y[1]=y[2]=30.0;y[3]=15.0;y[4]=y[5]=0.0;y[6]=15.0;
  for (i=0;i< 7 ; i++) y[i]=y[i]+160.0;
  for (j=0;j<7;j++)
    {
      for (i=0;i< 7 ; i++) 
	{
	  xpols[i+j*7]=x[i]+40*j;
	  ypols[i+j*7]=y[i];
	}
    }
   DR1("xliness","v",xpols,ypols,pats,&n,&n,PI0,0,0);
  pats[0]=0;pats[1]=4;pats[2]=8;pats[3]=12;
  pats[4]=15;pats[5]=whiteid;pats[6]=0;
  for (j=0;j<7;j++)
      for (i=0;i< 7 ; i++) 
	  ypols[i+j*7]=ypols[i+j*7]+60;
  DR1("xliness","v",xpols,ypols,pats,&n,&n,PI0,0,0);
  for (j=0;j<7;j++)
      for (i=0;i< 7 ; i++) 
	  ypols[i+j*7]=ypols[i+j*7]+60;
  for (j=0;j<7;j++) pats[j]=j;
  DR1("xpolys","v",xpols,ypols,pats,&n,&n,PI0,0,0);
  for (j=0;j<7;j++)
    for (i=0;i< 7 ; i++) 
      ypols[i+j*7]=ypols[i+j*7]+60;
  for (j=0;j<7;j++) pats[j]= -j;
  DR1("xpolys","v",xpols,ypols,pats,&n,&n,PI0,0,0);
  for (i=0; i < 7; i++)
    {
      xpols[2*i]=40*i;
      xpols[2*i+1]=xpols[2*i]+30.0;
      ypols[2*i]=360.0+40.0;
      ypols[2*i+1]=360.0+70.0;
    }
  n=14;
  DR1("xsegs","v",xpols,ypols,&n,PI0,PI0,PI0,0,0);
  for (i=0; i < 7; i++)
    {
      ypols[2*i]=360.0+70.0;
      ypols[2*i+1]=360.0+100.0;
    }
  arsize=50;
  DR1("xarrow","v",xpols,ypols,&n,&arsize,PI0,PI0,0,0);
  x[0]=0;x[1]=100;x[2]=200;
  for (i=0; i < 3 ; i++) y[i]=500;
  xpols[0]=10.0;xpols[1]=20.0;xpols[2]=35;
  ypols[0]=ypols[1]=ypols[2]=0.0;
  n=3;
  iflag=1;
  DR1("xnum","v",x,y,xpols,ypols,&n,&iflag,0,0);
  for (i=0; i < 3 ; i++) y[i]=550;
  iflag=0;
  DR1("xnum","v",x,y,xpols,ypols,&n,&iflag,0,0);

  }



static int testString()
{
  int j,siz,v=0;
  double x=0.0,y=0.0;
  double angle;
  fixbounds(-200.0,200.0,-200.0,200.0);
  C2F(dr)("xset","font",(j=2,&j),(siz=10,&siz),PI0,PI0,PI0,PI0,0,0);
  for ( j =0 ; j < 360; j=j+45)
    DR1("xstring","   String",&x,&y,(angle=j,&angle),&v,PI0,PI0,0,0);
  C2F(dr)("xset","default",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
}


static int testXliness()
{
  char info[10];
  int i=0,j,k,ii=0;
  double ang=0.0;
  double x=20.0,y=20.0,w=40.0,h=30.0;
  int npoly=1,polysize=5;
  double polyx[5],polyy[5];
  int whiteid,verbose=0,narg;
  fixbounds(0.0,500.0,0.0,250.0);
  C2F(dr)("xget","white",&verbose,&whiteid,&narg,PI0,PI0,PI0,0,0);
  sprintf(info,"white=%d",whiteid);
  DR1("xstring",info,&x,&y,&ang,&ii,PI0,PI0,0,0);
  x=10;y=40;
  for ( k =0 ; k < 4 ; k++)
    {
      for ( j =0 ; j < 10 ; j++)
	{ int pat;
	  pat=j+10*k;
	  polyx[0]=x;polyx[1]=x+w;polyx[2]=x+w;polyx[3]=x;polyx[4]=x;
	  polyy[0]=y;polyy[1]=y;polyy[2]=y+h;polyy[3]=y+h;polyy[4]=y;
	  DR1("xliness","str",polyx,polyy,&pat,&npoly,&polysize,PI0,0,0);
	  polyy[0]=polyy[0]-10.0;
	  sprintf(info,"gl=%d",pat);
	  DR1("xstring",info,polyx,polyy,&ang,&ii,PI0,PI0,0,0);
  	  x=x+w+5;
	}
      y=y+h+20;
      x=10;
    }
}

static int testXrects()
{
  int i,j,k,nrect=1,num=0;
  double rect[4],xx=10.0,yy=10.0,w=40.0,h=40.0;
  fixbounds(-0.0,500.0,-50.0,200.0);
  for ( k =0 ; k < 4 ; k++)
    {
      for ( j =0 ; j < 10 ; j++)
	{ int pat;
	  pat=j+10*k;
	  rect[0]=xx;rect[1]=yy;rect[2]=w;rect[3]=h;
	  DR1("xrects","str",rect,&pat,&nrect,PI0,PI0,PI0,0,0);
  	  xx=xx+w+5.0;
	}
      yy=yy+h+5.0;
      xx=10.0;
    }
}


#define NF 1
#define NCU  2

fixbounds(xmin,xmax,ymin,ymax)
     double xmin,xmax,ymin,ymax;
{
  int style[NCU],aint[4],n1=1,n2=1;
  double x[NCU*NF],y[NCU*NF],brect[4];
  int i,j,k,nrect=1,num=0;
  double rect[4],xx=10.0,yy=10.0,w=40.0,h=40.0;
  x[0]=xmin;x[1]=xmax;
  y[0]=ymin;y[1]=ymax;
  style[0]= -1;
  n1=NCU;n2=NF;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  C2F(plot2d)(x,y,&n1,&n2,style,"022"," ",brect,aint,0L,0L);
}
  


  
static int testPoly()
{
  int style[1],aint[4],n1=1,n2=1;
  double brect[4],x[1],y[1];
  brect[0]= -5.0;brect[2]=35.0;
  brect[1]= -5.0;brect[3]=35.0;
  style[0]= -1;
  C2F(plot2d)(x,y,&n1,&n2,style,"010"," ",brect,aint,0L,0L);
  polycorps();
}

#define NPC 7

polycorps()
{
  double x[NPC],y[NPC];
  int n=NPC,cf=0;
  x[0]=x[6]=0.0;x[5]=x[1]=10.0,x[4]=x[2]=20.0;x[3]=30.0;
  y[0]=15.0;y[1]=y[2]=30.0;y[3]=15.0;y[4]=y[5]=0.0;y[6]=15.0;
  DR1("xlines","v",&n,x,y,&cf,PI0,PI0,0,0);
}

typedef  struct  {
  char *name;
  int  (*fonc)();} OpTab ;

static int vide() {}

OpTab testtab[] ={
 "test2D", test2D,
 "test2D2", test2D2,
 "test2D3", test2D3,
 "test2D4", test2D4,
 "test2DN 1", test2DN1,
 "test2DN 2", test2DN2,
 "test2DN 3", test2DN3,
 "test3D", test3DA,
 "test3D1", test3D1,
 "test3D2", test3D2,
 "testArrows", testArrows,
 "testC 1", testC1,
 "testC 2", testC2,
 "testC 3", testC3,
 "testCh", testCh,
 "testG", testG,
 "testP3D", testP3D,
 "testPattern", testPattern,
 "testColor", testColor,
 "testPrim", testPrim,
 "testString", testString,
 "testXliness", testXliness,
/*  "testXrects", testXrects,*/
 "testXrects", testPoly,
 (char *) NULL,vide};

extern XtAppContext app_con;

/*	Function Name: MenuSelect
 *	Description: called whenever a menu item is selected.
 *	Arguments: w - the menu item that was selected.
 *                 junk, garbage - *** unused ***.
 *	Returns: 
 */

#define streq(a, b)        ( strcmp((a), (b)) == 0 )

/* ARGSUSED */
static void
MenuSelect(w, junk, garbage)
Widget w;
XtPointer junk, garbage;
{
  static firstentry=0;
  if (firstentry==0) 
    {
      int num=0,verbose=0,ww,narg;
      SetDriver_("Rec");  
      C2F(dr)("xget","window",&verbose,&ww,&narg,PI0,PI0,PI0,0,0);
      C2F(dr)("xset","window",&ww,PI0,PI0,PI0,PI0,PI0,0,0);
      firstentry++;
    }
  else 
    {
      int num=0;
      C2F(dr)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,0,0);
      C2F(dr)("xstart","v",&num,PI0,PI0,PI0,PI0,PI0,0,0);
    }

    if (streq(XtName(w), "test2D")) test2D();
    if (streq(XtName(w), "test2D2")) test2D2();
    if (streq(XtName(w), "test2D3")) test2D3();
    if (streq(XtName(w), "test2D4")) test2D4();
    if (streq(XtName(w), "test2DN 1")) test2DN1();
    if (streq(XtName(w), "test2DN 2")) test2DN2();
    if (streq(XtName(w), "test2DN 3")) test2DN3();
    if (streq(XtName(w), "test3D")) test3DA();
    if (streq(XtName(w), "test3D1")) test3D1();
    if (streq(XtName(w), "test3D2")) test3D2();
    if (streq(XtName(w), "testArrows")) testArrows();
    if (streq(XtName(w), "testC 1")) testC1();
    if (streq(XtName(w), "testC 2")) testC2();
    if (streq(XtName(w), "testC 3")) testC3();
    if (streq(XtName(w), "testCh")) testCh();
    if (streq(XtName(w), "testG")) testG();
    if (streq(XtName(w), "testP3D")) testP3D();
    if (streq(XtName(w), "testColor")) testColor();
    if (streq(XtName(w), "testPattern")) testPattern();
    if (streq(XtName(w), "testPrim")) testPrim();
    if (streq(XtName(w), "testString")) testString();
    if (streq(XtName(w), "testXliness")) testXliness();
/*    if (streq(XtName(w), "testXrects")) testXrects();*/
    if (streq(XtName(w), "testXrects")) testPoly();
}



/*
 * AddNewMenu 
 */

int
AddNewMenu(parent,drawbox)
     Widget parent,drawbox;
{
  Widget outer,command2,command3,button,menu,entry;
  static Arg args[1] ;
  Cardinal n=0;
  int i=0;
  XtSetArg(args[n], XtNfromHoriz,drawbox ); n++;
  button = XtCreateManagedWidget("menuButton", menuButtonWidgetClass, parent,
				 args,n);
  menu = XtCreatePopupShell("menu", simpleMenuWidgetClass, button,NULL,ZERO);
  while ( testtab[i].name != (char *) NULL)
     {
       entry= XtCreateManagedWidget(testtab[i].name, smeBSBObjectClass, menu,
				    args, ZERO);
       XtAddCallback(entry,XtNcallback,MenuSelect,NULL);
       i++;
     }
}


