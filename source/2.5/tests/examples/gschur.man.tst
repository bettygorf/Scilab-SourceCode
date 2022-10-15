clear;lines(0);
s=%s;
F=[-1,s,0,0;0,-1,0,0;0,0,2+s,0;0,0,0,-2+s];
roots(det(F))
[E,A]=pen2ea(F);
[As,Es,Z,dim] = gschur(A,E,'c')
// Other example
a=rand(4,4);b=rand(4,4);[as,bs,qs,zs]=gschur(a,b);
norm(qs*a*zs-as)
norm(qs*b*zs-bs )
clear a;
a(8,8)=2;a(1,8)=1;a(2,[2,3,4,5])=[0.3,0.2,4,6];a(3,[2,3])=[-0.2,.3];
a(3,7)=.5;
a(4,4)=.5;a(4,6)=2;a(5,5)=1;a(6,6)=4;a(6,7)=2.5;a(7,6)=-10;a(7,7)=4;
b=eye(8,8);b(5,5)=0;
[al,be]=gspec(a,b);
[bs,as,q,n]=gschur(b,a,'disc');n-4
