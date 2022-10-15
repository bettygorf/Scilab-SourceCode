function f=%sdp(p1,p2)
// %sdp(M,p)=M.*p
//!
if size(p1,'*')==1 then
  p1=p1*ones(p2)
elseif size(p2,'*')==1 then
  p2=p2*ones(p1)
end
f=tlist(['r','num','den','dt'],p1,p2,[])



