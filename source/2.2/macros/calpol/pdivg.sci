function pdiv(P1,P2)
// Element wise euclidan division of two polynomial matrices
// This is just a loop for pdiv
//!
[n,m]=size(P1);
for l=1:n,
    for k=1:m,
      [rlk,qlk]=pppdiv(P1(l,k),p2),R(l,k)=rlk;Q(l,k)=qlk;
    end;
end



