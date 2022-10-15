function [s,errmsg] = mtlb_sprintf(fmt,varargin)
[lhs,rhs]=argn()
count=0
//count % in fmt
nfmt=size(strindex(fmt,'%'),'*')
nv=size(varargin)
if nv==1 then
  a=varargin(1)
  na=size(a,'*')
  mult=max(na/nfmt,1)
  fmt=strcat(fmt(ones(1,mult))) // duplicate format
  l=list()
  A=a
  for k=1:size(A,'*'),l(k)=A(k); end
  s=msprintf(fmt,l(:))
else
  sz=[]
  for k=1:nv
    sz=[sz size(varargin(k),1)]
  end
  if and(sz==1) then
    mult=max(nv/nfmt,1)
    fmt=strcat(fmt(ones(1,mult))) // duplicate format 
    s=msprintf(fmt,varargin(:))
  else
    error('mtlb_printf this particular case is not implemented')
  end
end
K=strindex(s,'\n')
if K<>[] then
  w=s
  s=[]
  if K(1)<>1 then K=[-1 K],end
  for k=2:size(K,'*')
    s=[s;part(w,K(k-1)+2:K(k)-1)]
  end
  if K($)<>length(w)-1 then
    s=[s;part(w,K($)+2:length(w))]
  end
end
