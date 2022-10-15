function fcontour2d(xr,yr,f,nz,style,strf,leg,rect,nax)
// deff('[z]=surf(x,y)','z=x**2+y**2');
// fcontour(surf,-1:0.1:1,-1:0.1:1,10);
//
//!
// Copyright INRIA
[lhs,rhs]=argn(0);
if rhs==0,s_mat=['deff(''[z]=surf(x,y)'',''z=x**3+y'');';
                'fcontour2d(-1:0.1:1,-1:0.1:1,surf,10,1:10,'"011"','" "',[-1,-1,1,1]*1.5);'];
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs<3,write(%io(2),[' I need at least 3 arguments';
                       'or zero to have a demo']);
return;end
if rhs<4,nz=10,end;
if rhs < 5 then
  if prod(size(nz))==1 then 
    style=1:nz;
  else 
    style=1:prod(size(nz)),
  end
end
if rhs < 6,strf="021",end
if rhs < 7,leg=" ",end
if rhs < 8,rect=[0,0,10,10],end
if rhs < 9,nax=[2,10,2,10],end
if type(f)==11 then comp(f),end;
contour2d(xr,yr,feval(xr,yr,f),nz,style,strf,leg,rect,nax)


