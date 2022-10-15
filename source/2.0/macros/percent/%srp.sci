function [f]=%srp(m,p)
//f=M/p  M:scalar matrix p=polynomial
//!
if prod(size(p)) <> 1 then f=m*invr(p),return,end
[l,c]=size(m)
f=simp(list('r',m,p*ones(l,c),[]))



