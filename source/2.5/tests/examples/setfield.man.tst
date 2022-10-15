clear;lines(0);
l=list(1,'qwerw',%s)
l(1)='Changed'
l(0)='Added'
l(6)=['one more';'added']
//

a=hypermat([2,2,2],rand(1:2^3));// hypermatrices are coded using mlists
setfield(3,1:8,a);a // set the filed value to 1:8
