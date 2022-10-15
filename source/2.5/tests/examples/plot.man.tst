clear;lines(0);
x=0:0.1:2*%pi;
// simple plot
plot(sin(x))
// using captions
xbasc()
plot(x,sin(x),"sin","time","plot of sinus")
// plot 2 functions
xbasc()
plot([sin(x);cos(x)])
