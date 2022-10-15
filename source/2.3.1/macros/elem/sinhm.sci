function x=sinhm(a)
//square matrix hyperbolic sine 
//!
if type(a)<>1 then error(53),end
if a==[] then x=[],return,end
x=(expm(a)-expm(-a))/2





