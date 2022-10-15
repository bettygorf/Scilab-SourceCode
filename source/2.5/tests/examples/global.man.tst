clear;lines(0);
//first: calling environnment and a function share a variable
global a
a=1
deff('y=f1(x)','global a,a=x^2,y=a^2')
f1(2)
a
//second: three functions share variables
deff('initdata()','global A C ;A=10,C=30')
deff('letsgo()','global A C ;disp(A) ;C=70')
deff('letsgo1()','global C ;disp(C)')
initdata()
letsgo()
letsgo1()

