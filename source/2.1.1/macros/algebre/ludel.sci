function [w]=ludel(w)
[lhs,rhs]=argn(0), if rhs<>1 then error('bad call to ludel: (one input)'), end
if type(w) <> 15 then error('argument must be a list'), end
if w(1)~='factored' then error('wrong argument to ludel');end
w(1)='cleared';ludel1(w(3));
w=return(null())






