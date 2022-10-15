function [x,y,typ]=DLSS_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,orient,label]=graphics(1:4)
  xstringb(orig(1),orig(2),['x+=Ax+Bu';'y=Cx+Du'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);nin=model(2);nout=model(3);x0=model(7),rpar=model(8)
  ns=prod(size(x0))
  A=matrix(rpar(1:ns*ns),ns,ns)
  B=matrix(rpar(ns*ns+1:ns*(ns+nin)),ns,nin)
  C=matrix(rpar(ns*(ns+nin)+1:ns*(ns+nin+nout)),nout,ns)
  D=matrix(rpar(ns*(ns+nin+nout)+1:ns*(ns+nin+nout)+(nin*nout)),nout,nin)
  nin1=nin;nout1=nout
  while %t do
   [ok,label,A,B,C,D,x0]=getvalue('Set discrete linear system parameters',..
	['Block label';
	'A matrix';
	'B matrix';
	'C matrix';
	'D matrix';
	'Initial state'],..
	list('str',1,..
	  'mat',[-1,-1],..
	  'mat',[-1,-1],..
	  'mat',[-1,-1],..
  	  'mat',[-1,-1],..
	  'col',-1),..
	[label;
	 strcat(sci2exp(A));
	 strcat(sci2exp(B));
	 strcat(sci2exp(C));
 	 strcat(sci2exp(D));
	 strcat(sci2exp(x0))])
    if ~ok then break,end
    [ms,ns]=size(A)
    mess=[]
    if ms<>ns then mess=[mess;'A matrix must be square';' '],
      ok=%f,
    end
      [mms,nin]=size(B)
      [nout,nns]=size(C)
      [md1,nd1]=size(D)
    if mms^2<>mms*ns|nns^2<>ns*nns  then 
      mess=[mess;'B or C have wrong dimension';' '],
      ok=%f,
    end    
    if ns*md1<>ns*nout| ns*nd1<>ns*nin  then 
      mess=[mess;'D has wrong dimension';' '],
      ok=%f,
    end
    if ns==0 then [nin,nout]=size(D);end
    if ok then
      [model,graphics,ok]=check_io(model,graphics,nin,nout,1,0)
    else
      x_message(['Given Values are inconsistent:';' ';mess])
    end
    if ok then
      graphics(4)=label;
      rpar=[A(:);
	    B(:);
	    C(:);
	    D(:)];
	if D<>[] then	
	  if norm(D,1)<>0 then 
	    model(12)=[%t %f]; 
	  else  
	    model(12)=[%f %f];
	  end
	else
	  model(12)=[%f %f]; 
	end
      model(7)=x0,model(8)=rpar
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  x0=0;A=-1;B=1;C=1;D=0;
  model=list('dsslti',1,1,1,0,[],x0,[A;B;C;D],[],'d',%f,[%f %f])
  x=standard_define([3 2],model)
end

