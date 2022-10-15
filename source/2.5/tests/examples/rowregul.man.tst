clear;lines(0);
s=%s;
w=[1/s,0;s/(s^3+2),2/s];
Sl=tf2ss(w);
[Stmp,Ws]=rowregul(Sl,-1,-2);
Stmp('D')     // D matrix of Stmp
clean(ss2tf(Stmp))
