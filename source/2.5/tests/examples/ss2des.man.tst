clear;lines(0);
s=poly(0,'s');
G=[1/(s+1),s;1+s^2,3*s^3];Sl=tf2ss(G);
S=ss2des(Sl)
S1=ss2des(Sl,"withD")
Des=des2ss(S);Des(5)=clean(Des(5))
Des1=des2ss(S1)
