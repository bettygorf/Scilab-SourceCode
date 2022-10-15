 function [x,y,typ]=TIME_f(job,arg1,arg2)
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
   xarc(orig(1)+0.05*sz(1),orig(2)+0.95*sz(2),0.9*sz(1)*p,0.9*sz(2),0,360*64)
   xset('thickness',1);
   xsegs([orig(1)+rx    orig(1)+rx;  
          orig(1)+rx    orig(1)+rx+0.6*rx*cos(%pi/6)],..
         [orig(2)+ry    orig(2)+ry ;
	  orig(2)+1.8*ry  orig(2)+ry+0.6*ry*sin(%pi/6)],0)
   xset('thickness',thick);
 case 'getinputs' then
   [x,y,typ]=standard_inputs(arg1)
 case 'getoutputs' then
   [x,y,typ]=standard_outputs(arg1)
 case 'getorigin' then
   [x,y]=standard_origin(arg1)
 case 'set' then
   x=arg1
   graphics=arg1(2);label=graphics(4)
   while %t do
     [ok,label]=getvalue('Set Time block parameter',..
	 'Label',list('str',1),label)
     if ~ok then break,end
     graphics(4)=label;x(2)=graphics;
     break
   end
 case 'define' then
   model=list('timblk',0,1,0,0,[],[],[],[],'c',%f,[%f %t])
   x=standard_define([2 2],model)
 end
