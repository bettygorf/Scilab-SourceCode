function [Er,Ar,Q,Z]=fineta(E,A)
// Returns Er = Q*E*Z and Ar =Q*A*Z where Er is full column rank,
// and the reduced pencil (Er,Ar) corresponds to the
// "finite + eta" part of the pencil sE-A.
// Q = row (left)-subspace associated with finite + eta part of (E,A).
// For a regular pencil, Q spans the left finite eigenspace
// FD & RN
[LHS,RHS]=argn(0);
if RHS==1 then 
   A=-coeff(E,0);
   E=coeff(E,1);
end
Er=E;Ar=A;
[nr,nc]=size(Er);
Q=eye(nr,nr);Z=eye(nc,nc);
// Starting
[Zp,rk]=colcomp(Er);
if rk==nc;return;end

last=nc+1-rk:nc;first=1:nc-rk;
M=Zp(:,last);Z=Z*M;Er=Er*M;A12=Ar*Zp;
Ar=A12(:,last);A2=A12(:,first);

// Loop
while rk<>nc
   [Q2,r1]=rowcomp(A2);
   top=1:r1;bot=r1+1:nr;
   N=Q2(bot,:);
   Er=N*Er;Ar=N*Ar;
   Q=N*Q;
   [nr,nc]=size(Er);
   [Zp,rk]=colcomp(Er);
   last=nc+1-rk:nc;first=1:nc-rk;
   M=Zp(:,last);Z=Z*M;
   Er=Er*M;A12=Ar*Zp;Ar=A12(:,last);A2=A12(:,first);
end
