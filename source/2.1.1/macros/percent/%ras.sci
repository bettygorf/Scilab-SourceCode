function f=%ras(f,m)
// f=%ras(f,m) <=> f = f+m, 
//f: transfer matrix, m : scalar or scalar matrix
//!
[p,q]=size(m);
if p==1&q==1 then f(2)=f(2)+m*f(3);return;end
if p+q=-2 then m=m*eye(f(3));end
f(2)=f(2)+m.*f(3);


