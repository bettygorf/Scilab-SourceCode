function  [cpr,ok]=do_compile(scs_m)
// Copyright INRIA
par=scs_m(1);
if alreadyran then 
  //terminate current simulation
  do_terminate()
end

timer()
disablemenus()
[bllst,connectmat,clkconnect,cor,corinv,ok]=c_pass1(scs_m);
scs_m=null()
if ~ok then
  cpr=list()
  enablemenus()
  return,
end
cpr=c_pass2(bllst,connectmat,clkconnect,cor,corinv)
if cpr==list() then ok=%f,end
  
enablemenus()
