function [gc]=ctr_gram(a,b,domaine)
//!
[lhs,rhs]=argn(0)
select type(a)
 case 1  then
    if rhs<2 then error(39); end;
    if rhs=2 then domaine='c'; end;
    if part(domaine,1)<>'c' then domaine='d',end
    [m,n]=size(a)
    if m<>n then error(20,1),end
    [mb,nb]=size(b);if mb<>n then error(60),end
    
  //-compat next case retained for list/tlist compatibility
case 15 then
    flag=a(1);
    if flag(1)='r' then a=tf2ss(a);end
    if flag(1)<>'lss' then error(91,1),end
    [a,b,domaine]=a([2,3,7])
    if domaine=[] then
write(%io(2),'Warning: ctr_gram --> By default time-domain is continuous')
      domaine='c';
    end
    [n,n]=size(a)
  case 16 then
    flag=a(1);
    if flag(1)='r' then a=tf2ss(a);end
    if flag(1)<>'lss' then error(91,1),end
    [a,b,domaine]=a([2,3,7])
    if domaine=[] then
write(%io(2),'Warning: ctr_gram --> By default time-domain is continuous')
      domaine='c';
    end
    [n,n]=size(a)    
 else error('(a,b) pair or syslin state-space')
end;
gc=lyap(a',-b*b',domaine)



