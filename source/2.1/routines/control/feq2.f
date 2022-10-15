      subroutine feq2(nq,t,tq,tqdot)
c!but
c     Cette subroutine a ete implemente pour les besoins
c     de la procedure DEGRE1 qui recherche les maxima.
c     Elle ne fait qu'inverser le signe des derivees 1eres
c     fournies par FEQ.
c!
      implicit double precision (a-h,o-y)
      dimension tq(0:*),tqdot(0:*)
c
      call feq(nq,t,tq,tqdot)
      do 10 i=0,nq-1
         tqdot(i)=-tqdot(i)
 10   continue
c
      return
      end
