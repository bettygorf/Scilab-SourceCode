clear;lines(0);
hz=iir(3,'bp','ellip',[.15 .25],[.08 .03]);
[hzm,fr]=frmag(hz,256);
plot2d(fr',hzm')
xtitle('Discrete IIR filter band pass  0.15<fr<0.25 ',' ',' ');
q=poly(0,'q');     //to express the result in terms of the ...
hzd=horner(hz,1/q) //delay operator q=z^-1
