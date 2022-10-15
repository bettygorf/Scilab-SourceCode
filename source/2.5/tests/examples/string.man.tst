clear;lines(0);
string(rand(2,2))
deff('y=mymacro(x)','y=x+1')
[out,in,text]=string(mymacro)
x=123.356; 'Result is '+string(x)
