C/MEMBR ADD NAME=LOGELM,SSI=0
      subroutine logelm
c ================================== ( Inria    ) =============
c evaluation des fonctions elementaires sur les booleens
c =============================================================
c
      include '../stack.h'
c
      integer sadr,iadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c

c     functions/fin
c     1      
c   find
c
c
      lw=lstk(top+1)
c
      goto (10) fin
c
c     find
c
   10 if(rhs.ne.1) then
         call error(39)
         return
      endif
      if(lhs.gt.2) then
         call error(39)
         return
      endif
      il1=iadr(lstk(top))
      if(istk(il1).ne.4) then
         err=1
         call error(55)
         return
      endif
c
      m1=istk(il1+1)
      n1=istk(il1+2)
      mn1=m1*n1
      il=max(il1+3+mn1,iadr(lstk(top)+mn1*lhs)+8)
      err=sadr(il+mn1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call icopy(mn1,istk(il1+3),1,istk(il),1)
      istk(il1)=1
      l1=sadr(il1+4)
      if(mn1.gt.0) then
         l=l1
         do 11 k=0,mn1-1
            if(istk(il+k).ne.1) goto 11
            stk(l)=float(k+1)
            l=l+1
 11      continue
         nt=l-l1
      else
         nt=0
      endif
      istk(il1+1)=min(1,nt)
      istk(il1+2)=nt
      istk(il1+3)=0
      lstk(top+1)=l1+nt
      if(lhs.eq.1) goto 999
      top=top+1
      il2=iadr(lstk(top))
      istk(il2)=1
      istk(il2+1)=min(1,nt)
      istk(il2+2)=nt
      istk(il2+3)=0
      l2=sadr(il2+4)
      lstk(top+1)=l2+nt
      if(nt.eq.0) goto 999
      do 12 k=0,nt-1
         stk(l2+k)=float(int((stk(l1+k)-1.0d0)/m1)+1)
         stk(l1+k)=stk(l1+k)-(stk(l2+k)-1.0d+0)*m1
 12   continue
      goto 999
c
  999 return
      end
