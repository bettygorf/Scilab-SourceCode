Leps=1.d-5;
//tests riccati lyapounov sylvester
//
//   lyapunov
a=rand(3,3);x=rand(3,3);x=x*x';c=a'*x+x*a;
if norm(lyap(a,c,'cont')-x) > Leps then pause,end
c=a'*x*a-x;
if norm(lyap(a,c,'disc')-x) > Leps then pause,end
//
//      sylvester
x=rand(3,2);a=rand(3,3);b=rand(2,2);c=a*x+x*b;
if norm(sylv(a,b,c,'cont')-x) > Leps then pause,end
//      riccati
a=rand(3,3);
b=rand(3,2);
c=rand(3,3);c= c*c';r=rand(2,2);r=r*r'+eye;b=b*inv(r)*b';
x=ricc(a,b,c,'cont');
if norm(a'*x+x*a-x*b*x+c ) > Leps then pause,end
aa=[a -b;-c -a'];
[xx,d]=gschur(eye(6,6),aa,'cont');
xx=xx(:,1:d);
if norm(xx(4:6,:)/xx(1:3,:)-x) > Leps then pause,end
[xx,d]=schur(aa,'cont');xx=xx(:,1:d);
if norm(xx(4:6,:)/xx(1:3,:)-x) > Leps then pause,end
//       discrete time case
f=a;b=rand(3,2);g1=b;g2=r;g=g1/g2*g1';h=c;x=ricc(f,g,h,'disc');
if norm(f'*x*f-(f'*x*g1/(g2+g1'*x*g1))*(g1'*x*f)+h-x) > Leps then pause,end
aa=[eye(3,3) g;0*ones(3,3) f'];
bb=[f 0*ones(3,3);-h eye(3,3)];
[xx,d]=gschur(bb,aa,'disc');xx=xx(:,1:d);
if norm(xx(4:6,:)/xx(1:3,:)-x) > Leps then pause,end
fi=inv(f);
hami=[fi fi*g;h*fi f'+h*fi*g];
[xx,d]=schur(hami,'d');xx=xx(:,1:d);
fit=inv(f');
ham=[f+g*fit*h -g*fit;-fit*h fit];
[uu,d]=schur(ham,'d');
uu=uu(:,1:d);
if norm(uu(4:6,:)/uu(1:3,:)-x) > Leps then pause,end
