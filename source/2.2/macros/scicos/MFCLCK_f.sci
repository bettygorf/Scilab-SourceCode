function [x,y,typ]=MFCLCK_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  xstringb(orig(1),orig(2),['M. freq';'clock'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);dt=model(8)
  nn=model(9)
  [ok,label,dt,nn]=getvalue('Set Multifrequency clock parameters',..
      ['Block label';'basic period (1/f)';'multiply by (n)'],..
      list('str',1,'vec',1,'vec',1),[label;string(dt);string(nn)])
      if ok then 
	model(9)=nn
	model(8)=dt;
	hh=model(11);hh(2)=dt<>0;model(11)=hh
	graphics(4)=label
	x(2)=graphics;x(3)=model
      end
case 'define' then
  model=list('mfclck',0,0,1,2,[],0,0,2,'d',[%f %f],[%f %f])
  x=standard_define([2 2],model)
end

