function wdm=do_view(scs_m)
wpar=scs_m(1);wdm=wpar(1)
if size(wdm,'*')<4 then wdm(3)=0;wdm(4)=0;end
Xshift=wdm(3)
Yshift=wdm(4)
oxc=Xshift+(wdm(1)-80)/2
oyc=Yshift+(wdm(2))/2
plot2d(oxc,oyc,-1,'000')


[btn,xc,yc]=xclick(0) //get center of new view
Xshift=Xshift+(xc-oxc)
Yshift=Yshift+(yc-oyc)


wdm(3)=Xshift;wdm(4)=Yshift;
xset('alufunction',3);xbasc();xselect();
xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wdm(1),Yshift+wdm(2)])
xset('alufunction',6)


