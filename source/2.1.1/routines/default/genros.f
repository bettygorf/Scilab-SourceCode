      subroutine genros(ind,n,x,f,g,izs,rzs,dzs)
c     Example of cost function given by a subroutine
c     if n<=2 returns ind=0
c     f.bonnans, oct 86
      implicit double precision (a-h,o-z)
      real rzs(1)
      double precision dzs(*)
      dimension x(n),g(n),izs(*)
      common/nird/nizs,nrzs,ndzs
      if (n.lt.3) then
        ind=0
        return
      endif
      if(ind.eq.10) then
         nizs=2
         nrzs=1
         ndzs=2
         return
      endif
      if(ind.eq.11) then
         izs(1)=5
         izs(2)=10
         dzs(2)=100.0d+0
         return
      endif
      if(ind.eq.2)go to 5
      if(ind.eq.3)go to 20
      if(ind.eq.4)go to 5
      ind=-1
      return
5     f=1.0d+0
      do 10 i=2,n
        im1=i-1
10      f=f + dzs(2)*(x(i)-x(im1)**2)**2 + (1.0d+0-x(i))**2
      if(ind.eq.2)return
20    g(1)=-4.0d+0*dzs(2)*(x(2)-x(1)**2)*x(1)
      nm1=n-1
      do 30 i=2,nm1
        im1=i-1
        ip1=i+1
        g(i)=2.0d+0*dzs(2)*(x(i)-x(im1)**2)
30      g(i)=g(i) -4.0d+0*dzs(2)*(x(ip1)-x(i)**2)*x(i) - 
     &        2.0d+0*(1.0d+0-x(i))
      g(n)=2.0d+0*dzs(2)*(x(n)-x(nm1)**2) - 2.0d+0*(1.0d+0-x(n))
      return
      end
