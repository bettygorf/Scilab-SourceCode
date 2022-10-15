/*------------------------------------------------------------------------
    Graphic library for 2D and 3D plotting 
    Copyright (C) 1998 Chancelier Jean-Philippe
    jpc@cergrene.enpc.fr 
 --------------------------------------------------------------------------*/

#include <math.h>
#include <stdio.h>
#include <string.h>
#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "Math.h"

double 
MiniD(x, n)
     double *x;
     integer n;
{
  int i;
  double dx=1,mindx=1;
  if ( n < 2 ) return(mindx);
  mindx= Abs(x[1]-x[0]);
  mindx = ( mindx != 0 ) ? mindx : 1;
  for ( i = 2 ; i < n ; i++) 
    {
      dx = Abs(x[i]-x[i-1]);
      if ( dx < mindx && dx != 0 ) mindx=dx;
    }
  return(mindx);
}



/*-----------------------------------------------------------------
   C2F(champ)(x,y,fx,fy,strflag,vrect,arfact)

 Draw a vector field of dimension 2
 (fx[i+(*n1)*j], fy[i+(*n1)*j]) is the value of the vector field 
 at point X=(x[i],y[j]);
 fx and fy are (*n1)*(*n2) matrix of double values.
 arfact : a factor by which to multiply the default arrow size 
          usr 1.0 by defaut 
 
 strflag : a string of length 3 ( see plot2d) 
 vrect=[xmin,ymin,xmax,ymax]

 lstr : unused ( but used by Fortran ) 
-------------------------------------------------------------------*/

void champg(name, colored, x, y, fx, fy, n1, n2, strflag, brect, arfact, lstr)
     char *name;
     integer colored;
     double *x;
     double *y;
     double *fx;
     double *fy;
     integer *n1;
     integer *n2;
     char *strflag;
     double *brect;
     double *arfact;
     integer lstr;
{
  static char logflag[]="nn";
  static integer aaint[]={2,10,2,10};
  double FRect[4],scx,scy,xofset,yofset, maxx;
  integer IRect[4],err=0,*xm,*ym,*zm,i,j,job=1,n,na;
  integer Xdec[3],Ydec[3];
  double xx[2],yy[2];
  double nx,ny,sc,sfx,sfy,sfx2,sfy2;
  double arsize1=0.5,arsize2=0.5;
  integer arsize,nn1=1,nn2=2,iflag=0;
  integer verbose=0,narg,xz[10];
  C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /* Storing values if using the Record driver */
  if (GetDriver()=='R') 
    StoreChamp(name,x,y,fx,fy,n1,n2,strflag,brect,arfact);
  /** The arrowsize acording to the windowsize **/
  n=2*(*n1)*(*n2);
  xx[0]=x[0];xx[1]=x[*n1-1];
  yy[0]=y[0];yy[1]=y[*n2-1];
  /** Boundaries of the frame **/
  FrameBounds("gnn",xx,yy,&nn1,&nn2,aaint,strflag,brect,FRect,Xdec,Ydec);
  if ( (int)strlen(strflag) >=1 && strflag[0]=='2') job=0;
  if ( colored ==0) 
    Scale2D(job,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,logflag,&xm,&ym,n,&err);
  else 
    {
      Scale2D(job,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,logflag,&xm,&ym,0L,&err);
      Alloc(&xm,&ym,&zm,n,n,n/2,&err);
    }
  if ( err == 0) return;
  for ( i = 0 ; i < *n1 ; i++)
    for ( j =0 ; j < *n2 ; j++)
      {
	xm[2*(i +(*n1)*j)]= inint(scx*(x[i]-FRect[0]) + xofset);
	ym[2*(i +(*n1)*j)]= inint(scy*(-y[j]+FRect[3]) + yofset);
      }
  /** Scaling **/
  nx=MiniD(x,*n1)*scx;
  ny=MiniD(y,*n2)*scy;
  sfx= scx;
  sfy= scy;
  sfx2= sfx*sfx;
  sfy2= sfy*sfy;
  maxx = sfx2*fx[0]*fx[0]+sfy2*fy[0]*fy[0];
  for (i = 1;  i < (*n1)*(*n2) ; i++)
    {
      double maxx1;
      maxx1 =  sfx2*fx[i]*fx[i]+sfy2*fy[i]*fy[i];
      if ( maxx1 > maxx) maxx=maxx1;
    }
  maxx = ( maxx < SMDOUBLE) ? SMDOUBLE : sqrt(maxx);
  sc=maxx;
  /*sc= Min(nx,ny)/sc;*/
  sc= sqrt(nx*nx+ny*ny)/sc;
  sfx *= sc;
  sfy *= sc;
  /** size of arrow **/
  arsize1= ((double) IRect[2])/(5*(*n1));
  arsize2= ((double) IRect[3])/(5*(*n2));
  arsize=  (arsize1 < arsize2) ? inint(arsize1*10.0) : inint(arsize2*10.0) ;
  arsize = (int)(arsize*(*arfact));
  set_clip_box(IRect[0],IRect[0]+IRect[2],IRect[1],IRect[1]+IRect[3]);
  if ( colored == 0 ) 
    {
      int j=0;
      for ( i = 0 ; i < (*n1)*(*n2) ; i++)
	{
	  integer x1n,y1n,x2n,y2n,flag1=0;
	  xm[1+2*j]= (int)(sfx*fx[i]/2+xm[2*i]);
	  xm[2*j]  = (int)(-sfx*fx[i]/2+xm[2*i]);
	  ym[1+2*j]= (int)(-sfy*fy[i]/2+ym[2*i]);
	  ym[2*j]  = (int)(sfy*fy[i]/2+ym[2*i]);
	  clip_line(xm[2*j],ym[2*j],xm[2*j+1],ym[2*j+1],&x1n,&y1n,&x2n,&y2n,&flag1);
	  if (flag1 !=0)
	    {
	      if (flag1==1||flag1==3) { xm[2*j]=x1n;ym[2*j]=y1n;};
	      if (flag1==2||flag1==3) { xm[2*j+1]=x2n;ym[2*j+1]=y2n;};
	      /* sciprint("j'ai rajoute (%d,%d)->(%d,%d)\r\n",xm[2*j],ym[2*j],xm[2*j+1],ym[2*j+1]); */
	      j++;
	    }
	}
      na=2*j;
    }
  else 
    {
      integer x1n,y1n,x2n,y2n,flag1=0;
      integer whiteid;
      int j=0;
      C2F(dr)("xget","lastpattern",&verbose,&whiteid,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      for ( i = 0 ; i < (*n1)*(*n2) ; i++)
	{
	  double nor= sqrt(sfx2*fx[i]*fx[i]+sfy2*fy[i]*fy[i]);
	  zm[j] = inint( ((double) whiteid)*(1.0 - nor/maxx));
	  nor= sqrt(fx[i]*fx[i]+fy[i]*fy[i]);
	  xm[1+2*j]= (int)(sfx*fx[i]/(2*nor)+xm[2*i]);
	  xm[2*j]  = (int)(-sfx*fx[i]/(2*nor)+xm[2*i]);
	  ym[1+2*j]= (int)(-sfy*fy[i]/(2*nor)+ym[2*i]);
	  ym[2*j]  = (int)(sfy*fy[i]/(2*nor)+ym[2*i]);
	  clip_line(xm[2*j],ym[2*j],xm[2*j+1],ym[2*j+1],&x1n,&y1n,&x2n,&y2n,&flag1);
	  if (flag1 !=0)
	    {
	      if (flag1==1||flag1==3) { xm[2*j]=x1n;ym[2*j]=y1n;};
	      if (flag1==2||flag1==3) { xm[2*j+1]=x2n;ym[2*j+1]=y2n;};
	      j++;
	    }
       }
      na=2*j;
    }
  /** Draw Axis or only rectangle **/
  AxisDraw(FRect,IRect,Xdec,Ydec,aaint,scx,scy,xofset,yofset,strflag,logflag);
  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3],PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if ( colored ==0) 
    C2F(dr)("xarrow","v",xm,ym,&na,&arsize,xz,&iflag,PD0,PD0,PD0,PD0,0L,0L);
  else
    C2F(dr)("xarrow","v",xm,ym,&na,&arsize,zm,(iflag=1,&iflag),PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","clipoff",PI0,PI0,PI0,PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}

int C2F(champ)(x,y,fx,fy,n1,n2,strflag,brect,arfact,lstr)
     double x[],y[],fx[],fy[],brect[],*arfact;
     integer *n1,*n2;
     char strflag[];
     integer lstr;
{
  champg("champ",0,x,y,fx,fy,n1,n2,strflag,brect,arfact,lstr);
  return(0); 
}

int C2F(champ1)(x,y,fx,fy,n1,n2,strflag,brect,arfact,lstr)
     double x[],y[],fx[],fy[],brect[],*arfact;
     integer *n1,*n2;
     char strflag[];
     integer lstr;
{
  champg("champ1",1,x,y,fx,fy,n1,n2,strflag,brect,arfact,lstr);
  return(0);
}
