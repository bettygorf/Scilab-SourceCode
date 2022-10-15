function [x,y,typ]=BOUND_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  if size(label,'*')==3 then label=label(2:3),end //compatibility
  model=arg1(3);
  while %t do
    [ok,thresh,v,label]=getvalue([
	'Set Bound parameters';
	' '
	'if u(i)>thresh(i) then '
	'   y(i)=v(i)'
	'else'
	'   y(i)=0'
	'end'],..
	 ['thresh';'v'],..
	 list('vec',-1,'vec','size(x1,''*'')'),label)
     
    if ~ok then break,end //user cancel modification
    if ok then
      rpar=[thresh;v]
      model(8)=rpar
      graphics(4)=label;
      model(2)=size(v,'*')
      model(3)=size(v,'*')
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  in=1
  thresh=0
  v=1;
  rpar=[thresh;v]
  model=list('bound',1,1,[],[],[],[],rpar,[],'c',[],[%t %f],' ',list())
  label=[strcat(sci2exp(thresh));
         strcat(sci2exp(v))]
     
  gr_i=['thick=xget(''thickness'');xset(''thickness'',2);';
      'xx=orig(1)+[1/5;1/2;1/2;1-1/5]*sz(1);';
      'yy=orig(2)+[1/2;1/2;1-1/5;1-1/5]*sz(2);';
      'xpoly(xx,yy,''lines'');';
      'xset(''thickness'',1);';
      'xpoly(orig(1)+[1/9;1/5]*sz(1),orig(2)+[1/2;1/2]*sz(2),''lines'');';
      'xpoly(orig(1)+[1/2;1-1/9]*sz(1),orig(2)+[1/2;1/2]*sz(2),''lines'');';
      'xpoly(orig(1)+[1/2;1/2]*sz(1),orig(2)+[1/9;1/2]*sz(2),''lines'');';
      'xpoly(orig(1)+[1/2;1/2]*sz(1),orig(2)+[1-1/5;1-1/9]*sz(2),''lines'');';
      'xset(''thickness'',thick);']
  x=standard_define([2 2],model,label,gr_i)
end




