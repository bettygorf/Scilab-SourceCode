function [t]=tan(x)
//Syntax : [t]=tan(x)
//
// Tangent
//!
if type(x)<>1 then error(53),end
[m,n]=size(x)
if m<>n then t=sin(x)./cos(x)
        else t=sin(x)/cos(x)
end



