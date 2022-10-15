clear;lines(0);
s=poly(0,'s');
h=syslin('c',(s-1)/(s^3+5*s+20))
frq=0:0.05:3;repf=repfreq(h,frq);
clean(frep2tf(frq,repf,3))

Sys=ssrand(1,1,10); 
frq=logspace(-3,2,200);
[frq,rep]=repfreq(Sys,frq);  //Frequency response of Sys
[Sys2,err]=frep2tf(frq,rep,10);Sys2=clean(Sys2)//Sys2 obtained from freq. resp of Sys
[frq,rep2]=repfreq(Sys2,frq); //Frequency response of Sys2
xbasc();bode(frq,[rep;rep2])   //Responses of Sys and Sys2
[sort(trzeros(Sys)),sort(roots(Sys2('num')))]  //zeros
[sort(spec(Sys('A'))),sort(roots(Sys2('den')))] //poles

dom=1/1000; // Sampling time 
z=poly(0,'z');
h=syslin(dom,(z^2+0.5)/(z^3+0.1*z^2-0.5*z+0.08))
frq=(0:0.01:0.5)/dom;repf=repfreq(h,frq);
[Sys2,err]=frep2tf(frq,repf,3,dom);
[frq,rep2]=repfreq(Sys2,frq); //Frequency response of Sys2
xbasc();plot2d1("onn",frq',abs([repf;rep2])');

