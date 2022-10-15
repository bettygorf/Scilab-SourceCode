function [x,y,typ]=GAIN_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then //normal  position 
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,label]=graphics([1:2 4])
  model=arg1(3);gain=model(8)
  thick=xget('thickness');//xset('thickness',2)
  dx=sz(1)/5
  dy=sz(2)/10
  xx=orig(1)+      [1 4 1 1]*dx
  yy=orig(2)+sz(2)-[1 5 9 1]*dy
  xpoly(xx,yy,'lines')
  xstringb(orig(1)+dx,orig(2)+dy,string(gain),sz(1)-2*dx,sz(2)-2*dy,'fill')
  xset('thickness',thick)
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);  gain=model(8)
  while %t do
    [ok,label,gain]=getvalue('Set gain block parameters',..
	['Block label';'Gain'],list('str',1,'mat',[-1,-1]),..
	[label;strcat(sci2exp(gain),';')])
    if ~ok then break,end
    if gain==[] then
      x_message('Gain must have at least one element')
      ok=%f
    end
    [nout,nin]=size(gain)
    [model,graphics,ok]=check_io(model,graphics,nin,nout,0,0)
    if ok then
      graphics(4)=label
      model(8)=gain
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  model=list('gain',1,1,0,0,[],[],1,[],'c',%f,[%t %f])
  x=standard_define([2 2],model)
end

