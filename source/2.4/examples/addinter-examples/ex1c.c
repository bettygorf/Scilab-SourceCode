/* Copyright INRIA */

/**************************************************
*     inputs:  ch, a,b and c; ia,ib and mc,nc 
*     ch=character, a=integer, b=float and c=double 
*     ia,ib and [mc,nc] are the dimensions of a,b and c resp. 
*     outputs: a,b,c,d 
*     if ch='mul'   a,b and c = 2 * (a,b and c) 
*     and d of same dimensions as c with 
*     d(i,j)=(i+j)*c(i,j) 
*     if ch='add' a,b and c = 2 + (a,b and c) 
*     d(i,j)=(i+j)+c(i,j) 
*     w is a working array of size [mc,nc] 
*********************************************/


int foubare2c(ch, a, ia, b, ib, c, mc, nc, d, w, err)
     char *ch;
     int *a, *ia;
     float *b;
     int *ib;
     double *c;
     int *mc, *nc;
     double *d, *w;
     int *err;
{
  static int i, j, k;
  *err = 0;
  if (strcmp(ch, "mul") == 0) 
    {
      for (k = 0 ; k < *ib; ++k) 
	a[k] <<= 1;
      for (k = 0; k < *ib ; ++k) 
	b[k] *= (float)2.;
      for (i =  0 ; i < *mc ; ++i) 
	for (j = 0 ;  j < *nc ; ++j) 
	  c[i + j *(*mc) ] *= 2.;
      for (i = 0 ; i < *mc ; ++i) 
	for (j = 0 ; j < *nc ; ++j) 
	    {
	      w[i + j * (*mc) ] = (double) (i + j);
	      d[i + j * (*mc) ] = w[i + j *(*mc)] * c[i + j *(*mc)];
	    }
    } 
  else if (strcmp(ch, "add") == 0) 
    {
      for (k = 0; k < *ia ; ++k) 
	a[k] += 2;
      for (k = 0 ; k < *ib ; ++k) 
	b[k] += (float)2.;
      for (i =  0 ; i < *mc ; ++i) 
	for (j = 0 ;  j < *nc ; ++j) 
	  c[i + j *(*mc) ] += 2.;
      for (i = 0 ; i < *mc ; ++i) 
	for (j = 0 ; j < *nc ; ++j) 
	    {
	      w[i + j * (*mc) ] = (double) (i + j);
	      d[i + j * (*mc) ] = w[i + j *(*mc)] + c[i + j *(*mc)];
	    }
    } 
  else 
    {
      *err = 1;
    }
  return(0);
}


