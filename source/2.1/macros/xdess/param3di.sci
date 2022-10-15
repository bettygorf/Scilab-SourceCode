function param3di(x,y,z,T,A,leg,flags,ebox)
// interactive 3d parametric plot
//!
default_leg='X@Y@Z'
default_flag=[1 4]

[lhs,rhs]=argn(0)
if rhs<=0 then  //demo
  t=0:0.1:5*%pi;

  x=t.*sin(t)^5
  y=t.*cos(t)^3
  z=t
  rhs=3
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
else error('param3di(x,y,z [,T,A [,leg [,flags [,ebox]]]])')
end
flags(1)=1;
param3d(x,y,z,T,A,leg,flags,ebox)

dr=driver()
if dr=="Pos"|dr=="Fig" then return,end
if dr="X11"|dr=="Rec" then
  deff('[]=c()','xbasc()')
  deff('[]=s()',' ')
else
  deff('[]=c()','xset(''wwpc'')')
  deff('[]=s()','xset(''wshow'')')
end
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
    c();param3d(x,y,z,T,A,leg,flags,ebox);s()
  end
end









