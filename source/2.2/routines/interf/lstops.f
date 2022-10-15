      subroutine lstops
c =============================================================
c     operations elementaires sur les listes
c =============================================================
c
      include '../stack.h'
c
c
      integer rhs1,vol1,vol2,typ2,op,iadr,sadr,top0
      integer strpos
      external strpos
c
c
      data insert/2/,extrac/3/

c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c 
      op=fin
      fun=0
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') op
         call basout(io,wte,' lstops '//buf(1:4))
      endif
c
      lw=lstk(top+1)
      rhs1=rhs
      top0=top
      if(op.eq.insert) rhs=rhs-2
      if(op.eq.extrac) rhs=rhs-1
c
   05 il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      it1=istk(il1+2)
      id1=il1+3
      l1r=sadr(il1+m1+3)
c
      if(op.eq.extrac) goto 10
      if(op.eq.insert) goto 30
c
c     operations non implantee
      fin=-fin
      rhs=rhs1
      return
c
c extraction
   10 ltyp=istk(il1)
      if(rhs.eq.1) goto 11
      fin=-fin
      rhs=rhs1
      return
c
   11 rhs=rhs1-1
      top=top-1
      ilcol=iadr(lstk(top))
      if(istk(ilcol).eq.10) then
         ilt=iadr(sadr(il1+istk(il1+1)+3))
         nt=istk(ilt+1)*istk(ilt+2)
         if(nt.eq.1) then
            top=top0
            fin=-fin
            rhs=rhs1
            return
         endif
c     .  element is designated by its name
         if(istk(ilcol+1).gt.1.and.istk(ilcol+2).gt.1) then
            call error(21)
            return
         endif
         ncol=istk(ilcol+1)*istk(ilcol+2)
         lcol=iadr(lw)
         lw=sadr(lcol+ncol)
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
c     .  look for corresponding index
         l=ilcol+5+ncol
         do 12 i=1,ncol
            nl=istk(ilcol+4+i)-istk(ilcol+3+i)
            n=strpos(istk(ilt+5),nt-1,istk(ilt+5+nt),istk(l),nl)
            l=l+nl
            if(n.le.0) then
               call error(21)
               return
            endif
            n=n+1
            istk(lcol-1+i)=n
 12      continue
      else
c     .  element is designated by its index
         if(istk(ilcol).ne.1.or.istk(ilcol+3).ne.0) then
            call error(21)
            return
         endif
         if(istk(ilcol+1).gt.1.and.istk(ilcol+2).gt.1) then
            call error(21)
            return
         endif
         if(istk(ilcol+1).gt.0) then
            ncol=istk(ilcol+1)*istk(ilcol+2)
            lcol=sadr(ilcol+4)
            call entier(ncol,stk(lcol),istk(iadr(lcol)))
            lcol=iadr(lcol)
         else
            goto 20
         endif
      endif
c
      if(ncol.ne.lhs) then
         call error(41)
         return
      endif
c
      if(top+ncol+1.ge.bot) then
         call error(18)
         return
      endif
      do  17 i=1,ncol
      n=istk(lcol-1+i)
      if(n.gt.m1.or.n.lt.1) then
         call error(21)
         return
      endif
      lstk(top+1)=lstk(top)+istk(il1+2+n)-istk(il1+1+n)
      top=top+1
   17 continue
c
      top=top-1
      ill=max(lcol+ncol,iadr(lstk(top+1)))
      err=sadr(ill+ncol)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c      call isort(istk(lcol),ncol,istk(ill))
      do  18 i=1,ncol
      n=istk(lcol-1+i)
      istk(ill-1+i)=istk(il1+1+n)+l1r-1
   18 continue
c
      do  19 i=1,ncol
         k=top-ncol+i
         call dcopy(lstk(k+1)-lstk(k),stk(istk(ill-1+i)),1,
     $        stk(lstk(k)),1)
   19 continue
      goto 99
c
c     extraction list(:) 
c
   20 l=lstk(top)
      if(m1.ne.lhs) then
         call error(41)
         return
      endif

      if(top+1+m1.ge.bot) then
         call error(18)
         return
      endif
      do  21 i=1,m1
      lstk(top+1)=lstk(top)+istk(il1+2+i)-istk(il1+1+i)
      top=top+1
   21 continue
      top=top-1
      call dcopy(istk(il1+m1+2)-1,stk(l1r),1,stk(l),1)
      goto 99
c
c insert
   30 if(rhs.eq.1.and.(istk(il1).eq.15.or.istk(il1).eq.16)) goto 31
      fin=-fin
      rhs=rhs1
      return
c
   31 top=top-1
      ltyp=istk(il1)
      vol2=lstk(top+1)-lstk(top)
      l2=lstk(top)
      typ2=istk(iadr(l2))
c
      top=top-1
      ilcol=iadr(lstk(top))
      if(istk(ilcol).eq.10) then
         ilt=iadr(sadr(il1+istk(il1+1)+3))
         nt=istk(ilt+1)*istk(ilt+2)
         if(nt.eq.1) then
            top=top0
            fin=-fin
            rhs=rhs1
            return
         endif
c     .  element is designated by its name
         if(istk(ilcol+1)*istk(ilcol+2).ne.1) then
            call error(21)
            return
         endif
c     .  look for corresponding index
         n=strpos(istk(ilt+5),nt-1,istk(ilt+5+nt),istk(ilcol+6),
     $        istk(ilcol+5)-istk(ilcol+4))
         if(n.le.0) then
            call error(21)
            return
         endif
         n=n+1
      else
         if(istk(ilcol).ne.1.or.istk(ilcol+3).ne.0) then
            call error(21)
            return
         endif
         if(istk(ilcol+1)*istk(ilcol+2).ne.1) then
            call error(21)
            return
         endif
         n=int(stk(sadr(ilcol+4)))
         if(n.lt.0.or.n.gt.m1+1) then
            call error(21)
            return
         endif
      endif
c
      vol1=istk(il1+2+m1)-1
      ilr=iadr(lw)
      istk(ilr)=ltyp
      istk(ilr+1)=m1+1
      istk(ilr+2)=1
c
      if(n.eq.0) then
c     add a new element "on the left"
         if(typ2.eq.0) then
c     null element : nothing added
            call dcopy(lstk(top+3)-lstk(top+2),stk(lstk(top+2)),1,
     &           stk(lstk(top)),1)
            lstk(top+1)=lstk(top)+lstk(top+3)-lstk(top+2)
            goto 99
         endif
         ilr=iadr(lw)
         istk(ilr)=15
         istk(ilr+1)=m1+1
         istk(ilr+2)=1
         istk(ilr+3)=1+vol2
         do 32 i=1,m1
            istk(ilr+3+i)=istk(ilr+2+i)+istk(il1+2+i)-istk(il1+1+i)
 32      continue
         lr=sadr(ilr+4+m1)
         call dcopy(vol2,stk(l2),1,stk(lr),1)
         lr=lr+vol2
         call dcopy(vol1,stk(l1r),1,stk(lr),1)
         lr=lr+vol1
         call dcopy(lr-lw,stk(lw),1,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lr-lw
      elseif(n.eq.m1+1) then
c     add a new element "on the right"
         if(typ2.eq.0) then
c     null element : nothing added
            call dcopy(lstk(top+3)-lstk(top+2),stk(lstk(top+2)),1,
     &           stk(lstk(top)),1)
            lstk(top+1)=lstk(top)+lstk(top+3)-lstk(top+2)
            goto 99
         endif
         ilr=iadr(lw)
         istk(ilr)=ltyp
         istk(ilr+1)=m1+1
         call icopy(m1+1,istk(il1+2),1,istk(ilr+2),1)
         istk(ilr+3+m1)=istk(ilr+2+m1)+vol2
         lr=sadr(ilr+4+m1)
         call dcopy(vol1,stk(l1r),1,stk(lr),1)
         lr=lr+vol1
         call dcopy(vol2,stk(l2),1,stk(lr),1)
         lr=lr+vol2
         call dcopy(lr-lw,stk(lw),1,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lr-lw
      elseif(typ2.ne.0) then
c     change the specified element
         if (istk(il1+2+n)-istk(il1+1+n).eq.vol2) then
c     element is directly replaced 
            lr=l1r+istk(il1+1+n)-1
            call dcopy(vol2,stk(l2),1,stk(lr),1)
c     .     list has been modified in place
            il1=iadr(lstk(top))
            istk(il1)=-1
            istk(il1+1)=-1
            istk(il1+2)=istk(iadr(lstk(top0))+2)
            lstk(top+1)=lstk(top)+3
            goto 99
         endif
         ilr=iadr(lw)
         istk(ilr)=ltyp
         istk(ilr+1)=m1+1
         if(ltyp.eq.16.and.n.eq.1.and.typ2.ne.10) istk(ilr)=15
         istk(ilr+1)=m1
         call icopy(n,istk(il1+2),1,istk(ilr+2),1)
         istk(ilr+2+n)=istk(ilr+1+n)+vol2
         do 36 i=n+1,m1+1
            istk(ilr+i+2)=istk(ilr+i+1)+istk(il1+i+2)-istk(il1+i+1)
 36      continue
         lr=sadr(ilr+3+m1)
         call dcopy(istk(il1+1+n)-1,stk(l1r),1,stk(lr),1)
         lr=lr+istk(il1+1+n)-1
         call dcopy(vol2,stk(l2),1,stk(lr),1)
         lr=lr+vol2
         l1r=l1r+istk(il1+2+n)-1
         call dcopy(istk(il1+2+m1)-istk(il1+2+n),stk(l1r),1,stk(lr),1)
         lr=lr+istk(il1+2+m1)-istk(il1+2+n)
 38      call dcopy(lr-lw,stk(lw),1,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lr-lw
      else
c     suppress the specified element
         il=iadr(lstk(top))
         l2r=l1r-1+istk(il1+2+n)
         call icopy(2+n,istk(il1),1,istk(il),1)
         if(ltyp.eq.16.and.n.eq.1) istk(il)=15
         istk(il+1)=istk(il+1)-1
         do 41 i=n,m1
            istk(il+i+2)=istk(il+i+1)+istk(il1+i+3)-istk(il1+i+2)
 41      continue
         l=sadr(il+2+m1)
         call dcopy(istk(il+n+1)-1,stk(l1r),1,stk(l),1)
         l=l+istk(il+n+1)-1
         call dcopy(istk(il+1+m1)-istk(il+1+n),stk(l2r),1,stk(l),1)
         lstk(top+1)=l+istk(il+1+m1)-istk(il+1+n)
      endif
      goto 99
         
c

   99 return
      end
      integer function strpos(ptr,ns,chars,str,n)
      integer ptr(ns+1),ns,chars(*),str(n),n
      do 10 i=1,ns
         i1=ptr(i)
         i2=ptr(i+1)
         if(i2-i1.eq.n) then
            do 05 j=1,n
               if(str(j).ne.chars(i1-1+j)) goto 10
 05         continue
            strpos=i
            return
         endif
 10   continue
      strpos=0
      return
      end
