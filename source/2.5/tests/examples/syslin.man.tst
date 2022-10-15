clear;lines(0);
A=[0,1;0,0];B=[1;1];C=[1,1];
S1=syslin('c',A,B,C)   //Linear system definition
S1("A")    //Display of A-matrix
S1("X0"), S1("dt") // Display of X0 and time domain
s=poly(0,'s');
D=s;
S2=syslin('c',A,B,C,D)
H1=(1+2*s)/s^2, S1bis=syslin('c',H1)
H2=(1+2*s+s^3)/s^2, S2bis=syslin('c',H2)
S1+S2
[S1,S2]
ss2tf(S1)-S1bis
S1bis+S2bis
S1*S2bis
size(S1)
