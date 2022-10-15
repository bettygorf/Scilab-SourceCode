//<f>=%pir(i,j,f2,f)
// %pir(i,j,f2,f) insere la sous matrice de polynomes f2 dans la
//matrice de fractions rationnelles f1 aux lignes (colonnes)
// designees par i (j). Cette macro correspond a la syntaxe; f(i,j)=f2.
//!
[n,d]=f(2:3),[ld,cd]=size(d),l=maxi(i),c=maxi(j)
if l>ld then d(ld+1:l,:)=ones(l-ld,cd),ld=l,end
if c>cd then d(:,cd+1:c)=ones(ld,c-cd),end
n(i,j)=f2,[l,c]=size(f2),d(i,j)=ones(l,c)
f(2)=n,f(3)=d
//end


