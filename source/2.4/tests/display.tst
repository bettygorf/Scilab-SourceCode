// Copyright INRIA
z=poly(0,'z')
//lines(20,60)
format('v',10)
num=[ (((((1)*z-2.6533333)*z+2.6887936)*z-1.2916784)*z+0.2911572)*...
     z-0.0243497
      (((((1)*z-2.6533333)*z+2.6887936)*z-1.2916784)*z+0.2911572)*...
     z-0.0243497
     (((1)*z )*z )*z+1
     0]
den = [ ((((1)*z-1.536926)*z+0.8067352)*z-0.1682810)*z+0.0113508
((((1)*z-1.536926)*z+0.8067352)*z-0.1682810)*z+0.0113508
((1)*z )*z
1]
num',den'
[num;den]
[num den]
r=num./den
r'
//
digits='abcdefghijklmnopqrstuvwxyz'
numbers='1234567890'
majuscules='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
symbols=',./;''[] \ =-!\$%^&*()_+~:""[]| @'
[numbers;digits]
[numbers digits;digits numbers]
[numbers digits+digits+digits]
ans';
[ans ans]

z=poly(0,'z')
n=1+z;d=n*n;n1=[n d];d1=[d d*d];n1=[n1 n1];d1=[d1 d1];
n2=[n n*n;n*n n**4];d2=[n*n n**4;n n*n];den=d2(1,:);num=n2(2,:);
p=poly(rand(5,1),'z');q=poly(rand(6,1),'z');
p1=[p,0.1+2.35*z-5.05*z**3];q1=[q,2.56+0.03*z-10.01*z*z+z**5];
d3=[1+z**10 z**15];
tlist('r',d,n)
tlist('r',n,d)
tlist('r',d2,n2)
tlist('r',n2,d2)
tlist('r',den,num)
tlist('r',num,den)
tlist('r',p1,q1)
tlist('r',q1,p1)
tlist('r',p,q)
tlist('r',q,p)
tlist('r',p,z)
tlist('r',z,p)
tlist('r',d1,n1)
tlist('r',n1,d1)
