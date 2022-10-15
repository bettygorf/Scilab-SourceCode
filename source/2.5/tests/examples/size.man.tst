clear;lines(0);
[n,m]=size(rand(3,2))
[n,m]=size(['a','b';'c','d'])
x=ssrand(3,2,4);[ny,nu]=size(x)
[ny,nu]=size(ss2tf(x))
[ny,nu,nx]=size(x)
