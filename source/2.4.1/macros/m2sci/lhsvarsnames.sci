function varargout=lhsvarsnames()
// Copyright INRIA
varargout=list([])
lhs0=lhs
[lhs,rhs]=argn(0)
for k=1:lhs0
  varname=lst(ilst+lhs0+1-k)(2)
  p=find(varname==vnms(:,2))
  if p<>[] then 
    varname=vnms(p,1),
  else
    if funptr(varname)<>0 then varname='%'+varname,end
  end
  if lhs>1 then
    varargout(k)=varname
  else
    varargout(1)(k,1)=varname
  end
end
