clear;lines(0);
f=[0,0.4,0.4,0.6,0.6,1];H=[0,0,1,1,0,0];Hz=yulewalk(8,f,H);
fs=1000;fhz = f*fs/2;  
xbasc(0);xset('window',0);plot2d(fhz',H');
xtitle('Desired Frequency Response (Magnitude)')
[frq,repf]=repfreq(Hz,0:0.001:0.5);
xbasc(1);xset('window',1);plot2d(fs*frq',abs(repf'));
xtitle('Obtained Frequency Response (Magnitude)')
