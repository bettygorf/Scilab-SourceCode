// Copyright INRIA

files=G_make(['/tmp/ex4cI.o'],'ex4c.dll') ;
addinter(files,'cdgemmentry','dgemm');

alfa=2;beta=3;m=3;n=4;C=ones(m,n);k=2;A=ones(m,k);B=ones(k,n);
C1=dgemm(alfa,A,B,beta,C);
if norm(C1-(alfa*A*B+beta*C)) > %eps then pause,end






