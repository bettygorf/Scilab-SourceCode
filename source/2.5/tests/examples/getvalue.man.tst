clear;lines(0);
labels=["magnitude";"frequency";"phase    "];
[ok,mag,freq,ph]=getvalue("define sine signal",labels,...
     list("vec",1,"vec",1,"vec",1),["0.85";"10^2";"%pi/3"])
