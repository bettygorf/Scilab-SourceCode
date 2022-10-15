clear;lines(0);
a=eye(2,2);b=ones(a);
oldsave('TMPDIR/vals.dat',a,b);
clear a
clear b
oldload('TMPDIR/vals.dat','a','b');
