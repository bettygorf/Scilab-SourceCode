      subroutine polops
c ====================================================================
c
c     operations  sur les matrices de polynomes
c
c ====================================================================
c
      include '../stack.h'
c

      integer plus,minus,star,dstar,slash,bslash,dot,colon,concat
      integer quote,equal,less,great,insert,extrac
c
      double precision sr,si,e1,st
      integer vol,var1(4),var2(4),volr,rhs1,top0,op,iadr,sadr,topin
c
      data plus/45/,minus/46/,star/47/,dstar/62/,slash/48/
      data bslash/49/,dot/51/,colon/44/,concat/1/,quote/53/
      data equal/50/,less/59/,great/60/,insert/2/,extrac/3/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      op=fin
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' polops '//buf(1:4))
      endif
c
      fun=0
      if(op.eq.dstar) goto 70
c
      topin=top
      top0=top+1-rhs
      lw=lstk(top+1)
      rhs1=rhs
      if(op.eq.insert) rhs=2
      if(op.eq.extrac) rhs=1
c
      var2(1)=0
      if(rhs.eq.1) goto 05
      il2=iadr(lstk(top))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      if(istk(il2).gt.2) goto 03
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      mn2=m2*n2
      if(istk(il2).eq.1) goto 01
      id2=il2+8
      call icopy(4,istk(il2+4),1,var2,1)
      l2r=sadr(id2+mn2+1)
      vol=istk(id2+mn2)-1
      l2i=l2r+vol
      l3r=lw
      goto 03
   01 l2r=sadr(il2+4)
      l2i=l2r+mn2
      id2=iadr(lw)
      l3r=sadr(id2+mn2+1)
      err=l3r-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(id2)=1
      do 02 i=1,mn2
   02 istk(id2+i)=i+1
      l3r=l3r+1
   03 continue
c
      top = top-1
   05 il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      if(istk(il1).gt.2) goto 08
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      mn1 = m1*n1
      if(istk(il1).eq.1) goto 08
      id1=il1+8
      call icopy(4,istk(il1+4),1,var1,1)
c
      if(var2(1).eq.0) call icopy(4,var1,1,var2,1)
      if(op.ne.equal.and.op.ne.less+great) then
         do 07 i=1,4
            if(var1(i).ne.var2(i)) then
               fin=-fin
               top=top+1
               return
            endif
 07      continue
      endif
c
      l1r=sadr(id1+mn1+1)
      vol=istk(id1+mn1)-1
      l1i=l1r+vol
      goto 10
   08 l1r=sadr(il1+4)
      l1i=l1r+mn1
      call icopy(4,var2,1,var1,1)
      id1=iadr(l3r)
      l3r=sadr(id1+mn1+1)
      err=l3r-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(id1)=1
      do 09 i=1,mn1
   09 istk(id1+i)=i+1
      l3r=l3r+1
c
   10 it3=max(it1,it2)
c
      goto (60,120,130,65) op
      if (rhs .eq. 1) goto 101
      if (op .eq. plus .or. op .eq. minus) go to 20
      if (op .eq. star.or. op.eq.star+dot) go to 40
      if(op.eq.slash.or.op.eq.slash+dot) goto 150
      if(op.eq.bslash.or.op.eq.bslash+dot) goto 160
      if(op.eq.equal.or.op.eq.less+great) goto 180
c
c     operations non implantees
      top=top0-1+rhs
      fin=-fin
      return
c
c addition et soustraction
c
   20 continue
      if(op.eq.plus) goto 21
      if(err.gt.0) return
      vol=istk(id2+mn2)-1
      call dscal(vol*(it2+1),-1.0d+0,stk(l2r),1)
c
   21 continue
      if (mn1.eq.0) then
         vol=(istk(il2+8+mn2)-1)*(it2+1)
         call icopy(9+mn2,istk(il2),1,istk(il1),1)
         l1=sadr(il1+9+mn2)
         call dcopy(vol,stk(l2r),1,stk(l1),1)
         lstk(top+1)=l1+vol
         goto 999
      elseif(mn2.eq.0) then
         goto 999
      endif
      if(m1.gt.0) goto 25
c a1 est de dimensions indefinies
      istk(il1+1)=m2
      istk(il1+2)=n2
      m1=abs(m2)
      n1=abs(n2)
      mn1=m1*n1
      l=l1r
      id=id1
      n=istk(id+1)-istk(id)
      id1=iadr(l3r)
      l1r=sadr(id1+mn2+1)
      vol=m1*(n-1)+mn2
      l1i=l1r+vol
      l3r=l1i+vol*it1
      err=l3r-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dset(vol*(it1+1),0.0d+0,stk(l1r),1)
      l1=l1r
      do 22 i=1,min(n1,m1)
      call dcopy(n,stk(l),1,stk(l1),1)
      if(it1.eq.1) call dcopy(n,stk(l+n),1,stk(l1+vol),1)
      l1=l1+n+m1
   22 continue
      l1=id1
      istk(l1)=1
      do 23 j=1,n1
      do 23 i=1,m1
      l1=l1+1
      istk(l1)=istk(l1-1)+1
      if(i.eq.j) istk(l1)=istk(l1)+n-1
   23 continue
      goto 31
   25 if(m2.gt.0) goto 30
c a2 est de dimensions indefinies
      m2=abs(m1)
      n2=abs(n1)
      l=l2r
      id=id2
      n=istk(id+1)-istk(id)
      id2=iadr(l3r)
      l2r=sadr(id2+mn1+1)
      vol=m2*(n-1)+mn1
      l2i=l2r+vol
      l3r=l2i+vol*it2
      err=l3r-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dset(vol*(it2+1),0.0d+0,stk(l2r),1)
      l2=l2r
      do 26 i=1,min(n2,m2)
      call dcopy(n,stk(l),1,stk(l2),1)
      if(it2.eq.1) call dcopy(n,stk(l+n),1,stk(l2+vol),1)
      l2=l2+n+m2
   26 continue
      l2=id2
      istk(l2)=1
      do 27 j=1,n2
      do 27 i=1,m2
      l2=l2+1
      istk(l2)=istk(l2-1)+1
      if(i.eq.j) istk(l2)=istk(l2)+n-1
   27 continue
      goto 31
   30 if(m1.ne.m2.or.n1.ne.n2) then
         if(m1.eq.1.and.n1.eq.1) then
         fin=-fin
         top=topin
         return
c         buf='scalar + polynomial matrix --> use ones'
c         call error(9999)
         endif
         if(m2.eq.1.and.n2.eq.1) then
         fin=-fin
         top=topin
         return
c         buf='polynomial matrix + scalar --> use ones'
c         call error(9999)
         endif
         call error(8)
         return
      endif
c
   31 id3=iadr(l3r)
      l3r=sadr(id3+mn1+1)
      vol=0
      do 311 k=1,mn1
      vol=vol+max(istk(id1+k)-istk(id1+k-1),istk(id2+k)-istk(id2+k-1))
  311 continue
      l3i=l3r+vol
      err=l3i+vol*it3-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      goto (32,33,34) it1+2*it2
      call dmpad(stk(l1r),istk(id1),m1,stk(l2r),istk(id2),m2,stk(l3r),
     & istk(id3),m1,n1)
      call dmpadj(stk(l3r),istk(id3),m1,n1)
       goto 35
   32 call wdmpad(stk(l1r),stk(l1i),istk(id1),m1,stk(l2r),istk(id2),
     & m2,stk(l3r),stk(l3i),istk(id3),m1,n1)
      call wmpadj(stk(l3r),stk(l3i),istk(id3),m1,n1)
      goto 35
   33 call wdmpad(stk(l2r),stk(l2i),istk(id2),m2,stk(l1r),istk(id1),
     & m1,stk(l3r),stk(l3i),istk(id3),m1,n1)
      call wmpadj(stk(l3r),stk(l3i),istk(id3),m1,n1)
       goto 35
   34 call wmpad(stk(l1r),stk(l1i),istk(id1),m1,stk(l2r),stk(l2i),
     & istk(id2),m2,stk(l3r),stk(l3i),istk(id3),m1,n1)
      call wmpadj(stk(l3r),stk(l3i),istk(id3),m1,n1)
   35 continue
      istk(il1)=2
      istk(il1+1)=m1
      istk(il1+2)=n1
      istk(il1+3)=it3
      call icopy(4,var1,1,istk(il1+4),1)
      vol=istk(id3+m1*n1)-1
      call icopy(mn1+1,istk(id3),1,istk(il1+8),1)
      l1r=sadr(il1+9+mn1)
      call dcopy(vol*(it3+1),stk(l3r),1,stk(l1r),1)
      lstk(top+1)=l1r+vol*(it3+1)
      goto 999
c
c multiplications
c
 40   if(mn1.eq.0.or.mn2.eq.0) then
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         istk(il1+3)=0
         lstk(top+1)=sadr(il1+4)+1
         goto 999
      endif
      indef=0
      if(mn1*mn2.eq.1.and.(m1.lt.0.or.m2.lt.0)) indef=1
      m1=abs(m1)
      n1=abs(n1)
      m2=abs(m2)
      n2=abs(n2)
      if(mn1*mn2.ne.1 .and. op.lt.dot) goto 41
      if(m1.ne.m2.or.n1.ne.n2) then
         call error(10)
         return
      endif
      m3=m1
      n3=n1
      n1=0
      vol=istk(id1+mn1)+istk(id2+mn2)-mn2-2
      goto 50
   41 if(mn1.ne.1) goto 42
      m1=0
      n1=m2
      m3=m2
      n3=n2
      vol=istk(id2+mn2)-1+mn2*(istk(id1+1)-2)
      goto 50
   42 if(mn2.ne.1) goto 43
      n2=0
      m3=m1
      n3=n1
      vol=istk(id1+mn1)-1+mn1*(istk(id2+1)-2)
      goto 50
 43   if(n1.ne.m2) then
         call error(10)
         return
      endif
      m3=m1
      n3=n2
      vol=0
      do 46 i=1,m3
         j1=id2-m2
         do 45 j=1,n3
            j1=j1+m2
            k1=id1-m1
            mx=0
            do 44 k=1,n1
               k1=k1+m1
               ll1=istk(i+k1)-istk(i-1+k1)
               ll2=istk(k+j1)-istk(k-1+j1)
               mx=max(mx,ll1+ll2)
 44         continue
            vol=vol+mx-1
 45      continue
 46   continue
c
   50 continue
      id3=iadr(l3r)
      l3r=sadr(id3+m3*n3+1)
      l3i=l3r+vol
      err=l3i+it3*vol-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
      m=max(1,m1)
      goto (51,52,53) it1+2*it2
      call dmpmu(stk(l1r),istk(id1),m,stk(l2r),istk(id2),m2,
     & stk(l3r),istk(id3),m1,n1,n2)
      call dmpadj(stk(l3r),istk(id3),m3,n3)
      goto 55
   51 call wdmpmu(stk(l1r),stk(l1i),istk(id1),m,stk(l2r),istk(id2),
     & m2,stk(l3r),stk(l3i),istk(id3),m1,n1,n2)
      call wmpadj(stk(l3r),stk(l3i),istk(id3),m3,n3)
      goto 55
   52 call dwmpmu(stk(l1r),istk(id1),m,stk(l2r),stk(l2i),istk(id2),
     & m2,stk(l3r),stk(l3i),istk(id3),m1,n1,n2)
      call wmpadj(stk(l3r),stk(l3i),istk(id3),m3,n3)
      goto 55
   53 call wmpmu(stk(l1r),stk(l1i),istk(id1),m,stk(l2r),stk(l2i),
     & istk(id2),m2,stk(l3r),stk(l3i),istk(id3),m1,n1,n2)
      call wmpadj(stk(l3r),stk(l3i),istk(id3),m3,n3)
      goto 55
c
   55 if(istk(il1).eq.1) id1=il1+8
      l1r=sadr(id1+m3*n3+1)
      call icopy(m3*n3+1,istk(id3),1,istk(id1),1)
      vol=istk(id1+m3*n3)-1
      call dcopy(vol,stk(l3r),1,stk(l1r),1)
      call dcopy(vol,stk(l3i),1,stk(l1r+vol),1)
      lstk(top+1)=l1r+vol*(it3+1)
      istk(il1)=2
      istk(il1+1)=m3
      istk(il1+2)=n3
      istk(il1+3)=it3
      call icopy(4,var1,1,istk(il1+4),1)
      if(indef.eq.0) goto 999
      istk(il1+1)=-1
      istk(il1+2)=-1
      goto 999
c
c concatenation [a b]
c
   60 continue
      if(m1.lt.0.or.m2.lt.0) then
            call error(14)
            return
      endif
      if(m2.eq.0) then
         return
      elseif(m1.eq.0)then
         call dcopy(lstk(top+2)-lstk(top+1),stk(lstk(top+1)),1,
     &        stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lstk(top+2)-lstk(top+1)
         return
      elseif(m1.ne.m2) then
         call error(5)
         return
      endif
c
      id3=iadr(l3r)
      l3r=sadr(id3+mn1+mn2+1)
      vol=istk(id1+mn1)+istk(id2+mn2)-2
      l3i=l3r+vol
      lw=l3i+vol*it3
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      goto (61,62,63) it1+2*it2
      call dmpcnc(stk(l1r),istk(id1),m1,stk(l2r),istk(id2),m1,
     & stk(l3r),istk(id3),m1,n1,n2,1)
      goto 64
 61   call wmpcnc(stk(l1r),stk(l1i),istk(id1),m1,stk(l2r),st,
     & istk(id2),m1,stk(l3r),stk(l3i),istk(id3),m1,n1,n2,3)
      goto 64
 62   call wmpcnc(stk(l1r),st,istk(id1),m1,stk(l2r),stk(l2i),
     & istk(id2),m1,stk(l3r),stk(l3i),istk(id3),m1,n1,n2,2)
      goto 64
 63   call wmpcnc(stk(l1r),stk(l1i),istk(id1),m1,stk(l2r),stk(l2i),
     & istk(id2),m1,stk(l3r),stk(l3i),istk(id3),m1,n1,n2,1)
      goto 64
c
 64   istk(il1)=2
      istk(il1+1)=m1
      istk(il1+2)=n1+n2
      istk(il1+3)=it3
      call icopy(mn1+mn2+1,istk(id3),1,istk(il1+8),1)
      l1r=sadr(il1+9+mn1+mn2)
      call dcopy(vol*(it3+1),stk(l3r),1,stk(l1r),1)
      call icopy(4,var1,1,istk(il1+4),1)
      lstk(top+1)=l1r+vol*(it3+1)
      goto 999
c
c     concatenation [a;b]
 65   if(n1.lt.0.or.n2.lt.0) then
            call error(14)
            return
      endif
      if(n2.eq.0) then
         goto 999
      elseif(n1.eq.0)then
         call dcopy(lstk(top+2)-lstk(top+1),stk(lstk(top+1)),1,
     &        stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lstk(top+2)-lstk(top+1)
         goto 999
      elseif(n1.ne.n2) then
         call error(6)
         return
      endif
      m=m1+m2
      mn=m*n1
c
      id3=iadr(l3r)
      l3r=sadr(id3+mn+1)
      vol=istk(id1+mn1)+istk(id2+mn2)-2
      l3i=l3r+vol
      lw=l3i+vol*it3
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      goto (66,67,68) it1+2*it2
      call dmpcnc(stk(l1r),istk(id1),m1,stk(l2r),istk(id2),m2,
     & stk(l3r),istk(id3),m1,m2,n2,-1)
      goto 69
 66   call wmpcnc(stk(l1r),stk(l1i),istk(id1),m1,stk(l2r),st,
     & istk(id2),m2,stk(l3r),stk(l3i),istk(id3),m1,m2,n2,-3)
      goto 69
 67   call wmpcnc(stk(l1r),st,istk(id1),m1,stk(l2r),stk(l2i),
     & istk(id2),m2,stk(l3r),stk(l3i),istk(id3),m1,m2,n2,-2)
      goto 69
 68   call wmpcnc(stk(l1r),stk(l1i),istk(id1),m1,stk(l2r),stk(l2i),
     & istk(id2),m2,stk(l3r),stk(l3i),istk(id3),m1,m2,n2,-1)
      goto 69
c
 69   istk(il1)=2
      istk(il1+1)=m
      istk(il1+2)=n1
      istk(il1+3)=it3
      call icopy(mn1+mn2+1,istk(id3),1,istk(il1+8),1)
      l1r=sadr(il1+9+mn1+mn2)
      call dcopy(vol*(it3+1),stk(l3r),1,stk(l1r),1)
      call icopy(4,var1,1,istk(il1+4),1)
      lstk(top+1)=l1r+vol*(it3+1)
      goto 999
c
c puissance
c
   70 il2=iadr(lstk(top))
      mn2=istk(il2+1)*istk(il2+2)
      l2r=sadr(il2+4)
      top=top-1
      nexp=int(stk(l2r))
      if(real(nexp).ne.stk(l2r).or.istk(il2).ne.1.or.mn2.ne.1.or.
     & istk(il2+3).ne.0) call error(30)
      if(nexp.lt.0) goto 80
      if(err.gt.0) return
      il1=iadr(lstk(top))
      m1=abs(istk(il1+1))
      n1=abs(istk(il1+2))
      it1=istk(il1+3)
      mn1=m1*n1
      id1=il1+8
      l1r=sadr(id1+mn1+1)
      vol=istk(id1+mn1)-1
      l1i=l1r+vol
      if(mn1.gt.1 .and. m1.eq.n1) goto 80
c
c puissance elt par elt
      if(nexp.eq.0) goto 75
      n2=(vol-mn1)*nexp + mn1
      id2=id1
      l2r=l1r
      l2i=l1i
      id1=iadr(l2r+n2*(it1+1))
      l1r=sadr(id1+mn1+1)
      err=l1r+vol*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      lstk(top+1)=l2r+n2*(it1+1)
      call dcopy(vol*(it1+1),stk(l2r),1,stk(l1r),1)
      call icopy(mn1+1,istk(id2),1,istk(id1),1)
      istk(id2+mn1)=n2+1
      do 73 k=1,mn1
      l1=l1r+istk(id1+mn1-k)-1
      l2=l2r+(istk(id1+mn1-k)-(mn1+1-k))*nexp+mn1-k
      kk=id1+mn1-k
      n=istk(kk+1)-istk(kk)
      call dcopy(n,stk(l1),-1,stk(l2),-1)
      if(it1.eq.1) call dcopy(n,stk(l1+vol),-1,stk(l2+n2),-1)
      m2=n-1
      do 72 ne=2,nexp
      if(it1.eq.0) call dpmul1(stk(l2),m2,stk(l1),n-1,stk(l2))
      if(it1.eq.1) call wpmul1(stk(l2),stk(l2+n2),m2,stk(l1),
     &                    stk(l1+vol),n-1,stk(l2),stk(l2+n2))
      m2=m2+n-1
   72 continue
      istk(id2+mn1-k)=istk(id2+mn1-k+1)-(m2+1)
   73 continue
      goto 999
   75 continue
      l1=sadr(id1+mn1+1)
      do 76 i=1,mn1
      istk(id1+i)=i+1
      stk(l1-1+i)=1.0d+0
   76 continue
      istk(il1+3)=0
      lstk(top+mn1)=l1+mn1
      goto 999
c puissance de matrice
   80 continue
      fin=-fin
      top=top+1
      return
c
  101 vol=istk(id1+mn1)-1
      if (op .eq. quote) goto 110
c multiplication par -1
      call dscal(vol*(it1+1),-1.0d+0,stk(l1r),1)
      goto 999
c
c transposition
  110 continue
      id2=iadr(lstk(top+1))
      l2r=sadr(id2+mn1+1)
      l2i=l2r+vol
      err=l2r+vol*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(it1.eq.1) goto 111
      call dmptra(stk(l1r),istk(id1),m1,stk(l2r),istk(id2),m1,n1)
      goto 112
  111 call wmptra(stk(l1r),stk(l1i),istk(id1),m1,stk(l2r),stk(l2i),
     & istk(id2),m1,n1)
  112 istk(il1+1)=n1
      istk(il1+2)=m1
      call icopy(mn1+1,istk(id2),1,istk(id1),1)
      call dcopy(vol*(it1+1),stk(l2r),1,stk(l1r),1)
      goto 999
c
c
c     insertion
c
c insert
c     a(vl,vc)=m  a(v)=u
c
c     a(vl,vc)=m  a(v)=u
  120 continue
      ili=iadr(lstk(top0-2+rhs1))
      if (istk(ili+1)*istk(ili+2).eq.0) then
         rhs=rhs1
         top=top0-1+rhs1
         fin=-fin
         return
      endif
      rhs=rhs1-2
      nrow=-1
c
      top=top-1
      if(m1.le.0) then
         call error(14)
         return
      endif
      ilcol=iadr(lstk(top))
      if(istk(ilcol).eq.4) then
         rhs=rhs1
         top=top0-1+rhs1
         fin=-fin
         return
      endif
      if(istk(ilcol).ne.1) then
         call error(21)
         return
      endif
      if(istk(ilcol+3).ne.0) then
         call error(21)
         return
      endif
      if(istk(ilcol+1).gt.1.and.istk(ilcol+2).gt.1) then
         call error(21)
         return
      endif
      ncol=isign(istk(ilcol+1)*istk(ilcol+2),istk(ilcol+1))
      lcol=sadr(ilcol+4)
      if(ncol.lt.0) goto 122
      do 121 i=1,ncol
      istk(ilcol-1+i)=int(stk(lcol-1+i))
  121 continue
  122 continue
      ilrow=ilcol
      if(rhs.eq.1.and.n2.eq.1) then
        nrow=ncol
        ilrow=ilcol
        ncol=-1
      endif
c
      if(rhs.eq.1) goto 125
      top=top-1
      ilrow=iadr(lstk(top))
      if(istk(ilrow).eq.4) then
         rhs=rhs1
         top=top0-1+rhs1
         fin=-fin
         return
      endif
      if(istk(ilrow).ne.1) then
         call error(21)
         return
      endif
      if(istk(ilrow+3).ne.0) then
         call error(21)
         return
      endif
      if(istk(ilrow+1).gt.1.and.istk(ilrow+2).gt.1) then
         call error(21)
         return
      endif
      nrow=isign(istk(ilrow+1)*istk(ilrow+2),istk(ilrow+1))
      lrow=sadr(ilrow+4)
      if(nrow.lt.0) goto 124
      do 123 i=1,nrow
      istk(ilrow-1+i)=int(stk(lrow-1+i))
  123 continue
  124 continue
c
  125 call dimin(m2,n2,istk(ilrow),nrow,istk(ilcol),ncol,m1,n1,
     &           mr,nr,err)
      if(err.gt.0) then
         call error(21)
         return
      endif
      idr=iadr(l3r)
      lr=sadr(idr+mr*nr+1)
      err=lr-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mpinsp(istk(id2),m2,n2,istk(ilrow),nrow,istk(ilcol),ncol,
     &            istk(id1),m1,n1,istk(idr),mr,nr,err)
      if(err.gt.0) then
         call error(15)
         return
      endif
      volr=istk(idr)
c
      if(it1.eq.0) then
         if(it2.eq.0) then
            err=lr+volr-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call dmpins(stk(l2r),istk(id2),m2,n2,
     $           stk(l1r),istk(id1),m1,n1,stk(lr),istk(idr),mr,nr)
         else
            l1i=lr+volr*(it3+1)
            err=l1i+istk(id1+mn1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call dset(istk(id1+mn1),0.0d+0,stk(l1i),1)
            call wmpins(stk(l2r),stk(l2i),istk(id2),m2,n2,stk(l1r),
     $           stk(l1i),istk(id1),m1,n1,stk(lr),stk(lr+volr),
     $           istk(idr),mr,nr)
         endif
      else
         if(it2.eq.0) then
            l2i=lr+volr*(it3+1)
            err=l2i+istk(id2+mn2)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call dset(istk(id2+mn2),0.0d+0,stk(l2i),1)
            call wmpins(stk(l2r),stk(l2i),istk(id2),m2,n2,stk(l1r),
     $           stk(l1i),istk(id1),m1,n1,stk(lr),stk(lr+volr),
     $           istk(idr),mr,nr)
         else
            err=lr+volr*(it3+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call wmpins(stk(l2r),stk(l2i),istk(id2),m2,n2,stk(l1r),
     $           stk(l1i),istk(id1),m1,n1,stk(lr),stk(lr+volr),
     $           istk(idr),mr,nr)
         endif
      endif
c
  129 il1=iadr(lstk(top))
      istk(il1)=2
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=it3
      call icopy(4,var1,1,istk(il1+4),1)
      call icopy(mr*nr+1,istk(idr),1,istk(il1+8),1)
      l1=sadr(il1+mr*nr+9)
      call dcopy(volr*(it3+1),stk(lr),1,stk(l1),1)
      lstk(top+1)=l1+volr*(it3+1)
      goto 999
c
c extraction
  130 rhs=rhs1-1
      if(rhs.eq.2) il2=iadr(lstk(top-1))
      if(istk(il1).eq.4.or.(rhs.eq.2.and.istk(il2).eq.4)) then
         rhs=rhs1
         top=topin
         fin=-fin
         top=top0
         go to 999
      endif

      mr=-1
      nrow=-1
c
      if(m1.le.0) then
         call error(14)
         return
      endif
c
      top=top-1
      ilcol=iadr(lstk(top))
      if(istk(ilcol).ne.1) then
         call error(21)
         return
      endif
      if(istk(ilcol+3).ne.0) then
         call error(21)
         return
      endif
      if(istk(ilcol+1).gt.1.and.istk(ilcol+2).gt.1) then
         call error(21)
         return
      endif
      ncol=isign(istk(ilcol+1)*istk(ilcol+2),istk(ilcol+1))
      nr=ncol
      if(nr.eq.0) goto 146
      lcol=sadr(ilcol+4)
      if(ncol.lt.0) goto 132
      do 131 i=1,ncol
      istk(ilcol-1+i)=int(stk(lcol-1+i))
  131 continue
  132 continue
c
      if(rhs.ne.1) goto 140
c
c vect(arg)
      if(nr.lt.0) nr=mn1
      mr=1
      if(n1.ne.1) goto 133
      mr=nr
      nr=1
      nrow=ncol
      ilrow=ilcol
      ncol=-1
      goto 145
  133 if(m1.eq.1) goto 135
      n1=mn1
      m1=1
  135 continue
      nrow=-1
      ilrow=ilcol
      goto 145
c
  140 top=top-1
      ilrow=iadr(lstk(top))
      if(istk(ilrow).ne.1) then
         call error(21)
         return
      endif
      if(istk(ilrow+3).ne.0) then
         call error(21)
         return
      endif
      if(istk(ilrow+1).gt.1.and.istk(ilrow+2).gt.1) then
         call error(21)
         return
      endif
      nrow=isign(istk(ilrow+1)*istk(ilrow+2),istk(ilrow+1))
      mr=nrow
      lrow=sadr(ilrow+4)
      if(nrow.eq.0) goto 146
      if(nrow.lt.0) goto 142
      do 141 i=1,nrow
      istk(ilrow-1+i)=int(stk(lrow-1+i))
  141 continue
  142 continue
c
c     matrix(arg,arg)
      if(mr.lt.0) mr=m1
      if(nr.lt.0) nr=n1
c
  145 mnr=mr*nr
      idr=iadr(lw)
      lr=sadr(idr+mnr+1)
      err=lr-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
      call dmpext(stk(l1r),istk(id1),m1,n1,istk(ilrow),nrow,
     &    istk(ilcol),ncol,stk(lr),istk(idr),0,err)
      if(err.gt.0) then
         call error(21)
         return
      endif
      volr=istk(idr+mnr)-1
      err=lr+volr*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dmpext(stk(l1r),istk(id1),m1,n1,istk(ilrow),nrow,
     &            istk(ilcol),ncol,stk(lr),istk(idr),1,err)
      if(it1.eq.1) call dmpext(stk(l1i),istk(id1),m1,n1,
     &             istk(ilrow),nrow,istk(ilcol),ncol,stk(lr+volr),
     &             istk(idr),1,err)
c
      il1=iadr(lstk(top))
      istk(il1)=2
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=it1
      call icopy(4,var1,1,istk(il1+4),1)
      call icopy(mnr+1,istk(idr),1,istk(il1+8),1)
      l1=sadr(il1+9+mnr)
      call dcopy(volr*(it1+1),stk(lr),1,stk(l1),1)
      lstk(top+1)=l1+volr*(it1+1)
      go to 999
c
 146  continue
c un des vecteurs d'indice est vide
      top=top0
      il1=iadr(lstk(top))
      istk(il1)=1
      istk(il1+1)=0
      istk(il1+2)=0
      istk(il1+3)=0
      lstk(top+1)=sadr(il1+4)
      goto 999
c divisions
c
c
c     division a droite
  150 continue
      mn=mn2
      l=l2r
      il=il2
      if(op.gt.dot.and.(m1.ne.m2.or.n1.ne.n2)) then
         call error(11)
         return
      endif
      if (mn2 .eq. 1.or.op.eq.dot+slash) go to 151
  151 if(istk(il).ne.1) goto 155
      do 152 i=1,mn
      sr=stk(l-1+i)
      si=0.0d+0
      if(it2.eq.1) si=stk(l+mn-1+i)
      e1=max(abs(sr),abs(si))
      if(e1.eq.0.d0) then
         call error(27)
         return
      endif
      sr=sr/e1
      si=si/e1
      e1=e1*(sr*sr+si*si)
      stk(l-1+i)=sr/e1
      if(it2.eq.1) stk(l+mn-1+i)=-si/e1
  152 continue
c on apelle la multiplication avec l'inverse du scalaire
      goto 40
c
  155 continue
      fin=-op
      top=top+1
      goto 999
c
c     division a gauche
  160 continue
      l=l1r
      mn=mn1
      il=il1
      if(op.gt.dot.and.(m1.ne.m2.or.n1.ne.n2)) then
         call error(12)
         return
      endif
      if (mn1 .eq. 1.or.op.gt.dot) go to 151
      top=top+1
      fin=-op
      go to 999
c
c     comparaisons
 180  continue
      itrue=1
      if(op.eq.less+great) itrue=0
c     comparaison des types
      if(istk(il1).gt.2.or.istk(il2).gt.2) then
         istk(il1)=4
         istk(il1+1)=1
         istk(il1+2)=1
         istk(il1+3)=1-itrue
         lstk(top+1)=sadr(il1+4)
         return
      endif
c     des nom de variable
      do 181 i=1,4
         if(var1(i).ne.var2(i)) then
            istk(il1)=4
            istk(il1+1)=1
            istk(il1+2)=1
            istk(il1+3)=1-itrue
            lstk(top+1)=sadr(il1+4)
            return
         endif
 181  continue
c     des dimensions
      if(mn1.eq.1.and.mn2.gt.1) then
         nn1=istk(id1+1)-1
         err=lw+nn1*(it1+1)+2-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dcopy(nn1*(it1+1),stk(l1r),1,stk(lw),1)
         l1r=lw
         l1i=l1r+nn1
         id1=iadr(l1r+nn1*(it1+1))
         istk(id1)=1
         istk(id1+1)=nn1+1
         inc1=0
         inc2=1
         mn1=mn2
         m1=m2
         n1=n2
         istk(il1+1)=m1
         istk(il1+2)=n1
      else if(mn2.eq.1.and.mn1.gt.1) then
         nn2=istk(id2+1)-1
         err=lw+nn2*(it2+1)+2-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dcopy(nn2*(it2+1),stk(l2r),1,stk(lw),1)
         l2r=lw
         l2i=l2r+nn2
         id2=iadr(l2r+nn2*(it2+1))
         istk(id2)=1
         istk(id2+1)=nn2+1
         inc1=1
         inc2=0
         mn2=mn1
         m2=m1
         n2=n1
      else if(n1.ne.n2.or.m1.ne.m2) then
         istk(il1)=4
         istk(il1+1)=1
         istk(il1+2)=1
         istk(il1+3)=1-itrue
         lstk(top+1)=sadr(il1+4)
         return
      else
         inc1=1
         inc2=1
      endif
c     des valeurs
      i1=id1-inc1
      i2=id2-inc2
      l1r=l1r-1
      l2r=l2r-1
      l1i=l1i-1
      l2i=l2i-1
      do 185 i=0,mn1-1
         i1=i1+inc1
         i2=i2+inc2
         if(istk(i1+1)-istk(i1).ne.istk(i2+1)-istk(i2) ) goto 184
         nl=istk(i1+1)-istk(i1)-1
         do 182 ii=0,nl
            if(stk(l1r+istk(i1)+ii).ne.stk(l2r+istk(i2)+ii)) goto 184
 182     continue
         istk(il1+3+i)=itrue
         if(max(it1,it2).eq.0) goto 185
         e1=0.0d+0
         e2=0.0d+0
         do 183 ii=0,nl
            if(it1.eq.1) e1=stk(l1i+istk(i1)+ii)
            if(it2.eq.1) e2=stk(l2i+istk(i2)+ii)
            if(e1.ne.e2) goto 184
 183     continue
         istk(il1+3+i)=itrue
         goto 185
 184     istk(il1+3+i)=1-itrue
 185  continue
      istk(il1)=4
      istk(il1+1)=m1
      istk(il1+2)=n1
      lstk(top+1)=sadr(il1+3+mn1)
      goto 999

c
  999 return
      end
