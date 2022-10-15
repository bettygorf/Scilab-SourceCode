function [Y,rk,ac]=colcompr(A);
//[Y,rk,ac]=colcompr(A);
//column compression of polynomial matrix A
//(left compression)
//Y = right unimodular base
//rk = normal rank of A
//Ac = A*Y
//see rowcompr
//!
[m,n]=size(A);
[Ac,Y,rk]=htrianr(A);



