 function [x,y,typ]=DELAY_f(job,arg1,arg2)
 x=[];y=[],typ=[]
 select job
 case 'plot' then
   standard_draw(arg1)
   b1=xstringl(0,0,'e')
   b2=xstringl(0,0,'-Ts')
   graphics=arg1(2); [orig,sz]=graphics(1:2)
   h=-b1(2)+maxi(0,sz(2)-0.5*b1(4)+b2(4))/2
   w=maxi(0,sz(1)-b1(3)-b1(4))/2
   xstring(orig(1)+w,orig(2)+h,'e')
   xstring(orig(1)+w+b1(3)/2,orig(2)+h+b1(4)*0.5,'-Ts')
 case 'getinputs' then
   [x,y,typ]=standard_inputs(arg1)
 case 'getoutputs' then
   [x,y,typ]=standard_outputs(arg1)
 case 'getorigin' then
   [x,y]=standard_origin(arg1)
 case 'set' then
   x=arg1

   ppath = list([3 , 8 , 2],[3 , 8 , 3])
   newpar=list()
   for path=ppath do
     xx=get_tree_elt(arg1,path)
     execstr('xxn='+xx(5)+'(''set'',xx)')
     if ~and(xxn==xx) then
       arg1=change_tree_elt(arg1,path,xxn)
       newpar(size(newpar)+1)=path(3)
     end
   end
   x=arg1
   y=%f
   typ=newpar
 case 'define' then
   model = list('csuper',1,1,0,0,[],[],..
   list(list([600,400],'Delay',[],[]),..
   list('Block',list([242,170],[50,50],%t,' ',6,7,8,[]),..
   list('delay',1,1,1,0,[],..
   [0;0;0;0;0;0;0;0;0;0],[],[],'d',%f,[%f,%f]),' ','REGISTER_f'),..
   list('Block',list([247,281],[40,40],%t,' ',[],[],[],8),..
   list('csuper',0,0,0,1,[],[],..
   list(list([],' ',[],[]),..
   list('Block',list([],[],%t,' ',[],[],6,4),..
   list('evtdly',0,0,1,1,[],[],0.1,[],'d',%t,[%f,%f]),' ','EVTDLY_f'),..
   list('Block',list([],[],%t,'Out',[],[],7,[]),..
   list('output',0,0,1,0,[],[],[],1,'d',%f,[%f,%f]),' ','CLKOUT_f'),..
   list('Link',[],[],'drawlink',' ',[0,0],[10,-1],[2,1],[5,1]),..
   list('Block',..
   list([],[],%t,' ',[],[],4,[6;7]),..
   list('lsplit',0,0,1,2,[],[],[],[],'d',[%f,%f],[%t,%f]),' ','CLKSPLIT_f'),..
   list('Link',[],[],'drawlink',' ',[0,0],[10,-1],[5,1],[2,1]),..
   list('Link',[],[],'drawlink',' ',[0,0],[10,-1],[5,2],[3,1])),..
   [],'h',%f ,[%f,%f]),' ','CLOCK_f'),..
   list('Block',list([112,185],[20,20],%t,'In',[],6,[],[]),..
   list('input',0,1,0,0,[],[],[],1,'c',%f,[%f,%f]),' ','IN_f'),..
   list('Block',list([414,185],[20,20],%t,'Out',7,[],[],[]),..
   list('output',1,0,0,0,[],[],[],1,'c',%f,[%f,%f]),' ','OUT_f'),..
   list('Link',[132;234.85714],[195;195],'drawlink',' ',[0,0],[1,1],[4,1],[2,1]),..
   list('Link',[299.14286;414],[195;195],'drawlink',' ',[0,0],[1,1],[2,1],[5,1]),..
   list('Link',267*[1;1],[275.29;227.14],'drawlink',' ',[0,0],[10,-1],[3,1],[2,1])),..
   [],'h',%f,[%f,%f])
   x=standard_define([2 2],model,' ')
 end
