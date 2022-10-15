function [x,y,typ]=HALT_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then //normal  position 
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,label]=graphics([1:2 4])
  model=arg1(3);dt=model(8)
  xstringb(orig(1),orig(2),['STOP'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);n=model(9);
  while %t do
    [ok,label,n]=getvalue('Set Halt block parameters',..
	['Block label';'State on halt'],..
	list('str',1,'vec',1),..
	[label;string(n)])
    if ~ok then break,end
    if ok then
      graphics(4)=label
      model(9)=n
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  model=list('hltblk',0,0,1,0,[],[0],[],[0],'d',%f,[%f %f])
  x=standard_define([2 2],model)
end

