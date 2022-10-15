clear;lines(0);
h=syslin('c',-1+%s,3+2*%s+%s^2)
[g,fr]=g_margin(h)
[g,fr]=g_margin(h-10)
nyquist(h-10)
