function [x,y,typ]=EXPBLK_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  [graphics,model]=arg1(2:3); [orig,sz,orient,label]=graphics(1:4)
//  dly=model(8)
  xstringb(orig(1),orig(2),['a^u'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);  a=model(8)
  nin=model(2)
  while %t do
    [ok,label,nin,a]=getvalue('Set a^u  block parameters',..
	['Block label';'Number of inputs (outputs)';'a (>0)'],..
	list('str',1,'vec',1,'vec',1),..
	[label;string(nin);string(a)])
    if ~ok then break,end
    if a>0 then
      [model,graphics,ok]=check_io(model,graphics,nin,nin,0,0)
      if ok then
	graphics(4)=label
	model(8)=a;
	x(2)=graphics;x(3)=model
	break
      end
    else
      x_message('a^u : a must be positive')
    end
  end
case 'define' then
  model=list('expblk',1,1,0,0,[],[],%e,[],'c',%f,[%t %f])
  x=standard_define([2 2],model)
end

