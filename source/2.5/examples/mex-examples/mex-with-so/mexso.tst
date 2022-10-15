scilab_functions =[...
                  "pipo1"; 
                  "pipo2"; 
           ];
addinter("./libmylib.so","libmylib_gateway",scilab_functions);

//same as "exec libmylib.sce"
[x,y,z]=pipo1(1,2,3);
if z~=3 then pause,end
[u,v]=pipo2(2,1:3);
if u~=2 then pause,end





