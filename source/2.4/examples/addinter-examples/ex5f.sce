// Copyright INRIA

if ~c_link('cfunc') then 
  files=G_make(['/tmp/ex5fI.o','/tmp/ex5f.o'],'ex5f.dll');
  addinter(strcat(files,' '),'cfunc','ffuncex');
end

deff('[z]=f(x,y)','z=x+y');
res=ffuncex(1:3,4:6,f);
if norm(res -feval(1:3,4:6,f)) > %eps then pause,end

res1=ffuncex(1:3,4:6,'fp1');
if norm(res - res1 ) > %eps then pause,end

if ~c_link('fp3') then 
  files=G_make(['/tmp/ex5fm.o'],'ex5fm.dll');
  link(files,'fp3') ;
end

res2=ffuncex(1:3,4:6,'fp3');
if norm(res2 -cos(res)) > 100*%eps then pause,end

