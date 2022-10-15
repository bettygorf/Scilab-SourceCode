function s1=%r_q_r(s1,s2)
// %r_q_r(s1,s2) <=> s1= s1.\s2   for rationals
//!
// Copyright INRIA
[s1,s2]=sysconv(s1,s2)
[num,den]=simp(s1(3).*s2(2),s1(2).*s2(3))
s1(2)=num;s1(3)=den;



