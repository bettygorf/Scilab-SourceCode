function ExeclScilab(appli,h)
[lhs,rhs]=argn(0)
if rhs<>1 then error(39), end
dpy=getenv("DISPLAY")
p=SCI+"/bin/scilex"+" -display "+dpy
h=unix_g("hostname")
ExecAppli(SCI+"/bin/scilex",h,appli)
CreateLink("SELF",appli)
CreateLink(appli,"SELF")
