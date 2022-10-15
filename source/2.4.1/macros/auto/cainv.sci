function [X,dims,J,Y,k,Z]=cainv(Sl,alfa,beta)
//CA invariant subspace: dual of abinv
//Finds orthogonal bases X and Y and output injection J
//such that the abcd matrices of Sl in bases (X,Y) are displayed as:
//
//                  [A11,*,*,*,*,*]                [*]
//                  [0,A22,*,*,*,*]                [*]
//   X'*(A+J*C)*X = [0,0,A33,*,*,*]   X'*(B+J*D) = [*]
//                  [0,0,0,A44,*,*]                [0]
//                  [0,0,0,0,A55,*]                [0]
//                  [0,0,0,0,0,A66]                [0]
//
//          Y*C*X = [0,0,C13,*,*,*]          Y*D = [*]
//                  [0,0,0,0,0,C26]                [0]
//
// dims=[nd1,nu1,dimS,dimSg,dimN] defines the partition of A matrix and k the partition
// of [C,D] matrix.
// eigenvalues of A11 (nd1 x nd1) are unstable
// eigenvalues of A22 (nu1-nd1 x nu1-nd1) are stable
// pair (A33, C13) (dimS-nu1 x dimS-nu1, k x dimS-nu1) is observable, eigenvalues of A33 set to alfa
// A44 (dimSg-dimS x dimSg-dimS) is unstable
// A55 (dimN-dimSg,dimN-dimSg) is stable
// pair (A66,C26) (nx-dimN x nx-dimN, ) is observable, eigenvalues of A66 set to beta.
//
// dimS first columns of X span S= smallest (C,A) invariant
// subspace which contains Im(B).
// dimSg first columns of X span Sg
// dimN first columns of X span N=S+V
// dimS=0 iff B(ker(D))=0
//
// DDEP: dot(x)=A x + Bu + Gd
//           y= Cx   (observation)
//           z= Hx    (z=variable to be estimated, d=disturbance)
//  Find: dot(w) = Fw + Ey + Ru such that
//          zhat = Mw + Ny
//           z-Hx goes to zero at infinity
//  Solution exists iff Ker H contains Sg(A,C,G) inter KerC
//i.e. H is such that:
// For any W which makes a column compression of [Xp(1:dimSg,:);C]
// with Xp=X' and [X,dims,J,Y,k,Z]=cainv(syslin('c',A,G,C));
// [Xp(1:dimSg,:);C]*W = [0 | *] one has
// H*W = [0 | *]  (with at least as many columns as above).
// Copyright INRIA
[LHS,RHS]=argn(0);
if RHS==1 then alfa=-1;beta=-1;end
if RHS==2 then beta=-1;end
[X,ddims,F,U,k,Z]=abinv(Sl',beta,alfa);
nr=ddims(1);nvg=ddims(2);nv=ddims(3);noc=ddims(4);nos=ddims(5);
[nx,nx]=size(X);dimS=nx-nv;dimSg=nx-nvg;dimN=nx-nr;nu1=nx-noc;nd1=nx-nos;
n6=nx-nd1+1:nx;n5=nx-nu1+1:nx-nd1;
n4=nx-dimS+1:nx-nu1;n3=nx-dimSg+1:nx-dimS;n2=nx-dimN+1:nx-dimSg;n1=1:nx-dimN;
//nr=1:nr;nzs=nr+1:nr+nvg;nzi=nvg+1:nv;
X=[X(:,n6),X(:,n5),X(:,n4),X(:,n3),X(:,n2),X(:,n1)];
J=F';Z=Z';Y=U';Y=[Y(k+1:$,:);Y(1:k,:)];
dims=[nd1,nu1,dimS,dimSg,dimN];







