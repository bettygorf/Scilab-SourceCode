function [y]=RndInt(m,n,imin,imax) 
// discrete uniform random number 
//-------------------------------
y=rand(m,n,'uniform')
y=int(floor(y*(imax+1-imin)+ imin ));

function [z]=RndIntT(n)
//------------------------------- OK
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=10000;end 
imin=-10;
imax=10;
y=RndInt(1,n,-10,10);
i=imin-2:imax+2;
z=[];
for i1=i, z=[z,prod(size(find(y==i1)))],end
plot2d3("onn",i',z'/n,[1,2],"151","Simulation ",[-12,0,12,0.1]);
i1=(imin:imax)';
plot2d1("onn",i1,ones(i1)/prod(size(imin:imax)),[-2,5],"100","Theory");

function [y]=RndDisc(m,n,x,p)
// discrete law random number
// sum p_i delta_{x_i}
//-------------------------------
p1=[0,p];p1=cumsum(p1);
y=rand(m,n,'uniform')
N=prod(size(x));
res=0*ones(m*n);
for i=1:N,z=0*ones(m*n,1),id=find( p1(i) <= y & y < p1(i+1) ),
 	z(id)=x(i)*ones(prod(size(id))),res=res+z;
end
y=matrix(res,m,n);

function [z]=RndDiscT(n)
//------------------------------- OK
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=10000;end 
x=[1,3,4,6,10,12];
pr=[0.1,0.2,0.3,0.2,0.1,0.1];
y=RndDisc(1,n,x,pr);
i=0:13
z=[];
for i1=i, z=[z,prod(size(find(y==i1)))],end
plot2d3("onn",i',z'/n,[1,3],"151","Simulation ",[0,0,14,0.5]);
plot2d1("onn",x',pr',[-2,6],"100","Theory");

function [y]=Binomial(m,n,pb,nb) 
// Binomial law (p,N) 
// P{X=n} = C_N^n p^n (1-p)^(N-n)
//----------------------------------
  res=[];
 // we use blocks of size 100 to avoid overflows 
  ntir=100;
  ntirc=ntir;
  y=rand(ntir,nb,'uniform');
  indy= find( y < pb);
  y=0*ones(y);
  y(indy)=1;
  y=sum(y,'r')
  res=[res;y];
  while ( ntirc < m*n )
     y=rand(ntir,nb,'uniform');
     indy= find(y< pb);
     y=0*ones(y);
     y(indy)=1;
     y=sum(y,'r')
     res=[res;y];
     ntirc=ntirc+ntir;
  end 
  y=matrix(res(1:m*n),m,n);

function [zt]=BinomialT(n)
//------------------------------- OK
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=10000;end 
prb=0.5
N=10
y=Binomial(1,n,prb,N)
i=0:10;
z=[];
for i1=i, z=[z,prod(size(find(y==i1)))],end
plot2d3("onn",i',z'/n,[1,3],"161","Simulation");
deff('[y]=fact(n)','if n=0 then y=1;else y=n*fact(n-1);end');
deff('[z]=C(N,n)','z= fact(N)/(fact(n)*fact(N-n))');
i=0:N; 
zt=[];
for j=i, zt=[zt, C(N,j)*prb^j*(1-prb)^(N-j)];end 
plot2d1("onn",i',zt',[-2,6],"100","Theory");

function [y]=Geom(m,n,p) 
// P(0)= 0 P(i) = p*(1-p)^{n-1} P(inf)=0
// E = 1/p ; sig2= (1-p)/p^2
//--------------------------------------
if p >= 1 then write(%io(2),'p must be < 1');end
y=0*ones(m,n)
for i=1:m*n, 
	samples=1
	z=rand(1,1,'uniform');
	while( z < 1-p) ,z=rand(1,1,'uniform'); samples=samples+1;end
	y(i)= samples;
end
y=matrix(y,m,n)


function []=GeomT(n)
//------------------------------- OK
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=10000;end 
pr=0.2
y=Geom(1,n,pr)
N=20
i=0:N;
z=[];
for i1=i, z=[z,prod(size(find(y==i1)))],end
plot2d3("onn",i',z'/n,[1,3],"161","Simulation");
zt=[0];for i1=1:N; zt=[zt,pr*(1-pr)^(i1-1)];end
plot2d1("onn",i',zt',[-2,6],"100","Theory");


function [y]=Poisson(m,n,pmean) 
// P{n} = exp(-lambda)lambda^n/n!
// pmean =lambda 
//----------------------------
y=0*ones(m,n)
bound= exp(-pmean);
for i=1:m*n, 
	count=0
	lprod=1
	while( lprod >= bound), lprod=lprod*rand(1,1,'uniform');
	count=count+1;end
	y(i)=count-1;
end
y=matrix(y,m,n)

function [z]=PoissonT(n) 
//------------------------------- OK
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=1000;end 
pmean=3;
y=Poisson(1,n,pmean);
N=20;
i=0:N;
z=[];
for i1=i, z=[z,prod(size(find(y==i1)))],end
plot2d3("onn",i',z'/n,1,"161");
deff('[y]=fact(n)','if n=0 then y=1;else y=n*fact(n-1);end');
zt=[];for i1=0:N; zt=[zt, exp(-pmean) *pmean^i1/fact(i1)];end
plot2d1("onn",i',zt',[-2,6],"100","Theory");

function [y]=Exp(m,n,lambda)
// lambda exp(-lambda x) x>=0 
// ---------------------------
y=(-1/lambda)* log(rand(m,n,'uniform'));

function []=ExpT(n)
//------------------------------- OK
// lambda exp(-lambda x) x>=0 
// ---------------------------
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=1000;end 
lambda=3;
y=Exp(1,n,lambda);
histplot([0:0.1:10],y,[1,1],'051',' ',[0,0,5,3]);
deff('[y]=f(x)','y=lambda*exp(-lambda*x);');
x=[0:0.1:10]';plot2d(x,f(x),1,"000");
titre= 'macro histplot : Histogram plot';
xtitle(titre,'Classes','N(C)/Nmax');

function [y]=Weibull(m,n,alpha,beta)
//------------------------------- 
y=rand(m,n,'uniform')
y= (beta*( - log(1-y)))^(1/alpha)

function []=WeibullT(n)
//------------------------------- 
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=10000;end 
y=Weibull(1,n,1,2)
histplot(20,y,[1,1],'061');

function [y]=HyperGeom(m,n,mean,var)
//------------------------------- 
z = var / (mean * mean);
pP = 0.5 * (1.0 - sqrt((z - 1.0) / ( z + 1.0 )));
y=rand(m,n,'uniform')
zz=find( y > pP) ;
y=pP*ones(y);
y(zz) = (1-pP)*ones(zz);
y1=rand(m,n,'uniform')
y=-mean * log(y1) ./ (2.0 * y) ;

function []=HyperGeomT(n)
//------------------------------- 
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=10000;end 
y=HyperGeom(1,n,1,10)
histplot([0:0.25:10],y,[1,1],'061',' ',[0,0,10,0.4]);

function [y]=Erlang(m,n,pMean,pVariance) 
//------------------------------- 
  k = int( (pMean * pMean ) / pVariance + 0.5 );
  if (k <= 0) then k=1;end
  a = k / pMean;
 // we use blocks of size 100 to avoid overflows 
  res=[];
  ntir=100;
  ntirc=ntir;
  y=rand(ntir,k,'uniform');
  y= -log(prod(y,'r'))/a;
  res=[res;y];
  while ( ntirc < m*n )
     y=rand(ntir,k,'uniform');
     y= -log(prod(y,'r'))/a;
     res=[res;y];
     ntirc=ntirc+ntir;
  end 
  y=matrix(res(1:m*n),m,n);

function [y]=ErlangT(n)
//------------------------------- 
[lhs,rhs]=argn(0)
if rhs <= 0 ; n=10000;end 
y=Erlang(1,n,10,1)
histplot(20,y,[1,1],'061');

function [y]=RndPerm(n) 
//------------------------------- 
// a uniform random permutation of (1:n)
y=rand(1,n,'uniform')
[us,z]=sort(y);


