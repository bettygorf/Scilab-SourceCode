      subroutine deg1l2(imin,ta,mxsol,w,iw,ierr)
c!but
c     Determiner la totalite des polynome de degre 1.
c!liste d'appel
c     sorties :
c     -imin. est le nombre de minimums obtenus.
c     -ta. est le tableau dans lequel sont conserves les
c        minimums.
c     tableaux de travail
c     - w :54+2*mxsol
c     -iw :21+ mxsol
c!remarque
c     on notera que le neq ieme coeff de chaque colonne
c     devant contenir le coeff du plus au degre qui est
c     toujours 1. contient en fait la valeur du critere
c     pour ce polynome.
c!
      implicit double precision (a-h,o-y)
      dimension ta(mxsol,0:*)
      external feq,feq2,jacl2,jacl2r
c
      dimension tq(0:1),w(*),iw(*)
      common/sortie/nwf,info,ll
c
c
      lopt=1
      ltback=lopt+54
      lfree=ltback+2*mxsol
      lntb=1+21
c
      tq(0)=0.99990d+0
      tq(1)=1.0d+0
      minmax=-1
      neq=1
      neqbac=1
c
      if(info.gt.0) call outl2(51,neq,neq,x,x,x,x)
      do 120 icomp=1,50
c
         if (minmax.eq.-1) then
            nch=1
            call optml2(feq,jacl2,neq,tq,nch,w(lopt),iw)
            if(info.gt.1) call outl2(nch,neq,neqbac,tq,x,x,x)
c
            nch=2
            call optml2(feq,jacl2,neq,tq,nch,w(lopt),iw)
            if(info.gt.0) call outl2(nch,neq,neqbac,tq,x,x,x)
c
            minmax=1
         else
            nch=1
            call optml2(feq2,jacl2r,neq,tq,nch,w(lopt),iw)
            if(info.gt.1) call outl2(3,neq,neqbac,tq,x,x,x)
c
            nch=2
            call optml2(feq2,jacl2r,neq,tq,nch,w(lopt),iw)
            if(info.gt.1) call outl2(4,neq,neqbac,tq,x,x,x)
c
            minmax=-1
         endif
c
         if (abs(tq(0)).gt.1.0d+0) goto 140
c
         if (minmax.eq.1) then
            if (icomp.eq.1) then
               imin=1
               ta(imin,0)=tq(0)
               ta(imin,1)=phi(tq,neq)
            else
               call storl2(neq,tq,imin,ta,iback,iw(lntb),w(ltback),nch,
     $              mxsol,ierr)
               if(ierr.gt.0) return
            endif
         endif
c
         tq(0)=tq(0) - 0.000010d+0
c
 120  continue
c
 140  if(info.gt.0) then
         x=real(mxsol)
         call outl2(52,neq,imin,ta,x,x,x)
      endif
c
      return
      end
