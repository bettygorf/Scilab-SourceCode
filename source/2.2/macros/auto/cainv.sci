function [Y,ns,nsg,nn,J,k,Z]=cainv(Sl,alfa)
//Dual of abinv
//Finds basis Y and output injection J
//such that the abcd matrices of ss2ss(Sl,Y,[],J)) are: 
//
//                  [*,*,*,*]             [*]
//  (Y'A + J*C)*Y = [0,u,*,*]   B + J*D = [0]
//                  [0,0,s,*]             [0]
//                  [0,0,0,*]             [0]
//
//      C*Y = [*,*,*,*]                D= [*]
//            [0,0,0,*]                   [0]
//
// modes of A22 (u) are unstable
// modes of A33 (s) are stable
// pair (A44, C24) is observable, poles of A44 set to alfa.
// ns first columns of Y span S= smallest (C,A) invariant
// subspace which contains Im(B).
// nsg first columns of Y span Sg
// nn first columns of Y span N=S+V
// ns=0 iff B(ker(D))=0
// DDEP: dot(x)=A x + Bu + Gd
//           y= Cx   (observation)
//           z= Hx    (z=variable to be estimated, d=disturbance)
//  Find: dot(w) = Fw + Ey + Ru such that
//          zhat = Mw + Ny
//           z-Hx goes to zero at infinity
//  Solution exists iff Ker H contains Sg(A,C,G) inter KerC
//i.e. H is such that:
// For any W which makes a column compression of [Yp(1:nsg,:);C]
// with Yp=Y' and [Y,ns,nsg,nn,J,k,Z]=cainv(syslin('c',A,G,C));
// [Yp(1:nsg,:);C]*W = [0 | *] one has
// H*W = [0 | *]  (with at least as many columns as above).

[Y,nr,nvg,nv,F,k,Z]=abinv(Sl',alfa);
[nx,nx]=size(Y);ns=nx-nv;nsg=nx-nvg;nn=nx-nr;
n4=nx-ns+1:nx;n3=nx-nsg+1:nx-ns;n2=nx-nn+1:nx-nsg;n1=1:nr;
nr=1:nr;nzs=nr+1:nr+nvg;nzi=nvg+1:nv;
Y=[Y(:,n4),Y(:,n3),Y(:,n2),Y(:,n1)];
J=F';Z=Z';





