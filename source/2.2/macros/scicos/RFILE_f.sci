function [x,y,typ]=RFILE_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,orient,label]=graphics(1:4)
  xstringb(orig(1),orig(2),['read from';'input file'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(o)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(o)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);[nout,state,ipar]=model([3 7 9])
  ievt=ipar(3);N=ipar(4);
  imask=5+ipar(1)+ipar(2)
  if ievt<>0 then tmask=ipar(imask),else tmask=[],end
  outmask=ipar(imask+ievt:imask+nout+ievt-1)
  lunit=state(2)
  N=ipar(4)
  lfil=ipar(1)
  lfmt=ipar(2)
  if lfil>0 then fname=code2str(ipar(5:4+lfil)),else fname=' ',end
  if lfmt>0 then fmt=code2str(ipar(5+lfil:4+lfil+lfmt)),else fmt=' ',end
  while %t do
    [ok,label,tmask1,outmask,fname1,fmt1,N]=getvalue(..
	['Set RFILE block parameters';
	 'Read is done on';
	 '  -  a binary file if no format given';
	 '  -  a formatted file if a  format (fortran type) is given'],..
	['Block label';
	 'Time record selection';
	 'Outputs record selection';
	 'Input file name';
	 'Input Format';
	 'Buffer size'],..
	 list('str',1,'vec',-1,'vec',-1,'str',1,'str',1,'vec',1),..
	 [label;
	 sci2exp(tmask);
	 sci2exp(outmask);
	 fname;
	 fmt;
	 string(N)])
    if ~ok then break,end //user cancel modification
    mess=[]
    if prod(size(tmask1))>1 then
      mess=[mess;'Time record selection must be a scalar or an empty matrix']
      ok=%f	
    end
    fname1=stripblanks(fname1)
    fmt1=stripblanks(fmt1)
    if lunit>0&min(length(fmt),1)<>min(length(fmt1),1) then
      mess=[mess;'You cannot swich from formatted to unformatted';
	         'or  from unformatted to formatted when running';' ']
      ok=%f	   
    end
    if lunit>0&fname1<>fname then
      mess=[mess;'You cannot modify Output file name when running';' ']
      ok=%f
    end
    if lunit>0&size(tmask1)<>size(tmask) then
      mess=[mess;'You cannot modify time management when running';' ']
      ok=%f
    end
    if N<2 then
      mess=[mess;'Buffer size must be at least 2';' ']
      ok=%f
    end
    if ok then
      ievt=prod(size(tmask1))
      nout=prod(size(outmask))
      pause
      [model,graphics,ok]=check_io(model,graphics,0,nout,1,ievt)
      model(11)=ievt==1
    else
      x_message(['Some specified values are inconsistent:';
	         ' ';mess])
    end
    if ok then
      ipar=[length(fname1);
	    length(fmt1);
	    ievt;
	    N;
	    str2code(fname1);
	    str2code(fmt1);
	    tmask1
	    outmask(:)]
      if prod(size(state))<>(nout+ievt)*N+3 then 
	state=[-1;lunit;zeros((nout+ievt)*N+3,1)]
      end
      model(7)=state;model(9)=ipar
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  nout=1
  fmt='(7(e10.3,1x))'
  fname='foo'
  lunit=0
  N=2;
  rpar=[]
  ipar=[length(fname);length(fmt);0;N;str2code(fname);str2code(fmt);1]
  state=[1;lunit;zeros((nout)*N,1)]
  model=list('readf',0,nout,1,0,[],state,rpar,ipar,'d',%f,[%f %f])
  x=standard_define([3 2],model)
end

