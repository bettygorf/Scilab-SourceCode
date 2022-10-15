c      
c     SUBROUTINE psi
c      
      subroutine psi(q,qd,paramopt,fmat)
        doubleprecision q(23),qd(23),paramopt(4)
        implicit doubleprecision (t)
        doubleprecision fmat(1,1)
      t3 = (q(4)-0.3141593E1/4)**2
      t7 = (q(5)-0.3141593E1/2)**2
      t9 = qd(4)**2
      t11 = qd(5)**2
         fmat(1,1) = paramopt(1)*t3+paramopt(2)*t7+paramopt(3)*t9+paramo
     +pt(4)*t11
      end
