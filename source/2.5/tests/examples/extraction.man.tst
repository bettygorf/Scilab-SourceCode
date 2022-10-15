clear;lines(0);
// MATRIX CASE
a=[1 2 3;4 5 6]
a(1,2)
a([1 1],2)
a(:,1)
a(:,3:-1:1)
a(1)
a(6)
a(:)
a([%t %f %f %t])
a([%t %f],[2 3])
a(1:2,$-1)
a($:-1:1,2)
a($)
//
x='test'
x([1 1;1 1;1 1])
//
b=[1/%s,(%s+1)/(%s-1)]
b(1,1)
b(1,$)
b(2) // the numerator
// LIST OR TLIST CASE
l=list(1,'qwerw',%s)
l(1)
[a,b]=l([3 2])
l($)
x=tlist(l(2:3)) //form a tlist with the last 2 components of l
//
dts=list(1,tlist(['x';'a';'b'],10,[2 3]));
dts(2)('a')
dts(2)('b')(1,2)
[a,b]=dts(2)(['a','b'])

