//[stk,nwrk,t1,top]=func2f(op,stk,nwrk)
// genere la traduction de l'ensemble des primitives 
//!
lhs=evstr(op(4))
rhs=evstr(op(3))
t1=[]
execstr('[stkr,nwrk,t1,top]=f_'+op(2)+'(nwrk)')
if lhs>1 then
  top=top-1
  for k=1:lhs
    top=top+1
    stk(top)=stkr(k)
  end
else
  stk(top)=stkr
end
//end
