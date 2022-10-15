clear;lines(0);
n=50;
a=rand(n,n,'u');
fprintfMat(TMPDIR+'/Mat',a,'%5.2f');
a1=fscanfMat(TMPDIR+'/Mat');
