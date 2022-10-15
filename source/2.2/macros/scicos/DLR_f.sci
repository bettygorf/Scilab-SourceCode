function [x,y,typ]=DLR_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,orient,label]=graphics(1:4)
  xstringb(orig(1),orig(2),['Num(z)';'-----';'Den(z)'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);[x0,rpar,ipar]=model([7 8 9])
  ns=prod(size(x0));nin=1;nout=1
  if ipar==[] then //for compatibility
    A=matrix(rpar(1:ns*ns),ns,ns)
    B=matrix(rpar(ns*ns+1:ns*(ns+nin)),ns,nin)
    C=matrix(rpar(ns*(ns+nin)+1:ns*(ns+nin+nout)),nout,ns)
    D=rpar(ns*(ns+nin+nout)+1)
    H=ss2tf(syslin('d',A,B,C,D))
    H=clean(H);
    if type(H)==16 then
      num=H(2);den=H(3)
    else
      num=H,den=1
    end
    ipar=[sci2exp(num);sci2exp(den)]
  end
  z=poly(0,'z'),s=poly(0,'z')
  while %t do
    [ok,label,tnum,tden]=getvalue('Set discrete SISO transfer parameters',..
	['Block label';
	 'Numerator (z)';
	 'Denominator (z)'],..
 	list('str',1,'str',1,'str',1),..
	[label;ipar(1);ipar(2)])
    if ~ok then break,end
    num=real(evstr(tnum))
    den=real(evstr(tden))
    if degree(num)>degree(den) then
      x_message('Transfer must be proper')
      ok=%f
    end
    if ok then 
      H=cont_frm(num,den)
      [A,B,C,D]=H(2:5);
      graphics(4)=label;
      [ns1,ns1]=size(A)
      if ns1<=ns then 
	x0=x0(1:ns1)
      else
	x0(ns1,1)=0
      end
      rpar=[A(:);
	    B(:);
	    C(:);
	    D(:)]
      model(7)=x0
      model(8)=rpar
      model(9)=[tnum;tden]
      if norm(D,1)<>0 then model(12)=[%t %f]; else model(12)=[%f %f]; end
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  x0=0;A=-1;B=1;C=1;D=0;
  ipar=['1';'1+z']
  model=list('dsslti',1,1,1,0,[],x0,[A;B;C;D],ipar,'c',%f,[%f %f])
  x=standard_define([2.5 2.5],model)
end


