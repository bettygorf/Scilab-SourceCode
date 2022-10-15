function [t]=equil(p,q)
t=chol(q);
[u,s,u]=svd(t*p*t');
s=diag(s);
ll=ones(s)./sqrt(sqrt(s));
t=diag(ll)*u'*t



