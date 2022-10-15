function s2=%sir(i,j,s1,s2)
// %sir(i,j,M,r)  <=> r(i,j)=M
//!
//s2(i,j)=s1
//
if type(i)==10 then  // s2('num'),s2('den'),sl('dt')
  [lhs,rhs]=argn(0)
  if rhs<>3 then  error(21),end
  nams=['num','den','dt']
  kf=find(i==nams)
  if kf==[] then error(21),end
  s2=s1;kf=kf+1
  if size(s2(kf))<>size(j) then 
    if kf<>4|prod(size(j))>1 then
    warning('inserted element '+i+' has inconsistent dimension')
    end
  end
  s2(kf)=j
  return
end
if type(i)==4 then i=find(i),end
if type(j)==4 then j=find(j),end
[m,n]=size(s2(2))
if type(i)<>1 then i=horner(i,l),end
if type(j)<>1 then j=horner(j,c),end
if s1==[] then  // insertion d'une matrice vide
  if i==[]|j==[] then s=s2,return,end
  row=%f
  col=%f
  [m,n]=size(s2(2))
  if and(size(i)==[-1 -1]) then
    row=%t
  else
    if and(i(:)==(1:m)') then row=%t,end
  end
  if and(size(j)==[-1 -1]) then
    col=%t
  else
    if and(j(:)==(1:n)') then col=%t,end
  end
  if ~row&~col then error('inserting [] in submatrix --> forbidden!'),end
  if row&col then s2=[],return,end
  if row then
    j1=[]
    for jj=1:n
      if ~or(jj==j) then  j1=[j1 jj] ,end
    end
    s2=s2(:,j1)
  else
    i1=[]
    for ii=1:m
      if ~or(ii==i) then  i1=[i1 ii] ,end
    end
    s2=s2(i1,:)
  end
else
  [n,d]=s2(2:3),[ld,cd]=size(d),l=maxi(i),c=maxi(j)
  if l>ld then d(ld+1:l,:)=ones(l-ld,cd),ld=l,end
  if c>cd then d(:,cd+1:c)=ones(ld,c-cd),end
  n(i,j)=s1,[l,c]=size(s1),d(i,j)=ones(l,c)
  s2=tlist(['r','num','den','dt'],n,d,s2(4))
end



