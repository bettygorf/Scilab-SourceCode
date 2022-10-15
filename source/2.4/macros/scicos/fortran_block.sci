function [x,y,typ]=fortran_block(job,arg1,arg2)
//
// Copyright INRIA
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
  x=arg1
  model=arg1(3);graphics=arg1(2);
  label=graphics(4);
  while %t do
    [ok,i,o,rpar,funam,lab]=..
	getvalue('Set fortran_block parameters',..
	  ['input ports sizes';
	  'output port sizes';
	  'System parameters vector';
	  'function name'],..
	  list('vec',-1,'vec',-1,'vec',-1,'str',-1),label(1))
    if ~ok then break,end
    if funam==' ' then break,end
    label(1)=lab
    rpar=rpar(:)
    i=int(i(:));ni=size(i,1);
    o=int(o(:));no=size(o,1);
    tt=label(2);
    if model(1)(1)<>funam|size(model(2),'*')<>size(i,'*')..
	|size(model(3),'*')<>size(o,'*') then
      tt=[]
    end
    [ok,tt]=FORTR(funam,tt,i,o)
    if ~ok then break,end
    [model,graphics,ok]=check_io(model,graphics,i,o,[],[])
    if ok then
      model(1)(1)=funam
      model(8)=rpar
      label(2)=tt
      x(3)=model
      graphics(4)=label
      x(2)=graphics
      break
    end
  end
case 'define' then
  in=1
  out=1
  clkin=[]
  clkout=[]
  x0=[]
  z0=[]
  typ='c'
  auto=[]
  rpar=[]
  funam='forty'
  model=list(list(' ',1001),in,out,clkin,clkout,x0,z0,rpar,0,typ,auto,[%t %f],..
      ' ',list());
  label=list([sci2exp(in);sci2exp(out);	strcat(sci2exp(rpar));funam],..
	    list([]))
  gr_i=['xstringb(orig(1),orig(2),''Fortran'',sz(1),sz(2),''fill'');']
  x=standard_define([2 2],model,label,gr_i)
end


function [ok,tt]=FORTR(funam,tt,inp,out)
//
ni=size(inp,'*')
no=size(out,'*')
if tt==[] then

  tete1=['      subroutine '+funam+'(flag,nevprt,t,xd,x,nx,z,nz,tvec,';..
      '     $        ntvec,rpar,nrpar,ipar,nipar']

  tete2= '     $        '
  for i=1:ni
    tete2=tete2+',u'+string(i)+',nu'+string(i)
  end
  for i=1:no
    tete2=tete2+',y'+string(i)+',ny'+string(i)
  end
  tete2=tete2+')'

  tete3=['      double precision t,xd(*),x(*),z(*),tvec(*)';..
    '      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)']

  tete4= '      double precision rpar(*)'
    for i=1:ni
      tete4=tete4+',u'+string(i)+'(*)'
    end
    for i=1:no
      tete4=tete4+',y'+string(i)+'(*)'
    end
    tetec=['c';'c'];tetev=[' ';' '];
    tetend='      end'
    
    textmp=[tete1;tete2;tetec;tete3;tete4;tetec;tetev;tetec;tetend];
  else
    textmp=tt;
  end
  
  while 1==1
      [txt]=x_dialog(['Function definition in fortran';
	'Here is a skeleton of the functions which you shoud edit'],..
	 textmp);

      if txt<>[] then
	tt=txt
	[ok]=do_forcomlink(funam,tt)
	if ok then
	  textmp=txt;
	end
	break;
      else
	ok=%f;break;
      end  
  end
    
