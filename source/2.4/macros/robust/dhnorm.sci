function gama=dhnorm(sl,tol,gamamax)
// Discrete time H-infinity norm
// Copyright INRIA
[lhs,rhs]=argn(0);
if rhs==1 then tol=0.01;gamamax=1000;end
if rhs==2 then gamamax=1000;end
gamamin=sqrt(%eps);
n=0;
while %t
gama=(gamamin+gamamax)/2;n=n+1;
if n>1000 then warning('dhnorm: more than 1000 iterations!');return;end
 if dhtest(sl,gama) then
  gamamax=gama; else gamamin=gama
 end
if (gamamax-gamamin)<tol then return;end
end

function ok=dhtest(Sl,gama)
//test discrete hinfinity norm of sl is < gama
[A,B,C,D]=sl(2:5);B=B/sqrt(gama);C=C/sqrt(gama);D=D/gama;
R=eye-D'*D;
[n,n]=size(A);Id=eye(n,n);Z=0*Id;
Ak=A+B*inv(R)*D'*C;
E=[Id,-B*inv(R)*B';Z,Ak'];
Aa=[Ak,Z;-C'*inv(eye-D*D')*C,Id];
[w,k]=gschur(Aa,E,'d');
if k<>n then ok=%f;return;end
ws=w(:,1:n);
x12=ws(1:n,:);
phi12=ws(n+1:2*n,:);
if rcond(x12) > 1.d-6 then
X=phi12/x12;
z=eye-B'*X*B
ok=mini(real(spec(X))) > 0 & mini(real(spec(z))) > 0
else
warning('bad conditioning');ok=%f;end

