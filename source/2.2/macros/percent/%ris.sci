function f2=%ris(i,j,f2,n)
// %ris(i,j,r,m) insere la matrice de fractions rationnelles r dans la matrice
//de scalaires m pour les indices de lignes (de colonnes) i (j). (m(i,j)=r)
//!
if type(i)==10|type(j)==10 then error(21),end
[l,c]=size(n),
if size(i)<>[-1,-1]; l=maxi([l,maxi(i)]); end;
if size(j)<>[-1,-1]; c=maxi([c,maxi(j)]); end;
d=ones(l,c);
n(i,j)=f2(2),d(i,j)=f2(3)
f2(2)=n;f2(3)=d;



