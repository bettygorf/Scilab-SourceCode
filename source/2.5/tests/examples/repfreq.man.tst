clear;lines(0);
A=diag([-1,-2]);B=[1;1];C=[1,1];
Sys=syslin('c',A,B,C);
frq=0:0.02:5;w=frq*2*%pi; //frq=frequencies in Hz ;w=frequencies in rad/sec;
[frq1,rep] =repfreq(Sys,frq);
[db,phi]=dbphi(rep);
Systf=ss2tf(Sys)    //Transfer function of Sys
x=horner(Systf,w(2)*sqrt(-1))    // x is Systf(s) evaluated at s = i w(2)
rep=20*log(abs(x))/log(10)   //magnitude of x in dB
db(2)    // same as rep
ang=atan(imag(x),real(x));   //in rad.
ang=ang*180/%pi              //in degrees
phi(2)
repf=repfreq(Sys,frq);
repf(2)-x
