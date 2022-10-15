      integer function size(i,nl,nc)
c
      include '../stack.h'
      common/adre/lbot,ie,is,ipal,nbarg,ll(30)
c
c
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      iiadr=iadr(ll(i))
      nl=istk(iiadr-3)
      nc=istk(iiadr-2)
      size=nl*nc
c
      end
