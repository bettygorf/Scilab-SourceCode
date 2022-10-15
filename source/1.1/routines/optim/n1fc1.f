      subroutine n1fc1 (simul,prosca,n,xn,fn,g,dxmin,df1,epsf,
     1   zero,imp,io,mode,iter,nsim,memax,iz,rz,dz,izs,rzs,dzs)
c!but et methode
c minimisation d'une fonction hemiderivable par une methode de faisceau.
c la direction est obtenue par projection de l'origine
c sur un polyedre genere par un ensemble de gradients deja calcules
c et la recherche lineaire donne un pas de descente ou un pas nul.
c l'algorithme minimise f a eps0 pres (si convexite)
c ou eps0 est une tolerance donnee par l'utilisateur.
c!origine
c     c lemarechal  inria  1985
c!liste d'appel
c      subroutine n1fc1 (simul,prosca,n,xn,fn,g,dxmin,df1,epsf,
c     1   zero,imp,io,mode,iter,nsim,memax,iz,rz,dz,izs,rzs,dzs)
c
c
c     simul    : point d'entree au module de simulation
c                 (cf normes modulopt ou doc blaise)
c     n1fc1 appelle toujours simul avec indic = 4 ; le module de
c     simulation doit se presenter sous la forme subroutine simul
c     (n,x, f, g, izs, rzs, dzs) et e^tre declare en external dans le
c     programme appelant n1qn1.
c     prosca  : subroutine de calcul du produit scalaire (cf normes)
c     n (e)    : nombre de variables dont depend f.
c     xn (e-s)   : vecteur de dimension n ; en entree le point initial ;
c                 en sortie : le point final calcule par n1qn1.
c     fn (e-s)   : scalaire ; en entree valeur de f en x (initial), en sortie
c                 valeur de f en x (final).
c     g (e-s)   : vecteur de dimension n : en entree valeur du gradient en x
c                 (initial), en sortie valeur du gradient en x (final).
c     dxmin (e)   : precision requise sur chaque coordonnee de x
c     df1 (e-s) : en entree,estimation de la diminution de f a la premiere
c                 iteration. en sortie,valeur verifiant une estimation
c                 de la difference entre f(x) et min f .
c     epsf : precision a laquelle on desire minimiser f
c      zero : precision du zero machine
c      imp (e)   : contro^le les messages d'impression :
c                  0 rien n'est imprime
c                  = 1 impressions initiales et finales
c                  = 2 une impression par iteration (nombre d'iterations,
c                      nombre d'appels a simul, valeur courante de f).
c                  >=3 informations supplementaires sur les recherches
c                      lineaires ;
c                      tres utile pour detecter les erreurs dans le gradient.
c      io (e)    : le numero du canal de sortie, i.e. les impressions
c                  commandees par imp sont faites par write (io, format).
c        mode (s)
c                <=0 mode=indic de simul
c                1 fin normale
c                2 appel incoherent
c                3 reduire l'echelle des x
c                4 max iterations
c                5 max simulations
c                6 impossible d'aller au dela de dx
c                7 fprf2 mis en echec
c                8 on commence a boucler
c
c     iter (e-s)  : en entree nombre maximal d'iterations : en sortie nombre
c                    d'iterations reellement effectuees.
c     nsim (e-s)  : en entree nombre maximal d'appels a simul (c'est a dire
c          avecindic = 4). en sortie le nombre de tels appels reellement faits.
c     memax : entier>=1. nombre de gradients que peut contenir le faisceau
c     iz,rz,dz  : memoires de travail
c          dimension iz=2*(memax+1)
c          dimension rz=5*n+(n+4)*memax
c          dimension dz=(memax+9)*memax+8
c
c     izs,rzs,dzs memoires reservees au simulateur (cf doc)
c
c! subroutines appelees (modulopt)
c --------subroutine fprf2 (calcul de la direction)
c --------subroutines fremf1 et ffinf1 (esclaves de fprf2)
c --------subroutine frdf1 (reduction du faisceau)
c --------subroutine nlis2 (recherche lineaire)
c --------subroutine fpq2 (interpolations de la recherche lineaire)
c --------subroutine simul (module de simulation)
c --------subroutine prosca (produit de dualite donnant le gradient)
c!
c
      implicit double precision (a-h,o-z)
      external simul,prosca
      dimension iz(*),rz(*),xn(n),g(n),izs(*),dzs(*),dz(*)
      real rzs(*)
      if (n.gt.0 .and. df1.gt.0.0d+0
     1 .and. epsf.ge.0.0d+0 .and. zero.ge.0.0d+0
     1 .and. iter.ge.0 .and. nsim.ge.0
     1 .and. memax.ge.1 .and. dxmin.gt.0.0d+0) go to 10
      mode=2
      write (io,1001)
 1001 format (25h n1fc1   appel incoherent)
      go to 999
   10 ns=1
      ngd=ns+n
      nx=ngd+n
      nsa=nx+n
      ngg=nsa+n
      nal=ngg+n
      naps=nal+memax
      nanc=naps+memax
      npoids=nanc+memax
      nq=npoids+memax
      njc=1
      nic=njc+memax+1
      nr=1
      na=nr+(memax+1)*(memax+1)
      ne=na+memax+1
      nrr=ne+memax+1
      nxga=nrr+memax+1
      ny=nxga+memax+1
      nw1=ny+memax+1
      nw2=nw1+memax+1
c
      niz=2*(memax+1)
      nrz=nq+n*memax-1
      ndz=nw2+memax
      if (imp.gt.0) write (io,1000) n,memax,niz,nrz,ndz
 1000 format (22h entree dans n1fc1. n=,i4,8h  memax=,i3/
     122h  dimensions minimales,2x,3hiz(,i4,8h)    rz(,i6,8h)    dz(,
     1i6,1h)/)
      do 110 i=1,niz
  110 iz(i)=0
      do 120 i=1,nrz
  120 rz(i)=0.0d+0
      do 130 i=1,ndz
  130 dz(i)=0.0d+0
      call n1fc1a(simul,prosca,n,mode,xn,fn,g,df1,epsf,dxmin,imp,zero,
     1 io,ntot,iter,nsim,memax,rz(ns),rz(ngd),rz(nx),rz(nsa),
     1 rz(ngg),rz(nal),rz(naps),rz(nanc),rz(npoids),rz(nq),
     1 iz(njc),iz(nic),dz(nr),dz(na),dz(ne),dz(nrr),dz(nxga),dz(ny),
     1 dz(nw1),dz(nw2),izs,rzs,dzs)
      iz(1)=ntot
  999 return
      end
