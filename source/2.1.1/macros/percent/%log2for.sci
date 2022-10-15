//[stk,nwrk,txt,top]=%log2for(nwrk)
//
//!
txt=[]
iop=evstr(op(2))
s2=stk(top);s1=stk(top-1);top=top-1
if s2(2)='2' then s2(1)='('+s2(1)+')',end
if s1(2)='2' then s1(1)='('+s1(1)+')',end
stk=list(s1(1)+ops(iop,1)+s2(1),'1')
//end


