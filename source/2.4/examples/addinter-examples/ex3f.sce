// Copyright INRIA

scifuncs=['funcf1','funcf2','funcf3','funcf4'];  //Scilab functions
files=G_make(['/tmp/ex3fi.o','/tmp/ex3f.o'],'ex3f.dll');
addinter(strcat(files,' '),'testfentry3',scifuncs);

//matrix (double) created by C function
x1=funcf1();
if norm(x1-matrix((1:5*3),3,5)) > %eps then pause,end

//matrix (int) created by C function
x2=funcf2();
if norm(x2-matrix((1:5*3),3,5)) > %eps then pause,end

//Character string created by C function
x3=funcf3();
if x3<>"Scilab is ..." then pause,end


// all together 

[y1,y2,y3]=funcf4();
if y1<>x3 then pause,end
if norm(y2-x2) > %eps then pause,end
if norm(y3-x1) > %eps then pause,end
