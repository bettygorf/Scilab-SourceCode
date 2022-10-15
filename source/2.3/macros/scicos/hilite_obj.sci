function hilite_obj(o)
//
if o(1)=='Block' then
  graphics=o(2);
  [orig,sz]=graphics(1:2)
  thick=xget('thickness')
  xset('thickness',6*thick);
  xrect(orig(1),orig(2)+sz(2),sz(1),sz(2));
  xset('thickness',thick);
elseif o(1)=='Link' then
  xx=o(2)
  yy=o(3)
  thick=xget('thickness')
  xset('thickness',6*thick)
  drawobj(o)
  xset('thickness',thick);
end
