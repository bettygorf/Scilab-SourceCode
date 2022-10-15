function [x,y,typ]=AFFICH_f(job,arg1,arg2)
// Copyright INRIA
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
case 'getinputs' then
    [x,y,typ]=standard_inputs(o)
case 'getoutputs' then
  x=[];y=[];typ=[];
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);
  if size(label,'*')==5 then label(6)='0';end //compatibility
  if size(label,'*')==4 then label(4)=' ';label(5)=' ';end //compatibility
  while %t do
    [ok,font,fontsize,color,nt,nd,herit,label]=getvalue(..
	'Set  parameters',..
	['Font number';
	 'Font size';
	 'Color';
	 'Total number of digits';
	 'Number of rational part digits';
	 'Block inherits (1) or not (0)'],..
	 list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),label)
    if ~ok then break,end //user cancel modification
    mess=[]

    if font<=0 then
      mess=[mess;'Font number must be positive';' ']
      ok=%f
    end
    if fontsize<=0 then
      mess=[mess;'Font size must be positive';' ']
      ok=%f
    end
    if nt<=3 then
      mess=[mess;'Total number of digits must be greater than 3';' ']
      ok=%f
    end
    if nd<0 then
      mess=[mess;'Number of rational part digits must be '
	  'greater or equal 0';' ']
      ok=%f
    end
    if ~ok then
      message(['Some specified values are inconsistent:';
	' ';mess]);
    end
	   
    if ~or(herit==[0 1]) then
      mess=[mess;'Accept inherited values are 0 and 1';' ']
      ok=%f
    end
     if ~ok then
      message(['Some specified values are inconsistent:';
	  ' ';mess])
    end
    if ok then
      [model,graphics,ok]=check_io(model,graphics,-1,[],ones(1-herit,1),[])
    end
    if ok then
      [orig,sz]=graphics(1:2)
      rpar=[orig(:);sz(:)]
      ipar=[font;fontsize;color;xget('window');nt;nd]
      model(8)=rpar;model(9)=ipar;model(3)=ones(1-herit,1)
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  font=1
  fontsize=1
  color=1
  nt=9
  nd=2
  label=[string(font);
      string(fontsize);
      string(color);
      string(nt);
      string(nd)]
  rpar=[[0;0];[1;1]]
  ipar=[font;fontsize;color;0;nt;nd]
  model=list('affich',1,[],1,[],[],0,rpar,ipar,'d',[],[%t %f],' ',list())
  gr_i='xstringb(orig(1),orig(2),''+00000.00'',sz(1),sz(2),''fill'')'
  x=standard_define([3 2],model,label,gr_i)
end

function str=writetostring(z,frmt)
[m,n]=size(z)
u=file('open',TMPDIR+'/f','unknown')
write(u,z,frmt)
file('close',u)
str=read(TMPDIR+'/f',m,1,'(a)')
