function f=%rsp(f1,n2)
// %rsp(r,p) soustrait la matrice de polynomes p a la matrice de fractions
//rationnelles r. (r-p)
//!
[n1,d1]=f1(2:3)
[n1,d1]=simp(n1-n2.*d1,d1)
f=tlist('r',n1,d1,f1(4))



