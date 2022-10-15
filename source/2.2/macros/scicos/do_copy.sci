function [x,needcompile]=do_copy(x,needcompile)
while %t
  [btn,xc,yc,win]=xclick();
  if win==curwin then 
    [n,pt]=getmenu(datam,[xc,yc])
    if n>0 then n=resume(n),end
  end
  kc=find(win==windows(:,2))
  if kc==[] then 
    x_message('This window is not an active palette')
    k=[];break 
  elseif windows(kc,1)<0 then //click dans une palette
    kpal=-windows(kc,1)
    palette=objs(kpal)
    k=getblock(palette,[xc;yc])
    if k<>[] then o=palette(k),break,end
  elseif win==curwin then //click dans la fenetre courante
    k=getblock(x,[xc;yc])
    if k<>[] then 
      o=x(k);graphics=o(2)
      for kk=5:8
	// mark port disconnected
	graphics(kk)=0*graphics(kk)
      end
      o(2)=graphics
      break,
    end
  else 
    x_message('This window is not an active palette')
    k=[];break
  end
end
if k<>[] then
  xset('window',curwin);
  [btn,xc,yc]=xclick()
  xy=gridpoint([xc,yc]);
  geom=o(2);geom(1)=xy;o(2)=geom;
  drawobj(o)
  if pixmap then xset('wshow'),end
  x(size(x)+1)=o
  needcompile=%t
end
