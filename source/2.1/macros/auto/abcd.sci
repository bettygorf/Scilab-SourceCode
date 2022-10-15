function [A,B,C,D]=abcd(sl)
// Retrieves [A,B,C,D] matrices from linear system sl
if type(sl)<>15 then
  error('abcd: invalid input')
  return;
end
if sl(1)=='lss' then
 [A,B,C,D]=sl(2:5)
 return;
end
if sl(1)=='r' then
 w=tf2ss(sl);
 [A,B,C,D]=w(2:5)
end
