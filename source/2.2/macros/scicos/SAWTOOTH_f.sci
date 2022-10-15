function [x,y,typ]=SAWTOOTH_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then //normal  position 
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,label]=graphics([1:2 4])
  model=arg1(3);dt=model(8)
  xstringb(orig(1),orig(2),['sawtooth';'generator'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);dt=model(8);
  while %t do
    [ok,label,dt]=getvalue('Set Sawtooth generator block parameters',..
	['Block label';'dt'],..
	list('str',1,'vec',1),..
	[label;string(dt)])
    if ~ok then break,end
    if ok then
      if dt>0 then nclkout=1,else nclkout=0,end
      [model,graphics,ok]=check_io(model,graphics,0,1,1,nclkout)
      if ok then
	graphics(4)=label
	model(8)=[dt]
	x(2)=graphics;x(3)=model
	break
      end
    end
  end
case 'define' then
  model=list('sawtth',0,1,1,1,[],[0],[0.1],[0],'d',%t,[%f %t])
  x=standard_define([3 2],model)
end

