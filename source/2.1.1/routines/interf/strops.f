      subroutine strops
c ====================================================================
c
c   operations sur les matrices de chaines de caracteres
c
c ====================================================================
c
      include '../stack.h'
c
      integer plus,minus,star,dstar,slash,bslash,dot,colon,concat
      integer quote,equal,less,great,insert,extrac,ou,et,non
      integer top0,iadr,sadr,op,vol,volr,rhs1
      data plus/45/,minus/46/,star/47/,dstar/62/,slash/48/
      data bslash/49/,dot/51/,colon/44/,concat/1/,quote/53/
      data equal/50/,less/59/,great/60/,insert/2/,extrac/3/
      data ou/57/,et/58/,non/61/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c 
      op=fin
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' strops '//buf(1:4))
      endif
c
      fun=0
c
      top0=top
c
      lw=lstk(top+1)
      rhs1=rhs
      if(op.eq.insert) rhs=2
      if(op.eq.extrac) rhs=1
c
      if(rhs.eq.1) goto 05
      il2=iadr(lstk(top))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      mn2=m2*n2
      id2=il2+4
      l2r=id2+mn2+1
      l3r=lw
c
      top = top-1
   05 il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      mn1 = m1*n1
      id1=il1+4
      l1r=id1+mn1+1
      vol=istk(id1+mn1)-1
c
      goto (60,120,130,65) op
      if (rhs .eq. 1.and.op.eq.quote) goto 110
      if (op .eq. plus ) go to 20
      if(op.eq.equal.or.op.eq.less+great) goto 180
c
c     operations non implantees
 10   top=top0
      rhs=rhs1
      fin=-fin
      return


c
c addition
c
   20 if(m1.ne.m2.or.n1.ne.n2) then
         call error(8)
         return
      endif
      if(istk(il1).ne.istk(il2)) goto 10
      err=lw+sadr(istk(id1+mn1)+istk(id2+mn2))-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
      lr=iadr(lw)
      l=lr
      i1=1
      do 11 i=1,mn1
      la=istk(id1+i)-i1
      lb=istk(id2+i)-istk(id2+i-1)
      i1=istk(id1+i)
      istk(id1+i)=istk(id1+i-1)+la+lb
      call icopy(la,istk(l1r),1,istk(l),1)
      l1r=l1r+la
      l=l+la
      call icopy(lb,istk(l2r),1,istk(l),1)
      l2r=l2r+lb
      l=l+lb
11    continue
      call icopy(l-lr,istk(lr),1,istk(il1+5+mn1),1)
      lstk(top+1)=sadr(il1+5+mn1+l-lr)
      goto 999
c
c concatenation [a, b]
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
      if(istk(il1).ne.istk(il2)) goto 10
c
      id3=iadr(lw)
      l3r=id3+mn1+mn2+1
      vol=istk(id1+mn1)+istk(id2+mn2)-2
      err=sadr(l3r+vol)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call impcnc(istk(l1r),istk(id1),m1,istk(l2r),istk(id2),m1,
     & istk(l3r),istk(id3),m1,n1,n2,1)
c
      istk(il1)=10
      istk(il1+1)=m1
      istk(il1+2)=n1+n2
      istk(il1+3)=it1
      call icopy(mn1+mn2+vol+1,istk(id3),1,istk(il1+4),1)
      lstk(top+1)=sadr(il1+5+mn1+mn2+vol)
      goto 999
c
c     concatenation [a;b]
 65   continue
      if(n1.lt.0.or.n2.lt.0) then
            call error(14)
            return
      endif
      if(n2.eq.0) then
         return
      elseif(n1.eq.0)then
         call dcopy(lstk(top+2)-lstk(top+1),stk(lstk(top+1)),1,
     &        stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+lstk(top+2)-lstk(top+1)
         return
      elseif(n1.ne.n2) then
         call error(6)
         return
      endif
      if(istk(il1).ne.istk(il2)) goto 10
c
      id3=iadr(lw)
      l3r=id3+mn1+mn2+1
      vol=istk(id1+mn1)+istk(id2+mn2)-2
      err=sadr(l3r+vol)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call impcnc(istk(l1r),istk(id1),m1,istk(l2r),istk(id2),m2,
     & istk(l3r),istk(id3),m1,m2,n2,-1)
c
      istk(il1)=10
      istk(il1+1)=m1+m2
      istk(il1+2)=n1
      istk(il1+3)=it1
      call icopy(mn1+mn2+vol+1,istk(id3),1,istk(il1+4),1)
      lstk(top+1)=sadr(il1+5+mn1+mn2+vol)
      goto 999
c
c transposition
c
  110 continue
      id2=iadr(lw)
      l2r=id2+mn1+1
      err=sadr(l2r+vol)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call imptra(istk(l1r),istk(id1),m1,istk(l2r),istk(id2),m1,n1)
      istk(il1+1)=n1
      istk(il1+2)=m1
      call icopy(mn1+1+vol,istk(id2),1,istk(id1),1)
      goto 999
c
c insertion
c
c     a(vl,vc)=m  a(v)=u
  120 continue
      ili=iadr(lstk(top0-1))
      if (istk(ili+1)*istk(ili+2).eq.0) then
         top=top0
         rhs=rhs1
         fin=-fin
         return
      endif

      if(istk(il1).ne.istk(il2)) then
          if(istk(il2).ne.1.or.m2*n2.ne.0) goto 10
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
         top=top0
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
         top=top0
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
      lr=idr+mr*nr+1
      err=sadr(lr)-lstk(bot)
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
      err=sadr(lr+volr)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call impins(istk(l2r),istk(id2),m2,n2,
     &            istk(l1r),istk(id1),m1,n1,istk(lr),istk(idr),mr,nr)
c
  129 il1=iadr(lstk(top))
      istk(il1)=10
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=it1
      volr=istk(idr+mr*nr)
      call icopy(mr*nr+1+volr,istk(idr),1,istk(il1+4),1)
      lstk(top+1)=sadr(il1+5+mr*nr+volr)
      goto 999
c
c
c extraction
c
  130 rhs=rhs1-1
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
      if(istk(ilcol).eq.4) then
         rhs=rhs1
         top=top0
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
      nr=ncol
      lcol=sadr(ilcol+4)
      if(ncol.eq.0) goto 146
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
      if(istk(ilrow).eq.4) then
         rhs=rhs1
         top=top0
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
      lr=idr+mnr+1
      err=sadr(lr)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
      call impext(istk(l1r),istk(id1),m1,n1,istk(ilrow),nrow,
     &    istk(ilcol),ncol,istk(lr),istk(idr),0,err)
      if(err.gt.0) then
         call error(21)
         return
      endif
      volr=istk(idr+mnr)-1
      err=sadr(lr+volr)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call impext(istk(l1r),istk(id1),m1,n1,istk(ilrow),nrow,
     &            istk(ilcol),ncol,istk(lr),istk(idr),1,err)
c
      il1=iadr(lstk(top))
      istk(il1)=10
      istk(il1+1)=mr
      istk(il1+2)=nr
      istk(il1+3)=it1
      call icopy(mnr+1+volr,istk(idr),1,istk(il1+4),1)
      lstk(top+1)=sadr(il1+5+mnr+volr)
      go to 999
  146 continue
c un des vecteurs d'indice est vide
      top=top0-rhs1+1
      il1=iadr(lstk(top))
      istk(il1)=1
      istk(il1+1)=0
      istk(il1+2)=0
      lstk(top+1)=sadr(il1+4)+1
      goto 999
c
c     comparaisons
 180  continue
      itrue=1
      if(op.eq.less+great) itrue=0
c     comparaison des types
      if(istk(il1).ne.istk(il2)) then
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
         nn1=istk(il1+5)-1
         l1r=iadr(lw)
         err=sadr(l1r+nn1+2)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(nn1,istk(il1+6),1,istk(l1r),1)
         id1=l1r+nn1
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
         nn2=istk(il2+5)-1
         l2r=iadr(lw)
         err=sadr(l2r+nn2+2)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call icopy(nn2,istk(il2+6),1,istk(l2r),1)
         id2=l2r+nn2
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
         l1=il1+5+mn1
         l2=il2+5+mn2
      endif
c     des valeurs
      i1=id1-inc1
      i2=id2-inc2
      l1r=l1r-1
      l2r=l2r-1
      do 185 i=0,mn1-1
         i1=i1+inc1
         i2=i2+inc2
         if(istk(i1+1)-istk(i1).ne.istk(i2+1)-istk(i2) ) goto 184
         nl=istk(i1+1)-istk(i1)-1
         do 182 ii=0,nl
            if(istk(l1r+istk(i1)+ii).ne.istk(l2r+istk(i2)+ii)) goto 184
 182     continue
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
