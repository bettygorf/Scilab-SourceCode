host('make /tmp/dgemmint.o');
dgemmo=SCI+'/routines/lapack/dgemm.o';
addinter(['/tmp/dgemmint.o',dgemmo],'dgemmentry','dgemm') ;

alfa=2;beta=3;m=3;n=4;C=ones(m,n);k=2;A=ones(m,k);B=ones(k,n);
C1=dgemm(alfa,A,B,beta,C);
C1-(alfa*A*B+beta*C)




