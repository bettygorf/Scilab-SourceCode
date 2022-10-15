clear;lines(0);
s=poly(0,'s');
p=poly([1,2,3,4,1],'s','c')
det(s*eye()-companion(p))
roots(p)
spec(companion(p))
