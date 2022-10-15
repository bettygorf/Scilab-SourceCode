function [x,y,typ]=WFILE_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz,orient,label]=graphics(1:4)
  xstringb(orig(1),orig(2),'WFile',sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(o)
case 'getoutputs' then
  x=[];y=[];typ=[];
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);[nin,state,ipar]=model([2 7 9])
  win=ipar(1);N=ipar(3);clrs=ipar(4:nin+3)
  lunit=ipar(3)
  N=ipar(4)
  lfil=ipar(1)
  lfmt=ipar(2)
  if lfil>0 then fname=code2str(ipar(5:4+lfil)),else fname=' ',end
  if lfmt>0 then fmt=code2str(ipar(5+lfil:4+lfil+lfmt)),else fmt=' ',end
  while %t do
    [ok,label,nin,fname1,fmt1,N]=getvalue(..
	'Set WFILE block parameters',..
	['Block label';
	'Number of inputs';
	'Output file name';
	'Output Format';
	'Buffer size'],..
	 list('str',1,'vec',1,'str',1,'str',1,'vec',1),..
	 [label;
	 string(nin);
	 fname;
	 fmt;
	 string(N)])
    if ~ok then break,end //user cancel modification
    mess=[]
    fname1=stripblanks(fname1)
    fmt1=stripblanks(fmt1)
    if lunit>0&min(length(fmt),1)<>min(length(fmt1),1) then
      mess=[mess;'You cannot swich from formatted to unformatted';
	         'or  from unformatted to formatted when running';' ']
    if lunit>0&fname1<>fname then
      mess=[mess;'You cannot modify Output file name when running';' ']
      ok=%f
    end
    if N<2 then
      mess=[mess;'Buffer size must be at least 2';' ']
      ok=%f
    end
    if ok then
      [model,graphics,ok]=check_io(model,graphics,nin,0,1,0)
    else
      x_message(['Some specified values are inconsistent:';
	         ' ';mess])
    end
    if ok then
      ipar=[length(fname1);length(fmt1);lunit;N;str2code(fname1);str2code(fmt1)]
      if prod(size(state))<>(nin+1)*N+1 then state=-eye((nin+1)*N+1,1),end
      model(7)=state;model(9)=ipar
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  nin=1
  fmt='(7(e10.3,1x))'
  fname='foo'
  lunit=0
  N=2;
  ipar=[length(fname);length(fmt);lunit;N;str2code(fname);str2code(fmt)]
  state=-eye((nin+1)*N+1,1)
  model=list('writef',1,0,1,0,[],state,rpar,ipar,'d',%f,[%f %f])
  x=standard_define([2 2],model)
end

