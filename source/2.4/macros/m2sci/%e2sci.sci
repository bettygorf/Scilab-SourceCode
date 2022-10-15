function [stk,txt,top]=%e2sci()
// genere le code relatif a l'extraction d'une sous matrice
//!
// Copyright INRIA
txt=[]
rhs=maxi(0,abs(evstr(op(3)))-1)
sn=stk(top);top=top-1
s2=stk(top)
if rhs==1 then
  if s2(1)==':' then
    stk=list(sn(1)+'('+s2(1)+')','0','?','1',sn(5))
  elseif sn(3)=='1' then
    stk=list(sn(1)+'('+s2(1)+')','0','1','?',sn(5))
  elseif sn(4)=='1' then
    stk=list(sn(1)+'('+s2(1)+')','0','?','1',sn(5))
  elseif s2(4)=='1' then
    stk=list(sn(1)+'('+s2(1)+')','0','?','1',sn(5))
  else
    v='mtlb_e'+rhsargs([sn(1),s2(1)])
    txt='// '+v+' may be replaced by '+sn(1)+'('+s2(1)+')'+' if '+sn(1)+' is a vector.'
    stk=list(v,'0','?','?',sn(5))
  end
else
  s1=stk(top-1);top=top-1
  if s1(3)=='1'&s1(4)=='1' then
    stk=list(sn(1)+rhsargs([s1(1),s2(1)]),'0','1','?',sn(5))
  elseif  s2(3)=='1'&s2(4)=='1' then
    stk=list(sn(1)+rhsargs([s1(1),s2(1)]),'0','?','1',sn(5))
  else
    stk=list(sn(1)+rhsargs([s1(1),s2(1)]),'0','?','?',sn(5))
  end
end
 

