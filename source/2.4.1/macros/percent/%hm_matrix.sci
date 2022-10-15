function a=%hm_matrix(a,varargin)

if size(varargin)==1 then
  sz=varargin(1)
else
  sz=[]
  for k=1:size(varargin)
    if size(varargin(k),'*')<>1|type(varargin(k))<>1 then
      error('Size arguments must be integer scalars')
    end
    sz=[sz varargin(k)]
  end
  sz=round(sz)
end
if prod(a('dims'))<>prod(sz) then
  error('MATRIX: input and output matrices  must have the same number of elements')
end
a('dims')=sz(:)
