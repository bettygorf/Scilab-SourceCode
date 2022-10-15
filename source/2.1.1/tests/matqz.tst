Leps=1000*%eps;
//      gschur
a=rand(4,4);b=rand(4,4);[as,bs,qs,zs]=gschur(a,b);
if norm(qs*a*zs-as) > Leps then pause,end
if norm(qs*b*zs-bs ) > Leps then pause,end
//       gspec
b=eye(4,4);[al,be]=gspec(a,b);
if norm(al./be-spec(a) ) > Leps then pause,end
//
clear a
a(8,8)=2;a(1,8)=1;a(2,[2,3,4,5])=[0.3,0.2,4,6];a(3,[2,3])=[-0.2,.3];
a(3,7)=.5;
a(4,4)=.5;a(4,6)=2;a(5,5)=1;a(6,6)=4;a(6,7)=2.5;a(7,6)=-10;a(7,7)=4;
b=eye(8,8);b(5,5)=0;
[al,be]=gspec(a,b);
[bs,as,q,n]=gschur(b,a,'disc');n-4
