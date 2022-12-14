function [s1,s2]=sysconv(s1,s2)
//Syntax : [s1,s2]=sysconv(s1,s2)
//
// Converts s1 and s2 into common representation in order that
// system interconnexion operations can be applied.
// The conversion rules in given in the following table.
//   'c'  -> continuous time system
//   'd'  -> discrete time system
//    n   -> sampled system with sampling period n
//    []  -> system with undefined time domain
//For mixed systems s1 and s2 are put in state-space representation.
//
//                
//
// s1\s2|    'c'     |     'd'     |      n2        |     []     |
// ---------------------------------------------------------------
// 'c'  | nothing    |uncompatible | c2e(s1,n2)     |  c(s2)     |
// ---------------------------------------------------------------
// 'd'  |uncompatible| nothing     | e(s1,n2)       |  d(s2)     |
// ---------------------------------------------------------------
// n1   | c2e(s2,n1) | e(s2,n1)    | n1<>n2 uncomp  |  e(s2,n1)  |
//      |            |             | n1=n2  nothing |            |
// ---------------------------------------------------------------
// []   | c(s1)      | d(s1)       | e(s1,n2)       |  nothing   |
// ---------------------------------------------------------------
//
// Meaning:
//n1,n2    -> sampling period
//c2e(s,n) -> the continuous-time system s is transformed into
//            a sampled system with sampling period n.
//c(s)     -> conversion to continuous (time domain is 'c')
//d(s)     -> conversion to discrete (time domain is 'd')
//e(s,n)   -> conversion to samples system with period n
//!
s11=s1(1);s21=s2(1);
if s11(1)<>s21(1) then // conversion ss<-->tf
  if s11(1)='r' then s1=tf2ss(s1),else s2=tf2ss(s2),end
  s11=s1(1);s21=s2(1);
  //if s11(1)='lss' then s1=ss2tf(s1),else s2=tf2ss(s2),end
end;
if s11(1)=='r' then n1=4;end
if s21(1)=='r' then n2=4;end
if s11(1)=='lss' then n1=7;end
if s21(1)=='lss' then n2=7;end
select s1(n1)
 case 'c' then t1=0
 case 'd' then t1=1
 case []  then t1=3
 else t1=2
end;
select s2(n2)
 case 'c' then t2=0
 case 'd' then t2=1
 case [] then t2=3
 else t2=2
end;
select t1+4*t2
case 0 then,
case 1 then  warning('time domains are not compatible')
case 2 then  s2=dscr(s2,s1(n1))
case 3 then  s1(n1)='c'
case 4 then  warning('time domains are not compatible')
case 5 then,
case 6 then  s2(n2)=s1(n1)
case 7 then  s1(n1)='d'
case 8 then  s1=dscr(s1,s2(n2))
case 9 then  s1(n1)=s2(n2)
case 10 then
             if s1(n1)<>s2(n2) then
                 warning('time domains are not compatible')
              end;
case 11 then s1(n1)=s2(n2)
case 12 then s2(n2)='c'
case 13 then s2(n2)='d'
case 14 then s2(n2)=s1(n1)
end;



