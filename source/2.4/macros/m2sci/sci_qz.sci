function [stk,txt,top]=sci_qz()
// Copyright INRIA
txt=[]

if lhs==1 then
  stk=list('gschur('+stk(top-1)(1)+','+stk(top)(1)+')','0','?','?','1')
else
  stk=list()
  s=list('gschur('+stk(top-1)(1)+','+stk(top)(1)+')','-1','?','?','1')
  if lhs==5 then
    [AA, BB, Q, Z, V]=lhsvarsnames()
    txt=[txt;lhsargs([AA, BB, Q, Z, V])+' = mtlb_qz'+..
	    rhsargs([stk(top-1)(1),stk(top)(1)])]
    s=list(' ','-2','0','0','0')
  end
  for k=1:lhs
    stk(k)=s
  end
end


