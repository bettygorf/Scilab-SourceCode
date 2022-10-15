      subroutine frdf1(prosca,n,ntot,ninf,kgrad,
     1 al,q,s,epsn,aps,anc,mm1,r,e,ic,izs,rzs,dzs)
c
      implicit double precision (a-h,o-z)
      external prosca
      dimension al(mm1),q(*),epsn(mm1),aps(mm1),anc(mm1),ic(mm1),s(n),
     1 e(mm1),r(*),izs(*),dzs(*)
      real rzs(*)
c
c              this subroutine reduces a bundle
c              of size ntot in rn
c              to a size no greater than ninf
c
      if(ntot.le.ninf) go to 900
      if (ninf.gt.0) go to 100
c
c           pure gradient method
c
      ntot=0
      kgrad=0
      go to 900
c
c          reduction to the corral
  100 nt1=0
      do 150 j=1,ntot
      if(al(j).eq.0.0d+0 .and. epsn(j).ne.0.0d+0) go to 150
      nt1=nt1+1
      ic(nt1)=j
      if(j.eq.nt1) go to 130
      nj=n*(j-1)
      nn=n*(nt1-1)
      do 110 i=1,n
      nn=nn+1
      nj=nj+1
  110 q(nn)=q(nj)
      al(nt1)=al(j)
      epsn(nt1)=epsn(j)
      aps(nt1)=aps(j)
      anc(nt1)=anc(j)
      e(nt1+1)=e(j+1)
  130 if (epsn(j).eq.0.0d+0) kgrad=nt1
      nn=nt1*mm1+1
      nj=j*mm1+1
      do 140 k=1,nt1
      njk=nj+ic(k)
      nn=nn+1
  140 r(nn)=r(njk)
  150 continue
      ntot=nt1
      if(ntot.le.ninf) go to 900
c
c          corral still too large
c              save the near
c
      call prosca(n,s,s,r(mm1+2),izs,rzs,dzs)
      e(2)=1.0d+0
      z=0.0d+0
      z1=0.0d+0
      z2=0.0d+0
      do 370 k=1,ntot
      z1=z1+al(k)*aps(k)
      z2=z2+al(k)*anc(k)
  370 z=z+al(k)*epsn(k)
      aps(1)=z1
      anc(1)=z2
      epsn(1)=z
      if (ninf.gt.1) go to 400
      ntot=1
      kgrad=0
      do 380 i=1,n
  380 q(i)=s(i)
      go to 900
c                save the gradient
  400 nn=(kgrad-1)*n
      do 470 i=1,n
      nj=n+i
      nn=nn+1
      q(nj)=q(nn)
  470 q(i)=s(i)
      e(3)=1.0d+0
      nn=(mm1+1)*kgrad+1
      r(2*mm1+3)=r(nn)
      call prosca(n,q(n+1),s,r(2*mm1+2),izs,rzs,dzs)
      aps(2)=0.0d+0
      anc(2)=0.0d+0
      epsn(2)=0.0d+0
      kgrad=2
      ntot=2
  900 return
      end
