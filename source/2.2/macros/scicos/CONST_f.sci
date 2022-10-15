function [x,y,typ]=CONST_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  model=arg1(3);C=model(8)
  dx=sz(1)/5;dy=sz(2)/10
  xstringb(orig(1)+dx,orig(2)+dy,string(C),sz(1)-2*dx,sz(2)-2*dy,'fill')
case 'getinputs' then
  x=[];y=[];typ=[];
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);C=model(8)
  while %t do
    [ok,label,C]=getvalue(['Set Contant Block'],..
	    ['Block label';'Contants'],..
	    list('str',1,'vec',-1),..
	    [label;strcat(string(C),' ')])
    if ~ok then break,end
    nout=size(C,'*')
    if nout==0 then
      x_message('C must have at least one element')
      ok=%f
    end
    [model,graphics,ok]=check_io(model,graphics,0,nout,0,0)
    if ok then
      model(8)=C
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  rpar=1
  model=list('cstblk',0,1,0,0,[],[],rpar,[],'d',%f,[%f %f])
  x=standard_define([2 2],model)
end

