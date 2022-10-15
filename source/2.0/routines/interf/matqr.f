      subroutine matqr
c ================================== ( Inria    ) =============
c     evaluate functions involving qr decomposition (least squares)
c ====================================================================
      include '../stack.h'
      integer iadr,sadr
c
      double precision t,tol,eps,sr,si
      integer quote,vol
      data quote/53/
c
c    fin      -2       -1       1       
c             a\a2     a/a2     qr     
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1

c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matqr '//buf(1:4))
      endif
c
      eps=stk(leps)
c
      il=iadr(lstk(top-rhs+1))
      if(istk(il).ne.1) then
         err=rhs
         call error(53)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
c
      goto (14,10,99,40) fin+3
c
c     rectangular matrix right division, a/a2
c     call  left division for a2'\a
c
   10 continue
c on interverti l'ordre de a et a2
      l1=lstk(top-1)
      l2=lstk(top)
      l3=lstk(top+1)
      ll=l1+l3-l2
      err=ll+l3-l1 - lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dcopy(l3-l1,stk(l1),-1,stk(ll),-1)
      call dcopy(l3-l2,stk(ll+l2-l1),1,stk(l1),1)
      lstk(top)=ll
      lstk(top+1)=ll+l2-l1
c transposition  a2
      lw=lstk(top+1)
      il1=iadr(lstk(top))
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      mn1=m1*n1
      l1=sadr(il1+4)
      if(mn1 .eq. 0.or.istk(il1).eq.0) goto 11
      vol=mn1*(it1+1)
      ll = lw
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
      if(it1.eq.0) goto 11
      call mtran(stk(ll+mn1),m1,stk(l1+mn1),n1,m1,n1)
      call dscal(mn1,-1.0d+0,stk(l1+mn1),1)
c
c transposition a
   11 continue
      il1=iadr(lstk(top-1))
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      mn1=m1*n1
      l1=sadr(il1+4)
      if(mn1 .eq. 0.or.istk(il1).eq.0) goto 12
      vol=mn1*(it1+1)
      ll = lw
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
      if(it1.eq.0) goto 12
      call mtran(stk(ll+mn1),m1,stk(l1+mn1),n1,m1,n1)
      call dscal(mn1,-1.0d+0,stk(l1+mn1),1)
c
   12 top=top-1
      il=iadr(lstk(top))
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l=sadr(il+4)
      go to 15
c
c     rectangular matrix left division a backslash a2
c
   14 top=top-1
   15 il2=iadr(lstk(top+1))
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      l2=sadr(il2+4)
      if (m2*n2 .gt. 1) go to 16
c     scalar divided by a matrix
        m2 = m
        n2 = m
        err = l2+m*m*(it2+1) - lstk(bot)
        if (err .gt. 0) then
           call error(17)
           return
        endif
        sr=stk(l2)
        if(it2.eq.1) si=stk(l2+1)
        call dset(m*m*(it2+1),0.0d+0,stk(l2),1)
        call dset(m,sr,stk(l2),m+1)
        if(it2.eq.1) call dset(m,si,stk(l2+m*m),m+1)
c
   16 if (m2.ne.m) then
         call error(10-fin)
         return
      endif
      it1=max(it,it2)
      nn2=max(m,n)*n2
      l3 = l2 + nn2*(it1+1)
      l4 = l3 + n*(it+1)
      ilb=iadr(l4+n*(it+1))
      err = sadr(ilb+n) - lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      if (m .ge. n) go to 23
c     on plonge a2 dans une matrice ayant des lignes de longueur n
      mn2=m*n2
      ls=l2+mn2*(it2+1)
      ll=l2+nn2*(it2+1)
      mn=n2*(it2+1)
      do 22 j=1,mn
      ll=ll-n
      ls=ls-m
      call dcopy(m,stk(ls),-1,stk(ll),-1)
   22 continue
c     factorisation qr
   23 do 24 j = 1, n
        istk(ilb+j-1) = 0
   24 continue
      if(it.eq.0) call dqrdc(stk(l),m,m,n,stk(l4),istk(ilb),stk(l3),1)
      if(it.eq.1) call wqrdc(stk(l),stk(l+m*n),m,m,n,stk(l4),
     $ stk(l4+n),istk(ilb),stk(l3),stk(l3+n),1)
c     determination du rang
      k = 0
      t = abs(stk(l))
      if(it.eq.1) t=t+abs(stk(l+m*n))
      tol = dble(max(m,n))*eps*t
      mn = min(m,n)
      do 25 j = 1, mn
        ls = l+j-1+(j-1)*m
        t = abs(stk(ls))
        if(it.eq.1) t=t+abs(stk(ls+m*n))
        if (t .gt. tol) k = j
   25 continue
      if (k .lt. mn) then
         write(buf(1:17),'(i4,1pd13.4)') k,tol
         call basout(io,wte,
     +  '  deficient rank: rank ='//buf(1:4)//' - tol ='//buf(5:17))
      endif
      mn = max(m,n)
c     resolution
      if(it.eq.1) goto 28
c a est reelle
      ls=l2
      do 27 j = 1, n2
      call dqrsl(stk(l),m,m,k,stk(l4),stk(ls),t,stk(ls),stk(ls),t,t,
     $ 100,info)
      call dset(n-k,0.0d+0,stk(ls+k),1)
      if(it2.eq.0) goto 27
      call dqrsl(stk(l),m,m,k,stk(l4),stk(ls+nn2),t,stk(ls+nn2),
     1 stk(ls+nn2),t,t,100,info)
      call dset(n-k,0.0d+0,stk(ls+nn2+k),1)
   27 ls=ls+mn
      goto 30
   28 continue
c cas a complexe
      if(it2.eq.0) call dset (nn2,0.0d+0,  stk(l2+nn2),1)
      do 29 j = 1, n2
        ls = l2+(j-1)*mn
      call wqrsl(stk(l),stk(l+m*n),m,m,k,stk(l4),stk(l4+n),stk(ls),
     $ stk(ls+nn2),t,t,stk(ls),stk(ls+nn2),stk(ls),stk(ls+nn2),
     $ t,t,t,t,100,info)
        ll = ls+k
      call dset (n-k,0.0d+0,  stk(ll),1)
      call dset (n-k,0.0d+0,  stk(ll+nn2),1)
   29 continue
c     permutations
   30 continue
      do 31 j = 1, n
        istk(ilb+j-1) = -istk(ilb+j-1)
   31 continue
      do 35 j = 1, n
        if (istk(ilb+j-1) .gt. 0) go to 35
        k = -istk(ilb+j-1)
        istk(ilb+j-1) = k
   33   continue
          if (k .eq. j) go to 34
          ls = l2+j-1
          ll = l2+k-1
          call dswap(n2,stk(ls),mn,stk(ll),mn)
          if(it1.eq.1) call dswap(n2,stk(ls+nn2),mn,stk(ll+nn2),mn)
          istk(ilb+k-1) = -istk(ilb+k-1)
          k = istk(ilb+k-1)
          go to 33
   34   continue
   35 continue
      do 36 j = 1, n2
        ls = l2+(j-1)*mn
        ll=l+(j-1)*n
        call dcopy(n,stk(ls),1,stk(ll),1)
   36 continue
      if(it1.eq.0) goto 38
      do 37 j=1,n2
      ls=l2+(j-1)*mn+mn*n2
      ll=l+n*n2+ (j-1)*n
      call dcopy(n,stk(ls),1,stk(ll),1)
   37 continue
   38 continue
      istk(il+1)=n
      istk(il+2)=n2
      istk(il+3)=it1
      lstk(top+1)=l+n*n2*(it1+1)
      rhs=1
      if (fin .eq. -1) then
                  il1=iadr(lstk(top))
                  m1=istk(il1+1)
                  n1=istk(il1+2)
                  it1=istk(il1+3)
                  mn1=m1*n1
                  l1=sadr(il1+4)
                  if(mn1 .eq. 0.or.istk(il1).eq.0) goto 99
                  vol=mn1*(it1+1)
                  ll = lstk(top+1)
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
                  if(it1.eq.0) goto 99
                  call mtran(stk(ll+mn1),m1,stk(l1+mn1),n1,m1,n1)
                  call dscal(mn1,-1.0d+0,stk(l1+mn1),1)
      endif
      go to 99
c
c     qr
   40 if(top+lhs.ge.bot) then
         call error(18)
         return
      endif
      if(rhs.eq.2) then
      il=iadr(lstk(top))
      tol=stk(sadr(il+4))
      top=top-1
      endif
c
      if(fin.eq.1 .and. (lhs.lt.2 .or. lhs.gt.4)) then
         call error(41)
         return
      endif
c
      mn=m*n
      mm=m*m
      job=0
c     implantation des resultats et tableaux de travail
      ilq=iadr(lstk(top))
      lq=l
      lstk(top+1)=lq+mm*(it+1)
c
      top=top+1
      ilr=iadr(lstk(top))
      lr=sadr(ilr+4)
      lstk(top+1)=lr+mn*(it+1)
c
      if(lhs.eq.4) then
         top=top+1
         ilrk=iadr(lstk(top))
         lrk=sadr(ilrk+4)
         lstk(top+1)=lrk+1
      endif
c
      if(lhs.ge.3) then
c     on calcule et on stocke e
         top=top+1
         nn=n*n
         job=1
         ile=iadr(lstk(top))
         le=sadr(ile+4)
         lstk(top+1)=le+nn
      endif
c
      laux=lstk(top+1)
      lw=laux+n*(it+1)
      ilb=iadr(lw+n*(it+1))
      err=sadr(ilb+n)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
c     calcul de la dcomposition qr
      call dcopy(mn*(it+1),stk(l),-1,stk(lr),-1)
      do 43 j=1,n
         istk(ilb+j-1)=0
   43 continue
      if(it.eq.0) call dqrdc(stk(lr),m,m,n,stk(laux),istk(ilb),
     &                       stk(lw),job)
      if(it.eq.1) call wqrdc(stk(lr),stk(lr+mn),m,m,n,stk(laux),
     1            stk(laux+n),istk(ilb),stk(lw),stk(lw+n),job)
c
c     affectation des resultats
c
c     affectation de q
      call dset(mm*(it+1),0.0d+0,stk(lq),1)
      call dset(m,1.0d+0,stk(lq),m+1)
      ll=lq
      do 44 j=1,m
      if(it.eq.0) call dqrsl(stk(lr),m,m,n,stk(laux),stk(ll),stk(ll),
     1            t,t,t,t,10000,info)
      if(it.eq.1) call wqrsl(stk(lr),stk(lr+mn),m,m,n,stk(laux),
     1            stk(laux+n),stk(ll),stk(ll+mm),stk(ll),stk(ll+mm),
     2            t,t,t,t,t,t,t,t,10000,info)
      ll=ll+m
   44 continue
      istk(ilq+1)=m
      istk(ilq+2)=m
      m1=min(m-1,n)
      ll=lr+1
      do 51 j=1,m1
      call dset(m-j,0.0d+0,stk(ll),1)
      if(it.eq.1) call dset(m-j,0.0d+0,stk(ll+mn),1)
      ll=ll+m+1
   51 continue
      istk(ilr)=1
      istk(ilr+1)=m
      istk(ilr+2)=n
      istk(ilr+3)=it
c
      if(lhs.eq.2) goto 99
      if(rhs.eq.2) then
c     ############# calcul du rang 
         t=abs(stk(lr))
         if(it.eq.1) t=t+abs(stk(lr+mn))
         k=0
         ls=lr
         m1=min(m,n)
         do 450 j=1,m1
            t=abs(stk(ls))
            if(it.eq.1) t=t+abs(stk(ls+mn))
            if(t.le.tol) goto 460
            k=j
            ls=ls+m+1
 450     continue
 460     if(k.eq.0) then
            err=1
            call error(45)
            return
         endif
         istk(ilrk)=1
         istk(ilrk+1)=1
         istk(ilrk+2)=1
         istk(ilrk+3)=0
         stk(lrk)=dble(k)
      endif
c     #############   affectation de e
      if((lhs.eq.3.and.rhs.eq.1).or.(lhs.eq.4.and.rhs.eq.2)) then
         call dset(nn,0.0d+0,stk(le),1)
         ll=le-1
         do 52 j=1,n
            stk(ll+istk(ilb+j-1))=1.0d+0
            ll=ll+n
 52      continue
         istk(ile)=1
         istk(ile+1)=n
         istk(ile+2)=n
         istk(ile+3)=0
      endif
      goto 99
c     
 99   return
      end
