function draw(x)
nx=size(x)
for k=2:nx
   o=x(k)
   if o(1)<>'Link' then
     execstr(o(5)+'(''plot'',o)')
   else
     drawlink(o)
   end
end

