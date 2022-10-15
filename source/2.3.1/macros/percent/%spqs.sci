function r=%spqs(a,b)
//r=a.\b
[ij,v,mn]=spget(a)
if size(v,'*')<>mn(1)*mn(2) then
  error(27)
else
  r=full(a).\b
end
