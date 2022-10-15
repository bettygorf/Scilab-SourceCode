      subroutine feq(nq,t,tq,tqdot)
c!but
c      Etablir la valeur de l'oppose du gradient au point q
c!liste d'appel
c     subroutine feq(nq,t,tq,tqdot)
c     nq . degre du polynome Q ce qui correspond aussi au
c         nombre de coordonnees du point q=(q(0),...,q(nq-1))
c     t  . variable parametrique necessaire a l'execution de
c         la routine lsoda .
c     tq . tableau contenant les coordonnees du point q ou
c         encore les coefficients du polynome Q .
c
c     Sortie :
c     tqdot . tableau contenant les opposes des coordonnees du
c             gradient de la fonction PHI au point q
c!
      implicit double precision (a-h,o-y)
      parameter (ncoeff=601,npara=20)
      dimension tq(0:*),tqdot(0:*)
c
      dimension tlq(0:npara),tvq(0:ncoeff),trti(0:npara)
      common/foncg/tg(0:ncoeff)/degreg/ng
c
      do 199 i=0,nq-1
c
c     -- calcul du terme general --
c
         if (i.eq.0) then
            call lq(nq,tq,tlq,tvq)
            call dpodiv(tvq,tq,ng,nq)
            nv=ng-nq
         else
            ichoix=1
            call mzdivq(ichoix,nv,tvq,nq,tq)
         endif
c
         nr=nq-1
         call tild(nr,tvq(0),trti)
c
         call calsca(nq,tq,trti,y0)
c
c     -- conclusion --
c
         tqdot(i)=-2.0d+0*y0
c
 199  continue
c
      return
      end
