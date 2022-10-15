function [z]=%pap(x,y)
//z = x + y one of which is a polynomial
// and other matrix polynomial
[m,n]=size(x)
if m*n==1 then
   z=x*ones(y)+y
            else
   z=x+y*ones(x)
end
