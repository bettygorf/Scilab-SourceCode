clear;lines(0);
s=poly(0,'s');z=poly(0,'z');
w=ssrand(1,1,3);
wtf=ss2tf(w);v=[2,3,-1,4];a=v(1);b=v(2);c=v(3);d=v(4);
[horner(wtf,(a*z+b)/(c*z+d)),ss2tf(bilin(w,[a,b,c,d]))]
clean(ss2tf(bilin(bilin(w,[a,b,c,d]),[d,-b,-c,a]))-wtf)
