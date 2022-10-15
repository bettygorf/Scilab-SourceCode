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
stat=host('('+cmd+')>'+TMPDIR+'/unix.out 2>'+TMPDIR+'/unix.err;')
select stat
case 0 then
  host('$SCI/bin/xless '+TMPDIR+'/unix.out & 2>/dev/null;')
case -1 then // host failed
  error(85)
else //sh failed
  msg=read(TMPDIR+'/unix.err',-1,1,'(a)')
  error('unix_x: '+msg(1))
end

