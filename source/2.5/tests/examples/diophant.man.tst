clear;lines(0);
s=poly(0,'s');p1=(s+3)^2;p2=(1+s);
x1=s;x2=(2+s);
[x,err]=diophant([p1,p2],p1*x1+p2*x2);
p1*x1+p2*x2-p1*x(1)-p2*x(2)
