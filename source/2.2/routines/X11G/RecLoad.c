/* inclus par rpc/...
#include <string.h> 
#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif
*/

#ifdef macintosh
#	include "types.h"
#else /* not macintosh */
#       ifndef VMS
#   	include <sys/types.h>	/* for <netinet/in.h> on some systems */
#   	ifndef MSDOS 
#          include <netinet/in.h>	/* for htonl() */
#   	endif
#	endif
#endif /* not macintosh */

#include <rpc/types.h>
#include <rpc/xdr.h>

#include <stdio.h>
#include "Math.h"

#include "Rec.h"
extern int Store();

#define assert(ex) {if (!(ex)){ sciprint("Graphic Load/Save Error \r\n");return(0);}}

/*---------------------------------------------------------------------
  Partie Load/load en utilisant xdr 
---------------------------------------------------------------------------*/

LoadXcall1()
{
  struct xcall1_rec *lplot ;
  lplot= ((struct xcall1_rec *) MALLOC(sizeof(struct xcall1_rec)));
  if (lplot != NULL)
    {
      if (LoadVectC(&(lplot->fname)) == 0) return(0);
      if (LoadVectC(&(lplot->string)) == 0) return(0);
      if (LoadLI(&lplot->n1 ) == 0) return(0);
      if (LoadLI(&lplot->n2 ) == 0) return(0);
      if (LoadLI(&lplot->n3 ) == 0) return(0);
      if (LoadLI(&lplot->n4 ) == 0) return(0);
      if (LoadLI(&lplot->n5 ) == 0) return(0);
      if (LoadLI(&lplot->n6 ) == 0) return(0);
      if (LoadLI(&lplot->ndx1 ) == 0) return(0);
      if (LoadLI(&lplot->ndx2 ) == 0) return(0);
      if (LoadLI(&lplot->ndx3 ) == 0) return(0);
      if (LoadLI(&lplot->ndx4 ) == 0) return(0);
      if (LoadVectLI(&(lplot->x1)) == 0) return(0);
      if (LoadVectLI(&(lplot->x2)) == 0) return(0);
      if (LoadVectLI(&(lplot->x3)) == 0) return(0);
      if (LoadVectLI(&(lplot->x4)) == 0) return(0);
      if (LoadVectLI(&(lplot->x5)) == 0) return(0);
      if (LoadVectLI(&(lplot->x6)) == 0) return(0);
      if (LoadVectF(&(lplot->dx1)) == 0) return(0);
      if (LoadVectF(&(lplot->dx2)) == 0) return(0);
      if (LoadVectF(&(lplot->dx3)) == 0) return(0);
      if (LoadVectF(&(lplot->dx4)) == 0) return(0);
      if (Store("xcall1",(char *) lplot) == 0) return(0);
    }
  else 
    {
      Scistring("\nLoad Plot (xcall1): No more place \n");
      return(0);
    }
  return(1);
}

/*---------------------------------------------------------------------
  \encadre{Le cas des changement d'echelle}
  ---------------------------------------------------------------------------*/

LoadEch()
{
  struct scale_rec *lplot;
  lplot= ((struct scale_rec *) MALLOC(sizeof(struct scale_rec)));
  if (lplot != NULL)
    {
      if (LoadC(lplot->logflag) == 0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectF(&(lplot->Wrect)) == 0) return(0);
      if (LoadVectF(&(lplot->Frect)) == 0) return(0);
      if (LoadVectF(&(lplot->Frect_kp))   == 0) return(0);
      if (Store("scale",(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (Ech): No more place \n");
      return(0);
    }
  return(1);
}


/*---------------------------------------------------------------------
  \encadre{Le cas des plot2d}
  ---------------------------------------------------------------------------*/

/* Load the plot2d  in the plot list 
   same arguments as plot2d */

LoadPlot()
{
  integer n=0, nstyle;
  struct plot2d_rec *lplot;
  lplot= ((struct plot2d_rec *) MALLOC(sizeof(struct plot2d_rec)));
  if (lplot != NULL)
    {
      if (LoadLI(&lplot->n1) == 0) return(0);
      if (LoadLI(&lplot->n2) == 0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectC(&(lplot->xf)) == 0) return(0);
      if (lplot->n1==1 ) nstyle= lplot->n1+1;else nstyle= lplot->n1;
      switch (lplot->xf[0])
	{
	case 'g': n=(lplot->n1)*(lplot->n2);break;
	case 'e': n=0;break;
	case 'o': n=(lplot->n2);break;
	}
      if ( n != 0) 
	{
	  if (LoadVectF(&(lplot->x)) == 0) return(0);
	}
      if (LoadVectF(&(lplot->y)) == 0) return(0);
      if (LoadVectLI(&(lplot->style)) == 0) return(0);
      if (LoadVectC(&(lplot->strflag)) == 0) return(0);
      if (LoadVectC(&(lplot->strflag_kp)) == 0) return(0);
      if (LoadVectC(&(lplot->legend)) == 0) return(0);
      if (LoadVectF(&(lplot->brect)) == 0) return(0);
      if (LoadVectF(&(lplot->brect_kp)) == 0) return(0);
      if (LoadVectLI(&(lplot->aint)) == 0) return(0);
      if (LoadVectLI(&(lplot->aint_kp)) == 0) return(0);
      if (Store("plot2d",(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (plot): No more place \n");
      return(0);
    }
  return(1);
}


/*---------------------------------------------------------------------
  \encadre{Le cas de xgrid}
  ---------------------------------------------------------------------------*/

LoadGrid()
{ 
  struct xgrid_rec *lplot ;
  lplot= ((struct xgrid_rec *) MALLOC(sizeof(struct xgrid_rec)));
  if (lplot != NULL)
    {
      if (LoadLI(&lplot->style) == 0) return(0);
      if (LoadVectC(&(lplot->name))== 0) return(0);
      if (Store("xgrid",(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (grid): No more place \n");
      return(0);
    }
  return(1);
}


/*---------------------------------------------------------------------
  \encadre{Le cas du param3d}
  ---------------------------------------------------------------------------*/

LoadParam3D()
{
  struct param3d_rec *lplot;
  lplot= ((struct param3d_rec *) MALLOC(sizeof(struct param3d_rec)));
  if (lplot != NULL)
    {
      if (LoadLI(&lplot->n) == 0) return(0);
      if (LoadD(&lplot->teta) ==0) return(0);
      if (LoadD(&lplot->alpha) ==0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectF(&(lplot->x)) == 0) return(0);
      if (LoadVectF(&(lplot->y)) == 0) return(0);
      if (LoadVectF(&(lplot->z)) == 0) return(0);
      if (LoadVectC(&(lplot->legend)) == 0) return(0);
      if (LoadVectLI(&(lplot->flag)) == 0) return(0);
      if (LoadVectF(&(lplot->bbox))== 0) return(0);
      if (Store(lplot->name,(char *) lplot) == 0) return(0);
      
    }
  else
    {
      Scistring("\nLoad Plot (param3d): No more place \n");
      return(0);
    }
  return(1);
}


/*---------------------------------------------------------------------
  \encadre{Le cas des plot3d}
  ---------------------------------------------------------------------------*/

LoadPlot3D()
{
  struct plot3d_rec *lplot ;
  lplot= ((struct plot3d_rec *) MALLOC(sizeof(struct plot3d_rec)));
  if (lplot != NULL)
    {
      if (LoadLI(&lplot->p) == 0) return(0);
      if (LoadLI(&lplot->q) == 0) return(0);
      if (LoadD(&lplot->teta) == 0) return(0);
      if (LoadD(&lplot->alpha) == 0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectF(&(lplot->x)) == 0) return(0);
      if (LoadVectF(&(lplot->y)) == 0) return(0);
      if (LoadVectF(&(lplot->z)) == 0) return(0);
      if (LoadVectC(&(lplot->legend)) == 0) return(0);
      if (LoadVectLI(&(lplot->flag)) == 0) return(0);
      if (LoadVectF(&(lplot->bbox))== 0) return(0);
      if (Store(lplot->name,(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (plot3d): No more place \n");
      return(0);
    }
  return(1);
}

/*---------------------------------------------------------------------
  \encadre{Le cas des fac3d}
  ---------------------------------------------------------------------------*/

LoadFac3D()
{
  struct fac3d_rec *lplot;
  lplot= ((struct fac3d_rec *) MALLOC(sizeof(struct fac3d_rec)));
  if (lplot != NULL)
    {
      if (LoadLI(&lplot->p) == 0) return(0);
      if (LoadLI(&lplot->q) == 0) return(0);
      if (LoadD(&lplot->teta) == 0) return(0);
      if (LoadD(&lplot->alpha) == 0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectF(&(lplot->x)) == 0) return(0);
      if (LoadVectF(&(lplot->y)) == 0) return(0);
      if (LoadVectF(&(lplot->z)) == 0) return(0);
      if (LoadVectC(&(lplot->legend)) == 0) return(0);
      if (LoadVectLI(&(lplot->flag)) == 0) return(0);
      if (LoadVectF(&(lplot->bbox))== 0) return(0);
      if (Store(lplot->name,(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (fac3d): No more place \n");
      return(0);
    }
  return(1);
}

/*---------------------------------------------------------------------
  \encadre{Le cas des fec}
  ---------------------------------------------------------------------------*/

LoadFec()
{
  struct fec_rec *lplot;
  lplot= ((struct fec_rec *) MALLOC(sizeof(struct fec_rec)));
  if (lplot != NULL)
    {
      if (LoadLI(&lplot->Nnode) == 0) return(0);
      if (LoadLI(&lplot->Ntr) == 0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectF(&(lplot->x)) == 0) return(0);
      if (LoadVectF(&(lplot->y)) == 0) return(0);
      if (LoadVectF(&(lplot->triangles)) == 0) return(0);
      if (LoadVectF(&(lplot->func) ) == 0) return(0);
      if (LoadVectF(&(lplot->brect)) == 0) return(0);
      if (LoadVectF(&(lplot->brect_kp)) == 0) return(0);
      if (LoadVectLI(&(lplot->aaint)) == 0) return(0);
      if (LoadVectLI(&(lplot->aaint_kp)) == 0) return(0);
      if (LoadVectC(&(lplot->strflag)) == 0) return(0);
      if (LoadVectC(&(lplot->strflag_kp)) == 0) return(0);
      if (LoadVectC(&(lplot->legend))  == 0) return(0);
      if (Store(lplot->name,(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (fec): No more place \n");
      return(0);
    }
  return(1);
}


/*---------------------------------------------------------------------
  \encadre{Le cas des contours}
  ---------------------------------------------------------------------------*/

LoadContour()
{
  struct contour_rec *lplot;
  lplot= ((struct contour_rec *) MALLOC(sizeof(struct contour_rec)));
  if (lplot != NULL)
    { int res=1;
      if (LoadLI(&lplot->n1) == 0) return(0);
      if (LoadLI(&lplot->n2) == 0) return(0);
      if (LoadLI(&lplot->nz) == 0) return(0);
      if (LoadLI(&lplot->flagnz) == 0) return(0);
      if (lplot->flagnz != 0) 
	{
	  if (LoadVectF(&(lplot->zz))== 0) return(0);
	}
      if (LoadD(&lplot->teta)== 0) return(0);
      if (LoadD(&lplot->alpha)== 0) return(0);
      if (LoadD(&lplot->zlev)== 0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectF(&(lplot->x)) == 0) return(0);
      if (LoadVectF(&(lplot->y)) == 0) return(0);
      if (LoadVectF(&(lplot->z)) == 0) return(0);
      if (LoadVectC(&(lplot->legend)) == 0) return(0);
      if (LoadVectLI(&(lplot->flag)) == 0) return(0);
      if (LoadVectF(&(lplot->bbox)) == 0) return(0);
      if (Store(lplot->name,(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (contour): No more place \n");
      return(0);
    }
  return(1);
}

/*---------------------------------------------------------------------
  \encadre{Le cas des niveaux de gris }
  ---------------------------------------------------------------------------*/

/* Load the plot in the plot list 
   same arguments as gray */

LoadGray()
{
 
  struct gray_rec *lplot;
  lplot= ((struct gray_rec *) MALLOC(sizeof(struct gray_rec)));
  if (lplot != NULL)
    {
      if (LoadLI(&lplot->n1) == 0) return(0);
      if (LoadLI(&lplot->n2) == 0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectF(&(lplot->x)) == 0) return(0);
      if (LoadVectF(&(lplot->y)) == 0) return(0);
      if (LoadVectF(&(lplot->z)) == 0) return(0);
      if (LoadVectC(&(lplot->strflag)) == 0) return(0);
      if (LoadVectC(&(lplot->strflag_kp)) == 0) return(0);
      if (LoadVectF(&(lplot->brect)) == 0) return(0);
      if (LoadVectF(&(lplot->brect_kp)) == 0) return(0);
      if (LoadVectLI(&(lplot->aaint))  == 0) return(0);
      if (LoadVectLI(&(lplot->aaint_kp)) == 0) return(0);
      if (Store(lplot->name,(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (gray): No more place \n");
      return(0);
    }
  return(1);
}


/*---------------------------------------------------------------------
  \encadre{Le cas des champs de vecteurs}
  ---------------------------------------------------------------------------*/

LoadChamp()
{
  struct champ_rec *lplot;
  lplot= ((struct champ_rec *) MALLOC(sizeof(struct champ_rec)));
  if (lplot != NULL)
    {

      if (LoadLI(&lplot->n1) == 0) return(0);
      if (LoadLI(&lplot->n2) == 0) return(0);
      if (LoadD(&lplot->arfact) == 0) return(0);
      if (LoadVectC(&(lplot->name)) == 0) return(0);
      if (LoadVectF(&(lplot->x)) == 0) return(0);
      if (LoadVectF(&(lplot->y)) == 0) return(0);
      if (LoadVectF(&(lplot->fx)) == 0) return(0);
      if (LoadVectF(&(lplot->fy)) == 0) return(0);
      if (LoadVectC(&(lplot->strflag)) == 0) return(0);
      if (LoadVectC(&(lplot->strflag_kp)) == 0) return(0);
      if (LoadVectF(&(lplot->vrect)) == 0) return(0);
      if (LoadVectF(&(lplot->vrect_kp))== 0) return(0);
      if (Store("champ",(char *) lplot) == 0) return(0);
      
    }
  else 
    {
      Scistring("\nLoad Plot (champ): No more place \n");
      return(0);
    }
  return(1);
}

/*---------------------------------------------------------------------
  Relecture 
  ---------------------------------------------------------------------------*/

static char RFname[128];
static FILE *RF ;
static XDR rxdrs[1] ;
static u_int rcount ;
static u_int rszof ;


typedef  struct  {
  char *name;
  int  (*Load)();} LoadTable;

static LoadTable LoadCTable[] ={
  "champ",LoadChamp,
  "contour",LoadContour,
  "fac3d",LoadFac3D,
  "fac3d1",LoadFac3D,
  "fec",LoadFec,
  "gray",LoadGray,
  "param3d",LoadParam3D,
  "plot2d",LoadPlot,
  "plot3d",LoadPlot3D,
  "plot3d1",LoadPlot3D,
  "scale",LoadEch,
  "xcall1",LoadXcall1,
  "xgrid",LoadGrid,
  (char *)NULL,NULL};

C2F(xloadplots)(fname1,lvx)
     char *fname1;
     integer lvx;
{
  integer verb=0,cur,na;
  char name[4];
  char *type;
  struct listplot *list;
  strncpy(RFname,fname1,128);
#ifdef __STDC__
  RF = fopen(RFname,"rb") ;
#else
  RF = fopen(RFname,"r") ;
#endif
  if( RF == NULL)
    {
      sciprint("fopen failed\r\n") ;
      return;
    }
  xdrstdio_create(rxdrs, RF, XDR_DECODE) ;
  if ( LoadVectC(&type) == 0 ) 
    {
      sciprint("Wrong plot file : %s\n\n",fname1);
      return;
    }
  if ( strcmp(type,"SciG1.0") != 0) 
    {
      sciprint("Wrong plot file : %s\n\n",fname1);
      return;
    }
  while (LoadVectC(&type) != 0 && strcmp(type,"endplots") != 0) 
    {
      if (LoadTPlot(type) == 0) break;
    }
  assert(fflush((FILE *)rxdrs->x_private) != EOF) ; 
  assert(fclose(RF) != EOF) ;
  /** we plot the Loaded graphics **/
  GetDriver1_(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if ( (GetDriver_()) !='R')
    SetDriver_("Rec",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  CPixmapResize1();
  C2F(dr)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xreplay","v",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xsetdr",name, PI0, PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}

int LoadTPlot(type)
     char type[];
{
  int i=0;
  while (LoadCTable[i].name != (char *) NULL)
    {
      int j;
      j = strcmp(type,LoadCTable[i].name);
      if ( j == 0 ) 
	{ 
	  return( (*(LoadCTable[i].Load))());
	}
      else 
	{ 
	  if ( j <= 0)
	    {
	      sciprint("Unknown Plot type <%s>\r\n",type);
	      return(0);
	    }
	  else i++;
	}
    }
  return(0);
}

int LoadD(x)
     double *x;
{
  rszof = sizeof(double) ;
  rcount = (u_int) 1;
  assert( xdr_vector(rxdrs, (char *)x, rcount, rszof, xdr_double)) ;
  return(1);
}

int LoadLI(ix)
     integer *ix;
{
  rszof = sizeof(int) ;
  rcount = (u_int)1;
  assert( xdr_vector(rxdrs, (char *)ix, rcount, rszof, xdr_int)) ;
  return(1);
}
	
int LoadC(c)
     char *c;
{
  assert( xdr_vector(rxdrs,(char *) &rszof,(u_int)1,(u_int) sizeof(u_int), xdr_u_int)) ;
  assert( xdr_opaque(rxdrs,c,rszof));
  return(1);
}
      
LoadVectI(nx)
     int **nx;
{ 
  int nx1=1;
  rszof = sizeof(int) ;
  assert( xdr_vector(rxdrs,(char *) &rcount,(u_int)1,(u_int) sizeof(u_int), xdr_u_int)) ;      
  *nx = (int *)  MALLOC(rcount*sizeof(int));
  if ( *nx == NULL) return(0);
  assert( xdr_vector(rxdrs, (char *)*nx, rcount, rszof, xdr_int)) ;
  return(1);
}


int LoadVectLI(nx)
     integer **nx;
{ 
  integer nx1=1;
  /** Attention integer peut etre un long int **/
  rszof = sizeof(int) ;
  assert( xdr_vector(rxdrs,(char *) &rcount,(u_int)1,(u_int) sizeof(u_int), xdr_u_int)) ;
  *nx = (integer *)  MALLOC(rcount*sizeof(integer));
  if ( *nx == NULL) return(0);
  assert( xdr_vector(rxdrs, (char *)*nx, rcount, rszof, xdr_int)) ;
  return(1);
}

int    LoadVectF(nx)
     double **nx;
{
  double nx1=0.0;
  rszof = sizeof(double) ;
  assert( xdr_vector(rxdrs,(char *) &rcount,(u_int)1,(u_int) sizeof(u_int), xdr_u_int)) ;
  *nx = (double *)  MALLOC(rcount*sizeof(double));
  if ( *nx == NULL) return(0);
  assert( xdr_vector(rxdrs, (char *) *nx, rcount, rszof, xdr_double)) ;
  return(1);
}

int LoadVectC(nx)
     char **nx;
{
  char nx1='1';
  assert( xdr_vector(rxdrs,(char *) &rszof,(u_int)1,(u_int) sizeof(u_int), xdr_u_int)) ;
  *nx = (char *)  MALLOC(rszof);
  if ( *nx == NULL) return(0);
  assert( xdr_opaque(rxdrs, *nx,rszof));
  return(1);
}

