      subroutine spelm
c     
      include '../stack.h'
c     
      double precision abstol,reltol,tv,ptr,hand
      integer iadr, sadr
      logical fact

      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' spelm '//buf(1:4))
      endif

      rhs = max(0,rhs)
c     
      if(fin.eq.1) then
         lw = lstk(top+1)
         if (lhs .ne. 1) then
            call error(41)
            return
         endif
c     creation de matrice creuse
         if(rhs.eq.1) then
c     sparse(x)
            il=iadr(lstk(top))
            if(istk(il).eq.5.or.istk(il).eq.6) return
            m=istk(il+1)
            n=istk(il+2)
            if(m*n.eq.0.or.m.eq.-1) return
            if(istk(il).eq.1) then
               it=istk(il+3)
               l=sadr(il+4)
c     
               ilr=iadr(lw)
               lw=sadr(ilr+m+m*n)

               ls=lw
               li=ls+m*n
               lw=ls+m*n*(it+1)
               
               err=lw-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
               if(it.eq.0) then
                  call dful2sp(m,n,stk(l),nel,istk(ilr),stk(ls))
               else
                  call wful2sp(m,n,stk(l),stk(l+m*n),nel,
     $                 istk(ilr),stk(ls),stk(li))
               endif
               call icopy(m+nel,istk(ilr),1,istk(il+5),1)
               l=sadr(il+5+m+nel)
               call dcopy(nel,stk(ls),1,stk(l),1)
               if(it.eq.1) call dcopy(nel,stk(li),1,stk(l+nel),1)
               istk(il)=5
               istk(il+4)=nel
               lstk(top+1)=l+nel*(it+1)
            elseif(istk(il).eq.4) then
               l=il+3
               ilr=iadr(lw)
               lw=sadr(ilr+m*n)
               err=lw-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
               call lful2sp(m,n,istk(l),nel,istk(ilr))
               call icopy(m+nel,istk(ilr),1,istk(il+5),1)
               l=sadr(il+5+m+nel)
               istk(il)=6
               istk(il+3)=0
               istk(il+4)=nel
               lstk(top+1)=l
            else
               err=1
               call error(216)
               return
            endif
            return
         endif
c     sparse([i,j],value,[m,n])
         if (rhs .ne. 3.and.rhs.ne.2) then
            call error(39)
            return
         endif
         m=-1
         n=-1
         if(rhs.eq.3) then
c     [m,n] given
            il=iadr(lstk(top))
            if(istk(il).ne.1.or.istk(il+3).ne.0) then
               err=1
               call error(52)
               return
            endif
            if(istk(il+1)*istk(il+2).ne.2) then
               err=1
               call error(60)
               return
            endif
            l=sadr(il+4)
            m=stk(l)
            n=stk(l+1)
            top=top-1
            lw=lstk(top+1)
         endif
         
         ilij=iadr(lstk(top-1))
         if(istk(ilij).ne.1.or.istk(ilij+3).ne.0) then
            err=2
            call error(52)
            return
         endif
         if(istk(ilij+1).ne.0.and.
     $        istk(ilij+1).ne.2.and.istk(ilij+2).ne.2) then
            err=2
            call error(60)
            return
         endif
         nel=istk(ilij+1)*istk(ilij+2)/2
         lij=sadr(ilij+4)
         ilij=iadr(lij)
         if(nel.gt.0) then
            call entier(nel*2,stk(lij),istk(ilij))
         endif
         if(rhs.eq.2) then
            mm=0
            do 10 i=0,nel-1
               mm=max(mm,istk(ilij+i))
 10         continue
         else
            mm=m
         endif
c     
         ilv=iadr(lstk(top))
         if(istk(ilv).ne.1.and.istk(ilv).ne.4) then
            err=2
            call error(81)
            return
         endif
         if(istk(ilv+1)*istk(ilv+2).ne.nel) then
            err=2
            call error(60)
            return
         endif
         il1=ilij
         if(istk(ilv).eq.1) then
            itv=istk(ilv+3)
            lv=sadr(ilv+4)
            lind=iadr(max(lw,sadr(il1+5+mm+nel)+nel*(itv+1)))
            liw=lind+mm+nel
            lw=sadr(liw+nel)
            err=lw-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            if(itv.eq.0) then
               call dij2sp(m,n,nel,istk(ilij),stk(lv),
     $              istk(lind),mm+nel,istk(liw),ierr)
            else
               call wij2sp(m,n,nel,stk(lij),stk(lv),stk(lv+nel),
     $              istk(lind),mm+nel,istk(liw),ierr)
            endif
            if(ierr.eq.2) then
               buf='not enough memory'
               call error(9999)
            elseif(ierr.eq.1) then
               call error(42)
               return
            endif
            top=top-1
            il1=iadr(lstk(top))
            istk(il1)=5
            istk(il1+1)=m
            istk(il1+2)=n
            istk(il1+3)=itv
            istk(il1+4)=nel
            ilr=il1+5
            l=sadr(ilr+m+nel)
            inc=1
            if(l.gt.lv) inc=-1
            call dcopy(nel*(itv+1),stk(lv),inc,stk(l),inc)
            lstk(top+1)=l+nel*(itv+1)
            inc=1
            if(ilr.gt.lind) inc=-1
            call icopy(m+nel,istk(lind),inc,istk(ilr),inc)
            return
         else
            lv=ilv+3
            lind=iadr(max(lw,sadr(il1+5+mm+nel)))
            liw=lind+mm+nel
            lw=sadr(liw+nel)
            err=lw-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call lij2sp(m,n,nel,istk(ilij),istk(lv),
     $              istk(lind),mm+nel,istk(liw),ierr)
            if(ierr.eq.2) then
               buf='not enough memory'
               call error(9999)
            elseif(ierr.eq.1) then
               call error(42)
               return
            endif
            top=top-1
            il1=iadr(lstk(top))
            istk(il1)=6
            istk(il1+1)=m
            istk(il1+2)=n
            istk(il1+3)=0
            istk(il1+4)=nel
            ilr=il1+5
            l=sadr(ilr+m+nel)
            lstk(top+1)=l
            inc=1
            if(ilr.gt.lind) inc=-1
            call icopy(m+nel,istk(lind),inc,istk(ilr),inc)
            return
         endif
      endif
      if(fin.eq.2) then
c     [ij,v,sz]=spget(sp)
         lw = lstk(top+1)
         if (rhs .ne.1) then
            call error(39)
            return
         endif
         if (lhs .gt. 3) then
            call error(41)
            return
         endif 
         il=iadr(lstk(top))
         ityp=istk(il)
         if(ityp.ne.5.and.ityp.ne.6) then
            err=1
            call error(217)
            return
         endif
         nel=istk(il+4)
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         ilr=il+5
         ilc=ilr+m
         l=sadr(ilc+nel)

         if(nel.eq.0) then
            istk(il)=1
            istk(il+1)=0
            istk(il+2)=0
            istk(il+3)=0
            lstk(top+1)=sadr(il+4)
            if(lhs.ge.2) then
               top=top+1
               il=iadr(lstk(top))
               istk(il)=1
               istk(il+1)=0
               istk(il+2)=0
               istk(il+3)=0
               lstk(top+1)=sadr(il+4)
            endif
            if(lhs.eq.3) then
               top=top+1
               il=iadr(lstk(top))
               istk(il)=1
               istk(il+1)=1
               istk(il+2)=2
               istk(il+3)=0
               l=sadr(il+4)
               stk(l)=m
               stk(l+1)=n
               lstk(top+1)=l+2
            endif
            return
         endif
         lij=sadr(il+4)
         ilv=iadr(lij+2*nel)
         if(ityp.eq.5) then
            lv=sadr(ilv+4)
            ilrs=iadr(max(lw,lv+nel*(it+1)))
         else
            ilrs=iadr(max(lw,lij+2*nel))
         endif
         lw=sadr(ilrs+m+nel)
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
c     sauvegarde
         call icopy(m+nel,istk(ilr),1,istk(ilrs),1)
c     constitution des variables de sortie
         if(ityp.eq.5) then
            if(l.ge.lv) then
               call dcopy(nel*(it+1),stk(l),1,stk(lv),1)
            else
               call dcopy(nel*(it+1),stk(l),-1,stk(lv),-1)
            endif
         endif
         call int2db(nel,istk(ilrs+m),1,stk(lij+nel),1)
         i1=0
         do 30 i=1,m
            if(istk(ilrs-1+i).ne.0) then
               tv=i
               call dset(istk(ilrs-1+i),tv,stk(lij+i1),1)
               i1=i1+istk(ilrs-1+i)
            endif
 30      continue
         istk(il)=1
         istk(il+1)=nel
         istk(il+2)=2
         istk(il+3)=0
         lstk(top+1)=lij+2*nel
         if(lhs.ge.2) then
            top=top+1
            if(ityp.eq.5) then
               il=iadr(lstk(top))
               istk(il)=1
               istk(il+1)=nel
               istk(il+2)=1
               istk(il+3)=it
               lstk(top+1)=lv+nel*(it+1)
            else
               il=iadr(lstk(top))
               istk(il)=4
               istk(il+1)=nel
               istk(il+2)=1
               call iset(nel,1,istk(il+3),1)
               lstk(top+1)=sadr(il+3+nel)
            endif
         endif
         if(lhs.eq.3) then
            top=top+1
            il=iadr(lstk(top))
            istk(il)=1
            istk(il+1)=1
            istk(il+2)=2
            istk(il+3)=0
            l=sadr(il+4)
            stk(l)=m
            stk(l+1)=n
            lstk(top+1)=l+2
         endif
         return
      endif
      if(fin.eq.3) then
c     [A]=full(sp)
         lw = lstk(top+1)
         if (rhs .ne. 1) then
            call error(39)
            return
         endif
         if (lhs .ne. 1) then
            call error(41)
            return
         endif 
         il=iadr(lstk(top))
         if(istk(il).eq.1.or.istk(il).eq.2) return
         if(istk(il).ne.5.and.istk(il).ne.6) then
            err=1
            call error(217)
            return
         endif
         nel=istk(il+4)
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         ilr=il+5
         ilc=ilr+m
         if(istk(il).eq.5) then
c     matrix of scalar
            l=sadr(ilc+nel)
            ils=iadr(max(sadr(il+4)+m*n*(it+1),lw))
            ls=sadr(ils+m+nel)
            lw=ls+nel*(it+1)
            err=lw-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(m+nel,istk(ilr),1,istk(ils),1)
            call dcopy(nel*(it+1),stk(l),1,stk(ls),1)
            istk(il)=1
            l=sadr(il+4)
            if(it.eq.0) then
               call dspful(m,n,stk(ls),nel,istk(ils),stk(l))
            else
               call wspful(m,n,stk(ls),stk(ls+nel),nel,istk(ils),
     $              stk(l),stk(l+m*n))
            endif
            lstk(top+1)=l+m*n*(it+1)
         else
c     matrix of boolean
            ils=max(il+3+m*n,iadr(lw))
            lw=sadr(ils+m+nel)
            err=lw-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call icopy(m+nel,istk(ilr),1,istk(ils),1)
            istk(il)=4
            l=il+3
            call lspful(m,n,nel,istk(ils),istk(l))
            lstk(top+1)=sadr(l+m*n)
         endif
         return
      endif
      if(fin.eq.4) then
c     SCILAB function : lufact1
c     --------------------------
         if (rhs .ne. 1.and.rhs .ne. 2) then
            call error(39)
            return
         endif
         if (lhs .gt. 2) then
            call error(41)
            return
         endif
         abstol=stk(leps)
         reltol=0.001d0
         if(rhs.eq.2) then
c     checking variable tol (number 2)
            il=iadr(lstk(top))
            if (istk(il) .ne. 1) then
               err = 1
               call error(53)
               return
            endif
            l=sadr(il+4)
            if (istk(il+2)*istk(il+1).eq.1) then
               abstol=stk(l)
            elseif (istk(il+2)*istk(il+1).eq.2) then
               abstol=stk(l)
               reltol=stk(l+1)
            else
               err = 1
               call error(89)
               return
            endif
            top=top-1
            rhs=rhs-1
         endif
         lw = lstk(top+1)
         l0 = lstk(top+1-rhs)
c     
c     checking variable sp (number 1)
c     
         il1 = iadr(lstk(top))
         if (istk(il1) .ne. 5) then
            err = 1
            call error(219)
            return
         endif
         m=istk(il1+1)
         n=istk(il1+2)
         if(m.ne.n) then
            err=1
            call error(20)
            return
         endif
         it=istk(il1+3)
         nel=istk(il1+4)
         l=sadr(il1+5+m+nel)
         if(it.ne.0) then
            call error(220)
            return
         endif

         lw5=lw
         lw=lw+1
         err=lw-lstk(bot)
         if (err .gt. 0) then
            call error(17)
            return
         endif
c     
         mx=max(m,n)
         call lufact1(stk(l),istk(il1+5),istk(il1+5+m),mx,nel,
     $        stk(lw5),abstol,reltol,nrank,ierr)
         if(ierr.gt.0) then
            buf='not enough memory'
            call error(9999)
            return
         endif        
c     
         top=top-rhs
c     
c     output variable: fmat
c     
         top=top+1
         il=iadr(lstk(top))
         istk(il)=128
         istk(il+1)=m
         istk(il+2)=n
         istk(il+3)=it
         l=sadr(il+4)
         stk(l)=stk(lw5)
         lstk(top+1)=l+1
c     
         if(lhs .eq.2) then
c     
c     output variable: rank
c     
            top=top+1
            il=iadr(lstk(top))
            istk(il)=1
            istk(il+1)=1
            istk(il+2)=1
            istk(il+3)=0
            l=sadr(il+4)
            stk(l)=nrank
            lstk(top+1)=l+1
         endif
         return
      endif
      if (fin .eq. 5) then
c     
c     SCILAB function : lusolve
c     --------------------------
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
c     checking variable fmat (number 1)
c     
         il1 = iadr(lstk(top-rhs+1))
         if (istk(il1) .eq. 128) then
            m1=istk(il1+1)
            n1=istk(il1+2)
            l1 = sadr(il1+4)
            hand=stk(l1)
            fact=.true.
         elseif(istk(il1) .eq. 5) then
            m1=istk(il1+1)
            n1=istk(il1+2)
            if(m1.ne.n1) then
               err=1
               call error(20)
               return
            endif
            it1=istk(il1+3)
            nel1=istk(il1+4)
            l1=sadr(il1+5+m1+nel1)
            if(it1.ne.0) then
               call error(220)
               return
            endif
c     
            abstol=stk(leps)
            reltol=0.001d0
            mx=max(m1,n1)
            call lufact1(stk(l1),istk(il1+5),istk(il1+5+m1),mx,nel1,
     $           hand,abstol,reltol,nrank,ierr)
            if(ierr.gt.0) then
               buf='not enough memory'
               call error(9999)
               return
            endif  
            if(nrank.ne.m1) then
               call ludel1(hand)
               call error(19)
               return
            endif
            fact=.false.
         else
            err=1
            call error(218)
            return
         endif
c     checking variable b (number 2)
c     
         il2 = iadr(lstk(top-rhs+2))
         if (istk(il2) .ne. 1.and.istk(il2) .ne. 5) then
            err=2
            call error(219)
            return
         endif
         m2 = istk(il2+1)
         n2 = istk(il2+2)
         it2 = istk(il2+3)
         if(m2.ne.m1) then
            call error(60)
            return
         endif
         l2 = sadr(il2+4)
         l2i=l2+m2*n2
c     
         if(istk(il2).eq.1) then
c     b is full
            lw3=lw
            lw3i=lw3+m2*n2
            lw=lw+m2*n2*(it2+1)
            err=lw-lstk(bot)
            if (err .gt. 0) then
               call error(17)
               return
            endif
c     
            do 40 j=0,n2-1
               call lusolve1(hand,stk(l2+j*m2),stk(lw3+j*m2))
               if(it2.eq.1) then
                  call lusolve1(hand,stk(l2i+j*m2),stk(lw3i+j*m2))
               endif
               if (err .gt. 0) return
 40         continue
            if(.not.fact) call ludel1(hand)
c     
            top=top-rhs
            lw0=lw
            mv=lw0-l0
c     
c     output variable: x
c     
            top=top+1
            il=iadr(lstk(top))
            l=sadr(il+4)
            err=l+m2*(it2+1)-lstk(bot)
            if (err .gt. 0) then
               call error(17)
               return
            endif
            istk(il)=1
            istk(il+1)=m2
            istk(il+2)=n2
            istk(il+3)=it2
            call dcopy(m2*n2*(it2+1),stk(lw3),1,stk(l),1)
            lstk(top+1)=l+m2*n2*(it2+1)
            return
         else
c     b is sparse
            buf='lusolve not yet implemented for full RHS'
            call error(999)
            return
         endif

      endif
      if (fin .eq. 6) then
c     
c     SCILAB function : ludel1
c     --------------------------
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
c     checking variable fmat (number 1)
c     
         il1 = iadr(lstk(top-rhs+1))

         if (istk(il1) .ne. 128) then
            err=1
            call error(218)
            return
         endif
         l1 = sadr(il1+4)

         call ludel1(stk(l1))
         if (err .gt. 0) return
c     
         top=top-rhs
c     no output variable
         top=top+1
         il=iadr(lstk(top))
         istk(il)=0
         lstk(top+1)=lstk(top)+1
         return
      endif

      if (fin .eq. 7) then
         lw = lstk(top+1)
         l0 = lstk(top+1-rhs)
         if (rhs .ne. 1) then
            call error(39)
            return
         endif
         if (lhs .ne. 4) then
            call error(41)
            return
         endif
c     checking variable fmat (number 1)
c     
         il1 = iadr(lstk(top-rhs+1))
         if (istk(il1) .ne. 128) then
            err=1
            call error(218)
            return
         endif
         m=istk(il1+1)
         n=istk(il1+2)
         it1=istk(il1+3)
         l1 = sadr(il1+4)
         ptr=stk(l1)
         call lusiz1(ptr,nl,nu)
         ilp=il1
         lp=sadr(ilp+5+m+m)
         lw=lp+m*(it1+1)
         lstk(top+1)=lw
c     
         top=top+1
         ill=iadr(lstk(top))
         ll=sadr(ill+5+m+nl)
         lw=ll+nl*(it1+1)
         lstk(top+1)=lw
c     
         top=top+1
         ilu=iadr(lstk(top))
         lu=sadr(ilu+5+n+nu)
         lw=lu+nu*(it1+1)
         lstk(top+1)=lw
c     
         top=top+1
         ilq=iadr(lstk(top))
         lq=sadr(ilq+5+n+n)
         lw=lq+n*(it1+1)
         lstk(top+1)=lw
c     
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         istk(ilp)=5
         istk(ilp+1)=n
         istk(ilp+2)=n
         istk(ilp+3)=it1
         istk(ilp+4)=n
c     
         istk(ill)=5
         istk(ill+1)=n
         istk(ill+2)=n
         istk(ill+3)=it1
         istk(ill+4)=nl
c     
         istk(ilu)=5
         istk(ilu+1)=n
         istk(ilu+2)=n
         istk(ilu+3)=it1
         istk(ilu+4)=nu
c     
         istk(ilq)=5
         istk(ilq+1)=n
         istk(ilq+2)=n
         istk(ilq+3)=it1
         istk(ilq+4)=n
c     
         call luget1(ptr,istk(ilp+5),stk(lp),istk(ill+5),stk(ll),
     $        istk(ilu+5),stk(lu),istk(ilq+5),stk(lq))
         
         return
      endif
c     spclean
      if(fin .eq. 8) then
         abstol=1.0d-10
         reltol=1.0d-10
         if(rhs.eq.2) then
c     checking variable tol (number 2)
            il=iadr(lstk(top))
            if (istk(il) .ne. 1) then
               err = 1
               call error(53)
               return
            endif
            l=sadr(il+4)
            if (istk(il+2)*istk(il+1).eq.1) then
               abstol=stk(l)
            elseif (istk(il+2)*istk(il+1).eq.2) then
               abstol=stk(l)
               reltol=stk(l+1)
            else
               err = 1
               call error(89)
               return
            endif
            top=top-1
            rhs=rhs-1
         endif
         lw = lstk(top+1)
         l0 = lstk(top+1-rhs)
c     
c     checking variable sp (number 1)
c     
         il1 = iadr(lstk(top))
         if (istk(il1) .ne. 5) then
            err = 1
            call error(217)
            return
         endif
         m=istk(il1+1)
         n=istk(il1+2)
         it=istk(il1+3)
         nel=istk(il1+4)
         l=sadr(il1+5+m+nel)
         if(it.ne.0) then
            call error(220)
            return
         endif
         call dspcle(m,n,stk(l),nel,istk(il1+5),stk(l),nelr,istk(il1+5),
     $        abstol,reltol)
         if(nelr.eq.nel) return
         l1=sadr(il1+5+m+nelr)
         call dcopy(nelr,stk(l),1,stk(l1),1)
         if(it.eq.1) call dcopy(nelr,stk(l+nel),1,stk(l1+nelr),1)
         istk(il1+4)=nelr
         lstk(top+1)=l1+nelr*(it+1)
         return
      endif
      if(fin.eq.9) then
c     SCILAB function : nnz
c     --------------------------
         if (rhs .ne. 1) then
            call error(39)
            return
         endif
         if (lhs .ne. 1) then
            call error(41)
            return
         endif
         lw = lstk(top+1)
         l0 = lstk(top+1-rhs)
c     
c     checking variable sp (number 1)
c     
         il1 = iadr(lstk(top))
         if (istk(il1) .eq. 5) then
            m=istk(il1+1)
            n=istk(il1+2)
            it=istk(il1+3)
            nel=istk(il1+4)
         elseif (istk(il1) .eq. 1) then
            m=istk(il1+1)
            n=istk(il1+2)
            it=istk(il1+3)
            l=sadr(il1+4)
            nel=0
            if(it.eq.0) then
               do 50 i=0,m*n-1
                  if(stk(l+i).ne.0.0d0) nel=nel+1
 50            continue
            else
               li=l+m*n
               do 51 i=0,m*n-1
                  if(abs(stk(l+i))+abs(stk(li+i)).ne.0.0d0) nel=nel+1
 51            continue
            endif
         else
            err = 1
            call error(219)
            return
         endif
         istk(il1)=1
         istk(il1+1)=1
         istk(il1+2)=1
         istk(il1+3)=0
         l=sadr(il1+4)
         stk(l)=nel
         lstk(top+1)=l+1
         return
      endif
      if(fin.eq.10.or.fin.eq.11) then
c     SCILAB function : spmax spmin
c     --------------------------
         if (rhs .lt. 1) then
            call error(39)
            return
         endif
         if (lhs .ne. 1) then
            call error(41)
            return
         endif
         lw = lstk(top+1)
         l0 = lstk(top+1-rhs)
         if(rhs.eq.1) then
            il1 = iadr(lstk(top))
            if (istk(il1) .ne. 5) then
               err=1
               call error(217)
               return
            endif
            m1=istk(il1+1)
            n1=istk(il1+2)
            it1=istk(il1+3)
            nel1=istk(il1+4)
            irc1=il1+5
            l1=sadr(irc1+m1+nel1)
            if(it1.ne.0) then
               err=1
               call error(52)
               return
            endif
            tv=0.0d0
            if(nel1.gt.0) then
               tv=stk(l1)
               if(fin.eq.10) then
                  do 60 i=0,nel1-1
                     tv=max(tv,stk(l1+i))
 60               continue
                  if(tv.lt.0.0d0.and.nel1.lt.m1*n1) tv=0.0d0
               else
                  do 61 i=0,nel1-1
                     tv=min(tv,stk(l1+i))
 61               continue
                  if(tv.gt.0.0d0.and.nel1.lt.m1*n1) tv=0.0d0
               endif
            endif
            istk(il1)=1
            istk(il1+1)=1
            istk(il1+2)=1
            istk(il1+3)=0
            l=sadr(il1+4)
            stk(l)=tv
            lstk(top+1)=l+1
            return
         endif
c     
c     checking variable sp2 (number 2)
c     
         do 65 i=1,rhs-1
            il2 = iadr(lstk(top))
            if (istk(il2) .ne. 5) then
               err=2
               call error(217)
               return
            endif

            m2=istk(il2+1)
            n2=istk(il2+2)
            it2=istk(il2+3)
            nel2=istk(il2+4)
            irc2=il2+5
            if(it2.ne.0) then
               err=2
               call error(52)
               return
            endif
            l2=sadr(irc2+m2+nel2)
c     
c     checking variable sp1 (number 1)
c     
            top=top-1
            il1 = iadr(lstk(top))
            if (istk(il1) .ne. 5) then
               err=1
               call error(217)
               return
            endif
            m1=istk(il1+1)
            n1=istk(il1+2)
            it1=istk(il1+3)
            nel1=istk(il1+4)
            irc1=il1+5
            l1=sadr(irc1+m1+nel1)

            if(it1.ne.0) then
               err=1
               call error(52)
               return
            endif
            if(m1.ne.m2.or.n1.ne.n2) then
               call error(60)
               return
            endif
            irc=iadr(lw)
            nelmx=(iadr(lstk(bot))-irc-m1-10)/3
            lc=sadr(irc+m1+nelmx)
            lw=lc+nelmx
            err=lw-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif  
            nel=nelmx
            if(fin.eq.10) then
               call dspmax(m1,n1,stk(l1),nel1,istk(irc1),stk(l2),nel2,
     $              istk(irc2),stk(lc),nel,istk(irc),ierr)
            else
               call dspmin(m1,n1,stk(l1),nel1,istk(irc1),stk(l2),nel2,
     $              istk(irc2),stk(lc),nel,istk(irc),ierr)
            endif
            if(ierr.ne.0) then
               call error(17)
               return
            endif
            istk(il1+3)=0
            istk(il1+4)=nel
            call icopy(m1+nel,istk(irc),1,istk(irc1),1)
            l1=sadr(irc1+m1+nel)
            call dcopy(nel,stk(lc),1,stk(l1),1)
            lstk(top+1)=l1+nel
 65      continue
         return
      endif
      if(fin.eq.12) then
c     SCILAB function : spmatrix(sp,mr,nr)
c     --------------------------
         if (rhs .ne. 3) then
            call error(39)
            return
         endif
         if (lhs .ne. 1) then
            call error(41)
            return
         endif
         lw = lstk(top+1)
         l0 = lstk(top+1-rhs)
c     checking variable ne
         il=iadr(lstk(top))
         if(istk(il).ne.1.or.istk(il+3).ne.0) then
            err=3
            call error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=3
            call error(60)
            return
         endif
         l=sadr(il+4)
         nr=stk(l)
c     checking variable mr
         top=top-1
         il=iadr(lstk(top))
         if(istk(il).ne.1.or.istk(il+3).ne.0) then
            err=3
            call error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=3
            call error(60)
            return
         endif
         l=sadr(il+4)
         mr=stk(l)
         top=top-1
c     checking variable sp
         il1 = iadr(lstk(top))
         if (istk(il1) .ne. 5.and.istk(il1) .ne. 6) then
            err = 1
            call error(219)
            return
         endif
         m=istk(il1+1)
         n=istk(il1+2)

         if(m*n.ne.mr*nr) then
            call error(60)
            return
         endif
         if(mr.eq.m) return

         it=istk(il1+3)
         nel=istk(il1+4)
         l=sadr(il1+5+m+nel)
         if(istk(il1).eq.5) then
            if(mr.gt.m) then
               ls=sadr(il1+5+mr+nel)
               ils=iadr(ls+nel*(it+1))
               iw=ils+nel+m
               lw=sadr(iw+3*nel)
               err=lw-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
               call dcopy(nel*(it+1),stk(l),-1,stk(ls),-1)
               call icopy(nel+m,istk(il1+5),-1,istk(ils),-1)
            else
               ls=sadr(il1+5+mr+nel)
               ils=iadr(lw)
               iw=ils+nel+m
               lw=sadr(iw+3*nel)
               err=lw-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
               call icopy(nel+m,istk(il1+5),1,istk(ils),1)
               call dcopy(nel*(it+1),stk(l),1,stk(ls),1)
            endif
            if(it.eq.0) then
               call dspmat(m,n,stk(ls),nel,istk(ils),mr,istk(il1+5),
     $              istk(iw))
            else
               call wspmat(m,n,stk(ls),stk(ls+nel),nel,istk(ils),mr,
     $              istk(il1+5),istk(iw))
            endif
            lstk(top+1)=ls+nel*(it+1)
         else
            if(mr.gt.m) then
               ils=il1+5+mr+nel
               iw=ils+nel+m
               lw=sadr(iw+3*nel)
               err=lw-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
               call icopy(nel+m,istk(il1+5),-1,istk(ils),-1)
            else
               ls=sadr(il1+5+mr+nel)
               ils=iadr(lw)
               iw=ils+nel+m
               lw=sadr(iw+3*nel)
               err=lw-lstk(bot)
               if(err.gt.0) then
                  call error(17)
                  return
               endif
               call icopy(nel+m,istk(il1+5),1,istk(ils),1)
            endif
c  was    subroutine lspmat(ma,na,nela,inda,mr,indr,iw)
c  changed to  subroutine lspmat(ma,na,a,nela,inda,mr,indr,iw)
            call lspmat(m,n,stk(ls),nel,istk(ils),mr,istk(il1+5),
     $           istk(iw))
            lstk(top+1)=sadr(il1+5+mr+nel)
         endif
         istk(il1+1)=mr
         istk(il1+2)=nr
         return
      endif
      end

