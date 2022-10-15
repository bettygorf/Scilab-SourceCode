clear;lines(0);
u=file('open',TMPDIR+'/foo','unknown')
for k=1:4
  a=rand(1,4)
  write(u,a)
end
file('rewind',u)
x=read(u,2,4)
file('close',u)
//
file('close',file() ) //closes all opened files (C or Fortran type).
//
[units,typs,nams]=file()
