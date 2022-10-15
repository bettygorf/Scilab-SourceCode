clear;lines(0);
plot2d([0;1],[0;1],0)
str=["Scilab" "is";"not" "elisaB"];
r=xstringl(0.5,0.5,str)
xrects([r(1) r(2)+r(4) r(3) r(4)]')
xstring(r(1),r(2),str)
