scilab_functions =[...
"cdgemm";
"dgemm";
"dgebal";
"dgebak";
"dgels";
"dgeqrf";
           ];
auxiliary="";
files=G_make(["lapackscilab_gateway.o","lapackscilab.a", auxiliary],"void(Win)");
addinter(files,"lapackscilab_gateway",scilab_functions);

//same as "exec lapackscilab.sce"
alfa=2;beta=3;m=3;n=4;C=ones(m,n);k=2;A=ones(m,k);B=ones(k,n);
C1=dgemm(alfa,A,B,beta,C);
if norm(C1-(alfa*A*B+beta*C)) > %eps then pause,end
A=[1/2^10,1/2^10;2^10,2^10];
[SCALE, ILOW, IHI]=dgebal('S', A);
if norm(SCALE-[0.001;1]) > %eps then pause,end
[W,TAU]=dgeqrf(A);
m=2;V=[];for i=1:2;w(1:i-1)=0;w(i)=1;w(i+1:m)=W(i+1:m,i);V=[V,w];end;
Q=(eye()-TAU(2)*V(:,2)*V(:,2)')*(eye()-TAU(1)*V(:,1)*V(:,1)');
QA=Q*A;
if norm(QA(1,:) - W(1,:))  > %eps then pause,end
