// Copyright INRIA

files=G_make(['/tmp/ex8fi.o'],'ex8f.dll');
addinter(files,'entrypt','geval')

//Function geval is executed within the interface program 
//ex8fi.f

a_chain='hello';s=poly(0,'s');
deff('[y1,y2,y3]=myfunction(x1,x2)','y1=x1+x2,y2=1+s,y3=a_chain')

x1=1;x2=2;
[y1,y2,y3]=myfunction(x1,x2);

[u,v,w]=geval(x1,x2,myfunction);

if u-y1 > %eps then pause,end
if v-y2<>0 then pause,end
if w<>y3 then pause,end


