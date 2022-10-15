exec startup.sce
[p,q]=fmexfunction1(1,2);
if q~=2 then pause;end
[p,q,r,s,t]=fmexfunction2([1;2],[3,4]);
if norm(s-[9 12])~=0 then pause;end
