function [K,X,err]=leqr(P12,Vx)
//H-infinity lqr gain for full-state LQ problem
//(discrete or continuous)
//                discrete                        continuous
//      |I  -Vx  0|   | A    0     B|       |I   0   0|   | A    Vx    B  |
//     z|0   A'  0| - |-C'C  I    -S|      s|0   I   0| - |-C'C  -A'  -S  |
//      |0   B'  0|   | S'   0   D'D|       |0   0   0|   | S'   -B'   D'D|
if P12(1)<>'lss' then error('leqr: state-space only!');end
[A,B2,C1,D12]=P12(2:5);
[n,nu]=size(B2);
[ny,n]=size(C1);
select P12(7)
  case [] then
error('leqr: time domain is not defined ( P(7)=''c'' or ''d'')')
//      Continuous
  case 'c' then
Z=0*A;i=eye(A);
Q=C1'*C1;R=D12'*D12;S=C1'*D12;Ri=pinv(R);
E=[i,z,zeros(B2);
    z,i,zeros(B2);
    zeros(nu,2*n+nu)];
Aa=[A,Vx,B2;
    -Q,-A',-S;
     S',b2',R];
[w,k]=gschur(Aa,e,'c');
if k<>n then warning('leqr: stable subspace too small!');...
            k=[];w=[];err=[];return;end
ws=w(:,1:n);
x12=ws(1:n,:);
if rcond(x12)<1.d-6 then warning('leqr: bad conditioning!');...
              k=[];w=[];return;end
phi12=ws(n+1:2*n,:);
u12=ws(2*n+1:2*n+nu,:);
K=u12/X12;
X=phi12/x12;
//pause;
err=norm((A-B2*Ri*S')'*X+X*(A-B2*Ri*S')-X*(B2*Ri*B2'-Vx)*X+Q-S*Ri*S',1)
//K=-Ri*(B2'*X+S')
//      discrete
case 'd' then
I=eye(a);Z=0*i;
Q=C1'*C1;R=D12'*D12;S=C1'*D12;
e=[I,-Vx,zeros(B2);
   Z,A',zeros(B2);
   zeros(B2'),-B2',zeros(B2'*B2)];
aa=[A,Z,B2;
    -Q,I, -S;
     S', 0*B2', R];
[w,k]=gschur(aa,e,'d');
if k<>n then warning('leqr: stable subspace too small!');...
            k=[];w=[];return;end
ws=w(:,1:n);
x12=ws(1:n,:);
if rcond(x12) <1.d-6 then warning('leqr: bad conditioning!');...
            k=[];w=[];return;end
phi12=ws(n+1:2*n,:);
u12=ws(2*n+1:2*n+nu,:);
K=u12/X12;
X=phi12/x12;
if norm(x-x',1)>0.0001 then warning('leqr: X non symmetric!');...
        k=[];w=[];return;end
//pause;
//A'*X*A-(A'*X*B2+C1'*D12)*pinv(B2'*X*B2+D12'*D12)*(B2'*X*A+D12'*C1)+C1'*C1
Abar=A-B2*Ri*S';
Qbar=Q-S*Ri*S';
err=norm(X-(Abar'*inv((inv(X)+B2*Ri*B2'-Vx))*Abar+Qbar),1);
//K=-Ri*(B2'*inv(inv(X)+B2*Ri*B2'-Vx)*Abar+S')
end
