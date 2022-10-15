function [x,y,typ]=TRASH_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
   graphics=arg1(2); [orig,sz,label]=graphics([1:2 4])
   xstringb(orig(1),orig(2),'Trash',sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(o)
case 'getoutputs' then
  x=[];y=[];typ=[];
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);nin=model(2)
  while %t do
    [ok,label,nin]=getvalue(..
	'Set Trash parameters',..
	['Block label';
	'Number of inputs'],..
	    list('str',1,'vec',1),..
	    ['Trash';
	    string(nin)]);
   if ~ok then break,end
   [model,graphics,ok]=check_io(model,graphics,nin,0,1,0)
   if ok then
     graphics(4)=label;
     x(2)=graphics;x(3)=model
     break
   end
 end
case 'define' then
  nin=1
  model=list('trash',1,0,1,0,[],[],[],[],'d',%f,[%f %f])
  x=standard_define([2 2],model)
end

