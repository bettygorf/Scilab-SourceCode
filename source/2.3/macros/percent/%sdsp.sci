function r=%sdsp(a,b)
//r=a./b
[ij,v,mn]=spget(b)
if size(v,'*')<>mn(1)*mn(2) then
  error(27)
else
  r=a./full(b)
end
