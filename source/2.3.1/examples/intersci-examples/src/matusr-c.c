#include "../../../routines/machine.h"
#include <malloc.h> 

/*************************************************************
  Example of an integer array created by C code
  converted to output Scilab variable by cintf
*************************************************************/

C2F(ccalc3) ( a,m,n) 
     int **a,*m,*n ;
{
  int i ;
  *n=5 ;
  *m=3 ;
  *a= ( int *) malloc( (unsigned) (*m)*(*n) *sizeof(int));
  for ( i= 0 ; i < (*m)*(*n) ; i++) (*a)[i] = i ;
}


/*************************************************************
  Example of using a character string array sent by the interface.
  All 'a' are replaced by 'o'.
  Scilab type stringmat existing in stk.
  Fortran type Cstrinv.
*************************************************************/

C2F(ccalc4)(a,m,n) 
     char ***a;
     int *m,*n;
{
  int i;
  for ( i = 0 ; i < *m*(*n) ; i++) 
    {
      char *loc = (*a)[i];
      int j ;
      for ( j = 0 ; j < strlen(loc); j++) 
	{
	  if ( loc[j] =='a' ) loc[j] ='o';
	}
    }
}

/*************************************************************
  Example of using an array of character string created here.
  Its size is sent back as an output.
  It is converted into Scilab variable in the interface program.
  The allocated array is freed.
  stringmat scilab type not existing in stk and Cstrinv  Fortran type
*************************************************************/

C2F(ccalc5)(a,m,n)
     char ***a;
     int *m,*n;
{
  int i,nstring;
  *m=3;
  *n=2;
  nstring= (*m)*(*n);

  *a =(char **) malloc((unsigned) (nstring * sizeof(char *)));
  if ( *a ==0) 
    {
      return;
    }
  for ( i=0  ; i< nstring ; i++) 
    {
      (*a)[i] = (char *) malloc ((8)*sizeof(char));
      sprintf((*a)[i],"char %d",i);
    }
}

