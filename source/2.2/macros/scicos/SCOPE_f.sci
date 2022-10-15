function [x,y,typ]=SCOPE_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  thick=xget('thickness');xset('thickness',2)
  xrect(orig(1)+sz(1)/10,orig(2)+(1-1/10)*sz(2),sz(1)*8/10,sz(2)*8/10)
  xarrows([orig(1)+sz(1)/5,orig(1)+sz(1)/5; 
          orig(1)+(1-1/5)*sz(1),orig(1)+sz(1)/5],..
          [orig(2)+sz(2)/5,orig(2)+sz(2)/5; 
           orig(2)+sz(2)/5,orig(2)+(1-1/5)*sz(2)])
  t=(0:0.3:2*%pi)';  
  xpoly(orig(1)+(1/5+3*t/(10*%pi))*sz(1),..
        orig(2)+(1/4.3+(sin(t)+1)*3/10)*sz(2),'lines')
  xset('thickness',thick)
case 'getinputs' then
  [x,y,typ]=standard_inputs(o)
case 'getoutputs' then
  x=[];y=[];typ=[];
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);[nin,state,rpar,ipar]=model([2 7:9])
  win=ipar(1);N=ipar(3);clrs=ipar(4:nin+3)
  //next line for compatibility
  if size(rpar,'r')==3 then rpar=[rpar(1);-rpar(2);rpar(2);rpar(3)];end
  dt=rpar(1);ymin=rpar(2);ymax=rpar(3);per=rpar(4)
  while %t do
    [ok,label,nin,clrs,win,ymin,ymax,per,N,dt]=getvalue(..
	'Set Scope parameters',..
	['Block label';
	'Number of inputs';
	'inputs color c (<0) or mark (>0)';
	'Output window number';
	'Ymin';
	'Ymax';
	'Refresh period';
	'Buffer size';
	'dt (0 for normal operation)'],..
	 list('str',1,'vec',1,'vec',-1,'vec',1,'vec',1,..
	 'vec',1,'vec',1,'vec',1,'vec',1),..
	 ['Scope';
	 string(nin);
	 strcat(string(clrs),' ');
	 string(win);
	 string(ymin);
	 string(ymax);
	 string(per);
	 string(N);
	 string(dt)]);
    if ~ok then break,end //user cancel modification
    mess=[]
    if size(clrs,'*')<>nin then
      mess=[mess;'Inputs color c size must be equal to Number of inputs';' ']
      ok=%f
    end
    if win<0 then
      mess=[mess;'Window number can''t be negative';' ']
      ok=%f
    end
    if per<=0 then
      mess=[mess;'Refresh period must be positive';' ']
      ok=%f
    end
    if N<2 then
      mess=[mess;'Buffer size must be at least 2';' ']
      ok=%f
    end
    if ymin>=ymax then
      mess=[mess;'Ymax must be greater than Ymin';' ']
      ok=%f
    end
    if ok then
      [model,graphics,ok]=check_io(model,graphics,nin,0,1,0)
    else
      x_message(['Some specified values are inconsistent:';
	         ' ';mess])
    end
    if ok then
      rpar=[dt;ymin;ymax;per]
      ipar=[win;1;N;matrix(clrs,nin,1)]
      if prod(size(state))<>(nin+1)*N+1 then state=-eye((nin+1)*N+1,1),end
      model(7)=state;model(8)=rpar;model(9)=ipar
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  nin=1
  win=1; clrs=[-1;-3;-5;-7;-9;-11;-13;-15];
  N=2;
  ipar=[win;1;N;clrs(1:nin)]
  dt=0;ymin=-15;ymax=+15;per=30;
  rpar=[dt;ymin;ymax;per]
  state=-eye((nin+1)*N+1,1)
  model=list('scope',1,0,1,0,[],state,rpar,ipar,'d',%f,[%f %f])
  x=standard_define([2 2],model)
end

