function [x,y,typ]=SAT_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  thick=xget('thickness');xset('thickness',2)
  xpoly(orig(1)+[4/5;1/2+1/5;1/2-1/5;1/5]*sz(1),..
        orig(2)+[1-1/5;1-1/5;1/5;1/5]*sz(2),'lines')
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
  model=arg1(3);rpar=model(8)
  minp=rpar(1),maxp=rpar(2),pente=rpar(3)
  while %t do
    [ok,label,minp,maxp,pente]=getvalue('Set Saturation parameters',..
	['Block label';'Min';'Max';'Slope'],..
	list('str',1,'vec',1,'vec',1,'vec',1),..
	[label;string(minp);string(maxp);string(pente)])
    if ~ok then break,end
    if maxp<=minp  then
      x_message('Min must be strictly less than Max')
      ok=%f
    end
    if pente<=0 then
      x_message('Slope must be strictly positive')
      ok=%f
    end
    if ok then
      rpar=[minp;maxp;pente]
      model(8)=rpar
      graphics(4)=label
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  minp=-1;maxp=1;slope=1;rpar=[minp;maxp;slope]
  model=list('lusat',1,1,0,0,[],[],rpar,[],'c',%f,[%t %f])
  x=standard_define([2 2],model)
end

