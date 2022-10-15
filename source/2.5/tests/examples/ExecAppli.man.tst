clear;lines(0);
h=unix_g("hostname")
ExecAppli(SCI+"/bin/scilex",h,"Scilab2")
CreateLink("SELF","Scilab2")
ExecAppli(SCI+"/bin/scilex -ns",h,"Scilab3")
