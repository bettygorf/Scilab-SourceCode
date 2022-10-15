function d=g_diag(a,k)
// g_diag - implement diag function for sparse matrix, rational matrix ,..
[lhs,rhs]=argn(0)
if rhs==1 then k=0,end
select type(a)
case 1 then
  d=diag(a,k)
case 2 then
  d=diag(a,k)
case 4 then
  [m,n]=size(a)
  if m>1&n>1 then
    if k<=0 then
      mn=mini(m+k,n)
      i0=-k+1
    else
      mn=min(m,n-k)
      i0=k*m+1
    end
    a=matrix(a,m*n,1)
    i=i0+((0:mn-1)*(m+1))
    d=a(i)
  else
    nn = max(m,n)+abs(k)
    mn=max(m,n)
    i=(1:mn)+((1:mn)+(k-1))*nn
    d(i)=a
    d=matrix(d,nn,nn)
  end
case 5 then
  [ij,v,sz]=spget(a)
  m=sz(1);n=sz(2)
  if m>1&n>1 then
    l=find(ij(:,1)==(ij(:,2)-k))
    if k<=0 then
      mn=mini(m+k,n)
      i0=-k
    else
      mn=min(m,n-k)
      i0=0
    end
    kk=abs(k)
    if l==[] then d=sparse([],[],[mn,1]);return;end
    d=sparse([ij(l,1)-i0,ones(ij(l,1))],v(l),[mn,1])
  else
    nn = max(m,n)+abs(k)
    if ij==[] then 
      d=sparse([],[],[nn,nn])
    else
      d=sparse([ij(:,1),ij(:,1)+k],v,[nn,nn])
    end
  end
case 6 then
  [ij,v,sz]=spget(a)
  m=sz(1);n=sz(2)
  if m>1&n>1 then
    l=find(ij(:,1)==(ij(:,2)-k))
    if k<=0 then
      mn=mini(m,n-k)
    else
      mn=min(m+k,n)
    end
    kk=abs(k)
    d=sparse([ij(l,1),ones(ij(l,1))],v(l),[mn,1])
  else
    nn = max(m,n)+abs(k)
    if ij==[] then 
      d=sparse([],[],[nn,nn])
    else
      d=sparse([ij(:,1),ij(:,1)+k],v,[nn,nn])
    end
  end
  
//-compat next case retained for list/tlist compatibility
case 15 then
  a1=a(1);
  if a1(1)=='r' then
    d=a;
    d=syslin(a(4),diag(a(2),k),diag(a(3),k))
  end
case 16 then
  a1=a(1);
  if a1(1)=='r' then
    d=a;
    d=syslin(a(4),diag(a(2),k),diag(a(3),k))
  end  
end
