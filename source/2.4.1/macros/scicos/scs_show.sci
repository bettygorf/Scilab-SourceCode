function scs_show(scs_m,win)
// Copyright INRIA
oldwin=xget('window')
xset('window',win);xbasc()
wpar=scs_m(1)
wsiz=wpar(1)
Xshift=wsiz(3)
Yshift=wsiz(4)

xset('wdim',wsiz(1),wsiz(2))
[frect1,frect]=xgetech()
wdm=xget('wdim')
xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wsiz(1),Yshift+wsiz(2)])

drawobjs(scs_m)
