clear;lines(0);
deff('[z]=f(x,y)','z=x^2+y^2');
feval(1:10,1:5,f)
deff('[z]=f(x,y)','z=x+%i*y');
feval(1:10,1:5,f)
feval(1:10,1:5,'parab')   //See ffeval.f file
feval(1:10,'parab')
// For dynamic link (see example ftest in ffeval.f)
// you can use the link command (the parameters depend on the machine):
// unix('make ftest.o');link('ftest.o','ftest); feval(1:10,1:5,'ftest') 
