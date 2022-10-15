clear;lines(0);
deff('j=jdrn(n)','j=zeros(n,n);for k=1:n-1;j(k,k+1)=1;end')
A=sysdiag(jdrn(3),jdrn(2),rand(2,2));X=rand(7,7);
A=X*A*inv(X);
[S,P,D,index]=projspec(A);
index   //size of J-block
trace(P)  //sum of dimensions of J-blocks
A*S-(eye()-P)
norm(D^index,1)
