function fac3d(x,y,z,T,A,leg,flags,ebox)
//  fac3d - 3D facets plotting
//CALLING SEQUENCE
//     fac3d(x,y,z,theta,alpha,leg,flag,ebox)
//     fac3d(x,y,z,theta,alpha,leg,[flag,ebox)]
//
//PARAMETERS
//     x,y,z          : matrices of size (facsize,n2).
//                      x(:,i),y(:,i),z(:,i) are the 3D coordinate
//                      of the ith facet

//     theta, alpha   : real values giving in degree the  spherical
//                    coordinates of the observation point
//     leg            : string (captions for  each  axis.  this  is
//                    string with @ as a field separator, for exam-
//                    ple : "X@Y@Z")
//     flag           :  is   a   real   vector   of   size   three
//                    flag=[mode,type,box] or a list of size  three
//                    flag=list(mode,type,box)
//                    mode : string (treatment of hidden parts)
//                         mode >=2
//                              the hidden parts of the surface are
//                              removed  and the surface is painted
//                              in gray (from  low  gray  to  black
//                              according to the value of mode)
//                         mode = 1
//                              the hidden parts of the surface are
//                              drawn
//                         mode <= 0
//                              only the shadow of the  surface  is
//                              painted with a gray level depending
//                              on mode
//                              if flag is a list mode must be a 
//                              vector which specifies patterm for 
//                              each facet
//                    type : scaling
//                         if type = 0 the plot  is  made  using the
//                              current 3D scaling (set by a previous 
//                              call to param3d, plot3d, contour,
//                              plot3d1,fac3d)
//                         si type = 1 the boundaries are specified by
//                              the value of the parameter
//                              ebox=[xmin,xmax,ymin,ymax,zmin,zmax]
//                         else  the boundaries are computed with  the  
//                               given datas.
//                    box  : frame display around the plot.
//                         box=0
//                              nothing is drawn around the plot
//                         box=1
//                              unimplemented ( like box=0 )
//                         box=2
//                              only the axes  behind  the  surface
//                              are drawn
//                         box=3
//                              a box surrounding  the  surface  is
//                              drawn and captions are added
//                         box=4
//                              a box surrounding  the  surface  is
//                              drawn,  captions are added and axes
//                              too.
//DESCRIPTION
//     Draw the surface f(x,y) defined by a set of facet
//EXEMPLE
//%exemples
//
//
//  deff('[x,y,z]=scp(p1,p2)',['x=p1.*sin(p1).*cos(p2)';
//                             'y=p1.*cos(p1).*cos(p2)';
//                             'z=p1.*sin(p2)'])
//  [x,y,z]=eval3dp(scp,0:0.3:2*%pi,-%pi:0.3:%pi)
//  fac3d(x,y,z,35,45,'X@Y@Z')
//
//  deff('[x,y,z]=sph(alp,tet)',[
//                      'x=r*cos(alp).*cos(tet)+orig(1)*ones(tet)';
//                      'y=r*cos(alp).*sin(tet)+orig(2)*ones(tet)';
//                      'z=r*sin(alp)+orig(3)*ones(tet)'])
// r=1;orig=[0 0 0]
// [x1,y1,z1]=eval3dp(sph,[-%pi:0.2:%pi %pi],[0:0.2:%pi])
// r=1/2;orig=[-2 0 0]
// [x2,y2,z2]=eval3dp(sph,[-%pi:0.2:%pi %pi],[0:0.2:%pi])
// fac3d([x1 x2],[y1 y2],[z1 z2],35,45,'X@Y@Z',[2 2 4])
//AUTHOR
//     Serge Steer INRIA 1993
//!
[lhs,rhs]=argn(0)
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
  
else error('fac3d(x,y,z [,T,A [,leg [,flags [,ebox]]]])')
end
flags(2)=1

[n,m]=size(x)
if type(flags)==15 then
  if prod(size(flags(1)))<>m then
    error('# of elements of flags(1) must be equal to # of column of x')
  end
  c=matrix(flags(1),1,m)
  flags=[2 flags(2) flags(3)]
else
  c=ones(1,m)*flags(1)
end

xbasc();plot3d(0,0,0,T,A,leg,flags,ebox)


wid=xget('white')

//Calcul de la "distance" des facettes a l'observateur
ct=cos(T*%pi/180)
st=sin(T*%pi/180)
ca=cos(A*%pi/180)
sa=sin(A*%pi/180)
dist=1000000
zm=ones(1,n)*z/n+dist*sa*ones(1,m)
xm=ones(1,n)*x/n+dist*ca*ct*ones(1,m)
ym=ones(1,n)*y/n+dist*ca*st*ones(1,m)
dm=xm.*xm+ym.*ym+zm.*zm;
xm=[];ym=[];zm=[];
//ordonnancement des facettes selon leur distances
[dm,kdm]=sort(dm);dm=[];kdm=kdm(m:-1:1);
x=x(:,kdm);y=y(:,kdm);z=z(:,kdm);c=c(kdm);;kdm=[]

//Changement de coordonnees
[x,y]=geom3d(x,y,z);
//trace
xfpolys(x,y,(wid+1)*ones(c)+c)

//triedre visible
cn=[[1 3 5];[1 3 6];[1 4 5];[1 4 6];[2 3 5];[2 3 6];[2 4 5];[2 4 6]]
for k=1:8,corners(k,1:3)=ebox(cn(k,:)),end
zm=corners(:,3)+dist*sa*ones(8,1);
xm=corners(:,1)+dist*ca*ct*ones(8,1);
ym=corners(:,2)+dist*ca*st*ones(8,1);
dmc=xm.*xm+ym.*ym+zm.*zm;
xm=[];ym=[];zm=[];
[dmc,kdmc]=sort(dmc);dmc=[];kdmc=kdmc(1)
kk=cn(kdmc,:)
s0=ebox(kk);
vis=[];
for k=1:3
  kk=cn(kdmc,:);
  if 2*int(kk(k)/2)==kk(k) then inc=-1,else inc=1,end;
  kk(k)=kk(k)+inc;
  vis=[vis;[s0;ebox(kk)]];
end
[xv,yv]=geom3d(vis(:,1),vis(:,2),vis(:,3))
xsegs(matrix(xv,2,3),matrix(yv,2,3))






