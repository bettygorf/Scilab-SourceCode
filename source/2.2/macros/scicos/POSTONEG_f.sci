function [x,y,typ]=POSTONEG_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  xstringb(orig(1),orig(2),' + to - ',sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
case 'define' then
  rpar=[-1;-1;-1;0]
  model=list('zcross',1,0,0,1,[],[],rpar,[],'z',%f,[%t %f])
  x=standard_define([2 2],model)
end

