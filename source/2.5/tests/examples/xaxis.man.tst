clear;lines(0);
x=[-%pi:0.1:%pi]';
// plot without axis
plot2d(x,sin(x),1,"010"," ",[-4 -1 4 1])
// draw x axis
xpoly([-4 4],[0 0],"lines")
xaxis(0,[2 2],[2 0.1 3],[-4 0])
xstring(-4.1,-0.25,"-4"); xstring(-0.2,-0.1,"0"); xstring(4,-0.25,"4")
// draw y axis
xpoly([0 0],[-1 1],"lines")
xaxis(90,[2 2],[0.5 0.025 3],[0 1])
xstring(-0.5,-1.05,"-1"); xstring(-0.35,0.95,"1")
