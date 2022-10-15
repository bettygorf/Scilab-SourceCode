clear;lines(0);
s=poly(0,'s')
h=syslin('c',(s^2+2*0.9*10*s+100)/(s^2+2*0.3*10.1*s+102.01))
h1=h*syslin('c',(s^2+2*0.1*15.1*s+228.01)/(s^2+2*0.9*15*s+225)) 
[f1,spl]=calfrq(h1,0.01,1000);
rf=repfreq(h1,f1);
plot2d(real(rf)',imag(rf)')
