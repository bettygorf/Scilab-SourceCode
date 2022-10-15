function drawtitle(wpar)
// draw window title
[frect1,frect2]=xgetech()
rect=xstringl(0,frect2(3),wpar(2)(1))
w=rect(3);h=rect(4)
xstring((frect2(3)-rect(3))/2,frect2(4)-h,wpar(2)(1))


