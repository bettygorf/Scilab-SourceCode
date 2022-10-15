function [x,y,typ]=SELECT_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  [graphics,model]=arg1(2:3); [orig,sz,orient,label]=graphics(1:4)
  xstringb(orig(1),orig(2),'Selector',sz(1),sz(2),'fill')
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
    [ok,label,nin,z0]=getvalue('Set parameters',..
	['Block label';'number of inputs';'initial connected input'],..
	list('str',1,'vec',1,'vec',1),[label;string(nin);string(z0)])
    if ~ok then break,end
    if z0>nin|z0<=0 then 
      x_message('initial connected input is not a valit input port number')
      ok=%f
    end 
    [model,graphics,ok]=check_io(model,graphics,nin,1,nin,0)
    break
  end
    if ok then
    graphics(4)=label;
    model(7)=z0,model(4)=nin,model(2)=nin
    x(2)=graphics;x(3)=model
  end
case 'define' then
  z0=1
  model=list('selblk',1,1,1,0,[],z0,[],[],'d',%f,[%t %f])
  x=standard_define([2 2],model)
end

