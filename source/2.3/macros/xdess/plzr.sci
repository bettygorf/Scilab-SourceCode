function plzr(a,b,c,d)
//
[lhs,rhs]=argn(0)

//-compat type(a)==15 retained for list/tlist compatibility
if type(a)==15|type(a)==16 then
  if rhs<>1 then error(39),end
  a1=a(1);
  select a1(1)
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
mx=maxi([nr;dr;1;ni;di]*1.1)
mn=mini([nr;dr;-1;ni;di]*1.1)
xselect();
isoview(mn,mx,mn,mx);
xx=xget("mark")
xset("mark",xx(1),xx(1)+1);
if prod(size(nr))<>0 then
  plot2d(nr,ni,[-9,-1],"101",'Zeros')
end;
plot2d([mn;mx],[0;0],[4],"000",' ')
plot2d([0;0],[mn;mx],[4],"000",' ')
plot2d(dr,di,[-2,-2],"101",'Poles');
xarc(-1,1,2,2,0,360*64)
xtitle('transmission zeros and poles','real axis','imag. axis');
xset("mark",xx(1),xx(2));



