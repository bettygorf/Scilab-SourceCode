clear;lines(0);
s='1 1.3'
[n,a,b]=msscanf(s,"%i %e")
msscanf(s,"%i %e")


msscanf(' 12\n','%c%c%c%c') //scan characters

msscanf('0xabc','%x') //scan with hexadecimal format


msscanf('012345abczoo','%[0-9abc]%s')  //[] notation

//create a file with data
u=mopen(TMPDIR+'/foo','w');
t=0.5;mfprintf(u,'%6.3f %6.3f\n',t,sin(t))
t=0.6;mfprintf(u,'%6.3f %6.3f\n',t,sin(t))
mclose(u);
//read the file
u=mopen(TMPDIR+'/foo','r');
[n,a,b]=mfscanf(u,'%e %e')
l=mfscanf(u,'%e %e')
mclose(u);
