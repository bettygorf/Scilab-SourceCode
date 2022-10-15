// Copyright INRIA

scifuncs=['modstr','stacc'];  //Scilab functions
files=G_make(['/tmp/ex6cI.o','/tmp/ex6c.o'],'ex6c.dll');
addinter(strcat(files,' '),'intex6c',scifuncs);

//a's to o's
x=modstr('gaad');
if x<>'good' then pause,end 

//variable read in Scilab stack
param=1:10;
z=stacc();
if norm(z-param) > %eps then pause,end



