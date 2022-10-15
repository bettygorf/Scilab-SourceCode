function [ok,scs_m,cpr]=do_load(fname)

if alreadyran then do_terminate(),end  //end current simulation
cpr=list()
current_version=scicos_ver
scicos_ver='scicos2.2'
[lhs,rhs]=argn(0)
scs_m=[]
if rhs<=0 then fname=xgetfile('*.cos*'),end
if fname<>emptystr() then
  [path,name,ext]=splitfilepath(fname)
  select ext
  case 'cosf'
    exec(fname,-1)
    ok=%t
  case 'cos' then
    load(fname),
    ok=%t
  else
    message(['Only *.cos (binary) and *.cosf (formatted) files';
      'allowed'])
    ok=%f
    scs_m=list()
    return
  end
  if scs_m==[] then scs_m=x,end //for compatibility
  scs_m(1)(2)=[scs_m(1)(2)(1),path]
  if scicos_ver<>current_version then 
    scs_m=do_version(scs_m,scicos_ver),
    cpr=list()
  end
  if size(scs_m(1)(1),'*') <4 then scs_m(1)(1)=[scs_m(1)(1),0,0],end //compatibility
  if size(scs_m(1))<5 then scs_m(1)(5)=' ',end  //compatibility
  if type(scs_m(1)(5))<>10 then scs_m(1)(5)=' ',end //compatibility
else
  ok=%f
  scs_m=list()
end


