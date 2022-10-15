
#define spINSIDE_SPARSE
#include "spConfig.h"
#include "spmatrix.h"
#include "spDefs.h"


#define SIZE 800

#include "../machine.h"

main(argc,argv)
int argc;
char **argv;
{
  double b[SIZE],x[SIZE];
  int error,n=20,i,j;
  spREAL *pelement;
  char * matrix;
  if ( argc == 2)
    {
      sscanf(argv[1],"%d",&n);
      n = ( n > 800) ? 800  :n;
    };
  fprintf(stderr,"Matrix size :%d",n);
  matrix = spCreate(n,0,&error);
  if (error != spOKAY) 
    fprintf(stderr,"Unable to create matrix");
  for (i = 1; i <= n; i++) 
    for (j = 1; j <= n; j++) 
    {
      pelement = spGetElement(matrix,i,j);
      if (pelement == 0) 
	fprintf(stderr,"Not enough memory to create element");
      spADD_REAL_ELEMENT(pelement,(spREAL) 1.0/((double) (i+j)+1));
    }
  error = spFactor(matrix);
  switch (error) {
  case spZERO_DIAG:
    fprintf(stderr,"zero_diag: A zero was encountered on the diagonal the matrix ");
    break;
  case spNO_MEMORY:
    fprintf(stderr,"Not enough memory");
    break;
  case spSINGULAR:
    fprintf(stdout,"Singular matrix");
    break;
  case spSMALL_PIVOT:
    fprintf(stdout,"SMALL_PIVOT : matrix is singular at precision level");
    break;
  }
  spSolve(matrix,(spREAL*)b,(spREAL*)x);
  spDestroy(matrix);
  return(0);
}



/*
 * MEMORY ALLOCATION
 */


char * malloc1(n)
unsigned n;
{
  char *loc;
  loc = (char *) malloc(n);
  fprintf(stderr,"%d alloc\n",(int) loc);
  return(loc);
}

char * realloc1(p,n)
char *p;
unsigned n;
{
  char *loc;
  loc = (char *) realloc(p,n);
  fprintf(stderr,"%d realloc of %d \n",(int)p,(int) loc);
  return(loc);
};
