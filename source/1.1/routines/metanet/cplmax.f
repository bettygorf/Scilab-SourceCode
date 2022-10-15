      subroutine cplmax(alphi,beta,c,deg,ex,hp1,hp2,ihp1,ihp2,imin,
     &     ind,l1,l2,la2,lp2,m1,m2,ma,mm,n,n1dim,ndim,or,
     &     p1w,p2w,pimin,pivw,q,r,s1,s2,sat,x,z)
      implicit doubleprecision (a-h,o-z)
      dimension pivw(ndim),pimin(ndim),p1w(ndim),p2w(ndim)
      integer q(ndim),x(ma),sat(ndim)
      integer m1(ndim),m2(ndim),l1(ndim),l2(ndim),ind(ndim)
      integer deg(ndim),s1(ndim),s2(ndim)
      integer alphi(ndim),beta(ndim),or(ma),ex(ma),lp2(n1dim)
      integer la2(mm)
      dimension c(ma),r(ndim),imin(ndim),ihp1(ndim),ihp2(ndim)
      integer hp1(ndim),hp2(ndim),sortie
      logical modif
      doubleprecision infr
      do 2 l=1,ma
         x(l)=0
 2    continue
      z=0.
      infr=10.e5
      cmax=-1.
      do 5 l=1,ma
         if(c(l).lt.cmax) goto 5
         cmax=c(l)
         lmax=l
    5 continue
      if(cmax.gt.0) goto 10
      return
 10   continue
      do 11 i=1,n
         pivw(i)=cmax/2.
 11   continue
      do 14 i=1,n
         q(i)=0
 14   continue
      do 15 i=1,ndim
         alphi(i)=0
         beta(i)=0
         r(i)=0.
 15   continue
      do 16 i=1,n
         alphi(i)=i
         beta(i)=i
 16   continue
      do 18 i=1,n
         pimin(i)=10.e8
 18   continue
      nnn=n+1
      nnn1=nnn-1
      modif=.true.
 100  continue
      nn1=ndim+1
      call match(beta,c,deg,ex,hp1,hp2,ihp1,ihp2,ind,itmin,l1,l2,
     &     la2,lp2,m1,m2,ma,mm,modif,nnn1,n1dim,ndim,or,p1w,
     &     p2w,pimin,pivw,q,r,s1,s2,sat,sortie,x)
      if (sortie.eq.10) then
         call erro('error 10 in match')
         return
      endif
      if (sortie.eq.20) then
         call erro('error 20 in match')
         return
      endif
      if (sortie.eq.0) goto 900
      if (sortie.eq.2) goto 300
      if (sortie.eq.1) continue
      necl=itmin
      call eclat(alphi,beta,c,ex,imin,ma,mm,modif,
     &     n,ndim,necl,nnn1,or,pimin,pivw,q,r,sat,x)
      goto 100
 300  ncontr=0
 316  continue
      do 318 i=1,nnn1
         if(q(i).ne.0.and.alphi(i).eq.i) goto 320
 318  continue
      if(ncontr.gt.0) goto 350
      if(ncontr.eq.0) goto 900
 320  k=i
      ncontr=ncontr+1
      pimin(nnn)=pivw(i)
      imin(nnn)=i
      alphi(nnn)=nnn
      beta(nnn)=nnn
 330  l=q(i)
      x(l)=0
      alphi(i)=nnn
      j=or(l)
      j=beta(j)
      j1=ex(l)
      j1=beta(j1)
      if(j.eq.i)j=j1
      if(pivw(j).lt.pimin(nnn))imin(nnn)=j
      if(pivw(j).lt.pimin(nnn))pimin(nnn)=pivw(j)
      i=j
      if(i.eq.k) goto 340
      goto 330
 340  pivw(nnn)=pimin(nnn)
      q(nnn)=0
      nnn=nnn+1
      goto 316
 350  nnn1=nnn-1
      do 366 i=1,nnn1
         ib=beta(i)
         if(ib.eq.0)goto 366
         beta(i)=alphi(ib)
 366  continue
      modif=.true.
      do 410 i=1,nnn1
         r(i)=infr
 410  continue
      do 480 i=1,n
         if(alphi(i).ne.i) goto 425
         r(i)=0
         goto 480
 425     continue
         r(i)=0.
         ii=i
 430     continue
         i1=alphi(ii)
         if(i1.eq.ii)goto 445
         r(i)=r(i)+pivw(ii)-pimin(i1)
         if(r(i1).lt.infr)goto 440
         ii=i1
         goto 430
 440     continue
         r(i)=r(i)+r(i1)
 445     continue
         ii=i
 460     continue
         i1=alphi(ii)
         if(i1.eq.ii)goto 480
         if(r(i1).lt.infr)goto 480
         r(i1)=r(ii)-pivw(ii)+pimin(i1)
         ii=i1
         goto 460
 480  continue
      goto 100
 900  if(nnn1.eq.n) goto 950
      do 910 necl1=n+1,nnn1
         necl=nnn1+n+1-necl1
         if(beta(necl).eq.0) goto 910
         call eclat(alphi,beta,c,ex,imin,ma,ma,modif,
     &        n,ndim,necl,nnn1,or,pimin,pivw,q,r,sat,x)
 910  continue
 950  continue
      z=0.
      do 960 l=1,ma
         if(x(l).eq.2) z=z+c(l)-r(or(l))-r(ex(l))
 960  continue
      modif=.true.
 999  return
      end
