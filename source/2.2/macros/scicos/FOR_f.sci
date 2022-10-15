function [x,y,typ]=FOR_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  [graphics,model]=arg1(2:3); [orig,sz,orient,label]=graphics(1:4)
  dly=model(8)
  xstringb(orig(1),orig(2),['For 1:';string(dly)],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1
case 'define' then
  z0=[]
  model=list('forblk',1,1,2,2,[],[1;0],[],[],'d',%f,[%f %f])
  x=standard_define([2 2],model)
end

