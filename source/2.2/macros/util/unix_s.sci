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
host('('+cmd+')>/dev/null 2>'+TMPDIR+'/unix.err;echo $?>'+TMPDIR+'/unix.status')
errcatch(241,'continue','nomessage')
status=read(TMPDIR+'/unix.status',1,1)
errcatch(-1);
if iserror(241)==0 then
  if status==1 then
    msg=read(TMPDIR+'/unix.err',-1,1,'(a)')
    error('unix_s: '+msg(1))
  end
else
  errclear(241)
end
