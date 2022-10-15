//<f1>=%rmp(f1,n2)
// %rmp(f1,n2)  calcule le produit de la  matrice de fractions ration-
//nelles f1 par la matrice de polynomes n2
//Cette macro correspond a l'operation  f1*n2
//!
[n1,d1]=f1(2:3),
[l1,m1]=size(n1);[l2,m2]=size(n2),
//
if mini([l1*m1,l2*m2])=1 then,
  num=n1*n2,
  den=d1*ones(l2,m2),
else,
  if m1<>l2 then error(10),end,
  for i=1:l1,
    n=n1(i,:);
    [y,fact]=lcm(d1(i,:)),
    den(i,1:m2)=ones(1,m2)*y,
      for j=1:m2,
        num(i,j)=n*(n2(:,j).*matrix(fact,l2,1)),
      end,
  end,
end,
[num,den]=simp(num,den),
f1(2)=num;f1(3)=den;
//end


