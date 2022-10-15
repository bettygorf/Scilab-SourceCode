
#include <stdio.h>

#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>

main(argc,argv)
     int argc;
     char **argv;     
{
  static String description = "texte";
    static String strings[] = {
	"first list entry",
	"second list entry",
	"third list entry",
	"fourth list entry",
	NULL
    };
  inix1_(argc,argv);
  SetDriver_("X11"); dr_("xinit","unix:0.0");
  ExposeChooseWindow(strings,description);
  xselgraphic_();
};

    
cvstr_(){};

#include <math.h>
#define XN 63
#define NCURVES  3

test()
{
  int style[NCURVES],aint[4],n1,n2;
  float x[NCURVES*XN],y[NCURVES*XN],brect[4];
  int i,j;
  for ( j =0 ; j < NCURVES ; j++)
    for ( i=0 ; i < XN ; i++)
      {
	x[i+ XN*j]= ((float) i)/10.0;
	y[i+ XN*j]= (float) sin((j+1)*x[i+XN*j]);
      }
  for ( i=0 ; i < NCURVES ; i++)
    style[i]=-NCURVES+i;
  n1=NCURVES;n2=XN;
  aint[0]=aint[2]=2;aint[1]=aint[3]=10;
    plot2d_(x,y,&n1,&n2,style,"021"," ",brect,aint);
}

/*------------END-------*/




