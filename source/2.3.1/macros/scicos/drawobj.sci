function drawobj(o)
if o(1)=='Block' then
  execstr(o(5)+'(''plot'',o)')
elseif o(1)=='Link' then
  ct=o(7);c=ct(1)
  d=xget('dashes')
  xset('dashes',c)
  xpoly(o(2),o(3),'lines')
  xset('dashes',d)
elseif o(1)=='Text' then
  execstr(o(5)+'(''plot'',o)')
end




