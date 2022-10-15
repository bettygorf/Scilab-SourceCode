function varargout=%hm_size(M,job)
// Copyright INRIA
// returns dimensions of an hyper matrix


[lhs,rhs]=argn(0)
dims=M('dims')
if rhs==2 then
  if job=='*' then
    x1=prod(M('dims'))
  elseif type(job)==1 then
    if size(job,'*') >1 then error('Second argument is incorrect'),end
    if job<=0|job>size('dims') then error('Second argument is incorrect'),end
    x1=M('dims')(job)
  else
    error('Second argument is incorrect')
  end
  return
end
if lhs==1 then
  varargout(1)=M('dims')'
else
  if lhs>size(M('dims'),'*') then error('Too many LHS args'),end
  for k=1:lhs
    varargout(k)=dims(k)
  end
end




