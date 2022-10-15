s=poly(0,'s')
n=1+s;
d=real(poly([-1 -2 -%i %i],'s'))
evans(n,d,100);
n=real(poly([0.1-%i 0.1+%i,-10],'s'))
evans(n,d,80);
 
 
