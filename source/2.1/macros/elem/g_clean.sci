function a=g_clean(a,epsa,epsr)
//Syntax: [a]=clean(a,epsa,epsr)
// Given a, matrix of rationals or a polynomial matrix, this macro
// eliminates  all the coefficients of a with absolute value < epsa 
// and realtive value < epsr  (relative means realive wrt  norm 1 of
// the coefficients)
// Default values : epsa=1.d-10; epsr=1.d-10;
//!
[lhs,rhs]=argn(0)
if rhs == 1 then
  epsa=1.d-10;
  epsr=1.d-10;
elseif rhs==2 then
  epsr=1.d-10;
end
select type(a)
case 1 then
  a=clean(a,epsa,epsr)
case 2 then
  a=clean(a,epsa,epsr)
case 3 then
  a=clean(a,epsa,epsr)
case 15 then
 if a(1)<>'r' then error(43),end
 tdom=a(4)
 a2=clean(a(2),epsa,epsr),
 a3=clean(a(3),epsa,epsr),
 a=simp(a2./a3);a(4)=tdom
else
 error('clean: not implemented for this variable type')
end



