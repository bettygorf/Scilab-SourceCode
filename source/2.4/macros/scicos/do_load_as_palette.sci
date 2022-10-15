function [palettes,windows]=do_load_as_palette(palettes,windows)
// Copyright INRIA
[ok,scs_m,cpr,edited]=do_load()
if ~ok then return,end


maxpal=-mini([-200;windows(:,1)]) 
kpal=maxpal+1

lastwin=curwin

curwin=get_new_window(windows)
if or(curwin==winsid()) then
  
  xdel(curwin);
end
windows=[windows;[-kpal curwin]]
palettes(kpal)=scs_m
//
xset('window',curwin),xselect();
xset('alufunction',3)
if pixmap then xset('pixmap',1),end,xbasc();
wsiz=palettes(kpal)(1)(1)
xset('wdim',wsiz(1),wsiz(2))
Xshift=wsiz(3);Yshift=wsiz(4);
xsetech([-1 -1 8 8]/6,[Xshift,Yshift,Xshift+wsiz(1),Yshift+wsiz(2)])
drawobjs(palettes(kpal))
if pixmap then xset('wshow'),end
xinfo('Palette: may be used to copy  blocks or regions')
xset('window',lastwin)

