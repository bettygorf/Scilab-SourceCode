Leps=1.e-5;
bs=10.*ones(1,5);bi=-bs;x0=0.12*bs;epsx=1.e-15*x0;xopt=.1*bs;
[f,x,g]=optim('genros',x0,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',x0,'gc','in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
//
// DIVIDE BY ZERO
// [F,X,G]=OPTIM('GENROS',X0,'ND','IN');F-1+NORM(X-XOPT)
[f,x,g]=optim('genros',x0,'qn',1,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',x0,'gc',1,50,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
//
// DIVIDE BY ZERO
// [F,X,G]=OPTIM('GENROS',X0,'ND',1,50,'IN');F-1+NORM(X-XOPT)
[f,x1,g]  =optim('genros',x0,   'ar',100,6,'in');
[f,x,g,to]=optim('genros',x0,   'ar',100,3,'in');
[f,x,g,to]=optim('genros',x ,to,'ar',100,3,'in');
if norm(x-x1)/norm(x-xopt) > 0.1 then  pause,end
[f,x1,g]=optim('genros','b',bi,bs,x0,'ar',100,6,'in');
[f,x,g,to]=optim('genros','b',bi,bs,x0,'ar',100,3,'in');
[f,x,g]   =optim('genros','b',bi,bs,x,to,'ar',100,3,'in');
if norm(x-x1)/norm(x-xopt) > 0.1 then  pause,end
[f,x,g]=optim('genros',x0,'ar','in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',x0,'ar',100,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',x0,'ar',100,100,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',x0,'ar',100,100,%eps,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',x0,'ar',100,100,%eps,%eps,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',x0,'ar',100,100,%eps,%eps,epsx,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',x0,'gc','ar',100,100,%eps,%eps,epsx,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
//
[f,x,g]=optim('genros','b',bi,bs,x0,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros','b',bi,bs,x0,'gc','in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x]=optim('genros','b',bi,bs,x0,'ar',100,100,%eps,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g]=optim('genros',..
   'b',bi,bs,x0,'gc','ar',100,100,%eps,%eps,epsx,'in');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g,to,td]=optim('genros',x0,'in','sd');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g,ti]=optim('genros',x0,'gc','in','si');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g,to,ti,td]=optim('genros',x0,to,'in','si','sd');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g,td]=optim('genros',..
   'b',bi,bs,x0,'gc','ar',100,100,%eps,%eps,epsx,'in','sd');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g,ti]=optim('genros',x0,'gc','ar',100,100,%eps,'in','si');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g,ti,td]=optim('genros',..
    x0,'gc','ar',100,100,%eps,'in','si','sd');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
[f,x,g,ti,td]=optim('genros',..
    x0,'gc','ar',100,100,%eps,'in','ti',ti,'td',td,'si','sd');
if abs(f-1+norm(x-xopt) ) > Leps then pause,end
//
//********************************************************************
//
bs=[5 5];bi=-bs;x0=1.05*[1 1];xopt=[1 1];
deff('[f,g,ind]=rose(x,ind)', 'a=x(2)-x(1)^2 , b=1-x(2) ,...
f=50.*a**2 + b**2 , g(1)=-400.*x(1)*a , g(2)=200.*a -2.*b ');
comp(rose);
//[f,x,g,tr]=optim(rose,x0,'qn','ar',50);if abs(f+norm(x-xopt)) > Leps then pause,end
//[f,x,g]=optim(rose,x0,tr,'ar',50);if abs(f+norm(x-xopt)) > Leps then pause,end
[f,x,g]=optim(rose,x0,'gc','ar',50);if abs(f+norm(x-xopt)) > Leps then pause,end
//
// DIVIDE BY ZERO
// [F,X,G]=OPTIM(ROSE,X0,'ND','AR',25);F+NORM(X-XOPT)
[f,x,g]=optim(rose,'b',bi,bs,x0,'qn','ar',25);
if abs(f+norm(x-xopt)) > Leps then pause,end
[f,x,g]=optim(rose,'b',bi,bs,x0,'gc','ar',50);
if abs(f+norm(x-xopt)) > Leps then pause,end
[f,x,g,td]=optim(rose,x0,'gc','ar',50,'sd');
if abs(f+norm(x-xopt)) > Leps then pause,end
[f,x,g,ti]=optim(rose,x0,'gc','ar',50,'si');
if abs(f+norm(x-xopt)) > Leps then pause,end
[f,x,g,ti,td]=optim(rose,x0,'gc','ar',50,'si','sd');
if abs(f+norm(x-xopt)) > Leps then pause,end
//
// penalization (see doc)
//
// min (x1^2 +x2^2)/2 ; x1>=0, x1 + x2 =1 (solution [0.5 0.5] )
deff('[f,g,ind]=sip2(x,ind)',..
' f= [ x(1)+x(2)-1, -x(1), (x(1)^2+x(2)^2)/2],..
  g= [ 1, -1, x(1); 1,  0, x(2)] ');
cpen=50; ne=1; nc=2;bi=[0 0]; bs=[2 2];
deff('[fpen,gpen,ind]=sipn(x,ind,sip1,ne,nc,cpen)',...
['[f,g,indic]=sip1(x,ind)';
'if indic < 0 then ind=indic, return, end';
'if nc >ne then for i=ne+1:nc, f(i)=maxi([0 f(i)]), end,end';
'fpen=f(nc+1) + cpen*norm(f(1:nc))^2/2';
'if ind=2 then return,end';
'gpen=g(:,nc+1)';
'if ne > 0 then';
'   for i=1:ne, gpen=gpen + cpen*f(i)*g(:,i),end,end';
'if nc > ne then';
' for i=ne+1:nc, if f(i) > 0 then gpen=gpen + cpen*f(i)*g(:,i),end,end;end;'])
comp(sipn);
[f,x,g]=optim(list(sipn,sip2,ne,nc,cpen),...
              'b',bi,bs,[1 1],'ar',20,20,1.e-15);
if norm(x-[0.5 0.5]) + norm(g) > 0.1 then pause,end
