function f=%s_d_r(n1,f2)
// %s_d_r(M,r) =M./r
//!
// Copyright INRIA
if size(n1,'*')==0 then f=[],return,end
f=tlist(['r','num','den','dt'],n1.*f2(3),ones(n1).*f2(2),f2(4))


