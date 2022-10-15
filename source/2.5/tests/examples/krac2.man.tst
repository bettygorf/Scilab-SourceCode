clear;lines(0);
h=syslin('c',352*poly(-5,'s')/poly([0,0,2000,200,25,1],'s','c'));
xbasc();evans(h,100)
g=krac2(h)
hf1=h/.g(1);roots(denom(hf1))
hf2=h/.g(2);roots(denom(hf2))
