function [x,y,typ]=EVTDLY_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then //normal  position 
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,label]=graphics([1:2 4])
  model=arg1(3);dt=model(8)
  xstringb(orig(1),orig(2),['Delay';string(dt)],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);  dt=model(8)
  if model(11) then ff=1; else ff=0; end
  while %t do
    [ok,label,dt,ff]=getvalue('Set Event Delay  block parameters',..
	['Block label';'Delay';'Auto-exec (0,1)'],..
	list('str',1,'vec',1,'vec',1),..
	[label;string(dt);string(ff)])
    if ~ok then break,end
    if ff==0 then tt=%f; else tt=%t;end
    if dt<=0 then
      x_message('Delay must be positive')
      ok=%f
    end
    if ok then
      graphics(4)=label
      model(8)=dt
      model(11)=tt
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  dt=0.1
  model=list('evtdly',0,0,1,1,[],[],dt,[],'d',%t,[%f %f])
  x=standard_define([2 2],model)
end

