
#include "mex.h"

void
mexfunction7(int nlhs,mxArray *plhs[],int nrhs, mxArray *prhs[])
{
  double  *pr, *pi;
  int     *ir, *jc;
  int      row, col, total=0, number_of_columns;
  int      starting_row_index, stopping_row_index, 
    current_row_index;

  /* Get the starting positions of the data in the sparse array. */  
  if (! mxIsSparse(prhs[0]) ) mexErrMsgTxt("requires sparse input!");
  pr = mxGetPr(prhs[0]);
  ir = mxGetIr(prhs[0]);
  jc = mxGetJc(prhs[0]);

  /* Display the nonzero elements of the sparse array. */ 
  number_of_columns = mxGetN(prhs[0]);
  for (col=0; col<number_of_columns; col++)  { 
    starting_row_index = jc[col]; 
    stopping_row_index = jc[col+1]; 
    if (starting_row_index == stopping_row_index)
      continue;
    else 
      {
	for (current_row_index = starting_row_index; 
	     current_row_index < stopping_row_index; 
	     current_row_index++) 
	  {       
	    mexPrintf("(%d , %d) = %g \r\n", ir[current_row_index]+1, 
		      col+1, pr[total]);
	    total++;
	  }
      }
  }
}

