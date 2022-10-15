clear;lines(0);
t=[0:0.1:2*%pi]';
plot2d(sin(t),cos(t))
xbasc()
isoview(-1,1,-1,1)
plot2d(sin(t),cos(t),1,"001")
xset("default")
