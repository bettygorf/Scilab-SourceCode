#include "../machine.h"
#include <string.h>
typedef struct {
  double* x;      /* continuous  state */
  integer* xptr;  /* vector of pointers on block states */
  double* z;      /* discrete state */
  integer* zptr;  /* vector of pointers on block states */
  integer* iz;      /* unused */
  integer* izptr;  /* vector of pointers on iz */
  integer* inpptr; /* vector of pointers on block inputs */
  integer* inplnk;
  integer* outptr;/* vector of pointers on block outputs */
  integer* outlnk;
  integer* lnkptr;
  integer nlnkptr; /* size of lnkptr */
  double * rpar;  /* vector of real parameters */
  integer* rpptr; /* vector of pointers on block real parameters */
  integer* ipar;  /* vector of integer parameters */
  integer* ipptr; /* vector of pointers on block integer parameters */
  integer nblk;   /* number of  blocks */
  double * outtb; /* vector of outputs*/
  integer nout;   /* size of outtb */
  integer* subs;  /* import structure */
  integer nsubs;  /* number of imported data */
  double* tevts;
  integer* evtspt;
  integer nevts;
  integer pointi;
  integer *oord;
  integer *zord;
  integer *funptr; /* block indexes */
  integer *funtyp; /* block types */
} ScicosImport;

extern struct {
  integer kfun;
} C2F(curblk);



ScicosImport  scicos_imp={
(double *) NULL,   /* x */
(integer *) NULL,  /* xptr */
(double *) NULL,   /* z */
(integer *) NULL,  /* zptr */
(integer *) NULL,  /* iz */
(integer *) NULL,  /* izptr */

(integer *) NULL,  /* inpptr */
(integer *) NULL,  /* inplnk */
(integer *) NULL,  /* outptr */
(integer *) NULL,  /* outlnk */
(integer *) NULL,  /* lnkptr */
0,                 /* nlnkptr */
(double *) NULL,   /* rpar */
(integer *) NULL,  /* rpptr */
(integer *) NULL,  /* ipar */
(integer *) NULL,  /* ipptr */
0,                 /* nblk */
(double *) NULL,   /* outtb */
0,                 /* nout */
(integer *) NULL,  /* subs */
0,                 /* nsubs */
(double *) NULL,   /* tevts */
(integer *) NULL,  /* evtspt */
0,                 /* nevts */
0,                 /* pointi */
(integer *) NULL,  /* oord */
(integer *) NULL,  /* zord */
(integer *) NULL,  /* funptr */
(integer *) NULL   /* funtyp */
};

void  
C2F(makescicosimport)(x,xptr,z,zptr,iz,izptr,
     inpptr,inplnk,outptr,outlnk,lnkptr,nlnkptr,
     rpar,rpptr,ipar,ipptr,nblk,outtb,nout,subs,nsubs,
     tevts,evtspt,nevts,pointi,oord,zord,
     funptr,funtyp)
     
double *x ,*z,*outtb,*rpar,*tevts;
integer *xptr,*zptr,*iz,*izptr,*inpptr,*inplnk,*outptr,*outlnk,*lnkptr;
integer *nlnkptr,*rpptr,*ipar,*ipptr,*nblk,*nout,*subs,*nsubs;
integer *evtspt,*nevts,*pointi,*oord,*zord,*funptr,*funtyp;
     
{
    scicos_imp.x=x;
    scicos_imp.xptr=xptr;
    scicos_imp.z=z;
    scicos_imp.zptr=zptr;
    scicos_imp.iz=iz;
    scicos_imp.izptr=izptr;

    scicos_imp.inpptr=inpptr;
    scicos_imp.inplnk=inplnk;
    scicos_imp.outptr=outptr;
    scicos_imp.outlnk=outlnk;
    scicos_imp.lnkptr=lnkptr;
    scicos_imp.nlnkptr=*nlnkptr;

    scicos_imp.rpar=rpar;
    scicos_imp.rpptr=rpptr;
    scicos_imp.ipar=ipar;
    scicos_imp.ipptr=ipptr;
    scicos_imp.nblk=*nblk;
    scicos_imp.outtb=outtb;
    scicos_imp.nout=*nout;

    scicos_imp.subs=subs;
    scicos_imp.nsubs=*nsubs;

    scicos_imp.tevts=tevts;
    scicos_imp.evtspt=evtspt;
    scicos_imp.nevts=*nevts;
    scicos_imp.pointi=*pointi;

    scicos_imp.oord=oord;
    scicos_imp.zord=zord;

    scicos_imp.funptr=funptr;
    scicos_imp.funtyp=funtyp;
}

void
C2F(clearscicosimport)()
{
    scicos_imp.x=(double *) NULL;
    scicos_imp.xptr=(integer *) NULL;
    scicos_imp.z=(double *) NULL;
    scicos_imp.zptr=(integer *) NULL;
    scicos_imp.iz=(integer *) NULL;
    scicos_imp.izptr=(integer *) NULL;

    scicos_imp.inpptr=(integer *) NULL;
    scicos_imp.inplnk=(integer *) NULL;
    scicos_imp.outptr=(integer *) NULL;
    scicos_imp.outlnk=(integer *) NULL;
    scicos_imp.lnkptr=(integer *) NULL;
    scicos_imp.nlnkptr=0;

    scicos_imp.rpar=(double *) NULL;
    scicos_imp.rpptr=(integer *) NULL;
    scicos_imp.ipar=(integer *) NULL;
    scicos_imp.ipptr=(integer *) NULL;
    scicos_imp.nblk=0;
    scicos_imp.outtb=(double *) NULL;
    scicos_imp.nout=0;

    scicos_imp.subs=(integer *) NULL;
    scicos_imp.nsubs=0;
    scicos_imp.tevts=(double *) NULL;
    scicos_imp.evtspt=(integer *) NULL;
    scicos_imp.nevts=0;
    scicos_imp.pointi=0;

    scicos_imp.oord=(integer *) NULL;
    scicos_imp.zord=(integer *) NULL;

    scicos_imp.funptr=(integer *) NULL;
    scicos_imp.funtyp=(integer *) NULL;

}

integer  
C2F(getscicosvars)(what,v,nv,type)
integer *what;  /* data structure selection */
double **v;    /* Pointer to the beginning of the imported data */
integer *nv;   /* size of the imported data */
integer *type ;/* type of the imported data 0:integer,1:double */
{
    int nblk;

    if (scicos_imp.x==(double *)NULL){
	*v=(void *) NULL;
	return(2); /* undefined import table scicos is not running */
    }
    nblk=scicos_imp.nblk;
    /* imported from */
    switch (*what) {
    case 1 :			/* continuous state */
	*nv=(integer) (scicos_imp.xptr[nblk]-scicos_imp.xptr[0]);
        *v=(void *)(scicos_imp.x);
	*type=1;
	break;
    case 2 :			/* continuous state splitting array*/
	*nv=(integer)(nblk+1);
	*v=(void *) (scicos_imp.xptr);
	*type=0;
	break;
    case 3 :			/* discrete state */
	*nv=(integer)(scicos_imp.zptr[nblk]-scicos_imp.zptr[0]);
	*v=(void *) (scicos_imp.z);
	*type=1;
	break;
    case 4 :			/* discrete  state splitting array*/
	*nv=(integer)(nblk+1);
	*v=(void *) (scicos_imp.zptr);
	*type=0;
	break;
    case 5 :			/* rpar */
	*nv=(integer)(scicos_imp.rpptr[nblk]-scicos_imp.rpptr[0]);
	*v=(void *) (scicos_imp.rpar);
	*type=1;
	break;
    case 6 :			/* rpar  splitting array*/
	*nv=(integer)(nblk+1);
	*v=(void *) (scicos_imp.rpptr);
	*type=0;
	break;
    case 7 :			/* ipar */
	*nv=(integer)(scicos_imp.ipptr[nblk]-scicos_imp.ipptr[0]);
	*v=(void *) (scicos_imp.ipar);
	*type=0;
	break;
    case 8 :			/* ipar  splitting array*/
	*nv=(integer)(nblk+1);
	*v=(void *) (scicos_imp.ipptr);
	*type=0;
	break;
    case 9 :			/* outtb */
	*nv=(integer)(scicos_imp.nout);
	*v=(void *) (scicos_imp.outtb);
	*type=1;
	break;
    case 10 :                   /* inpptr */
	*nv=(integer)(nblk+1);
	*v=(void *) (scicos_imp.inpptr); 
	*type=0;
	break;
    case 11 :                   /* outptr */
	*nv=(integer)(nblk+1);
	*v=(void *) (scicos_imp.outptr); 
	*type=0;
	break;
    case 12 :                   /* inplnk */
	*nv=(integer)(scicos_imp.inpptr[nblk]-scicos_imp.inpptr[0]); 
	*v=(void *) (scicos_imp.inplnk); 
	*type=0;
	break;
    case 13 :                   /* outlnk */
	*nv=(integer)(scicos_imp.outptr[nblk]-scicos_imp.outptr[0]); 
	*v=(void *) (scicos_imp.outlnk); 
	*type=0;
	break;
    case 14 :                   /* lnkptr */
	*nv=(integer)(scicos_imp.nlnkptr);
	*v=(void *) (scicos_imp.lnkptr); 
	*type=0;
	break;
    }
    return(0);
}
void 
C2F(getlabel)(kfun,label,n)
integer *n, *kfun;  /* length of the label */
char **label;    
{
    int k;
    int job=1;

    k= *kfun;
    *n=(integer)(scicos_imp.izptr[k]-scicos_imp.izptr[k-1]);
    if (*n>0 )
	F2C(cvstr)(n,&(scicos_imp.iz[scicos_imp.izptr[k-1]-1]),*label,&job,*n);
}
void 
C2F(getscilabel)(kfun,label,n)
integer *n, *kfun;  /* length of the label */
integer label[];    
{
    int k,i;
    integer *u,*y;

    k= *kfun;
    *n=(integer)(scicos_imp.izptr[k]-scicos_imp.izptr[k-1]);
    if (*n>0 ) {
	u=(integer *)&(scicos_imp.iz[scicos_imp.izptr[k-1]-1]);
	y=label;
	for (i=0;i<*n;i++)
	    *(y++)=*(u++);  
	}
}

integer C2F(getcurblock)()
{
return(C2F(curblk).kfun);
    }
