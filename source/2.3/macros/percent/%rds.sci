function r=%rds(r,m)
// r=r./m
//!
if size(m,'*')==0 then r=[],return,end
r(3)=r(3).*m
r(2)=r(2).*ones(m)



