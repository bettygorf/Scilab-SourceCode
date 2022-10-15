C/MEMBR ADD NAME=RESID,SSI=0
      subroutine resid(neq, t, y, s, r, ires)
      double precision r, s, t, y
      dimension y(3), s(3), r(3)
      r(1) = -.040d+0*y(1) + 1.0d+4*y(2)*y(3) - s(1)
      r(2) =  .040d+0*y(1) - 1.0d+4*y(2)*y(3) - 3.0d+7*y(2)*y(2) - s(2)
      r(3) = y(1) + y(2) + y(3) - 1.0d+0
      return
      end
