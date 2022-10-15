function [sl]=imrep2ss(v,deg)
[lhs,rhs]=argn(0)
// hankel
[no,nv]=size(v);
n=nv/2;
ns1=no-1;n2=n-1;
l=1;
h(n,n)=0;
for k=1:n,h(l:l+ns1,:)=v(:,k:k+n2),l=l+no,end;
//factorization
if rhs=1 then [u,h,v,deg]=svd(h);else [u,h,v]=svd(h);end
//extraction
obs=u(:,1:deg);con=h*v(1:deg,:)';
//shift
obstild=obs(no+1:n*no,:);obstild(n*no,deg)=0;
sl=syslin(obs'*obstild,con(1:deg,1),obs(1:no,:))


