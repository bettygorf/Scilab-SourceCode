function [x,y,typ]=CLOCK_f(job,arg1,arg2)
x=[];y=[],typ=[]
select job
case 'plot' then
  standard_draw(arg1)
   [orig,sz]=arg1(1:2)
   wd=xget('wdim').*[1.016,1.12]
   graphics=arg1(2); [orig,sz,orient]=graphics(1:3)
   thick=xget('thickness');xset('thickness',2)
   p=wd(2)/wd(1);p=1
   rx=sz(1)*p/2
   ry=sz(2)/2
   xarcs([orig(1)+0.05*sz(1);
          orig(2)+0.95*sz(2);
	  0.9*sz(1)*p;
	  0.9*sz(2);
	  0;
	  360*64],10)
   xset('thickness',1);
   xsegs([orig(1)+rx    orig(1)+rx;  
          orig(1)+rx    orig(1)+rx+0.6*rx*cos(%pi/6)],..
         [orig(2)+ry    orig(2)+ry ;
	  orig(2)+1.8*ry  orig(2)+ry+0.6*ry*sin(%pi/6)],10)
   xset('thickness',thick);
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  // paths to updatable parameters or states
  ppath = list(2)
  newpar=list();
  path=2
  np=size(path,'*')
  spath=[matrix([3*ones(1,np);8*ones(1,np);path],1,3*np)]
  xx=get_tree_elt(arg1,spath)
  zz=xx(3);dt=zz(8)
  while %t do
    [ok,dt]=getvalue('Set Clock block parameters',..
	['Period'],..
	list('vec',1),..
	[string(dt)])
    if ~ok then break,end
    ok=dt>0
    if ~ok then
      x_message('Period must be positive.')
    else
      xxn=xx
      zz(8)=dt;xxn(3)=zz;
      if ~and(xxn==xx) then 
	// parameter or states changed
	arg1=change_tree_elt(arg1,spath,xxn)// Update
	newpar(size(newpar)+1)=path// Notify modification
      end
      break
    end
  end
  x=arg1
  y=%f
  typ=newpar
case 'define' then
  model = list('csuper',0,0,0,1,[],[],..
  list(list([600,400],' ',[],[],[]),..
  list('Block',list([218,210],[40,40],%t,' ',[],[],7,4),..
  list('evtdly',0,0,1,1,[],[],0.1,[],'d',%t,[%f,%f]),' ','EVTDLY_f'),..
  list('Block',list([351,148],[20,20],%t,'Out',[],[],6,[]),..
  list('output',0,0,1,0,[],[],[],1,'d',%f,[%f,%f]),' ','CLKOUT_f'),..
  list('Link',..
  [238;
  238;
  306.59898],..
  [204.28571;
  158;
  158],'drawlink',' ',[0,0],[10,-1],[2,1],[5,1]),..
  list('Block',..
  list(..
  [306.59898;
  158],[1,1],%t,' ',[],[],4,..
  [6;
  7]),list('lsplit',0,0,1,2,[],[],[],[],'d',[%f,%f],[%t,%f]),' ','CLKSPLIT_f'),..
  list('Link',..
  [306.59898;
  351],..
  [158;
  158],'drawlink',' ',[0,0],[10,-1],[5,1],[3,1]),..
  list('Link',..
  [306.59898;
  306.59898;
  238;
  238],..
  [158;
  299.7151;
  299.7151;
  255.71429],'drawlink',' ',[0,0],[10,-1],[5,2],[2,1])),[],'h',%f,[%f,%f])
  x=standard_define([2 2],model,' ')
end
