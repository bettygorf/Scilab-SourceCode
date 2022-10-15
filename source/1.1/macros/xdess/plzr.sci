function []=plzr(a,b,c,d)
//
[lhs,rhs]=argn(0)
if type(a)=15 then
  if rhs<>1 then error(39),end
  select a(1)
    case 'lss' then [a,b,c,d]=a(2:5)
    case 'r' then a=tf2ss(a),[a,b,c,d]=a(2:5)
    else error(97,1)
  end;
end;
dr=spec(a)
[al,be]=tr_zer(a,b,c,d)
nr=al./be
ni=imag(nr);nr=real(nr)
di=imag(dr);dr=real(dr)
max=maxi([nr;dr;1;ni;di]*1.1)
min=mini([nr;dr;-1;ni;di]*1.1)
xselect();
isoview(min,max,min,max);
xx=xget("mark")
xset("mark",xx(1),xx(1)+1);
if prod(size(nr))<>0 then
  plot2d(nr,ni,[9,1],"101",'Zeros')
end;
plot2d([min;max],[0;0],[-4],"000",' ')
plot2d([0;0],[min;max],[-4],"000",' ')
plot2d(dr,di,[2,2],"101",'Poles');
xarc(-1,1,2,2,0,360*64)
xtitle('transmission zeros and poles','real axis','imag. axis');
xset("mark",xx(1),xx(2));



