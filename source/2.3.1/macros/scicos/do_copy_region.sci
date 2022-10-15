function [scs_m,modified]=do_copy_region(scs_m,xc,yc,win)
xinfo('Drag to select region and click to fix the selection')
[reg,rect]=get_region(xc,yc,win)
modified=size(reg)>1
if rect==[] then return,end

xinfo('Drag to destination position and click to fix it')
rep(3)=-1
yc=yc-rect(4)  
while rep(3)==-1 , //move loop
  // draw block shape
  xrect(xc,yc+rect(4),rect(3),rect(4))
  if pixmap then xset('wshow'),end
  // get new position
  rep=xgetmouse()
  // erase block shape
  xrect(xc,yc+rect(4),rect(3),rect(4))

  xc=rep(1);yc=rep(2)
  xy=[xc,yc];
end

n=size(scs_m)
for k=2:size(reg)
  o=reg(k)
  // translate blocks and update connection index 
  if o(1)=='Link' then
    o(2)=o(2)-rect(1)+xc
    o(3)=o(3)-rect(2)+yc
    [from,to]=o(8:9)
    o(8)(1)=o(8)(1)+n-1;
    o(9)(1)=o(9)(1)+n-1;
  else
    o(2)(1)(1)=o(2)(1)(1)-rect(1)+xc
    o(2)(1)(2)=o(2)(1)(2)-rect(2)+yc
    if o(1)=='Block' then
      for i=5:8
	k_conn=find(o(2)(i)>0)
	o(2)(i)(k_conn)=o(2)(i)(k_conn)+n-1
      end
    end
  end
  scs_m($+1)=o
  drawobj(o)
end


function [reg,rect]=get_region(xc,yc,win)
alu=xget('alufunction')
wins=curwin
xset('window',win)
xset('alufunction',6)
reg=list();rect=[]
kc=find(win==windows(:,2))
if kc==[] then
  message('This window is not an active palette')
  return
elseif windows(kc,1)<0 then //click dans une palette
  kpal=-windows(kc,1)
  scs_m=palettes(kpal)
elseif win==curwin then //click dans la fenetre courante
  scs_m=scs_m
elseif pal_mode&win==lastwin then 
  scs_m=scs_m_s
elseif slevel>1 then
  execstr('scs_m=scs_m_'+string(windows(kc,1)))
else
  message('This window is not an active palette')
  return
end
rep(3)=-1
ox=xc
oy=yc
w=0;h=0
first=%t
while rep(3)==-1 do
  xrect(ox,oy,w,h)
  if first then rep=xgetmouse();else rep=xgetmouse(0),end
  xrect(ox,oy,w,h)
  xc1=rep(1);yc1=rep(2)
  ox=mini(xc,xc1)
  oy=maxi(yc,yc1)
  w=abs(xc-xc1);h=abs(yc-yc1)
  first=%f
end
xrect(ox,oy,w,h)
keep=[];del=[]
for k=2:size(scs_m)
  o=scs_m(k)
  if o(1)=='Block'|o(1)=='Text' then
    // check is block is outside rectangle
    orig=o(2)(1)
    sz=o(2)(2)
    x=[0 1 1 0]*sz(1)+orig(1)
    y=[0 0 1 1]*sz(2)+orig(2)
    ok=%f
    for kk=1:4
      data=[(ox-x(kk))'*(ox+w-x(kk)),(oy-h-y(kk))'*(oy-y(kk))];
      if data(1)<0&data(2)<0 then ok=%t;keep=[keep k];break;end
    end
    if ~ok then del=[del k],end
  end
end

[reg,DEL,DELL]=do_delete1(scs_m,del,%f)
reg=do_purge(reg)
rect=[ox,oy-h,w,h]
xrect(ox,oy,w,h)
xset('window',wins)
xset('alufunction',alu)
