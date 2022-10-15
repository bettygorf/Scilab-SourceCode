
#include "../machine.h"
#include <stdio.h>

#define PI0 (integer *) 0
#define PD0 (double *)  0

extern int demo_menu_activate;

#include <string.h> /* in case of dmalloc */ 
#include <malloc.h>


main(argc, argv)
     int argc;
     char **argv;
{
  int i,nowindow=0,nostartup=0;
  char *p;
  demo_menu_activate=1;
  for (i=argc-1 ; i >=0  ; i-- )
    {
      if ( strcmp(argv[i],"-ns")==0) nostartup=1;
      if ( strcmp(argv[i],"-nw")==0) nowindow=1;
    };
  if ( nowindow) 
    C2F(scilab)(&nostartup);
  else
    main_sci(argc,argv);
  return(0);
};

C2F(dsort)() {};
C2F(fbutn)() {};

#define PROMPT "[loop test]-->"

typedef  struct  {
  char *name;
  int  (*fonc)(); } TestOpTab ;

static int vide_() {}
     
static char buf[1000];


test_plot()
{
  integer win=0;
  check_win();
  plot();
  C2F(xsaveplots)(&win);
  C2F(xloadplots)(&win);
}

test_menu()
{
  integer win_num=0,ne=3,ierr=0;
  static char * entries[]={
    "Un ","Deux","Trois",NULL};
  AddMenu(&win_num,"test button",entries,&ne,&ierr);
}

test_quit() {
  C2F(clearexit)(0);
};

test_loop() {
  while (1) {
    C2F(xevents)();
  };
} 

test_message() 
{
  TestMatrixDialogWindow();
  TestChoose();
  TestMessage();
  TestDialog() ;
  TestmDialogWindow();
  TestChoice();
}

test_click() {
  integer i;
  double x,y;
  check_win();
  C2F(dr1)("xclick","void",&i,PI0,PI0,PI0,PI0, PI0,&x,&y,PD0,PD0,0L,0L);
  sprintf(buf,"-->[%d,%f,%f]",i,x,y);
  Xputstring(buf,strlen(buf));
}

test_events() 
{
  int i;
  for ( i=0 ; i < 1000; i++) 
    {
      unsigned usec=20;
      xevents1();
#ifdef sun
      usleep(usec);
#endif
    };
  Scistring("Quittting enevent loop");
};

test_xinfo() 
{
  xinfo_("Xinfo Tester",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
};


test_xgc() {
  integer num=0;
  /** need ../xgc dir to work **/
  /** xgc(); **/
  DeleteWindowToList_(num);
}

static TestOpTab testTab[] ={
  "add menu",test_menu,
  "click", test_click,
  "events",test_events,
  "loop",test_loop,
  "menus",test_message,
  "plot",test_plot,
  "quit",test_quit,
  "xgc",test_xgc,
  "xinfo",test_xinfo,
  (char *) NULL,vide_
  };

LTest(x0) 
     char * x0;
{
  int i=0;
  while ( testTab[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(x0,testTab[i].name);
       if ( j == 0 ) 
	 { 
	   (*(testTab[i].fonc))();
	   return;}
       else 
	 { 
	   if ( j <= 0)
	     {
	       sciprint("\nUnknow X operator <%s>\r\n",x0);
	       break;
	     }
	   else i++;
	 }
     }
  sciprint("\n Unknow X operator <%s>\r\n",x0);
  i=0;
  sciprint("%s","List of known operators \r\n");
  while ( testTab[i].name != (char *) NULL)
    {
      sciprint("\t%s\r\n",testTab[i].name);
      i++;
    }
}

F2C(scilab)(nostartup)
     int *nostartup;
{
  int siz=1000,len_line,eof,i;
  C2F(xscion)(&i);
  if ( i == 1) 
    for ( ; ; ) {
      Xputstring(PROMPT,strlen(PROMPT));
      C2F(zzledt1)(buf,&siz,&len_line,&eof,0L);
      Xputstring(buf,len_line);
      Xputstring("\r\n",2);
      LTest(buf);
    }
  else 
    for ( ; ; ) {
      fprintf(stdout,PROMPT);
      C2F(zzledt)(buf,&siz,&len_line,&eof,0L);
      fprintf(stdout,buf);
      fprintf(stdout,"\r\n");
      LTest(buf) ;
    };
};


C2F(sigbas)(i)
     int *i;
{
  fprintf(stderr,"CTRL_C activated \n");
};


check_win()
{
  integer verb=0,win,na;
  C2F(dr1)("xget","window",&verb,&win,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr1)("xset","window",&win,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
};


int C2F(scilines)(nl,nc)
     int *nl, *nc;
{};

int C2F(sciquit)()
{
  return(1);
}
     
#include <math.h>

#define XN2DD 2
#define NCURVES2DD  1

plot()
{
  long int style[NCURVES2DD],aaint[4],n1,n2;
  double x[NCURVES2DD*XN2DD],y[NCURVES2DD*XN2DD],brect[4];
  int i,j;
  for ( j =0 ; j < NCURVES2DD ; j++)
    {
      i=0;
      x[i+ XN2DD*j]= ((double) i+1)/10.0;
      y[i+ XN2DD*j]= 1.234;
      i=1;
      x[i+ XN2DD*j]= ((double) i+2)/10.0;
      y[i+ XN2DD*j]= 2,64;
      }
  for ( i=0 ; i < NCURVES2DD ; i++)
    style[i]= -NCURVES2DD+i;
  n1=NCURVES2DD;n2=XN2DD;
  aaint[0]=aaint[2]=2;aaint[1]=aaint[3]=10;
  C2F(plot2d)(x,y,&n1,&n2,style,"021"," ",brect,aaint,0L,0L);
};


void cerro(str)
char *str;
{
  fprintf(stderr,"%s",str);
}

void cout(str)
char *str;
{
  fprintf(stdout,"%s",str);
}


void C2F(cvstr)(n,line,str,job,lstr)
     int *n,*line;
     char str[];
     int  *job;
     long int lstr;
{};

