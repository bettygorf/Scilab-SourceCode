function f=%ce(i,j,f)
// %ce(i,j,f) extrait la sous matrice, definie par les indices de lignes
// donnes dans le vecteur i et les indices de colonnes donnes dans le
//vecteur j, de la matrice de  chaines f. i et j peuvent etre des vecteur
// de booleens f(i,j) est alors f(find(i),find(j))
//!
[lhs,rhs]=argn(0)
if rhs==2 then
  if type(i)==4 then i=find(i),end
  f=j(i)
else
  if type(i)==4 then i=find(i),end
  if type(j)==4 then j=find(j),end
  f=f(i,j)
end

//end


