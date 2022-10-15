function [X,F]=GCARE(Sl)
//[X,F]=GCARE(Sl)
//Generalized Control Algebraic Riccati Equation
//X = solution , F = gain
//!
//FD.
[A,B,C,D]=Sl(2:5);
S=eye+D'*D;R=eye+D*D';
Si=inv(S);
Ar=A-B*Si*D'*C;
H=[Ar,-B*Si*B';
   -C'*inv(R)*C,-Ar'];
X=ric_descr(H);
F=-Si*(D'*C+B'*X)



