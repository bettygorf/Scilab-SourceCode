function [x,y,typ]=IN_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  graphics=arg1(2); [orig,sz,orient]=graphics(1:3)
  model=arg1(3);prt=model(9)
  if orient then
    x=[orig(1);orig(1);orig(1)+sz(1);orig(1)]
    y=[orig(2);orig(2)+sz(2);orig(2)+sz(2)/2;orig(2)]
  else
    x=[orig(1);orig(1)+sz(1);orig(1)+sz(1);orig(1)]
    y=[orig(2)+sz(2)/2;orig(2)+sz(2);orig(2);orig(2)+sz(2)/2]
  end
  pat=xget('pattern');xset('pattern',1)
  xfpoly(x,y,1)
  xset('pattern',pat)
  xstring(orig(1),orig(2)-sz(2)/2,string(prt))
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
  typ=ones(x)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  [graphics,model]=arg1(2:3);
  label=graphics(4);
  if size(label,'*')==2 then label=label(1),end //compatibility
  while %t do
    [ok,prt,label]=getvalue('Set Input block parameters',..
	'Port number',list('vec',1),label)
    if ~ok then break,end
    prt=int(prt)
    if prt<=0 then
      message('Port number must be a positive integer')
    else
      model(9)=prt
      model(11)=[];model(3)=-1//compatibility
      graphics(4)=label
      x(2)=graphics
      x(3)=model
      break
    end
  end
case 'define' then
  in=-1
  prt=1
  model=list('input',[],-1,[],[],[],[],[],[1],'c',[],[%f %f],' ',list())
  label=string(prt)
  x=standard_define([1 1],model,label,[])
end


