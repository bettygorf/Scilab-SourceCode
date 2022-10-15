function s2=%sir(i,j,s1,s2)
// %sir(i,j,M,r)  <=> r(i,j)=M
//!
//s2(i,j)=s1
if s1==[] then  // insertion d'une matrice vide
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
  [t,n,d]=s2(1:3),[ld,cd]=size(d),l=maxi(i),c=maxi(j)
  if l>ld then d(ld+1:l,:)=ones(l-ld,cd),ld=l,end
  if c>cd then d(:,cd+1:c)=ones(ld,c-cd),end
  n(i,j)=s1,[l,c]=size(s1),d(i,j)=ones(l,c)
  s2=list(t,n,d,s2(4))
end
//end


