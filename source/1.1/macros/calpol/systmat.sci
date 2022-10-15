function [Sm]=systmat(Sl);
// System matrix of the linear system Sl (syslin list)
// in state-space form.
// Sm = [-sE + A   B;
//      [    C     D]
// To get the zeros use determ or detr (for square systems)
//!
ty=sl(1);
if ty=='lss' then
if sl(7)=='d' then
s=poly(0,'z');
else
s=poly(0,'s');
end
Sm=[-s*eye+sl(2),sl(3);sl(4),sl(5)];
return
end
if part(ty,1)=='d' then
s=poly(0,'s');
Sm=[-s*sl(6)+sl(2),sl(3);sl(4),sl(5)];
return
end



