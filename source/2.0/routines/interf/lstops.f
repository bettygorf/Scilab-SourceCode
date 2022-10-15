      subroutine lstops
c ================================== ( Inria    ) =============
c     operations elementaires sur les listes
c =============================================================
c
      include '../stack.h'
c
c
      integer plus,minus,star,dstar,slash,bslash,dot,colon,concat
      integer quote
      integer rhs1,vol1,vol2,typ2,op,iadr,sadr
c
c
      data plus/45/,minus/46/,star/47/,dstar/58/,slash/48/
      data bslash/49/,dot/51/,colon/44/,concat/1/,quote/53/
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
   10 if(rhs.eq.1) goto 11
      fin=-fin
      rhs=rhs1
      return
c
   11 rhs=rhs1-1
      top=top-1
      ilcol=iadr(lstk(top))
      if(istk(ilcol).ne.1.or.istk(ilcol+3).ne.0) then
         call error(21)
         return
      endif
      if(istk(ilcol+1).gt.1.and.istk(ilcol+2).gt.1) then
         call error(21)
         return
      endif
      ncol=isign(istk(ilcol+1)*istk(ilcol+2),istk(ilcol+1))
c
      if(ncol.lt.0) goto 20
      if(ncol.ne.lhs) then
         call error(41)
         return
      endif
c
      lcol=sadr(ilcol+4)
      if(top+ncol+1.ge.bot) then
         call error(18)
         return
      endif
      m=0
      k=top
      do  12 i=1,ncol
      n=int(stk(lcol-1+i))
      if(n.gt.m1.or.n.le.m) then
         call error(21)
         return
      endif
      lstk(top+1)=lstk(top)+istk(il1+2+n)-istk(il1+1+n)
      top=top+1
      m=n
   12 continue
      top=top-1
      ill=iadr(lstk(top+1))
      err=sadr(ill+ncol)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do  13 i=1,ncol
      n=int(stk(lcol-1+i))
      istk(ill-1+i)=istk(il1+1+n)+l1r-1
   13 continue
c
      do  14 i=1,ncol
      call dcopy(lstk(k+1)-lstk(k),stk(istk(ill-1+i)),1,stk(lstk(k)),1)
      k=k+1
   14 continue
      goto 99
c
   20 l=lstk(top)
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
   30 if(rhs.eq.1.and.istk(il1).eq.15) goto 31
      fin=-fin
      rhs=rhs1
      return
c
   31 top=top-1
      vol2=lstk(top+1)-lstk(top)
      l2=lstk(top)
      typ2=istk(iadr(l2))
c
      top=top-1
      ilcol=iadr(lstk(top))
      if(istk(ilcol).ne.1.or.istk(ilcol+3).ne.0) then
         call error(21)
         return
      endif
      if(istk(ilcol+1).gt.1.and.istk(ilcol+2).gt.1) then
         call error(21)
         return
      endif
      ncol=isign(istk(ilcol+1)*istk(ilcol+2),istk(ilcol+1))
      if(ncol.ne.1) then
         call error(21)
         return
      endif
      n=int(stk(sadr(ilcol+4)))
      if(n.lt.0.or.n.gt.m1+1) then
         call error(21)
         return
      endif
c
      vol1=istk(il1+2+m1)-1
      ilr=iadr(lw)
      istk(ilr)=15
      istk(ilr+1)=m1+1
      istk(ilr+2)=1
c
      if(n.ne.0) goto 33
      if(typ2.eq.0) then
          call dcopy(lstk(top+3)-lstk(top+2),stk(lstk(top+2)),1,
     &               stk(lstk(top)),1)
          lstk(top+1)=lstk(top)+lstk(top+3)-lstk(top+2)
          goto 99
      endif
c
      ilr=iadr(lw)
      istk(ilr)=15
      istk(ilr+3)=1+vol2
      do 32 i=1,m1
      istk(ilr+3+i)=istk(ilr+2+i)+istk(il1+2+i)-istk(il1+1+i)
   32 continue
      lr=sadr(ilr+4+m1)
      call dcopy(vol2,stk(l2),1,stk(lr),1)
      lr=lr+vol2
      call dcopy(vol1,stk(l1r),1,stk(lr),1)
      lr=lr+vol1
      goto 38
c
   33 if(n.ne.m1+1) goto 35
      if(typ2.eq.0) then
          call dcopy(lstk(top+3)-lstk(top+2),stk(lstk(top+2)),1,
     &               stk(lstk(top)),1)
          lstk(top+1)=lstk(top)+lstk(top+3)-lstk(top+2)
          goto 99
      endif
c
      call icopy(m1+1,istk(il1+2),1,istk(ilr+2),1)
      istk(ilr+3+m1)=istk(ilr+2+m1)+vol2
      lr=sadr(ilr+4+m1)
      call dcopy(vol1,stk(l1r),1,stk(lr),1)
      lr=lr+vol1
      call dcopy(vol2,stk(l2),1,stk(lr),1)
      lr=lr+vol2
      goto 38
c
   35 if(typ2.eq.0) goto 40
      istk(ilr+1)=m1
      call icopy(n,istk(il1+2),1,istk(ilr+2),1)
      istk(ilr+2+n)=istk(ilr+1+n)+vol2
      do 36 i=n+1,m1+1
      istk(ilr+i+2)=istk(ilr+i+1)+istk(il1+i+2)-istk(il1+i+1)
   36 continue
      lr=sadr(ilr+3+m1)
      call dcopy(istk(il1+1+n)-1,stk(l1r),1,stk(lr),1)
      lr=lr+istk(il1+1+n)-1
      call dcopy(vol2,stk(l2),1,stk(lr),1)
      lr=lr+vol2
      l1r=l1r+istk(il1+2+n)-1
      call dcopy(istk(il1+2+m1)-istk(il1+2+n),stk(l1r),1,stk(lr),1)
      lr=lr+istk(il1+2+m1)-istk(il1+2+n)
   38 call dcopy(lr-lw,stk(lw),1,stk(lstk(top)),1)
      lstk(top+1)=lstk(top)+lr-lw
      goto 99
c
   40 continue
      il=iadr(lstk(top))
      l2r=l1r-1+istk(il1+2+n)
      call icopy(2+n,istk(il1),1,istk(il),1)
      istk(il+1)=istk(il+1)-1
      do 41 i=n,m1
      istk(il+i+2)=istk(il+i+1)+istk(il1+i+3)-istk(il1+i+2)
 41   continue
      l=sadr(il+2+m1)
      call dcopy(istk(il+n+1)-1,stk(l1r),1,stk(l),1)
      l=l+istk(il+n+1)-1
      call dcopy(istk(il+1+m1)-istk(il+1+n),stk(l2r),1,stk(l),1)
      lstk(top+1)=l+istk(il+1+m1)-istk(il+1+n)
      goto 99
c

   99 return
      end
