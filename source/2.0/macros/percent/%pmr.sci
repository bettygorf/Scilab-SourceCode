//[f]=%pmr(p,f)
// %pmr(p,f)  calcule le produit  de la matrice de polynomes  p par la
//matrice de fractions rationnelles f.
//Cette macro correspond a l'operation  p*f
//!
[n2,d2]=f(2:3);
[l1,m1]=size(p);[l2,m2]=size(n2)
//
if mini([l1*m1,l2*m2])=1 then
  num=p*n2,
  den=ones(l1,m1)*d2,
  [num,den]=simp(num,den),
  f(2)=num,
  f(3)=den,
  return,
end;
if m1<>l2 then return,end
//
for j=1:m2,
   y=lcm(d2(:,j))
   for i=1:l1,
    x=0;
      for k=1:m1,
        x=x+p(i,k)*pdiv(y,d2(k,j))*n2(k,j),
      end,
    num(i,j)=x,den(i,j)=y,
  end,
end,
[num,den]=simp(num,den)
f(2)=num,f(3)=den;
//end


