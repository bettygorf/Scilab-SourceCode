C/MEMBR ADD NAME=OPTML2,SSI=0
      subroutine optml2(feq,jacl2,neq,q,nch,w,iw)
c!but
c      Routine de recherche de minimum du probleme d'approximation L2
c       par lsoda ( Lsoda = routine de resolution d'equa diff )
c!liste d'appel
c     subroutine optml2(feq,jacl2,neq,q,nch,w,iw)
c
c     external feq,jacl2
c     double precision q(0:neq),w(neq**2+29*neq+24)
c     integer nch,iw(20+neq)
c
c     Entrees :
c     - feq est la subroutine qui calcule le gradient,
c        oppose de la derivee premiere de la fonction phi.
c     - neq est le degre du polynome q
c     - q est polynome (ou point) de depart de la recherche.
c     - nch est l indice (valant 1 ou 2) qui classifie l
c       appel comme etant soit celui de la recherche et de la
c       localisation d un minimum local, soit de la
c       confirmation d un minimum local.
c
c     Sorties :
c     - neq est toujours le degre du polynome q (il peut  avoir varie).
c     - q est le polynome (ou plutot le tableau contenant
c         ses coefficients) qui resulte de la recherche ,il peut
c         etre du meme degre que le polynome initial mais aussi
c         de degre inferieur dans le cas d'une sortie de face.
c
c     Tableau de travail
c     - w de taille neq**2+29*neq+24
c     - iw de taille 20+neq
c!
      implicit double precision (a-h,o-y)
      dimension q(0:neq),w(*),iw(*)
c
      external feq,jacl2
      common/temps/t
      common/comall/nall/sortie/nwf,info,ll
c
c decoupage du tableau de travail w
      lqi=1
      lqdot=lqi+neq+1
      latol=lqdot+neq
      lrtol=latol+neq
      lwork=lrtol+neq
      lw=lwork+neq*neq+9*neq+22
      lfree=lwork+neq*neq+25*neq+23
c
      neqbac=neq
c
c     --- Initialisation de lsode ------------------------
c
 200  if (nch.eq.1) t=0.0d+0
      t0=t
      tt=0.10d+0
      tout=t0+tt
      itol=4
c
      if (neq.lt.7) then
         ntol=int((neq-1)/3)+5
      else
         ntol=int((neq-7)/2)+7
      endif
      call dset(neq,10.0d+0**(-(ntol)),w(lrtol),1)
      call dset(neq,10.0d+0**(-(ntol+2)),w(latol),1)
c
      itask=1
      if (nch.eq.1) istate=1
      if (nch.eq.2) istate=3
      iopt=0
      lrw=730
      liw=40
      mf=21
c
c     --- Initialisation du nombre maximal d'iteration ---
c
      if (nch.eq.1) then
         if (neq.le.11) then
            nlsode=11 + 2*(neq-1)
         else
            nlsode=29
         endif
      else
         nlsode=19
      endif
      ilcom=0
      ipass=0
c
c     --- Appel  de lsode --------------------------------
c
 210  do 290 i=1,nlsode
c
 220     ilcom=ilcom+1
c
c     -- Reinitialisation de la Tolerance --
c
         if (ilcom.eq.2.and.nch.eq.1) then
            call dset(neq,1.0d-05,w(lrtol),1)
            call dset(neq,1.0d-07,w(latol),1)
            istate=3
         else if (ilcom.eq.2.and.nch.eq.2) then
            w(lrtol)=1.0d-08
            w(latol)=1.0d-10
            w(lrtol+1)=1.0d-07
            w(latol+1)=1.0d-09
            w(lrtol+neq-1)=1.0d-05
            w(latol+neq-1)=1.0d-07
            do 240 j=2,neq-2
               w(lrtol+j)=1.0d-06
               w(latol+j)=1.0d-08
 240        continue
            istate=3
         endif
c
c     --------------------------------------
c
         call dcopy(neq+1,q,1,w(lqi),1)
         ti=t
         touti=tout
c
         if(info.gt.1) call outl2(30,neq,neq,q,x,t,tout)
c
         call lsode(feq,neq,q,t,tout,itol,w(lrtol),w(latol),itask,
     *        istate,iopt,w(lwork),lrw,iw,liw,jacl2,mf)
c
         call front(neq,q,nbout,w(lw))
c
         call feq(neq,t,q,w(lqdot))
         dnorm0= dnrm2(neq,w(lqdot),1)
         if(info.gt.1) call outl2(31,neq,nbout,q,dnorm0,t,tout)
c
c     -- test pour degre1 -----------
         if (nall.gt.0.and.neq.eq.1.and.nbout.gt.0)  return
c
c
c     -- Istate de lsode ------------
c
         if (istate.eq.-5) then
            if(info.gt.0) call outl2(32,neq,neq,x,x,x,x)
            call dscal(neq,0.10d+0,w(lrtol),1)
            call dscal(neq,0.10d+0,w(latol),1)
            if (t.eq.0.0d+0)  istate=1
            if (t.ne.0.0d+0)  istate=3
            ilcom=0
            goto 220
         endif
c
         if (istate.eq.-6) then
c     echec de l'integration appel avec de nouvelles tolerances
            if(info.gt.0) call outl2(33,neq,neq,x,x,x,x)
            if(info.gt.1) call outl2(34,neq,itol,w(latol),w(lrtol),
     $           t,tout)
            iopt=0
            itol=4
            call dset(neq,0.10d-05,w(lrtol),1)
            call dset(neq,0.10d-05,w(latol),1)
            if(info.gt.1) call outl2(35,neq,itol,w(latol),w(lrtol),x,x)
            if(info.gt.0) call outl2(36,neq,neq,x,x,x,x)
            istate=3
            if (t.ne.tout) goto 220
         endif
c
         if (istate.lt.-1.and.istate.ne.-6.and.istate.ne.-5) then
            if(info.gt.0) call outl2(37,neq,iopt,x,x,x,x)
            nch=15
            return
         endif
c
c     -------------------------------
c
c     -- Sortie de face -------------
c
         if (nbout.gt.0.and.nbout.ne.99) then
            call domout(neq,q,w(lqi),nbout,ti,t,itol,w(lrtol),w(latol),
     *           itask,istate,iopt,w(lwork),lrw,iw,liw,jacl2,mf,job)
            if(job.eq.-1) then
c     anomalie dans la recherche de l'intersection
               nch=16
               return
            endif
            if (job.eq.1) then
               nch= neq-neqbac
               return
               endif
         endif
c
c     -------------------------------
c
c     -- test sur le gradient -------
c
         epstop=(1.0d-06)**nch
         call feq(neq,t,q,w(lqdot))
         dnorm0= dnrm2(neq,w(lqdot),1)
         if (dnorm0.lt.epstop) goto 299
c
c     -------------------------------
c
c     -- Istate de lsode (suite) ----
c
         if (istate.eq.-1.and.t.ne.tout) then
            if(info.gt.0) call outl2(38,neq,neq,x,x,x,x)
            istate=2
            goto 220
         endif
c
c     -------------------------------
c
         tt= sqrt(10.0d+0) * tt
         tout=t0+tt
c
 290  continue
c
      if (nch.eq.2.and.dnorm0.gt.(1.0d-06)) then
         ipass=ipass + 1
         if (ipass.lt.5) then
            if(info.gt.0) call outl2(14,neq,neq,q,x,x,x)
            goto 210
         else
            if(info.gt.0) call outl2(39,neq,neq,x,x,x,x)
            nch=15
            return
         endif
      endif
c
 299  return
c
      end
