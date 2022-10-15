clear;lines(0);
W=ssrand(2,3,4);   //random system with 2 outputs and 3 inputs
[a,b,c,d]=abcd(W);
markpar=[c*b,c*a*b,c*a^2*b,c*a^3*b,c*a^4*b];
S=markp2ss(markpar,5,2,3);
[A,B,C,D]=abcd(S);
Markpar=[C*B,C*A*B,C*A^2*B,C*A^3*B,C*A^4*B];
norm(markpar-Markpar,1)
//Caution... c*a^5*b is not C*A^5*B !
