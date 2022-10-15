function unix_w(cmd)
//unix_w - shell command execution results redirected in main scilab window
//%Syntax
// unix_w(cmd)
//%Parameters
// cmd - a character string
//%Description
// cmd instruction (sh syntax) is passed to shell, the standard output 
// is redirected  to main scilab window
//%Examples
// unix_w("ls")
//%See also
// host unix_x unix_s unix_g
//!
if prod(size(cmd))<>1 then   error(55,1),end
host(cmd+'>'+TMPDIR+'/unix.out 2>'+TMPDIR+'/unix.err')
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
write(%io(2),read(TMPDIR+'/unix.out',-1,1,'(a)'))


