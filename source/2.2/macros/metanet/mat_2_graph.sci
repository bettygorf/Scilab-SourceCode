function [g]=mat_2_graph(a,directed)
[lhs,rhs]=argn(0)
if rhs<>2 then error(39), end
// directed
if directed<>1&directed<>0 then
  error('mat_2_graph: ""directed"" must be 0 or 1')
end
// a
if type(a)<>5 then
  error('mat_2_graph: matrix must be sparse')
end

[ij,v,mn]=spget(a);
n=mn(1)
m=mn(2)

if prod(size(v))<>2*m then
  error('mat_2_graph: matrix has wrong number of elements')
end

if directed==1 then

  if norm(ones(1,n)*a)<>0 then
    error('mat_2_graph: matrix is not an incidence matrix')
  end

  itab=find(v=1)
  jtab=find(v=-1)

  if prod(size(itab))<>prod(size(jtab)) then
    error('mat_2_graph: matrix is not an incidence matrix')  
  end

  he=ij(itab,:); ta=ij(jtab,:)
  [s,k]=sort(he(:,2)); he=he(k,:); he=he(:,1)
  ma=prod(size(k)); he=he(ma:-1:1)
  [s,k]=sort(ta(:,2)); ta=ta(k,:); ta=ta(:,1)
  ma=prod(size(k)); ta=ta(ma:-1:1)
  g=make_graph('foo',1,n,he',ta')

else
  
  oa=ones(1,n)*a
  if max(oa)>2|min(oa)<2 then
    error('mat_2_graph: matrix is not an incidence matrix')    
  end
  
  [ijp,vp,mnp]=spget(a');
  s=size(ijp)
  he=ijp(2:2:s(1),2)
  ta=ijp(1:2:s(1),2)
  g=make_graph('foo',0,n,he',ta')
  
end
