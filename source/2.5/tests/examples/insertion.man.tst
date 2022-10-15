clear;lines(0);
// MATRIX CASE
a=[1 2 3;4 5 6]
a(1,2)=10
a([1 1],2)=[-1;-2]
a(:,1)=[8;5]
a(1,3:-1:1)=[77 44 99]
a(1)=%s
a(6)=%s+1
a(:)=1:6
a([%t %f],1)=33
a(1:2,$-1)=[2;4]
a($:-1:1,1)=[8;7]
a($)=123
//
x='test'
x([4 5])=['4','5']
//
b=[1/%s,(%s+1)/(%s-1)]
b(1,1)=0
b(1,$)=b(1,$)+1
b(2)=[1 2] // the numerator
// LIST OR TLIST CASE
l=list(1,'qwerw',%s)
l(1)='Changed'
l(0)='Added'
l(6)=['one more';'added']
//
//
dts=list(1,tlist(['x';'a';'b'],10,[2 3]));
dts(2)('a')=33
dts(2)('b')(1,2)=-100
