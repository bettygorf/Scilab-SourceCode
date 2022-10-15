#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "../../../routines/machine.h"
#include <string.h> 
#include <stdio.h>

/*************************************************************
 *  Example of array created by C code
 *  converted to Scilab output variable
 *************************************************************/

/*     integer array    */

int intarrayc( a, m, n, ierr) 
     int *m, *n,*ierr;
     int **a;
{
  int i ;
  *n=5 ;
  *m=3 ;
  *a= ( int *) malloc( (unsigned) (*m)*(*n) *sizeof(int));
  if ( *a != (int *) 0)   
    {
      *ierr=0;
      for ( i= 0 ; i < (*m)*(*n) ; i++) (*a)[i] = i;
    }
  else 
      *ierr=1;
  return(0);
}

/*     double array    */

int dblearrayc( a, m, n,ierr)
     int *m, *n,*ierr;
     double **a;
{
  int i ;
  *n=5 ;
  *m=3 ;
  *a= ( double *) malloc( (unsigned) (*m)*(*n) *sizeof(double));
  if ( *a != (double *) 0)   
    {
      *ierr=0;
      for ( i= 0 ; i < (*m)*(*n) ; i++) (*a)[i] = i+1;
    }
  else 
    *ierr=1;
  return(0);
}

/*************************************************************
 * Example of using a character string sent by the interface.
 * All 'a' are replaced by 'o'.
 *************************************************************/

int as2osc(thechain)
     char *thechain;
{
    static int k, l;
    l = strlen(thechain);
    for (k = 1; k <= l; ++k) {
	if (*(unsigned char *)&thechain[k - 1] == 'a') {
	    *(unsigned char *)&thechain[k - 1] = 'o';
	}
    }
} 

/*************************************************************
 * Example of character string created here.
 * Its length is sent back as an output.
 * It is converted into Scilab variable in the interface program.
 * The allocated array is freed in the interface program.
 *************************************************************/

#define MYSTR "Scilab is ..."

int crestrc( a, m, ierr)
     int *m,*ierr;
     char **a;
{
  *m= strlen(MYSTR);
  *a= (char *) malloc((unsigned) (*m+1)*sizeof(char));
  if ( *a != (char *) 0) 
    {
      *ierr=0;
      sprintf((*a),MYSTR);
    }
  else
    {
      *ierr=1;
      sciprint(" malloc : No more space \r\n");
    }
  return(0);
}
