// Copyright INRIA

scifuncs=['funcc1','funcc2','funcc3','funcc4'];  //Scilab functions
files=G_make(['/tmp/ex3cI.o','/tmp/ex3c.o'],'ex3c.dll');
addinter(strcat(files,' '),'testcentry3',scifuncs)


//matrix (double) created by C function
x1=funcc1();
if norm(x1-matrix((1:5*3),3,5)) > %eps then pause,end

//matrix (int) created by C function
x2=funcc2();
if norm(x2-matrix((1:5*3),3,5)) > %eps then pause,end

//Character string created by C function
x3=funcc3();
if x3<>"Scilab is ..." then pause,end

// all together 

[y1,y2,y3]=funcc4();
if y1<>x3 then pause,end
if norm(y2-x2) > %eps then pause,end
if norm(y3-x1) > %eps then pause,end


