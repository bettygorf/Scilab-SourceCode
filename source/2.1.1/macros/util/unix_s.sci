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
host(cmd+' >/dev/null ')

errcatch(48,'continue','nomessage')
msg=read(TMPDIR+'/unix.err',-1,1,'(a)')
errcatch(-1);
if iserror(48)==0 then
  if prod(size(msg)) >0 then
    error('sh : '+msg(1))
  end
else
  errclear(48)
end
