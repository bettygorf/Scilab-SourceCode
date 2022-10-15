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
host('('+cmd+')>'+TMPDIR+'/unix.out 2>'+TMPDIR+'/unix.err;echo $?>'+TMPDIR+'/unix.status')
errcatch(241,'continue','nomessage')
status=read(TMPDIR+'/unix.status',1,1)
errcatch(-1);
if iserror(241)==0 then
  if status==1 then
    msg=read(TMPDIR+'/unix.err',-1,1,'(a)')
    error('unix_w: '+msg(1))
  end
else
  errclear(241)
end
write(%io(2),read(TMPDIR+'/unix.out',-1,1,'(a)'))
