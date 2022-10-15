      subroutine matlu
c ====================================================================
c
c     evaluate functions involving gaussian elimination
c
c ====================================================================
c
      include '../stack.h'
c
      double precision dtr(2),dti(2),eps,sr,si,rcond,t
c
      logical luf,lus,hot,fresh,tsmu
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
c
c
c     fonction / fin
c -2   -1    1    2     3    4   5    6    7     8        9     10
c  \    /   inv  det  rcond  lu      chol  rref lufact lusolve ludel
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matlu '//buf(1:4))
      endif
c
      if(rstk(pt).eq.906) goto 310
c
      if(rhs.le.0) then
         call error(39)
         return
      endif
c
      eps=stk(leps)
c

      go to (20,10,99,30,40,50,60,99,80,85,86,86,86),fin+3
c
 10   continue
c     matrix right division, a/a2
      il=iadr(lstk(top-rhs+1))
      if (istk(il).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      mn=m*n
      nn=n*n
c
      top=top-1
      il2=iadr(lstk(top+1))
      if(istk(il2).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      itr=max(it,it2)
      l2=sadr(il2+4)
      mn2=m2*n2
c
      if (m2 .ne. n2) then
         call error(20)
         return
      endif
      if (mn .eq. 1) go to 16
      if (mn2.le.0) then
         err=2
         call error(45)
         return
      endif
      if (mn.le.0) then
         lstk(top+1)=l
         return
      endif
      if (n .ne. n2) then
         call error(11)
         return
      endif
      l3=max(l+(itr+1)*mn,l2)+(it2+1)*mn2
      err=l3+n2*(it2+1)+(n2+1)/2-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
      if(it.eq.1.or.it2.eq.0) goto 9
      inc=1
      if(l2.le.l+2*mn) inc=-1
      call dcopy(mn2*(it2+1),stk(l2),inc,stk(l+2*mn),inc)
      call dcopy(mn,0.0d+0,0,stk(l+mn),1)
      istk(il+3)=1
      l2=l+2*mn
      lstk(top+1)=l2
    9 continue
      if(it2.eq.1) call wlslv(stk(l2),stk(l2+mn2),m2,n2,
     $     stk(l),stk(l+mn),m,m,stk(l3),rcond,err,2)
      if(it2.eq.0) call dlslv(stk(l2),m2,n2,stk(l),m,m,stk(l3),
     $     rcond,err,2)
      if(it2.eq.0.and.it.eq.1) call dlslv(stk(l2),m2,n2,stk(l+mn),m,m,
     $     stk(l3),rcond,err,-2)
      if (rcond.eq.0.0d+0) then
         call error(19)
         return
      endif
      t = 1.0d+0 + rcond
      if (t.eq.1.0d+0 .and. fun.ne.21) then
         write(buf(1:13),'(1pd13.4)') rcond
         call msgs(5,0)
      endif
      if (t.eq.1.0d+0 .and. fun.eq.21) then
         write(buf(1:13),'(1pd13.4)') rcond
         call msgs(6,0)
      endif
c
c     check for imaginary roundoff in matrix functions
      if(it2.eq.0.and.it.eq.0) goto 99
      do 13 i=1,nn
         sr=abs(stk(l+i-1))
         si=abs(stk(l+mn+i-1))
         if(si.gt.eps*sr) goto 99
 13   continue
      istk(il+3)=0
      lstk(top+1)=l+mn
      go to 99
c
 16   sr = stk(l)
      si=0.0d+0
      if(it.eq.1) si = stk(l+1)
      n = n2
      m = n
      mn=m*n
      nn=n*n
      istk(il+1)=n
      istk(il+2)=n
      istk(il+3)=it2
      lstk(top+1)=l+nn*(it2+1)
      call dcopy(nn*(it2+1),stk(l2),1,stk(l),1)
      it2=it
      it=istk(il+3)
      go to 31
c
 20   continue
c     matrix left division a backslash a2
      il=iadr(lstk(top-rhs+1))
      if (istk(il).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      mn=m*n
      nn=n*n

      top=top-1
      il2=iadr(lstk(top+1))
      if(istk(il2).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      l2=sadr(il2+4)
      mn2=m2*n2
c
      if (m .ne. n) then
         call error(20)
         return
      endif
      if (mn2 .eq. 1) go to 26
      if (mn2.le.0) then
         call error(45)
         return
      endif
      if (mn.le.0) then
         lstk(top+1)=l
         return
      endif
      if (m2 .ne. n) then
         call error(12)
         return
      endif
      l3=l2+(max(it,it2)+1)*mn2
      err = l3+n*(it+1)+sadr(n) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
c
      if(it.eq.1) then
         if(it2.eq.0) call dcopy(mn2,0.0d+0,0,stk(l2+mn2),1)
         call wlslv(stk(l),stk(l+mn),m,n,stk(l2),stk(l2+mn2),
     &        m2,n2,stk(l3),rcond,err,1)
      else
         call dlslv(stk(l),m,n,stk(l2),m2,n2*(it2+1),stk(l3),
     &        rcond,err,1)
      endif
c
      if (rcond .eq. 0.0d+0) then
         call error(19)
         return
      endif
      t = 1.0d+0 + rcond
c
      if (t .eq. 1.0d+0) then
         write(buf(1:13),'(1pd13.4)') rcond
         call msgs(5,0)
      endif
c
      istk(il+2)=n2
      it=max(it,it2)
      istk(il+3)=it
      lstk(top+1)=l+mn2*(it+1)
      call dcopy(mn2*(it+1),stk(l2),1,stk(l),1)
      go to 99
 26   sr = stk(l2)
      si=0.0d+0
      if(it2.eq.1) si = stk(l2+1)
      go to 31
c
 30   continue
c     inv
c
      il=iadr(lstk(top-rhs+1))
      if (istk(il).ne.1) then
         call cvname(id,'g_inv   ',0)
         goto 300
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      mn=m*n
      nn=n*n

 31   if (m .ne. n) then
         call error(20)
         return
      endif
      if(mn.le.0) return
      l3 = l + nn*(it+1)
      err = l3+n*(it+1)+sadr(n) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      if(it.eq.1) call wlslv(stk(l),stk(l+nn),n,n,sr,si,0,0,stk(l3),
     $     rcond,err,3)
      if(it.eq.0) call dlslv(stk(l),n,n,sr,0,0,stk(l3),rcond,err,3)
      if (rcond .eq. 0.0d+0) then
         call error(19)
         return
      endif
      t = 1.0d+0 + rcond
      if (t .eq. 1.0d+0) then
         write(buf(1:13),'(1pd13.4)') rcond
c       matrice est quasi singuliere ou mal normalisee')
         call msgs(5,0)
      endif
      if(fin.ge.0) goto 99
      goto(33,34,35) (it+2*it2)
 33   call dscal(nn*(it+1),sr,stk(l),1)
      istk(il+3)=it
      lstk(top+1)=l+m*n*(it+1)
      goto 99
 34   call dcopy(nn,stk(l),1,stk(l+nn),1)
      call dscal(nn,sr,stk(l),1)
      call dscal(nn,si,stk(l+nn),1)
      istk(il+3)=1
      lstk(top+1)=l+2*nn
      goto 99
 35   call wscal(nn,sr,si,stk(l),stk(l+nn),1)
      go to 99
c
 40   continue
c     det
c
      il=iadr(lstk(top-rhs+1))
      if (istk(il).ne.1) then
         call cvname(id,'g_det   ',0)
         goto 300
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      mn=m*n
      nn=n*n

      if (m .ne. n) then
         call error(20)
         return
      endif
      if(mn.le.0) goto 47
      ilp=iadr(l+mn*(it+1))
      lw=sadr(ilp+n)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(it.eq.1) call wgefa(stk(l),stk(l+mn),m,n,istk(ilp),info)
      if(it.eq.1) call wgedi(stk(l),stk(l+mn),m,n,istk(ilp),dtr,dti,
     &     sr,si,10)
      if(it.eq.0) call dgefa(stk(l),m,n,istk(ilp),info)
      if(it.eq.0) call dgedi(stk(l),m,n,istk(ilp),dtr,sr,10)
      k = int(dtr(2))
      ka = abs(k)+2
      t = 1.0d+0
      do 41 i = 1, ka
         t = t/10.0d+0
         if (t .eq. 0.0d+0) go to 42
 41   continue
      stk(l) = dtr(1)*10.0d+0**k
      if(it.eq.1) stk(l+1) = dti(1)*10.0d+0**k
      istk(il+1)=1
      istk(il+2)=1
      lstk(top+1)=l+it+1
      go to 99
 42   if (it .eq. 0) then
         write(buf(1:11),'(f7.4,i4)') dtr(1),k
         call basout(io,wte,' det = '//buf(1:7)//' * 10**'//buf(8:11))
      else
         write(buf(1:18),'(2f7.4,i4)') dtr(1),dti(2),k
         call basout(io,wte,' det = ('//buf(1:7)//' + '//buf(8:14)//
     &        ') * 10**'//buf(15:18))
      endif
      stk(l) = dtr(1)
      stk(l+2) = dti(1)
      stk(l+1) = dtr(2)
      stk(l+3) = 0.0d+0
      istk(il+1)=1
      istk(il+2)=2
      lstk(top+1)=l+2*(it+1)
      go to 99
c cas de la matrice vide
   47 continue
      istk(il+1)=1
      istk(il+2)=1
      lstk(top+1)=l+it+1
      stk(l)=0.0d+0
      if (it.eq.1) stk(l+1)=0.0d+0
      go to 99
c
 50   continue
c     rcond
c
      il=iadr(lstk(top-rhs+1))
      if (istk(il).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      mn=m*n
      nn=n*n

      if (m .ne. n) then
         call error(20)
         return
      endif
      if(mn.le.0) then
         call error(45)
         return
      endif
      l3 = l + nn*(it+1)
      err = l3+n*(it+1)+sadr(n) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      if(it.eq.1) call wlslv(stk(l),stk(l+mn),m,n,sr,si,0,0,stk(l3),
     $     rcond,ierr,0)
      if(it.eq.0) call dlslv(stk(l),m,n,sr,0,0,stk(l3),rcond,ierr,0)
      stk(l) = rcond
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      lstk(top+1)=l+1
      if (lhs .eq. 1) go to 99
      l = l + 1
      call dcopy(n*(it+1),stk(l3+sadr(n)),1,stk(l),1)
      top=top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=n
      istk(il+2)=1
      istk(il+3)=it
      lstk(top+1)=l+n*(it+1)
      go to 99
c
 60   continue
c     lu
c
      il=iadr(lstk(top-rhs+1))
      if (istk(il).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      mn=m*n
      nn=n*n

      if (m .ne. n) then
         call error(20)
         return
      endif
      if(lhs.ne.2) then
         call error(41)
         return
      endif
      if (top+2 .ge. bot) then
         call error(18)
         return
      endif
      if(mn.le.0) goto 67
      top = top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=n
      istk(il+2)=n
      istk(il+3)=it
      l2=sadr(il+4)
      lstk(top+1)=l2+nn*(it+1)
      ilp=iadr(lstk(top+1))
      err = sadr(ilp+n) -lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
c
      if(it.eq.1) call wgefa(stk(l),stk(l+mn),m,n,istk(ilp),info)
      if(it.eq.0) call dgefa(stk(l),m,n,istk(ilp),info)
      do 62 kb = 1, n
         k = n+1-kb
         ll=l+(k-1)*n
         lu=l2+(k-1)*n
         call dcopy(k,stk(ll),1,stk(lu),1)
         if(k.eq.n) goto 61
         call dcopy(n-k,0.0d+0,0,stk(lu+k),1)
         call dscal(n-k,-1.0d+0,stk(ll+k),1)
 61      call dcopy(k,0.0d+0,0,stk(ll),1)
         stk(ll+k-1)=1.0d+0
         i = istk(ilp+k-1)
         if (i .eq. k) go to 62
         li = l+i-1+(k-1)*n
         lk = l+k-1+(k-1)*n
         call dswap(n-k+1,stk(li),n,stk(lk),n)
 62   continue
      if(it.eq.0) goto 99
      l=l+nn
      l2=l2+nn
      do 64 kb = 1, n
         k = n+1-kb
         ll=l+(k-1)*n
         lu=l2+(k-1)*n
         call dcopy(k,stk(ll),1,stk(lu),1)
         if(k.eq.n) goto 63
         call dcopy(n-k,0.0d+0,0,stk(lu+k),1)
         call dscal(n-k,-1.0d+0,stk(ll+k),1)
 63      call dcopy(k,0.0d+0,0,stk(ll),1)
         i = istk(ilp+k-1)
         if (i .eq. k) go to 64
         li = l+i-1+(k-1)*n
         lk = l+k-1+(k-1)*n
         call dswap(n-k+1,stk(li),n,stk(lk),n)
 64   continue
      go to 99
c cas de la matrice vide
 67   continue
      istk(il+1)=0
      istk(il+2)=0
      istk(il+3)=0
      top=top+1
      il=il+4
      istk(il)=1
      istk(il+1)=0
      istk(il+2)=0
      istk(il+3)=0
      lstk(top+1)=sadr(il+4)
      go to 99
c
 80   continue
c     cholesky
      il=iadr(lstk(top-rhs+1))
      if (istk(il).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      mn=m*n
      nn=n*n

      if (m .ne. n) then
         call error(20)
         return
      endif
      if(mn.le.0) return
      if(it.eq.1) call wpofa(stk(l),stk(l+mn),m,n,err)
      if(it.eq.0) call dpofa(stk(l),m,n,err)
      if (err .ne. 0) then
         call error(29)
         return
      endif
      do 81 j = 1, n
         ll = l+j+(j-1)*m
         call dcopy(m-j,0.0d+0,0,stk(ll),1)
         if(it.eq.1) call dcopy(m-j,0.0d+0,0,stk(ll+mn),1)
 81   continue
      go to 99
c     rref
 85   if(rhs.gt.1) then
         call error(42)
         return
      endif
      if(mn.le.0) return
      if(it.eq.1) call wrref(stk(l),stk(l+m*n),m,m,n,eps)
      if(it.eq.0) call drref(stk(l),m,m,n,eps)
      go to 99
c
c
c     lufact et lusolve
 86   continue

      eps=stk(leps)
      hot=.false.
      fresh=.false.
      tsmu=.false.
      luf=fin.eq.8
      lus=fin.eq.9
      rhs = max(0,rhs)
c
      if (fin .eq. 8) then
c 
c SCILAB function : lufact1
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable val (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if ((istk(il1+2) .ne. 1).and. (istk(il1+1).ne.1)) then
          err = 1
          call error(89)
          return
        endif
        n1 = istk(il1+1)
        l1 = sadr(il1+4)
c       checking variable rc (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        n2 = istk(il2+1)
        m2 = istk(il2+2)
        if (m2 .ne. 2) then
          err = 2
          call error(89)
          return
        endif
        l2 = sadr(il2+4)
c       checking variable n (number 3)
c       
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 1) then
          err = 3
          call error(53)
          return
        endif
        if (istk(il3+1)*istk(il3+2) .ne. 1) then
          err = 3
          call error(89)
          return
        endif
        l3 = sadr(il3+4)
c     
c       cross variable size checking
c     
        call entier(n2*m2,stk(l2),istk(iadr(l2)))
        call entier(1,stk(l3),istk(iadr(l3)))
        lw5=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call lufact1(stk(l1),istk(iadr(l2)),istk(iadr(l3)),n1,stk(lw5))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: fmat
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw5),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 9) then
c 
c SCILAB function : lusolve1
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 2) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable fmat (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable b (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+2) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        n2 = istk(il2+1)
        l2 = sadr(il2+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        lw3=lw
        lw=lw+n2
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call lusolve1(istk(iadr(l1)),stk(l2),stk(lw3))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: x
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+n2-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=n2
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(n2,stk(lw3),1,stk(lw),1)
        lw=lw+n2
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 10) then
c 
c SCILAB function : ludel1
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 1) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking variable fmat (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c     
        call entier(1,stk(l1),istk(iadr(l1)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call ludel1(istk(iadr(l1)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c       no output variable
        top=top+1
        il=iadr(l0)
        istk(il)=0
        lstk(top+1)=l0+1
        return
      endif
c
c  fonctions matricielles gerees par l'appel a une macro
c
 300  fin=0
      call funs(id)
      if(err.gt.0) return
      if(fun.gt.0) then
         buf='primitive call'
         call error(9999)
         return
      endif
      if(fin.eq.0) then
         call putid(ids(1,pt+1),id)
         call error(4)
         if(err.gt.0) return
      endif
      pt=pt+1
      fin=lstk(fin)
      rstk(pt)=906
      icall=5
      fun=0
c     *call*  macro
      return
 310  continue
      pt=pt-1
      goto 99

 99   return
      end
