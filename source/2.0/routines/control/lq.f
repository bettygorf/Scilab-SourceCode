      subroutine lq(nq,tq,tlq,tvq)
c!but
c     cette routine calcule a  partir de g(z) et q(z) le
c       polynome Lq(z) defini comme le reste , tilde , de la division
c       par q(z) du produit g(z) par le tilde de q(z) .
c!liste d'appel
c     Entree :
c        tg . tableau des coefficients de la fonction g .
c        ng . degre du polynome g
c        tq . tableau des coefficients du polynome q
c        nq . degre du polynome q
c
c     Sortie :
c        tlq . tableau du polynome Lq de dimension au plus nq-1
c        tvq . tableau du polynome quotient vq de la division par
c           q du polynome gqti .
c!
      parameter (npara=20,ncoeff=601)
      implicit double precision (a-h,o-z)
      dimension tq(0:*),tlq(0:*),tvq(0:ng)
c
      dimension tqti(0:npara),tgqti(0:ncoeff+npara),trq(0:npara)
      common/foncg/tg(0:ncoeff)/degreg/ng
c
      call tild (nq,tq,tqti)
      call dpmul1(tg,ng,tqti,nq,tgqti)
      ngq=ng+nq
      call dpodiv(tgqti,tq,ngq,nq)
c     call divpol (ngq,tgqti,nq,tq)
c
      do 20 j=nq-1,0,-1
         trq(j)=tgqti(j)
 20   continue
c
      do 30 j=ng+nq,nq,-1
         tvq(j-nq)=tgqti(j)
 30   continue
c
      nrq=nq-1
      call tild (nrq,trq,tlq)
c
      return
      end
