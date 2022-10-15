c      
c     SUBROUTINE constr
c      
      subroutine constr(q,qd,param,fmat)
        doubleprecision q(23),qd(23),param(20)
        implicit doubleprecision (t)
        doubleprecision fmat(36,1)
      t2 = sin(q(18))
      t3 = cos(q(14))
      t4 = t2*t3
      t6 = cos(q(18))
      t7 = sin(q(14))
      t8 = cos(q(19))
      t9 = t7*t8
      t10 = t6*t9
      t13 = sin(q(5))
      t14 = sin(q(4))
      t15 = t6*t3
      t16 = param(19)*t15
      t17 = t14*t16
      t19 = t2*t9
      t20 = param(19)*t19
      t21 = t14*t20
      t24 = cos(q(4))
      t25 = param(19)*t4
      t26 = t24*t25
      t29 = param(19)*t10
      t30 = t24*t29
      t33 = cos(q(5))
      t34 = sin(q(19))
      t35 = t7*t34
      t36 = param(19)*t35
      t39 = -q(15)
      t40 = t6*t7
      t43 = t8*t4
      t47 = t34*qd(14)
      t48 = t3*t47
      t50 = t8*qd(19)
      t51 = t7*t50
      t55 = cos(q(10))
      t56 = t14*t55
      t58 = sin(q(10))
      t59 = t58*t33
      t60 = t24*t59
      t67 = -q(16)
      t69 = qd(4)*t56
      t72 = qd(4)*t60
      t76 = t58*t13*qd(5)
      t77 = t14*t76
      t81 = qd(10)*t24*t58
      t84 = t55*t33
      t86 = qd(10)*t14*t84
      t90 = t24*t55
      t91 = qd(4)*t90
      t93 = t14*t59
      t94 = qd(4)*t93
      t97 = t24*t76
      t101 = qd(10)*t14*t58
      t105 = qd(10)*t24*t84
      t108 = t2*t7
      t109 = qd(14)*t108
      t111 = t8*t15
      t112 = qd(14)*t111
      t115 = -qd(16)
      t116 = qd(18)*t15
      t119 = qd(18)*t19
      t122 = t7*t34*qd(19)
      t123 = t6*t122
      t128 = t13*t24*t16
      t131 = t13*t24*t20
      t135 = t13*t14*t25
      t138 = t13*t14*t29
      t174 = t3*t34
      t207 = -qd(17)
      t241 = t58*t13
      t246 = -q(17)
      t264 = t33*qd(5)
      t265 = t58*t264
      t268 = t55*t13*qd(10)
      t281 = -qd(15)
      t286 = t3*qd(19)
      t315 = qd(14)*t40
      t318 = qd(14)*t43
      t321 = qd(18)*t4
      t324 = qd(18)*t10
      t327 = t2*t122
      t333 = q(1)**2
      t336 = q(15)**2
      t337 = q(2)**2
      t340 = q(16)**2
      t341 = q(3)**2
      t344 = q(17)**2
      t345 = param(15)**2
         fmat(6,1) = q(16)-q(12)+param(17)*t4+param(17)*t10
         fmat(13,1) = t13*t17-t13*t21-t13*t26-t13*t30+t33*t36
         fmat(14,1) = q(21)+t39-param(20)*t40+param(20)*t43
         fmat(21,1) = -qd(13)+param(17)*t48+qd(17)+param(17)*t51
         fmat(3,1) = q(2)-q(8)+param(16)*t56+param(16)*t60
         fmat(10,1) = param(18)*t56+param(18)*t60-t25-t29+t67+q(2)
         fmat(18,1) = qd(1)-param(16)*t69-param(16)*t72+param(16)*t77-qd
     +(7)-param(16)*t81-param(16)*t86
         fmat(26,1) = qd(2)+param(18)*t91-param(18)*t94-param(18)*t97-pa
     +ram(18)*t101+param(18)*t105+param(19)*t109-param(19)*t112+t115-par
     +am(19)*t116+param(19)*t119+param(19)*t123
         fmat(29,1) = qd(4)*t128-qd(4)*t131+qd(4)*t135+qd(4)*t138+qd(5)*
     +t33*t17-qd(5)*t33*t21-qd(5)*t33*t26-qd(5)*t33*t30-qd(5)*t13*t36-qd
     +(14)*t13*t14*param(19)*t40-qd(14)*t13*t14*param(19)*t43+qd(14)*t13
     +*t24*param(19)*t108-qd(14)*t13*t24*param(19)*t111+qd(14)*t33*param
     +(19)*t174-qd(18)*t135-qd(18)*t138-qd(18)*t128+qd(18)*t131+qd(19)*t
     +13*t14*param(19)*t7*t34*t2+qd(19)*t13*t24*param(19)*t7*t34*t6+qd(1
     +9)*t33*param(19)*t9
         fmat(32,1) = -param(20)*t7*t47+t207+param(20)*t3*t50+qd(23)
         fmat(35,1) = qd(22)+param(1)*t8*t2*qd(18)+param(1)*t34*qd(19)*t
     +6+param(1)*qd(20)*t2
         fmat(7,1) = q(15)-q(11)+param(17)*t15-param(17)*t19
         fmat(15,1) = q(22)+t67-param(20)*t108-param(20)*t111
         fmat(22,1) = -qd(12)-param(17)*t109+param(17)*t112+qd(16)+param
     +(17)*t116-param(17)*t119-param(17)*t123
         fmat(4,1) = q(3)-q(9)+param(16)*t241
         fmat(11,1) = param(18)*t241-t36+t246+q(3)
         fmat(19,1) = qd(2)+param(16)*t91-param(16)*t94-param(16)*t97-qd
     +(8)-param(16)*t101+param(16)*t105
         fmat(1,1) = q(3)-param(1)*t13
         fmat(8,1) = q(23)-param(1)*t34
         fmat(27,1) = qd(3)+param(18)*t265+param(18)*t268-param(19)*t48+
     +t207-param(19)*t51
         fmat(30,1) = -param(20)*qd(14)*t15-param(20)*qd(14)*t19+t281+pa
     +ram(20)*qd(18)*t108+param(20)*qd(18)*t111-param(20)*t34*t2*t286+qd
     +(21)
         fmat(33,1) = qd(1)+param(1)*t33*t24*qd(4)-param(1)*t13*qd(5)*t1
     +4+param(1)*qd(6)*t24
         fmat(36,1) = qd(21)+param(1)*t8*t6*qd(18)-param(1)*t34*qd(19)*t
     +2+param(1)*qd(20)*t6
         fmat(16,1) = q(23)+t246+param(20)*t174
         fmat(23,1) = -qd(11)-param(17)*t315-param(17)*t318+qd(15)-param
     +(17)*t321-param(17)*t324+param(17)*t327
         fmat(5,1) = q(17)-q(13)+param(17)*t35
         fmat(12,1) = t333-2*q(1)*q(15)+t336+t337-2*q(2)*q(16)+t340+t341
     +-2*q(3)*q(17)+t344-t345
         fmat(24,1) = -param(1)*t50+qd(23)
         fmat(20,1) = qd(3)+param(16)*t265-qd(9)+param(16)*t268
         fmat(2,1) = q(1)-q(7)+param(16)*t90-param(16)*t93
         fmat(9,1) = param(18)*t90-param(18)*t93-t16+t20+t39+q(1)
         fmat(17,1) = qd(3)-param(1)*t264
         fmat(25,1) = qd(1)-param(18)*t69-param(18)*t72+param(18)*t77-pa
     +ram(18)*t81-param(18)*t86+param(19)*t315+param(19)*t318+t281+param
     +(19)*t321+param(19)*t324-param(19)*t327
         fmat(28,1) = 2*qd(1)*q(1)-2*qd(1)*q(15)+2*qd(2)*q(2)-2*qd(2)*q(
     +16)+2*qd(3)*q(3)-2*qd(3)*q(17)-2*qd(15)*q(1)+2*qd(15)*q(15)-2*qd(1
     +6)*q(2)+2*qd(16)*q(16)-2*qd(17)*q(3)+2*qd(17)*q(17)
         fmat(31,1) = -param(20)*qd(14)*t4+param(20)*qd(14)*t10+t115-par
     +am(20)*qd(18)*t40+param(20)*qd(18)*t43+param(20)*t34*t6*t286+qd(22
     +)
         fmat(34,1) = qd(2)+param(1)*t33*t14*qd(4)+param(1)*t13*qd(5)*t2
     +4+param(1)*qd(6)*t14
      end
