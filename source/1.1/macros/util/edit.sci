function [res]=edit(macroname,editor)
// macroname : character string giving a macroname 
//
[lhs,rhs]=argn(0)
if rhs<=1, editor ="emacs -w =80x50  ";end
//if ~isdef(macroname); write(%io(2),macroname+' is not defined');return;end;
errcatch(-1,"continue","nomessage")
if typeof(evstr(macroname))<>"macro" then 
	write(%io(2),macroname+' is not a macro');
	errcatch(-1); res=0;
	return
end
errcatch(-1);
fname='`ls $SCI/macros/*/'+macroname+'.sci`';
unix(editor+' '+fname);
unix("cp "+fname+" /tmp/poo.sci");
getf('/tmp/poo.sci');
unix("rm /tmp/poo.sci");
res=evstr(macroname);











