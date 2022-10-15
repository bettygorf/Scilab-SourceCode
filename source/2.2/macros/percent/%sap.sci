function [z]=%sap(x,y)
//z = scalar + polynomial matrix = x + y
[m,n]=size(x);
if m*n==1 then
   z=x*ones(y)+y;
          else
   z=x+y*ones(x);
end

