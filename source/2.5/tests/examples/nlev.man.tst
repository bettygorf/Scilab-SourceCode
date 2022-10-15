clear;lines(0);
A=rand(3,3);x=poly(0,'x');
[NUM,den]=nlev(A,'x')
clean(den-poly(A,'x'))
clean(NUM/den-inv(x*eye()-A))
