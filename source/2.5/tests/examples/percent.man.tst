clear;lines(0);
x1=tlist('x',1,2);
x2=tlist('x',2,3);
deff('x=%xmx(x1,x2)','x=list(''x'',x1(2)*x2(2),x2(3)*x2(3))');
x1*x2
