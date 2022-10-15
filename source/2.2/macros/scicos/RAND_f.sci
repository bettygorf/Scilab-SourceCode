function [x,y,typ]=RAND_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then //normal  position 
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,label]=graphics([1:2 4])
  model=arg1(3);dt=model(8)
  xstringb(orig(1),orig(2),['random';'generator'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);rpar=model(8);flag=model(9);
  while %t do
    [ok,label,flag,a,b,dt]=getvalue([
	'Set Random generator block parameters';
	'flag = 0 : Uniform distribution A is min and A+B max';
	'flag = 1 : Normal distribution A is mean and B deviation'],..
	['Block label';'flag';'A';'B';'dt'],..
	list('str',1,'vec',1,'vec',-1,'vec','size(x3,''*'')','vec',1),..
	[label;string([flag;rpar])])
    if ~ok then break,end
    mess=[]
    if flag<>0&flag<>1 then
      mess=[mess;'flag must be equal to 1 or 0';' ']
      x_message(mess)
      ok=%f
    end
    if ok then
      nout=size(a,'*')
      if dt>0 then nclkout=1,else nclkout=0,end
      [model,graphics,ok]=check_io(model,graphics,0,nout,1,nclkout)
      if ok then
	graphics(4)=label
	model(9)=flag
	model(8)=[a(:);b(:);dt]
	model(7)=[0*a(:);0]
	x(2)=graphics;x(3)=model
	break
      end
    end
  end
case 'define' then
  model=list('rndblk',0,1,1,0,[],[0;0],[0;1;0],[0],'d',%t,[%f %f])
  x=standard_define([3 2],model)
end

