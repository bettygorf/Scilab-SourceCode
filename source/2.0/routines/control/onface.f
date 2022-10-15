      subroutine onface(neq,q,nprox,ierr,w)
c!but
c     il est question ici de calculer (ou d estimer)
c     le polynome (ou point) qui se situe a l'intersection
c     de la recherche et de la face-frontiere du domaine.
c!liste d'appel
c     subroutine onface(neq,q,nprox)
c
c     double precision q(0:neq),w(*)
c     integer neq,nprox,ierr
c
c     Entree :
c     - neq. est le degre du polynome q(z) avant toute
c        modification.
c     - q. est le tableau de ses coefficients
c     - nprox. est l indice de la face par laquelle on estime
c        que la recherche a franchi la frontiere du domaine.
c
c     Sortie :
c     -neq. est alors le degre des polynomes de la face
c       traversee et donc du polynome intersection. Sa valeur
c       est inferieur de 1 ou 2 a sa valeur precedente.
c     - q. contient en sortie les coefficients du polynome
c       intersection dans le domaine de la face traversee.
c
c     Tableau de travail
c     - w : 15*neq
c!
      implicit double precision (a-h,o-y)
      dimension q(0:neq),w(*)
c
      dimension tps(0:1),taux2(0:2),tabeta(0:2)
      common/comall/nall/sortie/nwf,info,ll
c
c     decoupage du tableau de travail
      lqaux=1
      lqdot=lqaux
      lrq0=lqdot+neq+1
      lrq1=lrq0+neq
      lrgd0=lrq1+neq
      lrgd1=lrgd0+neq
      lgp=lrgd1+neq
      lgp1=lgp+2*neq-2
      lbeta=lgp1
      lw=lbeta+2*neq-2
      lfree=lw+6*neq+1
c
      neqvra=neq
c
      tps(1)=1.0d+0
      tps(0)=1.0d+0
c
      if (nprox.ne.0) then
      tps(0)=real(nprox)
c     calcul du reste de la division de q par tps
         call horner(q,neq,-tps(0),0.0d+0,srq,xx)
c     calcul du reste de la division de qdot  par 1+z
         call feq(neq,t,q,w(lqdot))
         call horner(w(lqdot),neq,-tps(0),0.0d+0,srgd,xx)
c
         call daxpy(neq,-srq/srgd,qdot,1,q,1)
c
         call dpodiv(q,tps,neq,1)
         if(info.gt.0) call outl2(70,1,1,x,x,x,x)
         if(info.gt.1) call outl2(71,1,1,q,x,x,x)
         call dcopy(neq,q(1),1,q,1)
         neq=neq-1
c
      else if (nprox.eq.0) then
c
         taux2(2)=1.0d+0
         taux2(1)=0.0d+0
         taux2(0)=1.0d+0
c
         call dcopy(neq+1,q,1,w(lqaux),1)
         do 200 ndiv=0,neq-2
            call dpodiv(w(lqaux),taux2,neq-ndiv,2)
            w(lrq1+ndiv)=w(lqaux+1)
            w(lrq0+ndiv)=w(lqaux)
c
            do 180 j=2,neq-ndiv
               w(lqaux+j-1)=w(lqaux+j)
 180        continue
            w(lqaux)=0.0d+0
 200     continue
         w(lrq1-1+neq)=w(lqaux+1)
         w(lrq0-1+neq)=w(lqaux)
c
         call feq(neq,t,q,w(lqaux))
         nqdot=neq-1
c
         do 240 ndiv=0,nqdot-2
            call dpodiv(w(lqaux),taux2,nqdot-ndiv,2)
            w(lrgd1+ndiv)=w(lqaux+1)
            w(lrgd0+ndiv)=w(lqaux)
c
            do 220 j=2,nqdot-ndiv
               w(lqaux+j-1)=w(lqaux+j)
 220        continue
            w(lqaux)=0.0d+0
 240     continue
         w(lrgd1-1+nqdot)=w(lqaux+1)
         w(lrgd0-1+nqdot)=w(lqaux)
c
c     - construction du polynome gp(z) dont on cherchera une racine
c     comprise entre -2 et +2 -----------------------------
c
         call dset(2*neq-2,0.0d+0,w(lgp),1)
         call dset(2*neq-2,0.0d+0,w(lgp1),1)
c
         do 260 j=1,neq
            do 258 i=1,nqdot
               k=i+j-2
               w(lgp+k)= w(lgp+k) + ((-1)**k)*w(lrq0-1+j)*w(lrgd1-1+i)
               w(lgp1+k)= w(lgp1+k) + ((-1)**k)*w(lrq1-1+j)*w(lrgd0-1+i)
 258        continue
 260     continue
c
         call ddif(2*neq-2,w(lgp1),1,w(lgp),1)
         ngp=2*neq-3
         call rootgp(ngp,w(lgp),nbeta,w(lbeta),ierr,w(lw))
         if(ierr.ne.0) return
c
         do 299 k=1,nbeta
c
c     - calcul de t (coeff multiplicateur) -
c
            auxt1=0.0d+0
            do 280 i=1,neq
               auxt1=auxt1 + w(lrq1-1+i)*( (-w(lbeta-1+k))**(i-1) )
 280        continue
c
            auxt2=0.0d+0
            do 290 i=1,nqdot
               auxt2=auxt2 + w(lrgd1-1+i)*( (-w(lbeta-1+k))**(i-1) )
 290        continue
c
            tmult=- auxt1/auxt2
c
            if (k.eq.1) then
               t0=tmult
               beta0=w(lbeta)
            else if (abs(tmult).lt.abs(t0)) then
               t0=tmult
               beta0=w(lbeta-1+k)
            endif
c
 299     continue
c
         call feq(neq,t,q,w(lqdot))
         call daxpy(neq,t0,w(lqdot),1,q,1)
c
         tabeta(2)=1.0d+0
         tabeta(1)=beta0
         tabeta(0)=1.0d+0
         call dpodiv(q,tabeta,neq,2)
         if(info.gt.0) call outl2(70,2,2,x,x,x,x)
         if(info.gt.1) call outl2(71,2,2,q,x,x,x)
c
         call dcopy(neq-1,q(2),1,q,1)
         neq=neq-2
c
      endif
c
      return
      end
