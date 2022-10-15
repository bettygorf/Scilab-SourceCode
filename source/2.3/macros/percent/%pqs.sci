function f=%pqs(p1,p2)
// f=%pqs(p,m) <=> f=p.\m
//!
if size(p1,'*')==1 then
  p1=p1*ones(p2)
elseif size(p2,'*')==1 then
  p2=p2*ones(p1)
end
f=tlist(['r','num','den','dt'],p2,p1,[])



