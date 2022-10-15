function fac3di(x,y,z,T,A,leg,flags,ebox)
// interactive 3d plot
//!
default_leg='X@Y@Z'
default_flag=[2 1 4]

[lhs,rhs]=argn(0)
if rhs<=0 then  //demo
  deff('[x,y,z]=sph(alp,tet)',[
                      'x=r*cos(alp).*cos(tet)+orig(1)*ones(tet)';
                      'y=r*cos(alp).*sin(tet)+orig(2)*ones(tet)';
                      'z=r*sin(alp)+orig(3)*ones(tet)'])
  r=1;orig=[0 0 0]
  [x1,y1,z1]=eval3dp(sph,[-%pi:0.2:%pi %pi],[0:0.2:%pi %pi])
  [n1,m1]=size(x1)
  r=1/2;orig=[-1 0 0]
  [x2,y2,z2]=eval3dp(sph,[-%pi:0.2:%pi %pi],[0:0.2:%pi %pi]) 
  [n2,m2]=size(x2)
  x=[x1 x2];y=[y1 y2];z=[z1 z2]
  T=35;A=45
  leg=default_leg
  flags=list([2*ones(1,m1) 4*ones(1,m2)],1,4)
  rhs=7
end

xmn=mini(x);xmx=maxi(x)
ymn=mini(y);ymx=maxi(y)
zmn=mini(z);zmx=maxi(z)


select rhs
case 3 then
  T=35;A=45
  flags=default_flag
  leg=default_leg
  ebox=[xmn xmx ymn ymx zmn zmx]
case 5 then
  flags=default_flag
  leg=default_leg
  ebox=[xmn xmx ymn ymx zmn zmx]
case 6 then
    flags=default_flag
    ebox=[xmn xmx ymn ymx zmn zmx] 
case 7 then
  ebox=[xmn xmx ymn ymx zmn zmx] 
case 8 then
  
else error('fac3di(x,y,z [,T,A [,leg [,flags [,ebox]]]])')
end
flags(2)=1;

dr=driver()
if dr=="Pos"|dr=="Fig" then return,end
if dr="X11"|dr=="Rec" then
  deff('[]=c()','xbasc()')
  deff('[]=s()',' ')
else
  deff('[]=c()','xset(''wwpc'')')
  deff('[]=s()','xset(''wshow'')')
end
c();fac3d(x,y,z,T,A,leg,flags,ebox);s()

while %t
  T0=T;A0=A
  [ib,xl,yl]=xclick();
  [xlp,ylp,rect]=xchange(xl,yl,'f2i') 
  xx=rect(3)-rect(1)
  yy=rect(4)-rect(2)
  if ib==2 then break,end
  rep(3)=-1
  while rep(3)==-1 do
    rep=xgetmouse()
    [xl,yl,rr]=xchange(rep(1),rep(2),'f2i')
    T=T0-180*(xl-xlp)/xx;A=A0-180*(yl-ylp)/yy;
    c();fac3d(ebox(1),ebox(3),ebox(5),T,A,leg,[2,flags(2),flags(3)],ebox);s()
  end
  c();fac3d(x,y,z,T,A,leg,flags,ebox);s()
end
