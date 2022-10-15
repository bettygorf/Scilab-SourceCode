function z=bvode(res,ncomp,m,aleft,aright,zeta,ipar,ltol,tol,fixpnt,...
fsub1,dfsub1,gsub1,dgsub1,guess1)
// Copyright INRIA

// Checks before calling bva 
if ncomp > 20 then error('bvode: ncomp < 20 requested ') ;end
mstar=prod(size(m))
if mstar<>ncomp then error('bvode: m must be of size ncomp');end
if sum(m) > 40  then error('bvode: m(1) +...+ m(ncomp) < 40 requested');end
if prod(size(ipar)) < 11  then error('bvode: ipar dimensioned at least 11');end
if prod(size(ltol))<>ipar(4)  then error('bvode: ltol must be of size ipar(4)');end
if prod(size(tol))<>ipar(4)  then error('bvode: tol must be of size ipar(4)');end
if prod(size(fixpnt))<>ipar(11) then 
  if ipar(11)<>0 then
    error('bvode: fixpnt must be of size ipar(11)');
  end
end
[z]=bva(res,ncomp,m,aleft,aright,zeta,ipar,ltol,tol,fixpnt,...
	fsub1,dfsub1,gsub1,dgsub1,guess1)
