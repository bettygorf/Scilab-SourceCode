function [x,y,typ]=OUT_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  graphics=arg1(2); [orig,sz,orient,label]=graphics(1:4)
  model=arg1(3);prt=model(9)
  if orient then
    x=[orig(1);orig(1)+sz(1);orig(1)+sz(1);orig(1)]
    y=[orig(2)+sz(2)/2;orig(2)+sz(2);orig(2);orig(2)+sz(2)/2]
  else
    x=[orig(1);orig(1);orig(1)+sz(1);orig(1)]
    y=[orig(2);orig(2)+sz(2);orig(2)+sz(2)/2;orig(2)]
  end
  pat=xget('pattern');xset('pattern',0)
  xfpoly(x,y,1)
  xset('pattern',pat)
  xstring(orig(1),orig(2)-sz(2)/2,label+' '+string(prt))
case 'getinputs' then
  graphics=arg1(2)
  [orig,sz,orient]=graphics(1:3)
  if orient then
    x=orig(1)
    y=orig(2)+sz(2)/2
  else
    x=orig(1)+sz(1)
    y=orig(2)+sz(2)
  end
  typ=ones(x) 
case 'getoutputs' then
  x=[];y=[];typ=[];
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  [graphics,model]=arg1(2:3);
  prt=model(9);label=graphics(4);
  while %t do
    [ok,label,prt]=getvalue('Set Output block parameters',..
	['Output name';'Port number'],..
	list('str',1,'vec',1),[label;string(prt)])
    if ~ok then break,end
    if prt<=0 then
      x_message('Port number must be a positive integer')
      ok=%f
    end
    if ok then
      model(9)=prt
      graphics(4)=label
      x(2)=graphics;
      x(3)=model
      break
    end
  end
case 'define' then
  model=list('output',1,0,0,0,[],[],[],[1],'c',%f,[%f %f])
  x=standard_define([1 1],model,'Out')
end

