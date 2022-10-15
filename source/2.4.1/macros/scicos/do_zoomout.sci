function wdm=do_zoomout(scs_m)
// Copyright INRIA
wpar=scs_m(1);wdm=wpar(1)
if size(wdm,'*')<6 then wdm(3)=0;wdm(4)=0;wdm(5)=wdm(1);wdm(6)=wdm(2);end
Xshift=wdm(3)
Yshift=wdm(4)

wdm(5)=wdm(5)/.9;wdm(6)=wdm(6)/.9;



