function [A,B,C,D]=abcd(sl)
// Retrieves [A,B,C,D] matrices from linear system sl
//-compat type(sl)<>15 retained for list/tlist compatibility
if type(sl)<>15&type(sl)<>16 then
  error('abcd: invalid input')
  return;
end
typis=sl(1);
if typis(1)=='lss' then
 [A,B,C,D]=sl(2:5)
 return;
end
if typis(1)=='r' then
 w=tf2ss(sl);
 [A,B,C,D]=w(2:5)
end
