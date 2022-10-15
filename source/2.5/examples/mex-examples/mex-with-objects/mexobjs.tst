exec startup.sce;
[p,q,r]=mexfunction1(1:4,'qwerty');
if r~='qwerty' then pause,end
[a,x]=mexfunction2(20,'x');
if a~=20 then pause,end
A=rand(2,2);B=rand(2,3);
C=mexfunction3(A,B);
if norm(A*B-C) > %eps then pause,end
p=mexfunction4(1:3,'x');
if p ~= poly(1:3,'x') then pause,end
w1=mexfunction5(1:5);
if and(w1~=(1:5)) then pause,end
w2=mexfunction6(1:5);
if and(w2~=(1:5)) then pause,end
w=rand(2,3);w(10,15)=0;w=sparse(w);
mexfunction7(mtlb_sparse(w));
w=mexfunction8();
if w(1)~='123456789 ' then pause,end
mexfunction9() // prints something calling disp 

clear myvar;
A=mexfunction10() // search myvar 
if A<>"variable myvar not found" then pause,end
myvar=1:45;
A=mexfunction10() // search myvar again 
if A<>"variable myvar found size=[1,45]" then pause,end


mexfunction11() // creates A11 with a mexEvalString
if A11<>[1,2,3,4] then pause,end

mexfunction12() // creates C with a WriteMatrix (<==> mxPutArray)
if C<>matrix(0:7,4,2) then pause,end

mexfunction13() // creates X with a mexEvalString 
// then try to get it with mexGetArray 
if X<>[1,2,3] then pause,end


