function [at,bt,ct,dt]=gtild(a,b,c,d)
// input:
// g:=[A,B,C,D] (syslin list) or g=g(s) 
// gtild returns g~(s) = g(-s)' (in transfer form or in state-space)
// calling sequences:
//-- [at,bt,ct,dt]=gtild(a,b,c,[d])
//-- [gt]=gtild(g) 
//!
[lhs,rhs]=argn(0),
select rhs,
 case 1 then
    if typeof(a)='rational' then
          v=varn([a(2),a(3)]),s=poly(0,v),
          at=horner(a,-s),
          if typeof(at)=='usual' then at=at'; else at=syslin('c',at'),end
          return,
    end,
    if typeof(a)='polynomial'
          v=varn(a),s=poly(0,v),
          at=horner(a,-s)';
          return, 
    end
    if typeof(a)='usual'
          at=a';
          return,
    end
    if typeof(a)='state-space'
          if typeof(a(5))='polynomial'
          d=a(5);v=varn(d);s=poly(0,v);
          dp=horner(d,-s);at=syslin('c',-a(2)',-a(4)',a(3)',dp'); 
          return
          end
          if typeof(a(5))='usual'
          at=syslin('c',-a(2)',-a(4)',a(3)',a(5)'); 
          return
          end
    end
 case 3 then a=syslin('c',a,b,c),
 case 4 then a=syslin('c',a,b,c,d),
        else
          error('gtild: Incorrect # of input arguments'),
end,
     at=syslin('cont',-a(2)',-a(4)',a(3)',a(5)'),
if lhs=4 then
     dt=at(5),ct=at(4),bt=at(3),at=at(2),
end;




