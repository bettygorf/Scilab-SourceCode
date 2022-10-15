function [lp,la,ls]=adj_lists(directed,n,tail,head)
[lhs,rhs]=argn(0)
if rhs<>4 then error(39), end
// check directed
if directed<>1&directed<>0 then
  error('First argument must be 0 or 1')
end
// check n
if prod(size(n))<>1|n<1
  error('Second argument must be greater than 1')
end

// check tail
s=size(tail)
if s(1)<>1 then
  error('Third argument must be a row vector')
end
ma=s(2)
// check head
s=size(head)
if s(1)<>1 then
  error('Fourth argument must be a row vector')
end
if s(2)<>ma then
  error('""tail"" and ""head"" must have identical sizes')
end
// check tail and head
if min(min(tail),min(head))<1|max(max(tail),max(head))>n then
  error('""tail"" and ""head"" do not represent a graph')
end
// compute lp, la and ls
if directed==1 then
  [lp,la,ls]=m6ta2lpd(tail,head,n+1,n)
else
  [lp,la,ls]=m6ta2lpu(tail,head,n+1,n,2*ma)
end
