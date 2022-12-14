function showinstr(mac)
if type(mac)==11 then
  [in,out,txt]=string(mac)
  x_message(txt)
end


function [X,Y]=field(x,y)
// x and y are two vectors defining a grid
// X and Y are two matrices which gives the grid point coordinates
//-------------------------------------------------------------
// Copyright INRIA
[rx,cx]=size(x);
[ry,cy]=size(y);
if rx<>1, write(%io(2),"x must be a row vector");return;end;
if ry<>1, write(%io(2),"y must be a row vector");return;end;
X=x.*.ones(cy,1);
Y=y'.*.ones(1,cx);

function plot3d3(x,y,z,vect,T,A,leg,flags,ebox)
// mesh draw of a solid surface described 
// by a set of points ( as in the plot3d2 macro : see below ) 
// the mesh is drawn using the colums and rows of [x,y,z]
//---------------------------------------------------------
// Copyright INRIA
[lhs,rhs]=argn(0);
if rhs <= 3; vect=-1;end
if rhs >= 4 & vect<>-1 
  nobjs=prod(size(vect))+1;
  [rx,cx]=size(x);
  vect1=[0,vect,rx];
  xx=[],yy=[],zz=[];
  for i=1:nobjs; 
    xx=[x(vect1(i)+1:vect1(i+1),:),xx]
    yy=[y(vect1(i)+1:vect1(i+1),:),yy]
    zz=[z(vect1(i)+1:vect1(i+1),:);zz]
  end
else
  xx=x;yy=y;zz=z;
end
[n,p]=size(z);
if rhs < 9 then ebox=[-1,1,-1,1,-1,1];end 
if rhs < 8 then flags=[3,4,2,3];end
if rhs < 7 then leg=" ";end 
if rhs < 6 then A=45;end 
if rhs < 5 then T=35;end 
param3d1(xx,yy,list(zz,flags(1)*ones(1,p)),T,A,leg,flags(3:4),ebox) 
param3d1(xx',yy',list(zz',flags(2)*ones(1,n)),T,A,leg,[0,flags(4)],ebox) 

function [xx,yy,zz]=nf3d(x,y,z)
// 3d coding transformation 
// from facets coded in three matrices x,y,z to scilab code for facets 
// accepted by plot3d 
//---------------------------------------------------------
// Copyright INRIA
[n1,n2]=size(x)
ind=ones(1,n1-1).*.[0 1 n1+1 n1]+ (1:n1-1).*.[1 1 1 1];
// ind=[1,2,n1+2,n1+1 , 2,3,n1+3,n1+2, ....  ,n1-1,n1,2n1,2n1-1
ind2=ones(1,n2-1).*.ind+((0:n2-2)*n1).*.ones(ind);
nx=prod(size(ind2))
xx=matrix(x(ind2),4,nx/4);
yy=matrix(y(ind2),4,nx/4);
zz=matrix(z(ind2),4,nx/4);

function plot3d2(x,y,z,vect,varargin)
// plot3d2(x,y,z,vect,T,A,leg,flags,ebox)
// (x,y,z) description of a set of surfaces 
// to Scilab description + call to plot3d 
// (x,y,z) are three matrices which describe a surface 
// the surface is composed of four sided polygons 
// The x-coordinates of a facet are given by x(i,j),x(i+1,j),x(i,j+1),
//	x(i+1,j+1)
// the vect vector is used when multiple surfaces are coded 
// in the same (x,y,z) matrices. vect(j) gives the line 
// at which the coding of the jth surface begins 
// if vect==-1 means that vect is useless
// Copyright INRIA
//---------------------------------------------------------
[lhs,rhs]=argn(0);
if rhs <= 3; vect=-1;varargin=list();end
if rhs >= 4 & vect<>-1 then
  nobjs=prod(size(vect))+1;
  [rx,cx]=size(x);
  vect1=[0,vect,rx];
  xx=[],yy=[],zz=[];
  for i=1:nobjs; 
    [xxl,yyl,zzl]=nf3d(x(vect1(i)+1:vect1(i+1),:),...
	y(vect1(i)+1:vect1(i+1),:),...
	z(vect1(i)+1:vect1(i+1),:)),...
	xx=[xx,xxl];yy=[yy,yyl];zz=[zz,zzl];
  end;
else 
  [xx,yy,zz]=nf3d(x,y,z)
end
plot3d(xx,yy,zz,varargin(:))

function [z]=dup(x,n)
// utility 
// x is a vector this function returns [x,x,x,x...] or [x;x;x;x;..]
// depending on x 
// Copyright INRIA
[nr,nc]=size(x)
if nr==1 then y=ones(n,1) ; z= x.*.y ; 
	else if nc<>1 then error("dup : x must be a vector");
	else y=ones(1,n) ; z= x.*.y ; end;end

function [z] = bezier(p,t)
//comment : Computes a  Bezier curves.
//For a test try:
//beziertest; bezier3dtest; nurbstest; beziersurftest; c1test;
//Uses the following functions:
//bezier, bezier3d, nurbs, beziersurface
//endcomment
//reset();
// Evaluate sum p_i B_{i,n}(t) the easy and direct way.
// p must be a k x n+1 matrix (n+1) points, dimension k.
// Copyright INRIA
	n=size(p,'c')-1;// i=nonzeros(t~=1);
	t1=(1-t); t1z= find(t1==0.0); t1(t1z)= ones(t1z);
	T=dup(t./t1,n)';
	b=[((1-t')^n),(T.*dup((n-(1:n)+1)./(1:n),size(t,'c')))];
	b=cumprod(b,'c');
	if (size(t1z,'c')>0); b(t1z,:)= dup([ 0*ones(1,n),1],size(t1z,'c')); end;
	z=p*b';
// endfunction


function bezier3d (p)
// Shows a 3D Bezier curve and its polygon
// Copyright INRIA
	t=linspace(0,1,300);
	s=bezier(p,t);
	dh=xget("dashes");
	xset("dashes",3)
	param3d(p(1,:),p(2,:),p(3,:),34,45)
	xset("dashes",4);
	param3d(s(1,:),s(2,:),s(3,:),34,45,"x@y@z",[0,0])
	xset("dashes",dh);
	xtitle('A 3d polygon and its Bezier curve');
// endfunction	


function [X,Y,Z]=beziersurface (x,y,z,n)
// Compute a Bezier surface. Return {bx,by,bz}.
// Copyright INRIA
	[lhs,rhs]=argn(0);
	if rhs <= 3 ; n=20;end 
	t=linspace(0,1,n);
	n=size(x,'r')-1; // i=nonzeros(t~=1);
	t1=(1-t); t1z= find(t1==0.0); t1(t1z)= ones(t1z);
	T=dup(t./t1,n)';
	b1=[((1-t')^n),(T.*dup((n-(1:n)+1)./(1:n),size(t,'c')))];
	b1=cumprod(b1,'c');
	if (size(t1z,'c')>0); 
		b1(t1z,:)= dup([ 0*ones(1,n),1],size(t1z,'c')); end;

	n=size(x,'c')-1; // i=nonzeros(t~=1);
	t1=(1-t); t1z= find(t1==0.0); t1(t1z)= ones(t1z);
	T=dup(t./t1,n)';
	b2=[((1-t')^n),(T.*dup((n-(1:n)+1)./(1:n),size(t,'c')))];
	b2=cumprod(b2,'c');
	if (size(t1z,'c')>0); 
		b2(t1z,:)= dup([ 0*ones(1,n),1],size(t1z,'c')); end;
	X=b1*x*b2';Y=b1*y*b2';Z=b1*z*b2';
// endfunction

function cplxmap(z,w,varargin)
//cplxmap(z,w,T,A,leg,flags,ebox)
//cplxmap Plot a function of a complex variable.
//       cplxmap(z,f(z))
// Copyright INRIA
x = real(z);
y = imag(z);
u = real(w);
v = imag(w);
M = max(u);
m = min(u);
s = ones(size(z));
//mesh(x,y,m*s,blue*s);
//hold on
[X,Y,U]=nf3d(x,y,u);
[X,Y,V]=nf3d(x,y,v);
Colors = sum(V,'r');
Colors = Colors - min(Colors);
Colors = 32*Colors/max(Colors);
plot3d1(X,Y,list(U,Colors),varargin(:))


function cplxroot(n,m,varargin)
//cplxroot(n,m,T,A,leg,flags,ebox)
//CPLXROOT Riemann surface for the n-th root.
//       CPLXROOT(n) renders the Riemann surface for the n-th root.
//       CPLXROOT, by itself, renders the Riemann surface for the cube root.
//       CPLXROOT(n,m) uses an m-by-m grid.  Default m = 20.
// Use polar coordinates, (r,theta).
// Cover the unit disc n times.
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs  < 1, n = 3; end
if rhs  < 2, m = 20; end
r = (0:m)'/m;
theta = - %pi*(-n*m:n*m)/m;
z = r * exp(%i*theta);
s = r.^(1/n) * exp(%i*theta/n);
cplxmap(z,s,varargin(:))


