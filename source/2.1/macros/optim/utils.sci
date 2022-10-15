function [r,ind]=aplat(l,r)
//flattens a list. If l is constant it puts it in a list
//ind contains the list structure
if type(l)==1|type(l)==5 then r=list(l);ind=-1;return;end
n=size(l)
[lhs,rhs]=argn(0)
if rhs==1 then r=list(),nr=0,end
ind=list()
i=0
nind=0
for li=l
 i=i+1
 if type(li)==15 then 
    [r,ind1]=aplat(li,r)
    ni=size(ind1)
    for j=1:ni,nind=nind+1;ind(nind)=[i,ind1(j)];end
    nr=size(r)
  else
    nr=nr+1
    r(nr)=li
    nind=nind+1
    ind(nind)=i
  end
end

function [r,ind]=recons(r,ind)
//reconstruct a list from a flat list (see aplat)
if ind=-1 then r=r(:);return;end
nr=size(r)
ma=0
for k=nr:-1:1
   mm=prod(size(ind(k)))
   if ma<=mm then ma=mm;ki=k; end
end

if ma<=1 then return; end
vi=ind(ki);vi=vi(1:ma-1);
k=ki
vj=vi

while vj=vi
  k=k+1
  if k>nr then break; end
  vv=ind(k);
  if prod(size(vv))==ma then vj=vv(1:ma-1); else vj=[]; end
end
kj=k-1
rt=list(r(ki))
for k=ki+1:kj
  rt(k-ki+1)=r(ki+1)
  r(ki+1)=null()
  ind(ki+1)=null()
end
ind(ki)=vi
r(ki)=rt
[r,ind]=recons(r,ind)


function li=vec2list(bigVector,varsizes,ind)
//bigVector: big vector
//varsizes: k x 2 matrix, varsizes(i,:)=size of ith matrix
//li: list of k matrices, li(i)=matrix of size varsizes(i,:);
[LHS,RHS]=argn(0)
if bigVector=[] then
     n=0;for dimi=varsizes',n=n+prod(dimi);end
bigVector=zeros(n,1);
end
li=list();point=1;i=0;
for dimi=varsizes'
 newpoint=point+prod(dimi)-1;i=i+1;
 li(i)=matrix(bigVector(point:newpoint),dimi(1),dimi(2));
 point=newpoint+1;
end
if RHS==3 then li=recons(li,ind); end


function [bigVector,varsizes]=list2vec(li)
//li=list(X1,...Xk) is a list of matrices
//bigVector: big vector [X1(:);...;Xk(:)] (stacking of matrices in li)
//varsizes: k x 2 matrix, with varsiz(i,:)=size(Xi)
bigVector=[];varsizes=[];
li=aplat(li)
for mati=li
  sm=size(mati);
  varsizes=[varsizes;sm];
  bigVector=[bigVector;matrix(mati,prod(sm),1)];
//  bigVector=[bigVector;mati(:)];        
end

function [bigVector]=splist2vec(li)
//li=list(X1,...Xk) is a list of matrices
//bigVector: sparse vector [X1(:);...;Xk(:)] (stacking of matrices in li)
bigVector=[];
li=aplat(li)
for mati=li
  sm=size(mati);
  bigVector=[bigVector;sparse(matrix(full(mati),prod(sm),1))];
end

function [A,b]=spaff2Ab(lme,dimX,D,ind)
//Y,X,D are lists of matrices. 
//Y=lme(X,D)= affine fct of Xi's; 
//[A,b]=matrix representation of lme in canonical basis.
[LHS,RHS]=argn(0)
select RHS
case 3 then
nvars=0;
for k=dimX'
   nvars=nvars+prod(k);
end
x0=zeros(nvars,1);
b=list2vec(lme(vec2list(x0,dimX),D));
A=[];
for k=1:nvars
xi=x0;xi(k)=1;
// A=[A,list2vec(lme(vec2list(xi,dimX),D))-b];
   A=[A,sparse(list2vec(lme(vec2list(xi,dimX),D))-b)];
end

case 4 then
nvars=0;
for k=dimX'
   nvars=nvars+prod(k);
end
x0=zeros(nvars,1);
b=list2vec(lme(vec2list(x0,dimX,ind),D));
A=[];
for k=1:nvars
xi=x0;xi(k)=1;
//  A=[A,list2vec(lme(vec2list(xi,dimX,ind),D))-b];
  A=[A,sparse(list2vec(lme(vec2list(xi,dimX,ind),D))-b)];
end
end



