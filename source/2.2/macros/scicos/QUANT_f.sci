function [x,y,typ]=QUANT_f(job,arg1,arg2)
x=[];y=[],typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  thick=xget('thickness');xset('thickness',2)
  xpoly(orig(1)+[1;2;2;3;3;4;4]/5*sz(1),..
        orig(2)+[1;1;2;2;3;3;4]/5*sz(2),'lines')
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
  model=arg1(3);rpar=model(8);ipar=model(9);
  pas=rpar(1)
  meth=ipar
  ok=%f
  while ~ok then
    [ok,label,pas,meth]=getvalue('Set parameters',..
	['Block label';'Step';'Quantization Type (1-4)'],..
	list('str',1,'vec',1,'vec',1),[label;string(pas);string(meth)])
    if ok then
      if meth<1|meth>4 then 
	x_message('Quantization Type must be from 1 to 4')
	ok=%f
      end
    end
  end
  rpar=pas
  model(8)=rpar
  model(9)=meth
  select meth
  case 1 then
    model(1)='qzrnd'
  case 2 then
    model(1)='qztrn'
  case 3 then
    model(1)='qzflr'
  case 4  then
    model(1)='qzcel'
  end
  graphics(4)=label
  x(2)=graphics;x(3)=model
case 'define' then
  pas=0.1;rpar=pas
  model=list('qzrnd',1,1,0,0,[],[],rpar,1,'c',%f,[%t %f])
  x=standard_define([2 2],model)
end

