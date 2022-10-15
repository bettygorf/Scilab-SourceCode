function x=g_det(a)
// only to be called by function det
//!
// Copyright INRIA
a1=a(1);
select type(a)
case 2 then 
  x=determ(a)
  
//-compat next case retained for list/tlist compatibility
case 15 then
  if a1(1)=='r' then
    [n,d]=lcmdiag(a);
    x=determ(n)/determ(d);
    //x=detr(a);
  else
    error(43)
  end
case 16 then
  if a1(1)=='r' then
    [n,d]=lcmdiag(a);
    x=determ(n)/determ(d);
    //x=detr(a);
  else
    error(43)
  end
else
  error(43)
end
