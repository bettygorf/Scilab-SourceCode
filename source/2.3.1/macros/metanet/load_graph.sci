function [g]=load_graph(path)
[lhs,rhs]=argn(0)
if rhs<>1 then error(39),end
// path
if type(path)<>10|prod(size(path))<>1 then
  error('Argument must be a string')
end
g1=m6loadg(path)
g=glist()
for i=2:32, g(i)=g1(i-1), end
g(33)=[]; g(34)=[]
