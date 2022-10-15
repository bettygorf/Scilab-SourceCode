clear;lines(0);
s=poly(0,'s');G=[1/(s-1),s;1,2/s^3];
S1=tf2des(G);S2=tf2des(G,"withD");
W1=des2ss(S1);W2=des2ss(S2);
clean(ss2tf(W1))
clean(ss2tf(W2))
