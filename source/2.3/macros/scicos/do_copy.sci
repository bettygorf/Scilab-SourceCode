function [scs_m,needcompile]=do_copy(scs_m,needcompile)
while %t
  [btn,xc,yc,win]=xclick(0);
  if win==curwin then
    [n,pt]=getmenu(datam,[xc,yc])
    if n>0 then n=resume(n),end
  end
  if btn<>0 then
    [scs_m,modified]=do_copy_region(scs_m,xc,yc,win)
    if modified then needcompile=4,end
    return
  end
  kc=find(win==windows(:,2))
  if kc==[] then
    message('This window is not an active palette')
    k=[];break
  elseif windows(kc,1)<0 then //click dans une palette
    kpal=-windows(kc,1)
    palette=palettes(kpal)
    k=getblock(palette,[xc;yc])
    if k<>[] then o=palette(k),break,end
  elseif win==curwin then //click dans la fenetre courante
    k=getblock(scs_m,[xc;yc])
    if k<>[] then
      o=scs_m(k);graphics=o(2)
      for kk=5:8
	// mark port disconnected
	graphics(kk)=0*graphics(kk)
      end
      o(2)=graphics
      break,
    end
    elseif pal_mode&win==lastwin then 
    k=getblock(scs_m_s,[xc;yc])
    if k<>[] then
      o=scs_m_s(k);graphics=o(2)
      for kk=5:8
	// mark port disconnected
	graphics(kk)=0*graphics(kk)
      end
      o(2)=graphics
      break,
    end
  elseif slevel>1 then
    execstr('k=getblock(scs_m_'+string(windows(kc,1))+',[xc;yc])')
    if k<>[] then
      execstr('o=scs_m_'+string(windows(kc,1))+'(k)')
      graphics=o(2)
      for kk=5:8
	// mark port disconnected
	graphics(kk)=0*graphics(kk)
      end
      o(2)=graphics
      break,
    end
  else
    message('This window is not an active palette')
    k=[];break
  end
end
if k<>[] then
  xset('window',curwin);
  
  rep(3)=-1
  [xy,sz]=o(2)(1:2)
  while rep(3)==-1 , //move loop
    // draw block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    if pixmap then xset('wshow'),end
    // get new position
    rep=xgetmouse()
    // clear block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    xc=rep(1);yc=rep(2)
    xy=[xc,yc];
  end
  // update and draw block
  o(2)(1)=xy
  drawobj(o)
  if pixmap then xset('wshow'),end
  scs_m(size(scs_m)+1)=o
  needcompile=4
end


