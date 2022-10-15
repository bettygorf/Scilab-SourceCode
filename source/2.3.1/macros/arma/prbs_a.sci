function [u]=prbs_a(n,nc,ids)
//<u>=prbs_a(n,nc,[ids])
// Tirage de PRBS
// tirage de u=<u0,u1,...,u_(n-1)>;
// a valeurs dans {-1,1} et changeant nc fois de signe
// au plus.
// Si on veut fixer les dates de changement de signe on peut
// fournir une variable de plus ids qui est un vecteur
// donnant les indices de changement de signe de u (ordre quelconque)
//!
[lhs,rhs]=argn(0)
if rhs <=2,
  rand('uniform');
  yy= int(mini(maxi(n*rand(1,nc),1*ones(1,nc)),n*ones(1,nc)));
  ids=sort(yy);ids=[n,ids,1];
else
  [n1,n2]=size(ids);
  ids=[n,mini(n*ones(ids),maxi(sort(ids),1*ones(ids))),1];
end
u=0*ones(1,n);
[n1,n2]=size(ids);
val=1;
for i=1:n2-1,
        if ids(i)<>ids(i+1);
        u(ids(i+1):ids(i))=val*ones(ids(i+1):ids(i));val=-1*val;
       end
end



