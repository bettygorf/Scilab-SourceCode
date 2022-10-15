clear;lines(0);
// Here xsetech is used to split the graphics window in two parts 
// first xsetech is used to set the first sub window 
// and the graphics scale 
xsetech([0,0,1.0,0.5],[-5,-3,5,3])
// we call plot2d with the "001" option to use the graphics scale 
// set by xsetech 
plot2d([1:10]',[1:10]',1,"001"," ")
// then xsetech is used to set the second sub window 
xsetech([0,0.5,1.0,0.5])
// the graphics scale is set by xsetech to [0,0,1,1] by default 
// and we change it with the use of the rect argument in plot2d 
plot2d([1:10]',[1:10}',1,"011"," ",[-6,-6,6,6])

// Four plots on a single graphics window 
xbasc()
xset("font",2,0)
xsetech([0,0,0.5,0.5]); plot3d()
xsetech([0.5,0,0.5,0.5]); plot2d()
xsetech([0.5,0.5,0.5,0.5]); grayplot()
xsetech([0,0.5,0.5,0.5]); histplot()
// back to default values for the sub window 
xsetech([0,0,1,1])
xset("default")
