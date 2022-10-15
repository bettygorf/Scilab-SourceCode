//<f>=%rdr(s1,s2)
// %rdr(s1,s2) calcule la division element par element de la matrice de
//fractions rationnelles s1 par la matrice de fractions rationnelles s2
// s1./s2
//!
[s1,s2]=sysconv(s1,s2)
[num,den]=simp(s1(2).*s2(3),s1(3).*s2(2))
f=list('r',num,den,s1(4))
//end


