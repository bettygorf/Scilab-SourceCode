      subroutine lstelm
c ================================== ( Inria    ) =============
c
c     evaluate utility list's functions
c
c =============================================================
c     

c
      include '../stack.h'
      integer adr
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' lstelm '//buf(1:4))
      endif
c
c     functions/fin
c
c
      rhs=max(0,rhs)
      if(top-rhs+lhs+1.ge.bot) then
         call error(18)
         return
      endif
c
      n=rhs
      err=lstk(top+1)+adr(n+3,1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      ld=lstk(top+1-rhs)
      lf=lstk(top+1)
      il=adr(ld,0)
      l=adr(il+n+3,1)
      call dcopy(lf-ld,stk(ld),-1,stk(l),-1)
      top=top+1-rhs
      istk(il)=15
      istk(il+1)=n
      istk(il+2)=1
      do 10 i=1,n
      istk(il+2+i)=istk(il+1+i)+lstk(top+i)-lstk(top-1+i)
   10 continue
      lstk(top+1)=l+lf-ld
      goto 99
   99 return
      end
