function f=%sqr(s,f)
// %sqr(s,f)  f= s./f
//!
if size(s,'*')==0 then f=[],return,end
f=tlist(['r','num','den','dt'],f(2)./s,f(3).*ones(s),f(4)),



