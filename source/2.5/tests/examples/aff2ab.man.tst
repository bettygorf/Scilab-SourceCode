clear;lines(0);
// Lyapunov equation solver (one unknown variable, one constraint)
deff('Y=lyapunov(X,D)','[A,Q]=D(:);Xm=X(:); Y=list(A''*Xm+Xm*A-Q)')
A=rand(3,3);Q=rand(3,3);Q=Q+Q';D=list(A,Q);dimX=[3,3];
[Aly,bly]=aff2ab(lyapunov,dimX,D);
[Xl,kerA]=linsolve(Aly,bly); Xv=vec2list(Xl,dimX); lyapunov(Xv,D)
Xm=Xv(:); A'*Xm+Xm*A-Q

// Lyapunov equation solver with redundant constraint X=X'
// (one variable, two constraints) D is global variable
deff('Y=ly2(X,D)','[A,Q]=D(:);Xm=X(:); Y=list(A''*Xm+Xm*A-Q,Xm''-Xm)')
A=rand(3,3);Q=rand(3,3);Q=Q+Q';D=list(A,Q);dimX=[3,3];
[Aly,bly]=aff2ab(ly2,dimX,D);
[Xl,kerA]=linsolve(Aly,bly); Xv=vec2list(Xl,dimX); ly2(Xv,D)

// Francis equations
// Find matrices X1 and X2 such that:
// A1*X1 - X1*A2 + B*X2 -A3 = 0
// D1*X1 -D2 = 0 
deff('Y=bruce(X,D)','[A1,A2,A3,B,D1,D2]=D(:),...
[X1,X2]=X(:);Y=list(A1*X1-X1*A2+B*X2-A3,D1*X1-D2)')
A1=[-4,10;-1,2];A3=[1;2];B=[0;1];A2=1;D1=[0,1];D2=1;
D=list(A1,A2,A3,B,D1,D2);
[n1,m1]=size(A1);[n2,m2]=size(A2);[n3,m3]=size(B);
dimX=[[m1,n2];[m3,m2]];
[Af,bf]=aff2ab(bruce,dimX,D);
[Xf,KerAf]=linsolve(Af,bf);Xsol=vec2list(Xf,dimX)
bruce(Xsol,D)

// Find all X which commute with A
deff('y=f(X,D)','y=list(D(:)*X(:)-X(:)*D(:))')
A=rand(3,3);dimX=[3,3];[Af,bf]=aff2ab(f,dimX,list(A));
[Xf,KerAf]=linsolve(Af,bf);[p,q]=size(KerAf);
Xsol=vec2list(Xf+KerAf*rand(q,1),dimX);
C=Xsol(:); A*C-C*A
