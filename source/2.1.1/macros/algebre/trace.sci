function t=trace(a)
// trace - computes the trace of a matrix
select type(a)
case 1 then
  [m,n]=size(a)
  if m<>n then error('the argument of trace must be a square matrix');end
  t=sum(diag(a))
case 2 then
  [m,n]=size(a)
  if m<>n then error('the argument of trace must be a square matrix');end
  t=sum(diag(a))
case 15 then
  if a(1)=='r' then
    [m,n]=size(a)
    if m<>n then error('the argument of trace must be a square matrix');end
    t=sum(diag(a))
  else
    error('invalid argument for trace');
  end
case 5 then
  [m,n]=size(a)
  if m<>n then error('the argument of trace must be a square matrix');end
  t=sum(diag(a))
else
  error('invalid argument for trace');
end
