C/MEMBR ADD NAME=ARL2A,SSI=0
      subroutine arl2a(f,nf,ta,mxsol,imina,nall,inf,ierr,ilog,w,iw)
c!but
c     Cette procedure a pour but de rechercher le plus
c     grand nombre d'approximants pour chaque degre en partant
c     du degre 1 jusqu'a l'ordre nall.
c!liste d'appel
c     subroutine arl2a(f,nf,ta,nta,nall,info,ierr,io)
c     double precision ta(mxsol,0:nall),f(nf),w(*)
c     integer iw(*)
c
c     entrees
c      f : vecteur des coefficients de Fourier
c      nf : nombre de coefficients de Fourrier maxi 200
c      nall: degre des polynomes minimums que l'on veut  atteindre.
c      inf : impression de la progression de l'algorithme:
c            0 = rien
c            1 = resultats intermediaires et messages d'erreur
c            2 = suivi detaille
c      ilog : etiquette logique du fichier ou sont ecrite ces informations
c
c      sorties
c       ta :tableau contenant les minimums  locaux a l'ordre nall
c       imina : nombre de minimums trouves
c       ierr. contient l'information sur le deroulement du programme
c          ierr=0 : ok
c          ierr=1 : trop de coefficients de fourrier (maxi 200)
c          ierr=2 : ordre d'approximation trop eleve
c          ierr=3 : boucle indesirable sur 2 ordres
c          ierr=4 : plantage lsode
c          ierr=5 : plantage dans recherche de l'intersection avec une face
c          ierr=7 : trop de solutions
c
c      tableaux de travail
c      w: nall**2+32*nall+25+4*(nall+1)*mxsol
c      iw :20+nall+2*mxsol
c!Origine
c M Cardelli L Baratchart INRIA Sophia-Antipolis 1989
c!
      implicit double precision (a-h,o-y)
      parameter (ncoeff=601,npara=20)
      dimension ta(mxsol,0:nall),f(nf),w(*),iw(*)
c
      common/foncg/tg(0:ncoeff) /degreg/ng
      common/sortie/io,info,ll
      common/no2f/gnrm
      common/comall/nall1
c
c     decoupage du tableau de travail
      ldeg=1
      ltb=ldeg+nall**2+31*nall+24
      ltc=ltb+(nall+1)*mxsol
      ltback=ltc+(nall+1)*mxsol
      lter=ltback+(nall+1)*mxsol
      ltq=ltback+(nall+1)*mxsol
      lfree=ltq+nall+1
c
      ildeg=1
      ilntb=ildeg+20+nall
      ilnter=ilntb+mxsol
      ilfree=ilnter+mxsol
c     initialisations
      io=ilog
      ll=80
      info=inf
      nall1=nall
c
c test validite des arguments
      if(nf.gt.ncoeff) then
         ierr=1
         return
      endif
      if(nall.gt.npara) then
         ierr=2
         return
      endif
c
      ng=nf-1
      call dcopy(nf,f,1,tg,1)
      gnrm=dnrm2(nf,f,1)
      call dscal(nf,1.0d+0/gnrm,tg,1)
      gnrm=gnrm**2
c
c
      iback=0
c
      call deg1l2(imina,ta,mxsol,w(ldeg),iw(ildeg),ierr)
      if(ierr.gt.0) return
      if (nall.eq.1) goto 400
      neq=1
c
      do 200 ideg=2,nall
c
         call degl2 (neq,imina,iminb,iminc,ta,w(ltb),w(ltc),
     $        iback,iw(ilntb),w(ltback),mxsol,w(ldeg),iw(ildeg),ierr)
         if(ierr.gt.0) return
c
         if (imina.eq.0) goto 201
c
 200  continue
c
 201  if(info.gt.1) call outl2(23,neq,iback,x,x,x,x)
c
      if (iback.gt.0) then
         imina=0
         neq=iw(ilntb)
         inf=1
         do 300 ideg=neq,nall-1
c
            do 250 j=inf,iback
               ntbj=iw(ilntb+j-1)
               if (ntbj.eq.neq) then
                  call dcopy(ntbj,w(ltback-1+j),mxsol,w(ltq),1)
                  w(ltq+ntbj)=1.0d+0
c
                  nch=1
                  call storl2 (neq,tq,imina,ta,iter,iw(ilnter),
     $                         w(lter),nch,mxsol,ierr)
c
               else
                  inf=j
                  goto 260
               endif
 250        continue
c
c
 260        call degl2 (neq,imina,iminb,iminc,ta,w(ltb),w(ltc),
     $           iter,iw(ilnter),w(lter),mxsol,w(ldeg),iw(ildeg),ierr)
            if(ierr.gt.0) return
c
 300     continue
      endif
c
 400  continue
c
      return
      end
