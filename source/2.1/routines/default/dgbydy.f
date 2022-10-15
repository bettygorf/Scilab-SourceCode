C/MEMBR ADD NAME=DGBYDY,SSI=0
      subroutine dgbydy(neq, t, y, s, ml, mu, p, nrowp)
      double precision s, t, p, y
      dimension y(3), s(3), p(nrowp,3)
      p(1,1) = -.040d+0
      p(1,2) = 1.0d+4*y(3)
      p(1,3) = 1.0d+4*y(2)
      p(2,1) = .040d+0
      p(2,2) = -1.0d+4*y(3) - 6.0d+7*y(2)
      p(2,3) = -1.0d+4*y(2)
      p(3,1) = 1.0d+0
      p(3,2) = 1.0d+0
      p(3,3) = 1.0d+0
      return
      end
