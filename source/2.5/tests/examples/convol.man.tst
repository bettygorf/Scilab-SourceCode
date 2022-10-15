clear;lines(0);
x=1:3;
h1=[1,0,0,0,0];h2=[0,1,0,0,0];h3=[0,0,1,0,0];
x1=convol(h1,x),x2=convol(h2,x),x3=convol(h3,x),
convol(h1+h2+h3,x)
p1=poly(x,'x','coeff')
p2=poly(h1+h2+h3,'x','coeff')
p1*p2
