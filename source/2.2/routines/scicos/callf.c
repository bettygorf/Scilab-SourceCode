#include <string.h>
#include "../machine.h"

typedef  struct  {
  char *name;
  void  (*fonc)();
} OpTab ;
void  vide() {};
extern void  F2C(sciblk)();

#include "blocks.h"

C2F(callf)(i,t,xc,nx,z,nz,uc,nu,nclock,rpar,nrpar,ipar,nipar,out,nout,flag)
integer *i,*ipar,*flag,*nx,*nz,*nu,*nclock,*nrpar,*nipar,*nout;
double *t,*xc,*z,*uc,*rpar,*out;
    {
	double *v;
	int ii;
	if (*i<0) {
	    ii=-(*i);
	    F2C(sciblk)(&ii,t,xc,nx,z,nz,uc,nu,rpar,nrpar,ipar,nipar,
			nclock,out,nout,flag);
	}
	else if (*i<=ntabsim) {
	    (*(tabsim[*i-1].fonc))(t,xc,nx,z,nz,uc,nu,rpar,nrpar,ipar,nipar,
				   nclock,out,nout,flag);
	}
	else {
	    ii=*i-ntabsim-1;
	    F2C(dyncall)(&ii,t,xc,nx,z,nz,uc,nu,rpar,nrpar,
			 *ipar,nipar,nclock,out,nout,flag,v,v,v,v,v,
			 v,v,v,v,v,v,v,v,v,v);
	}
    }

integer C2F(funnum)(fname)
char * fname;
{
    int i=0,ln;
    integer job=0;
    integer loc;

    while ( tabsim[i].name != (char *) NULL) {
	if ( strcmp(fname,tabsim[i].name) == 0 ) return(i+1);
	i++;
    }
    ln=strlen(fname);
    F2C(tlink)(fname,&job,&loc,ln);
    if (loc>0) 
	return(ntabsim+(int)loc);
    return(0);
}
