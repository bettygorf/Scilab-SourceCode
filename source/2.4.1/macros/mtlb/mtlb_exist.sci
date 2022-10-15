function r=mtlb_exist(nam)
// Copyright INRIA
fptr=funptr(nam)
if fptr<>0 then 
  fptr=int(fptr/100)
  if fptr<=500 then
    r=5
  else
    r=3
  end
elseif exists(nam)==1 then
  if type(nam)==11|type(nam)==13 then
    r=2
  else
    r=1
  end
end
