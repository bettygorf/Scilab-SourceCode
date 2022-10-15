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
// Copyright INRIA
if prod(size(cmd))<>1 then   error(55,1),end

if getenv('WIN32','NO')=='OK' & getenv('COMPILER','NO')=='VC++' then 
	out_f = strsubst(TMPDIR,'/','\')+'\unix.out';
	cmd1= cmd + ' > '+ out_f;
else 
	cmd1='('+cmd+')>'+TMPDIR+'/unix.out 2>'+TMPDIR+'/unix.err;';
end 
stat=host(cmd1);
select stat
case 0 then
  if getenv('WIN32','NO')=='OK' & getenv('COMPILER','NO')=='VC++' then 
  	host(strsubst(SCI,'/','\')+'\bin\xless.exe '+ out_f);
  else 
  	host('$SCI/bin/xless '+TMPDIR+'/unix.out & 2>/dev/null;')
  end
case -1 then // host failed
  error(85)
else //sh failed
  if getenv('WIN32','NO')=='OK' & getenv('COMPILER','NO')=='VC++' then 
	error('unix_x: shell error');
  else 
	  msg=read(TMPDIR+'/unix.err',-1,1,'(a)')
	  error('unix_x: '+msg(1))
  end 
end

