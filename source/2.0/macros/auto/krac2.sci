function [kp,kn,rp,rn]=krac2(n,d)
[lhs,rhs]=argn(0)
if rhs=1 then
   if type(n)<>15 then error(97,1),end;
   select n(1)
     case 'r' then [n,d]=n(2:3)
     case 'lss' then n=ss2tf(n);[n,d]=n(2:3)
     else error(97,1),
   end;
end;
if prod(size(n))<>1 then error(95,1),end
x=[];
q1=derivat(n/d);s=roots(q1(2));
//
for a=s',if abs(imag(a))<=10*%eps then x=[x;a],end,end
if x=[] then;return,end
//
nx=prod(size(x))
y=real(-ones(1,nx)./freq(n,d,real(x)))
//
kp=[];kn=[];rp=[];rn=[]
y=sort(y)
i1=1;i2=1;eps=1.
while i1<=nx
 crit=abs((y(i1)-y(i2))/y(i1))
 if crit<10*%eps then
                     i1=i1+1
                 else
                     if y(i1)>0 then
                        kp=[kp y(i1)],rp=[rp,x(i1)]
                                else
                        kn=[kn y(i1)],rn=[rn,x(i1)]
                     end;
                     y(i2+1)=y(i1),i2=i2+1,i1=i1+1
 end;
end;



