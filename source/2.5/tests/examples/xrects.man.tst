clear;lines(0);
plot2d([-100,500],[-50,50],[-1,-1],"022")
cols=[-34,-33,-32,-20:5:20,32,33,34];
x=400*(0:14)/14; step=20;
rects=[x;10*ones(x);step*ones(x);30*ones(x)];
xrects(rects,cols)
xnumb(x,15*ones(x),cols)
