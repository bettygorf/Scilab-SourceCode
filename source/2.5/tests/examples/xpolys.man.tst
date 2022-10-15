clear;lines(0);
plot2d(0,0,-1,"012"," ",[0,0,1,1])
rand("uniform")
xset("pattern",3)
xpolys(rand(3,5),rand(3,5),[-1,-2,0,1,2])
xset("default")
