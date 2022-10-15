function f=invr(h)
//if h is a scalar, polynomial or rational fonction matrix, invr
//computes h^(-1).
//!
h1=h(1);
if type(h)==1 then f=inv(h);return;end
if type(h) == 2 then
[m,n]=size(h);
if m<>n then error(20),end
ndeg=maxi(degree(h));
    if ndeg==1 then
      E=coeff(h,1);A=-coeff(h,0);
         if norm(E-eye(E),1) < 100*%eps then
         [num,den]=coff(A,varn(h));f=num/den;
         return
       end
      [Bfs,Bis,chis]=glever(E,A,varn(h));
      f=Bfs/chis - Bis;
      return;
    end;
f=eye(n,n);
   for k=1:n-1,
       b=h*f,
       d=-sum(diag(b))/k
       f=b+eye(n,n)*d,
   end;
   d=sum(diag(h*f))/n,
   if degree(d)=0 then d=coeff(d),end,
   f=f/d;
   return;
 end
 
//-compat type(h)==15 retained for list/tlist compatibility
if type(h)==15|type(h)==16 then
   if h1(1)<> 'r' then error(44),end
   [m,n]=size(h(2));
   if m<>n then error(20),end
   f=eye(n,n);
   for k=1:n-1,
       b=h*f,
       d=0;for l=1:n,d=d+b(l,l),end,d=-d/k;
       f=b+eye(n,n)*d,
   end;
   b=h*f;d=0;for l=1:n,d=d+b(l,l),end;d=d/n,
   f=f/d;
   return;
end;
error('invalid input to invr');





