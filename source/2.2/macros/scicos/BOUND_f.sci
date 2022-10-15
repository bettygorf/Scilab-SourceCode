function [x,y,typ]=BOUND_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  thick=xget('thickness');xset('thickness',2)
  xpoly(orig(1)+[1/5;1/2;1/2;1-1/5]*sz(1),..
        orig(2)+[1/2;1/2;1-1/5;1-1/5]*sz(2),'lines')
  xset('thickness',1)
  xpoly(orig(1)+[1/9;1/5]*sz(1),..
        orig(2)+[1/2;1/2]*sz(2),'lines')
  xpoly(orig(1)+[1/2;1-1/9]*sz(1),..
        orig(2)+[1/2;1/2]*sz(2),'lines')
  xpoly(orig(1)+[1/2;1/2]*sz(1),..
        orig(2)+[1/9;1/2]*sz(2),'lines')
  xpoly(orig(1)+[1/2;1/2]*sz(1),..
        orig(2)+[1-1/5;1-1/9]*sz(2),'lines')
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
  model=arg1(3);rpar=model(8);nin=model(2)
  thresh=rpar(1),v=rpar(2)
  while %t do
    [ok,label,nin,thresh,v]=getvalue([
	'Set Bound parameters';
	' '
	'if u(i)>thresh(i) then '
	'   y(i)=v(i)'
	'else'
	'   y(i)=0'
	'end'],..
	    ['Block label';'number of input/output';'thresh';'v'],..
	    list('str',1,'vec',1,'vec',-1,'vec',-4),..
	    [label;
	    string(nin);
	    strcat(string(thresh),' ');
	    strcat(string(v),' ')])
    if ~ok then break,end //user cancel modification
    mess=[]
    if prod(size(thresh))<>nin then
      x_message(['size of thresh and v vectors must be equal to the';
	  'number of input/output';' '])
      ok=%f
    end
    if ok then
      [model,graphics,ok]=check_io(model,graphics,nin,nin,0,0)
    end 
    if ok then
      rpar=[thresh,v]
      model(8)=rpar
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  rpar=[0;1]
  model=list('bound',1,1,0,0,[],[],rpar,[],'c',%f,[%t %f])
  x=standard_define([2 2],model)
end

