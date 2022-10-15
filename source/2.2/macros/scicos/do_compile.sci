function  [state,sim,cor,corinv,ok]=do_compile(x)
par=x(1);sim_mode=par(5);
[bllst,connectmat,clkconnect,cor,corinv,ok]=c_pass1(x);x=null()
if ~ok then 
  state=list(),sim=list(),cor=[],corinv=[]
  return,
end
[state,sim,cor,corinv,ok]=c_pass2(bllst,connectmat,clkconnect,cor,corinv,sim_mode)
if ~ok then 
  state=list(),sim=list(),cor=[],corinv=[]
  return,
end
