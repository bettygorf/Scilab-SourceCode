      subroutine polelm
c     ====================================================================
c     
c     evaluation des fonctions polynomiales elementaires
c     
c     ====================================================================
c     
      INCLUDE '../stack.h'
      integer iadr, sadr
c     
      double precision t,sr,si,eps,er,epsa,epsr
      integer id(4),blank,v2,vol,volr,racine,coeff,ipb(6)
      logical roots
      integer fail 
c
      integer simpmd
      common/csimp/ simpmd
c
      data blank/40/,racine/27/,coeff/12/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      
c     
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' polelm '//buf(1:4))
      endif
c     
c     functions/fin
c     1       2       3       4       5       6       7       8
c     poly     roots  degre   coeff   eval    pdiv  simp     sum
c     
c     9       10      11      12      13      14     15        16
c     prod    diag    triu     tril    bezout sfact simp_mode  varn
c     
c     17
c     cleanp
c     
      if(top+lhs-rhs.ge.bot) then
         call error(18)
         return
      endif
      if(fin.ne.15.and.rhs.le.0) then
         call error(39)
         return
      endif
      if(fin.eq.15) goto 120
c     
      eps=stk(leps)
c     
      il1=iadr(lstk(top+1-rhs))
      if(istk(il1).gt.2) then
         if(fin.ne.7) then
            err=1
            call error(54)
            return
         endif
      endif
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      l1=sadr(il1+4)
      mn1=m1*n1
      if(istk(il1).eq.2) then
         id1=il1+8
         l1=sadr(id1+mn1+1)
         vol=istk(id1+mn1)-1
         call icopy(4,istk(il1+4),1,id,1)
      else
         id(1)=0
      endif
      lw=lstk(top+1)
c     
      goto (10,20,30,40,50,60,73,55,58,25,27,27,70,83,120,100,110) fin
c     
c     poly
c     
 10   continue
      if(lhs.ne.1) then
         call error(41)
         return
      endif
      roots=.true.
      if(rhs.ne.3) goto 11
      il=iadr(lstk(top))
      rhs=rhs-1
      top=top-1
      if(istk(il).ne.10) then
         err=rhs
         call error(55)
         return
      endif
      il=il+5+istk(il+1)*istk(il+2)
      if(abs(istk(il)).eq.racine) goto 11
      roots=.false.
      if(abs(istk(il)).ne.coeff) then
         err=rhs
         call error(36)
         return
      endif
 11   if(rhs.ne.2) then
         call error(39)
         return
      endif
c     nom de la variable muette
      il=iadr(lstk(top))
      if(istk(il).ne.10) then
         err=2
         call error(55)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=2
         call error(89)
         return
      endif
      n=istk(il+5)-1
      do 12 i=1,4
         id(i)=blank
         if(i.le.n) id(i)=istk(il+5+i)
 12   continue
c     premier argument
      top=top-1
      if(.not.roots) goto 17
 13   if(mn1.eq.1.or.m1.ne.n1) goto 14
c     polynome caracteristique,decomposition spectrale de la matrice
      fin=3
      rhs=1
      if(it1.eq.0) call matdsr
      if(it1.eq.1) call matdsc
      if(err.gt.0) return
      mn1=m1
      m1=1
      n1=mn1
      it1=istk(il1+3)
      lw=l1+mn1*(it1+1)
      goto 13
c     polynome defini par ses racines
 14   ild=il1+8
      lc=sadr(ild+2)
      lr=lc+(mn1+1)*(it1+1)
      err=lr+mn1*(it1+1)-lstk(bot)
      call dcopy(mn1*(it1+1),stk(l1),1,stk(lr),1)
      istk(il1)=2
      istk(il1+1)=1
      istk(il1+2)=1
      call icopy(4,id,1,istk(il1+4),1)
      istk(ild)=1
      istk(ild+1)=mn1+2
      lstk(top+1)=lc+(mn1+1)*(it1+1)
      if(it1.eq.1) goto 15
      call dprxc(mn1,stk(lr),stk(lc))
      goto 999
 15   call wprxc(mn1,stk(lr),stk(lr+mn1),stk(lc),stk(lc+mn1+1))
      do 16 i=1,mn1+1
         l=lc-1+i
         if( stk(l)+stk(l+mn1+1).ne.stk(l)) goto 999
 16   continue
      istk(il1+3)=0
      lstk(top+1)=lc+mn1+1
      goto 999
c     polynome defini par ses coefficients
 17   if(istk(il1).ne.1) then
         err=1
         call error(53)
         return
      endif
      if(n1.ne.1.and.m1.ne.1) then
         err=1
         call error(89)
         return
      endif
      if(mn1.le.0) then
         call error(42)
         return
      endif
      lr=sadr(il1+10)
      call dcopy(mn1*(it1+1),stk(l1),-1,stk(lr),-1)
      istk(il1)=2
      istk(il1+1)=1
      istk(il1+2)=1
      call icopy(4,id,1,istk(il1+4),1)
      istk(il1+8)=1
      istk(il1+9)=1+mn1
      lstk(top+1)=lr+mn1*(it1+1)
      goto 999
c     
c     roots : racines,
c     
 20   continue
      if(lhs.ne.1) then
         call error(41)
         return
      endif
      if(istk(il1).gt.2) then
         err=1
         call error(54)
         return
      endif
      if(istk(il1+1)*istk(il1+2).ne.1) then
         err=1
         call error(43)
         return
      endif
      if(istk(il1).lt.2) goto 24
      lc=l1
      l1=sadr(il1+4)
      n=vol
 21   n=n-1
      if(n.lt.0) goto 24
      t=abs(stk(lc+n))
      if(it1.eq.1) t=t+abs(stk(lc+n+vol))
      if(t.eq.0.0d+0) goto 21
      if(it1.eq.0) then
         err=l1+2*n-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dcopy(n+1,stk(lc),1,stk(l1),1)
         call dtild(n+1,stk(l1),1)
         call rpoly(stk(l1),n,stk(l1),stk(l1+n),fail)
         if(fail.eq.1) then
            call error(24)
            return
         elseif(fail.eq.2) then
            call error(74)
            return
         elseif(fail.eq.3) then
            call error(75)
            return

         endif
         istk(il1)=1
         istk(il1+1)=n
         istk(il1+2)=1
         if(n.eq.0) istk(il1+2)=0
         istk(il1+3)=1
         lstk(top+1)=l1+2*n
         goto 999
      endif
      lw=lw+n*n*(it1+1)
      err=lw+n*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      sr=stk(lc+n)
      call dcopy(n,stk(lc),-1,stk(lw),1)
      if(it1.eq.1) goto 22
      call dscal(n,-1.0d+0/sr,stk(lw),1)
      goto 23
 22   si=stk(lc+vol+n)
      t=sr*sr+si*si
      sr=-sr/t
      si=si/t
      call dcopy(n,stk(lc+vol),-1,stk(lw+n),1)
      call wscal(n,sr,si,stk(lw),stk(lw+n),1)
 23   call dset(n*n*(it1+1),0.0d+0,stk(l1),1)
      call dset(n-1,1.0d+0,stk(l1+n),n+1)
      call dcopy(n,stk(lw),1,stk(l1),1)
      if(it1.eq.1) call dcopy(n,stk(lw+n),1,stk(l1+n*n),1)
      lstk(top+1)=l1+n*n*(it1+1)
      istk(il1)=1
      istk(il1+1)=n
      istk(il1+2)=n
      fin=3
      fun=2
c     *call* matds(r c)
      goto 999
c     polynome de degre 0
 24   istk(il1)=1
      istk(il1+1)=0
      istk(il1+2)=0
      lstk(top+1)=sadr(il1+4)
      goto 999
c     
c     diag
 25   kdiag=0
      if(rhs.eq.1) goto 26
      il=iadr(lstk(top))
      if(istk(il).ne.1) then
         err=2
         call error(53)
         return
      endif
      if(istk(il+3).ne.0) then
         err=2
         call error(52)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=2
         call error(89)
         return
      endif
      kdiag=int(stk(sadr(il+4)))
      top=top-1
      lw=lstk(top+1)
 26   idr=iadr(lw)
      if(m1.eq.1.or.n1.eq.1) then
         m1=mn1
         n1=0
         err=sadr(idr+mn1*(mn1+abs(kdiag)))-lstk(bot)
      else
         err=sadr(idr+min(n1,m1))-lstk(bot)
      endif
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mpdiag(istk(id1),m1,n1,kdiag,istk(idr),mr,nr)
      if(nr.le.0.or.mr.le.0) then
         istk(il1)=1
         istk(il1+1)=0
         istk(il1+2)=0
         istk(il1+3)=0
         lstk(top+1)=sadr(il1+4)
         goto 999
      endif
      lr=sadr(idr+mr*nr+1)
      volr=istk(idr)
      err=lr+volr*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if (it1.eq.0) call dmpins(stk(l1),istk(id1),mn1,1,stk,1,0,0,
     1     stk(lr),istk(idr),mr,nr)
      if(it1.eq.1) call wmpins(stk(l1),stk(l1+vol),istk(id1),mn1,1,
     1     stk,stk,1,0,0,stk(lr),stk(lr+volr),istk(idr),mr,nr)
      istk(il1+1)=mr
      istk(il1+2)=nr
      call icopy(mr*nr+1,istk(idr),1,istk(id1),1)
      l1=sadr(id1+mr*nr+1)
      call dcopy(volr*(it1+1),stk(lr),1,stk(l1),1)
      lstk(top+1)=l1+volr*(it1+1)
      goto 999
c     
c     triu tril
c     
 27   kdiag=0
      job=1
      if(fin.eq.12) job=0
      if(rhs.eq.1) goto 28
      il=iadr(lstk(top))
      if(istk(il).ne.1) then
         err=2
         call error(53)
         return
      endif
      if(istk(il+3).ne.0) then
         err=2
         call error(52)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=2
         call error(89)
         return
      endif
      kdiag=int(stk(sadr(il+4)))
      top=top-1
      lw=lstk(top+1)
 28   idr=iadr(lw)
      lr=sadr(idr+mn1+1)
      err=lr-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mptri(istk(id1),m1,n1,kdiag,istk(idr),job)
      volr=istk(idr)
      err=lr+volr*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if (it1.eq.0) call dmpins(stk(l1),istk(id1),m1,n1,stk,1,0,0,
     1     stk(lr),istk(idr),m1,n1)
      if(it1.eq.1) call wmpins(stk(l1),stk(l1+vol),istk(id1),m1,n1,
     1     stk,stk,1,0,0,stk(lr),stk(lr+volr),istk(idr),m1,n1)
      istk(il1+1)=m1
      istk(il1+2)=n1
      call icopy(mn1+1,istk(idr),1,istk(id1),1)
      l1=sadr(id1+mn1+1)
      call dcopy(volr*(it1+1),stk(lr),1,stk(l1),1)
      lstk(top+1)=l1+volr*(it1+1)
      goto 999
c     
c     degre
c     
 30   continue
      if(lhs.ne.1) then
         call error(41)
         return
      endif
      l=sadr(il1+4)
      if(mn1.eq.0) return
      if(istk(il1).ne.2) goto 33
      do 31 k=1,mn1
         stk(l1-1+k)=dble(istk(id1+k)-istk(id1+k-1)-1)
 31   continue
      call dcopy(mn1,stk(l1),1,stk(l),1)
 32   lstk(top+1)=l+mn1
      istk(il1)=1
      istk(il1+3)=0
      goto 999
 33   continue
      if(istk(il1).ne.1) goto 34
      if(err.gt.0) return
      call dset(mn1,0.0d+0,stk(l),1)
      goto 32
 34   fun=15
      fin=5
      return
c     
c     coeff
 40   continue
      if(istk(il1).ne.2) goto 48
c     
      lr=lstk(top+1)
      if(rhs.ne.1) goto 45
      mx=0
      do 41 ij=1,mn1
         nij=istk(id1+ij)-istk(id1+ij-1)
         if(nij.gt.mx) mx=nij
 41   continue
      v2=mn1*mx
      err=lr+v2*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dset(v2*(it1+1),0.0d+0,stk(lr),1)
      do 42 ij=1,mn1
         nij=istk(id1+ij)-istk(id1+ij-1)
         lij=l1-1+istk(id1+ij-1)
         call dcopy(nij,stk(lij),1,stk(lr-1+ij),mn1)
         if(it1.eq.1) then
            call dcopy(nij,stk(lij+vol),1,stk(lr+v2-1+ij),mn1)
         endif
 42   continue
      l=sadr(il1+4)
      call dcopy(v2*(it1+1),stk(lr),1,stk(l),1)
      istk(il1)=1
      istk(il1+2)=n1*mx
      lstk(top+1)=l+v2*(it1+1)
      goto 999
 45   ilv=iadr(lstk(top))
      if(istk(ilv).ne.1) then
         err=2
         call error(53)
         return
      endif
      if(istk(ilv+3).ne.0) then
         err=2
         call error(52)
         return
      endif
      if(istk(ilv+1).ne.1.and.istk(ilv+2).ne.1) then
         err=2
         call error(89)
         return
      endif
      nv=istk(ilv+1)*istk(ilv+2)
      lv=sadr(ilv+4)
      err=lr+mn1*nv*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dset(mn1*nv*(it1+1),0.0d+0,stk(lr),1)
      do 46 ij=1,mn1
         nij=istk(id1+ij)-istk(id1+ij-1)
         lij=l1-1+istk(id1+ij-1)
         do 47 k=1,nv
            mv=int(stk(lv-1+k))
            if(mv.ge.nij) goto 47
            stk(lr+ij-1+(k-1)*mn1)=stk(lij+mv)
            if(it1.ne.0) stk(lr+ij-1+(k-1+nv)*mn1)=stk(lij+mv+vol)
 47      continue
 46   continue
      top=top-1
      l=sadr(il1+4)
      call dcopy(mn1*nv*(it1+1),stk(lr),1,stk(l),1)
      istk(il1)=1
      istk(il1+1)=m1
      istk(il1+2)=n1*nv
      lstk(top+1)=l+mn1*nv*(it1+1)
      goto 999
c     
 48   if(istk(il1).ne.1) then
         err=1
         call error(53)
         return
      endif
      if(rhs.eq.1) goto 999
      il=iadr(lstk(top))
      top=top-1
      n=int(stk(sadr(il+4)))
      if(n.eq.0) goto 999
      istk(il1+3)=0
      call dset(mn1,0.0d+0,stk(l1),1)
      lstk(top+1)=l1+mn1
      goto 999
c     
c     eval
 50   continue
      goto 999
c     
c     sum
 55   istk(il1+1)=1
      istk(il1+2)=1
      maxd=0
      do 56 i=1,mn1
         m=istk(id1+i)-istk(id1-1+i)
         if(m.gt.maxd) maxd=m
 56   continue
      err=lw+maxd*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dset(maxd*(it1+1),0.0d+0,stk(lw),1)
      do 57 i=1,mn1
         li=l1-1+istk(id1-1+i)
         n=istk(id1+i)-istk(id1-1+i)
         call dadd(n,stk(li),1,stk(lw),1)
         if(it1.eq.1) call dadd(n,stk(li+vol),1,stk(lw+maxd),1)
 57   continue
      istk(il1+9)=1+maxd
      l1=sadr(il1+10)
      call dcopy(maxd*(it1+1),stk(lw),1,stk(l1),1)
      lstk(top+1)=l1+maxd*(it1+1)
      goto 999
c     
c     prod
 58   istk(il1+1)=1
      istk(il1+2)=1
      maxd=istk(id1+mn1)-mn1
      err=lw+maxd*(it1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      stk(lw)=1.0d+0
      if(it1.eq.1) stk(lw+maxd)=0.0d+0
      m=0
      do 59 i=1,mn1
         n=istk(id1+i)-istk(id1+i-1)-1
         li=l1-1+istk(id1+i-1)
         if(it1.eq.0) call dpmul1(stk(li),n,stk(lw),m,stk(lw))
         if(it1.eq.1) call wpmul1(stk(li),stk(li+vol),n,stk(lw),
     1        stk(lw+maxd),m,stk(lw),stk(lw+maxd))
         m=m+n
 59   continue
      istk(id1+1)=1+maxd
      l=sadr(id1+2)
      call dcopy(maxd*(it1+1),stk(lw),1,stk(l),1)
      lstk(top+1)=l+maxd*(it1+1)
      goto 999
c     
c     pdiv
 60   continue
c     denominateur
      if(lhs.gt.2) then
         call error(41)
         return
      endif
      ild=iadr(lstk(top))
      if(istk(ild).gt.2) then
         err=2
         call error(54)
         return
      endif
      nd=istk(ild+1)*istk(ild+2)
      if(nd.ne.1) then
         err=2
         call error(89)
         return
      endif
      itd=istk(ild+3)
      if(istk(ild).eq.1) then
         ld=sadr(ild+4)
         nd=0
         if (id(1).eq.0) then
            err=2
            call error(54)
            return
         endif 
      else
         if(id(1).eq.0) call icopy(4,istk(ild+4),1,id,1)
         do 61 i=1,4
            if(id(i).ne.istk(ild+3+i)) then
               call error(43)
               return
            endif
 61      continue
         nd=istk(ild+9)-2
         ld=sadr(ild+10)
      endif
c     test degre du denominateur
      v2=istk(ild+9)-1
 64   continue
      if(itd.eq.0) then
         if(stk(ld+nd).ne.0.0d+0) goto 65
      else
         if(abs(stk(ld+nd))+abs(stk(ld+v2+nd)).ne.0.0d+0) goto 65
      endif
      nd=nd-1
      if(nd.lt.0) then
         call error(27)
         return
      endif
      goto 64
c     
 65   if(mn1.ne.1) then
         err=1
         call error(89)
         return
      endif
      it1=istk(il1+3)
      if(istk(il1).eq.1) then
         nn=0
      else
         nn=istk(id1+1)-2
      endif
c     
      if(nn.lt.nd) then
c        . No division to perform
         if(lhs.eq.2) then
            istk(ild)=1
            ld=sadr(ild+4)
            stk(ld)=0.0d+0
            lstk(top+1)=ld+1
         else
            top=top-1
            istk(il1)=1
            stk(l1)=0.0d+0
            lstk(top+1)=l1+1
         endif
         goto 999
      endif
c
      if(it1.eq.0) then
         if (itd.eq.0) then
            call dpodiv(stk(l1),stk(ld),nn,nd)
         else
            l1i=lw
            lw=l1i+nn+1
            err=lw-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            ldi=ld+v2
            call dset(nn+1,0.0d0,stk(l1i),1)
            call wpodiv(stk(l1),stk(l1i),stk(ld),stk(ldi),nn,nd,ierr)
         endif
      else
         l1i=l1+nn+1
         if (itd.eq.0) then
            ldi=lw
            lw=ldi+nd+1
            err=lw-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call dset(nd+1,0.0d0,stk(ldi),1)
            call wpodiv(stk(l1),stk(l1i),stk(ld),stk(ldi),nn,nd,ierr)
         else
            ldi=ld+v2
            call wpodiv(stk(l1),stk(l1i),stk(ld),stk(ldi),nn,nd,ierr)
         endif
      endif
c     
      itr=max(it1,itd)
      nq=nn-nd

      if(lhs.eq.1) then
c     .  only q is returned
         top=top-1
c     .  set type
         istk(il1+3)=itr
c     .  set length
         istk(il1+9)=nq+2
c     .  install real and imaginary part
         call dcopy(nq+1,stk(l1+nd),1,stk(l1),1)
         if(itr.eq.1) call dcopy(nq+1,stk(l1i+nd),1,stk(l1+nq+1),1)
      else
c     .  computes remainder degree
         nr=nd
 66      nr=nr-1
         if(nr.lt.0) goto 67
         if (itr.eq.0) then
            if(stk(l1+nr).eq.0.0d+0) goto 66
         else
            if(stk(l1+nr).eq.0.0d+0.and.stk(l1i+nr).eq.0.0d+0) goto 66
         endif
 67      continue

c
         if(itr.eq.0) then
c     .     real result
            if(nr.gt.0) then
c     .        remainder is a polynomial
               istk(id1+1)=nr+2
               lstk(top)=l1+(nr+1)
            else
c     .        remainder is a scalar
               istk(il1)=1
               istk(il1+1)=1
               istk(il1+2)=1
               lr=sadr(il1+4)
               stk(lr)=stk(l1)
c????               stk(lr+1)=stk(l1i)
               lstk(top)=lr+1
            endif
            ilq=iadr(lstk(top))
            lq=sadr(ilq+10)
            inc=1 
            if (l1+nd.lt.lq) inc=-1
            call dcopy(nq+1,stk(l1+nd),inc,stk(lq),inc)
            if(nr.lt.0) stk(lr)=0.0d+0
            istk(ilq)=2
            istk(ilq+1)=1
            istk(ilq+2)=1
            istk(ilq+3)=0
            call icopy(4,id,1,istk(ilq+4),1)
            idq=ilq+8
            istk(idq)=1
            istk(idq+1)=nq+2
            lstk(top+1)=lq+nq+1
            goto 999
         else
c     .     complex result
c     .     preserve quotient coeff
            lqs=lw
            lw=lqs+sadr(10)+(nq+1)*2
            err=lw-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            call dcopy(nq+1,stk(l1+nd),1,stk(lqs),1)
            call dcopy(nq+1,stk(l1i+nd),1,stk(lqs+nq+1),1)

c     .     set remainder
            if(nr.ge.0) then
               istk(il1+3)=1
               call dcopy(nr+1,stk(l1i),1,stk(l1+nr+1),1)
               istk(id1+1)=nr+2
               lstk(top)=l1+(nr+1)*2
            else
               istk(il1+3)=0
               stk(l1)=0.0d0
               istk(id1+1)=2
               lstk(top)=l1+1
            endif
c     .     set quotient
            ilq=iadr(lstk(top))
            istk(ilq)=2
            istk(ilq+1)=1
            istk(ilq+2)=1
            istk(ilq+3)=1
            call icopy(4,id,1,istk(ilq+4),1)
            idq=ilq+8
            istk(idq)=1
            istk(idq+1)=nq+2
            lq=sadr(ilq+10)
            call dcopy(2*(nq+1),stk(lqs),1,stk(lq),1)
            lstk(top+1)=lq+(nq+1)*2
         endif
      endif
      goto 999
c     
c     bezout
 70   continue
      if(rhs.ne.2) then 
         call error(39)
         return
      endif
      if(lhs.ne.2.and.lhs.ne.3) then
         call error(41)
         return
      endif
      ilb=iadr(lstk(top))
      if(istk(ilb).ne.2) then
         err=2
         call error(54)
         return
      endif
      nb=istk(ilb+1)*istk(ilb+2)
      if(nb.ne.1)then
         err=2
         call error(89)
         return
      endif
      nb=istk(ilb+9)-2
      lb=sadr(ilb+9)
c     
      if(mn1.ne.1) then
         err=1
         call error(89)
         return
      endif
      na=vol-1
c     
      lf=lstk(top+1)
      lw=lf+2*(na+nb)+min(na,nb)+3
      n0=max(na,nb)+1
      err=lw+10*n0+3*n0*n0-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call recbez(stk(l1),na,stk(lb),nb,stk(lf),ipb,stk(lw),er)
c     pgcd
      np=ipb(2)-ipb(1)-1
      istk(il1+9)=2+np
      call dcopy(np+1,stk(lf+ipb(1)-1),1,stk(l1),1)
      lstk(top)=l1+np+1
c     matrice q 
      il=iadr(lstk(top))
      istk(il)=2
      istk(il+1)=2
      istk(il+2)=2
      istk(il+3)=0
      call icopy(4,istk(il1+4),1,istk(il+4),1)
      il=il+8
      istk(il)=1
      l=sadr(il+5)
      do 71 i=1,4
         ii=i+1
         istk(il+1)=istk(il)+ipb(ii+1)-ipb(ii)
         call dcopy(istk(il+1)-istk(il),stk(lf+ipb(ii)-1),1,stk(l),1)
         l=l+istk(il+1)-istk(il)
         il=il+1
 71   continue
      lstk(top+1)=l
      if(lhs.eq.3) then
c     retour de l'erreur
         top=top+1
         il=iadr(lstk(top))
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         l=sadr(il+4)
         stk(l)=er
         lstk(top+1)=l+1
      endif
      goto 999
c     
c     simp
c     
 73   continue

      lw=lstk(top+1)
      if(rhs.eq.1) then
         if(lhs.ne.1) then 
            call error(41)
            return
         endif
c     -compat istk(il1).ne.15 retained for list/tlist compatibility
         if(istk(il1).ne.15.and.istk(il1).ne.16) then
            err=1
            call error(90)
            return
         endif
         if(istk(il1+1).ne.4) then
            err=1
            call error(90)
            return
         endif
         ll=sadr(il1+7)
         ill=iadr(ll)
         if(istk(ill).ne.10) then
            err=1
            call error(90)
            return
         endif
         if(abs(istk(ill+5+istk(ill+1)*istk(ill+2))).ne.27) then
            err=1
            call error(90)
            return
         endif
         l0=ll+istk(il1+3)-1
         ila=iadr(l0)
         ilb=iadr(ll+istk(il1+4)-1)
         if(istk(ila).gt.2) then 
            err=1
            call error(90)
            return
         endif
         if(istk(ilb).gt.2) then 
            err=1
            call error(90)
            return
         endif
      else
         if(rhs.ne.2) then 
            call error(39)
            return
         endif
         if(lhs.ne.2) then 
            call error(41)
            return
         endif
         l0=lstk(top-1)
         ila=il1
         ilb=iadr(lstk(top))
         if(istk(ila).gt.2) then 
            err=1
            call error(54)
            return
         endif
         if(istk(ilb).gt.2) then 
            err=2
            call error(54)
            return
         endif
      endif
c     
      mna=istk(ila+1)*istk(ila+2)
      if(istk(ilb+1)*istk(ilb+2).ne.mna)then
         call error(60)
         return
      endif
      if(istk(ila+3).ne.0.or.istk(ilb+3).ne.0.or.simpmd.eq.0) then 
         return
      endif
c     
      if(istk(ila).eq.1)then
         ida=iadr(lw)
         lw=sadr(ida+mna+1)
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         do 74 i=1,mna+1
            istk(ida+i-1)=i
 74      continue
         la=sadr(ila+4)
      else
         ida=ila+8
         la=sadr(ida+mna+1)
      endif
c     
      if(istk(ilb).eq.1) then
         idb=iadr(lw)
         lw=sadr(idb+mna+1)
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         do 75 i=1,mna+1
            istk(idb+i-1)=i
 75      continue
         lb=sadr(ilb+4)
      else
         idb=ilb+8
         lb=sadr(idb+mna+1)
      endif
c     
      na=0
      nb=0
      do 76 i=1,mna
         na=max(na,istk(ida+i)-istk(ida-1+i))
         nb=max(nb,istk(idb+i)-istk(idb-1+i))
 76   continue
c     
      lar=la
      lbr=lb
      la1=la
      lb1=lb
      do 79 i=1,mna
         na=istk(ida+i)-istk(ida-1+i)-1
         nb=istk(idb+i)-istk(idb-1+i)-1
         ierr=lstk(bot)-lw
         call  dpsimp(stk(la),na,stk(lb),nb,stk(la1),nnum,
     $        stk(lb1),nden,stk(lw),ierr)
         if(ierr.eq.1) then
            call error(27)
            return
         elseif(ierr.eq.2) then
            call msgs(43,i)
         endif
         la=la+na+1
         lb=lb+nb+1
         la1=la1+nnum
         lb1=lb1+nden
         istk(ida-1+i)=nnum
         istk(idb-1+i)=nden
 79   continue
      ma=1
      mb=1
      do 80 i=1,mna+1
         na=istk(ida-1+i)
         nb=istk(idb-1+i)
         istk(ida-1+i)=ma
         istk(idb-1+i)=mb
         ma=ma+na
         mb=mb+nb
 80   continue
      if(lhs.eq.2) then
         lstk(top)=lar+istk(ida+mna)-1
         
         il=iadr(lstk(top))
      else
         istk(il1+4)=istk(il1+3)+lar+istk(ida+mna)-l0-1
         l0=lar+istk(ida+mna)-1
         il=iadr(l0)
      endif
      if(istk(ilb).eq.2) then
c     b matrice de polynome
         call icopy(9+mna,istk(ilb),1,istk(il),1)
         l=sadr(il+9+mna)
         call dcopy(istk(il+8+mna),stk(lbr),1,stk(l),1)
         l=l+istk(il+8+mna)-1
      else
c     b matrice de scalaires
         call icopy(4,istk(ilb),1,istk(il),1)
         l=sadr(il+4)
         call dcopy(mna,stk(lbr),1,stk(l),1)
         l=l+mna
      endif
      if(lhs.eq.1) then
c     on recopie le 4ieme champ de la liste
         mb=istk(il1+6)-istk(il1+5)
         call dcopy(mb,stk(ll+istk(il1+5)-1),1,stk(l),1)
         istk(il1+5)=istk(il1+4)+l-l0
         istk(il1+6)=istk(il1+5)+mb
         l=l+mb
      endif
      lstk(top+1)=l
      goto 999
c     
c     sfact
c     
 83   continue
      if(lhs.ne.1) then
         call error(41)
         return
      endif
      if(it1.ne.0) then
         err=1
         call error(52)
         return
      endif
      maxit=100
      if(mn1.ne.1) goto 86
      n1=istk(id1+1)-2
      if (2*int(n1/2).ne.n1) then
         call error(88)
         return
      endif
      n=1+n1/2
      do 81 i=0,n-1
         if(stk(l1+i).ne.stk(l1+n1-i)) then
            call error(88)
            return
         endif
 81   continue
      lw=lstk(top+1)
      err=lw+6*n-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      
      call sfact1(stk(l1),n-1,stk(lw),maxit,ierr)
      if(ierr.eq.2) then
         write(buf,82) n-1
 82      format('No real solution: degree ',i2,' entry is negative!')
         call error(999)
         return
      else if(ierr.eq.1) then
         call error(24)
         return
      else if(ierr.lt.0) then
c     convergence incomplete
         write(buf(1:4),'(i3)') ierr
         call msgs(22,0)
      endif
      lstk(top+1)=l1+n
      istk(id1+1)=n+1
      goto 999
c     cas multivariable
 86   continue
      if(m1.ne.n1) then
         err=1
         call error(20)
         return
      endif
c     conversion en un polnynome matriciel
      n1=0
      do 87 i=1,mn1
         n1=max(n1,istk(id1+i)-istk(id1+i-1))
 87   continue
c     
      n1=1+(n1-1)/2
      l2=lstk(top+1)
      lw=l2+mn1*n1
      err=lw+sadr((n1+1)*m1*((n1+1)*m1)+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c     
      do 88 i=1,mn1
         nij=istk(id1+i)-istk(id1-1+i)-1
         lij=l1-1+istk(id1-1+i)
         mij=2+nij-n1
         l2ij=l2-1+i
         call dset(n1,0.0d+0,stk(l2ij),mn1)
         if(mij.gt.0) call dcopy(mij,stk(lij+n1-1),1,stk(l2ij),mn1)
 88   continue
c     
      maxit=maxit+n1
      call sfact2(stk(l2),m1,n1-1,stk(lw),maxit,ierr)
      if(ierr.lt.0) then
         call error(24)
         return
      endif
      if(ierr.gt.0) then
         call error(88)
         return
      endif
c     passage du polynome matriciel a la matrice de polynomes
      do 89 i=1,mn1
         istk(id1+i)=1+n1*i
         call dcopy(n1,stk(l2-1+i),mn1,stk(l1),1)
         l1=l1+n1
 89   continue
      lstk(top+1)=l1
      goto 999
c     
c     varn
 100  continue
      if(lhs.ne.1) then
         call error(1)
         return
      endif
      if(rhs.ne.1) goto 105
      if(istk(il1).ne.2.and.istk(il1).ne.3) then
         err=1
         call error(54)
         return
      endif
c     extraction du nom de la variable muette
      istk(il1)=10
      istk(il1+1)=1
      istk(il1+2)=1
      istk(il1+3)=0
      call icopy(4,istk(il1+4),-1,istk(il1+6),-1)
      istk(il1+4)=1
      istk(il1+5)=5
      lstk(top+1)=sadr(il1+10)
      goto 999
 105  if(rhs.ne.2) then
         call error(39)
         return
      endif
c     chgt de la variable muette
      il=iadr(lstk(top))
      if(istk(il).ne.10) then
         err=2
         call error(55)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=2
         call error(36)
         return
      endif
      nc=istk(il+5)-1
      if(istk(il1).eq.1) goto 106
      call icopy(max(4,nc),istk(il+6),1,istk(il1+4),1)
      if(nc.lt.4) call iset(4-nc,blank,istk(il1+4+nc),1)
 106  top=top-1
      goto 999
c     
c     cleanp  
 110  continue
      if (rhs.eq.3) then
c     clean(p,epsa,epsr)
         iler=iadr(lstk(top))
         ler=sadr(iler+4)
         ilea=iadr(lstk(top-1))
         lea=sadr(ilea+4)
         epsr=stk(ler)
         epsa=stk(lea)
         top=top-2
      else if (rhs.eq.2) then
c     clean(p,epsa)
         ilea=iadr(lstk(top))
         lea=sadr(ilea+4)
         top=top-1
         epsr=1.d-10
         epsa=stk(lea)
      else if(rhs.eq.1) then
         epsr=1.d-10
         epsa=1.d-10
      endif
      id2=iadr(lstk(top+1))
      err=sadr(id2+mn1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(it1.eq.0) then
         call dmpcle(stk(l1),istk(id1),m1,n1,istk(id2),epsr,epsa)
         lstk(top+1)=l1+istk(id1+m1*n1)-1
      else
         call wmpcle(stk(l1),stk(l1+vol),istk(id1),m1,n1,
     &        istk(id2),epsr,epsa)
         lstk(top+1)=l1+(istk(id1+m1*n1)-1)*2
      endif
      goto 999
c
c     simp_mode
 120  continue
      if(rhs.gt.1) then
         call error(39)
         return
      endif
      if(rhs.le.0) then
         top=top+1
         il=iadr(lstk(top))
         istk(il)=4
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=simpmd
         lstk(top+1)=sadr(il+4)
         goto 999
      else
         il=iadr(lstk(top))
         if(istk(il).ne.4) then
            err=1
            call error(208)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(36)
            return
         endif
         simpmd=istk(il+3)
         istk(il)=0
         lstk(top+1)=sadr(il+1)
      endif
      goto 999
c     
 999  continue
      return
      end
