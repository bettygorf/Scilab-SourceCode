function [Er,Ar,Q,Z]=epsfin(E,A)
// Returns the epsilon + finite part of the pencil sE-A
// Z right subspace associated with epsilon and finite part
// For a regular pencil Z spans the right finite eigenspace
// FD & RN (see fineta macro)
[LHS,RHS]=argn(0)
if RHS==1 then [E,A]=pen2ea(E);end
E=pertrans(E);A=pertrans(A);
[Er,Ar,Z,Q]=fineta(E,A);
Er=pertrans(Er);Ar=pertrans(Ar);
Z=pertrans(Z);Q=pertrans(Q);
