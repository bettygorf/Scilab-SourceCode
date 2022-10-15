function ok=do_save(scs_m)   
// saves scicos data structures scs_m and cpr on a binary file
//!
if pal_mode then scs_m=do_purge(scs_m),end
//file path
if size(scs_m(1)(2),'*')<2 then 
  path='./'
else
  path=scs_m(1)(2)(2)
end
//open file

fname=path+scs_m(1)(2)(1)+'.cos'

errcatch(240,'continue','nomessage')
u=file('open',fname,'unknown','unformatted')
errcatch(-1)
if iserror(240)==1 then
  message('Directory write access denied')
  errclear(240)
  ok=%f
  return
end
//update cpr data structure to make it coherent with last changes
if needcompile==4 then
  cpr=list()
else
  [cpr,state0,needcompile,ok]=do_update(cpr,state0,needcompile)
  if ~ok then return,end
  cpr(1)=state0
end
//save
save(u,scicos_ver,scs_m,cpr)
file('close',u)
if pal_mode then update_scicos_pal(path,scs_m(1)(2)(1),fname),end
ok=%t

