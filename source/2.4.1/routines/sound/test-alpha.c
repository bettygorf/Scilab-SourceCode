/* Copyright INRIA */
#include "st.h"
#include "libst.h"
#include <values.h>

int main()
{
  long buf;
#if defined(__alpha)
  register int datum;
#else
  register long datum;
#endif
  datum = 44575;
  buf = ((int) LEFT(datum, 16));
  fprintf(stderr,"res = %ld \n",buf);
  fprintf(stderr,"long=%d int=%d res = %ld \n",sizeof(long),sizeof(int),buf);
  buf = 44575;
  buf = ((int) LEFT(datum, 16));
  fprintf(stderr,"res = %ld \n",buf);
  fprintf(stderr,"long=%d int=%d res = %ld \n",sizeof(long),sizeof(int),buf);
  buf= MAXLONG;
  datum = MAXINT;
  fprintf(stderr,"maxlong=%ld maxint=%d res \n",buf,datum);
  return 0;
}

