function f=%s_r_r(m,f)
// %s_r_r(m,r) <=> m/f   constant/rational
//!
// Copyright INRIA
if prod(size(f(2)))<>1 then f=m*invr(f),return,end
[l,c]=size(m);
f=simp(tlist(['r','num','den','dt'],m*f(3),ones(l,c)*f(2),f(4)))



