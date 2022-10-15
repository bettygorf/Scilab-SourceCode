clear;lines(0);
wss=ssrand(1,1,3);[a,b,c,d]=abcd(wss);
wtf=ss2tf(wss);
x1=ldiv(numer(wtf),denom(wtf),5)
x2=[c*b;c*a*b;c*a^2*b;c*a^3*b;c*a^4*b]
wssbis=markp2ss(x1',5,1,1);
wtfbis=clean(ss2tf(wssbis))
x3=ldiv(numer(wtfbis),denom(wtfbis),5)
