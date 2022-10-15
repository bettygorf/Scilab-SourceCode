clear;lines(0);
z=poly(0,'z');
h=z/(z-.5);
[tg,fr]=group(100,h);
plot(fr,tg)
