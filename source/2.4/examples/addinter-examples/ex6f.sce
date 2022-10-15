// Copyright INRIA

scifuncs=['modstr','stacc'];  //Scilab functions
files=G_make(['/tmp/ex6fi.o','/tmp/ex6f.o'],'ex6f.dll');
addinter(strcat(files,' '),'intex6f',scifuncs);

//a's to o's
x=modstr('gaad');
if x<>'good' then pause,end 

//variable read in Scilab stack
param=1:10;
z=stacc();
if norm(z-param) > %eps then pause,end



