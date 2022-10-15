function x=do_move(x)
//get block to move
while %t
  [n,pt]=getmenu(datam);xc=pt(1);yc=pt(2)
  if n>0 then n=resume(n),end
//  [btn,xc,yc]=xclick()
  k=getobj(x,[xc;yc])
  if k<>[] then break,end
end
o=x(k);
if o(1)=='Link' then
  x_message('Not yet possible to move links')
  return
end
//look at connected links
connected=get_connected(x,k)
o=x(k)
xx=[];yy=[];ii=[];clr=[];mx=[];my=[]
//build set of segs to move

for i=connected
  oi=x(i)
  [xl,yl,ct,from,to]=oi([2,3,7:9])
  ct(1)=ct(1)+1;clr=[clr ct(1)]
  nl=prod(size(xl))

  if from(1)==k then
    ii=[ii i]
    if nl>=4 then
      x1=xl(1:4)
      y1=yl(1:4)
    elseif nl==3 then
      x1=xl([1 1:3])
      y1=yl([1 1:3])
    elseif xl(1)==xl(2)|yl(1)==yl(2) then // vertical or horizontal  link
      x1=[xl(1);xl(1)+(xl(2)-xl(1))/2;xl(1)+(xl(2)-xl(1))/2;xl(2)]
      y1=[yl(1);yl(1)+(yl(2)-yl(1))/2;yl(1)+(yl(2)-yl(1))/2;yl(2)]
    else
      x1=[xl(1);xl(1)+(xl(2)-xl(1))/2;xl(1)+(xl(2)-xl(1))/2;xl(2)]
      y1=[yl(1);yl(1);yl(2);yl(2)]
    end
    if xl(1)==xl(2) then
      mx=[mx,[1;1;0;0]]
      my=[my,[1;1;1;0]]
    else
      mx=[mx,[1;0;0;0]]
      my=[my,[1;1;0;0]]
    end
    xx=[xx x1];yy=[yy y1]
    xpolys(xl(1:mini(nl,4)),yl(1:mini(nl,4)),-ct(1))
    xpolys(x1,y1,-ct(1))
    if pixmap then xset('wshow'),end
  elseif to(1)==k then
    ii=[ii -i]
    if nl>=4 then
      x1=xl(nl:-1:nl-3)
      y1=yl(nl:-1:nl-3)
    elseif nl==3 then
      sel=[nl:-1:nl-2,nl-2]
      x1=xl([nl nl:-1:nl-2])
      y1=yl([nl nl:-1:nl-2])
    elseif xl(1)==xl(2)|yl(1)==yl(2) then // vertical or horizontal  link 
      xm=xl(2)+(xl(1)-xl(2))/2
      x1= [xl(2);xm;xm;xl(1)]
      ym=yl(2)+(yl(1)-yl(2))/2;
      y1= [yl(2);ym;ym;yl(1)]
    else
      xm=xl(2)+(xl(1)-xl(2))/2
      x1=[xl(2);xm;xm;xl(1)]
      y1=[yl(2);yl(2);yl(1);yl(1)]
    end
    if x1(1)==x1(2) then
      mx=[mx,[1;1;0;0]]
      my=[my,[1;1;1;0]]
    else
      mx=[mx,[1;0;0;0]]
      my=[my,[1;1;0;0]]
    end
    xx=[xx x1];yy=[yy y1]
    xpolys(xl(maxi(1,nl-3):nl),yl(maxi(1,nl-3):nl),-ct(1))
    xpolys(x1,y1,-ct(1))
    if pixmap then xset('wshow'),end
  end
end
[mxx,nxx]=size(xx)
if connected<>[] then // move a block and connected links
  [xmin,ymin]=getorigin(o)
  xc=xmin;yc=ymin
  rep(3)=-1
  graphics=o(2);[xy,sz]=graphics(1:2)
  // clear block 
  drawobj(o)
  // draw block shape
  xrect(xc,yc+sz(2),sz(1),sz(2))
  while rep(3)==-1 do
    rep=xgetmouse();
    // clear block shape
      xrect(xc,yc+sz(2),sz(1),sz(2))
    // clear moving links
    xpolys(xx+mx*(xc-xmin),yy+my*(yc-ymin),-clr)
    xc=rep(1);yc=rep(2)
    // get new position
    xy=gridpoint([xc,yc]);
    xc=xy(1);yc=xy(2)
    // draw block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    // draw moving part of links
    xpolys(xx+mx*(xc-xmin),yy+my*(yc-ymin),-clr)
    if pixmap then xset('wshow'),end
  end
  // clear  block shape
  xrect(xc,yc+sz(2),sz(1),sz(2))
  // update and draw block
  graphics(1)=xy;o(2)=graphics
  drawobj(o) 
  if pixmap then xset('wshow'),end
  // update objects structure
  x(k)=o

  //udate moved links
  
  xx=xx+mx*(xc-xmin)
  yy=yy+my*(yc-ymin)
  for i=1:prod(size(ii))
    oi=x(abs(ii(i)))
    xl=oi(2);yl=oi(3);nl=prod(size(xl))
    if ii(i)>0 then
      if nl>=4 then
	xl(1:4)=xx(:,i)
	yl(1:4)=yy(:,i)
      elseif nl==3 then
	xl=xx(2:4,i)
	yl=yy(2:4,i)
      else
	xl=xx(:,i)
	yl=yy(:,i)
      end
    else
      if nl>=4 then
	xl(nl-3:nl)=xx(4:-1:1,i)
	yl(nl-3:nl)=yy(4:-1:1,i)
      elseif nl==3 then
	xl=xx(4:-1:2,i)
	yl=yy(4:-1:2,i)
      else
	xl=xx(4:-1:1,i)
	yl=yy(4:-1:1,i)
      end
    end
    nl=prod(size(xl))
    //eliminate double points
    kz=find((xl(2:nl)-xl(1:nl-1))^2+(yl(2:nl)-yl(1:nl-1))^2==0)
    xl(kz)=[];yl(kz)=[]
    //store
    oi(2)=xl;oi(3)=yl;
    x(abs(ii(i)))=oi;
  end
else // move an unconnected block
  rep(3)=-1
  graphics=o(2);[xy,sz]=graphics(1:2)
  // clear block
  drawobj(o)
  // draw block shape
  xrect(xc,yc+sz(2),sz(1),sz(2))
  while rep(3)==-1 do
    // clear block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    rep=xgetmouse()
    xc=rep(1);yc=rep(2)
    // get new position
    xy=gridpoint([xc,yc]);
    xc=xy(1);yc=xy(2)
    // draw block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    if pixmap then xset('wshow'),end
  end
  // clear  block shape
  xrect(xc,yc+sz(2),sz(1),sz(2))
  // update and draw block
  graphics(1)=xy;o(2)=graphics
  drawobj(o) 
  if pixmap then xset('wshow'),end
  x(k)=o
end

