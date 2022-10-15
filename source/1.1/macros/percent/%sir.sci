//<f>=%sir(i,j,f2,f)
// %sir(i,j,M,r) insere la matrice de scalaires M dans la matrice de fractions
//rationnelles r pour les indices de lignes (de colonnes) i (j). (r(i,j)=M)
//!
//f(i,j)=f2
[t,n,d]=f(1:3),[ld,cd]=size(d),l=maxi(i),c=maxi(j)
if l>ld then d(ld+1:l,:)=ones(l-ld,cd),ld=l,end
if c>cd then d(:,cd+1:c)=ones(ld,c-cd),end
n(i,j)=f2,[l,c]=size(f2),d(i,j)=ones(l,c)
f=list(t,n,d,f(4))
//end


