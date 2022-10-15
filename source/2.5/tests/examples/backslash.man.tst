clear;lines(0);
A=rand(3,2);b=[1;1;1]; x=A\b; y=pinv(A)*b;  x-y
A=rand(2,3);b=[1;1]; x=A\b; y=pinv(A)*b; x-y, A*x-b, A*y-b
A=rand(3,1)*rand(1,2); b=[1;1;1]; x=A\b; y=pinv(A)*b; A*x-b, A*y-b
A=rand(2,1)*rand(1,3); b=[1;1]; x=A\b; y=pinv(A)*b; A*x-b, A*y-b 
