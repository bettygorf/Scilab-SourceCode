clear;lines(0);
l=list(1,'qwerw',%s)
[a,b]=getfield([3 2],l)

a=hypermat([2,2,2],rand(1:2^3));// hypermatrices are coded using mlists
a(1) // the a(1,1,1) entry
getfield(1,a) // the mlist first field
