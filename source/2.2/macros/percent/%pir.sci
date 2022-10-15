function f=%pir(i,j,f2,f)
// %pir(i,j,f2,f) insere la sous matrice de polynomes f2 dans la
//matrice de fractions rationnelles f1 aux lignes (colonnes)
// designees par i (j). Cette macro correspond a la syntaxe; f(i,j)=f2.
//!
if type(i)==10 then  // s2('num'),s2('den'),sl('dt')
  [lhs,rhs]=argn(0)
  if rhs<>3 then  error(21),end
  nams=['num','den','dt']
  kf=find(i==nams)
  if kf==[] then error(21),end
  f=f2;kf=kf+1
  if kf==4 then error('inserted element '+i+' has incorrect type'),end
  if size(f(kf))<>size(j) then 
    warning('inserted element '+i+' has inconsistent dimension')
  end
  f(kf)=j
  return
end
[n,d]=f(2:3),[ld,cd]=size(d),l=maxi(i),c=maxi(j)
if l>ld then d(ld+1:l,:)=ones(l-ld,cd),ld=l,end
if c>cd then d(:,cd+1:c)=ones(ld,c-cd),end
n(i,j)=f2,[l,c]=size(f2),d(i,j)=ones(l,c)
f(2)=n,f(3)=d



