function [x,y,typ]=INTEGRAL_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,orient,label]=graphics(1:4)
  xstringb(orig(1),orig(2),['  1/s  '],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);x0=model(6);
  while %t do
   [ok,label,x0]=getvalue('Set continuous linear system parameters',..
	['Block label';
	'Initial state'],..
	list('str',1,'vec',1),..
	[label;
	 strcat(sci2exp(x0))])
    if ~ok then break,end
    graphics(4)=label;
    model(6)=x0;
    x(2)=graphics;x(3)=model
    break
  end
case 'define' then
  model=list('integr',1,1,0,0,0,[],[],[],'c',%f,[%f %f])
  x=standard_define([2 2],model)
end

