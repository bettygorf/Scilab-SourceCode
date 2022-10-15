function [K,X]=lqr(P12)
//lqr gain for full-state LQ problem
//(discrete or continuous)
//          discrete                        continuous
//      |I   0   0|   | A    0   B  |      |I   0   0|   | A    0    B  |
//     z|0   A'  0| - |-C'C  I   -S'|    s |0   I   0| - |-C'C -A'  -S' |
//      |0   B'  0|   | S    0   D'D|      |0   0   0|   | S   -B'   D'D|
if P12(1)<>'lss' then error('lqr: state-space only!');end
[A,B2,C1,D12]=P12(2:5);
[n,nu]=size(B2);
[ny,n]=size(C1);
select P12(7)
  case [] then
error('lqr: time domain is not defined ( P(7)=''c'' or ''d'')')
  case 'c' then
Z=0*A;i=eye(A);
E=[I,z,0*B2;
    z,I,0*B2;
    0*ones(nu,2*n+nu)];

Aa=[A,z,B2;
    -C1'*C1,-A',-C1'*D12;
     D12'*C1,b2',d12'*d12] 
[w,k]=gschur(Aa,e,'c');
if k<>n then error('lqr: stable subspace too small!');end
ws=w(:,1:n);
x12=ws(1:n,:);
phi12=ws(n+1:2*n,:);
u12=ws(2*n+1:2*n+nu,:);
if rcond(x12)< 1.d-5 then warning('lqr: bad contionning!');end
K=u12/X12;
X=phi12/x12;
return
  case 'd' then
I=eye(a);z=0*I;
e=[i,z,0*B2;
   z,a',0*b2;
   0*b2',-B2',0*b2'*b2];

aa=[A,z, B2;
    -C1'*C1,i, -c1'*d12;
     D12'*C1, 0*b2', d12'*D12];

[w,k]=gschur(aa,e,'d');
if k<>n then error('lqr: stable subspace too small!');end
ws=w(:,1:n);
x12=ws(1:n,:);
phi12=ws(n+1:2*n,:);
u12=ws(2*n+1:2*n+nu,:);
if rcond(x12)< 1.d-5 then warning('lqr: bad contionning!');end
K=u12/X12;
X=phi12/x12;
return
end
