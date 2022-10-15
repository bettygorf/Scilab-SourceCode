clear;lines(0);
[cells,fact,zzeros,zpoles]=...
eqiir('lp','ellip',[2*%pi/10,4*%pi/10],0.02,0.001)
transfer=fact*poly(zzeros,'z')/poly(zpoles,'z')
