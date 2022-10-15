//<z,zd,u,ar>=exar2()
//<z,zd,u,ar>=exar2()
//
// Exemple de processus ARMAX ( K.J. Astrom)
// On simule une version bidimensionnelle
// de l'exemple exar1();
//!
a=[1,-2.851,2.717,-0.865].*.eye(2,2)
b=[0,1,1,1].*.[1;1];
d=[1,0.7,0.2].*.eye(2,2);
sig=eye(2,2);
ar=armac(a,b,d,2,1,sig);
write(%io(2),"Simulation of the  ARMAX process :");
armap(ar);
u=-prbs_a(300,1,int([2.5,5,10,17.5,20,22,27,35]*100/12));
zd=narsimul(a,b,d,sig,u);
z=narsimul(a,b,d,0.0*sig,u);
write(%io(2),"Least square identification ARX :");
[la,lb,sig,resid]=armax(3,3,zd,u,1,1);
//end


