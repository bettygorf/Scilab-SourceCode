Leps=1.e-10;
//test for flts
 a=[1 2 3;
    0 2 4
    0 0 1];
 b=[1 0;0 0;0 1];
 c=eye(3,3);
//
 s=syslin('d',a,b,c);
 h=ss2tf(s);
 u=[1;-1]*(1:10);
//
 yh=flts(u,h); ys=flts(u,s);
if norm(yh-ys)> Leps then pause,end
//hot restart
 [ys1,x]=flts(u(:,1:4),s);ys2=flts(u(:,5:10),s,x);
  if norm([ys1 ys2]-ys)>sqrt(%eps) then pause,end
  yh1=flts(u(:,1:4),h);yh2=flts(u(:,5:10),h,[u(:,2:4); yh(:,2:4)]);
  if norm([yh1 yh2]-yh)>sqrt(%eps) then pause,end
//d<>0
 d=[-3 8;4 -0.5;2.2 0.9];
 s=syslin('d',a,b,c,d);
 h=ss2tf(s);
 u=[1;-1]*(1:10);
//
 rh=flts(u,h); rs=flts(u,s);
if norm(rh-rs) > Leps then pause,end
//hot restart
 [ys1,x]=flts(u(:,1:4),s);ys2=flts(u(:,5:10),s,x);
  if norm([ys1 ys2]-rs)>sqrt(%eps) then pause,end
  yh1=flts(u(:,1:4),h);yh2=flts(u(:,5:10),h,[u(:,2:4); yh1(:,2:4)]);
  if norm([yh1 yh2]-rh)>sqrt(%eps) then pause,end
