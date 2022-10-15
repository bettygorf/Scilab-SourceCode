function [stk,txt,top]=sci_eval()
// Copyright INRIA
txt=[]
write(logfile,'Warning: eval argument not translated to scilab syntax. Check')
if lhs==1 then
  if rhs==1 then
    if and(lst(ilst+1)==['1' 'ans']) then
      stk=list('execstr('+stk(top)(1)+')','0','?','?','?')
    else
      stk=list('evstr('+stk(top)(1)+')','0','?','?','?')
    end
  else
    if and(lst(ilst+1)==['1' 'ans']) then
      txt=['if '+'execstr('+stk(top-1)(1)+',''errcatch'')'+'<>0 then' 
          '  execstr('+stk(top)(1)+')'
          'end']
      stk=list(' ','-2','?','?','?')
    elseif lst(ilst+1)(1)=='1' then
      v=lst(ilst+1)(2)
      txt=['if '+'execstr('+v+'='+stk(top-1)(1)+',''errcatch'')'+'<>0 then' 
          '  execstr('+v+'='+stk(top)(1)+')'
          'end']
      stk=list(' ','-2','?','?','?')
    end
    top=top-1
  end
else
  LHS=[]
  for k=1:lhs,   LHS=[LHS,lst(ilst+k)(2)],end
  if rhs==1 then
    txt='execstr('+sci2exp(lhsargs(LHS)+' = '+stk(top)(1))+')'
  else

    txt=['if '+'execstr('+sci2exp(lhsargs(LHS)+' = '+stk(top-1)(1))+',''errcatch'')'+'<>0 then'
            '  execstr('+sci2exp(lhsargs(LHS)+' = '+stk(top)(1))+')'
            'end']
  end
  stk=list()
  for k=1:lhs,stk(k)=list(' ','-2','0','?','?','?'),end
  top=top-rhs+1
end
