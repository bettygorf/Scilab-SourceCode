Leps=1.e-7;
s=poly(0,'s');
p=(s-1)*(s+1)*(s+2)*(s+10);
a=(s-5)*(s-1)*(s*s)*((s+1/2)**2);
b=(s-3)*(s+2/5)*(s+3);
if residu(p,a,b)+(531863/4410) > Leps then pause,end
z=poly(0,'z');
a=z^3+0.7*z^2+0.5*z-0.3;
b=z^3+0.3*z^2+0.2*z+0.1;
deff('[ptild]=tilde(p,s)','c=coeff(p),n=degree(p)+1,c=c(n:-1:1),...
s=poly(0,s),ptild=0,...
for k=1:n,ptild=ptild+c(k)*s^(k-1),end')
atild=tilde(a,'z');
btild=tilde(b,'z');
if residu(b*btild,z*a,atild)-2.9488038 > Leps then pause,end
a=a+0*%i;b=b+0*%i;
if real(residu(b*btild,z*a,atild)-2.9488038) > Leps then pause,end
