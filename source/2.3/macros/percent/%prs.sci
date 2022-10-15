function f=%prs(p,m)
// f=%prs(p,m) <=> f=p/m 
// with p matrix of polynomials, m constant matrix
//!
[l,c]=size(m)
[mp,np]=size(p);
if l==c then 
  f=p*inv(m)
else
  s=poly(0,varn(p))
  f=coeff(p,0)/m
  for k=1:maxi(degree(p))
    f=f+(coeff(p,k)/m)*(s^k)
  end
end
