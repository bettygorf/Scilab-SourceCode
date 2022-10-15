function unix_x(cmd)
//unix_x - shell command execution, results redirected in an xless window
//%Syntax
// unix_x(cmd)
//%Parameters
// cmd - a character string
//%Description
// cmd instruction is passed to shell, the standard output is redirected 
// to  a background xless window
//%Examples
// unix_x("ls")
//%See also
// host unix_g unix_s
//!
if prod(size(cmd))<>1 then   error(55,1),end
host('('+cmd+')>'+TMPDIR+'/unix.out 2>'+TMPDIR+'/unix.err;echo $?>'+TMPDIR+'/unix.status')
errcatch(241,'continue','nomessage')
status=read(TMPDIR+'/unix.status',1,1)
errcatch(-1);
if iserror(241)==0 then
  if status==1 then
    msg=read(TMPDIR+'/unix.err',-1,1,'(a)')
    error('unix_x: '+msg(1))
  end
else
  errclear(241)
end
host('$SCI/bin/xless '+TMPDIR+'/unix.out & 2>/dev/null;')
