function [x,y,typ]=CLKIN_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  graphics=arg1(2); [orig,sz,orient]=graphics(1:3)
  model=arg1(3);prt=model(9)
  pat=xget('pattern');xset('pattern',default_color(-1))
  thick=xget('thickness');xset('thickness',2)
  if orient then
    x=orig(1)+sz(1)*[-1/6;-1/6;1/1.5;1;1/1.5]
    y=orig(2)+sz(2)*[0;1;1; 1/2;0]
    xstring(orig(1),orig(2)+sz(2)/12,string(prt))
  else
    x=orig(1)+sz(1)*[0;1/3;7/6;7/6;1/3]
    y=orig(2)+sz(2)*[1/2;1;1;0;0]
    xstring(orig(1)+sz(1)/3,orig(2)+sz(2)/12,string(prt))
  end
  xpoly(x,y,'lines',1)
  xset('thickness',thick)
  xset('pattern',pat)
case 'getinputs' then
  x=[];y=[];typ=[]
case 'getoutputs' then
  graphics=arg1(2)
  [orig,sz,orient]=graphics(1:3)
  if orient then
    x=orig(1)+sz(1)
    y=orig(2)+sz(2)/2
  else
    x=orig(1)
    y=orig(2)+sz(2)
  end
  typ=-ones(x)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  [graphics,model]=arg1(2:3);
  label=graphics(4)
  label=label(1) // compatibility
  while %t do
    [ok,prt,label]=getvalue('Set Event Input block parameters',..
	'Port number',list('vec',1),label)
    prt=int(prt)
    if ~ok then break,end
    if prt<=0 then
      message('Port number must be a positive integer')
    else
      model(9)=prt
      model(5)=1
      model(11)=-1//compatibility
      graphics(4)=label
      x(2)=graphics
      x(3)=model
      break
    end
  end
case 'define' then
  prt=1
  model=list('input',[],[],[],1,[],[],[],prt,'d',-1,[%f %f],' ',list())
  label=string(prt)
  x=standard_define([1 1],model,label,[])
end


