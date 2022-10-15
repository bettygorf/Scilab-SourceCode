function [newblocks,pals_changed]=do_edit_pal()
lastwin=curwin
curwin=get_new_window(windows)
xset('window',curwin)
xset('default')
windows=[windows;[-(size(palettes)+1) curwin]]
menu_e=['Help','Window','Palettes','Move','Copy','Align',..
               'AddNew','Delete','Save','Undo','Replot','View',..
	       'Calc','Back']
menu_p=['Help','Edit..','File..','Block..','View','Exit']
menu_f=['Help','Rename','Save','Save As','FSave','Load','Back']
scs_m_s=scs_m;
pal_mode=%t
scs_m=list(list([600,400,0,0],'Untitled',[],[],[]))
[scs_m,newblocks,pals_changed]=scicos(scs_m,menu_p)
xset('window',lastwin)
xselect()
