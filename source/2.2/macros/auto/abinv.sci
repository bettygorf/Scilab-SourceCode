function [X,nr,nvg,nv,F,k,Z]=abinv(Sl,alfa)
//Output nulling subspace (maximal unobservable subspace) for
// Sl = linear system defined by [A,B,C,D]
//The nv first columns of X i.e V=X(:,1:nv), spans this subspace
//which is also the unobservable subspace of (A+B*F,C+D*F);
//The nr first columns of X spans R, the controllable part of V (nr<=nv).
//(nr=0 for a left invertible system).
//The nvg first columns of X spans Vg=maximal AB-stabilizable subspace.
// (nr<=nvg<=nv). The modes of X2'*(A*BF)*X(:,1:nvg) are either
// assignable or stable.
//For X=[V,X2] (X2=X(:,nv+1:nx)) one has X2'*(A+B*F)*V=0 and (C+D*F)*V=0
//The zeros (transmission zeros for minimal Sl) are given by :
//X0=X(:,nr+1:nv); spec(X0'*(A+B*F)*X0) i.e. nv-nr closed-loop fixed modes
//If optional real parameter alfa is given as input, the nr controllable 
//modes of (A+BF) are set to alfa.
// Generically, for strictly proper systems one has:
// Fat plants (ny<nu): nv=nr=nx-nu --> no zeros
// Tall plants (ny>nu): nv=nr=0 --> no zeros
// Square plants (ny=nu): nv=nx-nu, nr=0, --> nv zeros
// For proper (D full rank) plants, generically:
// Square plants: nv=nx, nr=0, --> nx zeros
// Tall plants: nv=nr=0 --> no zeros
// Fat plants: nv=nr=nx --> no zeros
// Z is a column compression of Sl and k the normal rank of Sl.
//nv=nx  iff C^(-1)(D)=0;
//DDPS:
//   Find u=Fx+Rd which reject Q*d and stabilizes the plant:
//
//    xdot=Ax+Bu+Qd
//    y=Cx+Du
//
//     DDPS has a solution iff Im(Q) is included in Vg + Im(B). 
//     Let G=(X(:,nvg+1:nx))'= left anihilator of Vg i.e. G*Vg=0;
//     B2=G*B; Q2=G*Q; DDPS solvable iff B2(:,1:k)*R1 + Q2 =0 has a solution.
//     R=[R1;*] is the solution  (with F=output of abinv).
//     Im(Q2) is in Im(B2) means row-compression of B2=>row-compression of Q2
//     Then C*[(sI-A-B*F)^(-1)+D]*(Q+B*R) =0   (<=>G*(Q+B*R)=0)
//F.D.
timedomain=Sl(7);
if timedomain=[] then warning('abinv: time domain not given =>Sl assumed continuous (default)');timedomain='c';end
[LHS,RHS]=argn(0);
[A,B,C,D]=abcd(Sl);
[nx,nu]=size(B);
Vi=eye(A);
[X,nv]=im_inv([A;C],[Vi,B;zeros(C*Vi),D]);
Vi1=X(:,1:nv);
while %t,
[X,n1]=im_inv([A;C],[Vi1,B;zeros(C*Vi1),D]);
if nv==n1 then break;end
nv=n1;Vi1=X(:,1:n1);
end
V=X(:,1:nv);    // V subspace
//
if nv==0 then 
  nr=0;nvg=0;F=[];X=eye(X);
  [Z,k]=colcomp([B;D]);
  return;
end
Anew=X'*A*X;Bnew=X'*B;Cnew=C*X;
//
A11=Anew(1:nv,1:nv);
A21=Anew(nv+1:nx,1:nv);B2=Bnew(nv+1:nx,:);
C1=Cnew(:,1:nv);B1=Bnew(1:nv,:);
[U,k]=colcomp([B2;D]);   //U is nu x nu
Uker=U(:,1:nu-k);Urange=U(:,nu-k+1:nu);
B1t=B1*Uker;B1bar=B1*Urange;
B2bar=B2*Urange;
Dbar =D*Urange; 
// B2bar,Dbar have k columns , B1t has nu-k columns and nv rows
Z=[A21,B2bar;C1,Dbar]; //Z is (nx-nv)+ny x nv+k 
[W,nn]=colcomp(Z);    // ? (nv+k-nn)=nv  <=> k=nn ? if not-->problem!
W1=W(:,1:nv)*inv(W(1:nv,1:nv));
F1bar=W1(nv+1:nv+k,:);  
//[A21,B2bar;C1,Dbar]*[eye(nv,nv);F1bar]=zeros(nx-nv+ny,nv)
A11=A11+B1bar*F1bar;  //add B1bar*F1bar is not necessary!
[nvg,nr,Ur]=st_ility(syslin(timedomain,A11,B1t,[]));
//[nr,Ur]=contr(A11,B1t);
//if B1t<>[]|norm(B1t,1)>1.d-10 then
if B1t<>[] then
       voidB1t=%f;
       Urc=Ur(:,1:nr);  //nv rows, nr columns
       A1111=Urc'*A11*Urc;B1t1=Urc'*B1t;
       if RHS==1 then
         warning('abinv: needs alfa =>use default value alfa=-1')
         alfa=-1;
       end
       F11=-ppol(A1111,B1t1,alfa*ones(nr,1));  //nu-k rows, nr columns
       F1t=F11*Urc';   //nu-k rows, nv columns
else
  voidB1t=%t;
  F1t=0*rand(nu-k,nv);
       nr=0;
end     
if ~voidB1t then
if norm(B1t,1)<1.d-10 then
   F1t=0*rand(nu-k,nv);
       nr=0;
end       
end     
// Now spec(Anew(1:nv,1:nv)+B1*U*[F1t;F1bar]) = 
//     spec(A11+B1t*F1t) = placed poles + zeros
F=U*[F1t;F1bar]*V'; //pause;
X(:,1:nv)=V*Ur;
//[nv,W]=unobs(A+B*F,C+D*F); V=W(:,1:nv)
Z=syslin(timedomain,A+B*F,B*U,F,U);
//[XX,dim]=spaninter(B,V);BinterV=XX(:,1:dim);
//[XX,dim,dimV]=spanplus(V,B);BplusV=XX(:,1:dim);
//[nr,R]=contr(A+B*F,BinterV);R=R(:,1:nr);
//[nw,W]=contr(A+B*F,BplusV);

