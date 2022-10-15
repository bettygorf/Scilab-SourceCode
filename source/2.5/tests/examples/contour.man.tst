clear;lines(0);
t=%pi*[-10:10]/10;
deff("[z]=surf(x,y)","z=sin(x)*cos(y)"); z=feval(t,t,surf);
rect=[-%pi,%pi,-%pi,%pi,-1,1];
contour(t,t,z,10,35,45," ",[0,1,0],rect)
// changing the format of the printing of the levels
xset("fpf","%.2f")
xbasc()
contour(t,t,z,10,35,45," ",[0,1,0],rect)
