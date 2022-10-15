function [Sl1,right,left]=ss2ss(Sl,T,F,G)
// State-space to state-space conversion
// Returns the linear system Sl1=[A1,B1,C1,D1]
// where A1=inv(T)*A*T,B1=inv(T)*B,C1=C*T,D1=D.
// Optional parameters F and G are state feedback
// and output injection respectively. For example,
// Sl1=ss2ss(Sl,T,F) returns Sl1=[A1,B1,C1,D1] with
// A1=inv(T)*(A+B*F)*T;B1=inv(T)*B;C1=(C+D*F)*T;D1=D;
// If F is given as input then right is a non singular 
// linear system such that Sl1=Sl*right. 
// Sl1*invsyslin(right) is a factorization of Sl.
// Idem for left: if F and G are given, Sl1=left*Sl*right.
// Example: Sl=ssrand(2,2,5); trzeros(Sl);
// Sl1=ss2ss(Sl,rand(5,5),rand(2,5),rand(5,2)); 
// trzeros(Sl1), trzeros(rand(2,2)*Sl1*rand(2,2))
// See also : projsl
[A,B,C,D]=abcd(Sl);
[LHS,RHS]=argn(0);
if RHS==2 then
A1=inv(T)*A*T;B1=inv(T)*B;C1=C*T;D1=D
Sl1=syslin(Sl(7),A1,B1,C1,D1);right=eye(A1);left=right;
return
end
if RHS==3 then
A1=A+B*F;C1=C+D*F;
A1=inv(T)*A1*T;B1=inv(T)*B;C1=C1*T;D1=D
Sl1=syslin(Sl(7),A1,B1,C1,D1);
right=syslin(Sl(7),A+B*F,B,F,eye(F*B));
return
end
if RHS==4 then
A1=A+B*F+G*C;C1=C+D*F;B1=B+G*D
A1=inv(T)*A1*T;B1=inv(T)*B1;C1=C1*T;D1=D
Sl1=syslin(Sl(7),A1,B1,C1,D1);
right=syslin(Sl(7),A+B*F,B,F,eye(F*B));
left=syslin(Sl(7),A+B*F,G,C,eye(C*G));
return
end
