      logical function compil(n,code,val1,val2,val3,val4)
      integer val1,val2,val3,val4,n,l
      include '../stack.h'
      integer code,sadr
      sadr(l)=(l/2)+1
      compil=.false.
      if (comp(1).eq.0) return
      compil=.true.
      l=comp(1)
      err=sadr(l+2*(n+1))-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(l)=code
      if ( n.ge.1) istk(l+1)=val1
      if ( n.ge.2) istk(l+2)=val2
      if ( n.ge.3) istk(l+3)=val3
      if ( n.ge.4) istk(l+4)=val4
      comp(1)=l+1+n
      return
      end

