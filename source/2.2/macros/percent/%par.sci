function [f]=%par(m,f)
// %par(m,f)  <=> f=m+p 
//!
if prod(size(m))==1 then f=tlist(f(1),f(2)+m*f(3),f(3),f(4));return;end
f=tlist(f(1),f(2)+m.*f(3),f(3),f(4))


