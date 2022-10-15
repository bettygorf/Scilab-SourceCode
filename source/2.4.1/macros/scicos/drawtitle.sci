function drawtitle(wpar)
// draw window title
// Copyright INRIA
wpar=scs_m(1);wdm=wpar(1)
w=wdm(5)/3;h=wdm(6)/12;
pat=xget('pattern')
xset('pattern',default_color(0));
//xrect(wdm(3)+(wdm(5)-w)/2,wdm(4)+wdm(6),w,h)
xstringb(wdm(3)+(wdm(5)-w)/2,wdm(4)+wdm(6)-h,wpar(2)(1),w,h,'fill')
//
xset('pattern',pat)
