function [x,y,typ]=ZCROSS_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  xstringb(orig(1),orig(2),'Zcross',sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);
  nin=model(2)
  [ok,label,nin1]=getvalue(['Set Zero-Crossing parameters';..
                                 'All surfaces must cross together'],..
      ['Block label';'Number of inputs'],..
	  list('str',1,'vec',1),[label;string(nin)])
      if ok then 
	[model,graphics,ok]=check_io(model,graphics,nin1,0,0,1)
	if ok then
	  nin=nin1
	  kk=0
	  for jj=1:nin
	    kk=kk+2^(nin+jj-1)
	  end
	  model(8)=[-ones(kk,1);zeros(2^(2*nin)-kk,1)]
	  graphics(4)=label
	  x(2)=graphics;x(3)=model
	end
      end
case 'define' then
  rpar=[-1;-1;-1;0]
  model=list('zcross',1,0,0,1,[],[],rpar,[],'z',%f,[%t %f])
  x=standard_define([2 2],model)
end

