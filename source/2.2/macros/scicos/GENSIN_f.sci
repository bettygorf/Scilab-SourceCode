function [x,y,typ]=GENSIN_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  model=arg1(3);C=model(8)
  xstringb(orig(1),orig(2),['sinusoid';'generator'],sz(1),sz(2),'fill')
case 'getinputs' then
  x=[];y=[];typ=[];
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);rpar=model(8)
  while %t do
    [ok,label,M,F,P]=getvalue(['Set Gen_SIN Block'],..
	    ['Block label';'Magnitude';'Frequency';'phase'],..
	    list('str',1,'vec',1,'vec',1,'vec',1),..
	    [label;string(rpar(1));string(rpar(2));string(rpar(3));])
    if ~ok then break,end
    if F<0 then
      x_message('Frequency must be positive')
      ok=%f
    end
    [model,graphics,ok]=check_io(model,graphics,0,1,0,0)
    if ok then
      model(8)=[M;F;P]
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  rpar=[1;1;0]
  model=list('gensin',0,1,0,0,[],[],rpar,[],'c',%f,[%f %t])
  x=standard_define([3 2],model)
end

