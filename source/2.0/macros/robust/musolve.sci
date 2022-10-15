function [mu,D,G]=musolve(M,K,T,params)
// musolve - Structured Singular value problem
//  [mu [,D [,G]] ]=musolve(M,K,T [,params])
//
//     M  -  n by n matrix for which the upper bound of SSV is to be computed.
//     K  -  m by 1 vector contains the block structure. K(i), i=1:m, is the
//           size of each block, and sum(K) should be equal to n.
//     T  -  m by 1 vector indicates the type of each block. 
//        T(i)=1 <=>  the ith perturbation block is repeated real 
//               -->  D(i) and G(i) blocks are full complex
//        T(i)=2 <=>  the ith perturbation block is repeated complex 
//               -->  D(i) block is full complex, G(i) = 0
//        T(i)=3 <=>  the ith  perturbation block is full complex 
//               -->  D(i) is repeated real, G(i)=0
//     params =[printflg #iter rtol utol ptol #psteps #dsteps]
//           if params has less than 7 elements the right most ones are set
//           to their default values:
//            printflg = 0      : print flag, 0 - nothing is printed 
//            #iter    = 20     : # of iterations allowed
//            rtol     = 1.d-6  : required relative accuracy. 
//            utol     = 1.d-10 : tolerance for unfeasability
//            ptol     = 1.d-12 : tolerance for projection
//            #pstep   = 5      : # of primal dichotomy steps
//            #dstep   = 5      : # of dual Newton steps
//     D  - block diagonal positive hermitian n by n matrix
//     G  - block diagonal hermitian n by n matrix
//%Description
// Minimize mu such that  D and G matrices exist which verify :
//    M'*D*M +%i*(G*M - M'*G) -mu^2*D<=0
//    D>=0
// REFS: Fan, Tits, Doyle IEEE AC Jan 91 
//      Young, Newlin,Doyle CDC 91 pp 1251-1256
//!
[lhs,rhs]=argn(0)
params_d=[-1 20 1.d-6 1.d-10 1.d-12 5 5 0 0]
withqr=%f;
if rhs==3 then
  params=params_d
else
  np=prod(size(params))
  for ki=np+1:7
     params(ki)=params_d(ki)
  end
end
[n,n1]=size(M)
if n1<>n then error(20,1),end
nblc=prod(size(K))
if nblc<>prod(size(T)) then
    error('the block structure and type vector must have the same size')
end
if sum(K)<>n then
    error('sum of block size must equal dimension of M')
end

realcase=(and(imag(M)==0))&(and(T==3)|and(K==1))
if realcase then // REAL CASE 
  deff('[Q]=func(X)','Q=X')
  A=strucbas(K,T,func,'r')
  deff('[Q]=func(X)','Q=M''*X*M')
  Q=strucbas(K,T,func,'r')
  msiz=n
else  // COMPLEX CASE
  T1=T;k1=find(T1==2);T1(k1)=ones(k1)';
  deff('[Q]=func(X)','Q=X')
  A=strucbas(K,T1,func,'c')
  deff('[Q]=func(X)','Q=M''*X*M')
  Qd=strucbas(K,T1,func,'c')

  T1=T;zers=find(T1==2|T1==3);T1(zers)=0*zers'
// 5 means full complex blocks of G have zero diagonal
// replace 5 by 1 below for full complex blocks with
// non zero diagonal
// k1=find(T1==1);T1(k1)=5*ones(k1)';
  k1=find(T1==1);T1(k1)=1*ones(k1)';
  deff('[Q]=func(X)','Q=X')
  Ag=strucbas(K,T1,func,'c')
  deff('[Y]=func(X)','Y=%i*(X*M - M''*X)')
  Qg=strucbas(K,T1,func,'c')
  msiz=2*n
  [na1,ma1]=size(A)
  Q=[Qd;Qg]
  A=[A;0*Qg]
end

tmax=(maxi(svd(M))^2)*(1+.1)
// Solve the problem

[na2,ma]=size(A);
if withqr then
[U,aq,rk,e]=qr([A,Q],1.d-10);aq=aq*e';e=[]
A=aq(1:rk,1:ma);Q=aq(1:rk,ma+1:2*ma);aq=[];
else
  rk=na2
end

b=A(1,:);
p=Q(1,:);
A(1,:)=[];
Q(1,:)=[];
[na,ma]=size(A);
nx=(na*ma)/(msiz*(msiz+1)/2)

[x1,mu2,info]=nemirov(matrix(A',1,na*ma),b,matrix(Q',1,na*ma),..
               p,msiz,0,list(tmax,[0*ones(1,nx)]),params)
//disp(spec(uncompress(x1'*a+b,'s')),'spec(ax+b)=')
//disp(spec(uncompress(-mu2*(x1'*a+b)+(x1'*q+p),'s')),'spec(t*(ax+b)-(qx+p))=')
if info(1)<0 then
warning('projective method fails!');
  disp(info,'info = ')
  D=[];G=[]
  return
end

X=[1,x1'];
A=[b;A];Q=[p;Q];

//disp(spec(uncompress(-mu2*(x*a)+(x*q),'s')),'spec(t*(ax)-(qx))=')

if withqr then 
  A=U*[A;0*ones(na2-na,ma)],
  X=[X,0*ones(1,na2-na)]*U';
end

mu=sqrt(mu2)

// Reconstruct D  matrix
if realcase then
  D=uncompress(X*A,'s');
  G=0*D;
else
  D=uncompress(X(1:na1)*A(1:na1,:),'s');
  D=D(1:n,1:n)-%i*D(n+1:2*n,1:n);
  if Qg==[] then
    G=0*ones(n,n)
  else
    G=uncompress(X(na1+1:na2)*Ag,'s');
    G=G(1:n,1:n)-%i*G(n+1:2*n,1:n);
  end
end
//disp(spec(m'*d*m),'spec(m''*d*m)=')
//disp(spec(m'*d*m+%i*(g*m-m'*g)-mu^2*d),'spec(m''*d*m+%i*(g*m-m''*g)-mu^2*d)=')
//disp(spec(d),'spec(d)=')


function AA=compress(A)
//For A square and symmetric AA is vector:
// [A(1,1),A(2,1),A(2,2),...,A(q,1),...A(q,q),...]
//!
if norm(A-A','fro')>1.d-5 then
  error('non symmetric matrix')
end
[m,n]=size(A)
AA=[]
for l=1:m,AA=[AA A(l,1:l)],end


function A=uncompress(AA,mod)
//Rebuilds  A square symmetric or antsymmetric from AA
// mode : 's' : symmetric
//        'a' : skew-symmetric
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


function [Q]=strucbas(K,T,func,typ)
//strucbas - form a decomposition of linear mapping 
//           over a block-structured basis
//Syntax
//  [Q]=strucbas(K,T,func,typ)
//Parameters
// K :vector of block sizes
// T  : types of blocks
//      T(i)==1 : ith block of X full complex
//      T(i)==3 : ith block of X is a*eye (repeated real)
//      T(i)==4 : ith block of X is full real
//      T(i)==0 : ith block of X is a zero block 
//      T(i)==5 : ith block of X  complex with a zero diagonal
// func : macro which defines the linear mapping y=func(x)
// typ: 'r'  if X is real
//      'c'  if X is complex
//
//Remark
// Q is a matrix, each row of which is the compressed form of func(E)
//   where E is a basis entry
//   in the complex case Q(l,:) contains the compressed form of
//   [real(I) imag(I);-imag(i)' real(i)] where I=func(E)
//
// to display the uncompressed form use:
//  [m,n]=size(q);for i=1:m,uncompress(q(i,:),'s'),end
//!
ptr=1
n=sum(K)
Q=[]
if typ=='r' then
for ib=1:prod(size(T))
  blsiz=K(ib)
  sel=ptr:ptr+blsiz-1
  if T(ib)==4|(T(ib)==1&K(ib)==1) then 
    for l=sel
      for ki=ptr:l
        X=0*ones(n,n);
        X(ki,l)=1
        X(l,ki)=1
        Q=[Q;compress(func(X))]
      end
    end
  elseif T(ib)==3 then
    X=0*ones(n,n);
    X(sel,sel)=eye(blsiz,blsiz)
    Q=[Q;compress(func(X))]
  elseif T(ib)==0 then
  else
    error('block type  must be 0 3 4')
  end  
  ptr=ptr+blsiz
end
else  //complex	
for ib=1:prod(size(T))
  blsiz=K(ib)
  sel=ptr:ptr+blsiz-1
  if T(ib)==1 then
    for l=sel
      for ki=ptr:l
        X=0*ones(n,n);
        X(ki,l)=1
        X(l,ki)=1
        R=func(X)
        Q=[Q;compress([real(R) imag(R);-imag(R') real(R)])]
      end
    end
    for l=sel
      for ki=ptr:l-1
        X=0*ones(n,n);
        X(ki,l)=%i
        X(l,ki)=-%i
        R=func(X)
//disp('I',R);pause
        Q=[Q;compress([real(R) imag(R);-imag(R') real(R)])]
      end
    end
  elseif T(ib)==3 then
    X=0*ones(n,n);
    X(sel,sel)=eye(blsiz,blsiz)
    R=func(X)
//pause
    Q=[Q;compress([real(R) imag(R);-imag(R') real(R)])]
  elseif T(ib)==4 then
    for l=sel
      for ki=ptr:l
        X=0*ones(n,n);
        X(ki,l)=1
        X(l,ki)=1
        R=func(X)
        Q=[Q;compress([real(R) imag(R);-imag(R') real(R)])]
      end
    end
  elseif T(ib)==5 then
    for l=sel
      for ki=ptr:l-1
        X=0*ones(n,n);
        X(ki,l)=1
        X(l,ki)=1
        R=func(X)
        Q=[Q;compress([real(R) imag(R);-imag(R') real(R)])]
      end
    end
    for l=sel
      for ki=ptr:l-1
        X=0*ones(n,n);
        X(ki,l)=%i
        X(l,ki)=-%i
        R=func(X)
//disp('I',R);pause
        Q=[Q;compress([real(R) imag(R);-imag(R') real(R)])]
      end
    end
  elseif T(ib)==0 then
  else
    error('block type  must be 0 1 2 3')
  end  

  ptr=ptr+blsiz
end
end

function x=decomp(a)
x=uncompress(a,'s')
[m,n]=size(x)
m=m/2
x=x(1:m,1:m)-%i*x(m+1:2*m,1:m)
