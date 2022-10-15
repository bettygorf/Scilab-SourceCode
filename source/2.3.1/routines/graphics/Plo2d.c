#include <string.h> /* in case of dbmalloc use */
#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <stdio.h>
#include <math.h>
#include "Math.h"

/*--------------------------------------------------------------------
  C2F(plot2d)(x,y,n1,n2,style,strflag,legend,brect,aaint,lstr1,lstr2)
  
  Draw *n1 curves of *n2 points each
  (x[i+(*n2)*j] ,y[i+(*n2)*j]) Double values giving the point
  position of point i of curve j (i=0,*n2-1 j=0,*n1-1)

  style[*n1]-> give the style to use for each curve 
     if style is positive --> a mark is used (mark id = style[i])
     if style is strictly negative --> a dashed line is used 
        (dash id = abs(style[i])
     if there's only one curve, style can be of type style[0]=style,
     style[1]=pos ( pos in [1,6]) 
     pos give the legend position (1 to 6) (this can be iteresting
     if you want to superpose curves with different legends by 
     calling plot2d more than one time.

  strflag[3] is a string
  
     if strflag[0] == '1' then legends are added 
        legend = "leg1@leg2@....@legn"; gives the legend for each curve
	else no legend

     if strflag[1] == '1' then  the values of brect are used to fix 
        the drawing boundaries :  brect[]= <xmin,ymin,xmax,ymax>;
	if strflag[1] == '2' then the values  are computed from data
	else if strflag[1]=='0' the previous values 
                (previous call or defaut values) are used 

     if  strflag[2] == '1' ->then an axis is added
        the number of intervals 
        is specified by the vector aaint[4] of integers 
	   <aaint[0],aaint[1]> specifies the x-axis number of  points 
	   <aaint[2],aaint[3]> same for y-axis
     if  strflag[2] == '2' -> no axis, only a box around the curves
     else no box and no axis 

 lstr* : unused ( but used by Fortran ) 
--------------------------------------------------------------------------*/
extern char GetDriver();
  
int C2F(plot2d)(x,y,n1,n2,style,strflag,legend,brect,aaint,lstr1,lstr2)
     double x[],y[],brect[];
     integer *n1,*n2,style[],aaint[];
     char legend[],strflag[];
     integer lstr1,lstr2;
{
  static char logflag[]="nn";
  double FRect[4],scx,scy,xofset,yofset;
  integer IRect[4],err=0,*xm,*ym,job=1;
  integer Xdec[3],Ydec[3];
  /* Storing values if using the Record driver */
  if (GetDriver()=='R') 
    StorePlot("plot2d1","gnn",x,y,n1,n2,style,strflag,legend,brect,aaint);
  /** Boundaries of the frame **/
  FrameBounds("gnn",x,y,n1,n2,aaint,strflag,brect,FRect,Xdec,Ydec);
  /** Scales **/
  if ( (int)strlen(strflag) >=2 && strflag[1]=='0') job=0;
  Scale2D(job,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,logflag,&xm,&ym,(*n1)*(*n2),&err);
  if ( err == 0) return(0);
  /** Real to Pixel values **/
  C2F(echelle2d)(x,y,xm,ym,n1,n2,IRect,"f2i",3L);
  AxisDraw(FRect,IRect,Xdec,Ydec,aaint,scx,scy,xofset,yofset,strflag,"nn");
  /** Drawing the curves **/
  C2F(dr)("xset","clipping",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
	  ,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xpolys","v",xm,ym,style,n1,n2,
	  PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","clipoff",PI0,PI0,PI0,PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** Drawing the Legends **/
  if ((int)strlen(strflag) >=1  && strflag[0] == '1')
    Legends(IRect,style,n1,legend); 
  return(0);
}


int C2F(xgrid)(style)
     integer *style;
{
  integer IRect[4],aaint[4];
  char logflag[2];
  integer closeflag=0,n=2,vx[2],vy[2],i,j,*xm,*ym,err;
  double FRect[4],scx,scy,xofset,yofset,pas;
  integer verbose=0,narg,xz[10];
  if (GetDriver()=='R') StoreGrid("xgrid",style);
  C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","dashes",style,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  /** Get current scale **/
  Scale2D(0L,FRect,IRect,aaint,&scx,&scy,&xofset,&yofset,logflag,&xm,&ym,0L,&err);
  pas = ((double) IRect[2]) / ((double) aaint[1]);
  /** x-axis grid (i.e vertical lines ) */
  for ( i=0 ; i < aaint[1]; i++)
    {
      vy[0]=IRect[1];
      vy[1]=IRect[1]+IRect[3];
      vx[0]=vx[1]= IRect[0] + inint( ((double) i)*pas);
      if ( i!=0) C2F(dr)("xlines","void",&n, vx, vy,&closeflag,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if (logflag[0] == 'l') 
	{
	  int jinit=1;
	  if ( i== 0 ) jinit=2; /* no grid on plot boundary */
	  for (j= jinit; j < 10 ; j++)
	    {
	      vx[0]=vx[1]= IRect[0] + inint( ((double) i)*pas)+ inint(log10(((double)j))*pas);
	       C2F(dr)("xlines","void",&n, vx, vy,&closeflag,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	    }
	}
    }
  /** y-axis grid (i.e horizontal lines ) **/
  pas = ((double) IRect[3]) / ((double) aaint[3]);
  for ( i=0 ; i < aaint[3]; i++)
    {
      vx[0]=IRect[0];
      vx[1]=IRect[0]+IRect[2];
      vy[0]=vy[1]= IRect[1] + inint( ((double) i)*pas);
      if (i!=0)  C2F(dr)("xlines","void",&n, vx, vy,&closeflag,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
      if (logflag[1] == 'l') 
	{
	  int jinit=1;
	  if ( i== aaint[3]-1 ) jinit=2; /* no grid on plot boundary */
	  for (j= jinit; j < 10 ; j++)
	    {
	      vy[0]=vy[1]= IRect[1] + inint( ((double) i+1)*pas)- inint(log10(((double)j))*pas);
	       C2F(dr)("xlines","void",&n, vx, vy,&closeflag,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	    }
	}
    }
  C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
 return(0);
}

/** Draw Axis or only rectangle **/

void AxisDraw(FRect, IRect, Xdec, Ydec, aaint, scx, scy, xofset, yofset, strflag, lfg)
     double *FRect;
     integer *IRect;
     integer *Xdec;
     integer *Ydec;
     integer *aaint;
     double scx;
     double scy;
     double xofset;
     double yofset;
     char *strflag;
     char *lfg;
{
  integer verbose=0,narg,xz[10],fg;
  C2F(dr)("xget","foreground",&verbose,&fg,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","dashes",&fg,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if ((int)strlen(strflag) >= 3 && strflag[2] == '1')
    {
      if ( strflag[1] == '5' || strflag[1] =='6' )
	{
	  /* utilisation des bornes automatiques */
	  C2F(aplot1)(FRect,IRect,Xdec,Ydec,&(aaint[0]),&(aaint[2]),lfg,scx,scy,xofset,yofset);
	}
      else
	{
	  double xmin1,xmax1, ymin1,ymax1;
	  C2F(aplot)(IRect,(xmin1=FRect[0],&xmin1),(ymin1=FRect[1],&ymin1),
		 (xmax1=FRect[2],&xmax1),(ymax1=FRect[3],&ymax1),
		 &(aaint[0]),&(aaint[2]),lfg); 
	}
    }
  else
    {
      if ((int)strlen(strflag) >= 3 && strflag[2] == '2')
	C2F(dr)("xrect","v",&IRect[0],&IRect[1],&IRect[2],&IRect[3]
		,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    }
  C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}

/*----------------------------------------------------
 * Recherche des min et max, avec eventuellement des graduations adaptes 
 *----------------------------------------------------*/

void FrameBounds(xf, x, y, n1, n2, aaint, strflag, brect, FRect, Xdec, Ydec)
     char *xf;
     double *x;
     double *y;
     integer *n1;
     integer *n2;
     integer *aaint;
     char *strflag;
     double *brect;
     double *FRect;
     integer *Xdec;
     integer *Ydec;
{
  static double xmax=10.0,xmin=0.0,ymin= -10.0,ymax=0.0;
  if ((int)strlen(strflag) >= 2)
    {
      integer verbose=0,narg,xz[2],wmax,hmax;
      double hx,hy,hx1,hy1;
      char c;
      /* 
       * min,max using brect or x,y according to flags 
       */
      switch ( strflag[1])
	{
	case '1' : 
	case '3' :
	case '5' : 
	  xmin=brect[0];xmax=brect[2];ymin= -brect[3];ymax= -brect[1];
	  break;
	case '2' : 
	case '4' : 
	case '6' :
	  if ( (int)strlen(xf) < 1) c='g' ; else c=xf[0];
	  switch ( c )
	    {
	    case 'e' : xmin= 1.0 ; xmax = (*n2);break;
	    case 'o' : 
	      xmax=  (double) Maxi(x,(*n2));
	      xmin=  (double) Mini(x,(*n2)); break;
	    case 'g' :
	    default: 
	      xmax=  (double) Maxi(x,(*n1)*(*n2));
	      xmin=  (double) Mini(x,(*n1)*(*n2)); break;
	    }
	  ymax=  (double) - Mini(y,(*n1)*(*n2));
	  ymin=  (double) - Maxi(y,(*n1)*(*n2));
	  break;
	}
      /*
       * changing computed min,max for producing isoview 
       * mode 
       */
      if ( strflag[1] == '3' || strflag[1] == '4')
	{
	  C2F(dr)("xget","wdim",&verbose,xz,&narg, PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  wmax=xz[0];hmax=xz[1];
	  hx=xmax-xmin;
	  hy=ymax-ymin;
	  if ( hx/(double)wmax  <hy/(double) hmax ) 
	    {
	      hx1=wmax*hy/hmax;
	      xmin=xmin-(hx1-hx)/2.0;
	      xmax=xmax+(hx1-hx)/2.0;
	    }
	  else 
	    {
	      hy1=hmax*hx/wmax;
	      ymin=ymin-(hy1-hy)/2.0;
	      ymax=ymax+(hy1-hy)/2.0;
	    }
	}
    }
  /* Changing min,max if using log scaling  */
  if ((int)strlen(xf) >= 2 && xf[1]=='l' && (int)strlen(strflag) >= 2 && strflag[1] != '0')
    {
      /* xaxis */
      if ( xmin >  0)
	{
	  xmax=(double) ceil(log10(xmax));
	  xmin=(double) floor(log10(xmin));
	  aaint[0]=1;aaint[1]=inint(xmax-xmin);
	}
      else 
	{
	  Scistring(" Can't use Log on X-axis xmin is negative \n");
	  xmax= 1;
	  xmin= 0;
	  aaint[0]=1;aaint[1]=inint(xmax-xmin);
	}
    }
  if ((int)strlen(xf) >=3  && xf[2]=='l' && (int)strlen(strflag) >= 2 && strflag[1] != '0')
    {
      /* y axis */
      if ( (- ymin ) > 0 && (-ymax > 0) )
	{
	  ymax=  (double) ceil(-log10(-ymax));
	  ymin=  (double) floor(-log10(-ymin));
	  aaint[2]=1;aaint[3]=inint(ymax-ymin);
	}
      else 
	{
	  Scistring(" Can't use Log on y-axis ymin is negative \n");
	  ymax= 0;
	  ymin= -1;
	  aaint[2]=1;aaint[3]=inint(ymax-ymin);
	}
    }
  /** Scaling **/
  /* FRect gives the plotting boundaries xmin,ymin,xmax,ymax */
  
  FRect[0]=xmin;FRect[1]= -ymax;FRect[2]=xmax;FRect[3]= -ymin;

  if ( (int)strlen(strflag) >=2 && ( strflag[1]=='5' || strflag[1]=='6' ))
    {
      /* recherche automatique des bornes et graduations */
      Gr_Rescale(&xf[1],FRect,Xdec,Ydec,&(aaint[0]),&(aaint[2]));
    }
}

/*----------------------------------------------------
  legend="leg1@leg2@leg3@...."             
  legend contain legends separated by '@'
  if nlegend is the number of legends stored in legend
  then the function Legends draw  Min(*n1,6,nlegends) legends
-----------------------------------------------------*/

void Legends(IRect, style, n1, legend)
     integer *IRect;
     integer *style;
     integer *n1;
     char *legend;
{
char *leg,*loc;
double xi,yi,xoffset,yoffset;  
int i;
loc=(char *) MALLOC( (strlen(legend)+1)*sizeof(char));
if ( loc != 0)
  {
    integer verbose=0,narg,xz[10],fg;
    C2F(dr)("xget","foreground",&verbose,&fg,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    C2F(dr)("xget","dashes",&verbose,xz,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    C2F(dr)("xset","dashes",&fg,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);

    strcpy(loc,legend);
    xoffset= IRect[2]/12.0;
    yoffset= IRect[3]/40.0;
    xi= IRect[0];
    for ( i = 0 ; i < *n1 && i < 6 ; i++)
      {  
	integer xs,ys,flag,polyx[2],polyy[2],lstyle[1],ni;
	double angle;
	if (*n1 == 1) ni=Max(Min(5,style[1]-1),0);else ni=i;
	if (ni >= 3)
	  { xi=IRect[0]+IRect[2]/2;
	    yi=IRect[1]+IRect[3]+(ni-3)*yoffset+4*yoffset;}
	else
	  { yi=IRect[1]+IRect[3]+(ni)*yoffset+4*yoffset;
	  }
	xs=inint(xi+1.2*xoffset),ys=inint(yi+yoffset/4),angle=0.0;flag=0;
	if ( i==0) leg=strtok(loc,"@"); else leg=strtok((char *)0,"@");
	 if (leg != 0) 
	   {
	     C2F(dr)("xstring",leg,&xs,&ys,PI0,&flag
		     ,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L);
	     if (style[i] > 0)
	       { 
		 integer n,p;
		 polyx[0]=inint(xi);polyx[1]=inint(xi+xoffset);
		 polyy[0]=inint(yi);polyy[1]=inint(yi);
		 lstyle[0]=style[i];
		 p=2;n=1;
		 C2F(dr)("xpolys","v",polyx,polyy,lstyle,&n,&p
		     ,PI0,PD0,PD0,PD0,PD0,0L,0L);
	       }
	     else
	       { 
		 integer n,p;
		 polyx[0]=inint(xi+xoffset);
		 polyy[0]=inint(yi);
		 lstyle[0]=style[i];
		 p=1;n=1;
		 C2F(dr)("xpolys","v",polyx,polyy,lstyle,&n,&p
		     		     ,PI0,PD0,PD0,PD0,PD0,0L,0L);
	       }
	   }
       }
    FREE(loc);
    C2F(dr)("xset","dashes",xz,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  }
else
  {
    Scistring("Legends : No more Place to store Legends\n");
  }
}





