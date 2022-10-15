function mat=excel2sci(fname,sep)
// Given an ascii  file created by Excel using "Text and comma" format
// exel2sci(fname) returns the corresponding Scilab matrix of strings.
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs<2 then sep=',',end

v=read(fname,-1,1,'(a)')
n=size(v,1)
mat=[]
for i=1:n
  line=v(i,:)
  ki=1
  row=[]
  ln=length(line)
  for k=1:ln
    if part(line,k)==sep then
      if k==ki then 
	row=[row,emptystr()]
      else
	row=[row,part(line,ki:k-1)]
      end
      ki=k+1
    end
  end
  k=ln
  if k==ki then 
    row=[row,emptystr()]
  else
    row=[row,part(line,ki:k-1)]
  end
  mat=[mat;row]
end

