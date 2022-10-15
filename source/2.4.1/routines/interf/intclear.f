      subroutine intclear(fname)
c     
c     Copyright INRIA
      include '../stack.h'
c     
      character*(*) fname
      integer top0,id(nsiz)
      logical getsmat,checkval,checklhs
      integer iadr, sadr
      integer a, blank,percen
      logical ok
      data a/10/,blank/40/,percen/56/
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      if(.not.checklhs(fname,1,1)) return

      if(rhs.le.0) then
c     clear all variable
         bot = bbot
         if (macr.ne.0 .or. paus.ne.0) then
c     .     clear within a macro, an execstr, an exec or a pause
            k = lpt(1) - (13+nsiz)
            if(lin(k+7).ne.0.and.istk(lin(k+6)).eq.10) goto 01
c     .     clear within a macro, an exec or a pause
            bot = lin(k+5)
         endif
 01      top=top+1
         il = iadr(lstk(top))
         istk(il) = 0
         lstk(top+1) = lstk(top) + 1
         return
      endif
     
      top0=top
      do 10 k=1,rhs
         if(.not.getsmat(fname,top0,top,m,n,1,1,lr,nlr)) return
         if(.not.checkval(fname,m*n,1)) return
         if(nlr.eq.0) then
            top=top-1
            goto 10
         endif
c        . check for valid variable name
         do 05 i=0,nlr-1
            ic=abs(istk(lr+i))
            if((ic.gt.blank.and.(i.gt.0.and.ic.eq.percen)).or.
     $           (i.eq.0.and.ic.lt.a)) then
               err=rhs+1-k
               call error(248)
               return
            endif
 05      continue
         call namstr(id,istk(lr),nlr,0)
         il = iadr(lstk(top))
         istk(il) = 0
         lstk(top+1) = lstk(top) + 1
         rhs = 0
         call stackp(id,0)
         if (err .gt. 0) return
         fin = 1
 10   continue
      top=top+1
      il = iadr(lstk(top))
      istk(il) = 0
      lstk(top+1) = lstk(top) + 1
      end
