function f=%r_x_r(s1,s2)
// %r_x_r(r1,r2)=r1.*r2    r1,r2 rationals
//!
// Copyright INRIA
[s1,s2]=sysconv(s1,s2)
[num,den]=simp(s1(2).*s2(2),s1(3).*s2(3))
f=tlist(['r','num','den','dt'],num,den,s1(4))



