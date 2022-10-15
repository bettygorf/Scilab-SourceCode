clear;lines(0);
s=poly(0,'s');
h=syslin('c',(s-1)/(1+5*s+s^2+s^3))
xbasc();evans(h)
g=kpure(h)
hf=h/.g(1)
roots(denom(hf))
