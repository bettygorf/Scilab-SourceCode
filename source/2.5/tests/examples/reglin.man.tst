clear;lines(0);
// simulation of data for a(3,5) and b(3,1)
x=rand(5,100);
aa=testmatrix('magi',5);aa=aa(1:3,:);
bb=[9;10;11]
y=aa*x +bb*ones(1,100)+ 0.1*rand(3,100);
// identification 
[a,b,sig]=reglin(x,y);
maxi(abs(aa-a))
maxi(abs(bb-b))
// an other example : fitting a polynom 
f=1:100; x=[f.*f; f];
y= [ 2,3]*x+ 10*ones(f) + 0.1*rand(f);
[a,b]=reglin(x,y)
