function [t]=acosh(x)
//Syntaxes : <t>=acosh(x)
//
//Hyberbolic cosine inverse of x
//Entries of x in ]1,+inf[
//Outputs in   ]0,+inf[ x ]-pi,pi]
//                  and    [0] x [0,pi]
//
//!
if type(x)<>1 then error(53),end
[m,n]=size(x)
if m<>n then t=log(x+(x+ones(m,n)).*sqrt((x-ones(m,n))./(x+ones(m,n))))
        else t=log(x+(x+eye)*sqrt((x-eye)/(x+eye)))
end



