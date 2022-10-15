function f=%pps(p,s)
// %pps(p,s)  calcule la puissance  s_ieme  d'une matrice
//de polynomes.
//l'exposant s doit etre entier.
//les puissances entieres positives sont definies en fortran.
//!
if int(s)<>s then error('%pps: integer power only'),end
[m,n]=size(p)

if m<>n then 
  if s<0 then
    f=ones(p)./p
    f1=f;for k=2:-s,f=f*f1;end
  end
else
  if s<0 then
    //algorithme de leverrier
    num=eye(n,n)
    for k=1:n-1,
      b=p*num,
      den=-sum(diag(b))/k,
      num=b+eye*den,
    end;
    den=sum(diag(p*num))/n
    //
    [num,den]=simp(num,den*ones(m,n))
    f=list('r',num,den,[])
    if s=-1 then return,end
    f1=f;
    for k=2:-s,f=f*f1;end
  else
    f=p;
    for k=2:s,f=f*p;end
  end
end


