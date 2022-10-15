//<s1>=%rlr(s1,s2)
// %rlr(s1,s2) calcule la division a gauche de la matrice de fractions
//rationnelles s1 et de la matrice de fractions rationnelles s2 (s1\s2)
//!
 
[s1,s2]=sysconv(s1,s2)
[n,m]=size(s1(2))
if n<>m then error(43),end
if m*n=1 then
    s1=%rmr(list('r',s1(3),s1(2),s1(4)),s2)
else
    // reduction de s1 sous la forme D1**(-1)* N1 (D1 diagonale)
    p=s1(2)
    s1=s1(3)
    for l=1:n
      [pp,fact]=lcm(s1(l,:))
      p(l,:)=p(l,:).*fact
      s2(l,:)=s2(l,:)*pp
    end
    s1=invr(p)*s2,
end
//end


