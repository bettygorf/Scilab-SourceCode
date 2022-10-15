function []=demo_01()
//[]=demo_01() 
//             
//!
rect_p=[-15,-15,15,15];
xset("wdim",400,400);
plot2d(0,0,-1,"010"," ",rect_p);
ok='no'
while ok='no' then
    mess='chose demo number: 1-4,0 to leave'
    write(%io(2),mess,'(a,3x,$)')
    n=read(%io(1),1,1,'(a1)')
    select n
       case '0' then ok='yes'
       case '1' then
                   xclear()
                   plot2d(0,0,-1,"012"," ",rect_p)
                   t=0:0.2:5
                   for k=t,
                    polygone([-5+1.5*k,-4+0.8*k],round(3+k),0.5+1.5*k,k);
                   end
      case '2' then
                   xclear()
                   plot2d(0,0,-1,"012"," ",rect_p)
                   t=0:0.08:3*%pi; t=t(1:95);
                   for k=t,rectang([-5+0.5*k,0],0.5+1.6*k,0.5+1.6*k,k);end
      case '3' then
                   xclear()
                   plot2d(0,0,-1,"012"," ",rect_p)
                   xy=[-3 0;-3 0]
                   i=1
                   for l=1:8
                     xo=xy(:,i)
                     for k=1:12,
                       xy=rotate(xy,-0.1976,xo);
                       xpoly(xy(1,:),xy(2,:),"lines",1);
                     end
                     if i=1 then i=2,else i=1,end
                   end
      case '4' then
                   xclear()
                   plot2d(0,0,-1,"012"," ",rect_p)
                   xy=[-3 0;-3 0]
                   i=1
                   lseg=[];
                   for l=1:8
                     xo=xy(:,i)
                     for k=1:12,
                       xy=rotate(xy,-0.1976,xo);
                       lseg=[lseg,xy];
                     end
                     if i=1 then i=2,else i=1,end
                   end
                   xsegs(lseg(1,:),lseg(2,:));
    end
end
