function [x,y,typ]=GENERAL_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  xstringb(orig(1),orig(2),' GENERAL ',sz(1),sz(2),'fill')
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
  nin=model(2);nout=model(5)
  [ok,label,nin1,nout1]=getvalue('Set General Zero-Crossing parameters',..
      ['Block label';
       'Number of inputs';
       'Number of event outputs'],..
      list('str',1,'vec',1,'vec',1),..
      [label;string(nin);string(nout)])
  if ok then 
    [model,graphics,ok]=check_io(model,graphics,nin1,0,0,nout1)
    if ok then
      if nout==nout1 & nin==nin1 then
	rp=matrix(rpar,nout,2^(2*nin));
      else
	rp=-1*ones(nout1,2^(2*nin1))
      end
      n=size(rp,2)/2
      result=x_mdialog('routing matrix',string(1:nout1),..
	  string(1:2^(2*nin1-1)),string(rp(:,n+1:2*n)))
      if result<>[] then 
	rp(1:nout1,n+1:2*n)=evstr(result)
	nin=nin1
	nout=nout1
	model(8)=rp(:)
	graphics(4)=label
	x(2)=graphics;x(3)=model
      end
    end
  end
case 'define' then
  rpar=[0;0;0;0]
  model=list('zcross',1,0,0,1,[],[],rpar,[],'z',%f,[%t %f])
  x=standard_define([3 2],model)
end

