function [x,y,typ]=REGISTER_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  [graphics,model]=arg1(2:3); [orig,sz,orient,label]=graphics(1:4)
  dly=model(8)
  xstringb(orig(1),orig(2),['Shift';'Register';string(dly)],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);z0=model(7)
  while %t do
    [ok,label,z0]=getvalue('Set delay parameters',..
	['Block label';'Register initial condition'],..
	list('str',1,'vec',-1),[label;strcat(string(z0),';')])
    if ~ok then break,end
    if prod(size(z0))<2 then 
      x_message('Register length must be at least 2')
      ok=%f
    end 
    if ok then
      graphics(4)=label;
      model(7)=z0
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  z0=zeros(10,1)
  model=list('delay',1,1,1,0,[],z0,[],[],'d',%f,[%f %f])
  x=standard_define([2.5 2.5],model)
end

