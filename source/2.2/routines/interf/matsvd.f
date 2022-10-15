      subroutine matsvd
c ================================== ( Inria    ) =============
c     evaluate functions involving singular value decomposition
c
c =============================================================
      include '../stack.h'
c
      logical fro,inf
      double precision p,s,t,tol,eps
      double precision pythag,wnrm2,wasum
      double precision ddot,dnrm2,dasum,dlamch
      integer rang,froben,infini
      integer iadr,sadr
      data froben/15/,infini/18/
c
c    fin     1        2        3        4        5      6
c           svd      pinv     cond     norm     rank   sva
c
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matsvd '//buf(1:4))
      endif
c
      if(rhs.le.0) then
         call error(39)
         return
      endif
      if(top+lhs-rhs+1.ge.bot) then
         call error(18)
         return
      endif
c
      il=iadr(lstk(top+1-rhs))
      if(istk(il).ne.1) then
         err=1
         call error(53)
         return
      endif
c
      tol = -1.0d+0
      if ((rhs.eq.2).and.(fin.le.2.or.fin.ge.5)) then
      il1=iadr(lstk(top))
      if(istk(il1).ne.1) then
         err=2
         call error(53)
         return
      endif
      if(istk(il1+3).ne.0) then
         err=2
         call error(52)
         return
      endif
      l1=sadr(il1+4)
      tol=stk(l1)
      top = top-1
      endif
c
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      mn = m*n
      m1=min(m+1,n)
c
      eps=stk(leps)
c
      go to (50,70,10,30,70,80), fin
c
c     cond
c
   10 continue
      if(mn.le.0) then
        k=1
        goto 78
      endif
      ld = l + mn*(it+1)
      l1 = ld + m1*(it+1)
      l2 = l1 + n*(it+1)
      err = l2+m*(it+1) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      if(it.eq.0) goto 11
      call wsvdc(stk(l),stk(l+mn),m,m,n,stk(ld),stk(ld+m1),
     1 stk(l1),stk(l1+n),t,t,1,t,t,1,stk(l2),stk(l2+m),0,ierr)
      goto 12
   11 call dsvdc(stk(l),m,m,n,stk(ld),stk(l1),t,1,t,1,stk(l2),0,ierr)
   12 continue
c 
      if (ierr.gt.1) call msgs(3,ierr)

      s = stk(ld)
      ld = ld + min(m,n) - 1
      t = stk(ld)
      if (t .eq. 0.0d+0) then
         t=dlamch('o')
      else
         t=s/t
      endif
      stk(l) = t
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      lstk(top+1)=l+1
      go to 99
c
c     vector norm
c
   30 continue
c        empty matrix
      if(mn.eq.0) then
      err=1
      call error(45)
      return
      endif
      p = 2.0d+0
      inf = .false.
      if (rhs .ne. 2) go to 32
      iln=il
      fro=.false.
      iln=iadr(lstk(top))
      top = top-1
c
      if(istk(iln).eq.1) then
         p=stk(sadr(iln+4))
      else if(istk(iln).eq.10) then
         ilc=iln+5+istk(iln+1)*istk(iln+2)
         fro = abs(istk(ilc)).eq.froben .and. mn.gt.1
         inf = abs(istk(ilc)).eq.infini .and. mn.gt.1
         if (fro) m = mn
         if (fro) n = 1
      else
         err=2
         call error(55)
         return
      endif
 32   continue
      if (m .gt. 1 .and. n .gt. 1) go to 40
      if (m*n.eq.0) then
c     empty matrix
         istk(il)=1
         istk(il+1)=0
         istk(il+2)=0
         istk(il+3)=0
         lstk(top+1)=sadr(il+4)
         return
      endif
      if(inf) goto 33
      if (p .eq. 1.0d+0) go to 36
      if (p .eq. 2.0d+0) go to 38
   33 if(it.eq.1) goto 34
      i=idamax(mn,stk(l),1)+l-1
      s=abs(stk(i))
      if( inf .or. s .eq. 0.0d+0) goto 49
   34 i=iwamax(mn,stk(l),stk(l+mn),1)+l-1
      s=abs(stk(i))+abs(stk(i+mn))
      if (inf .or. s .eq. 0.0d+0) go to 49
      t = 0.0d+0
      do 35 i = 1, mn
         ls = l+i-1
         t = t + (pythag(stk(ls),stk(ls+mn))/s)**p
   35 continue
      if (p .ne. 0.0d+0) p = 1.0d+0/p
      s = s*t**p
      go to 49
c
   36 if(it.eq.1) s = wasum(mn,stk(l),stk(l+mn),1)
      if(it.eq.0) s=dasum(mn,stk(l),1)
      go to 49
c
   38 if(it.eq.1) s= wnrm2(mn,stk(l),stk(l+mn),1)
      if(it.eq.0) s=dnrm2(mn,stk(l),1)
      go to 49
c
c     matrix norm
c
   40 if (inf) go to 43
      if (p .eq. 1.0d+0) go to 46
      if (p .ne. 2.0d+0) then
         call error(23)
         return
      endif
      ld = l + mn*(it+1)
      l1 = ld + m1*(it+1)
      l2 = l1 + n*(it+1)
      err = l2+m*(it+1) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      if(it.eq.0) goto 41
      call wsvdc(stk(l),stk(l+mn),m,m,n,stk(ld),stk(ld+m1),
     1 stk(l1),stk(l1+n),t,t,1,t,t,1,stk(l2),stk(l2+m),0,ierr)
      goto 42
   41 continue
      call dsvdc(stk(l),m,m,n,stk(ld),stk(l1),t,1,t,1,stk(l2),0,ierr)
c
   42 if (ierr.gt.1) call msgs(3,ierr)

      s = stk(ld)
      go to 49
c
   43 s = 0.0d+0
      do 45 i = 1, m
         li = l+i-1
         if(it.eq.0) t = dasum(n,stk(li),m)
         if(it.eq.1) t = wasum(n,stk(li),stk(li+mn),m)
         s = max(s,t)
   45 continue
      goto 49
   46 s=0.0d+0
      do 48 j = 1, n
         lj = l+(j-1)*m
         if(it.eq.0) t = dasum(m,stk(lj),1)
         if(it.eq.1) t = wasum(m,stk(lj),stk(lj+mn),1)
         s = max(s,t)
   48 continue
   49 stk(l) = s
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      lstk(top+1)=l+1
      go to 99
c
c     svd
c
   50 continue
      if(mn.le.0) then
c          empty matrix
c           svd([])=[]          
      if(lhs.eq.1) return 
c          [u,s,v]=svd([]) -> u=[],v=[],s=[]
      if(lhs.ge.3) then
      istk(il)=1
      istk(il+1)=0
      istk(il+2)=0
      istk(il+3)=0
      lstk(top+1)=sadr(il+4)
c
      top = top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=0
      istk(il+2)=0
      istk(il+3)=0
      lstk(top+1)=sadr(il+4)
c
      top = top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=0
      istk(il+2)=0
      istk(il+3)=0
      lstk(top+1)=sadr(il+4)
      if(lhs.eq.3) return
      top=top+1
      il=iadr(lstk(top))
      l=sadr(il+4)
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      stk(l)=0.d0
      lstk(top+1)=l+1
      return
      endif     
      endif
      if (lhs .lt. 3) go to 52
      k = m
      if (rhs .eq. 2 .and. lhs .ne. 4) k = min(m,n)
      lu=l
      ld=lu+m*k*(it+1)+sadr(5)-1
      lv=ld+k*n+sadr(5)-1
      l=lv+n*n*(it+1)
      l1=l+m*n*(it+1)
      l2=l1+n*(it+1)
      lsv=l2+m*(it+1)
c
      err = lsv+m1*(it+1) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
c
      call dcopy(m*n*(it+1),stk(lu),1,stk(l),1)
      job = 11
      if (rhs .eq. 2 .and. lhs .ne. 4) job = 21
      if(it.eq.0) call dsvdc(stk(l),m,m,n,stk(lsv),stk(l1),
     1 stk(lu),m,stk(lv),n,stk(l2),job,ierr)
      if(it.eq.1) call wsvdc(stk(l),stk(l+m*n),m,m,n,stk(lsv),
     1 stk(lsv+m1),stk(l1),stk(l1+n),stk(lu),stk(lu+m*k),m,stk(lv),
     2 stk(lv+n*n),n,stk(l2),stk(l2+m),job,ierr)
c     set matrix of singular values
c
      if (ierr.gt.1) call msgs(3,ierr)
c
      if(rhs.eq.1) tol=dble(max(m,n))*eps*stk(lsv)
      rang=0
      do 51 j = 1, n
      do 51 i = 1, k
        ll = ld+i-1+(j-1)*k
        ls = lsv+i-1
        if (i.eq.j) then
                        stk(ll) = stk(ls)
                        if(stk(ls).gt.tol) rang=i
                    else
                        stk(ll)=0.0d+0
        endif
   51 continue
c
c     set headers for lhs
      istk(il+1)=m
      istk(il+2)=k
      istk(il+3)=it
      lstk(top+1)=lu+m*k*(it+1)
c
      top = top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=k
      istk(il+2)=n
      istk(il+3)=0
      lstk(top+1)=ld+k*n
c
      top = top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=n
      istk(il+2)=n
      istk(il+3)=it
      lstk(top+1)=lv+n*n*(it+1)
      if(lhs.eq.3) goto 99
      top=top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      lr=lv+n*n*(it+1)+sadr(5)-1
      stk(lr)=dble(rang)
      lstk(top+1)=lr+1
      go to 99
c
   52 ld = l + m*n*(it+1)
      l1 = ld + m1*(it+1)
      l2 = l1 + n*2
      err = l2+m*(it+1) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      if(it.eq.0) call dsvdc(stk(l),m,m,n,stk(ld),
     $           stk(l1),t,1,t,1,stk(l2),
     $           0,ierr)
      if(it.eq.1) call wsvdc(stk(l),stk(l+m*n),m,m,n,
     1 stk(ld),stk(ld+m1),stk(l1),stk(l1+n),t,t,1,t,t,1,
     2 stk(l2),stk(l2+m),0,ierr)
c
      if (ierr.gt.1) call msgs(3,ierr)

      k = min(m,n)
      call dcopy(k,stk(ld),1,stk(l),1)
      istk(il+1)=k
      istk(il+2)=1
      istk(il+3)=0
      lstk(top+1)=l+k
      go to 99
c
c     pinv and rank
c
   70 continue
      if (mn.le.0 ) then
        if (fin.eq.2) then
c           pinv([])=[]
c           err=1
c           call error(45)
           return
        endif
        k=0
        goto 78
      endif
      lu = l + m*n*(it+1)
      ld = lu + m*m*(it+1)
      if (fin .eq. 5) ld = l + m*n*(it+1)
      lv = ld + m1*(it+1)
      l1 = lv + n*n*(it+1)
      if (fin .eq. 5) l1 = ld + n*(it+1)
      l2 = l1 + n*(it+1)
      err = l2+m*(it+1) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      if (fin .eq. 2) job = 11
      if (fin .eq. 5) job = 0
      if(it.eq.0) call dsvdc(stk(l),m,m,n,stk(ld),
     $        stk(l1),stk(lu),m,stk(lv),
     $        n,stk(l2),job,ierr)
      if(it.eq.1) call wsvdc(stk(l),stk(l+m*n),m,m,n,
     1 stk(ld),stk(ld+m1),stk(l1),stk(l1+n),
     2 stk(lu),stk(lu+m*m),m,stk(lv),stk(lv+n*n),n,
     3 stk(l2),stk(l2+m),job,ierr)
c
      if (ierr.gt.1) call msgs(3,ierr)

      if (tol .lt. 0.0d+0) tol = dble(max(m,n))*eps*stk(ld)
      mn = min(m,n)
      k = 0
      do 72 j = 1, mn
        ls = ld+j-1
        s = stk(ls)
        if (s .le. tol) go to 73
        k = j
        ll = lv+(j-1)*n
      if (fin.eq.2) call dscal(n,1.0d+0/s,stk(ll),1)
      if (fin.eq.2.and.it.eq.1) call dscal(n,1.0d+0/s,stk(ll+n*n),1)
   72 continue
   73 if (fin .eq. 5) go to 78
      do 74 j=1,m
      do 74 i=1,n
      ll=l+i-1+(j-1)*n
      l1=lv+i-1
      l2=lu+j-1
      stk(ll)=ddot(k,stk(l2),m,stk(l1),n)
   74 continue
      if(it.eq.0) goto 77
      do 76 j = 1, m
      do 76 i = 1, n
        ll = l+i-1+(j-1)*n
        l1 = lv+i-1
        l2 = lu+j-1
        stk(ll) = stk(ll)+ddot(k,stk(l2+m*m),m,stk(l1+n*n),n)
        stk(ll+m*n)=ddot(k,stk(l2),m,stk(l1+n*n),n)
     1 -ddot(k,stk(l2+m*m),m,stk(l1),n)
   76 continue
   77 continue
      istk(il+1)=n
      istk(il+2)=m
      istk(il+3)=it
      lstk(top+1)=l+m*n*(it+1)
      go to 99
   78 stk(l) = dble(k)
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      lstk(top+1)=l+1
      go to 99
c
c sva
c
   80 continue
      if(lhs.ne.3) then
         call error(41)
         return
      endif
      k=min(m,n)
      lu=l
      ld=lu+m*k*(it+1)+sadr(5)-1
      lv=ld+k*n+sadr(5)-1
      l=lv+n*n*(it+1)
      l1=l+m*n*(it+1)
      l2=l1+n*(it+1)
      lsv=l2+m*(it+1)
c
      err = lsv+m1*(it+1) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
c
      call dcopy(m*n*(it+1),stk(lu),1,stk(l),1)
      job=21
      if(it.eq.0) call dsvdc(stk(l),m,m,n,stk(lsv),stk(l1),
     1 stk(lu),m,stk(lv),n,stk(l2),job,ierr)
      if(it.eq.1) call wsvdc(stk(l),stk(l+m*n),m,m,n,stk(lsv),
     1 stk(lsv+m1),stk(l1),stk(l1+n),stk(lu),stk(lu+m*k),m,stk(lv),
     2 stk(lv+n*n),n,stk(l2),stk(l2+m),job,ierr)
      if(tol.ge.1.0d+0) goto 81
c    calcul du rang numerique
      if(rhs.eq.1) tol=dble(max(m,n))*eps*stk(lsv)
      rang=0
      do 82 j=1,k
      ls=lsv+j-1
      s=stk(ls)
      if(s.le.tol) goto 83
      rang=j
  82  continue
  81  if(tol.ge.1.0d+0) rang=int(tol)
  83  continue
c     set matrix of singular values
      ld=lu+m*rang*(it+1)+sadr(5)-1
      do 84 jb = 1, rang
      do 84 i = 1, rang
        j = rang+1-jb
        ll = ld+i-1+(j-1)*rang
        if (i.ne.j) stk(ll) = 0.0d+0
        ls = lsv+i-1
        if (i.eq.j) stk(ll) = stk(ls)
   84 continue
c
      if (ierr.gt.1) call msgs(3,ierr)
c
c     set headers for lhs
      istk(il+1)=m
      istk(il+2)=rang
      istk(il+3)=it
      lstk(top+1)=lu+m*rang*(it+1)
c
      top = top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=rang
      istk(il+2)=rang
      istk(il+3)=0
      lst=ld+n*k
      lstk(top+1)=ld+rang*rang
c
      lvn=ld+rang*rang+sadr(5)-1
      call dcopy(n*rang*(it+1),stk(lv),1,stk(lvn),1)
      top = top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=n
      istk(il+2)=rang
      istk(il+3)=it
      lstk(top+1)=lvn+n*rang*(it+1)
      go to 99
   99 return
      end
