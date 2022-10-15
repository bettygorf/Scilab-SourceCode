function [x,y,typ]=POWBLK_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  [graphics,model]=arg1(2:3); [orig,sz,orient,label]=graphics(1:4)
//  dly=model(8)
  xstringb(orig(1),orig(2),['u^a'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);  
  if model(8)<>[] then
    a=model(8)
  else
    a=model(9)
  end
  nin=model(2)
  while %t do
    [ok,label,nin,a]=getvalue('Set u^a block parameters',..
	['Block label';'Number of inputs (outputs)';'Basis'],..
	list('str',1,'vec',1,'vec',1),..
	[label;string(nin);string(a)])
    if ~ok then break,end
    [model,graphics,ok]=check_io(model,graphics,nin,nin,0,0)
    if ok then
      graphics(4)=label
      if a==int(a) then
	model(9)=a;
	model(8)=[]
      else
	model(8)=a;
	model(9)=[]
      end
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  model=list('powblk',1,1,0,0,[],[],1.5,[],'c',%f,[%t %f])
  x=standard_define([2 2],model)
end

