clear;lines(0);
h=syslin('c',-1+%s,3+2*%s+%s^2)
[p,fr]=p_margin(h)  
[p,fr]=p_margin(h+0.7)  
nyquist(h+0.7)
t=(0:0.1:2*%pi)';plot2d(sin(t),cos(t),-3,'000')
