clear;lines(0);
v=ones(1,20);
xbasc();
plot2d1('enn',0,[v';zeros(80,1)],2,'051',' ',[1,-0.5,100,1.5])

[d,n,e]=arl2(v,poly(1,'z','c'),1)
plot2d1('enn',0,ldiv(n,d,100),2,'000')
[d,n,e]=arl2(v,d,3)
plot2d1('enn',0,ldiv(n,d,100),3,'000')
[d,n,e]=arl2(v,d,8)
plot2d1('enn',0,ldiv(n,d,100),5,'000')

[d,n,e]=arl2(v,poly(1,'z','c'),4,'all')
plot2d1('enn',0,ldiv(n(1),d(1),100),10,'000')
