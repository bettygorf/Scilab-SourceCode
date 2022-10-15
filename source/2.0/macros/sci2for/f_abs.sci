//[stk,nwrk,txt,top]=f_abs(nwrk)
//!
nam='abs'
txt=[] 
s2=stk(top)
v=s2(1)
it2=prod(size(v))-1
if it2==0 then
  [stk,nwrk,txt,top]=f_gener(nam,nwrk,[s2(3),s2(3)])
else
  error(nam+' of complex argument is not implemented')
end
//end


