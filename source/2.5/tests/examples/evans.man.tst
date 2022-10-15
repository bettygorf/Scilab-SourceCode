clear;lines(0);
H=syslin('c',352*poly(-5,'s')/poly([0,0,2000,200,25,1],'s','c'));
evans(H,100)
P=3.0548543 - 8.8491842*%i;    //P=selected point
k=-1/real(horner(H,P));
Ns=H('num');Ds=H('den');
roots(Ds+k*Ns)     //contains P as particular root
// Another one
xbasc();s=poly(0,'s');n=1+s;
d=real(poly([-1 -2 -%i %i],'s'));
evans(n,d,100);
//
xbasc();n=real(poly([0.1-%i 0.1+%i,-10],'s'));
evans(n,d,80);
