function [x,y,typ]=SCOPXY_f(job,arg1,arg2)
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
  state=model(7);
  while %t do
    [ok,clrs,siz,win,wpos,wdim,xmin,xmax,ymin,ymax,N,label]=getvalue(..
	'Set Scope parameters',..
	['color (>0) or mark (<0)';
	'line or mark size';
	'Output window number';
	'Output window position';
	'Output window sizes';
	'Xmin';
	'Xmax';
	'Ymin';
	'Ymax';
	'Buffer size'],..
	 list('vec',1,'vec',1,'vec',1,'vec',-1,'vec',-1,'vec',1,'vec',1,..
	 'vec',1,'vec',1,'vec',1),label)
    if ~ok then break,end //user cancel modification
    mess=[];
    if size(wpos,'*')<>0 &size(wpos,'*')<>2 then
      mess=[mess;'Window position must be [] or a 2 vector';' ']
      ok=%f
    end
    if size(wdim,'*')<>0 &size(wdim,'*')<>2 then
      mess=[mess;'Window dim must be [] or a 2 vector';' ']
      ok=%f
    end
    if win<0 then
      mess=[mess;'Window number cannot be negative';' ']
      ok=%f
    end
    if N<1&clrs>0 then
      mess=[mess;'Buffer size must be at least 1';' ']
      ok=%f
    end
    if N<2&clrs<0 then
      mess=[mess;'Buffer size must be at least 2';' ']
      ok=%f
    end
    if ymin>=ymax then
      mess=[mess;'Ymax must be greater than Ymin';' ']
      ok=%f
    end
    if xmin>=xmax then
      mess=[mess;'Xmax must be greater than Xmin';' ']
      ok=%f
    end
    if ok then
      if wpos==[] then wpos=[-1;-1];end
      if wdim==[] then wdim=[-1;-1];end
      rpar=[xmin;xmax;ymin;ymax]
      ipar=[win;1;N;clrs;siz;1;wpos(:);wdim(:)]
      if prod(size(state))<>2*N+1 then state=-eye(2*N+1,1),end
      model(7)=state;model(8)=rpar;model(9)=ipar
      model(11)=[] //compatibility
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  win=1; clrs=4;siz=1
  wdim=[600;400]
  wpos=[-1;-1]
  N=2;
  ipar=[win;1;N;clrs;1;0;1;wpos(:);wdim(:)]
  xmin=-15;xmax=15;ymin=-15;ymax=+15
  rpar=[xmin;xmax;ymin;ymax]
  state=-eye(2*N+1,1)
  model=list('scopxy',[1;1],[],1,[],[],state,rpar,ipar,'d',[],[%f %f],' ',list())
  label=[sci2exp(clrs);
	sci2exp(siz);
	string(win);
	sci2exp([]);
	sci2exp(wdim);
	string(xmin);
	string(xmax);
	string(ymin);
	string(ymax);
	string(N)];
  gr_i=['thick=xget(''thickness'');xset(''thickness'',2);';
    't=(0:0.2:2*%pi)'';';
    'xx=orig(1)+(1/5+(cos(3*t)+1)*3/10)*sz(1);';
    'yy=orig(2)+(1/4.3+(sin(t+1)+1)*3/10)*sz(2);';
    'xpoly(xx,yy,''lines'');';
    'xset(''thickness'',thick)']
  x=standard_define([2 2],model,label,gr_i)
end




