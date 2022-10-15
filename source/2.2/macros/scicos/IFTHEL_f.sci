function [x,y,typ]=IFTHEL_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  [graphics,model]=arg1(2:3); [orig,sz,orient,label]=graphics(1:4)
  xstringb(orig(1),orig(2),['If in>=0';' ';' then    else'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);z0=model(7);nin=model(2);
  while %t do
    [ok,label]=getvalue('Set parameters',..
	['Block label'],..
	list('str',1),[label])
    if ~ok then break,end
    graphics(4)=label;
    x(2)=graphics;
    break
  end
case 'define' then
  model=list('ifthel',1,0,1,2,[],[],[],[],'d',%f,[%t %f])
  x=standard_define([3 3],model)
end

