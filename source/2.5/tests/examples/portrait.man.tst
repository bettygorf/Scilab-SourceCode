clear;lines(0);
a=rand(2,2)
deff('[ydot]=l_s(t,y)','ydot=a*y')
portrait(l_s)
