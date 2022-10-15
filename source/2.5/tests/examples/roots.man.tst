clear;lines(0);
p=poly([0,10,1+%i,1-%i],'x');
roots(p)
A=rand(3,3);roots(poly(A,'x'))    // Evals by characteristic polynomial
spec(A) 
