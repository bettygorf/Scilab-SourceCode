      subroutine fprf2 (iflag,ntot,nv,io,zero,s2,
     1 eps,al,imp,u,eta,mm1,jc,ic,r,a,e,rr,xpr,y,w1,w2)
      implicit double precision (a-h,o-z)
      common /fprf2c/ u1,nc
c         the dimensions are mm1*mm1 for r and
c             mm1 for jc,ic,a,e,rr,xpr,y,w1,w2
      dimension al(ntot),jc(mm1),ic(mm1),y(mm1),w1(mm1),w2(mm1),
     1 a(mm1),e(mm1),r(*),rr(mm1),xpr(mm1)
c
c     *****  on entry  *****
c
c       iflag=0-1  initialize on one subgradient (mu in)
c
c       iflag=2    '     '     '     '     '     '     '
c                  and strive to enter by priority the
c                  points of the previous corral at the
c                  beginning of the iterations.
c
c       iflag=3    initialize on the previous projection
c                  (with its corresponding corral)
c
c
c      *****  on exit  *****
c
c                  iflag=0    normal end
c
c                        1    old solution is already optimal
c
c                        2    constraints non feasible
c
c                        3    trying to enter a variable
c                             that is already in the corral
c
c                        4    starting to loop
c
c
c
c
c      imp > 5    one prints final information
c
c
c      imp > 6    one prints information at each iteration
c
c
c      imp > 7    one prints also
c
c                - at each iteration the choleski matrix
c                - and the initial information such as (pi,pj) ...
c
c
c
 1001 format(27h     epsilon smaller than a)
 1003 format(3h a=,10d10.3,/(6x,10d10.3))
 1004 format(7h (g,g)=,10d10.3,/(7x,10d10.3))
 1005 format(27h start with variables 1 and,i4)
 1006 format(7h (s,s)=,d12.4,10h  variable,i4,
     12h (,d12.4,12h) coming in.)
 1007 format(9h variable,i4,2h (,i4,3h) =,d11.3,11h going out.,
     1 17h  feasible (s,s)=,d11.4,12h unfeasible=,d11.4)
 1008 format(15h initial corral/(20i6))
 1010 format(12h   epsilon =,d10.3)
 1011 format(3h x=,10d11.3,/(3x,10d11.3))
 1012 format(10h choleski,,10d11.3,/(10x,10d11.3))
 1013 format(22h   duplicate variable ,i3)
 1014 format(14h finished with,i3,10h gradients,i3,
     111h variables./
     1 7h (s,s)=,d11.4,6h test=,d11.4/
     1               32h cost of the extra constraint u=,d12.5)
 1015 format(20i6)
 1016 format(28h fprf2 is apparently looping)
 1018 format(//)
 1019 format(47h error from fprf2. old solution already optimal)
 1020 format(7h (s,s)=,d12.4,5h  u1=,d12.3,23h  variable 1 coming in.)
c
c
c               ****   begin   ****
c
c              prepare various data
c
c
      niter=0
      nt1=ntot+1
      itmax=10*ntot
      incr=0
      k00=1
      w1s=0.0d+0
      w2s=0.0d+0
      w12s=0.0d+0
      gama=.990d+0
c                     initial printouts
      if(imp.le.7) go to 100
      write(io,1003) (a(j),j=1,nt1)
      write(io,1010) eps
      do 95 j=1,nt1
      mej=(j-1)*mm1
      write(io,1004) (r(mej+jj),jj=1,j)
   95 continue
c
c                     initial point
c
  100 if(iflag.ne.3) go to 110
      if(imp.gt.6) write(io,1008) (jc(k),k=1,nv)
      j0=nt1
      ps=u1*(a(nt1)-eps)
      ment=(nt1-1)*mm1
      do 103 k=1,nv
      jk=ment+jc(k)
  103 ps=ps+xpr(k)*r(jk)
      if(ps.lt.s2) go to 107
      if (imp.gt.0) write(io,1019)
      iflag=1
      return
  107 nv=nv+1
      nc=nc+1
      jc(nv)=j0
      niter=1
      go to 300
  110 if(iflag.le.1) go to 140
c        save the corral of previous call
      do 120 i=1,nt1
  120 ic(i)=0
      do 130 k=1,nv
      jk=jc(k)
  130 ic(jk)=1
      ic(nt1)=1
c           initialize with one feasible gradient
  140 jc(1)=1
      nv=2
      nc=1
      jc(2)=0
      do 150 j=2,nt1
      if(a(j).gt.eps) go to 150
      jc(2)=j
  150 continue
      if(jc(2).gt.0) go to 160
      if (imp.gt.0) write(io,1001)
      iflag=2
      return
  160 j=jc(2)
      rr(1)=1.0d+0
      jj=(j-1)*mm1+j
      ps=1.0d+0+r(jj)
      if (ps.gt.0.0d+0) go to 170
      iflag=3
      return
  170 rr(2)=sqrt(ps)
      r(2)=a(j)
      do 180 i=1,nt1
  180 xpr(i)=0.0d+0
      xpr(1)=eps-a(j)
      xpr(2)=1.0d+0
      u1=0.0d+0
      u2=-r(jj)
      if(imp.gt.6) write(io,1005) j
c
c                 stopping criterion
c
  200 niter=niter+1
      if(imp.gt.6) write(io,1011) (xpr(i),i=1,nv)
      if(niter.le.itmax) go to 205
      if (imp.gt.0) write(io,1016)
      iflag=4
      return
  205 s2=-eps*u1-u2
      if(s2.le.eta) go to 900
      sp=gama*s2
c                    first compute all the tests,
c            and test with the corral of previous call
      j0=0
      do 220 j=2,nt1
      ps=u1*(a(j)-eps)
      do 210 k=1,nv
      jj=jc(k)
      if(jj.eq.1) go to 210
      j1=max(j,jj)
      j2=min(j,jj)
      jj=(j1-1)*mm1+j2
      ps=ps+xpr(k)*r(jj)
  210 continue
      y(j)=ps
      if(iflag.ne.2) go to 220
      if(ic(j).ne.1) go to 220
      if(ps.ge.sp) go to 220
      j0=j
      sp=ps
  220 continue
      if(j0.eq.0) go to 240
      if(sp.ge.gama*s2) go to 240
      ps1=abs(u1*(eps-a(j0)))
      do 230 k=1,nv
      j=jc(k)
      if(j.eq.j0) go to 240
      if(j.eq.1) go to 230
      j1=max(j0,j)
      j2=min(j0,j)
      jj=(j1-1)*mm1+j2
      ps1=ps1+xpr(k)*abs(u1*(2.0d+0*eps-a(j))+2.0d+0*y(j)-r(jj))
  230 continue
      ps1=ps1*1000.0d+0*zero
      if(sp.gt.s2-ps1) go to 240
      ic(j0)=0
      go to 280
c                     now the remaining ones
  240 j0=0
      sp=gama*s2
      do 260 j=2,nt1
      if(iflag.eq.2.and.ic(j).eq.1) go to 260
      if(y(j).ge.sp) go to 260
      sp=y(j)
      j0=j
  260 continue
      if(j0.eq.0) go to 290
      ps1=abs(u1*(eps-a(j0)))
      do 270 k=1,nv
      j=jc(k)
      if(j.eq.1) go to 270
      j1=max(j0,j)
      j2=min(j0,j)
      jj=(j1-1)*mm1+j2
      ps1=ps1+xpr(k)*abs(u1*(2.0d+0*eps-a(j))+2.0d+0*y(j)-r(jj))
  270 continue
      ps1=ps1*1000.0d+0*zero
      if(sp.gt.s2-ps1) go to 290
  280 nc=nc+1
      nv=nv+1
      jc(nv)=j0
      if(imp.gt.6) write(io,1006) s2,j0,sp
      go to 300
c         first set of optimality conditions satisfied
  290 if(u1.ge.-dble(nv)*zero) go to 900
      j0=1
      nv=nv+1
      jc(nv)=1
      if(imp.gt.6) write(io,1020) s2,u1
c
c               augmenting r
c
  300 nv1=nv-1
      do 305 k=1,nv1
      if(jc(k).ne.j0) go to 305
      if (imp.gt.0) write(io,1013) j0
      iflag=3
      return
  305 continue
      j=jc(1)
      j1=max(j,j0)
      j2=min(j,j0)
      jj=(j1-1)*mm1+j2
      r(nv)=(a(j)*a(j0)+e(j)*e(j0)+r(jj))/rr(1)
      ps0=r(nv)*r(nv)
      if(nv1.eq.1) go to 330
      do 320 k=2,nv1
      j=jc(k)
      j1=max(j,j0)
      j2=min(j,j0)
      jj=(j1-1)*mm1+j2
      ps=a(j)*a(j0)+e(j)*e(j0)+r(jj)
      k1=k-1
      do 310 kk=1,k1
      j1=(kk-1)*mm1+k
      j2=(kk-1)*mm1+nv
  310 ps=ps-r(j1)*r(j2)
      mek=k1*mm1+nv
      r(mek)=ps/rr(k)
  320 ps0=ps0+r(mek)*r(mek)
      jj=(j0-1)*mm1+j0
      ps0=a(j0)*a(j0)+e(j0)*e(j0)+r(jj)-ps0
      if (ps0.gt.0.0d+0) go to 330
      iflag=3
      return
  330 rr(nv)=sqrt(ps0)
      if(niter.le.1) go to 400
      incr=1
      k00=nv
c
c          solving the corral-system
c
  400 k=k00
      if(k.gt.nv) go to 430
      if(imp.le.7) go to 410
      write(io,1012) rr(1)
      if(nv.eq.1) go to 410
      do 404 l=2,nv
      k1=l-1
      write(io,1012) (r((kk-1)*mm1+l),kk=1,k1),rr(l)
  404 continue
  410 j=jc(k)
      ps1=a(j)
      ps2=e(j)
      if(k.eq.1) go to 420
      k1=k-1
      do 415 kk=1,k1
      jj=(kk-1)*mm1+k
      ps0=r(jj)
      ps1=ps1-ps0*w1(kk)
  415 ps2=ps2-ps0*w2(kk)
  420 ps0=rr(k)
      w1(k)=ps1/ps0
      w2(k)=ps2/ps0
      k=k+1
      if(k.le.nv) go to 410
c                two-two system
  430 k=1
      if(incr.eq.1) k=nv
  440 w1s=w1s+w1(k)*w1(k)
      w2s=w2s+w2(k)*w2(k)
      w12s=w12s+w1(k)*w2(k)
      k=k+1
      if(k.le.nv) go to 440
      det=w1s*w2s-w12s*w12s
      ps2=w2s*eps-w12s
      ps1=w1s-w12s*eps
  450 v1=ps2/det
      v2=ps1/det
  460 u1=eps-v1
      u2=1.0d+0-v2
      if(nv.eq.nc+1) u1=0.0d+0
c                  backward
      y(nv)=(v1*w1(nv)+v2*w2(nv))/rr(nv)
      if(nv.eq.1) go to 500
      do 480 l=2,nv
      k=nv-l+1
      k1=k+1
      ps=v1*w1(k)+v2*w2(k)
      mek=(k-1)*mm1
      do 470 kk=k1,nv
      mej=mek+kk
  470 ps=ps-r(mej)*y(kk)
  480 y(k)=ps/rr(k)
c
c                test for positivity
c
  500 dmu=-zero*eps
      do 530 k=1,nv
      if(jc(k).eq.1) go to 520
      if(y(k).le.zero) go to 550
      go to 530
  520 if(y(k).le.dmu) go to 550
  530 continue
      do 540 k=1,nv
  540 xpr(k)=y(k)
      go to 200
c           interpolating between x and y
  550 teta=0.0d+0
      k0=k
      do 560 k=1,nv
      if(y(k).ge.0.0d+0) go to 560
      ps=y(k)/(y(k)-xpr(k))
      if(teta.ge.ps) go to 560
      teta=ps
      k0=k
  560 continue
      do 570 k=1,nv
      ps=teta*xpr(k)+(1.0d+0-teta)*y(k)
      if(ps.le.zero) ps=0.0d+0
  570 xpr(k)=ps
      if(imp.le.6) go to 600
      ps1=0.0d+0
      ps2=0.0d+0
      do 580 k=1,nv
      do 580 kk=1,nv
      j1=max(jc(k),jc(kk))
      j2=min(jc(k),jc(kk))
      jj=(j1-1)*mm1+j2
      ps1=ps1+xpr(k)*xpr(kk)*r(jj)
      ps2=ps2+y(k)*y(kk)*r(jj)
  580 continue
c
c                  compressing the corral
c
  600 nv=nv-1
      incr=0
      k00=k0
      w1s=0.0d+0
      w2s=0.0d+0
      w12s=0.0d+0
      l=jc(k0)
      if(l.ne.1) nc=nc-1
      if (imp.gt.6) write(io,1007) k0,l,y(k0),ps1,ps2
      if(k0.gt.nv) go to 400
      k1=k0-1
      do 620 k=k0,nv
      xpr(k)=xpr(k+1)
      if(k0.eq.1) go to 620
      do 610 kk=1,k1
      mek=(kk-1)*mm1+k
  610 r(mek)=r(mek+1)
  620 jc(k)=jc(k+1)
      xpr(nv+1)=0.0d+0
  630 mek=(k0-1)*mm1+k0+1
      ps=r(mek)
      ps12=rr(k0+1)
      ps0=sqrt(ps*ps+ps12*ps12)
      ps=ps/ps0
      ps12=ps12/ps0
      rr(k0)=ps0
      if(k0.eq.nv) go to 400
      k1=k0+1
      mek01=(k0-1)*mm1
      mek=k0*mm1
      mekk=mek-mm1
      do 640 k=k1,nv
      j1=mekk+k
      j2=mek+k
      r(j1)=ps*r(j1+1)+ps12*r(j2+1)
      if(k.gt.k1) r(j2)=ps2
  640 ps2=-ps12*r(j1+1)+ps*r(j2+1)
      r(j2+1)=ps2
      k0=k0+1
      go to 630
c
c                      *** finished ***
c
  900 iflag=0
      do 930 j=1,ntot
  930 al(j)=0.0d+0
      do 940 k=1,nv
      j=jc(k)-1
      if(j.ne.0) al(j)=xpr(k)
  940 continue
      u=u1
      if (imp.le.5) return
      write(io,1014) nc,nv,s2,sp,u1
      write(io,1015) (jc(k),k=1,nv)
      write(io,1018)
      return
      end
