function [rep,stat]=unix_g(cmd)
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
[lhs,rhs]=argn(0)
if prod(size(cmd))<>1 then   error(55,1),end
stat=host('('+cmd+')>'+TMPDIR+'/unix.out 2>'+TMPDIR+'/unix.err;')
select stat
case 0 then
  rep=read(TMPDIR+'/unix.out',-1,1,'(a)')
  if size(rep,'*')==0 then rep=[],end
case -1 then // host failed
  disp('host does not answer...')
  rep=emptystr()
else
  msg=read(TMPDIR+'/unix.err',-1,1,'(a)')
  disp(msg(1))
  rep=emptystr()
end
