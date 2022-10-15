clear;lines(0);
x=poly(0,'x');
p1=(x+1)*(x-3)^5;p2=(x-2)*(x-3)^3;
[thegcd,U]=bezout(p1,p2) 
det(U)
clean([p1,p2]*U)
thelcm=p1*U(1,2)
lcm([p1,p2])
