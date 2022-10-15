function [scs_m,needcompile]=do_delete(scs_m,needcompile)
// do_delete - delete a scicos object
// get first object to delete
//!
while %t
  [btn,xc,yc]=xclick(0);
  pt=[xc,yc]
  [n,pt]=getmenu(datam,pt);
  if n>0 then n=resume(n),end
  if btn<>0 then
    [scs_m,modified]=do_delete_region(scs_m,xc,yc)
    if modified then needcompile=4,end
    return
  end
  K=getobj(scs_m,[xc;yc])
  if K<>[] then break,end
end

[scs_m,DEL]=do_delete1(scs_m,K,%t)
if DEL<>[] then needcompile=4,end

//suppress right-most deleted elements
while scs_m($)==list('Deleted') then
  scs_m($)=null();
end

