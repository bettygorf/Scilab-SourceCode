C/MEMBR ADD NAME=topt2,SSI=0
      subroutine topt2(i,n,x,f,g,izs,rzs,dzs)
c     test de l optimisation a deux niveaux dans blaise
      implicit double precision (a-h,o-z)
      dimension x(2),g(2),dzs(1)
      i=1
      f=(x(1)-dzs(1))**2 + 10* x(2)**2
      g(1)=2*(x(1)-dzs(1))
      g(2)=20*x(2)
      end
