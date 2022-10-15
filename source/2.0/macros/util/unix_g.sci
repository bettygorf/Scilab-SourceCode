function rep=unix_g(cmd)
//unix_g - shell command execution 
//%Syntax
//rep=unix_g(cmd)
//%Parameters
// cmd - a character string
// rep - a column vector of character strings
//%Description
// cmd instruction (sh syntax) is passed to shell, the standard output 
// is redirected  to scilab variable rep.
//%Examples
// unix_g("ls")
//%See also
// host unix_x unix_s
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
rep=read(TMPDIR+'/unix.out',-1,1,'(a)')

