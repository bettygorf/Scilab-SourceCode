
function [z]=colnew(res,ncomp,m,aleft,aright,zeta,ipar,ltol,tol,fixpnt,...
	fsub1,dfsub1,gsub1,dgsub1,guess1)
// Checks before calling bva 
if ncomp > 20 then write(%io(2),' ncomp < 20 requested ') ; return;end
mstar=prod(size(m))
if mstar<>ncomp then write(%io(2),' m must be of size ncomp');
	return;end
if sum(m) > 40  then write(%io(2),' m(1) +...+ m(ncomp) < 40 requested');
	return;end
if prod(size(ipar)) < 11  then write(%io(2),' ipar dimensioned at least 11');
	return;end
if prod(size(ltol))<>ipar(4)  then write(%io(2),'ltol must be of size ipar(4)')
	;return;end
if prod(size(tol))<>ipar(4)  then write(%io(2),'tol must be of size ipar(4)');
	;return;end
if prod(size(fixpnt))<>ipar(11) then 
    if ipar(11)<>0,write(%io(2),'fixpnt must be of size ipar(11)');
	;return;end
	end;
[z]=bva(res,ncomp,m,aleft,aright,zeta,ipar,ltol,tol,fixpnt,...
	fsub1,dfsub1,gsub1,dgsub1,guess1)
