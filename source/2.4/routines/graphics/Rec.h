
/* Copyright (C) 1998 Chancelier Jean-Philippe */

/*---------------------------------------------------------------------
\encadre{Le cas des xcall1}
---------------------------------------------------------------------------*/

struct xcall1_rec {char *fname,*string;
		   integer *x1,*x2,*x3,*x4,*x5,*x6;
		   double *dx1,*dx2,*dx3,*dx4;
		   integer n1,n2,n3,n4,n5,n6,ndx1,ndx2,ndx3,ndx4;
		 } ;

/*---------------------------------------------------------------------
\encadre{Le cas des changement d'echelle}
---------------------------------------------------------------------------*/


struct scale_rec { char *name; double *Wrect,*Frect,*Frect_kp; char logflag[2]; } ;

  
/*---------------------------------------------------------------------
\encadre{Le cas des plot2d}
---------------------------------------------------------------------------*/

struct plot2d_rec {char *name,*xf;
		   double *x,*y,*brect;
		   integer   n1,n2,*style,*aint;
		   char *legend,*strflag;
		   char *strflag_kp;
		   integer *aint_kp;
		   double *brect_kp;
		 } ;

  
/*---------------------------------------------------------------------
\encadre{Le cas de xgrid}
---------------------------------------------------------------------------*/

struct xgrid_rec { char *name;
		   integer style ;
		 } ;


/*---------------------------------------------------------------------
\encadre{Le cas du param3d}
---------------------------------------------------------------------------*/

struct param3d_rec {char *name;
		    double *x,*y,*z,*bbox;
		    integer   n,*flag;
		    double teta,alpha;
		    char  *legend;
		 } ;

struct param3d1_rec {char *name;
		    double *x,*y,*z,*bbox;
		    integer   n,m,iflag,*colors,*flag;
		    double teta,alpha;
		    char  *legend;
		 } ;

/*---------------------------------------------------------------------
\encadre{Le cas des plot3d}
---------------------------------------------------------------------------*/

struct plot3d_rec {char *name;
		   double *x,*y,*z,*bbox;
		   integer   p,q,*flag;
		   double teta,alpha;
		   char  *legend;
		 } ;


/*---------------------------------------------------------------------
\encadre{Le cas des fac3d}
---------------------------------------------------------------------------*/

struct fac3d_rec {char *name;
		   double *x,*y,*z,*bbox;
		   integer   p,q,*flag,*cvect;
		   double teta,alpha;
		   char  *legend;
		 } ;

/*---------------------------------------------------------------------
\encadre{Le cas des fec}
---------------------------------------------------------------------------*/


struct fec_rec {char *name;
		double *x,*y,*triangles,*func;
		integer   Nnode,Ntr;
		double *brect;
		integer  *aaint;
		char  *legend,*strflag;
		char *strflag_kp;
		double *brect_kp;
		integer *aaint_kp;
	      } ;

/*---------------------------------------------------------------------
\encadre{Le cas des contours}
---------------------------------------------------------------------------*/
/** general **/
struct contour_rec {char *name;
		    double *x,*y,*z,*zz,zlev;
		    integer   n1,n2,nz,flagnz;
		    double *bbox;
		    double teta,alpha;
		    integer *flag;
		    char  *legend;
		 } ;


/** version 2d **/

struct contour2d_rec {char *name;
  double *x,*y,*z,*zz;
  integer   n1,n2,nz,flagnz;
  double *brect;
  integer *style,*aint;
  char *legend,*strflag;
  char *strflag_kp;
  integer *aint_kp;
  double *brect_kp;
} ;



/*---------------------------------------------------------------------
\encadre{Le cas des niveaux de gris }
---------------------------------------------------------------------------*/

struct gray_rec {char *name,*strflag;
		 double *x,*y,*z,*brect;
		 integer   n1,n2,*aaint;
		 integer *aaint_kp;
		 double *brect_kp;
		 char *strflag_kp;
		 } ;

/*---------------------------------------------------------------------
\encadre{Le cas des champs de vecteurs}
---------------------------------------------------------------------------*/

struct champ_rec {char *name;
		  double *x,*y,*fx,*fy,*vrect,arfact;
		  integer   n1,n2;
		  char *strflag;
		  char *strflag_kp;
		  double *vrect_kp;
		} ;

/*---------------------------------------------------------------------
\encadre{Gestion d'une liste de graphiques}
C'est un liste doublement chain\'ee. (pout faciliter la destruction d'un elemnet dans la chaine.
---------------------------------------------------------------------------*/

struct listplot {
            char *type;
	    int  window;
            char *theplot; 
	    struct listplot   *ptrplot;
	    struct listplot   *previous;
	  } ;

extern struct listplot *ListPFirst ;







