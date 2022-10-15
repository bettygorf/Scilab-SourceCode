//<f>=%rxr(s1,s2)
// %rxr(r1,r2) calcule le produit element par element de 2 matrices de
//fractions rationnelles . (r1.*r2)
//!
[s1,s2]=sysconv(s1,s2)
[num,den]=simp(s1(2).*s2(2),s1(3).*s2(3))
f=list('r',num,den,s1(4))
//end


