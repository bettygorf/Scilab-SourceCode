function unix_s(cmd)
//unix_s - silent shell command execution
//%Syntax
// unix_s(cmd)
//%Parameters
// cmd - a character string
//%Description
// cmd instruction (sh syntax) is passed to shell, the standard output 
// is redirected  to  /dev/null
//%Examples
// unix_s("\rm -f foo")
//%See also
// host unix_g unix_x
//!
if prod(size(cmd))<>1 then   error(55,1),end
stat=host('('+cmd+')>/dev/null 2>'+TMPDIR+'/unix.err;')
select stat
case 0 then
case -1 then // host failed
  error(85)
else //sh failed
  msg=read(TMPDIR+'/unix.err',-1,1,'(a)')
  error('unix_s: '+msg(1))
end

