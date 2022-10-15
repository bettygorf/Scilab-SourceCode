clear;lines(0);
s=poly(0,'s');
h=syslin('c',1/((s+5)*(s+10)*(100+6*s+s*s)*(s+.3)));
[frq,rf]=repfreq(h,0.1,20,0.005);
xbasc(0);
plot2d(frq',phasemag(rf,'c')');
xbasc(1);
plot2d(frq',phasemag(rf,'m')');
