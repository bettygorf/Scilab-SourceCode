function [z,zd,u,ar]=exar1()
//<z,zd,u,ar>=exar1()
//
// Exemple de processus ARMAX ( K.J. Astrom)
// On simule le processus armax caract\'eris\'e par
//    a=<1,-2.851,2.717,-0.865>
//    b=<0,1,1,1>
//    d=<1,0.7,0.2>
// exite par un PRBS
//  z  : version sans bruit (d=0)
//  zd : version bruite
// Et on l'identifie avec armax ( comme le bruit est colore
// armax doit donner des estimateurs biaises)
// Sortie :
//   z,zd,u,ar,  ar est une liste decrivant le processus arma
//               voir arma et armap
//!
a=[1,-2.851,2.717,-0.865]
b=[0,1,1,1]
d=[1,0.7,0.2]
ar=armac(a,b,d,1,1,1);
write(%io(2),"Simulation of the ARMAX process :");
armap(ar);
u=-prbs_a(300,1,int([2.5,5,10,17.5,20,22,27,35]*100/12));
zd=narsimul(a,b,d,1.0,u);
z=narsimul(a,b,d,0.0,u);
write(%io(2),"Least square ARX identification:");
[la,lb,sig,resid]=armax(3,3,zd,u,1,1);



