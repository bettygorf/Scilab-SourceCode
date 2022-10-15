function f=%s_q_r(s,f)
// %s_q_r(s,f)  f= s./f
//!
// Copyright INRIA
if size(s,'*')==0 then f=[],return,end
f=tlist(['r','num','den','dt'],f(2)./s,f(3).*ones(s),f(4)),



