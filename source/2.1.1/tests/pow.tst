//test with scalar vector and matrices
x1=1:3;
x0=0:2;
if or(x1**2<>[1 4 9]) then pause,end
if or(x0**2<>[0 1 4]) then pause,end
if or(x1**0<>[1 1 1]) then pause,end

if norm(x1**(2*(1+%eps))-x1**2)>100*%eps then pause,end
if norm(x0**(2*(1+%eps))-x0**2)>100*%eps then pause,end

if norm(x1**(-2)-[1 0.25 1/9])>100*%eps then pause,end
if norm(x1**(-2*(1+%eps))-[1 0.25 1/9])>100*%eps then pause,end

p=2+%eps*%i;
if norm(x1**p-x1**2)>100*%eps then pause,end
if norm(x0**p-x0**2)>100*%eps then pause,end
if norm(x1**(-p)-x1**(-2))>100*%eps then pause,end

y=%eps*%eps*ones(1,3);x1=x1+y;x0=x0+y;
if norm(x1**2-[1 4 9])>100*%eps then pause,end
if norm(x0**2-[0 1 4])>100*%eps then pause,end

x1**2.000000001;x0**2.000000001;
if norm(x1**2-[1 4 9])>100*%eps then pause,end
if norm(x0**2-[0 1 4])>100*%eps then pause,end

if norm(x1**(-2)-[1 0.25 1/9])>100*%eps then pause,end
if norm(x1**(-2*(1+%eps))-[1 0.25 1/9])>100*%eps then pause,end
if norm(x1**p-x1**2)>100*%eps then pause,end
if norm(x0**p-x0**2)>100*%eps then pause,end
if norm(x1**(-p)-x1**(-2))>100*%eps then pause,end

x1=[1 2;3 4];
if or(x1**1<>x1) then pause,end
if or(x1**(-1)<>inv(x1)) then pause,end
if or(x1**2<>x1*x1) then pause,end
if or(x1**(-2)<>inv(x1)**2) then pause,end

x1(1,1)=x1(1,1)+%i;
if or(x1**2<>x1*x1) then pause,end
if or(x1**(-2)<>inv(x1)**2) then pause,end
if or(x1**1<>x1) then pause,end
if or(x1**(-1)<>inv(x1)) then pause,end

if or(rand(4,4)**0<>eye(4,4)) then pause,end


x1=[1 2;2 3];x2=x1**(1/2);
if norm(x2**(2)-x1)>100*%eps then pause,end
x2=x1**(-1/2);
if norm(x2**(-2)-x1)>100*%eps then pause,end

//x1=[1 2+%i;2-%i 3];
//x2=x1**(1/2);
//if norm(x2**(2)-x1)>100*%eps then pause,end
//x2=x1**(-1/2);
//if norm(x2**(-2)-x1)>100*%eps then pause,end

//test with polynomial vector and matrices
s=poly(0,'s');
if or(coeff(s**3+1)<>[1 0 0 1]) then pause,end


x1=[1 s+1 s**3+1];
if or(x1**2<>[1 1+2*s+s**2  1+2*s**3+s**6]) then pause,end
if or(coeff(x1**0)<>[1 1 1]) then pause,end
if or(x1**3<>[1,1+3*s+3*s^2+s^3,1+3*s^3+3*s^6+s^9]) then pause,end
if or((x1**(-1)-[1 1/(1+s)  1/(1+s**3)])<>0) then pause,end

x1=[s+1 2*s;3+4*s^2 4];
if or(x1**1<>x1) then pause,end
if or(x1**(-1)<>inv(x1)) then pause,end
if or(x1**2<>x1*x1) then pause,end
if or(x1**(-2)<>inv(x1)**2) then pause,end

x1(1,1)=x1(1,1)+%i;
if or(x1**2<>x1*x1) then pause,end
//if or(x1**(-2)<>inv(x1)**2) then pause,end  //simp complexe non implemented
if or(x1**1<>x1) then pause,end
//if or(x1**(-1)<>inv(x1)) then pause,end //simp complexe non implemented


