      subroutine degl2(neq,imina,iminb,iminc,ta,tb,tc,
     &     iback,ntback,tback,mxsol,w,iw,ierr)
c!but
c     Cette procedure a pour objectif de determiner le plus grand
c     nombre de minimums de degre "neq".
c!liste d'appel
c     subroutine degre (neq,imina,iminb,iminc,ta,tb,tc,
c    &     iback,ntback,tback)
c
c     Entree :
c     -neq. est le degre des polynomes parmi lesquels ont
c       recherche les minimums.
c     -imina. est le nombre de minimums de degre "neq-1"
c       contenus dans ta.
c     -iminb. est le nombre de minimums de degre "neq-2"
c       contenus dans tb.
c     -iminc. est le nombre de minimums de degre "neq-3"
c       contenus dans tc.
c     -ta. est le tableau contenant donc les minimums de degre
c       "neq-1"
c     -tb. est le tableau contenant donc les minimums de degre
c       "neq-2"
c     -tc. est le tableau contenant donc les minimums de degre
c       "neq-3"
c     -iback. est le nombre de minimums obtenus apres une
c       intersection avec la frontiere
c     -ntback est un tableau d'entier qui contient les degre
c       de ces minimums
c     -tback. est le tableau qui contient leurs coefficients,
c       ou ils sont ordonnes degre par degre.
c
c     Sortie :
c     -imina. est le nombre de minimums de degre neq que l'on
c       vient de determiner
c     -iminb. est le nombre de minimums de degre "neq-1"
c     -iminc. est le nombre de minimums de degre "neq-2"
c     -ta. contient les mins de degre neq, -tb. ceux de degre
c       neq-1 et tc ceux de degre neq-2
c     -iback,ntback,tback ont pu etre augmente des mins obtenus
c       apres intersection eventuelle avec la frontiere.
c
c     tableaux de travail
c      w :neq**2+31*neq+24
c      iw :20+neq
c!
      implicit double precision (a-h,o-y)
      dimension ta(mxsol,0:*),tb(mxsol,0:*),tc(mxsol,0:*),
     &     ntback(mxsol),tback(mxsol,0:*)
      dimension w(*),iw(*)
c
      dimension  tps(0:1),tms(0:1)
c
      external feq,jacl2
      common/comall/nall
      common/sortie/nwf,info,ll
c
      tps(0)= 1.0d+0
      tps(1)= 1.0d+0
      tms(0)=-1.0d+0
      tms(1)= 1.0d+0
c
c
c     -------- Reinitialisation des tableaux --------
c
      if (neq.eq.1) goto 111
c
      do 110 j=1,iminb
         call dcopy(neq,tb(j,0),mxsol,tc(j,0),mxsol)
 110  continue
      iminc=iminb
c
 111  do 120 j=1,imina
         call dcopy(neq,ta(j,0),mxsol,tb(j,0),mxsol)
 120  continue
      iminb=imina
c
c
      imina=0
      neq=neq+1
      neqbac=neq
c     decoupage du tableau de travail
      ltq=1
      ltr=ltq+neq+1
      lopt=ltr+neq+1
      lfree=lopt+neq**2+29*neq+24
      if(info.gt.0) call outl2(51,neq,neq,x,x,x,x)
c
c     -------- Boucles de calculs --------
c
      do 190 k=1,iminb
c
         call dcopy(neq-1,tb(k,0),mxsol,w(ltr),1)
         w(ltr+neq-1)=1.0d+0
c
         do 180 imult=1,2
c
            if (imult.eq.1) then
               call dpmul1(w(ltr),neq-1,tps,1,w(ltq))
            else if (imult.eq.2) then
               call dpmul1(w(ltr),neq-1,tms,1,w(ltq))
            endif
c
 140        continue
c
            nch=1
            call optml2 (feq,jacl2,neq,w(ltq),nch,w(lopt),iw)
            if(info.gt.1) call outl2(nch,neq,neqbac,w(ltq),x,x,x)
            if(nch.eq.15.and.nall.eq.0) then
               ierr=4
               return
            endif
c
            if (nch.eq.-1) goto 140
            if (nch.eq.-2) goto 140
c
            nch=2
            call optml2 (feq,jacl2,neq,w(ltq),nch,w(lopt),iw)
            if(info.gt.0) call outl2(nch,neq,neqbac,w(ltq),x,x,x)
            if(nch.eq.15.and.nall.eq.0) then
               ierr=4
               return
            endif
c
c
            if (nch.eq.-1) goto 140
            if (nch.eq.-2) goto 140
c
            if (nch.eq.15) then
               if(info.gt.0) call outl2(50,neq,neq,x,x,x,x)
               goto 170
            endif
c
            nch= neq-neqbac
            if (nch.eq.-2) then
               call storl2 (neq,w(ltq),iminc,tc,iback,ntback,tback,nch,
     $              mxsol,ierr)
            else if (nch.eq.-1) then
               call storl2 (neq,w(ltq),iminb,tb,iback,ntback,tback,nch,
     $              mxsol,ierr)
            else
               call storl2 (neq,w(ltq),imina,ta,iback,ntback,tback,nch,
     $              mxsol,ierr)
            endif
c
 170        neq=neqbac
c
 180     continue
 190  continue
      if(info.gt.0) then
         x=real(mxsol)
         call outl2(53,neq,imina,ta,x,x,x)
      endif
      return
      end
