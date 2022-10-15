// Copyright INRIA

files=G_make(['/tmp/ex7fi.o'],'ex7f.dll');
addinter(files,'intex7','pipo');

//pipo(2) ==> error  since g_abs is not defined

deff('z=g_abs(x)','z=abs(x)+a')    //Now g_abs is defined

a=33;
y=pipo(33)-34;   //goes into Fortran interface ex7fi which calls g_abs
if y<>32 then pause,end



