C/MEMBR ADD NAME=ARL2,SSI=0
      subroutine arl2(f,nf,num,tq,dgmin,dgmax,errl2,w,iw,
     $     inf,ierr,ilog)
c!but
c     Cette procedure a pour but de gerer l'execution dans
c     le cas ou un unique polynome approximant est desire
c!liste d'appel
c      subroutine arl2(f,nf,num,tq,dgmin,dgmax,errl2,w,
c     $     inf,ierr,ilog)
c
c     double precision tq(0:dgmax),f(nf),num(dgmax)
c     double precision w(dgmax**2+29*dgmax+24)
c     integer dgmin,dgmax,dginit,info,ierr,iw(20+dgmax)
c
c     Entree :
c     dgmin. est le degre du polynome de depart quand il est
c        fourni, (vaux 0 s'il ne l'est pas).
c     dginit. est le premier degre pour lequel aura lieu la
c        recherche.
c     dgmax. est le degre desire du dernier approximant
c     tq. est le tableau contenant le polynome qui peut etre
c        fourni comme point de depart par l'utilisateur.
c
c     Sortie :
c     tq. contient la solution obtenu de degre dgmax.
c     num. contient les coefficients du numerateur optimal
c     errl2. contient l'erreur L2 pour l'optimum retourne
c     ierr. contient l'information sur le deroulement du programme
c          ierr=0 : ok
c          ierr=1 : trop de coefficients de fourrier (maxi 200)
c          ierr=2 : ordre d'approximation trop eleve
c          ierr=3 : boucle indesirable sur 2 ordres
c          ierr=4 : plantage lsode
c          ierr=5 : plantage dans recherche de l'intersection avec une face
c
c  tableau de travail
c     w: dimension: dgmax**2+29*dgmax+24e
c     iw : dimension 20+dgmax
c!sous programme appeles
c  optml2,feq,jacl2,outl2,lq,phi (arl2)
c  dcopy,dnrm2,dscal,dpmul1
c!origine
c M Cardelli, L Baratchart  INRIA sophia-Antipolis 1989
c!
      parameter (ncoeff=601,npara=20)
      integer dgmin,dgmax,dginit,info,ierr,iw(*)
      double precision tq(0:dgmax),f(nf),num(dgmax),w(*),x
c
      double precision tg,errl2
      double precision tps(0:1),tms(0:1),dnrm2,sqrt,phi,gnrm
      integer dg,dgback
      external feq,jacl2
      common/foncg/tg(0:ncoeff) /degreg/ng
      common/sortie/io,info,ll
      common/no2f/gnrm
c
c     decoupage du tableau de travail
      ltr=1
      lfree=ltr+dgmax**2+29*dgmax+24
c
      ll=80
      info=inf
      io=ilog
c
c test validite des arguments
      if(nf.gt.ncoeff) then
         ierr=1
         return
      endif
      if(dgmax.gt.npara) then
         ierr=2
         return
      endif
c
      if (dgmin.gt.0) then
         dginit=dgmin
      else
         tq(0)=1.d0
         dginit=1
      endif

c
      ierr=0
      ntest1=-1
c
      ng=nf-1
      call dcopy(nf,f,1,tg,1)
      gnrm=dnrm2(nf,f,1)
      call dscal(nf,1.0d+0/gnrm,tg,1)
      gnrm=gnrm**2
c
      tps(0)= 1.0d+0
      tps(1)= 1.0d+0
      tms(0)=-1.0d+0
      tms(1)= 1.0d+0
c
c     ---- Boucle de calcul ---------------------------------------------
c
      do 500 nnn=dginit,dgmax
c
         ifaceo=0
c
         if (nnn.eq.dginit) then
            if (dgmin.gt.0) then
               dg=dginit
               goto 230
            else
               dg=dginit-1
            endif
         endif
c
 200     dg=dg+1
c
c     -- Initialisation du nouveau point de depart --
c     (dans l'espace de dimension dg , Hyperespace superieur
c     d'une dimension par rapport au precedent ).
c
         if (ntest1.eq.1) then
            call dpmul1(tq,dg-1,tps,1,w(ltr))
            call dcopy(dg+1,w(ltr),1,tq,1)
         else if (ntest1.eq.-1) then
            call dpmul1(tq,dg-1,tms,1,w(ltr))
            call dcopy(dg+1,w(ltr),1,tq,1)
         endif
c
c     ------------------------
c
 230     dgback=dg
c
         if(info.gt.1) call outl2(20,dg,dgback,x,x,x,x)
c
         nch=1
         call optml2(feq,jacl2,dg,tq,nch,w,iw)
         if(info.gt.1) call outl2(nch,dg,dgback,tq,x,x,x)
         if(nch.ge.15) then
            ierr=4+nch-15
            return
         endif
c
         if (nch.lt.0) then
            ifaceo=ifaceo+1
            ntest1=-1*ntest1
            if (dg.eq.0) goto 200
            goto 230
         endif
c
         if(info.gt.1) call outl2(21,dg,dg,x,x,x,x)
         nch=2
         call optml2(feq,jacl2,dg,tq,nch,w,iw)
         if(info.gt.0) call outl2(nch,dg,dgback,tq,x,x,x)
         if(nch.ge.15) then
            ierr=4+nch-15
            return
         endif
c
         if (nch.lt.0) then
            ifaceo=ifaceo+1
            ntest1=-1*ntest1
            if (dg.eq.0) goto 200
            goto 230
         endif
c
c
         if (ifaceo.eq.8) then
            if(info.ge.0) call outl2(22,dg,dg,x,x,x,x)
            ierr=3
            return
         endif
c
         if (dg.lt.nnn) goto 200
c
 500  continue
c
c Fin de la recherche Optimale
c
c numerateur optimal
      gnrm=sqrt(gnrm)
      call lq(dg,tq,num,w(ltr))
      call dscal(dg,gnrm,num,1)
c     Le gradient de la fonction critere y vaut :-tqdot
c     call feq(dg,t,tq,tqdot)
c     valeur du critere
      errl2= sqrt(phi(tq,dg))*gnrm
c
      return
      end
