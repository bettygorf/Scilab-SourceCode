clear;lines(0);
x=poly(0,'x');
M=[x;x^2;2+x^3]*[1,x-2,x^4];
[Mu,U,rk]=htrianr(M)
det(U)
M*U(:,1:2)
