function [D,G,mu]=musolve(M,KK,T,params)
// musolve - Structured Singular value problem
//%Syntax
//  [mu [,D [,G]] ]=musolve(M,KK,T [,params])
//
//     M  -  n by n matrix for which the upper bound of SSV is to be computed.
//     K  -  m by 1 vector contains the block structure. K(i), i=1:m, is the
//           size of each block, and sum(K) should be equal to n.
//     T  -  m by 1 vector indicates the type of each block. For i=1:m,
//           T(i)=1 indicates the corresponding block is a repeated scalar
//                  real block
//           T(i)=2 indicates the corresponding block is a full complex block.
//           T(i)=3 indicates the corresponding block is a repeated complex
//                  scalar block.
//     PARAMS =[printflg #iter rtol utol ptol #psteps #dsteps]
//           if PARAMS has less than 7 elements the right most ones are set
//           to their default values:
//            printflg = 0      : print flag, 0 - nothing is printed 
//            #iter    = 50     : # of iterations allowed
//            rtol     = 1.d-6  : required relative accuracy. 
//            utol     = 1.d-10 : tolerance for unfeasability
//            ptol     = 1.d-12 : tolerance for projection
//            #pstep   = 5      : # of primal dichotomy steps
//            #dstep   = 0      : # of dual Newton steps, 0 - default dual step
//     D  - hermitian n by n matrix
//     G  - hermitian n by n matrix
//%Description
// Minimize mu such that  D and G matrices exist which verify :
//    M'*D*M +%i*(G*M - M'*G) -mu^2*D<=0
//    D>=0
//!
// Origin R. Nikhoukah, S Steer Inria 1992

[lhs,rhs]=argn(0)
params_d=[1 50 1.d-6 1.d-10 1.d-12 5 0]
if rhs==3 then
  params=params_d
else
  np=prod(size(params))
  for k=np+1:7
     params(k)=params_d(k)
  end
end
[n,n1]=size(M)
if n1<>n then error(20,1),end
nblc=prod(size(KK))
if nblc<>prod(size(T)) then
    error('the bloc structure and type vector must have the same size')
end
if sum(KK)<>n then
    error('sum of bloc size must equal de dimension of M')
end

Mr=real(M)
Mi=imag(M)

A=[]
b=[]
Q=[]
p=[]
x=[]
t1=find(t==1)
realcase=(norm(Mi,'inf')==0)&(t1==[])
if realcase then
// REAL CASE 
//form a basis of D 
  ptr=1
  xptr=1
  for ib=1:nblc
    blsiz=KK(ib)
    if T(ib)==1|T(ib)==3 then
      for l=ptr:ptr+blsiz-1
        for k=ptr:l
          Dr=0*ones(n,n);
          Dr(k,l)=1
          Dr(l,k)=1
          A=[A compress(Dr)]
          Q=[Q compress(Mr'*Dr*Mr)]
        end
      end
    elseif T(ib)==2 then
      Dr=0*ones(n,n);
      Dr(ptr:ptr+blsiz-1,ptr:ptr+blsiz-1)=eye(blsiz,blsiz)
      A=[A compress(Dr)]
      Q=[Q compress(Mr'*Dr*Mr)]
    else 
      error('blocs types must be 1 2 or 3')
    end  
    ptr=ptr+blsiz
  end
  qg=[]
  msiz=n
else
// COMPLEX CASE
//form a basis of D 
  MM=[Mr -Mi;Mi Mr]
  MMh=[Mr' Mi';-Mi' Mr']
  ptr=1
  xptr=1
  for ib=1:nblc
    blsiz=KK(ib)
    if T(ib)==1|T(ib)==3 then
      for l=ptr:ptr+blsiz-1
        for k=ptr:l
          Dr=0*ones(n,n);
          Dr(k,l)=1
          Dr(l,k)=1
          if l<>k then 
             Di=0*ones(n,n)
             Di(l,k)=1;Di(k,l)=-1,
             A=[A compress(eye(2,2).*.Dr) compress([0 -1;1 0].*.Di)]
             Q=[Q compress(MMh*(eye(2,2).*.Dr)*MM),..
                  compress(MMh*([0 -1;1 0].*.Di)*MM)]
          else
             A=[A compress(eye(2,2).*.Dr)]
             Q=[Q compress(MMh*(eye(2,2).*.Dr)*MM)]
          end
        end
      end
    elseif T(ib)==2 then
      Dr=0*ones(n,n);
      Dr(ptr:ptr+blsiz-1,ptr:ptr+blsiz-1)=eye(blsiz,blsiz)
      A=[A compress(eye(2,2).*.Dr)]
      Q=[Q compress(MMh*(eye(2,2).*.Dr)*MM)]
    else 
      error('blocs types must be 1 2 or 3')
    end  
    ptr=ptr+blsiz
  end
  // form basis for G
  jMM=[-Mi -Mr;Mr -Mi]
  jMMh=[Mi' -Mr'; Mr' Mi']
  ptr=1
  Qg=[]
  for ib=1:nblc
    blsiz=KK(ib)
    if T(ib)==1
      for l=ptr:ptr-1+blsiz
        for k=ptr:l
          Gr=0*ones(n,n);
          Gr(k,l)=1
          Gr(l,k)=1
          if l<>k then 
            Gi=0*ones(n,n)
            Gi(l,k)=1;Gi(k,l)=-1, 
            Qg=[Qg compress((eye(2,2).*.Gr)*jMM-jMMh*(eye(2,2).*.Gr))',..
                 compress(([0 -1;1 0].*.Gi)*jMM-jMMh*([0 -1;1 0].*.Gi))']
          else
            Qg=[Qg compress((eye(2,2).*.Gr)*jMM-jMMh*(eye(2,2).*.Gr))']
          end
        end
      end
      ptr=ptr+blsiz
    end
  end
  msiz=2*n
end
//compress column of Qg  to obtain full rank
[nQg,mQg]=size(Qg)
if nQg<>0 then
  [u,rk]=colcomp(Qg)
  Qg=Qg*u;Qg=Qg(:,mQg-rk+1:mQg);nQ=prod(size(Qg))
  Q=[Q matrix(Qg,1,nQ)]
  A=[A 0*ones(1,nQ)]
  nxq=nQ/(msiz*(msiz+1)/2)
end
//
b=-0.0001*compress(eye(msiz,msiz))
p=0*b
//tmax=sum(m.*m')
tmax=(maxi(svd(m))**2)*(1+.1)
nx=prod(size(A))/(msiz*(msiz+1)/2)

// Solve the problem

[x,mu,info]=nemirov(A,b,Q,p,msiz,0,list(tmax,0*ones(1,nx)),params)
mu=sqrt(mu)

if info(1)<0 then
  D=[];G=[]
  return
end
if nQg<>0 then
  //Choose a particular solution and transform back
  xg=[0*ones(mQg-rk,1);x(nx-nxq+1:nx)]
  x=[x(1:nx-nxq); u*xg]
end
// Reconstruct D  matrix
ptr=1
xptr=1
Dr=0*ones(n,n);Di=0*ones(n,n);
if realcase then
  for ib=1:nblc
    blsiz=KK(ib)
    if T(ib)==1|T(ib)==3 then
      for l=ptr:ptr+blsiz-1
        for k=ptr:l
          Dr(k,l)=x(xptr);Dr(l,k)=x(xptr);
          xptr=xptr+1
        end
      end
    elseif T(ib)==2 then
      Dr(ptr:ptr+blsiz-1,ptr:ptr+blsiz-1)=eye(blsiz,blsiz)*x(xptr)
      xptr=xptr+1
    end  
    ptr=ptr+blsiz
  end
else
  for ib=1:nblc
    blsiz=KK(ib)
    if T(ib)==1|T(ib)==3 then
      for l=ptr:ptr+blsiz-1
        for k=ptr:l
          if l<>k then 
             Dr(k,l)=x(xptr);Dr(l,k)=x(xptr);
             Di(l,k)=x(xptr+1);Di(k,l)=-x(xptr+1),
             xptr=xptr+2
          else
             Dr(k,l)=x(xptr);Dr(l,k)=x(xptr);
             xptr=xptr+1
          end
        end
      end
    elseif T(ib)==2 then
      Dr(ptr:ptr+blsiz-1,ptr:ptr+blsiz-1)=eye(blsiz,blsiz)*x(xptr)
      xptr=xptr+1
    end  
    ptr=ptr+blsiz
  end
end
// Reconstruct G  matrix

ptr=1
Gr=0*ones(n,n);Gi=0*ones(n,n);
for ib=1:nblc
  blsiz=KK(ib)
  if T(ib)==1
    for l=ptr:ptr-1+blsiz
      for k=ptr:l
        if l<>k then 
          Gr(l,k)=x(xptr);Gr(k,l)=x(xptr);
          Gi(l,k)=x(xptr+1);Gi(k,l)=-x(xptr+1)
          xptr=xptr+2
        else
          Gr(k,l)=x(xptr)
          xptr=xptr+1
        end
      end
    end
    ptr=ptr+blsiz
  end
end
D=Dr+%i*Di
G=Gr+%i*Gi
//end

function AA=compress(A)
//Si A est une matrice carree symetrique AA est le vecteur
// [A(1,1),A(2,1),A(2,2),...,A(q,1),...A(q,q),...]
//!
if norm(a-a','fro')>1.d-5 then
  error('non symmetric matrix')
end
[m,n]=size(a)
AA=[]
for l=1:m,AA=[AA A(l,1:l)],end
//end

function A=uncompress(AA,mod)
//Reconstruit la matrice carree symetrique ou antisymetrique A 
//a partir du  vecteur AA:
// mode : 's' : la matrice A est symetrique
//        'a' : la matrice A est anti-symetrique
// [A(1,1),A(2,1),A(2,2),...,A(q,1),...A(q,q),...]
//!
nn=prod(size(AA))
m=maxi(real(roots(poly([-2*nn 1 1],'x','c'))))
s=1;if part(mod,1)=='a' then s=-1,end
A=[]
ptr=1
for l=1:m
  A(l,1:l)=AA(ptr:ptr+l-1)
  ptr=ptr+l
end
A=A+s*tril(A,-1)'
//end