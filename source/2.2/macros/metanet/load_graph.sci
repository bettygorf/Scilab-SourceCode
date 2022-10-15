function [g]=load_graph(path)
[lhs,rhs]=argn(0)
if rhs<>1 then error(39),end
// path
if type(path)<>10|prod(size(path))<>1 then
  error('load_graph: argument must be a string')
end
g1=loadg(path)
g=tlist('graph')
for i=2:32, g(i)=g1(i-1), end
g(33)=[]; g(34)=[]
