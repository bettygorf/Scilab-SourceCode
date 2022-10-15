function [iperm,mrepi,profile,ierr]=bandwr(a,b,c,d)
//case 1 : a is a sparse matrix and b is (option) iopt
//case 2 : a is lp, b is ls, c is n the dimension and d is (option) iopt
[lhs,rhs]=argn(0)
if (rhs>4|rhs<1) then error(39), end;
if (rhs<3) then
  if (rhs == 1) then iopt=1;else iopt=b; end;
  [ij,v,mn]=spget(a);v=v';  
  if (sum(a-a') <> 0) then   
    error('The matrix ""a"" must to be symmetric')
  end
  n=mn(1);
  if (size(diag(a),1) < n) then   
    error('There are null terms on the diagonal')
  end
  [lp,la,ls]=m6ta2lpd(ij(:,1)',ij(:,2)',n+1,n);
else
  lp=a;ls=b;n=c;
  if (rhs == 3) then iopt=1;else iopt=d; end;
  v=ones(ls);
end;
if(n < 3) then 
  error('Size too small')
end
nz=size(v,2);
liwork=2*n+2+2*nz+6*n+3;
iwork=zeros(1,liwork);
lrwork=n*n+1;
rwork=zeros(1,lrwork);
iwork(1:(n+1))=lp;
iwork((2*n+2):(2*n+2+nz-1))=ls;
rwork(1:nz)=v;
[iperm,mrepi,profile,ierr]=m6bandred(n,nz,liwork,iwork,lrwork,rwork,iopt);
