      subroutine n1fc1a(simul,prosca,n,mode,xn,fn,g,df0,eps0,dx,imp,
     1  zero,io,ntot,iter,nsim,memax,s,gd,x,sa,gg,al,aps,anc,poids,
     1  q,jc,ic,r,a,e,rr,xga,y,w1,w2,izs,rzs,dzs)
c cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit double precision (a-h,o-z)
      external simul,prosca
      dimension xn(n),g(n),izs(*),dzs(*),x(n),gd(n),gg(n),s(n),sa(n)
      dimension al(memax),aps(memax),anc(memax),poids(memax)
      dimension jc(*),ic(*),q(*),r(*),a(*),e(*),rr(*),
     1 xga(*),y(*),w1(*),w2(*)
      real rzs(*)
 1000 format (19h n1fc1   iter  nsim,6x,2hfn,11x,3heps,7x,2hs2,
     19x,1hu,5x,2hnv)
 1001 format (25h n1fc1   appel incoherent)
 1002 format(/6h n1fc1,21h    tableau des poids/
     1       (6h n1fc1,3x,7d10.3))
 1003 format(/6h n1fc1,17h   fin par indic=,i2,11h dans simul)
 1004 format(6h n1fc1,i7,i5,d16.7,16h   convergence a,d10.3,5h pres,
     13h  (,d9.2,1h))
 1005 format(6h n1fc1,i7,i5,d16.7,20h   faisceau reduit a,
     1 i3,10h gradients)
 1006 format (/22h n1fc1    fin sur nsim)
 1007 format(6h n1fc1,3x,i4,i5,2x,d14.7,3d10.2,i3)
 1009 format (6h n1fc1,10x,6hlogic=,i2,4x,3hro=,d10.3,
     1 4x,4htps=,d10.3,4x,4htnc=,d10.3)
 1010 format (6h n1fc1,12x,6hdiam2=,d10.3,4x,5heta2=,d10.3,4x,
     1 3hap=,d10.3)
 1011 format(/37h n1fc1    la direction ne pivote plus)
 1012 format(/24h n1fc1    fin sur iter =,i4)
 1013 format(/31h n1fc1    fin anormale de fprf2)
 1014 format(/23h n1fc1    fin sur dxmin)
 1015 format(/53h n1fc1  attention on bute sur tmax, reduire l'echelle)
 1016 format(/21h n1fc1    fin normale)
 1017 format (1x)
 1018 format (/25h n1fc1    fin sur indic=0)
c
c         initialisations
c
      itmax=iter
      iter=0
      itimp=0
      napmax=nsim
      nsim=1
      logic=1
      logic2=0
      tmax=1.0d+20
      eps=df0
      epsm=eps
      df=df0
      mode=1
      ntot=0
      iflag=0
c
c          initialisation du faisceau
c          calcul du diametre de l'epure et du test d'arret
c
      aps(1)=0.0d+0
      anc(1)=0.0d+0
      poids(1)=0.0d+0
      nta=0
      kgrad=1
      memax1=memax+1
      do 50 i=1,n
   50 q(i)=-g(i)
      call prosca (n,g,g,diam2,izs,rzs,dzs)
      diam2=100.0d+0*df0*df0/diam2
      eta2=1.0d-2*eps0*eps0/diam2
      ap=zero*df0/diam2
      if(imp.gt.2) write (io,1000)
c
c              boucle
c
  100 iter=iter+1
      itimp=itimp+1
      if(iter.lt.itmax) go to 110
      if(imp.gt.0) write (io,1012) iter
      mode=4
      go to 900
  110 ntot=ntot+1
      if(logic.eq.3) ro=ro*sqrt(s2)
      if (itimp.ne.-imp) go to 200
      itimp=0
      indic=1
      call simul(indic,n,xn,f,g,izs,rzs,dzs)
c
c         calcul de la direction
c
  200 eps=min(eps,epsm)
      eps=max(eps,eps0)
      call fremf1 (prosca,iflag,n,ntot,nta,memax1,q,poids,e,a,r,
     1 izs,rzs,dzs)
      call fprf2 (iflag,ntot,nv,io,zero,s2,eps,al,
     1 imp,u,eta2,memax1,jc,ic,r,a,e,rr,xga,y,w1,w2)
c
c         fin anormale de fprf2
c
      if(iflag.eq.0) go to 250
      if(imp.gt.0) write (io,1013)
      mode=7
      go to 900
  250 nta=ntot
      call ffinf1 (n,nv,jc,xga,q,s)
      u=max(u,0.0d+0)
      s2=max(s2,0.0d+0)
c
c          tests d'arret
c
      if (s2.gt.eta2) go to 300
c
c         calcul de la precision
      z=0.0d+0
      do 260 k=1,nv
      j=jc(k)-1
      if (j.gt.0) z=z+xga(k)*poids(j)
  260 continue
      epsm=min(epsm,z)
      if (imp.ge.2) write (io,1004) iter,nsim,fn,epsm,s2
      if (epsm.gt.eps0) go to 270
      mode=1
      if (imp.gt.0) write (io,1016)
      go to 900
c
c         diminution de epsilon
  270 epsm=max(0.10d+0*epsm,eps0)
      eps=epsm
      if (logic.eq.3) tol=0.010d+0*eps
      iflag=2
      go to 200
c
c                 suite des iterations
c                    impressions
c
  300 if (imp.gt.3) write (io,1017)
      if (imp.gt.2) write (io,1007) iter,nsim,fn,eps,s2,u,nv
      if (imp.ge.6) write (io,1002) (poids(i),i=1,ntot)
c                test de non-pivotage
      if (logic.ne.3) go to 350
      z=0.0d+0
      do 310 i=1,n
      z1=s(i)-sa(i)
  310 z=z+z1*z1
      if(z.gt.10.0d+0*zero*zero*s2) go to 350
      if(imp.gt.0) write (io,1011)
      mode=8
      go to 900
c
c                recherche lineaire
c
  350 iflag=3
      s3=s2+u*eps
      if (logic.eq.3) go to 365
      ro=2.0d+0*df/s3
      tol=0.010d+0*eps
      go to 370
  365 ro=ro/sqrt(s2)
      tol=max(0.60d+0*tol,0.010d+0*eps0)
  370 fa=fn
      alfa=0.20d+0
      beta=0.10d+0
      fpn=-s3
      if (memax.eq.1) tol=0.0d+0
c                 calcul de la resolution minimale, fonction de dx
      tmin=0.0d+0
      do 372 i=1,n
  372 tmin=max(tmin,abs(s(i)/dx))
      tmin=1.0d+0/tmin
      if (iter.eq.1) roa=ro
      call nlis2 (simul,prosca,n,xn,fn,fpn,ro,tmin,tmax,s,s2,g,gd,alfa,
     1 beta,imp,io,logic,nsim,napmax,x,tol,ap,tps,tnc,gg,izs,rzs,dzs)
      if (logic.eq.0 .or. logic.eq.2 .or. logic.eq.3) go to 380
c                 sortie par anomalie dans mlis2
      if (imp.le.0) go to 375
      if (logic.eq.6 .or. logic.lt.0) write (io,1014)
      if (logic.eq.4) write (io,1006)
      if (logic.eq.5) write (io,1018)
      if (logic.eq.1) write (io,1015)
  375 if (logic.eq.1) mode=3
      if (logic.eq.4) mode=5
      if (logic.eq.5) mode=0
      if (logic.eq.6) mode=6
      if (logic.lt.0) mode=logic
      go to 900
  380 if (logic.ne.3) go to 385
      do 382 i=1,n
  382 sa(i)=s(i)
  385 if (iter.gt.1) go to 390
c
c              1ere iteration, ajustement de ap, diam et eta
      if (logic.eq.0) tps=(fn-fa)-ro*fpn
      ap=zero*zero*abs(tps)/(s2*ro*ro)
      ajust=ro/roa
      if (logic.ne.3) diam2=diam2*ajust*ajust
      if (logic.ne.3) eta2=eta2/(ajust*ajust)
      if (imp.ge.2) write (io,1010) diam2,eta2,ap
  390 mm=memax-1
      if (logic.eq.2) mm=memax-2
      if (ntot.le.mm) go to 400
c
c      reduction du faisceau pour entrer le nouvel element
c
      call frdf1(prosca,n,ntot,mm,kgrad,al,q,s,poids,aps,anc,memax1,
     1 r,e,ic,izs,rzs,dzs)
      iflag=1
      nta=ntot
      if (imp.ge.2) write (io,1005) iter,nsim,fn,ntot
c
  400 if (imp.ge.5) write (io,1009) logic,ro,tps,tnc
      if (logic.eq.3) go to 500
c
c                 iteration de descente
c
      iflag=min(iflag,2)
      df=fa-fn
      if (ntot.eq.0) go to 500
c
c               actualisation des poids
c
      s3n=ro*sqrt(s2)
      do 430 k=1,ntot
      nk=(k-1)*n
      z=0.0d+0
      do 420 i=1,n
      nki=nk+i
c                   y(k) contient -(gk,s) (attention a l'artifice)
  420 z=z+q(nki)*s(i)
      y(k)=z
      z1=abs(aps(k)+(-df+ro*z))
      z2=anc(k)+s3n
      poids(k)=max(z1,ap*z2*z2)
      aps(k)=z1
      anc(k)=z2
  430 continue
c
c                actualisation de eps
c
      eps=ro*s3
      kgrad=ntot+1
c
c       nouvel element du faisceau (pour les trois types de pas)
c
  500 nt1=ntot+1
      if (logic.eq.3) go to 510
      aps(nt1)=0.0d+0
      anc(nt1)=0.0d+0
      poids(nt1)=0.0d+0
      go to 520
  510 aps(nt1)=tps
      anc(nt1)=sqrt(tnc)
      poids(nt1)=max(tps,ap*tnc)
  520 nk=ntot*n
      do 530 i=1,n
      nki=nk+i
  530 q(nki)=-g(i)
c
c      traitement pour logic=2 (on ajoute encore un gradient)
      if(logic.ne.2) go to 550
      ntot=ntot+1
      logic=3
      logic2=1
      do 540 i=1,n
  540 g(i)=gd(i)
      go to 390
  550 logic=logic-logic2
      logic2=0
      go to 100
c
c                epilogue
c
  900 if (iter.le.1) go to 990
      do 910 i=1,n
  910 g(i)=-s(i)
  990 return
      end
