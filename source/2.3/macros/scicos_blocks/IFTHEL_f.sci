function [x,y,typ]=IFTHEL_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  x(3)(11)=[-1 -1]
case 'define' then
  model=list(list('ifthel',1),1,[],1,[1;1],[],[],[],[],'l',[-1 -1],[%f %f],' ',list())
  gr_i=['txt=[''If in>=0'';'' '';'' then    else''];';
    'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
  x=standard_define([3 3],model,[],gr_i)
end








