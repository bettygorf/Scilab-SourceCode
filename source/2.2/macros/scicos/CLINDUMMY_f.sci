function [x,y,typ]=CLINDUMMY_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,orient,label]=graphics(1:4)
  xstringb(orig(1),orig(2),['DUMMY';'CLSS'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1
case 'define' then
  x0=0;
  model=list('cdummy',0,0,0,0,x0,[],[],[],'c',%f,[%f %f])
  x=standard_define([3 2],model)
end

