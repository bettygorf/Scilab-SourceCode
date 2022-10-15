function [x,y,typ]=EVENTSCOPE_f(job,arg1,arg2)
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
  model=arg1(3);[nclock,rpar,ipar]=model([4 8 9])
  win=ipar(1);clrs=ipar(3:nclock+2)
  //next line for compatibility
  per=rpar(1);
  while %t do
    [ok,label,nclock,clrs,win,per]=getvalue(..
	'Set Scope parameters',..
	['Block label';
	'Number of inputs';
	'inputs color c (<0) or mark (>0)';
	'Output window number';
	'Refresh period'],..
	 list('str',1,'vec',1,'vec',-1,'vec',1,'vec',1),..
	 ['EventScope';
	 string(nclock);
	 strcat(string(clrs),' ');
	 string(win);
	 string(per)]);
    if ~ok then break,end //user cancel modification
    mess=[]
    if size(clrs,'*')<>nclock then
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
    if ok then
      [model,graphics,ok]=check_io(model,graphics,0,0,nclock,0)
    else
      x_message(['Some specified values are inconsistent:';
	         ' ';mess])
    end
    if ok then
      rpar=[per]
      ipar=[win;1;matrix(clrs,nclock,1)]
      model(8)=rpar;model(9)=ipar
      graphics(4)=label;
      x(2)=graphics;x(3)=model
      break
    end
  end
case 'define' then
  nclock=1
  win=1; clrs=[-1;-3;-5;-7;-9;-11;-13;-15];
  ipar=[win;1;clrs(1:nclock)]
  per=30;
  rpar=[per]
  state=-1
  model=list('evscpe',0,0,1,0,[],state,rpar,ipar,'d',%f,[%f %f])
  x=standard_define([2 2],model)
end

