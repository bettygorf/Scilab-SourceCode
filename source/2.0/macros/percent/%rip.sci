function f2=%rip(i,j,f2,n)
// %rip(i,j,f2,p) insere la matrice de fractions rationnelles f2 dans la
//matrice de polynomes p pour les indices de lignes (de colonnes) i (j).
// p(i,j)=f2
//!
[l,c]=size(n),
if size(i)<>[-1,-1]; l=maxi([l,maxi(i)]); end;
if size(j)<>[-1,-1]; c=maxi([c,maxi(j)]); end;
d=ones(l,c);
n(i,j)=f2(2),d(i,j)=f2(3)
f2(2)=n;f2(3)=d;
//end


