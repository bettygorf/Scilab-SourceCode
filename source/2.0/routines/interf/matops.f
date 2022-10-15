      subroutine matops
c     
c     operations matricielles
c     
      include '../stack.h'
      integer op
c     
      double precision ddot,d1mach
      double precision cstr,csti
      integer vol,iadr,sadr
c     
      double precision sr,si,e1,st,e2,powr,powi,e1r,e1i,e2r,e2i
      integer plus,minus,star,dstar,slash,bslash,dot,colon,concat
      integer quote,extrac,insert,less,great,equal
      integer top0
      data plus/45/,minus/46/,star/47/,dstar/58/,slash/48/
      data bslash/49/,dot/51/,colon/44/,concat/1/,quote/53/
      data extrac/3/,insert/2/,less/59/,great/60/,equal/50/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      op=fin
c     
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matops op: '//buf(1:4))
      endif
c     
      top0=top
      lw=lstk(top+1)+1
      it2=0
      goto (04,03,02,01) rhs
      call error(39)
      return
c     
 01   il4=iadr(lstk(top))
      if(istk(il4).lt.0) il4=iadr(istk(il4+1))
      m4=istk(il4+1)
      n4=istk(il4+2)
      it4=istk(il4+3)
      l4=sadr(il4+4)
      mn4=m4*n4
      top=top-1
c     
 02   il3=iadr(lstk(top))
      if(istk(il3).lt.0) il3=iadr(istk(il3+1))
      m3=istk(il3+1)
      n3=istk(il3+2)
      it3=istk(il3+3)
      l3=sadr(il3+4)
      mn3=m3*n3
      top=top-1
c     
 03   il2=iadr(lstk(top))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      l2=sadr(il2+4)
      mn2=m2*n2
      top=top-1
c     
 04   il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      l1=sadr(il1+4)
      mn1=m1*n1
      top=top-1
c     
c     operations binaires et ternaires
c     --------------------------------
c     
      top=top+1
      itr=max(it1,it2)
c     
      fun = 0
c     
c     cconc  extrac insert rconc
      goto(75  ,  85  ,  80   ,78) op
c     
c           :  +  -  * /  \  =          '
      goto(50,07,08,10,20,25,130,06,06,70) op+1-colon
c     
 06   if(op.eq.dstar) goto 30
      if(op.ge.3*dot+star) goto 65
      if(op.ge.2*dot+star) goto 120
      if(op.ge.less+equal) goto 130
      if(op.ge.dot+star) goto 55
      if(op.ge.less) goto 130
c     
c     addition
 07   continue
c       []+a
      if (mn1.eq.0) then
         call icopy(4,istk(il2),1,istk(il1),1)
         call dcopy(mn2*(it2+1),stk(l2),1,stk(l1),1)
         lstk(top+1)=l1+mn2*(it2+1)
         goto 999
      elseif(mn2.eq.0) then
c       a+[]
         goto 999
      endif
      if (m1 .lt. 0) go to 40
      if (m2 .lt. 0) go to 41
      if (mn2.eq.1) then
c        a+cst
         call dadd(mn1,stk(l2),0,stk(l1),1)
         if(it2+2*it1.eq.1) call dcopy(mn1,stk(l2+mn2),0,
     &                                 stk(l1+mn1),1)
         if(it1*it2.eq.1) call dadd(mn1,stk(l2+mn2),0,
     &                              stk(l1+mn1),1)
         lstk(top+1)=l1+mn1*(itr+1)
         istk(il1+3)=itr
         goto 999
      endif
      if (mn1.eq.1) then
c        cst+a
         cstr=stk(l1)
         csti=stk(l1+1)
         call dcopy((it2+1)*mn2,stk(l2),1,stk(l1),1)
         if(it1.eq.1.and.it2.eq.0) call dset(mn2,0.d0,stk(l1+mn2),1)
         call dadd(mn2,cstr,0,stk(l1),1)
         if(it1.eq.1) call dadd(mn2,csti,0,stk(l1+mn2),1)
         lstk(top+1)=l1+mn2*(itr+1)
         istk(il1+1)=m2
         istk(il1+2)=n2
         istk(il1+3)=itr
         goto 999
      endif
      if (m1 .ne. m2.or.n1 .ne. n2) then
      call error(8)
      return
      endif
      call dadd(mn1,stk(l2),1,stk(l1),1)
      if(it2+2*it1.eq.1) call dcopy(mn1,stk(l2+mn1),1,stk(l1+mn1),1)
      if(it1*it2.eq.1) call dadd(mn1,stk(l2+mn1),1,stk(l1+mn1),1)
      lstk(top+1)=l1+mn1*(itr+1)
      istk(il1+3)=itr
      go to 999
c     
c     soustraction
 08   if(rhs.eq.2) goto 09
      if(mn1.le.0) goto 999
      call dscal(mn1*(it1+1),-1.0d+0,stk(l1),1)
      goto 999
 09   continue
      if (mn1.eq.0) then
c        []-a
         call icopy(4,istk(il2),1,istk(il1),1)
         call dcopy(mn2*(it2+1),stk(l2),1,stk(l1),1)
         call dscal(mn2*(it2+1),-1.0d0,stk(l1),1)
         lstk(top+1)=l1+mn2*(it2+1)
         goto 999
      elseif(mn2.eq.0) then
c         a-[]
         goto 999
      endif
      if (mn2.eq.1) then
c        a-cst
         stk(l2)=-stk(l2)
         if(it2.eq.1) stk(l2+1)=-stk(l2+1)
         goto 07
      endif
      if (mn1.eq.1) then
c        cst-a
         call dscal((it2+1)*mn2,-1.0d0,stk(l2),1)
         goto 07
      endif
      if (m1 .lt. 0) go to 42
      if (m2 .lt. 0) go to 45
c       check dimensions
      if (m1 .ne. m2.or.n1 .ne. n2) then
      call error(9)
      return
      endif
      call ddif(mn1,stk(l2),1,stk(l1),1)
      if(itr.eq.0) goto 999
      if(it1.eq.0) call dscal (mn1,-1.0d+0,stk(l2+mn1),1)
      if(it1.eq.0) call dcopy(mn1,stk(l2+mn1),1,stk(l1+mn1),1)
      if(it1*it2.eq.1) call ddif(mn1,stk(l2+mn1),1,stk(l1+mn1),1)
      lstk(top+1)=l1+mn1*(itr+1)
      istk(il1+3)=itr
      go to 999
c     
c     multiplication
 10   if (m2*mn2 .eq. 1) go to 12
      if (mn1 .eq. 1) go to 13
      if (mn2 .eq. 1) go to 12
      if(mn1.eq.0.or.mn2.eq.0) then
         istk(il1+1)=0
         istk(il1+2)=0
         istk(il1+3)=0
         lstk(top+1)=sadr(il1+4)+1
         goto 999
      endif
      if (n1 .ne. m2) then
         call error(10)
         return
      endif
c     
      istk(il1+2)=n2
      istk(il1+3)=itr
      lstk(top+1)=l1+m1*n2*(itr+1)
c     
      mnr=m1*n2*(itr+1)
      lr=l1+mnr
      vol=lstk(top+2)-lstk(top)
      err=lr+vol-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dcopy(vol,stk(l1),-1,stk(lr),-1)
      l2=l2+mnr
c     
      if(it1*it2.eq.1) goto 11
      call dmmul(stk(lr),m1,stk(l2),m2,stk(l1),m1,m1,n1,n2)
      if(it1.eq.1) call dmmul(stk(lr+mn1),m1,stk(l2),m2,stk(l1+m1*n2),
     1     m1,m1,n1,n2)
      if(it2.eq.1) call dmmul(stk(lr),m1,stk(l2+mn2),m2,stk(l1+m1*n2),
     1     m1,m1,n1,n2)
      goto 999
c     a et a2 sont complexes
 11   call wmmul(stk(lr),stk(lr+mn1),m1,stk(l2),
     1     stk(l2+mn2),m2,stk(l1),stk(l1+m1*n2),m1,m1,n1,n2)
      go to 999
c     
 12   continue
c     a*cst
      sr = stk(l2)
      if(it2.eq.1) si = stk(l2+1)
      go to 14
 13   continue
c     cst*a
      sr = stk(l1)
      if(it1.eq.1) si = stk(l1+1)
      call dcopy(mn2*(it2+1),stk(l2),1,stk(l1),1)
      m1=m2
      n1=n2
      mn1=it1
      it1=it2
      it2=mn1
      mn1=mn2
c     
 14   continue
      istk(il1+1)=m1
      istk(il1+2)=n1
      istk(il1+3)=itr
      lstk(top+1)=l1+mn1*(itr+1)
c     
      err=lstk(top+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c     
      goto (15,16,17),it2+2*it1
c     la matrice et le scalaire sont reel
      call dscal(mn1,sr,stk(l1),1)
      goto 999
 15   continue
c     la matrice est reelle le scalaire est complexe
      call dcopy(mn1,stk(l1),1,stk(l1+mn1),1)
      call dscal(mn1,si,stk(l1+mn1),1)
      call dscal(mn1,sr,stk(l1),1)
      goto 999
 16   continue
c     la matrice est complexe, le scalaire est reel
      call dscal(mn1,sr,stk(l1),1)
      call dscal(mn1,sr,stk(l1+mn1),1)
      goto 999
 17   continue
c     la matrice et le scalaire sont complexes
      call wscal(mn1,sr,si,stk(l1),stk(l1+mn1),1)
      goto 999
c     
c     division a droite
 20   if (mn2 .eq. 1) go to 21
      if (m2 .eq. n2) fun = 1
      if (m2 .ne. n2) fun = 4
      fin = -1
      top = top+1
      rhs = 2
      go to 999
 21   continue
      sr=stk(l2)
      si=0.0d+0
      if(it2.eq.1) si=stk(l2+1)
 22   e1=max(abs(sr),abs(si))
c     prov  NON!!!!!!!  1/1.d20 --> 0 !
c      if(e1.eq.(1.d0+e1)) then
c      sr=0.d0
c      goto 14
c      endif
c
      if(e1.eq.0.0d+0) then
         call error(27)
         return
      endif
      sr=sr/e1
      si=si/e1
      e1=e1*(sr*sr+si*si)
      sr=sr/e1
      si=-si/e1
      goto 14
c     on appele la multiplication avec l'inverse du scalaire
c     
c     division a gauche
 25   if (m1*n1 .eq. 1) go to 26
      if (m1 .eq. n1) fun = 1
      if (m1 .ne. n1) fun = 4
      top = top+1
      fin = -2
      rhs = 2
      go to 999
 26   continue
      m1=m2
      n1=n2
      sr=stk(l1)
      si=0.0d+0
      if(it1.eq.1) si=stk(l1+1)
      call dcopy(mn2*(it2+1),stk(l2),1,stk(l1),1)
      m1=m2
      n1=n2
      mn1=it1
      it1=it2
      it2=mn1
      mn1=mn2
      goto 22
c     
c     puissance
 30   if (mn2 .ne. 1) then
         call error(30)
         return
      endif
      if(m1.eq.n1.and.m1*n1.gt.1) goto 31
      err=l1+mn1*(itr+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c     element wise
      if(it2.eq.0) then
         powr=stk(l2)
         if(it1.eq.0) then
            call ddpow(mn1,stk(l1),1,powr,err)
         else
            call wdpow(mn1,stk(l1),stk(l1+mn1),1,
     &           powr,err)
         endif
      else
         powr=stk(l2)
         powi=stk(l2+1)
         if(it1.eq.0) then
            call dwpow(mn1,stk(l1),stk(l1+mn1),1,
     &           powr,powi,err)
         else
            call wwpow(mn1,stk(l1),stk(l1+mn1),1,
     &           powr,powi,err)
         endif
      endif
      if(err.eq.1) then
         call error(30)
         return
      endif
      if(err.eq.2) then
         call error(27)
         return
      endif
      istk(il1+3)=itr
      lstk(top+1)=l1+mn1*(itr+1)
      goto 999
c     
c     elevation d'une matrice carree a une puissance
 31   nexp = nint(stk(l2))
      if (it2 .ne. 0) go to 39
      if (stk(l2) .ne. dble(nexp)) go to 39
      if (nexp.eq.1) go to 999
      if (nexp.eq.0) then
         lw=l1+mn1*(it1+1)
         ipvt=iadr(lw+m1*(it1+1))
         err=sadr(ipvt+m1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         if(it1.eq.0) then
            call dgeco(stk(l1),m1,m1,istk(ipvt),sr,stk(lw))
         else
            call wgeco(stk(l1),stk(l1+mn1),m1,m1,istk(ipvt),
     &           sr,stk(lw),stk(lw+m1))
         endif
         if(1.0d+0+sr.eq.1.0d+0) then
            call error(19)
            return
         endif
         call dset(mn1,0.0d+0,stk(l1),1)
         call dset(m1,1.0d+0,stk(l1),m1+1)
         istk(il1+3)=0
         lstk(top+1)=l1+mn1
         goto 999
      endif
c     
      if (nexp.le.0) then
         fun=10
         fin=1
         rhs=1
         call matlu
         if(err.gt.0) return
         nexp=-nexp
         fun=0
      endif
      l2=l1+mn1*(it1+1)
c     
      l3=l2+mn1*(itr+1)
      err=l3+n1*(itr+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      lstk(top+1)=l1+mn1*(itr+1)
      istk(il1+3)=itr
c     
      call dcopy(mn1*(itr+1),stk(l1),1,stk(l2),1)
      if(it1.eq.1) goto 35
c     la matrice est reelle
      do 34 kexp=2,nexp
         do 33 j=1,n1
            ls=l1+(j-1)*n1
            call dcopy(n1,stk(ls),1,stk(l3),1)
            do 32 i=1,n1
               ls=l2+(i-1)
               ll=l1+(i-1)+(j-1)*n1
               stk(ll)=ddot(n1,stk(ls),n1,stk(l3),1)
 32         continue
 33      continue
 34   continue
      goto 999
c     
 35   continue
c     la matrice est complexe
      do 38 kexp=2,nexp
         do 37 j=1,n1
            ls=l1+(j-1)*n1
            call dcopy(n1,stk(ls),1,stk(l3),1)
            call dcopy(n1,stk(ls+mn1),1,stk(l3+n1),1)
            do 36 i=1,n1
               ls=l2+(i-1)
               ll=l1+(i-1)+(j-1)*n1
               stk(ll)=ddot(n1,stk(ls),n1,stk(l3),1)-
     $              ddot(n1,stk(ls+mn1),n1,stk(l3+n1),1)
               stk(ll+mn1)=ddot(n1,stk(ls),n1,stk(l3+n1),1)+
     $              ddot(n1,stk(ls+mn1),n1,stk(l3),1)
 36         continue
 37      continue
 38   continue
      goto 999
c     
c     puissance non entiere ou non positive
 39   fun = 6
      fin = 29
      rhs=2
      top=top+1
      go to 999
c     
c     
c     
c     addition et soustraction d'un scalaire fois l'identite
 40   sr=stk(l1)
      si=0.0d+0
      if(it1.eq.1) si=stk(l1+1)
      call dcopy(mn2*(it2+1),stk(l2),1,stk(l1),1)
      m1=m2
      n1=n2
      m2=it2
      it2=it1
      it1=m2
      mn1=mn2
      goto 46
c     
 41   sr=stk(l2)
      si=0.0d0
      if(it2.eq.1) si = stk(l2+1)
      goto 46
c     
c     soustraction a*eye-b
 42   sr=stk(l1)
      si=0.0d+0
      if(it1.eq.1) si=stk(l1+1)
 43   call dcopy(mn2*(it2+1),stk(l2),1,stk(l1),1)
      call dscal(mn2*(it2+1),-1.0d+0,stk(l1),1)
      mn1=mn2
      m1=m2
      n1=n2
      m2=it2
      it2=it1
      it1=m2
      goto 46
c     
c     soustraction a-eye*b
 45   sr=-stk(l2)
      si=0.0d+0
      if(it2.eq.1) si =- stk(l2+1)
c     
 46   err=l1+mn1*(itr+1) - lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      lstk(top+1)=l1+mn1*(itr+1)
      istk(il1+1)=m1
      istk(il1+2)=n1
      istk(il1+3)=itr
c     
      if(itr.eq.1.and.it1.eq.0) call dset(mn1,0.0d+0,stk(l1+mn1),1)
      do 47 i = 1, max(n1,m1)
         ll = l1 + (i-1)*(m1+1)
         stk(ll) = stk(ll)+sr
         if(itr.ne.0) stk(ll+mn1) = stk(ll+mn1)+si
 47   continue
      go to 999
c     
c     boucle implicite
 50   e2 = stk(l2)
      st = 1.0d+0
      n = 0
      if (rhs .lt. 3) go to 51
      e2=stk(l3)
      st = stk(l2)
      if (st .eq. 0.0d+0) go to 53
 51   e1 = stk(l1)
c     check for clause
      if (rstk(pt-1) .eq. 801.or.rstk(pt).eq.611) go to 54
      err = l1 + max(3,int((e2-e1)/st)) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      l=l1
 52   if (st*(stk(l)-e2).gt.0.0d+0) then
         if (abs(stk(l)-e2).lt.abs(st*d1mach(4))) n=n+1
         go to 53
      endif
      n = n+1
      l = l+1
      stk(l) = e1 + dble(n)*st
      go to 52
 53   continue
      istk(il1+1)=1
      if(n.eq.0) istk(il1+1)=0
      istk(il1+2)=n
      istk(il1+3)=0
      lstk(top+1)=l1+n
      go to 999
c     
c     for clause
 54   stk(l1) = e1
      stk(l1+1) = st
      stk(l1+2) = e2
      istk(il1+1)=-3
      istk(il1+2)=-1
      lstk(top+1)=l1+3
      go to 999
c     
c     operations elements a elements
 55   continue
      i1=1
      i2=1
      op = op - dot
      if(mn1.eq.0.or.mn2.eq.0) then
c     [].*a     a.*[]  -->[]
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         istk(il1+3)=0
         lstk(top+1)=sadr(il1+4)+1
         goto 999
      endif
      if(mn1.eq.1.and.op.eq.star) goto 13
      if(mn2.eq.1.and.op.eq.star) goto 12
      if(mn1.ne.1.and.mn2.ne.1) then
c       check dimensions
      if (m1.ne.m2 .or. n1.ne.n2) then
         buf='inconsistent element-wise operation'
         call error(9999)
         return
      endif
      endif
      lstk(top+1)=l1+mn1*(itr+1)
      istk(il1+3)=itr
      if(mn2.eq.1) then
       if(op.eq.slash) then
       cstr=stk(l2)
        if(it2.eq.1) csti=stk(l2+1)
           if(it1*it2.eq.1) then
           sr=cstr
           si=csti
           e1=abs(sr)+abs(si)
            if(e1.eq.0.0d+0) then
            call error(27)
            return
            endif
           sr=sr/e1
           si=si/e1
           e1=e1*(sr*sr+si*si)
           sr=sr/e1
           si=-si/e1
           call wvmul(mn1,sr,si,0,stk(l1),stk(l1+mn1),1)
           goto 999
           endif
        if(it1.eq.0.and.it2.eq.0) then
           if (cstr.eq.0.d0) then
           call error(27)
           return
           endif
           call dvmul(mn1,1.0d0/cstr,0,stk(l1),1)
           goto 999
        endif
        if(it1.eq.0.and.it2.eq.1) then
           err=l1+2*mn1-lstk(bot)
           if(err.gt.0) then
           call error(17)
           return
           endif
           lstk(top+1)=l1+2*mn1
           istk(il1+3)=it2
           sr=cstr
           si=csti
           e1=abs(sr)+abs(si)
            if(e1.eq.0.0d+0) then
             call error(27)
             return
            endif
           sr=sr/e1
           si=si/e1
           e1=e1*(sr*sr+si*si)
           sr=sr/e1
           si=-si/e1
           call dset(mn1,0.d0,stk(l1+mn1),1)
           call wvmul(mn1,sr,si,0,stk(l1),stk(l1+mn1),1)
           goto 999
        endif
        if(it1.eq.1.and.it2.eq.0) then
           if(cstr.eq.0.d0) then
           call error(27) 
           return
           endif
           call dvmul(2*mn1,1.0d0/cstr,0,stk(l1),1)
           goto 999
        endif
       endif
       if(op.eq.bslash) then
       cstr=stk(l2)
       if(it2.eq.1) csti=stk(l2+1)
          if(it1.eq.0.and.it2.eq.0) then
          do 550 ii=1,mn1
          if(stk(l1+ii-1).eq.0.d0) then
          call error(27)
          endif
          stk(l1+ii-1)=cstr/stk(l1+ii-1)
 550      continue
          goto 999
          endif
          if(it1.eq.0.and.it2.eq.1) then
          istk(il1+3)=it2
          err=l1+2*mn1-lstk(bot)
              if(err.gt.0) then
              call error(17)
              return
              endif
          lstk(top+1)=l1+2*mn1
          do 551 i=1,mn1
          sr=stk(l1+i-1)
          e1=abs(sr)+abs(si)
            if(sr.eq.0.0d+0) then
             call error(27)
             return
            endif
          stk(l1+i-1)=cstr/sr
          stk(l1+mn1+i-1)=csti/sr
 551      continue
          goto 999
          endif
          if(it1.eq.1.and.it2.eq.0) then
          do 552 i=1,mn1
          sr=stk(l1+i-1)
          si=stk(l1+mn1+i-1)
          e1=abs(sr)+abs(si)
            if(e1.eq.0.0d+0) then
             call error(27)
             return
            endif
          sr=sr/e1
          si=si/e1
          e1=e1*(sr*sr+si*si)
          sr=sr/e1
          si=-si/e1
          stk(l1+i-1)=cstr*sr
          stk(l1+mn1+i-1)=cstr*si
 552      continue
          goto 999
          endif
          if(it1.eq.1.and.it2.eq.1) then
          do 553 i=1,mn1
          sr=stk(l1+i-1)
          si=stk(l1+mn1+i-1)
          e1=abs(sr)+abs(si)
            if(e1.eq.0.0d+0) then
             call error(27)
             return
            endif
          sr=sr/e1
          si=si/e1
          e1=e1*(sr*sr+si*si)
          sr=sr/e1
          si=-si/e1
          stk(l1+i-1)=sr*cstr-si*csti
          stk(l1+mn1+i-1)=cstr*si+sr*csti
 553      continue
          goto 999
          endif
       endif
      endif
c              
      if(mn1.eq.1) then
       if(op.eq.slash) then
       cstr=stk(l1)
       if(it1.eq.1) csti=stk(l1+1)
           if(it1.eq.0.and.it2.eq.0) then
           istk(il1+1)=m2
           istk(il1+2)=n2
           lstk(top+1)=l1+mn2
           do 554 i=1,mn2
           sr=stk(l2+i-1)
            if(sr.eq.0.d0) then
            call error(27)
            return
            endif
           stk(l1+i-1)=cstr/sr
 554       continue
           goto 999
           endif
           if(it1.eq.0.and.it2.eq.1) then
           err=l1+2*mn2-lstk(bot)
            if(err.gt.0) then
            call error(17)
            return
            endif
           istk(il1+1)=m2
           istk(il1+2)=n2
           istk(il1+3)=it2
           lstk(top+1)=l1+2*mn2
           do 555 i=1,mn2
           sr=stk(l2+i-1)
           si=stk(l2+mn2+i-1)
           e1=abs(sr)+abs(si)
            if(e1.eq.0.0d+0) then
            call error(27)
            return
            endif
           sr=sr/e1
           si=si/e1
           e1=e1*(sr*sr+si*si)
           sr=sr/e1
           si=-si/e1
           stk(l2+i-1)=sr*cstr
           stk(l2+mn2+i-1)=cstr*si
 555       continue
           call dcopy(2*mn2,stk(l2),1,stk(l1),1)
           goto 999
           endif
           if(it1.eq.1.and.it2.eq.1) then
           istk(il1+1)=m2
           istk(il1+2)=n2
           lstk(top+1)=l1+2*mn2
           do 556 i=1,mn2
           sr=stk(l2+i-1)
           si=stk(l2+mn2+i-1)
           e1=abs(sr)+abs(si)
            if(e1.eq.0.0d+0) then
             call error(27)
             return
            endif
           sr=sr/e1
           si=si/e1
           e1=e1*(sr*sr+si*si)
           sr=sr/e1
           si=-si/e1
           stk(l2+i-1)=sr*cstr-si*csti
           stk(l2+mn2+i-1)=cstr*si+csti*sr
 556       continue
           call dcopy(2*mn2,stk(l2),1,stk(l1),1)
           goto 999
           endif
           if(it1.eq.1.and.it2.eq.0) then
           err=l1+2*mn2-lstk(bot)
            if(err.gt.0) then
            call error(17)
            return
            endif
           istk(il1+1)=m2
           istk(il1+2)=n2
           lstk(top+1)=l1+2*mn2
           do 557 i=1,mn2
           sr=stk(l2+i-1)
            if(sr.eq.0.0d+0) then
             call error(27)
             return
            endif
           stk(l2+i-1)=cstr/sr
           stk(l2+mn2+i-1)=csti/sr
 557       continue
           call dcopy(2*mn2,stk(l2),1,stk(l1),1)
           goto 999
           endif
       endif
       if(op.eq.bslash) then
       cstr=stk(l1)
       if(it1.eq.1) csti=stk(l1+1)
           if(it1.eq.0.and.it2.eq.0) then
            if(cstr.eq.0.d0) then
            call error(17)
            return
            endif
           istk(il1+1)=m2
           istk(il1+2)=n2
           lstk(top+1)=l1+mn2
           do 558 i=1,mn2
           sr=stk(l2+i-1)
           stk(l1+i-1)=sr/cstr
 558       continue
           goto 999
           endif
           if(it1.eq.1.and.it2.eq.0) then
           err=l2+2*mn2-lstk(bot)
            if(err.gt.0) then
            call error(17)
            return
            endif
           sr=cstr
           si=csti
           e1=abs(sr)+abs(si)
            if(e1.eq.0.0d+0) then
            call error(27)
            return
            endif
           sr=sr/e1
           si=si/e1
           e1=e1*(sr*sr+si*si)
           sr=sr/e1
           si=-si/e1
           cstr=sr
           csti=si
           istk(il1+1)=m2
           istk(il1+2)=n2
           lstk(top+1)=l1+2*mn2
           do 559 i=1,mn2
           sr=stk(l2+i-1)
           stk(l2+i-1)=sr*cstr
           stk(l2+mn2+i-1)=sr*csti
 559       continue
           call dcopy(2*mn2,stk(l2),1,stk(l1),1)
           goto 999
           endif
           if(it1.eq.0.and.it2.eq.1) then
            if(cstr.eq.0.d0) then
            call error(27)
            return
            endif
           istk(il1+1)=m2
           istk(il1+2)=n2
           istk(il1+3)=it2
           lstk(top+1)=l1+2*mn2
           do 560 i=1,mn2
           stk(l2+i-1)=stk(l2+i-1)/cstr
           stk(l2+mn2+i-1)=stk(l2+mn2+i-1)/cstr
 560       continue
           call dcopy(2*mn2,stk(l2),1,stk(l1),1)
           goto 999
           endif
           if(it1.eq.1.and.it2.eq.1) then
           istk(il1+1)=m2
           istk(il1+2)=n2
           istk(il1+3)=it2
           lstk(top+1)=l1+2*mn2
           sr=cstr
           si=csti
           e1=abs(sr)+abs(si)
            if(e1.eq.0.0d+0) then
            call error(27)
            return
            endif
           sr=sr/e1
           si=si/e1
           e1=e1*(sr*sr+si*si)
           sr=sr/e1
           si=-si/e1
           cstr=sr
           csti=si
           do 561 i=1,mn2
           sr=stk(l2+i-1)
           si=stk(l2+mn2+i-1)
           stk(l2+i-1)=sr*cstr-si*csti
           stk(l2+mn2+i-1)=sr*csti+si*cstr
 561       continue
           call dcopy(2*mn2,stk(l2),1,stk(l1),1)
           goto 999
           endif
       endif
      endif
      if(op.ne.star) goto 60
c     multiplication
 56   if(it1*it2.eq.1) goto 58
      if(it1.eq.1) call dvmul(mn1,stk(l2),i2,stk(l1+mn1),i1)
      if(it2.eq.1) call dvmul(mn1,stk(l1),i1,stk(l2+mn2),i2)
      call dvmul(mn1,stk(l2),i2,stk(l1),i1)
      if(it2.eq.1) call dcopy(mn1,stk(l2+mn2),i2,stk(l1+mn1),i1)
      goto 999
c     a et a2 complexes
 58   call wvmul(mn1,stk(l2),stk(l2+mn2),i2,stk(l1),stk(l1+mn1),i1)
      goto 999
c     
c     division a droite et a gauche
c     
 60   lstk(top+1)=l1+mn1*(itr+1)
      istk(il1+3)=itr
      ll=l2-1
      it=it2
      if(op.eq.slash) goto 61
      ll=l1-1
      it=it1
 61   if(it.eq.1) goto 63
c     la matrice diviseur est reelle
      do 62 i=1,mn1
         if(stk(ll+i).eq.0.0d+0) then
            call error(27)
            return
         endif
         stk(ll+i)=1.0d+0/stk(ll+i)
 62   continue
      if(mn1.eq.1) goto 13
      goto 56
c     la matrice diviseur est complexe
 63   do 64 i=1,mn1
         sr=stk(ll+i)
         si=stk(ll+mn1+i)
         e1=abs(sr)+abs(si)
         if(e1.eq.0.0d+0) then
            call error(27)
            return
         endif
         sr=sr/e1
         si=si/e1
         e1=e1*(sr*sr+si*si)
         sr=sr/e1
         si=-si/e1
         stk(ll+i)=sr
         stk(ll+mn1+i)=si
 64   continue
      if(mn1.eq.1) goto 13
      goto 56
c     
c     kronecker
 65   fin = op - 3*dot - star + 19
      fun = 6
      top = top + 1
      rhs = 2
      go to 999
c     
c     
c     transposition
 70   if(mn1 .eq. 0.or.istk(il1).eq.0) goto 999
      vol=mn1*(it1+1)
      ll = l1+vol
      err = ll+vol - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
c     
      istk(il1+1)=n1
      istk(il1+2)=m1
c     
      call dcopy(vol,stk(l1),1,stk(ll),1)
      call mtran(stk(ll),m1,stk(l1),n1,m1,n1)
      if(it1.eq.0) goto 999
      call mtran(stk(ll+mn1),m1,stk(l1+mn1),n1,m1,n1)
      call dscal(mn1,-1.0d+0,stk(l1+mn1),1)
c     
      goto 999
c     
c     concatenation [a b]
 75   if(m1.lt.0.or.m2.lt.0) then
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
      if(itr.eq.0) then
         call dcopy(mn2,stk(l2),1,stk(l1+mn1),1)
      else
         lw=l1+(itr+1)*(mn1+mn2)
         if(lw.gt.l2) then
            err=lw+mn2*(it2+1)-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call dcopy(mn2*(it2+1),stk(l2),-1,stk(lw),-1)
            l2=lw
         endif
         if(it1.eq.1) call dcopy(mn1,stk(l1+mn1),-1,stk(l1+mn1+mn2),-1)
         call dcopy(mn2,stk(l2),1,stk(l1+mn1),1)
         if(it1.eq.0) call dset(mn1,0.0d+0,stk(l1+mn1+mn2),1)
         if(it1.eq.0) call dcopy(mn2,stk(l2+mn2),1,stk(l1+2*mn1+mn2),1)
         if(it2.eq.0) call dset(mn2,0.0d+0,stk(l1+2*mn1+mn2),1)
         if(it2.eq.1) call dcopy(mn2,stk(l2+mn2),1,stk(l1+2*mn1+mn2),1)
      endif
      n=n1+n2
      istk(il1+1)=m1
      istk(il1+2)=n
      istk(il1+3)=itr
      lstk(top+1)=sadr(il1+4)+m1*n*(itr+1)
      goto 999
c     
c     concatenation [a;b]
 78   if(n1.lt.0.or.n2.lt.0) then
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
      if(n1.eq.1.and.itr.eq.0) then
         call dcopy(mn2,stk(l2),1,stk(l1+mn1),1)
         istk(il1+1)=m
         istk(il1+3)=itr
         lstk(top+1)=l1+mn*(itr+1)
         goto 999
      endif
      lw1=l1+(itr+1)*mn
      lw2=lw1+mn1*(it1+1)
      err=lw2+mn2*(it2+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dcopy(mn2*(it2+1),stk(l2),1,stk(lw2),1)
      call dcopy(mn1*(it1+1),stk(l1),1,stk(lw1),1)
c     
      if(itr.eq.1) call dset(mn,0.0d+0,stk(l1+(mn1+mn2)),1)
      call dmcopy(stk(lw1),m1,stk(l1),m,m1,n1)
      if(it1.eq.1) call dmcopy(stk(lw1+mn1),m1,stk(l1+mn),m,m1,n1)
      call dmcopy(stk(lw2),m2,stk(l1+m1),m,m2,n1)
      if(it2.eq.1) call dmcopy(stk(lw2+mn2),m2,stk(l1+mn+m1),m,m2,n1)
      istk(il1+1)=m
      istk(il1+2)=n1
      istk(il1+3)=itr
      lstk(top+1)=sadr(il1+4)+mn*(itr+1)
      goto 999
c     
c     extraction
c     
 80   continue
c     extraction
c     
      if(rhs.gt.2) goto 82
c     vect(arg)
      if(mn1.eq.0) then
c     un des vecteurs d'indice est vide
         istk(il1+1)=0
         istk(il1+2)=0
         lstk(top+1)=l1+1
         goto 999
      endif
      if(m1.gt.1.and.n1.gt.1.or.it1.ne.0) then
         call error(21)
         return
      endif
      if(m2.lt.0) then
         call error(14)
         return
      endif
c     
      if(m1.lt.0) mn1=mn2
      err=l1+(it2+1)*mn1-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c     
      do 81 i = 0, mn1-1
         ll = l1+i
         ls = l2+i
         if (m1 .gt. 0) then
            ls = l2 + int(stk(ll)) - 1
            if (ls .lt. l2 .or. ls .ge. l2+mn2) then
               call error(21)
               return
            endif
         endif
         stk(ll) = stk(ls)
         if(it2.eq.1) stk(ll+mn1) = stk(ls+mn2)
 81   continue
      m = 1
      n = 1
      if (m2 .gt. 1) m = mn1
      if (m2 .eq. 1) n = mn1
      istk(il1)=1
      istk(il1+1)=m
      istk(il1+2)=n
      istk(il1+3)=it2
      lstk(top+1)=l1+m*n*(it2+1)
      go to 999
c     
c     matrix(arg,arg)
 82   if(rhs.gt.4) then
         call error(36)
         return
      endif
      if(mn1*mn2.eq.0) then
c     un des vecteurs d'indice est vide
         istk(il1+1)=0
         istk(il1+2)=0
         lstk(top+1)=l1+1
         goto 999
      endif
      if(it1+it2.ne.0) then
         call error(21)
         return
      endif
      if(m3.lt.0) then
         call error(14)
         return
      endif
      m=mn1
      if(istk(il1+1).lt.0) m=istk(il3+1)
c     
      n=mn2
      if(istk(il2+1).lt.0) n=istk(il3+2)
c     
      l=lstk(top+2)
      mn = m*n
      err=l+(it3+1)*mn-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 84 j = 1, n
         do 83 i = 1, m
            li = l1+i-1
            if (istk(il1+1) .gt. 0) li = l1 + int(stk(li)) - 1
            lj = l2+j-1
            if (istk(il2+1) .gt. 0) lj = l2 + int(stk(lj)) - 1
            ls = l3 + li-l1 + (lj-l2)*m3
            if (ls.lt.l3 .or. ls.ge.l3+mn3) then
               call error(21)
               return
            endif
            ll = l + i-1 + (j-1)*m
            stk(ll) = stk(ls)
            if(it3.eq.1) stk(ll+mn) = stk(ls+mn3)
 83      continue
 84   continue
      call dcopy(mn*(it3+1),stk(l),1,stk(l1),1)
      istk(il1+1)=m
      istk(il1+2)=n
      istk(il1+3)=it3
      lstk(top+1)=l1+mn*(it3+1)
      go to 999
      
c     insert
c     a(vl,vc)=m arg4(arg1,arg2)=arg3 ou  a(v)=u (arg3(arg1)=arg2)
 85   ili=iadr(lstk(top0-1))
      if (istk(ili+1)*istk(ili+2).eq.0) then
         top=top0
         fin=-fin
         return
      endif
      m=-1
      n=-1
      goto (86,88),rhs-2
c     
c     arg3(arg1)=arg2
c     
 86   mk=m3
      nk=n3
      itk=it3
      lk=l3
      md=m2
      nd=n2
      itd=it2
      ld=l2
c     
      if(it1.ne.0) then
         call error(21)
         return
      endif
c
      if (n3.le.1.and.n2.le.1) then
c     vecteur colonne
         m=isign(mn1,m1)
         if(m.ge.0) goto 90
         if(mn2.ne.mn3) then
            call error(15)
            return
         endif
      else
c     vecteur ligne
         if (m3.gt.1.or.m2.gt.1) then
c             matrix(:)=vector
              if(mn2.ne.mn3) then
              call error(15)
              return
              endif
            istk(il1)=1
            istk(il1+1)=m3
            istk(il1+2)=n3
            istk(il1+3)=it2
            call dcopy((it2+1)*mn2,stk(l2),1,stk(l1),1)
            lstk(top+1)=l1+mn2*(it2+1)
            return
         endif
         n=isign(mn1,m1)
         l2=l1
         
         if(n.ge.0) goto 90
         if(mn2.ne.mn3) then
            call error(15)
            return
         endif
      endif
      go to 90
c     
c     m est une matrice
c     arg4(arg1,arg2)=arg3
 88   mk=m4
      nk=n4
      itk=it4
      lk=l4
      md=m3
      nd=n3
      itd=it3
      ld=l3
c     
      if(it1+it2.ne.0) then
         call error(21)
         return
      endif
c
      if(m1.ge.0) m=mn1
      if(m2.ge.0) n=mn2
      if(mn4.eq.0.and.(m.lt.0.or.n.lt.0)) then
         call error(15)
         return
      endif
      if(m.ge.0.and.n.ge.0) goto 90
      if(m.lt.0.and.m4.ne.m3) then
         call error(15)
         return
      endif
      if(n.lt.0.and.n4.ne.n3) then
         call error(15)
         return
      endif
      go to 90
c     
 90   mr=mk
      if (m .ge. 0) then
         if(m.ne.md) then
            call error(15)
            return
         endif
         do 91 i = 1, m
            ls=int(stk(l1+i-1))
            if(ls.le.0) then
               call error(21)
               return
            endif
            mr=max(mr,ls)
 91      continue
      else
         mr = max(mr,md)
      endif
      mr = max(mr,md)
c     
      nr=nk
      if (n .ge. 0) then 
         if(n.ne.nd) then
            call error(15)
            return
         endif
         do 93 i = 1, n
            ls=int(stk(l2+i-1))
            if(ls.le.0) then
               call error(21)
               return
            endif
            nr=max(nr,ls)
 93      continue
      else
         nr = max(nr,nd)
      endif
      nr = max(nr,nd)
c     
c     scalar matrix case
      mnk=mk*nk
      mnd=md*nd
      mnr=mr*nr
      itr=max(itk,itd)
      if(mnr*(itr+1).ne.mnk*(itk+1) ) then
         lr=lw
         err = lr + mnr*(itr+1) - lstk(bot)
         if (err .gt. 0) then
            call error(17)
            return
         endif
c     initialisation de r a 0
         call dset(mnr*(itr+1),0.0d+0,stk(lr),1)
c     on reecrit a dans R
         if(mnk.ge.1) then
            call dmcopy(stk(lk),mk,stk(lr),mr,mk,nk)
            if(itk.eq.1) then
               call dmcopy(stk(lk+mnk),mk,stk(lr+mnr),mr,mk,nk)
            endif
         endif
      else
         lr=lk
      endif
c     
c     on implante les coeff de M dans R
      do 99 j = 1, nd
         do 98 i = 1, md
            li = i-1
            if (m .gt. 0) li =   int(stk(l1+i-1)) - 1
            lj = j-1
            if (n .gt. 0) lj =  int(stk(l2+j-1)) - 1
            ll = lr+li+lj*mr
            ls = ld+i-1+(j-1)*md
            stk(ll) = stk(ls)
            if(itd.eq.1) stk(ll+mnr)=stk(ls+mnd)
            if(itr.eq.1.and.itd.eq.0) stk(ll+mnr)=0.0d+0
 98      continue
 99   continue
c     
      if(lr.ne.lk) then
         call dcopy(mnr*(itr+1),stk(lr),1,stk(l1),1)
         istk(il1)=1
         istk(il1+1)=mr
         istk(il1+2)=nr
         istk(il1+3)=itr
         lstk(top+1)=l1+mnr*(itr+1)
      else
c     la matrice a ete modifie sur place 
         k=istk(iadr(lstk(top0))+2)
         istk(il1)=-1
         istk(il1+1)=-1
         istk(il1+2)=k
         lstk(top+1)=lstk(top)+3
      endif
      goto 999

c     
c     *. /. \.
 120  fin=-fin
      top=top+1
      goto 999
c     
 130  continue
      if(fin.eq.61) then
         fin=-fin
         top=top+1
         goto 999
      endif
c     comparaisons
      if(mn1.eq.1.and.mn2.gt.1) then
         err=lw+mn2*(it1+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dset(mn2,stk(l1),stk(lw),1)
         if(it1.eq.1) call dset(mn2,stk(l1+1),stk(lw+mn2),1)
         l1=lw
         mn1=mn2
         m1=m2
         n1=n2
         istk(il1+1)=m1
         istk(il1+2)=n1
      elseif(mn2.eq.1.and.mn1.gt.1) then
         err=lw+mn1*(it2+1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dset(mn1,stk(l2),stk(lw),1)
         if(it1.eq.1) call dset(mn1,stk(l2+1),stk(lw+mn1),1)
         l2=lw
         mn2=mn1
         m2=m1
         n2=n1
      elseif(mn2.eq.0.and.mn1.eq.0) then
         if(op.eq.equal.or.op.eq.less+great) then
            istk(il1)=4
            istk(il1+1)=1
            istk(il1+2)=1
            istk(il1+3)=1
            if(op.eq.less+great) istk(il1+3)=0
            lstk(top+1)=sadr(il1+4)
            goto 999
         else
            call error(60)
            return
         endif

      endif
      if(n1.ne.n2.or.m1.ne.m2) then
         if(op.eq.equal.or.op.eq.less+great) then
            istk(il1)=4
            istk(il1+1)=1
            istk(il1+2)=1
            istk(il1+3)=0
            if(op.eq.less+great) istk(il1+3)=1
            lstk(top+1)=sadr(il1+4)
         else
            call error(60)
            return
         endif
      else if(max(it1,it2).eq.1) then
         if(op.ne.equal.and.op.ne.less+great) then
            call error(57)
            return
         endif
         itrue=1
         if(op.eq.less+great) itrue=0
         istk(il1)=4
         do 131 i=0,mn1-1
            e1r=stk(l1+i)
            e2r=stk(l2+i)
            e1i=0.0d+0
            e2i=0.0d+0
            if(it1.eq.1) e1i=stk(l1+mn1+i)
            if(it2.eq.1) e2i=stk(l2+mn2+i)
            if(e1r.eq.e2r.and.e1i.eq.e2i) then
               istk(il1+3+i)=itrue
            else
               istk(il1+3+i)=1-itrue
            endif
 131     continue
         lstk(top+1)=sadr(il1+3+mn1)
      else
         istk(il1)=4
         if(mn1.eq.0) then
            if(op.ne.equal.and.op.ne.less+great) then
               call error(57)
            else
               istk(il1+1)=1
               istk(il1+2)=1
               istk(il1+3)=1
               if(op.ne.equal) istk(il1+3)=0
               lstk(top+1)=sadr(il1+4)
            endif
            return
         endif
         do 132 i=0,mn1-1
            e1=stk(l1+i)
            e2=stk(l2+i)
            if(  (op.eq.equal   .and. e1.eq.e2) .or.
     &           (op.eq.less+great    .and. e1.ne.e2) .or.
     &           (op.eq.less          .and. e1.lt.e2) .or.
     &           (op.eq.great         .and. e1.gt.e2) .or.
     &           (op.eq.(less+equal)  .and. e1.le.e2) .or.
     &           (op.eq.(great+equal) .and. e1.ge.e2) ) then
               istk(il1+3+i)=1
            else
               istk(il1+3+i)=0
            endif
 132     continue
         lstk(top+1)=sadr(il1+3+mn1)
      endif
c     
      
 999  return
      end
