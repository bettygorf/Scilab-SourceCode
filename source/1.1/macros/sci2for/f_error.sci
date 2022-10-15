//[stk,nwrk,txt,top]=f_error(nwrk)
//
//!
txt=[]
s=stk(top);mess=s(1)
if part(mess,1)='''' then mess=part(mess,2:length(mess)-1),end
 
[errn,nwrk]=adderr(nwrk,mess)
txt=[' ierr='+string(errn);' return']
stk=list(' ','-1','-1')
//end


