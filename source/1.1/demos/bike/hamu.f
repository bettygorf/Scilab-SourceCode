c      
c     SUBROUTINE hamu
c      
      subroutine hamu(q,qd,u,lambda,p1,p2,param,paramopt,fmat)
        doubleprecision q(23),qd(23),u(2),lambda(20),p1(23),p2(23),param
     +(20),paramopt(4)
        implicit doubleprecision (t)
        doubleprecision fmat(1,2)
      t3 = sin(q(5))
      t5 = -q(18)+q(4)
      t6 = cos(t5)
      t7 = sin(q(14))
      t9 = t3*t6*t7
      t12 = cos(q(5))
      t13 = sin(t5)
         fmat(1,2) = p2(6)-p2(10)
         fmat(1,1) = (-p2(4)*t9-p2(5)*t12*t13*t7+p2(14)*cos(q(14))*t3*t1
     +3+p2(18)*t9)/(sin(q(19))*t3*t6+cos(q(19))*t12)/t7
      end
