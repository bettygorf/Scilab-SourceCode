function [f]=%rap(f,m)
// %rap(f,m) <=> f=f+p
//!
if prod(size(m))==1 then num=f(2)+m*f(3)
     else num=f(2)+m.*f(3);end
[num,den]=simp(num,f(3))
f(2)=num;f(3)=den


