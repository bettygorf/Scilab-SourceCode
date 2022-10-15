C/MEMBR ADD NAME=DOMOUT,SSI=0
      subroutine domout(neq,q,qi,nbout,ti,touti,itol,rtol,atol,itask,
     *     istate,iopt,rwork,lrw,iwork,liw,jacl2,mf,job)
c!but
c     Etant sortie du domaine d'integration au cours
c     de l'execution de la routine Optm2, il s'agit ici de
c     gerer ou d'effectuer l'ensemble des taches necessaires
c     a l'obtention du point de la face par lequel la
c     'recherche' est passee.
c!liste d'appel
c     subroutine domout(neq,q,qi,nbout,ti,touti,itol,rtol,atol,itask,
c    *     istate,iopt,rwork,lrw,iwork,liw,jacl2,mf,job)
c
c     double precision  atol(0:neq),rtol(0:neq),q(0:neq),qi(0:neq)
c     double precision rwork(neq**2+19*neq+20),iwork(20+neq)
c
c     Entree :
c     - Il y a deja toutes les variables et tableaux de
c        variables necessaires a l'execution de la routine Lsode
c     - qi. est le dernier point obtenu de la trajectoire
c        qui soit a l'interieur du domaine.
c     - q. est celui precedemment calcule, qui se situe a
c       l'exterieur.
c
c     Sortie :
c     - q. est cense etre le point correspondant a l'inter-
c        section entre la face et la trajectoire.
c     - job. est un parametre indiquant si le franchissement
c            est verifie.
c            si job=-1 pb de detection arret requis
c
c     Tableaux de travail
c     - rwork : neq**2+25*neq+23
c     - iwork : 20+neq
c!
      implicit double precision (a-h,o-z)
      dimension  atol(0:neq),rtol(0:neq),rwork(*),iwork(*),
     *     q(0:neq),qi(0:neq)
      external feq,jacl2
      common/comall/nall
      common /sortie/nwf,info,ll
c
      lrwork=1
      lqex=lrwork+neq**2+9*neq+22
      lw=lqex+neq+1
      lfree=lw+15*neq
c
      tout=touti
      nboute=0
c
c     --- Etape d'approche de la frontiere ----------------------------
c
 300  kmax= int(log((tout-ti)/0.006250d+0)/log(2.0d+0))
      k0=1
c
      if(info.gt.1) call outl2(40,neq,kmax,x,x,x,x)
c
c
 314  do 380 k=k0,kmax
c
         tpas= (tout-ti)/2.0d+0
c
         if (nbout.gt.0) then
            istate=1
            call dcopy(neq+1,qi,1,q,1)
            t=ti
            tout=ti + tpas
         else
            call dcopy(neq+1,q,1,qi,1)
            ti=t
            tout=ti + tpas
         endif
c
 340     if(info.gt.1) call outl2(41,neq,neq,q,x,t,tout)
c
         call lsode(feq,neq,q,t,tout,itol,rtol,atol,itask,
     *        istate,iopt,rwork,lrw,iwork,liw,jacl2,mf)
         if(info.gt.1) call outl2(42,neq,neq,q,x,t,tout)
c
         if (istate.eq.-1.and.t.ne.tout) then
            if(info.gt.1) call outl2(43,neq,neq,x,x,x,x)
            istate=2
            goto 340
         endif
c
         call front(neq,q,nbout,rwork(lw))
         if(info.gt.1) call outl2(44,neq,nbout,x,x,x,x)
c
         if (nbout.gt.0) then
            nboute=nbout
            call dcopy(neq+1,q,1,rwork(lqex),1)
         endif
c
         if (istate.lt.0) then
            if(info.gt.1) call outl2(45,neq,istate,x,x,x,x)
            job=-1
            return
         endif
c
         if (k.eq.kmax.and.nboute.eq.0.and.tout.ne.touti) then
            tout=touti
            goto 340
         endif
c
 380  continue
c
c     ---------------------------
c
      if (nboute.eq.0) then
         job=0
         return
      else if (nboute.gt.2) then
         newrap=1
         goto 390
      endif
c
      call watfac(neq,rwork(lqex),nface,newrap,rwork(lw))
      if (newrap.eq.1) goto 390
c
      neqsav=neq
      call onface(neq,q,nface,ierr,rwork(lw))
      if(ierr.ne.0) then
         job=-1
         return
      endif
      yi=phi(qi,neqsav)
      yf=phi(q,neq)
c
      eps390=1.0d-08
      if (yi.lt.(yf-eps390)) then
         newrap=1
         goto 390
      endif
c
      if(info.gt.1) call outl2(46,neq,nface,q,x,yi,yf)
c
      newrap=0
c
 390  if (newrap.eq.1) then
         neq=neqsav
         k0=kmax
         kmax=kmax+1
         nbout=1
         tout=ti + 2*tpas
         if(info.gt.1) call outl2(47,neq,neq,x,qi,x,x)
         goto 314
      endif
c
      job=1
c
 399  if(info.gt.1) call outl2(48,neq,neq,x,x,x,x)
      return
c
      end
