function [Z,H]=GFARE(Sl)
//[Z,H]=GFARE(Sl)
//Generalized Filter Algebraic Riccati Equation
//X = solution , F = gain
//!
//FD.
[A,B,C,D]=Sl(2:5);
S=eye+D'*D;R=eye+D*D';
Si=inv(S);Ri=inv(R);
Ar=A-B*Si*D'*C;
H=[Ar',-C'*Ri*C;
   -B*Si*B',-Ar];
Z=ric_descr(H);
H=-(B*D'+Z*C')*Ri



