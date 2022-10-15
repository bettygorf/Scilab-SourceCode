#include "../machine.h"
#include <stdio.h>

main(argc, argv)
     int argc;
     char **argv;
{
  int i,nowindow=0,nostartup=0;
  for (i=argc-1 ; i >=0  ; i-- )
    {
      if ( strcmp(argv[i],"-ns")==0) nostartup=1;
      if ( strcmp(argv[i],"-nw")==0) nowindow=1;
    };
  if ( nowindow) 
    C2F(scilab)(&nostartup);
  else
    main_sci(argc,argv);
};

#define PROMPT "[loop test (quit,plot,click)]-->"

/* version with Xterm */

F2C(scilab)(nostartup)
     int *nostartup;
{
  int siz=1000,len_line,eof,i;
  static char buf[1000];
  C2F(xscion)(&i);
  if ( i == 1) 
    for ( ; ; ) {
      Xputstring(PROMPT,strlen(PROMPT));
      zzledt1_(buf,&siz,&len_line,&eof);
      Xputstring(buf,len_line);
      Xputstring("\r\n",2);
      if ( strcmp(buf,"plot")==0)
	{ 
	  check_win();
	  plot();
	} 
      else if ( strcmp(buf,"quit")==0) break; 
      else if ( strcmp(buf,"looptest")==0)
	{ 
	  while (1) {
	    C2F(xevents)();
	  };
	} 
      else if ( strcmp(buf,"click")==0) 
	{int i,x,y;
	 check_win();
	 xclick_("pipo",&i,&x,&y);
	 sprintf(buf,"-->[%d,%d,%d]",i,x,y);
	 Xputstring(buf,strlen(buf));
       }
      else if ( strcmp(buf,"eventloop")==0) 
	{
	  int i;
	  for ( i=0 ; i < 1000; i++) 
	    {
	      unsigned usec=20;
	      xevents1();
	      usleep(usec);
	    };
	  Scistring("Quittting enevent loop");
       };
    }
  else 
    for ( ; ; ) {
      fprintf(stdout,PROMPT);
      zzledt_(buf,&siz,&len_line,&eof);
      fprintf(stdout,buf);
      fprintf(stdout,"\r\n");
      if ( strcmp(buf,"plot")==0)
	{ 
	  check_win();
	  plot();
	} 
      else if ( strcmp(buf,"quit")==0) break; 
      else if ( strcmp(buf,"looptest")==0)
	{ 
	  while (1) C2F(xevents)();
	} 
      else if ( strcmp(buf,"click")==0) 
	{int i,x,y;
	 check_win();
	 xclick_("pipo",&i,&x,&y);
	 sprintf(buf,"-->[%d,%d,%d]",i,x,y);
	 fprintf(stdout,buf);
       };
    };
};


C2F(sigbas)(i)
     int *i;
{
  fprintf(stderr,"CTRL_C activated \n");
};

#define IP0 (int *) 0

check_win()
{
  int verb=0,win,na,v;
  C2F(dr1)("xget","window",&verb,&win,&na,v,v,v,0,0);
  C2F(dr1)("xset","window",&win,IP0,IP0,IP0,IP0,IP0,0,0);
};


int C2F(scilines)(nl,nc)
     int *nl, *nc;
{};

int C2F(sciquit)(nl,nc)
     int *nl, *nc;
{return(1);}
     
#include <math.h>

#define PI0 (int *) 0
#define DR1(x0,x1,x2,x3,x4,x5,x6,x7,lx0,lx1)  \
  C2F(dr1)(x0,x1,(int *)(x2),(int *)(x3),(int *) (x4),(int *) (x5),(int *) (x6),(int *) (x7),lx0,lx1)


#define XN2DD 2
#define NCURVES2DD  1

plot()
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
  C2F(plot2d)(x,y,&n1,&n2,style,"021"," ",brect,aint,0L,0L);
};

