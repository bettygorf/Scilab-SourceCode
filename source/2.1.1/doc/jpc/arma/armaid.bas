<la,lb,sig,resid>=narmax(3,3,zd,u,1,1);
la
lb
sig

a=<1,-2.851,2.717,-0.865>;
b=<0,1,1,1>;
d=<1>;
ar=arma(a,b,d,1,1,1);
armap(ar);
u=-prbs(300,1,ent(<2.5,5,10,17.5,20,22,27,35>*100/12));
zd=narsimul(a,b,d,1.0,u);
z=narsimul(a,b,d,0.0,u);
write(%io(2),"Identification ARX (moindre carres):");
<la,lb,sig,resid>=narmax(3,3,zd,u,1,1);
la
lb
sig
<la,lb,sig,resid>=narmax(3,3,z,u,1,1);
la
lb
sig
