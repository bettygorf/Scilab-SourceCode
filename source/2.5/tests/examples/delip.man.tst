clear;lines(0);
ck=0.5;
delip([1,2],ck)
deff('y=f(t)','y=1/sqrt((1-t^2)*(1-ck^2*t^2))')
intg(0,1,f)    //OK since real solution!
