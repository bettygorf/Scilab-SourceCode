clear;lines(0);
p1=linspace(0,2*%pi,10);
p2=linspace(0,2*%pi,10);
deff("[x,y,z]=scp(p1,p2)",["x=p1.*sin(p1).*cos(p2)";..
                            "y=p1.*cos(p1).*cos(p2)";..
                            "z=p1.*sin(p2)"])
[x,y,z]=eval3dp(scp,p1,p2);
plot3d(x,y,z)
