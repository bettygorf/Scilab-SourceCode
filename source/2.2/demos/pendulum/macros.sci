function []=anim(x,teta,amode,frein)
//anim(x,teta) animated plot
//!
[lhs,rhs]=argn(0)
if rhs <=2, amode =0 ;end
if rhs <=3, frein =1 ;end
maxp=maxi(x+l*sin(teta));minp=mini(x+l*sin(teta));
maxx=maxi([x,maxp]);minx=mini([minp,x])
isoview(minx,maxx,-l,l);
[m,n]=size(x);
xset("alufunction",6);
xset("thickness",2);
if amode=0 then 
  for k=1:n,for j=1:frein,
          xsegs([x(k),x(k)+l*sin(teta(k))],[0, l*cos(teta(k))]);
          xsegs([x(k),x(k)+l*sin(teta(k))],[0, l*cos(teta(k))]);
          end;end
  k=n;xsegs([x(k),x(k)+l*sin(teta(k))],[0, l*cos(teta(k))]);
  xset("alufunction",3);//xpause();
else
 isoview(minx,maxx,-l,l);
 for k=1:n,dpnd1(x(k),teta(k));dpnd1(x(k),teta(k));end;
  xset("alufunction",3);//xpause();
end
xset("thickness",1);


function []=dpnd()
//dpnd() scheme of experiment
//!
isoview(0,100,0,100);
lc=20,
hc=10,
lb=40,
teta=.25,
xg=40,
y1=25,
y2=y1+hc,
yg=y1+hc/2,
x1=xg-lc/2;x2=xg+lc/2,
xpoly([x1 x2 x2 x1 x1],[y1,y1,y2,y2,y1],"lines",1),
xsegs([xg,xg+lb*sin(teta)],[y2,y2+lb*cos(teta)]),
xarc(x1+lc/10-2.5,y1-2.5+2.5,5,5,0,360*64);
xarc(x2-5+lc/10-2.5,y1-2.5+2.5,5,5,0,360*64);
xsegs([10 90],[y1-5 y1-5]); 
xarrows([x2 x2+10],[yg yg],3.0);
xstring(x2+20,yg,'u (force)',0,0);
xset("dashes",1);xsegs([xg xg],[y2 y2+lb]);xstring(xg,y2+lb,' teta',0,0);
xset("default");


function []=dpnd1(x,theta)
//dpnd() scheme
//!
lc=l/4,
hc=l/5,
xg=x,
y1=0,
y2=y1+hc,
yg=y1+hc/2,
x1=xg-lc/2;x2=xg+lc/2,
xpoly([x1 x2 x2 x1 x1],[y1,y1,y2,y2,y1],"lines",1),
xsegs([xg,xg+l*sin(theta)],[y2,y2+l*cos(theta)]),
r=lc/4
xarc(x1+lc/10,y1,r,r,0,360*64);
xarc(x2-r-lc/10,y1,r,r,0,360*64);


function [xdot]=ivpd(t,x)
//ydot=ivpd(t,y) non linear equations of the pendulum
// y=[x;d(x)/dt,teta,d(teta)/dt].
// mb, mc, l must be predefined 
//!
g=9.81;
u=0
qm=mb/(mb+mc)
cx3=cos(x(3))
sx3=sin(x(3))
d=4/3-qm*cx3*cx3
xd4=(-sx3*cx3*qm*x(4)**2+2/(mb*l)*(sx3*mb*g-qm*cx3*u))/d
//
xdot=[x(2);
      (u+mb*(l/2)*(sx3*x(4)**2-cx3*xd4))/(mb+mc);
      x(4);
      xd4]



function [y,xdot]=pendu(x,u)
//[y,xdot]=pendu(x,u) input (u) - output (y) function of the pendulum
//!
g=9.81;
qm=mb/(mb+mc)
cx3=cos(x(3))
sx3=sin(x(3))
d=4/3-qm*cx3*cx3
xd4=(-sx3*cx3*qm*x(4)**2+2/(mb*l)*(sx3*mb*g-qm*cx3*u))/d
//
xdot=[x(2);
      (u+mb*(l/2)*(sx3*x(4)**2-cx3*xd4))/(mb+mc);
      x(4);
      xd4]
//
y=[x(1);
   x(3)]



function [xdot]=regu(t,x)
//xdot=regu(t,x) simulation of the compound system
// pendulum - observer - compensator
//!
xp=x(1:4);xo=x(5:8);
u =-kr*xo   //control
[y,xpd]=pendu(xp,u)
xod=(f-k*h)*xo+k*y+g*u
xdot=[xpd;xod]



