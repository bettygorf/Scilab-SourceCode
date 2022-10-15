c      
c     SUBROUTINE vecfin
c      
      subroutine vecfin(q,qd,u,lambda,p1,p2,param,paramopt,fmat)
        doubleprecision q(23),qd(23),u(2),lambda(20),p1(23),p2(23),param
     +(20),paramopt(4)
        implicit doubleprecision (t)
        doubleprecision fmat(66,1)
      t4 = -0.3141593E1
         fmat(44,1) = 0
         fmat(46,1) = 0
         fmat(66,1) = 0
         fmat(17,1) = 0
         fmat(55,1) = 0
         fmat(61,1) = 0
         fmat(4,1) = 2*paramopt(3)*qd(4)
         fmat(23,1) = 0
         fmat(11,1) = 0
         fmat(56,1) = 0
         fmat(48,1) = 0
         fmat(62,1) = 0
         fmat(63,1) = 0
         fmat(1,1) = 0
         fmat(20,1) = 0
         fmat(8,1) = 0
         fmat(15,1) = 0
         fmat(25,1) = 0
         fmat(28,1) = paramopt(2)*(2*q(5)+t4)
         fmat(31,1) = 0
         fmat(34,1) = 0
         fmat(37,1) = 0
         fmat(40,1) = 0
         fmat(65,1) = 0
         fmat(50,1) = 0
         fmat(5,1) = 2*paramopt(4)*qd(5)
         fmat(12,1) = 0
         fmat(58,1) = 0
         fmat(51,1) = 0
         fmat(57,1) = 0
         fmat(52,1) = 0
         fmat(2,1) = 0
         fmat(47,1) = 0
         fmat(21,1) = 0
         fmat(9,1) = 0
         fmat(16,1) = 0
         fmat(42,1) = 0
         fmat(26,1) = 0
         fmat(29,1) = 0
         fmat(32,1) = 0
         fmat(35,1) = 0
         fmat(38,1) = 0
         fmat(41,1) = 0
         fmat(60,1) = 0
         fmat(64,1) = 0
         fmat(45,1) = 0
         fmat(18,1) = 0
         fmat(6,1) = 0
         fmat(13,1) = 0
         fmat(49,1) = 0
         fmat(53,1) = 0
         fmat(3,1) = 0
         fmat(22,1) = 0
         fmat(10,1) = 0
         fmat(24,1) = 0
         fmat(43,1) = 0
         fmat(59,1) = 0
         fmat(27,1) = paramopt(1)*(4*q(4)+t4)/2
         fmat(30,1) = 0
         fmat(33,1) = 0
         fmat(36,1) = 0
         fmat(39,1) = 0
         fmat(54,1) = 0
         fmat(19,1) = 0
         fmat(7,1) = 0
         fmat(14,1) = 0
      end
