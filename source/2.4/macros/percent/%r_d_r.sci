function f=%r_d_r(s1,s2)
// f=s1./s2
//!
// Copyright INRIA
[s1,s2]=sysconv(s1,s2)
[num,den]=simp(s1(2).*s2(3),s1(3).*s2(2))
f=tlist(['r','num','den','dt'],num,den,s1(4))



