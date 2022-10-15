      subroutine sigelm
c ================================== ( Inria    ) =============
c     basic signal processing routines
      include '../stack.h'
c
      double precision adelp,adels,fact,zzi(16),zzr(16),zpi(16),zpr(16)
      double precision alpha,beta,yyy,u,y,eps,eps1,v
      double precision kappa,lambda,mu,nu
      integer ordre,lw,lt,li,lr,lo,lf,lg
      integer i,top2,tope
      integer iadr,sadr
c
      logical vect,macro,fort,arma
      integer fini,update
c
      external dgetx,dgety
      external bgetx,bgety
      character*6 namex,namey
      common/cmps/mx,my
      common/pse2/namex,namey
c
      data fini/15/,update/30/
c
c functions
c
c    0    1      2      3      4      5      6      7      8      9
c 0     ffir   fft   fiir   corr   rpem   amell  delip  remez  syredi
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' sigelm '//buf(1:4))
      endif
c
      lbot=lstk(bot)
      goto(10,20,30,40,50,60,70,80,90)fin
c
c     filtres a reponse impulsionnelle finie  c
 10   continue
c
      return
c
c fft : transformee de  fourier rapide
c ---
c
c*20  continue
c*    return
c
 20   continue
      if(rhs.lt.2) then
         call error(39)
         return
      endif
      ierr=0
      vect=.false.
      lbot=lstk(bot)
      top2=top-rhs+1
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=1
         call error(53)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      mn=m*n
      it=istk(il+3)
      lr=sadr(il+4)
      vect=m.eq.1.or.n.eq.1
      il1=iadr(lstk(top2+1))
      if(istk(il1).ne.1) then
         err=2
         call error(53)
         return
      endif
      l1=sadr(il1+4)
      isn=nint(stk(l1))
      if(isn.ne.1.and.isn.ne.-1) then
         err=2
         call error(36)
         return
      endif
      if(rhs.eq.4) goto 22
c
c fft 
c
      if(rhs.ne.2) then
         call error(39)
         return
      endif
      li=lr+mn
      libre=li+mn
      lw=lbot-libre-1
      err=libre-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(mn.eq.1) then
         top=top-1
         return
      endif
      if(it.eq.0) then
         call dset(mn,0.0d+0,stk(li),1)
         istk(il+3)=1
      endif
      if(.not.vect) goto 23
      mn2=2**int(log(dble(mn)+0.5d0)/log(2.0d+0))
      if(mn2.eq.mn) then
         if(mn.le.2**15) then
         call fft842(isn,mn,stk(lr),stk(li),err)
         if(err.gt.0) then
            buf='error in fft842'
            call error(9999)
            return
         endif
         else
         call dfft2(stk(lr),stk(li),1,mn,1,isn,ierr,stk(libre),lw)
         endif
      else
      call dfft2(stk(lr),stk(li),1,mn,1,isn,ierr,stk(libre),lw)
      endif
      goto 24
 23   continue
      call dfft2(stk(lr),stk(li),n,m,1,isn,ierr,stk(libre),lw)
      if(ierr.lt.0) goto 24
      call dfft2(stk(lr),stk(li),1,n,m,isn,ierr,stk(libre),lw)
 24   continue
      if(ierr.lt.0) then
         buf='fft fails by lack of memory'
         call error(999)
         return
      endif
      top=top-1
      lstk(top+1)=li+mn
      return
 22   continue
c     rhs=4
      ilinc=iadr(lstk(top))
      linc=sadr(ilinc+4)
      nspn=int(stk(linc))
      top=top-1
      iln=iadr(lstk(top))
      ln=sadr(iln+4)
      n=int(stk(ln))
      li=lr+mn
      err=li-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(it.eq.0) then
         err=li+mn-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dset(mn,0.0d+0,stk(li),1)
         istk(il+3)=1
      endif
      libre=li+mn
      lw=lbot-libre-1
      nseg=mn/n/nspn
      call dfft2(stk(lr),stk(li),nseg,n,nspn,isn,ierr,stk(libre),lw)
      top=top2
      lstk(top+1)=li+mn
      return
c     ========================================
c
 30   continue
c
c
      return
 40   continue
c     calcul de correlations
      tope=top
      top2=top-rhs+1
      il1=iadr(lstk(top2))
      if(istk(il1).eq.10) then
         ich=il1+5+istk(il1+1)*istk(il1+2)
         ich=istk(ich)
         if(ich.eq.fini) goto 41
         if(ich.eq.update) goto 42
      endif
      il=iadr(lstk(top))
      l=sadr(il+4)
      lag=int(stk(l))
      lcxy=lstk(top+1)
      lrxy=lcxy+lag
      lbot=lrxy+2
      err=lbot-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(rhs.eq.3) then
         top=top-1
         ily=iadr(lstk(top))
         ly=sadr(ily+4)
         ny=istk(ily+1)*istk(ily+2)
         top=top-1
         ilx=iadr(lstk(top))
         lx=sadr(ilx+4)
         nx=istk(ilx+1)*istk(ilx+2)
         if(nx.ne.ny) then
            call error(60)
            return
         endif
      endif
      if(rhs.eq.2) then
         top=top-1
         ily=iadr(lstk(top))
         ly=sadr(ily+4)
         ilx=ily
         lx=ly
         nx=istk(ily+1)*istk(ily+2)
      endif
      call tscccf(stk(lx),stk(ly),nx,stk(lcxy),stk(lrxy),lag,ierr)
      if(ierr.eq.-1) then
         buf='too many coefficients are required'
         call error(999)
         return
      endif
      istk(ilx+1)=1
      istk(ilx+2)=lag
      istk(ilx+3)=0
      call dcopy(lag,stk(lcxy),1,stk(lx),1)
      lstk(top+1)=lx+lag
      if(lhs.eq.2) then
         ly=lstk(top+1)
         ily=iadr(ly)
         istk(ily)=1
         istk(ily+1)=1
         istk(ily+2)=rhs-1
         istk(ily+3)=0
         ly=sadr(ily+4)
         call dcopy(rhs-1,stk(lrxy),1,stk(ly),1)
         top=top+1
         lstk(top+1)=ly+lag
      endif
      return
 41   continue
      macro=.false.
      fort=.false.
c     methode de la fft
      if(rhs.ne.5.and.rhs.ne.4) then
         call error(39)
         return
      endif
c     calcul de lag
      il=iadr(lstk(top))
      m=istk(il+1)
      n=istk(il+2)
      l=sadr(il+4)
      lag=int(stk(l))
      mm=2*lag
      if(rhs.eq.4.and.m*n.ne.1) then
         err=4
         call error(89)
         return
      endif
c     calcul de n
      il=iadr(lstk(top-1))
      m=istk(il+1)
      n=istk(il+2)
      kntop=top-1
      if(m*n.ne.1) then
         err=rhs-1
         call error(89)
         return
      endif
      l=sadr(il+4)
      n=int(stk(l))
c     pointeurs sur x (et y eventuellement)
      top2=top2+1
      kgxtop=top2
c 2ieme arg
      ilx=iadr(lstk(top2))
      macro=istk(ilx).eq.11.or.istk(ilx).eq.13
      fort=istk(ilx).eq.10
      if(fort) then
         nb=istk(ilx+5)-1
         nb=max(nb,6)
         call cvstr(nb,istk(ilx+6),namex,1)
      endif
      mx=top2
      my=mx
      mode=2
      if(rhs.eq.5) then
         top2=top2+1
         kgytop=top2
         ily=iadr(lstk(top2))
         if(fort) then
            if(istk(ily).ne.10) then
               err=3
               call error(55)
               return
            endif
            nb=istk(ily+5)-1
            nb=max(nb,6)
            call cvstr(nb,istk(ily+6),namey,1)
         endif
         my=top2
         mode=3
      endif
c     calculs des adresses des tableaux de travail
      lxa=lstk(top+1)
      ilw1=iadr(lxa)
      lxa=lxa+10
      lxr=lxa+mm
      lxi=lxr+mm
      lzr=lxi+mm
      lzi=lzr+sadr(mm)
      lzfin=lzi+sadr(mm)
      err=lzfin-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      top=top+1
      lstk(top+1)=lzfin
      if(fort) then
         call cmpse2(mm,n,mode,dgetx,dgety,stk(lxa),stk(lxr),
     1        stk(lxi),stk(lzr),stk(lzi),ierr)
         if(ierr.gt.0) then
            buf='fft call : needs power of two!'
            call error(999)
            return
         endif
      endif
      if(macro) then
c     external
         istk(ilw1)=mode-1
         istk(ilw1+1)=ilw1+3
         istk(ilw1+2)=ilw1+6
         istk(ilw1+3)=kgxtop
         istk(ilw1+4)=kntop
         istk(ilw1+5)=kntop
         istk(ilw1+6)=kgytop
         istk(ilw1+7)=kntop
         istk(ilw1+8)=kntop
c
         call cmpse2(mm,n,mode,bgetx,bgety,stk(lxa),stk(lxr),
     1        stk(lxi),stk(lzr),stk(lzi),ierr)
         if(ierr.gt.0) then
            buf='fft call : needs a power of 2'
            call error(999)
            return
         endif
      endif
      top=tope-rhs+1
      il=il1
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=lag
      istk(il+3)=0
      l=sadr(il+4)
      call dcopy(lag,stk(lxa),1,stk(l),1)
      lstk(top+1)=l+lag
      if(lhs.eq.1) return
      top=top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=rhs-3
      istk(il+3)=0
      l=sadr(il+4)
      call dcopy(rhs-3,stk(lxr),1,stk(l),1)
      lstk(top+1)=l+2
      return
 42   continue
      tope=top
      ichaud=0
      mode=0
c     correlations par updates
c     pointeurs sur x et y eventuellement
      top2=top2+1
      ilx=iadr(lstk(top2))
      mx=istk(ilx+1)
      nx=istk(ilx+2)
      itx=istk(ilx+3)
      mnx=mx*nx
      lx=sadr(ilx+4)
      if(itx.ne.0) then
         err=2
         call error(52)
         return
      endif
c     cross corr si on passe y
      top2=top2+1
      ily=iadr(lstk(top2))
      ny=istk(ily+1)
      my=istk(ily+2)
      mny=ny*my
      if(mny.eq.mnx) then
         mode=1
         ly=sadr(ily+4)
      endif
c     calcul de mfft
      if(mode.eq.1) top2=top2+1
      il=iadr(lstk(top2))
      mz=istk(il+1)
      nz=istk(il+2)
      it=istk(il+3)
      lzr=sadr(il+4)
      mfft=mz*nz
      lzi=lzr+mfft
      if (it.eq.0) then
         call dset(mfft,0.d0,stk(lzi),1)
      endif
c     x residuel
      if(mode.eq.1.and.rhs.eq.5) ichaud=1
      if(mode.eq.0.and.rhs.eq.4) ichaud=1
c     calculs des adresses des tableaux de travail
      lxr=lzi+mfft
      if(ichaud.eq.1) then
         top2=top2+1
         il=iadr(lstk(top2))
         mx0=istk(il+1)
         nx0=istk(il+2)
         mnx0=mx0*nx0
         nbx=mnx0
         lx0=sadr(il+4)
      endif
      if(ichaud.eq.1) then
         call dcopy(mnx0,stk(lx0),1,stk(lxr),1)
         call dset(mfft-mnx0,0.d0,stk(lxr+mnx0),1)
      endif
      lxi=lxr+mfft
      lfin=lxi+mfft
      err=lfin-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(mode.eq.1) then
         call cmpse3(mfft,mnx,mode,stk(lx),stk(ly),stk(lxr),stk(lxi),
     1        stk(lzr),stk(lzi),ierr,ichaud,nbx)
      endif
      if(mode.eq.0) then
         call cmpse3(mfft,mnx,mode,stk(lx),yyy,stk(lxr),stk(lxi),
     1        stk(lzr),stk(lzi),ierr,ichaud,nbx)
      endif
      if(ierr.gt.0) then
         buf='fft call: needs a power of 2'
         call error(999)
         return
      endif
      if(lhs.eq.1) then
         top=tope-rhs+1
         il=il1
         istk(il)=1
         istk(il+1)=mz
         istk(il+2)=nz
         istk(il+3)=1
         l=sadr(il+4)
         call dcopy(mfft,stk(lzr),1,stk(l),1)
         call dcopy(mfft,stk(lzi),1,stk(l+mfft),1)
         lstk(top+1)=l+mfft*2
         return
      endif
      if(lhs.eq.2) then
         top=tope-rhs+1
         ilw=il1
         istk(ilw)=1
         istk(ilw+1)=mz
         istk(ilw+2)=nz
         istk(ilw+3)=1
         lw=sadr(ilw+4)
         lstk(top+1)=lw+2*mfft
         top=top+1
         ilxu=iadr(lstk(top))
         lxu=sadr(ilxu+4)
         call dcopy(nbx,stk(lx+mnx-nbx),1,stk(lxr),1)
         call dcopy(mfft,stk(lzr),1,stk(lw),1)
         call dcopy(mfft,stk(lzi),1,stk(lw+mfft),1)
         call dcopy(nbx,stk(lxr),1,stk(lxu),1)
         istk(ilxu)=1
         istk(ilxu+1)=1
         istk(ilxu+2)=nbx
         istk(ilxu+3)=itx
         lstk(top+1)=lxu+nbx
      endif
      return
c
 50   continue
      arma=.false.
      top2=top-rhs+1
      il=iadr(lstk(top2))
      if(istk(il).ne.15) then
         err=1
         call error(56)
         return
      endif
      if(istk(il+1).ne.5) then
         err=1
         call error(89)
         return
      endif
      il7=il+7
      ilt=il7+istk(il+2)
      lt=sadr(ilt+4)
      lp=lt+istk(il+3)-istk(il+2)
      ilp=sadr(lp)-4
      ll=lp+istk(il+4)-istk(il+3)
      ill=sadr(ll)-4
      lphi=ll+istk(il+5)-istk(il+4)
      ilphi=sadr(lphi)-4
      lpsi=lphi+istk(il+6)-istk(il+5)
      ilpsi=sadr(ilphi)-4
      top2=top2+1
      ilu=iadr(lstk(top2))
      mnu=istk(ilu+1)*istk(ilu+2)
      if(mnu.le.1)  arma=.true.
      lu=sadr(ilu+4)
      top2=top2+1
      ily=iadr(lstk(top2))
      ly=sadr(ily+4)
      mny=istk(ily+1)*istk(ily+2)
      if(mnu.ne.mny) then
         call error(60)
         return
      endif
      if(top2.eq.top) then
         llam=lstk(top+1)
         stk(llam)=0.950d+0
         stk(llam+1)=0.990d+0
         stk(llam+2)=0.010d+0
         lk=llam+3
         stk(lk)=0.00d+0
         stk(lk+1)=0. 980d+0
         stk(lk+2)=0.020d+0
         lc=lk+3
         stk(lc)=1000.0d+0
         goto 55
      endif
      top2=top2+1
      illam=iadr(lstk(top2))
      llam=sadr(illam+4)
      if(top2.eq.top) then
         lk=lstk(top+1)
         stk(lk)=0.00d+0
         stk(lk+1)=0.980d+0
         stk(lk+2)=0.020d+0
         lc=lk+3
         stk(lc)=1000.0d+0
         goto 55
      endif
      top2=top2+1
      ilk=iadr(lstk(top2))
      lk=sadr(ilk+4)
      if(top2.eq.top) then
         lc=lk+3
         stk(lc)=1000.0d+0
         goto 55
      endif
      top2=top2+1
      ilc=iadr(lstk(top2))
      lc=sadr(ilc+4)
      ilk=iadr(lstk(top2-1))
      lk=sadr(ilk+4)
      illam=iadr(lstk(top2-2))
      llam=sadr(illam+4)
 55   continue
      mnt=istk(ilt+1)*istk(ilt+2)
      ordre=mnt/3
      lf=lc+1+2*ordre
      lg=lf+mnt
      lsta=lg+mnt
      lwork=lsta+1+ordre
      lmax=lwork+1
      err=lmax-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      lambda=stk(llam)
      alpha=stk(llam+1)
      beta=stk(llam+2)
      kappa=stk(lk)
      mu=stk(lk+1)
      nu=stk(lk+2)
      do 52 k=1,mny-1
         y=stk(ly+k)
         u=stk(lu+k-1)
         call rpem(stk(lt),stk(lp),ordre,u,y,lambda,
     1        kappa,stk(lc),ista,v,eps,eps1,mnt,
     2        stk(lphi),stk(lpsi),stk(lsta),stk(lwork),
     3        stk(lf),stk(lg),stk(ll))
         lambda=alpha*lambda+beta
         kappa=mu*kappa+nu
 52   continue
      if (lhs.eq.1) then
         top=top-rhs+1
         return
      endif
      if(lhs.eq.2) then
         top=top-rhs+2
         istk(ilu)=1
         istk(ilu+1)=1
         istk(ilu+2)=1
         istk(ilu+3)=0
         stk(lu)=v
         lstk(top+1)=lu+1
         return
      endif
      return
 60   continue
c
c     amell: calculation of the jacobi's elliptic function am(u,k)
      if(rhs.ne.2) then
         call error(39)
         return
      endif
c
      il=iadr(lstk(top))
      itv=istk(il)
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      l1=sadr(il+4)
      if(stk(l1).lt.0.or.stk(l1).gt.1)then
         err=rhs
         call error(36)
         return
      endif
      il=iadr(lstk(top-1))
      itv=istk(il)
      m=istk(il+1)
      n=istk(il+2)
      length=m*n
      it=istk(il+3)
      l=sadr(il+4)
      lw=lstk(top+1)
      err=lw+length-lstk(bot)
      if(err.gt.0)then
         call error(17)
         return
      endif
      call amell(stk(l),stk(l1),stk(lw),length)
      call dcopy(length,stk(lw),1,stk(l),1)
      top=top-1
      lstk(top+1)=l+length
      return
c
c delip
c -----
c
 70   continue
      if(rhs.ne.2.or.lhs.ne.1) then
         call error(39)
         return
      endif
      il1=iadr(lstk(top))
      itv1=istk(il1)
      if(itv1.ne.1) then
         err=2
         call error(53)
         return
      endif
      m1=istk(il1+1)
      n1=istk(il1+2)
      if(m1*n1.ne.1) then
         err=2
         call error(89)
         return
      endif
      it1=istk(il1+3)
      l1=sadr(il1+4)
      il2=iadr(lstk(top-1))
      itv2=istk(il2)
      if(itv2.ne.1) then
         err=1
         call error(53)
         return
      endif
      m2=istk(il2+1)
      n2=istk(il2+2)
      length=m2*n2
      it2=istk(il2+3)
      l2=sadr(il2+4)
      lw=lstk(top+1)
      err=lw+2*length-lstk(bot)
      if(err.gt.0)then
         call error(17)
         return
      endif
      call delip(length,stk(lw),stk(lw+length),stk(l2),stk(l1))
      top=top-1
      istk(il2)=1
      istk(il2+1)=m2
      istk(il2+2)=n2
      istk(il2+3)=1
      call dcopy(length,stk(lw),1,stk(l2),1)
      call dcopy(length,stk(lw+length),1,stk(l2+length),1)
      lstk(top+1)=l2+2*length
      return
 80   continue
c
c     remez goes here
c
      il1=iadr(lstk(top))
      itv1=istk(il1)
      m1=istk(il1+1)
      n1=istk(il1+2)
      ngrid=m1*n1
      it1=istk(il1+3)
      l1=sadr(il1+4)
      call simple(ngrid,stk(l1),stk(l1))
      il2=iadr(lstk(top-1))
      itv2=istk(il2)
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      l2=sadr(il2+4)
      call simple(ngrid,stk(l2),stk(l2))
      il3=iadr(lstk(top-2))
      itv3=istk(il3)
      m3=istk(il3+1)
      n3=istk(il3+2)
      it3=istk(il3+3)
      l3=sadr(il3+4)
      call simple(ngrid,stk(l3),stk(l3))
      il4=iadr(lstk(top-3))
      itv4=istk(il4)
      m4=istk(il4+1)
      n4=istk(il4+2)
      nc=m4*n4-2
      it4=istk(il4+3)
      l4=sadr(il4+4)
      ir4=il4+4
      call entier(nc+2,stk(l4),stk(l4))
      lw=lstk(top+1)
      err=lw+7*(nc+2)-lstk(bot)
      if(err.gt.0)then
         call error(17)
         return
      endif
      lw1=lw+nc+2
      lw2=lw1+nc+2
      lw3=lw2+nc+2
      lw4=lw3+nc+2
      lw5=lw4+nc+2
      lw6=lw5+nc+2
      call remez(ngrid,nc,stk(l4),stk(lw1),stk(lw2),stk(lw3),
     *     stk(l3),stk(l2),stk(l1),stk(lw4),
     *     stk(lw5),stk(lw6),stk(lw))
      top=top-3
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=nc+1
      istk(ilo+3)=0
      lo=sadr(ilo+4)
      call dcopy(nc+1,stk(lw),1,stk(lo),1)
      lstk(top+1)=lo+nc+1
      return
 90   continue
c
c     syredi goes here
c
      il1=iadr(lstk(top))
      itv1=istk(il1)
      m1=istk(il1+1)
      n1=istk(il1+2)
      it1=istk(il1+3)
      l1=sadr(il1+4)
      adels=stk(l1)
      il2=iadr(lstk(top-1))
      itv2=istk(il2)
      m2=istk(il2+1)
      n2=istk(il2+2)
      it2=istk(il2+3)
      l2=sadr(il2+4)
      adelp=stk(l2)
      il3=iadr(lstk(top-2))
      itv3=istk(il3)
      m3=istk(il3+1)
      n3=istk(il3+2)
      it3=istk(il3+3)
      l3=sadr(il3+4)
      il4=iadr(lstk(top-3))
      itv4=istk(il4)
      m4=istk(il4+1)
      n4=istk(il4+2)
      it4=istk(il4+3)
      l4=sadr(il4+4)
c     call entier(1,stk(l4),stk(l4))
      iapro=stk(l4)
      il5=iadr(lstk(top-4))
      itv5=istk(il5)
      m5=istk(il5+1)
      n5=istk(il5+2)
      it5=istk(il5+3)
      l5=sadr(il5+4)
c     call entier(1,stk(l5),stk(l5))
      ityp=stk(l5)
      lw1=lstk(top+1)
      lw2=lw1+16
      lw3=lw2+16
      lw4=lw3+16
      lw5=lw4+16
      lw6=lw5+16
      lw7=lw6+32
      lw8=lw7+32
      lw9=lw8+32
      lw10=lw9+32
      lw11=lw10+32
      lw12=lw11+32
      lw13=lw12+32
      lw14=lw13+32
      lw15=lw14+128
      lw16=lw15+128
      lw17=lw16+4
      lw18=lw17+32
      lw19=lw18+32
      err=lw19-lstk(bot)
      if(err.gt.0)then
         call error(17)
         return
      endif
      maxdeg=32
      call syredi(maxdeg,ityp,iapro,stk(l3),adelp,adels,
     *     ndeg,nb,
     *     fact,stk(lw1),stk(lw2),stk(lw3),stk(lw4),stk(lw5),
     *     stk(lw6),stk(lw7),stk(lw8),stk(lw9),
     *     ierr,stk(lw10),stk(lw11),stk(lw12),stk(lw13),
     *     stk(lw14),stk(lw15),stk(lw16),stk(lw17),stk(lw18))
c     subroutine syredi(maxdeg,ityp,iapro,om,adelp,adels,
c     *                   ndeg,nb,
c     *                   fact,b2,b1,b0,c1,c0,
c     *                   zzr,zzi,zpr,zpi,
c     *                   ierr,spr,spi,pren,pimn,
c     *                   zm,sm,rom,nzero,nze)
c
c     nb=(maxdeg+1)/2
c     dimension b2,b1,b0,c1,c0 :nb
c     dimension zzr,zzi,zpr,zpi,spr,spi :maxdeg
c     dimension pren,pimn,nzero,nze :maxdeg
c     dimension zm,sm :maxdeg x 4
      if(ierr.ne.0)then
         buf='syredi: fortran error'
         call error(999)
         return
      endif
      top=top-4
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=1
      length=istk(ilo+1)*istk(ilo+2)
      istk(ilo+3)=0
      lo=sadr(ilo+4)
      stk(lo)=fact
      lstk(top+1)=lo+length
      top=top+1
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=nb
      length=istk(ilo+1)*istk(ilo+2)
      istk(ilo+3)=0
      lo=sadr(ilo+4)
      call dcopy(length,stk(lw1),1,stk(lo),1)
      lstk(top+1)=lo+length
      top=top+1
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=nb
      length=istk(ilo+1)*istk(ilo+2)
      istk(ilo+3)=0
      lo=sadr(ilo+4)
      call dcopy(length,stk(lw2),1,stk(lo),1)
      lstk(top+1)=lo+length
      top=top+1
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=nb
      length=istk(ilo+1)*istk(ilo+2)
      istk(ilo+3)=0
      lo=sadr(ilo+4)
      call dcopy(length,stk(lw3),1,stk(lo),1)
      lstk(top+1)=lo+length
      top=top+1
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=nb
      length=istk(ilo+1)*istk(ilo+2)
      istk(ilo+3)=0
      lo=sadr(ilo+4)
      call dcopy(length,stk(lw4),1,stk(lo),1)
      lstk(top+1)=lo+length
      top=top+1
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=nb
      length=istk(ilo+1)*istk(ilo+2)
      istk(ilo+3)=0
      lo=sadr(ilo+4)
      call dcopy(length,stk(lw5),1,stk(lo),1)
      lstk(top+1)=lo+length
      j=0
      k=0
      do 1001 i=1,nb
         if(stk(lw7+i-1).eq.0)then
            j=j+1
            zzr(j)=stk(lw6+i-1)
            zzi(j)=0
         else
            j=j+1
            zzr(j)=stk(lw6+i-1)
            zzi(j)=stk(lw7+i-1)
            j=j+1
            zzr(j)=stk(lw6+i-1)
            zzi(j)=-stk(lw7+i-1)
         endif
         if(stk(lw9+i-1).eq.0)then
            k=k+1
            zpr(k)=stk(lw8+i-1)
            zpi(k)=0
         else
            k=k+1
            zpr(k)=stk(lw8+i-1)
            zpi(k)=stk(lw9+i-1)
            k=k+1
            zpr(k)=stk(lw8+i-1)
            zpi(k)=-stk(lw9+i-1)
         endif
 1001 continue
      if(j.lt.ndeg)then
         do 1002 i=j+1,ndeg
            zzr(i)=0
            zzi(i)=0
 1002    continue
      endif
      if(k.lt.ndeg)then
         do 1003 i=k+1,ndeg
            zpr(i)=0
            zpi(i)=0
 1003    continue
      endif
      top=top+1
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=ndeg
      length=istk(ilo+1)*istk(ilo+2)
      istk(ilo+3)=1
      lo=sadr(ilo+4)
      call dcopy(length,zzr(1),1,stk(lo),1)
      call dcopy(length,zzi(1),1,stk(lo+length),1)
c     call dcopy(length,stk(lw6),1,stk(lo),1)
c     call dcopy(length,stk(lw7),1,stk(lo+length),1)
      lstk(top+1)=lo+2*length
      top=top+1
      ilo=iadr(lstk(top))
      istk(ilo)=1
      istk(ilo+1)=1
      istk(ilo+2)=ndeg
      length=istk(ilo+1)*istk(ilo+2)
      istk(ilo+3)=1
      lo=sadr(ilo+4)
      call dcopy(length,zpr(1),1,stk(lo),1)
      call dcopy(length,zpi(1),1,stk(lo+length),1)
c     call dcopy(length,stk(lw8),1,stk(lo),1)
c     call dcopy(length,stk(lw9),1,stk(lo+length),1)
      lstk(top+1)=lo+2*length
      return
      end
