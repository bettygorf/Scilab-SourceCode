C/MEMBR ADD NAME=APLUSP,SSI=0
      subroutine aplusp(neq, t, y, ml, mu, p, nrowp)
      double precision p, t, y
      dimension y(3), p(nrowp,3)
      p(1,1) = p(1,1) + 1.0d+0
      p(2,2) = p(2,2) + 1.0d+0
      return
      end
