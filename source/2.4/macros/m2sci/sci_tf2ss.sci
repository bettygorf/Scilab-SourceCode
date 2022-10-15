function [stk,txt,top]=sci_tf2ss()
// Copyright INRIA
txt=[]
H=gettempvar()
N=stk(top-1)(1)
D=stk(top)(1)
txt=H+' = tf2ss(rlist(poly('+N+'($:-1:1),''x''),poly('+D+'($:-1:1),''x'')))'
r=list(H+'(2:'+string(lhs+1)+')','-1','?','?','1')
stk=list()
for k=1:lhs
  stk(k)=r
end


