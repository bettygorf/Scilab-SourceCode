// Copyright INRIA

if ~c_link('cfunc') then 
   files=G_make(['/tmp/ex5cI.o','/tmp/ex5c.o'],'ex5c.dll');
   addinter(strcat(files,' '),'cfunc','FuncEx');
end

deff('[z]=f(x,y)','z=x+y');
res=FuncEx(1:3,4:6,f);
if norm(res -feval(1:3,4:6,f)) > %eps then pause,end

res1=FuncEx(1:3,4:6,'fp1');
if norm(res - res1 ) > %eps then pause,end

if ~c_link('fp3') then 
  files=G_make(['/tmp/ex5cm.o'],'ex5cm.dll');
  link(files,'fp3','C') ;
end

res2=FuncEx(1:3,4:6,'fp3');
if norm(res2 -cos(res)) > 100*%eps then pause,end

