function [x,y,typ]=CLKSPLIT_f(job,arg1,arg2)
x=[];y=[],typ=[];
select job
case 'plot' then
case 'getinputs' then
  graphics=arg1(2); orig=graphics(1)
  x=orig(1)
  y=orig(2)
  typ=-ones(x)
case 'getoutputs' then
  graphics=arg1(2); orig=graphics(1)
  x=[1 1]*orig(1)
  y=[1 1]*orig(2)
  typ=-ones(x) 
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
case 'define' then
  model=list('split',0,0,1,2,[],[],[],[],'d',[%f,%f,%f],[%f %f])
  x=standard_define([1 1]/2,model)
end





  
  
