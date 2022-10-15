      integer function msize(i,nl,nc)
c
      include '../stack.h'
c
      integer iadr
c
      iadr(l)=l+l-1
c
      iiadr=iadr(ladr(i))
      nl=istk(iiadr-3)
      nc=istk(iiadr-2)
      msize=nl*nc
c
      end
