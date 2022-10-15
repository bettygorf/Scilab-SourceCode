function [txt]=strcat(strs,opt)
//txt=strcat(strs) catenates character strings: txt=strs(1)+...+strs(n)
//
//txt= strcat(strs,opt) returns txt=strs(1)+opt+...+opt+strs(n)
//Example: strcat(string(1:10),',')
//!
if type(strs)<>10 then error(55,1),end
n=prod(size(strs))
if n==0 then txt=' ',return,end
txt=strs(1)
[lhs,rhs]=argn(0)
if rhs==1 then
  for k=2:n,txt=txt+strs(k),end
else
  if type(opt)<>10 then error(55,2),end
  if prod(size(opt))<>1 then error(89,2),end
  for k=2:n,txt=txt+opt+strs(k),end
end

