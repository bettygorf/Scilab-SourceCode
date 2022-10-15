clear;lines(0);
x=poly(0,'x');
p1=(1+x^2)*(1-x);p2=1-x;
[r,q]=pdiv(p1,p2)
p2*q-p1
p2=1+x;
[r,q]=pdiv(p1,p2)
p2*q+r-p1
