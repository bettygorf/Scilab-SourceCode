function f=%rss(f1,n2)
// %rss(f,m)  soustrait la  matrice  de scalaires  m  a la  matrice de
//fractions rationnelles f.
//Cette macro correspond a l'operation  f-m
//!
[n1,d1]=f1(2:3),
[m1,m2]=size(n2)
if m1<0 then n2=n2*eye(n1),end
[n1,d1]=simp(n1-n2.*d1,d1),
f=tlist('r',n1,d1,f1(4)),
//end


