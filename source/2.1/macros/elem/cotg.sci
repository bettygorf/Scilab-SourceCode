function [t]=cotg(x)
//Syntax : [t]=cotg(x)
//
//Cotangent of x (x is a vector)
if type(x)<>1 then error(53),end
[m,n]=size(x)
if m<>n|m*n=1 then t=sin(x).\cos(x)
        else error('function not implemented for square matrices!')
end



