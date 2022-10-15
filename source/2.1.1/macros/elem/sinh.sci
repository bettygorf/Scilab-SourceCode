function [t]=sinh(x)
//Syntax : <t>=sinh(x)
//
//hyperbolic sine 
//!
if type(x)<>1 then error(53),end
[m,n]=size(x)
t=exp(x)
if m<>n then t=(t-ones(m,n)./t)/2
        else t=(t-1/t)/2
end



