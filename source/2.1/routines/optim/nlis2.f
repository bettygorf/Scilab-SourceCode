      subroutine nlis2 (simul,prosca,n,xn,fn,fpn,t,tmin,tmax,d,d2,g,gd,
     1 amd,amf,imp,io,logic,nap,napmax,x,tol,a,tps,tnc,gg,izs,rzs,dzs)
c cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c subroutine effectuant une recherche lineaire sur 0 tmax
c partant du point xn dans la direction d.
c sous l'hypothese d'hemiderivabilite, donne
c un pas serieux, bloque, nul ou semi serieux-nul (2 gradients).
c necessite fpn < 0 estimant la derivee a l'origine.
c appelle simul systematiquement avec indic = 4
c
c  logic
c        0          descente serieuse
c        1          descente bloquee
c        2          pas semiserieux-nul
c        3          pas nul, enrichissement du faiseau
c        4          nap > napmax
c        5          retour a l'utilisateur
c        6          non hemi-derivable (au-dela de tmin)
c        < 0        contrainte implicite active
c
c        imp
c                   =0 pas d'impressions
c                   >0 message en cas de fin anormale
c                   >3 informations pour chaque essai de t
c            ----------------------------------------
c fait appel aux subroutines:
c -------simul(indic,n,x,f,g,izs,rzs,dzs)
c--------prosca(n,x,y,ps,izs,rzs,dzs)
c cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit double precision (a-h,o-z)
      external simul,prosca
      dimension xn(n),d(n),g(n),x(n),izs(*),dzs(*),gg(n),gd(n)
      real rzs(*)
 1000 format (/4x,9h nlis2   ,4x,4hfpn=,d10.3,4h d2=,d9.2,
     1 7h  tmin=,d9.2,6h tmax=,d9.2)
 1001 format (/4x,6h nlis2,10x,17htmin force a tmax)
 1002 format (4x,6h nlis2,36x,1hi,d10.3,2d11.3)
 1003 format (4x,6h nlis2,d13.3,2d11.3,2h i)
 1004 format (4x,6h nlis2,36x,1hi,d10.3,7h indic=,i3)
 1006 format (4x,6h nlis2,3x,20hcontrainte implicite,i4,7h active)
 1007 format (/4x,6h nlis2,3x,12hfin sur tmin)
 1010 format (/4x,6h nlis2,3x,i5,22h simulations atteintes)
 1011 format (/4x,6h nlis2,3x,31harret demande par l'utilisateur)
c
c     initialisations
c
      tesf=amf*fpn
      tesd=amd*fpn
      td=0.0d+0
      tg=0.0d+0
      fg=fn
      fpg=fpn
      ta=0.0d+0
      fa=fn
      fpa=fpn
      indica=1
      logic=0
      tx=0.0d+0
      cx=0.0d+0
      fx=fn
      gx=fpn
      step=t
      sthalf=0.1
      penlty=0.0d+0
c          elimination d'un t initial ridiculement petit
      if (t.gt.tmin) go to 20
      t=tmin
      if (t.le.tmax) go to 20
      if (imp.gt.0) write (io,1001)
      tmin=tmax
   20 if (fn+t*fpn.lt.fn+0.90d+0*t*fpn) go to 30
      t=2.0d+0*t
      go to 20
c
   30 if(t.lt.tmax) go to 40
      t=tmax
      logic=1
   40 if (imp.ge.4) write (io,1000) fpn,d2,tmin,tmax
      do 50 i=1,n
   50 x(i)=xn(i)+t*d(i)
      inout=0
      call fpq2 (inout,tx,cx,fx,gx,step,sthalf,penlty,iyflag,
     1 ty,cy,fy,gy,t,cz,fz,gz,ggg,hh,s)
c
c                           boucle
c
  100 nap=nap+1
      if(nap.le.napmax) go to 150
c                sortie par maximum de simulations
      logic=4
      if(imp.ge.4) write(io,1010) nap
      if (tg.eq.0.0d+0) go to 999
      fn=fg
      do 120 i=1,n
      g(i)=gg(i)
  120 xn(i)=xn(i)+tg*d(i)
      go to 999
  150 indic=4
      call simul(indic,n,x,f,g,izs,rzs,dzs)
      if(indic.ne.0) go to 200
c
c                arret demande par l'utilisateur
      logic=5
      fn=f
      do 170 i=1,n
  170 xn(i)=x(i)
      if(imp.ge.4) write(io,1011)
      go to 999
c
c                les tests elementaires sont faits, on y va
c                tout d'abord, ou en sommes nous ?
c
  200 if(indic.gt.0) go to 210
      td=t
      indicd=indic
      logic=0
      if (imp.ge.4) write(io,1004) t,indic
      t=tg+0.10d+0*(td-tg)
      go to 905
c
c                calcul de la derivee directionnelle h'(t)
c
  210 call prosca (n,d,g,fp,izs,rzs,dzs)
c
c         test de descente (premiere inegalite pour un pas serieux)
      ffn=f-fn
      if(ffn.le.t*tesf) go to 300
      td=t
      fd=f
      fpd=fp
      do 230 i=1,n
  230 gd(i)=g(i)
      indicd=indic
      logic=0
      cz=ffn-t*tesf
      fz=f
      gz=fp
      if(imp.ge.4) write(io,1002) t,ffn,fp
      if(tg.ne.0.0d+0) go to 500
c                tests pour un pas nul (si tg=0)
      if(fpd.lt.tesd) go to 500
      tps=(fn-f)+td*fpd
      tnc=d2*td*td
      p=max(a*tnc,tps)
      if(p.gt.tol) go to 500
      logic=3
      go to 999
c
c                    descente
  300 if(imp.ge.4) write(io,1003) t,ffn,fp
c
c         test de derivee (deuxieme inegalite pour un pas serieux)
      if(fp.lt.tesd) go to 320
c
c                sortie, le pas est serieux
      logic=0
      fn=f
      fpn=fp
      do 310 i=1,n
  310 xn(i)=x(i)
      go to 999
c
  320 if (logic.eq.0) go to 350
c
c                sortie par descente bloquee
      fn=f
      fpn=fp
      do 330 i=1,n
  330 xn(i)=x(i)
      go to 999
c
c                on a une descente
  350 tg=t
      fg=f
      fpg=fp
      do 360 i=1,n
  360 gg(i)=g(i)
      cz=0.0d+0
      fz=f
      gz=fp
c
      if(td.ne.0.0d+0) go to 500
c                extrapolation
      call fpq2 (inout,tx,cx,fx,gx,step,sthalf,penlty,
     1 iyflag,ty,cy,fy,gy,t,cz,fz,gz,ggg,hh,s)
      if(t.lt.tmax) go to 900
      logic=1
      t=tmax
      go to 900
c
c                interpolation
c
  500 continue
      call fpq2 (inout,tx,cx,fx,gx,step,sthalf,penlty,
     1 iyflag,ty,cy,fy,gy,t,cz,fz,gz,ggg,hh,s)
c
c                 fin de boucle
c
  900 fa=f
      fpa=fp
  905 indica=indic
c                 peut-on faire logic=2 ?
      if (td.eq.0.0d+0) go to 920
      if (indicd.lt.0) go to 920
      if (td-tg.gt.10.0d+0*tmin) go to 920
      if (fpd.lt.tesd) go to 920
      tps=(fg-fd)+(td-tg)*fpd
      tnc=d2*(td-tg)*(td-tg)
      p=max(a*tnc,tps)
      if(p.gt.tol) go to 920
c               sortie par pas semiserieux-nul
      logic=2
      fn=fg
      fpn=fpg
      t=tg
      do 910 i=1,n
      xn(i)=xn(i)+tg*d(i)
  910 g(i)=gg(i)
      go to 999
c
c                test d'arret sur la proximite de tg et td
c
  920 if (td.eq.0.0d+0) go to 990
      if (td-tg.le.tmin) go to 950
      if (abs(ty-tx).le.tmin) go to 950
      do 930 i=1,n
      z=xn(i)+t*d(i)
      if (z.ne.x(i) .and. z.ne.xn(i)) go to 990
  930 continue
c                arret sur tmin ou de secours
  950 logic=6
      if (indicd.lt.0) logic=indicd
      if (tg.eq.0.0d+0) go to 970
      fn=fg
      do 960 i=1,n
      xn(i)=xn(i)+tg*d(i)
  960 g(i)=gg(i)
  970 if (imp.le.0) go to 999
      if (logic.lt.0) write(io,1006) logic
      if (logic.eq.6) write(io,1007)
      go to 999
c
c                recopiage de x et boucle
  990 do 995 i=1,n
  995 x(i)=xn(i)+t*d(i)
      go to 100
c
  999 return
      end
