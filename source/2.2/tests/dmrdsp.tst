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
