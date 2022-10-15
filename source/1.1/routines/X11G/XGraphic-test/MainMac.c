#include "../../machine.h"      
#include <stdio.h>
#include <math.h>

main(argc,argv)
     int argc;char *argv[];
{
	SetDriver_("Rec");
	C2F(dr)("xinit","test.ps");
	test();
	while (1) { wait();};
};

wait()
{
  int ibutton,w2,h2;
  C2F(dr)("xclick","void",&ibutton,&w2,&h2);
  C2F(dr)("xclear","v");
};

/*------------END-------*/


#define XN 1
#define NCURVES  2
  
  test()
{
  int style[NCURVES],aint[4],n1,n2;
  double x[NCURVES*XN],y[NCURVES*XN],brect[4];
  int i,j,num;
  x[0]=-100.0;x[1]=500.0;
  y[0]=-100.0;y[1]=600.0;
  style[0]=-1;
  n1=NCURVES;n2=XN;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
  num=0;
  C2F(plot2d)(x,y,&n1,&n2,style,"022"," ",brect,aint);
  corps1();
}



corps1()
{
  double x[7],y[7],boxes[7*4],arcs[7*6],xpols[7*7],ypols[7*7];
  int pats[7],n,i,j,iflag,arsize;
  int verbose=0,narg,whiteid;
  C2F(dr)("xset","default");
  n=7;
  C2F(dr)("xget","white",&verbose,&whiteid,&narg
      			 ,(int*)0,(int*)0,(int*)0,0,0);
  for (i=0; i < 7; i++) x[i]=i*40.00;
  for (i=0; i < 7; i++)
    {
      boxes[4*i]=x[i];
      boxes[4*i+1]=10.000;
      boxes[4*i+2]=30.000;
      boxes[4*i+3]=30.000;
      pats[i]=whiteid+1;
    };
  C2F(dr1)("xrects","v",boxes,pats,&n);
  for (i=0; i < 7; i++) boxes[4*i+1]=45.000;
  pats[0]=0;pats[1]=4;pats[2]=8;pats[3]=12;
  pats[4]=15;pats[5]=whiteid;pats[6]=0;
  C2F(dr1)("xrects","v",boxes,pats,&n);
  for (i=0; i < 7; i++)
    {
      arcs[6*i]=x[i];
      arcs[6*i+1]=90.000;
      arcs[6*i+2]=30.000;
      arcs[6*i+3]=30.000;
      arcs[6*i+4]=0.000;
      arcs[6*i+5]=64.0*180.000;
    };
  C2F(dr1)("xarcs","v",arcs,pats,&n);
  for (i=0; i < 7; i++)
    {
      arcs[6*i+1]=135.000;
      arcs[6*i+5]=64*360.000;
      pats[i]=whiteid+1;
    };
  C2F(dr1)("xarcs","v",arcs,pats,&n);
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
    };
   C2F(dr1)("xliness","v",xpols,ypols,pats,&n,&n);
  pats[0]=0;pats[1]=4;pats[2]=8;pats[3]=12;
  pats[4]=15;pats[5]=whiteid;pats[6]=0;
  for (j=0;j<7;j++)
      for (i=0;i< 7 ; i++) 
	  ypols[i+j*7]=ypols[i+j*7]+60;
  C2F(dr1)("xliness","v",xpols,ypols,pats,&n,&n);
  for (j=0;j<7;j++)
      for (i=0;i< 7 ; i++) 
	  ypols[i+j*7]=ypols[i+j*7]+60;
  for (j=0;j<7;j++) pats[j]=j;
  C2F(dr1)("xpolys","v",xpols,ypols,pats,&n,&n);
  for (j=0;j<7;j++)
    for (i=0;i< 7 ; i++) 
      ypols[i+j*7]=ypols[i+j*7]+60;
  for (j=0;j<7;j++) pats[j]=-j;
  C2F(dr1)("xpolys","v",xpols,ypols,pats,&n,&n);
  for (i=0; i < 7; i++)
    {
      xpols[2*i]=40*i;
      xpols[2*i+1]=xpols[2*i]+30.0;
      ypols[2*i]=360.0+40.0;
      ypols[2*i+1]=360.0+70.0;
    };
  n=14;
  C2F(dr1)("xsegs","v",xpols,ypols,&n);
  for (i=0; i < 7; i++)
    {
      ypols[2*i]=360.0+70.0;
      ypols[2*i+1]=360.0+100.0;
    };
  arsize=50;
  C2F(dr1)("xarrow","v",xpols,ypols,&n,&arsize);
  x[0]=0;x[1]=100;x[2]=200;
  for (i=0; i < 3 ; i++) y[i]=500;
  xpols[0]=10.0;xpols[1]=20.0;xpols[2]=35;
  ypols[0]=ypols[1]=ypols[2]=0.0;
  n=3;
  iflag=1;
  C2F(dr1)("xnum","v",x,y,xpols,ypols,&n,&iflag);
  for (i=0; i < 3 ; i++) y[i]=550;
  iflag=0;
  C2F(dr1)("xnum","v",x,y,xpols,ypols,&n,&iflag);

  };



