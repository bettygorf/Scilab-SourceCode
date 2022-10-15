function [f1,f2,f3,f4,f5]=%re(i,j,f)
// %re(i,j,f) extrait la sous matrice, definie par les indices de lignes
// donnes dans le vecteur i et les indices de colonnes donnes dans le
//vecteur j, de la matrice de fractions rationnelles f.
//!
if type(i)==10 then
  [lhs,rhs]=argn(0)
  if rhs<>2 then  error(21),end
  nams=['num','den','dt']
  for k=1:prod(size(i))
    kf=find(i(k)==nams)
    if kf==[] then error(21),end
    execstr('f'+string(k)+'=j(kf+1)')
  end
  return
end
if type(i)==4 then i=find(i),end
if type(j)==4 then j=find(j),end
if i==[]|j==[] then f=[],return,end
f1=f;
[n,d]=f1(2:3)
f1(2)=n(i,j);f1(3)=d(i,j)
