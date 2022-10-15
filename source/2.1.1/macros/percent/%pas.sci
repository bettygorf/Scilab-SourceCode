function [z]=%pas(x,y)
//z = polynomial matrix + constant matrix = x + y
// one of which is 1 by 1
[m,n]=size(x);
if m*n==1 then 
   z=x*ones(y)+y
          else
   z=x+y*ones(x)
end


