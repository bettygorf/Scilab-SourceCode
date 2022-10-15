clear;lines(0);
Sl=ssrand(2,2,5); trzeros(Sl)       // zeros are invariant:
Sl1=ss2ss(Sl,rand(5,5),rand(2,5),rand(5,2)); 
trzeros(Sl1), trzeros(rand(2,2)*Sl1*rand(2,2))
// output injection [ A + GC, (B+GD,-G)]
//                  [   C   , (D   , 0)]
p=1,m=2,n=2; sys=ssrand(p,m,n);

// feedback (m,n)  first and then output injection.

F1=rand(m,n);
G=rand(n,p);
[sys1,right,left]=ss2ss(sys,rand(n,n),F1,G,2);

// Sl1 equiv left*sysdiag(sys*right,eye(p,p)))

res=clean(ss2tf(sys1) - ss2tf(left*sysdiag(sys*right,eye(p,p))))

// output injection then feedback (m+p,n) 
F2=rand(p,n); F=[F1;F2];
[sys2,right,left]=ss2ss(sys,rand(n,n),F,G,1);

// Sl1 equiv left*sysdiag(sys,eye(p,p))*right 

res=clean(ss2tf(sys2)-ss2tf(left*sysdiag(sys,eye(p,p))*right))

// when F2= 0; sys1 and sys2 are the same 
F2=0*rand(p,n);F=[F1;F2];
[sys2,right,left]=ss2ss(sys,rand(n,n),F,G,1);

res=clean(ss2tf(sys2)-ss2tf(sys1))
