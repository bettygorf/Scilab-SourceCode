function [g]=make_graph(name,directed,n,tail,head)
[lhs,rhs]=argn(0)
if rhs<>5 then error(39), end
// name
if type(name)<>10|prod(size(name))<>1 then
  error('make_graph: ""name"" must be a string')
end
// directed
if directed<>1&directed<>0 then
  error('make_graph: ""directed"" must be 0 or 1')
end
// node_number
if prod(size(n))<>1|n<1
  error('make_graph: ""n"" must greater than 1')
end
// tail
s=size(tail)
if s(1)<>1 then
  error('make_graph: ""tail"" must be a row vector')
end
ma=s(2)
// head
s=size(head)
if s(1)<>1 then
  error('make_graph: ""head"" must be a row vector')
end
if s(2)<>ma then
  error('make_graph: ""tail"" and ""head"" must have identical sizes')
end
// tail and head
if min(min(tail),min(head))<1|max(max(tail),max(head))>n then
  error('make_graph: ""tail"" and ""head"" do not represent a graph')
end
g=tlist('graph',name,directed,n,tail,head,..
    [],[],[],[],[],[],[],[],[],[],..
    [],[],[],[],[],[],[],[],[],[],..
    [],[],[],[],[],[],[],[])
