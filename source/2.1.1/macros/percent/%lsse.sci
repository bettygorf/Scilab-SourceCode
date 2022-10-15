function [f]=%lsse(i,j,f)
// f= f(i,j)
//!
// origine s. steer inria 1988
//
if type(i)==4 then i=find(i),end
if type(j)==4 then j=find(j),end
if i==[]|j==[] then f=[],return,end
[a,b,c,d,x0,dom]=f(2:7)
f=list('lss',a,b(:,j),c(i,:),d(i,j),x0,dom)



