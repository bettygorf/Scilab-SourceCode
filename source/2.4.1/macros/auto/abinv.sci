function [X,dims,F,U,k,Z]=abinv(Sl,alfa,beta)
//Output nulling subspace (maximal unobservable subspace) for
// Sl = linear system defined by [A,B,C,D];
// The dimV first columns of X i.e V=X(:,1:dimV), spans this subspace
// which is also the unobservable subspace of (A+B*F,C+D*F);
// The dimR first columns of X spans R, the controllable part of V (dimR<=dimV).
// (dimR=0 for a left invertible system).
// The dimVg first columns of X spans Vg=maximal AB-stabilizable subspace.
// (dimR<=dimVg<=dimV). The modes of X2'*(A*BF)*X(:,1:dimVg) are either
// assignable or stable.
// For X=[V,X2] (X2=X(:,dimV+1:nx)) one has X2'*(A+B*F)*V=0 and (C+D*F)*V=0
// The zeros (transmission zeros for minimal Sl) are given by :
// X0=X(:,dimR+1:dimV); spec(X0'*(A+B*F)*X0) i.e. dimV-dimR closed-loop fixed modes
// If optional real parameter alfa is given as input, the dimR controllable 
// modes of (A+BF) are set to alfa.
// Generically, for strictly proper systems one has:
// Fat plants (ny<nu): dimV=dimR=nx-nu --> no zeros
// Tall plants (ny>nu): dimV=dimR=0 --> no zeros
// Square plants (ny=nu): dimV=nx-nu, dimR=0, --> dimV zeros
// For proper (D full rank) plants, generically:
// Square plants: dimV=nx, dimR=0, --> nx zeros
// Tall plants: dimV=dimR=0 --> no zeros
// Fat plants: dimV=dimR=nx --> no zeros
// Z is a column compression of Sl and k the normal rank of Sl.
//
//DDPS:
//   Find u=Fx+Rd which reject Q*d and stabilizes the plant:
//
//    xdot=Ax+Bu+Qd
//    y=Cx+Du
//
//     DDPS has a solution iff Im(Q) is included in Vg + Im(B). 
//     Let G=(X(:,dimVg+1:nx))'= left anihilator of Vg i.e. G*Vg=0;
//     B2=G*B; Q2=G*Q; DDPS solvable iff B2(:,1:k)*R1 + Q2 =0 has a solution.
//     R=[R1;*] is the solution  (with F=output of abinv).
//     Im(Q2) is in Im(B2) means row-compression of B2=>row-compression of Q2
//     Then C*[(sI-A-B*F)^(-1)+D]*(Q+B*R) =0   (<=>G*(Q+B*R)=0)
//F.D.
// Copyright INRIA
timedomain=Sl(7);
if timedomain==[] then warning('abinv: time domain not given =>Sl assumed continuous (default)');timedomain='c';end
[LHS,RHS]=argn(0);
if RHS==1 then alfa=-1;beta=-1;end
if RHS==2 then beta=alfa;end
[A,B,C,D]=abcd(Sl);
[nx,nu]=size(B);
Vi=eye(A);
[X,dimV]=im_inv([A;C],[Vi,B;zeros(C*Vi),D]);
Vi1=X(:,1:dimV);
while %t,
[X,n1]=im_inv([A;C],[Vi1,B;zeros(C*Vi1),D]);
if dimV==n1 then break;end
dimV=n1;Vi1=X(:,1:n1);
end
V=X(:,1:dimV);    // V subspace
//
if dimV==0 then 
  dimR=0;dimVg=0;F=[];X=eye(X);
  [Z,k]=colcomp([B;D]);
end
Anew=X'*A*X;Bnew=X'*B;Cnew=C*X;
//
A11=Anew(1:dimV,1:dimV);A22=Anew(dimV+1:$,dimV+1:$);
A21=Anew(dimV+1:nx,1:dimV);B2=Bnew(dimV+1:nx,:);
C1=Cnew(:,1:dimV);B1=Bnew(1:dimV,:);
[U,k]=colcomp([B2;D]);   //U is nu x nu
Uker=U(:,1:nu-k);Urange=U(:,nu-k+1:nu);
B1t=B1*Uker;B1bar=B1*Urange;
B2bar=B2*Urange;Dbar =D*Urange; 
// B2bar,Dbar have k columns , B1t has nu-k columns and dimV rows
Z=[A21,B2bar;C1,Dbar]; //Z is (nx-dimV)+ny x dimV+k 
[W,nn]=colcomp(Z);    // ? (dimV+k-nn)=dimV  <=> k=nn ? if not-->problem!
W1=W(:,1:dimV)*inv(W(1:dimV,1:dimV));
F1bar=W1(dimV+1:dimV+k,:);  
//[A21,B2bar;C1,Dbar]*[eye(dimV,dimV);F1bar]=zeros(nx-dimV+ny,dimV)
A11=A11+B1bar*F1bar;  //add B1bar*F1bar is not necessary!
sl1=syslin(timedomain,A11,B1t,0*B1t');    //sl1=syslin(timedomain,A11,B1t,[]); is now forbidden!
[dimVg,dimR,Ur]=st_ility(sl1);
if B1t<>[] then
       voidB1t=%f;
       if RHS==1 then
         warning('abinv: needs alfa =>use default value alfa=-1')
         alfa=-1;
       end
       F1t=stabil(sl1('A'),sl1('B'),alfa); //nu-k rows, dimV columns
else
  voidB1t=%t;
  F1t=0*rand(nu-k,dimV);
       dimR=0;
end     
if ~voidB1t then
if norm(B1t,1)<1.d-10 then
   F1t=0*rand(nu-k,dimV);
       dimR=0;
end       
end     
//disp(spec(A11+B1t*F1t))
sl2=syslin(timedomain,A22,B2*Urange,0*(B2*Urange)');
[ns2,nc2,U2,sl3]=st_ility(sl2);
if (nc2~=0)&(RHS==1|RHS==2) then
  warning('abinv: needs beta => use default value beta=-1');
end
F2=Urange*stabil(sl2('A'),sl2('B'),beta);
//disp(spec(A22+B2*F2));
// Now spec(Anew(1:dimV,1:dimV)+B1*U*[F1t;F1bar]) = 
//     spec(A11+B1t*F1t) = placed poles + zeros
F=[U*[F1t;F1bar],F2]*X';
X=X*sysdiag(Ur,U2);
noc=dimV+nc2;nos=dimV+ns2;
dims=[dimR,dimVg,dimV,noc,nos];
Z=syslin(timedomain,A+B*F,B*U,F,U);


