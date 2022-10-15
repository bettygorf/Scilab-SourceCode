function [scs_m,needcompile]=do_delete(scs_m,needcompile)
// do_delete - delete a scicos object
// get first object to delete
//!
// Copyright INRIA
while %t
  [btn,xc,yc,win,Cmenu]=getclick()
  if Cmenu<>[] then
    Cmenu=resume(Cmenu)
  end
  
  K=getobj(scs_m,[xc;yc])
  if K<>[] then break,end
end
scs_m_save=scs_m,nc_save=needcompile
[scs_m,DEL]=do_delete1(scs_m,K,%t)
if DEL<>[] then 
  needcompile=4,

  //suppress right-most deleted elements
  while scs_m($)==list('Deleted') then
    scs_m($)=null();
  end
  [scs_m_save,nc_save,enable_undo,edited]=resume(scs_m_save,nc_save,%t,%t)
end

