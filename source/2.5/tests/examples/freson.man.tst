clear;lines(0);
h=syslin('c',-1+%s,(3+2*%s+%s^2)*(50+0.1*%s+%s^2))
fr=freson(h)
bode(h)
g=20*log(abs(repfreq(h,fr)))/log(10)
