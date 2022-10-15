clear;lines(0);
//Real case: 1x1 and 2x2 blocks
a=rand(5,5);[ab,x,bs]=bdiag(a);ab
//Complex case: complex 1x1 blocks
[ab,x,bs]=bdiag(a+%i*0);ab
