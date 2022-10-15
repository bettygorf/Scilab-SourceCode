#include "../machine.h"

#define NULL 0

void C2F(eulerc)(alpho,la2,lp2,ls2,ma,mm,n,phiw,sigma,sigmadim)
int *alpho,*la2,*lp2,*ls2,*ma,*mm,*n,*phiw,**sigma,*sigmadim;
{
  int *alphi,*beta,*deg,*hp1,*hp2,*ihp1,*ihp2,*imin;
  int *sigmaw;
  int edg,eul,i,ma1;
  int isize = sizeof(int);
  
  ma1 = *ma + 1;
  
  if ((sigmaw = (int *)malloc(ma1 * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }

  F2C(euler)(&eul,alpho,la2,lp2,ls2,ma,&ma1,mm,n,phiw,sigmaw);

  if (eul == 0)
    *sigmadim = 0;
  else {
    if ((*sigma = (int *)malloc(*ma * isize)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    *sigmadim = *ma;
    edg = sigmaw[*ma];
    (*sigma)[0] = edg;
    for (i = 2; i <= *ma; i++) {
      if (edg == -1) break;
      edg = sigmaw[edg-1];
      (*sigma)[i-1] = edg;
    }
  }

  free(sigmaw);
}
