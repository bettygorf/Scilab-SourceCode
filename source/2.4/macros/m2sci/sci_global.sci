function [stk,txt,top]=sci_global()

// Copyright INRIA
RHS=[]
for k=1:rhs
  nam=stk(top-rhs+k)(1)
  if ischanged(lst,nam) then
    RHS=[RHS nam]
  end
end
if RHS<>[] then
  txt=['// global('+makeargs(RHS)+') cannot be properly handled'
       '// variables are modified by the function']
  write(logfile,txt)
end
stk=list(' ','-2','0','0','1')

function r=ischanged(lst,nam)
r=%f
for lstk=lst
  if type(lstk)==15 then
    r=r|ischanged(lstk,nam)
  else
    if (lstk(1)=='1'|lstk(1)=='for') then
      if lstk(2)==nam then 
	r=%t
	break
      end
    end
  end
end

