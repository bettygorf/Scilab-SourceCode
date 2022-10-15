function [h,err]=frep2tf(frq,repf,dg)
w=2*%i*%pi*frq
n=prod(size(w))
//initialisation
m=2*dg
a=[0*ones(m+1,m+1)];
err=0
x=ones(1,dg)
//triangularisation 
for k=1:n
  for l=1:dg-1,  x(l+1)=x(l)*w(k),end
  a(m+1,:)=[x repf(k)*[-x x(dg)*w(k)]]
  for k1=1:mini([k,m])
    u=givens(a(k1,k1),a(m+1,k1));
    a([k1,m+1],k1:m+1)=u*a([k1,m+1],k1:m+1);
  end;
//  d=abs(diag(a));print(6,d),
  err=err+a(m+1,m+1)*a(m+1,m+1)'
end;
//test
d=sort(abs(diag(a)));d=d/d(1)
rg=m;while d(rg)<sqrt(%eps) then rg=rg-1,end
if rg<>m then error('estimated maximum degree : '+string(int(rg/2))),end
//solution
x=real(a(1:m,1:m)\a(1:m,m+1))
h=tlist('r',poly(x(1:dg),'s','c'),...
           poly([x((dg+1):m);1],'s','c'),'c')
err=sqrt(err)



