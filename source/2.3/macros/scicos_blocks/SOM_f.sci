function [x,y,typ]=SOM_f(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
  wd=xget('wdim')
  graphics=arg1(2); [orig,sz,orient]=graphics(1:3)
  thick=xget('thickness');xset('thickness',2)
  p=wd(2)/wd(1)
  rx=sz(1)*p/2
  ry=sz(2)/2
  xarc(orig(1),orig(2)+sz(2),sz(1)*p,sz(2),0,360*64)


  xset('thickness',1)
  xsegs([orig(1) orig(1)+rx;orig(1)+2*rx orig(1)+rx],..
        [orig(2)+ry orig(2)+2*ry;orig(2)+ry orig(2)],0)
  xset('thickness',thick)
  if orient then  //standard orientation
    out= [0  -1/14
          1/7    0
	  0   1/14]*3
    xfpoly(sz(1)*out(:,1)+ones(3,1)*(orig(1)+sz(1)*p),..
	sz(2)*out(:,2)+ones(3,1)*(orig(2)+sz(2)/2),1)
  else //tilded orientation
    out= [0   -1/14
	  -1/7    0
 	   0   1/14]*3
    xfpoly(sz(1)*out(:,1)+ones(3,1)*orig(1),..
	sz(2)*out(:,2)+ones(3,1)*(orig(2)+sz(2)/2),1)
  end
case 'getinputs' then
  graphics=o(2)
  [orig,sz,orient]=graphics(1:3)
  wd=xget('wdim');
  if orient then
    t=[%pi -%pi/2 0]
  else
    t=[%pi %pi/2 0]
  end
  r=sz(2)/2
  rx=r*wd(2)/wd(1)
  x=(rx*sin(t)+(orig(1)+rx)*ones(t))
  y=r*cos(t)+(orig(2)+r)*ones(t)
  typ=ones(x)
case 'getoutputs' then
  graphics=o(2)
  [orig,sz,orient]=graphics(1:3)
  wd=xget('wdim');
  if orient then
    t=%pi/2
    dx=sz(1)/7
  else
    t=-%pi/2
    dx=-sz(1)/7
  end
  r=sz(2)/2
  rx=r*wd(2)/wd(1)
  x=(rx*sin(t)+(orig(1)+rx)*ones(t))+dx
  y=r*cos(t)+(orig(2)+r)*ones(t)
  typ=ones(x)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  [graphics,model]=arg1(2:3);
  label=graphics(4)
  if size(label,'*')==2 then label=label(2),end
  while %t do
    [ok,sgn,label]=getvalue(['Set sum block parameter';' '
	                   'Input ports are located at up, left or right and down'
			   'position.'
			   'You must specify 3 gain numbers but if two links are '
			   'connected only the first values are used'
			   'Ports are numbered  anti-clock wise'],..
			   'Inputs signs/gain',list('vec',3),label)
    if ~ok then break,end
    model(8)=sgn(:)
    model(11)=[]//comptibility
    graphics(4)=label
    x(2)=graphics;x(3)=model
    break
  end
case 'define' then
  sgn=[1;1;1]
  model=list(list('sum',2),[-1;-1;-1],-1,[],[],[],[],sgn,[],'c',[],[%t %f],' ',list())
  label=[sci2exp(1);sci2exp(sgn)]
  x=standard_define([1 1]/1.2,model,label,[])
end




