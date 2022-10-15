function [x,y,typ]=ANIMXY_f(job,arg1,arg2)
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  thick=xget('thickness');xset('thickness',2)
//  xrect(orig(1)+sz(1)/10,orig(2)+(1-1/10)*sz(2),sz(1)*8/10,sz(2)*8/10)
//  xarrows([orig(1)+sz(1)/5,orig(1)+sz(1)/5; 
//          orig(1)+(1-1/5)*sz(1),orig(1)+sz(1)/5],..
//          [orig(2)+sz(2)/5,orig(2)+sz(2)/5; 
//           orig(2)+sz(2)/5,orig(2)+(1-1/5)*sz(2)])
  t=(0:0.3:2*%pi)';  
  xpoly(orig(1)+(1/5+(cos(2.2*t)+1)*3/10)*sz(1),..
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
  model=arg1(3);[state,rpar,ipar]=model([7:9])
  win=ipar(1);N=ipar(3);clrs=ipar(4);siz=ipar(5)
  xmin=rpar(1);xmax=rpar(2);ymin=rpar(3);ymax=rpar(4)
  while %t do
    [ok,label,clrs,siz,win,xmin,xmax,ymin,ymax,N]=getvalue(..
	'Set Scope parameters',..
	['Block label';
	'color (<0) or mark (>0)';
	'line or mark size';
	'Output window number';
	'Xmin';
	'Xmax';
	'Ymin';
	'Ymax';
	'Buffer size'],..
	 list('str',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,..
	 'vec',1,'vec',1,'vec',1),..
	 [label;
	 string(clrs);
	 string(siz);
	 string(win);
	 string(xmin);
	 string(xmax);
	 string(ymin);
	 string(ymax);
	 string(N)]);
    if ~ok then break,end //user cancel modification
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
      rpar=[xmin;xmax;ymin;ymax]
      ipar=[win;1;N;clrs;siz;0]
      if prod(size(state))<>2*N+1 then state=zeros(2*N+1,1),end
      model(7)=state;model(8)=rpar;model(9)=ipar
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  win=1; clrs=[-4];
  N=2;
  ipar=[win;1;N;clrs;1;0]
  xmin=-15;xmax=15;ymin=-15;ymax=+15
  rpar=[xmin;xmax;ymin;ymax]
  state=zeros(2*N+1,1)
  model=list('scopxy',2,0,1,0,[],state,rpar,ipar,'d',%f,[%f %f])
  x=standard_define([2 2],model,'Anim')
end

