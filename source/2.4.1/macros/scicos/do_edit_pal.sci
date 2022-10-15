function [newblocks,pals_changed]=do_edit_pal()
// Copyright INRIA
lastwin=curwin
disablemenus()
curwin=get_new_window(windows)
xset('window',curwin)
xset('default')
windows=[windows;[-(size(palettes)+1) curwin]]
scs_m_s=scs_m;
pal_mode=%t
scs_m=list(list([600,400,0,0],'Untitled',[],[],[]))
[scs_m,newblocks,pals_changed]=scicos(scs_m)
xset('window',lastwin)
enablemenus()
xselect()
