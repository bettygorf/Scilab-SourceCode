function [f]=%ras(f,m)
// f=%ras(f,m) <=> f = f+m
//!
[p,q]=size(m);
if p+q=-2 then m=m*eye(f(3)); end;
if p*q=1 then f(2)=f(2)+m*f(3);return;end
f(2)=f(2)+m.*f(3)


