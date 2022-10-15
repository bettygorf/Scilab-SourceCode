function ExecScilab(appli)
[lhs,rhs]=argn(0)
if rhs<>1 then error(39), end
dpy=getenv("DISPLAY")
p=SCI+"/bin/scilex"+" -display "+dpy
h=unix_g("hostname")
ExecAppli(p,h,appli)
