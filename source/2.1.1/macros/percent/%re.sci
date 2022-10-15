//<f>=%re(i,j,f)
// %re(i,j,f) extrait la sous matrice, definie par les indices de lignes
// donnes dans le vecteur i et les indices de colonnes donnes dans le
//vecteur j, de la matrice de fractions rationnelles f.
//!
if type(i)==4 then i=find(i),end
if type(j)==4 then j=find(j),end
if i==[]|j==[] then f=[],return,end
[n,d]=f(2:3)
f(2)=n(i,j);f(3)=d(i,j)
//end


