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
          if a(1)='r' then
             v=varn(a(2)),s=poly(0,v),
             at=horner(a,-s),at=syslin('c',at'),
             return,end,
     case 3 then a=syslin('c',a,b,c),
     case 4 then a=syslin('c',a,b,c,d),
     else
          error('Input arguments are :[A,[B,C,[D]]]'),
     end,
     at=syslin('cont',-a(2)',-a(4)',a(3)',a(5)'),
     if lhs=4 then
        dt=at(5),ct=at(4),bt=at(3),at=at(2),
     end,



