function [out1,out2]=m_sin(t,x,z,u,clock,flag,rpar,ipar)
//if flag>0 then write(0,'m_sin t='+string(t)+' flag ='+string(flag)),end
out1=[];out2=[];
select flag
case 1 then
  out1=sin(rpar(1)*t+rpar(2))
case 2 then
   x_message('?')
case 3 then 
  x_message('?')
case -1 then //initialisation
  model=t
  label='Sin'
  state=[]
  dstate=[]
  rpar=[1;0]
  model=list(model(1),0,1,0,0,state,dstate,rpar,[],'d',-1,[%f %t])
  out1=list(model,label)
case -2 then //update
  model=t
  label=x
  rpar=model(8);gain=rpar(1);phase=rpar(2)
  [ok,label1,gain,phase]=getvalue('Set Sin block parameters',..
      ['Block label';'Frequency';'Phase'],list('str',1,'vec',1,'vec',1),..
      [label;string(gain);string(phase)])
  if ok then
    model(8)=[gain;phase]
    label=label1
  end
  out1=list(model,label)
end
