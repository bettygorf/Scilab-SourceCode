function [scs_m,needcompile]=do_copy(scs_m,needcompile)
// Copyright INRIA
while %t
  [btn,xc,yc,win,Cmenu]=getclick()
  if Cmenu<>[] then
    Cmenu=resume(Cmenu)
  end
  kc=find(win==windows(:,2))
  if kc==[] then
    message('This window is not an active palette')
    k=[];break
  elseif windows(kc,1)<0 then //click dans une palette
    kpal=-windows(kc,1)
    palette=palettes(kpal)
    k=getblock(palette,[xc;yc])
    if k<>[] then 
      o=palette(k),
      graphics=o(2)
      for kk=5:8
	// mark port disconnected
	graphics(kk)=0*graphics(kk)
      end
      o(2)=graphics
      break,
    end
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
  dr=driver()
  if dr=='Rec' then driver('X11'),end
  while rep(3)==-1 , //move loop
    // draw block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    if pixmap then xset('wshow'),end
    // get new position
    rep=xgetmouse(0)
    // clear block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    xc=rep(1);yc=rep(2)
    xy=[xc,yc];
  end
    driver(dr)
  // update and draw block
  if rep(3)==2 then
//    drawobj(o)
    if pixmap then xset('wshow'),end
    return
  end
  o(2)(1)=xy
  drawobj(o)
  if pixmap then xset('wshow'),end
  scs_m_save=scs_m,nc_save=needcompile
  scs_m(size(scs_m)+1)=o
  needcompile=4
  [scs_m_save,nc_save,enable_undo,edited]=resume(scs_m_save,nc_save,%t,%t)
end


