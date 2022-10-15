clear;lines(0);

a=rand(3,2);b=[1;1;1];x0=[1;-1];
deff('f=fun(x,a,b)','f=a*x-b');
deff('g=dfun(x,a,b)','g=a');

[f,xopt]=leastsq(fun,x0)      //Simplest call
xopt-a\b  //compare with linear algebra solution

[f,xopt]=leastsq(fun,dfun,x0)      //specify gradient

[f,xopt]=leastsq(list(fun,[1 2;3 4],[1;2]),x0)    

deff('f=fun(x,a,b)','f=exp(a*x)-b');
deff('g=dfun(x,a,b)','g=a.*(exp(a*x)*ones(1,size(a,2)))');

[f,xopt]=leastsq(list(fun,[1 2;3 4],[1;2]),x0)  
