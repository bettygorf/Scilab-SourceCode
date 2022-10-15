function scs_m=do_move(scs_m)
// get a scicos object to move, and move it with connected objects
//!
//get block to move
while %t
  [n,pt]=getmenu(datam);xc=pt(1);yc=pt(2)
  if n>0 then n=resume(n),end
  [k,wh]=getobj(scs_m,[xc;yc])
  if k<>[] then break,end
end

if scs_m(k)(1)=='Block'|scs_m(k)(1)=='Text' then
  scs_m=moveblock(scs_m,k,xc,yc)
elseif scs_m(k)(1)=='Link' then
  scs_m=movelink(scs_m,k,xc,yc,wh)
end

function scs_m=moveblock(scs_m,k,xc,yc)
// Move  block k and modify connected links if any
//!
//look at connected links
connected=get_connected(scs_m,k)
o=scs_m(k)
xx=[];yy=[];ii=[];clr=[];mx=[];my=[]

// build movable segments for all connected links
//===============================================
for i=connected
  oi=scs_m(i)
  [xl,yl,ct,from,to]=oi([2,3,7:9])
  clr=[clr ct(1)]
  nl=prod(size(xl))
  if from(1)==k then
    ii=[ii i]
    // build movable segments for this link
    if nl>=4 then
      x1=xl(1:4)
      y1=yl(1:4)
    elseif nl==3 then 
      // 3 points link add one point at the begining
      x1=xl([1 1:3])
      y1=yl([1 1:3])
    elseif xl(1)==xl(2)|yl(1)==yl(2) then 
      // vertical or horizontal   2 points link add a point in the middle
      x1=[xl(1);xl(1)+(xl(2)-xl(1))/2;xl(1)+(xl(2)-xl(1))/2;xl(2)]
      y1=[yl(1);yl(1)+(yl(2)-yl(1))/2;yl(1)+(yl(2)-yl(1))/2;yl(2)]
    else
      // oblique 2 points link add 2 points in the middle
      x1=[xl(1);xl(1)+(xl(2)-xl(1))/2;xl(1)+(xl(2)-xl(1))/2;xl(2)]
      y1=[yl(1);yl(1);yl(2);yl(2)]
    end
    //set allowed (x or y) move for each points of build movable segments
    if nl==3 then
      if xl(1)==xl(2) then 
	mx=[mx,[1;1;1;0]]
	my=[my,[1;1;0;0]]
      else
	mx=[mx,[1;1;0;0]]
	my=[my,[1;1;1;0]]
      end
    else
      if xl(1)==xl(2) then
	mx=[mx,[1;1;0;0]]
	my=[my,[1;1;1;0]]
      else
	mx=[mx,[1;0;0;0]]
	my=[my,[1;1;0;0]]
      end
    end
    xx=[xx x1];yy=[yy y1]  //store  movable segments for this link
    // redraw movable segments
    xpolys(xl(1:mini(nl,4)),yl(1:mini(nl,4)),ct(1))
    xpolys(x1,y1,ct(1))
    if pixmap then xset('wshow'),end
  elseif to(1)==k then
    ii=[ii -i]
    // build movable segments
    if nl>=4 then
      x1=xl(nl:-1:nl-3)
      y1=yl(nl:-1:nl-3)
    elseif nl==3 then 
      // 3 points link add one point at the end
      sel=[nl:-1:nl-2,nl-2]
      x1=xl([nl nl:-1:nl-2])
      y1=yl([nl nl:-1:nl-2])
    elseif xl(1)==xl(2)|yl(1)==yl(2) then 
      // vertical or horizontal 2 points link add a point in the middle
      xm=xl(2)+(xl(1)-xl(2))/2
      x1= [xl(2);xm;xm;xl(1)]
      ym=yl(2)+(yl(1)-yl(2))/2;
      y1= [yl(2);ym;ym;yl(1)]
    else
      // oblique 2 points link add 2 points in the middle
      xm=xl(2)+(xl(1)-xl(2))/2
      x1=[xl(2);xm;xm;xl(1)]
      y1=[yl(2);yl(2);yl(1);yl(1)]
    end
    if nl==3 then
      if x1(2)==x1(3) then 
	mx=[mx,[1;1;1;0]]
	my=[my,[1;1;0;0]]
      else
	mx=[mx,[1;1;0;0]]
	my=[my,[1;1;1;0]]
      end
    else
      if x1(1)==x1(2) then
	mx=[mx,[1;1;0;0]]
	my=[my,[1;1;1;0]]
      else
	mx=[mx,[1;0;0;0]]
	my=[my,[1;1;0;0]]
      end
    end
    xx=[xx x1];yy=[yy y1] //store  movable segments for this link
    // redraw movable segments 
    xpolys(xl(maxi(1,nl-3):nl),yl(maxi(1,nl-3):nl),ct(1))
    xpolys(x1,y1,ct(1))
    if pixmap then xset('wshow'),end
  end
end

// move a block and connected links
//=================================
[mxx,nxx]=size(xx)
if connected<>[] then // move a block and connected links
  [xmin,ymin]=getorigin(o)
  xc=xmin;yc=ymin
  rep(3)=-1
  [xy,sz]=o(2)(1:2)
  // clear block
  drawobj(o)
  // clear links 
  xpolys(xx+mx*(xc-xmin),yy+my*(yc-ymin),clr)
  dr=driver()
  if dr=='Rec' then driver('X11'),end
  while rep(3)==-1 ,  // move loop
    // draw block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    // draw moving links
    xpolys(xx+mx*(xc-xmin),yy+my*(yc-ymin),clr)
    // get new position
    rep=xgetmouse();
    // clear block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    // clear moving part of links
    xpolys(xx+mx*(xc-xmin),yy+my*(yc-ymin),clr)
    if pixmap then xset('wshow'),end
    xc=rep(1);yc=rep(2)
    xy=[xc,yc];
  end
  // update and draw block
  o(2)(1)=xy
  driver(dr)
  xpolys(xx+mx*(xc-xmin),yy+my*(yc-ymin),clr)
  drawobj(o)
  if pixmap then xset('wshow'),end
  // update block in scicos structure
  scs_m(k)=o
  
  //udate moved links in scicos structure
  xx=xx+mx*(xc-xmin)
  yy=yy+my*(yc-ymin)
  for i=1:prod(size(ii))
    oi=scs_m(abs(ii(i)))
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
    scs_m(abs(ii(i)))=oi;
  end
else // move an unconnected block
  rep(3)=-1
  [xy,sz]=o(2)(1:2)
  // clear block
  drawobj(o)
  dr=driver()
  if dr=='Rec' then driver('X11'),end
  while rep(3)==-1 , //move loop
    // draw block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    // get new position
    rep=xgetmouse(0)
    // clear block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    xc=rep(1);yc=rep(2)
    xy=[xc,yc];
    if pixmap then xset('wshow'),end
  end
  // update and draw block
  o(2)(1)=xy
  driver(dr)
  drawobj(o)
  if pixmap then xset('wshow'),end
  // update block in scicos structure
  scs_m(k)=o
end

function scs_m=movelink(scs_m,k,xc,yc,wh)
// move the  segment wh of the link k and modify the other segments if necessary
//!
o=scs_m(k)

[xx,yy,ct]=o([2 3 7])
nl=size(o(2),'*')  // number of link points
if wh==1 then
  from=o(8)
  if scs_m(from(1))(3)(1)<>'lsplit'|nl<3 then
    message('It is not possible to move these segments')
    return
  else  // link comes from a split 
    e=[min(yy(1:2))-max(yy(1:2)),min(xx(1:2))-max(xx(1:2))];
    e=e/norm(e)
    X1=xx(1:3)
    Y1=yy(1:3)
    x1=X1;y1=Y1;
    xpolys(x1,y1,ct(1))
    dr=driver()
    if dr=='Rec' then driver('X11'),end
    rep(3)=-1
    while rep(3)==-1 do
      //draw moving part of the link
      xpolys(x1,y1,ct(1))
      rep=xgetmouse();
      //erase moving part of the link
      xpolys(x1,y1,ct(1))
      xc1=rep(1);yc1=rep(2)
      x1(1:2)=X1(1:2)+e(1)*(xc-xc1)
      y1(1:2)=Y1(1:2)+e(2)*(yc-yc1)
      if pixmap then xset('wshow'),end
    end
    //draw moving part of the link
    driver(dr)
    xpolys(x1,y1,ct(1))
    if pixmap then xset('wshow'),end
    xx(1:3)=x1
    yy(1:3)=y1
    o(2)=xx;o(3)=yy;
    scs_m(k)=o
    //move split block and update other connected links
    connected=get_connected(scs_m,from(1))
    //erase split and other connected links
    for j=find(connected<>k),drawobj(scs_m(connected(j))),end
    drawobj(scs_m(from(1)))
    // change links
    if connected(1)<>k then
      o=scs_m(connected(1));
      [xx,yy,ct]=o([2 3 7]);
      xx($)=xx($)+e(1)*(xc-xc1);
      yy($)=yy($)+e(2)*(yc-yc1);
      xpolys(xx,yy,ct(1))
      o(2)=xx;o(3)=yy;scs_m(connected(1))=o;
    end
    for kk=2:size(connected,'*')
      if connected(kk)<>k then
	o=scs_m(connected(kk))
	[xx,yy,ct]=o([2 3 7])
	xx(1)=xx(1)+e(1)*(xc-xc1)
	yy(1)=yy(1)+e(2)*(yc-yc1)
	xpolys(xx,yy,ct(1))
	o(2)=xx;o(3)=yy;scs_m(connected(kk))=o;
      end
    end
    o=scs_m(from(1))
    o(2)(1)(1)=o(2)(1)(1)+e(1)*(xc-xc1);
    o(2)(1)(2)=o(2)(1)(2)+e(2)*(yc-yc1);
    drawobj(o)
    scs_m(from(1))=o
    return
  end
end
if wh>=nl-1 then
  to=o(9)
  if scs_m(to(1))(3)(1)<>'lsplit'|nl<3 then
    message('It is not possible to move these segments')
    return
  else // link goes to a split 
    e=[min(yy($-1:$))-max(yy($-1:$)),min(xx($-1:$))-max(xx($-1:$))];
    e=e/norm(e)
    X1=xx($-2:$)
    Y1=yy($-2:$)
    x1=X1;y1=Y1;
    dr=driver()
    xpolys(x1,y1,ct(1))
    if dr=='Rec' then driver('X11'),end
    rep(3)=-1
    while rep(3)==-1 do
      //draw moving part of the link
      xpolys(x1,y1,ct(1))
      rep=xgetmouse();
      //erase moving part of the link
      xpolys(x1,y1,ct(1))
      xc1=rep(1);yc1=rep(2)
      x1($-1:$)=X1($-1:$)+e(1)*(xc-xc1)
      y1($-1:$)=Y1($-1:$)+e(2)*(yc-yc1)
      if pixmap then xset('wshow'),end
    end
    //draw moving part of the link
    driver(dr)
    xpolys(x1,y1,ct(1))
    if pixmap then xset('wshow'),end
    xx($-2:$)=x1
    yy($-2:$)=y1
    o(2)=xx;o(3)=yy;
    scs_m(k)=o
    //move split block and update other connected links
    connected=get_connected(scs_m,to(1))
    //erase split and other connected links
    for j=find(connected<>k),drawobj(scs_m(connected(j))),end
    drawobj(scs_m(to(1)))
    for kk=2:size(connected,'*')
      o=scs_m(connected(kk))
      [xx,yy,ct]=o([2 3 7])
      xx(1)=xx(1)+e(1)*(xc-xc1)
      yy(1)=yy(1)+e(2)*(yc-yc1)
      xpolys(xx,yy,ct(1))
      o(2)=xx;o(3)=yy;scs_m(connected(kk))=o;
    end
    o=scs_m(to(1))
    o(2)(1)(1)=o(2)(1)(1)+e(1)*(xc-xc1);
    o(2)(1)(2)=o(2)(1)(2)+e(2)*(yc-yc1);
    drawobj(o)
    scs_m(to(1))=o
    return      
  end
end
if nl<4 then
  message('It is not possible to move these links')
  return
end
e=[min(yy(wh:wh+1))-max(yy(wh:wh+1)),min(xx(wh:wh+1))-max(xx(wh:wh+1))];
e=e/norm(e)
X1=xx(wh-1:wh+2)
Y1=yy(wh-1:wh+2)
x1=X1;y1=Y1;
dr=driver()
xpolys(x1,y1,ct(1))
if dr=='Rec' then driver('X11'),end
rep(3)=-1
while rep(3)==-1 do
  //draw moving part of the link
  xpolys(x1,y1,ct(1))
  rep=xgetmouse();
  //erase moving part of the link
  xpolys(x1,y1,ct(1))
  xc1=rep(1);yc1=rep(2)
  x1(2:3)=X1(2:3)+e(1)*(xc-xc1)
  y1(2:3)=Y1(2:3)+e(2)*(yc-yc1)
  if pixmap then xset('wshow'),end
end
//draw moving part of the link
driver(dr)
xpolys(x1,y1,ct(1))
if pixmap then xset('wshow'),end
xx(wh-1:wh+2)=x1
yy(wh-1:wh+2)=y1
o(2)=xx;o(3)=yy;
scs_m(k)=o




