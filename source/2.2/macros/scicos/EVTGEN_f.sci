function [x,y,typ]=EVTGEN_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then 
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,label]=graphics([1:2 4])
  model=arg1(3);tt=model(11)
  xstringb(orig(1),orig(2),['Event at';'time '+string(tt)],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);tt=model(11);
  while %t do
    [ok,label,tt]=getvalue('Set Event time',..
	['Block label';'Event Time'],..
	list('str',1,'vec',1),..
	[label;string(tt)])
    if ~ok then break,end
    if ok then
      graphics(4)=label
      if model(11)<>tt then
	model(11)=tt
	x_message(['Because of this modification,';..
	    'diagram should be manually compiled';..
	    '(Compile) before simulation (Run).'])
      end
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  tt=0
  model=list('trash',0,0,0,1,[],[],[],[],'d',tt,[%f %f])
  x=standard_define([2 2],model)
end

