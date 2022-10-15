clear;lines(0);
w=0.1:0.1:5;mag=1+abs(sin(w));
fresp=cepstrum(w,mag);
plot2d([w',w'],[mag(:),abs(fresp)])
