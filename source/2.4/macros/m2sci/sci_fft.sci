function [stk,txt,top]=sci_fft()
// Copyright INRIA
txt=[]
if rhs==1 then
  if stk(top)(3)=='1'|stk(top)(4)=='1' then
    stk=list('fft('+stk(top)(1)+',[],-1)','0',stk(top)(3),stk(top)(4),'1','?')
  else
    write(logfile,'Warning: Not enough information on arg size using mtlb_fft instead of fft')
    txt=['//mtlb_fft may be replaced by fft if '+stk(top)(1)+' is a vector']
    stk=list('mtlb_fft('+stk(top)(1)+',[],-1)','0',stk(top)(3),stk(top)(4),'1','?')
  end
else  
  stk=list('mtlb_fft('+stk(top-1)(1)+','+stk(top)(1)+',-1)','0','?','?','1','?')
end
