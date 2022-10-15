//<s1>=%rir(i,j,s1,s2)
// %rir(i,j,s1,s2) insere la matrice de fractions rationnelles f2 dans la
//matrice de fractions rationnelles s2 pour les indices de lignes
// (de colonnes) i (j).
// s2(i,j)=s1
//!
[s1,s2]=sysconv(s1,s2)
[n,d]=s2(2:3)
[n1,n2]=size(d);
if size(i)<>[-1,-1]; n3=maxi([n1,maxi(i)]); else n3=n1; end;
if size(j)<>[-1,-1]; n4=maxi([n2,maxi(j)]); else n4=n2; end;
d1=ones(n3,n4);
d1(1:n1,1:n2)=d;
n(i,j)=s1(2),d1(i,j)=s1(3)
s1(2)=n;s1(3)=d1;
//end


