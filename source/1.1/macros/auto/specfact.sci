function [w0,l]=specfact(a,b,c,d)
r=d+d',w0=sqrt(d),
p=ricc(a-b/r*c,b/r*b',-c'/r*c,'cont')
l=w0\(c+b'*p)



