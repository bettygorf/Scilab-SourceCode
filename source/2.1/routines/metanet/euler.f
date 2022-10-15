      subroutine euler(eul,alpho,la2,lp2,ls2,ma,ma1,mm,n,phiw,sigma)
      implicit integer (a-z)
      dimension lp2(*),ls2(mm),la2(mm)
      dimension sigma(ma1)
      dimension alpho(n),phiw(n)
      nsi=0
      eul=1
      do 5 i=1,n
         deg = (lp2(i+1)-lp2(i))
         if((deg-(deg/2)*2).eq.0) goto 5
         nsi=nsi+1
         if(nsi.gt.2)goto 7
    5 continue
      if(nsi.ne.1) goto 10
    7 continue
      eul=0
      return
 10   continue
      ia=0
      ib=0
      do 20 i=1,n
         alpho(i)=lp2(i+1)-lp2(i)
         deg=alpho(i)
         if((deg-(deg/2)*2).eq.0)goto 20
         if(ia.eq.0) goto 15
         ib=i
         goto 20
 15      continue
         ia=i
 20   continue
      if(ia.ne.0)goto 25
      ia=1
      ib=1
 25   continue
      do 30 u=1,ma1
         sigma(u)=0
 30   continue
      nu=0
      uu=ma+1
      do 50 i=1,n
         phiw(i)=0
 50   continue
      phiw(ia)=ma+1
      uuu=-1
      i=ia
      t=ib
 100  continue
      if(alpho(i).eq.0) goto 300
      ll=lp2(i)+alpho(i)-1
      u=la2(ll)
      alpho(i)=alpho(i)-1
      if(u.eq.uu.or.sigma(u).ne.0) goto 100
      j=ls2(ll)
      phiw(j)=u
      sigma(uu)=u
      nu=nu+1
      i=j
      if(i.eq.t) goto 200
      uu=u
      goto 100
 200  continue
      sigma(u)=uuu
      if(nu.eq.ma) return
 300  continue
      do 310 k=1,n
         if(alpho(k).ne.0.and.phiw(k).ne.0) goto 320
 310  continue
 320  continue
      i=k
      t=k
      uu=phiw(i)
      uuu=sigma(uu)
      goto 100
      end
