#include <string.h>
#include <malloc.h>

#include "../machine.h"

void C2F(l2adj)(lp,ls,n1,n,m,a)
int *lp,*ls,*n1,*n,*m,**a;
{
  int i,j;
  *n = *n1 - 1;
  if ((*a = (int *)malloc((*n * *n) * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 0; i < *n * *n; i++) (*a)[i] = 0;
  for (i = 1; i <= *n; i++)
    for (j = lp[i-1]; j <= lp[i]-1; j++)
      (*a)[(*n * (ls[j-1]-1) + i) - 1] = 1;
}

void C2F(adj2l)(a,n,lp,ls,n1,m)
int *a,*n,**lp,**ls,*n1,*m;
{
  int i,ip,j,mmax,na;
  mmax = *n * (*n - 1);
  *n1 = *n + 1;
  if ((*ls = (int *)malloc(mmax * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((*lp = (int *)malloc((*n + 1) * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  na = 0; (*lp)[0] = 1; ip = 1;
  for (i = 1; i <= *n; i++) {
    for (j = 1; j <= *n; j++) {
      if (a[*n * (j - 1) + i - 1] == 1) {
	(*ls)[ip-1] = j;
	ip++; na++;
      }
    }
    (*lp)[i] = ip;
  }
  *m = na;
}
