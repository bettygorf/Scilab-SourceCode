function [nutr,ierr]=mesh2d(x,y,front)
[lhs,rhs]=argn(0)
if (rhs>3|rhs<2) then error(39), end
nbs=size(x,2);n1=size(y,2);
if(nbs <> n1) then 
  error('Incompatible arrays dimensions')
end
if(nbs < 3) then 
  error('Minimum 3 points needed')
end
n6=6*nbs-9;
n4=4*nbs-4;
if (rhs == 2) then
  [iadj,iend,nbt,nutr,ierr]=m6deumesh(nbs,n4,n6,x,y);
else  
  n6=6*(nbs+nbs-2)
  lfront=size(front,2);
  cr=[x;y];
  tri=zeros(1,n4);
  [nbt,nutr,c,err]=m6mesh2b(nbs,n6,n4,lfront,cr,tri,front);
  ntot=3*nbt;nunu=nutr(1:ntot);
  nutr=matrix(nunu,3,nbt);
end;
ii=find(nutr(1,:)==0); nutr(:,ii)=[];
