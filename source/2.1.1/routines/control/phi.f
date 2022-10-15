C/MEMBR ADD NAME=PHI,SSI=0
      double precision function phi(tq,nq)
c%but
c calcule la fonction phi
c%
      implicit double precision (a-h,o-y)
      parameter (npara=20,ncoeff=601)
      dimension tq(0:npara),tlq(0:npara), tvq(0:npara)
      common/foncg/tg(0:ncoeff)/degreg/ng
c      common/no2f/aux
c
      call lq(nq,tq,tlq,tvq)
c
      call calsca(nq,tq,tlq,y0)
c
      phi= 1.0d+0 - y0
c
      return
      end
