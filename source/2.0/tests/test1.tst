mode(-1)
a=[1 2 3 4 5]
if a([%f %t])<>2 then pause,end
a([%f %t])=-1;if a<>[1 -1 3 4 5] then pause,end
a=[1 2;3 4]
if a([%f %t],[%t %f])<>3 then pause,end
s=poly(0,'s')
a=[1 2 3 4 5]*s
if a([%f %t])<>2*s then pause,end
a([%f %t])=-s;if a<>[1 -1 3 4 5]*s then pause,end
a=[1 2;3 4]*s
if a([%f %t],[%t %f])<>3*s then pause,end
a=string([1 2 3 4 5])
if a([%f %t])<>'2' then pause,end
a([%f %t])='-1';if a<>string([1 -1 3 4 5]) then pause,end
a=string([1 2;3 4])
if a([%f %t],[%t %f])<>'3' then pause,end
