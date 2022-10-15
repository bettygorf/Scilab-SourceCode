function f=%sdr(n1,f2)
// %sdr(M,r) =M./r
//!
if size(n1,'*')==0 then f=[],return,end
f=tlist(['r','num','den','dt'],n1.*f2(3),ones(n1).*f2(2),f2(4))


